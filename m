From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 1/2] cxlflash: Base superpipe support
Date: Fri, 19 Jun 2015 17:37:53 -0500
Message-ID: <1434753473-6218-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:59597 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbbFSWjr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 18:39:47 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 19 Jun 2015 16:39:47 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id CA8E819D803E
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2015 16:30:45 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t5JMdOKX45154350
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2015 15:39:24 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t5JMdiQk012038
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2015 16:39:45 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Add superpipe supporting infrastructure to device driver for the IBM CXL
Flash adapter. This patch allows userspace applications to take advantage
of the accelerated I/O features that this adapter provides and bypass the
traditional filesystem stack.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 Documentation/powerpc/cxlflash.txt |  298 ++++++
 drivers/scsi/cxlflash/Makefile     |    2 +-
 drivers/scsi/cxlflash/common.h     |   18 +
 drivers/scsi/cxlflash/main.c       |   12 +
 drivers/scsi/cxlflash/superpipe.c  | 1856 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/superpipe.h  |  210 ++++
 include/uapi/scsi/cxlflash_ioctl.h |  159 +++
 7 files changed, 2554 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/powerpc/cxlflash.txt
 create mode 100644 drivers/scsi/cxlflash/superpipe.c
 create mode 100644 drivers/scsi/cxlflash/superpipe.h
 create mode 100644 include/uapi/scsi/cxlflash_ioctl.h

diff --git a/Documentation/powerpc/cxlflash.txt b/Documentation/powerpc/cxlflash.txt
new file mode 100644
index 0000000..c4d3849
--- /dev/null
+++ b/Documentation/powerpc/cxlflash.txt
@@ -0,0 +1,298 @@
+Introduction
+============
+
+    The IBM Power architecture provides support for CAPI (Coherent
+    Accelerator Power Interface), which is available to certain PCIe slots
+    on Power 8 systems. CAPI can be thought of as a special tunneling
+    protocol through PCIe that allow PCIe adapters to look like special
+    purpose co-processors which can read or write an application's
+    memory and generate page faults. As a result, the host interface to
+    an adapter running in CAPI mode does not require the data buffers to
+    be mapped to the device's memory (IOMMU bypass) nor does it require
+    memory to be pinned.
+
+    On Linux, Coherent Accelerator (CXL) kernel services present CAPI
+    devices as a PCI device by implementing a virtual PCI host bridge.
+    This abstraction simplifies the infrastructure and programming
+    model, allowing for drivers to look similar to other native PCI
+    device drivers.
+
+    CXL provides a mechanism by which user space applications can
+    directly talk to a device (network or storage) bypassing the typical
+    kernel/device driver stack. The CXL Flash Adapter Driver enables a
+    user space application direct access to Flash storage.
+
+    The CXL Flash Adapter Driver is a kernel module that sits in the
+    SCSI stack as a low level device driver (below the SCSI disk and
+    protocol drivers) for the IBM CXL Flash Adapter. This driver is
+    responsible for the initialization of the adapter, setting up the
+    special path for user space access, and performing error recovery. It
+    communicates directly the Flash Accelerator Functional Unit (AFU)
+    as described in Documentation/powerpc/cxl.txt.
+
+    The cxlflash driver supports two, mutually exclusive, modes of
+    operation at the device (LUN) level:
+
+        - Any flash device (LUN) can be configured to be accessed as a
+          regular disk device (i.e.: /dev/sdc). This is the default mode.
+
+        - Any flash device (LUN) can be configured to be accessed from
+          user space with a special block library. This mode further
+          specifies the means of accessing the device and provides for
+          either raw access to the entire LUN (referred to as direct
+          or physical LUN access) or access to a kernel/AFU-mediated
+          partition of the LUN (referred to as virtual LUN access). The
+          segmentation of a disk device into virtual LUNs is assisted
+          by special translation services provided by the Flash AFU.
+
+Overview
+========
+
+    The Coherent Accelerator Interface Architecture (CAIA) introduces a
+    concept of a master context. A master typically has special privileges
+    granted to it by the kernel or hypervisor allowing it to perform AFU
+    wide management and control. The master may or may not be involved
+    directly in each user I/O, but at the minimum is involved in the
+    initial setup before the user application is allowed to send requests
+    directly to the AFU.
+
+    The CXL Flash Adapter Driver establishes a master context with the
+    AFU. It uses memory mapped I/O (MMIO) for this control and setup. The
+    Adapter Problem Space Memory Map looks like this:
+
+                     +-------------------------------+
+                     |    512 * 64 KB User MMIO      |
+                     |        (per context)          |
+                     |       User Accessible         |
+                     +-------------------------------+
+                     |    512 * 128 B per context    |
+                     |    Provisioning and Control   |
+                     |   Trusted Process accessible  |
+                     +-------------------------------+
+                     |         64 KB Global          |
+                     |   Trusted Process accessible  |
+                     +-------------------------------+
+
+    This driver configures itself into the SCSI software stack as an
+    adapter driver. The driver is the only entity that is considered a
+    Trusted Process to program the Provisioning and Control and Global
+    areas in the MMIO Space shown above.  The master context driver
+    discovers all LUNs attached to the CXL Flash adapter and instantiates
+    scsi block devices (/dev/sdb, /dev/sdc etc.) for each unique LUN
+    seen from each path.
+
+    Once these scsi block devices are instantiated, an application
+    written to a specification provided by the block library may get
+    access to the Flash from user space (without requiring a system call).
+
+    This master context driver also provides a series of ioctls for this
+    block library to enable this user space access.  The driver supports
+    two modes for accessing the block device.
+
+    The first mode is called a virtual mode. In this mode a single scsi
+    block device (/dev/sdb) may be carved up into any number of distinct
+    virtual LUNs. The virtual LUNs may be resized as long as the sum of
+    the sizes of all the virtual LUNs, along with the meta-data associated
+    with it does not exceed the physical capacity.
+
+    The second mode is called the physical mode. In this mode a single
+    block device (/dev/sdb) may be opened directly by the block library
+    and the entire space for the LUN is available to the application.
+
+    Only the physical mode provides persistence of the data.  i.e. The
+    data written to the block device will survive application exit and
+    restart and also reboot. The virtual LUNs do not persist (i.e. do
+    not survive after the application terminates or the system reboots).
+
+
+Block library API
+=================
+
+    Applications intending to get access to the CXL Flash from user
+    space should use the block library, as it abstracts the details of
+    interfacing directly with the cxlflash driver that are necessary for
+    performing administrative actions (i.e.: setup, tear down, resize).
+    The block library can be thought of as a 'user' of services,
+    implemented as IOCTLs, that are provided by the cxlflash driver
+    specifically for devices (LUNs) operating in user space access
+    mode. While it is not a requirement that applications understand
+    the interface between the block library and the cxlflash driver,
+    a high-level overview of each supported service (IOCTL) is provided
+    below.
+
+    The block library can be found on GitHub:
+    http://www.github.com/mikehollinger/ibmcapikv
+
+
+CXL Flash Driver IOCTLs
+=======================
+
+    Users, such as the block library, that wish to interface with a flash
+    device (LUN) via user space access need to use the services provided
+    by the cxlflash driver. As these services are implemented as ioctls,
+    a file descriptor handle must first be obtained in order to establish
+    the communication channel between a user and the kernel.  This file
+    descriptor is obtained by opening the device special file associated
+    with the scsi disk device (/dev/sdb) that was created during LUN
+    discovery. As per the location of the cxlflash driver within the
+    SCSI protocol stack, this open is actually not seen by the cxlflash
+    driver. Upon successful open, the user receives a file descriptor
+    (herein referred to as fd1) that should be used for issuing the
+    subsequent ioctls listed below.
+
+    The structure definitions for these IOCTLs are available in:
+    uapi/scsi/cxlflash_ioctl.h
+
+DK_CXLFLASH_ATTACH
+------------------
+
+    This ioctl obtains, initializes, and starts a context using the CXL
+    kernel services. These services specify a context id (u16) by which
+    to uniquely identify the context and its allocated resources. The
+    services additionally provide a second file descriptor (herein
+    referred to as fd2) that is used by the block library to initiate
+    memory mapped I/O (via mmap()) to the CXL flash device and poll for
+    completion events. This file descriptor is intentionally installed by
+    this driver and not the CXL kernel services to allow for intermediary
+    notification and access in the event of a non-user-initiated close(),
+    such as a killed process. This design point is described in further
+    detail in the description for the DK_CXLFLASH_DETACH ioctl.
+
+    There are a few important aspects regarding the "tokens" (context id
+    and fd2) that are provided back to the user:
+
+        - These tokens are only valid for the process under which they
+          were created. The child of a forked process cannot continue
+          to use the context id or file descriptor created by its parent
+          (see DK_CXLFLASH_CLONE for further details).
+
+        - These tokens are only valid for the lifetime of the context and
+          the process under which they were created. Once either is
+          destroyed, the tokens are to be considered stale and subsequent
+          usage will result in errors.
+
+        - When a context is no longer needed, the user shall detach from
+          the context via the DK_CXLFLASH_DETACH ioctl.
+
+        - A close on fd2 will invalidate the tokens. This operation is not
+          required by the user.
+
+DK_CXLFLASH_USER_DIRECT
+-----------------------
+    This ioctl is responsible for transitioning the LUN to direct
+    (physical) mode access and configuring the AFU for direct access from
+    user space on a per-context basis. Additionally, the block size and
+    last logical block address (LBA) are returned to the user.
+
+    As mentioned previously, when operating in user space access mode,
+    LUNs may be accessed in whole or in part. Only one mode is allowed
+    at a time and if one mode is active (outstanding references exist),
+    requests to use the LUN in a different mode are denied.
+
+    The AFU is configured for direct access from user space by adding an
+    entry to the AFU's resource handle table. The index of the entry is
+    treated as a resource handle that is returned to the user. The user
+    is then able to use the handle to reference the LUN during I/O.
+
+DK_CXLFLASH_USER_VIRTUAL
+------------------------
+    This ioctl is responsible for transitioning the LUN to virtual mode
+    of access and configuring the AFU for virtual access from user space
+    on a per-context basis. Additionally, the block size and last logical
+    block address (LBA) are returned to the user.
+
+    As mentioned previously, when operating in user space access mode,
+    LUNs may be accessed in whole or in part. Only one mode is allowed
+    at a time and if one mode is active (outstanding references exist),
+    requests to use the LUN in a different mode are denied.
+
+    The AFU is configured for virtual access from user space by adding
+    an entry to the AFU's resource handle table. The index of the entry
+    is treated as a resource handle that is returned to the user. The
+    user is then able to use the handle to reference the LUN during I/O.
+
+    By default, the virtual LUN is created with a size of 0. The user
+    would need to use the DK_CXLFLASH_VLUN_RESIZE ioctl to adjust the grow
+    the virtual LUN to a desired size. To avoid having to perform this
+    resize for the initial creation of the virtual LUN, the user has the
+    option of specifying a size as part of the DK_CXLFLASH_USER_VIRTUAL
+    ioctl, such that when success is returned to the user, the
+    resource handle that is provided is already referencing provisioned
+    storage. This is reflected by the last LBA being a non-zero value.
+
+DK_CXLFLASH_VLUN_RESIZE
+-----------------------
+    This ioctl is responsible for resizing a previously created virtual
+    LUN and will fail if invoked upon a LUN that is not in virtual
+    mode. Upon success, an updated last LBA is returned to the user
+    indicating the new size of the virtual LUN associated with the
+    resource handle.
+
+    The partitioning of virtual LUNs is jointly mediated by the cxlflash
+    driver and the AFU. An allocation table is kept for each LUN that is
+    operating in the virtual mode and used to program a LUN translation
+    table that the AFU references when provided with a resource handle.
+
+DK_CXLFLASH_RELEASE
+-------------------
+    This ioctl is responsible for releasing a previously obtained
+    reference to either a physical or virtual LUN. This can be
+    thought of as the inverse of the DK_CXLFLASH_USER_DIRECT or
+    DK_CXLFLASH_USER_VIRTUAL ioctls. Upon success, the resource handle
+    is no longer valid and the entry in the resource handle table is
+    made available to be used again.
+
+    As part of the release process for virtual LUNs, the virtual LUN
+    is first resized to 0 to clear out and free the translation tables
+    associated with the virtual LUN reference.
+
+DK_CXLFLASH_DETACH
+------------------
+    This ioctl is responsible for unregistering a context with the
+    cxlflash driver and release outstanding resources that were
+    not explicitly released via the DK_CXLFLASH_RELEASE ioctl. Upon
+    success, all "tokens" which had been provided to the user from the
+    DK_CXLFLASH_ATTACH onward are no longer valid.
+
+DK_CXLFLASH_CLONE
+-----------------
+    This ioctl is responsible for cloning a previously created
+    context to a more recently created context. It exists solely to
+    support maintaining user space access to storage after a process
+    forks. Upon success, the child process (which invoked the ioctl)
+    will have access to the same LUNs via the same resource handle(s)
+    and fd2 as the parent, but under a different context.
+
+    Context sharing across processes is not supported with CXL and
+    therefore each fork must be met with establishing a new context
+    for the child process. This ioctl simplifies the state management
+    and playback required by a user in such a scenario. When a process
+    forks, child process can clone the parents context by first creating
+    a context (via DK_CXLFLASH_ATTACH) and then using this ioctl to
+    perform the clone from the parent to the child.
+
+    The clone itself is fairly simple. The resource handle and lun
+    translation tables are copied from the parent context to the child's
+    and then synced with the AFU.
+
+DK_CXLFLASH_VERIFY
+------------------
+    The DK_CXLFLASH_VERIFY ioctl is used to detect various changes such
+    as the capacity of the disk changing, the number of LUNs visible
+    changing, etc. In cases where the changes affect the application
+    (such as a LUN resize), the cxlflash driver will report the changed
+    state to the application.
+
+DK_CXLFLASH_RECOVER_AFU
+-----------------------
+    This ioctl is used to drive recovery (if such an action is warranted)
+    by resetting the adapter. Any state associated with all the open
+    contexts, will be re-established.
+
+DK_CXLFLASH_MANAGE_LUN
+----------------------
+    This ioctl is used to switch a LUN from a mode where it is available
+    for file-system access (legacy), to a mode where it is set aside for
+    exclusive user space access (superpipe). In case a LUN is visible
+    across multiple ports and adapters, this ioctl is used to uniquely
+    identify each LUN by its World Wide Node Name (WWNN).
diff --git a/drivers/scsi/cxlflash/Makefile b/drivers/scsi/cxlflash/Makefile
index dc95e20..3de309c 100644
--- a/drivers/scsi/cxlflash/Makefile
+++ b/drivers/scsi/cxlflash/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_CXLFLASH) += cxlflash.o
-cxlflash-y += main.o
+cxlflash-y += main.o superpipe.o
diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index fe86bfe..9cf9fa3 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -103,6 +103,14 @@ struct cxlflash_cfg {
 	struct pci_pool *cxlflash_cmd_pool;
 	struct pci_dev *parent_dev;
 
+	spinlock_t ctx_tbl_slock;
+	struct ctx_info *ctx_tbl[MAX_CONTEXT];
+	struct list_head ctx_err_recovery; /* contexts w/ recovery pending */
+	struct file_operations cxl_fops;
+
+	int num_user_contexts;
+	int last_lun_index[CXLFLASH_NUM_FC_PORTS];
+
 	wait_queue_head_t tmf_waitq;
 	bool tmf_active;
 	u8 err_recovery_active:1;
@@ -177,5 +185,15 @@ int cxlflash_afu_reset(struct cxlflash_cfg *);
 struct afu_cmd *cxlflash_cmd_checkout(struct afu *);
 void cxlflash_cmd_checkin(struct afu_cmd *);
 int cxlflash_afu_sync(struct afu *, ctx_hndl_t, res_hndl_t, u8);
+int cxlflash_alloc_lun(struct scsi_device *);
+void cxlflash_init_lun(struct scsi_device *);
+void cxlflash_list_init(void);
+void cxlflash_list_terminate(void);
+int cxlflash_slave_alloc(struct scsi_device *);
+int cxlflash_slave_configure(struct scsi_device *);
+void cxlflash_slave_destroy(struct scsi_device *);
+int cxlflash_ioctl(struct scsi_device *, int, void __user *);
+int cxlflash_mark_contexts_error(struct cxlflash_cfg *);
+
 #endif /* ifndef _CXLFLASH_COMMON_H */
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 76a7286..2773177 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -679,10 +679,13 @@ static struct scsi_host_template driver_template = {
 	.module = THIS_MODULE,
 	.name = CXLFLASH_ADAPTER_NAME,
 	.info = cxlflash_driver_info,
+	.ioctl = cxlflash_ioctl,
 	.proc_name = CXLFLASH_NAME,
 	.queuecommand = cxlflash_queuecommand,
 	.eh_device_reset_handler = cxlflash_eh_device_reset_handler,
 	.eh_host_reset_handler = cxlflash_eh_host_reset_handler,
+	.slave_alloc = cxlflash_slave_alloc,
+	.slave_configure = cxlflash_slave_configure,
 	.change_queue_depth = cxlflash_change_queue_depth,
 	.cmd_per_lun = 16,
 	.can_queue = CXLFLASH_MAX_CMDS,
@@ -2198,9 +2201,12 @@ static int cxlflash_probe(struct pci_dev *pdev,
 
 	cfg->init_state = INIT_STATE_NONE;
 	cfg->dev = pdev;
+	cfg->last_lun_index[0] = 0;
+	cfg->last_lun_index[1] = 0;
 	cfg->dev_id = (struct pci_device_id *)dev_id;
 	cfg->mcctx = NULL;
 	cfg->err_recovery_active = 0;
+	cfg->num_user_contexts = 0;
 
 	init_waitqueue_head(&cfg->tmf_waitq);
 	init_waitqueue_head(&cfg->eeh_waitq);
@@ -2208,6 +2214,8 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	INIT_WORK(&cfg->work_q, cxlflash_worker_thread);
 	cfg->lr_state = LINK_RESET_INVALID;
 	cfg->lr_port = -1;
+	spin_lock_init(&cfg->ctx_tbl_slock);
+	INIT_LIST_HEAD(&cfg->ctx_err_recovery);
 
 	pci_set_drvdata(pdev, cfg);
 
@@ -2279,6 +2287,8 @@ static int __init init_cxlflash(void)
 	pr_info("%s: IBM Power CXL Flash Adapter: %s\n",
 		__func__, CXLFLASH_DRIVER_DATE);
 
+	cxlflash_list_init();
+
 	return pci_register_driver(&cxlflash_driver);
 }
 
@@ -2287,6 +2297,8 @@ static int __init init_cxlflash(void)
  */
 static void __exit exit_cxlflash(void)
 {
+	cxlflash_list_terminate();
+
 	pci_unregister_driver(&cxlflash_driver);
 }
 
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
new file mode 100644
index 0000000..4ea6c72
--- /dev/null
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -0,0 +1,1856 @@
+/*
+ * CXL Flash Device Driver
+ *
+ * Written by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>, IBM Corporation
+ *             Matthew R. Ochs <mrochs@linux.vnet.ibm.com>, IBM Corporation
+ *
+ * Copyright (C) 2015 IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/delay.h>
+#include <linux/file.h>
+#include <linux/moduleparam.h>
+#include <linux/syscalls.h>
+#include <misc/cxl.h>
+#include <asm/unaligned.h>
+
+#include <scsi/scsi_host.h>
+#include <uapi/scsi/cxlflash_ioctl.h>
+
+#include "sislite.h"
+#include "common.h"
+#include "superpipe.h"
+
+struct cxlflash_global global;
+
+/**
+ * marshall_det_to_rele() - translate detach to release structure
+ * @detach:	Destination structure for the translate/copy.
+ * @rele:	Source structure from which to translate/copy.
+ */
+static void marshall_det_to_rele(struct dk_cxlflash_detach *detach,
+				 struct dk_cxlflash_release *release)
+{
+	release->hdr = detach->hdr;
+	release->context_id = detach->context_id;
+}
+
+/**
+ * create_lun_info() - allocate and initialize a LUN information structure
+ * @sdev:	SCSI device associated with LUN.
+ *
+ * Return: Allocated lun_info structure on success, NULL on failure
+ */
+static struct lun_info *create_lun_info(struct scsi_device *sdev)
+{
+	struct lun_info *lun_info = NULL;
+
+	lun_info = kzalloc(sizeof(*lun_info), GFP_KERNEL);
+	if (unlikely(!lun_info)) {
+		pr_err("%s: could not allocate lun_info\n", __func__);
+		goto create_lun_info_exit;
+	}
+
+	lun_info->sdev = sdev;
+
+	spin_lock_init(&lun_info->slock);
+
+create_lun_info_exit:
+	return lun_info;
+}
+
+/**
+ * lookup_lun() - find or create a LUN information structure
+ * @sdev:	SCSI device associated with LUN.
+ * @wwid:	WWID associated with LUN.
+ *
+ * Return: Found/Allocated lun_info structure on success, NULL on failure
+ */
+static struct lun_info *lookup_lun(struct scsi_device *sdev, __u8 *wwid)
+{
+	struct lun_info *lun_info, *temp;
+	ulong flags = 0UL;
+
+	if (wwid)
+		list_for_each_entry_safe(lun_info, temp, &global.luns, list) {
+			if (!memcmp(lun_info->wwid, wwid,
+				    DK_CXLFLASH_MANAGE_LUN_WWID_LEN))
+				return lun_info;
+		}
+
+	lun_info = create_lun_info(sdev);
+	if (unlikely(!lun_info))
+		goto out;
+
+	spin_lock_irqsave(&global.slock, flags);
+	if (wwid)
+		memcpy(lun_info->wwid, wwid, DK_CXLFLASH_MANAGE_LUN_WWID_LEN);
+	list_add(&lun_info->list, &global.luns);
+	spin_unlock_irqrestore(&global.slock, flags);
+
+out:
+	pr_debug("%s: returning %p\n", __func__, lun_info);
+	return lun_info;
+}
+
+/**
+ * cxlflash_slave_alloc() - allocate and associate LUN information structure
+ * @sdev:	SCSI device associated with LUN.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int cxlflash_slave_alloc(struct scsi_device *sdev)
+{
+	int rc = 0;
+	struct lun_info *lun_info = NULL;
+
+	lun_info = lookup_lun(sdev, NULL);
+	if (unlikely(!lun_info)) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	sdev->hostdata = lun_info;
+
+out:
+	pr_debug("%s: returning sdev %p rc=%d\n", __func__, sdev, rc);
+	return rc;
+}
+
+/**
+ * cxlflash_slave_configure() - configure and make device aware of LUN
+ * @sdev:	SCSI device associated with LUN.
+ *
+ * Stores the LUN id and lun_index and programs the AFU's LUN mapping table.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int cxlflash_slave_configure(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct lun_info *lun_info = sdev->hostdata;
+	struct cxlflash_cfg *cfg = shost_priv(shost);
+	struct afu *afu = cfg->afu;
+
+	pr_debug("%s: id = %d/%d/%d/%llu\n", __func__, shost->host_no,
+		 sdev->channel, sdev->id, sdev->lun);
+
+	/* Store off lun in unpacked, AFU-friendly format */
+	lun_info->lun_id = lun_to_lunid(sdev->lun);
+	lun_info->lun_index = cfg->last_lun_index[sdev->channel];
+
+	writeq_be(lun_info->lun_id,
+		  &afu->afu_map->global.fc_port[sdev->channel]
+		  [cfg->last_lun_index[sdev->channel]++]);
+
+	return 0;
+}
+
+/**
+ * cxlflash_list_init() - initializes the global LUN list
+ */
+void cxlflash_list_init(void)
+{
+	INIT_LIST_HEAD(&global.luns);
+	spin_lock_init(&global.slock);
+	global.err_page = NULL;
+}
+
+/**
+ * cxlflash_list_terminate() - frees resources associated with global LUN list
+ */
+void cxlflash_list_terminate(void)
+{
+	struct lun_info *lun_info, *temp;
+	ulong flags = 0;
+
+	spin_lock_irqsave(&global.slock, flags);
+	list_for_each_entry_safe(lun_info, temp, &global.luns, list) {
+		list_del(&lun_info->list);
+		kfree(lun_info);
+	}
+
+	if (global.err_page) {
+		__free_page(global.err_page);
+		global.err_page = NULL;
+	}
+	spin_unlock_irqrestore(&global.slock, flags);
+}
+
+/**
+ * find_error_context() - locates a context by cookie on the error recovery list
+ * @cfg:	Internal structure associated with the host.
+ * @ctxid:	Desired context.
+ *
+ * Return: Found context on success, NULL on failure
+ */
+static struct ctx_info *find_error_context(struct cxlflash_cfg *cfg, u64 ctxid)
+{
+	struct ctx_info *ctx_info;
+
+	list_for_each_entry(ctx_info, &cfg->ctx_err_recovery, list)
+		if (ctx_info->ctxid == ctxid)
+			return ctx_info;
+
+	return NULL;
+}
+
+/**
+ * get_context() - obtains a validated context reference
+ * @cfg:	Internal structure associated with the host.
+ * @ctxid:	Desired context.
+ * @lun_info:	LUN associated with request.
+ * @ctx_ctrl:	Control information to 'steer' desired lookup.
+ *
+ * NOTE: despite the name pid, in linux, current->pid actually refers
+ * to the lightweight process id (tid) and can change if the process is
+ * multi threaded. The tgid remains constant for the process and only changes
+ * when the process of fork. For all intents and purposes, think of tgid
+ * as a pid in the traditional sense.
+ *
+ * Return: Validated context on success, NULL on failure
+ */
+struct ctx_info *get_context(struct cxlflash_cfg *cfg, u64 ctxid,
+			     struct lun_info *lun_info, enum ctx_ctrl ctx_ctrl)
+{
+	struct ctx_info *ctx_info = NULL;
+	struct lun_access *lun_access = NULL;
+	bool found = false;
+	pid_t pid = current->tgid, ctxpid = 0;
+	ulong flags = 0;
+
+	if (unlikely(ctx_ctrl & CTX_CTRL_CLONE))
+		pid = current->parent->tgid;
+
+	if (likely(ctxid < MAX_CONTEXT)) {
+		spin_lock_irqsave(&cfg->ctx_tbl_slock, flags);
+		ctx_info = cfg->ctx_tbl[ctxid];
+
+		if (unlikely(ctx_ctrl & CTX_CTRL_ERR))
+			ctx_info = find_error_context(cfg, ctxid);
+		if (unlikely(!ctx_info)) {
+			if (ctx_ctrl & CTX_CTRL_ERR_FALLBACK) {
+				ctx_info = find_error_context(cfg, ctxid);
+				if (ctx_info)
+					goto found_context;
+			}
+			spin_unlock_irqrestore(&cfg->ctx_tbl_slock, flags);
+			goto out;
+		}
+found_context:
+		/*
+		 * Increment the reference count under lock so the context
+		 * is not yanked from under us on a removal thread.
+		 */
+		atomic_inc(&ctx_info->nrefs);
+		spin_unlock_irqrestore(&cfg->ctx_tbl_slock, flags);
+
+		ctxpid = ctx_info->pid;
+		if (likely(!(ctx_ctrl & CTX_CTRL_NOPID)))
+			if (pid != ctxpid)
+				goto denied;
+
+		if (likely(lun_info)) {
+			list_for_each_entry(lun_access, &ctx_info->luns, list)
+				if (lun_access->lun_info == lun_info) {
+					found = true;
+					break;
+				}
+
+			if (!found)
+				goto denied;
+		}
+	}
+
+out:
+	pr_debug("%s: ctxid=%llu ctxinfo=%p ctxpid=%u pid=%u ctx_ctrl=%u "
+		 "found=%d\n", __func__, ctxid, ctx_info, ctxpid, pid,
+		 ctx_ctrl, found);
+
+	return ctx_info;
+
+denied:
+	atomic_dec(&ctx_info->nrefs);
+	ctx_info = NULL;
+	goto out;
+}
+
+/**
+ * afu_attach() - attach a context to the AFU
+ * @cfg:	Internal structure associated with the host.
+ * @ctx_info:	Context to attach.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int afu_attach(struct cxlflash_cfg *cfg, struct ctx_info *ctx_info)
+{
+	struct afu *afu = cfg->afu;
+	int rc = 0;
+	u64 reg;
+
+	/* Restrict user to read/write cmds in translated mode */
+	(void)readq_be(&ctx_info->ctrl_map->mbox_r);	/* unlock ctx_cap */
+	writeq_be((SISL_CTX_CAP_READ_CMD | SISL_CTX_CAP_WRITE_CMD),
+		  &ctx_info->ctrl_map->ctx_cap);
+
+	reg = readq_be(&ctx_info->ctrl_map->ctx_cap);
+
+	/* if the write failed, the ctx must have been
+	 * closed since the mbox read and the ctx_cap
+	 * register locked up. Fail the registration.
+	 */
+	if (reg != (SISL_CTX_CAP_READ_CMD | SISL_CTX_CAP_WRITE_CMD)) {
+		pr_err("%s: ctx may be closed reg=%llx\n", __func__, reg);
+		rc = -EAGAIN;
+		goto out;
+	}
+
+	/* set up MMIO registers pointing to the RHT */
+	writeq_be((u64)ctx_info->rht_start, &ctx_info->ctrl_map->rht_start);
+	writeq_be(SISL_RHT_CNT_ID((u64)MAX_RHT_PER_CONTEXT,
+				  (u64)(afu->ctx_hndl)),
+		  &ctx_info->ctrl_map->rht_cnt_id);
+out:
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+
+}
+
+/**
+ * cxlflash_check_status() - evaluates the status of an AFU command
+ * @ioasa:	The IOASA of an AFU command.
+ *
+ * Return: 1 when IOASA has error, 0 when IOASA does not have an error
+ */
+int cxlflash_check_status(struct afu_cmd *cmd)
+{
+	struct sisl_ioasa *ioasa = &cmd->sa;
+	ulong lock_flags;
+
+	/* not retrying afu timeouts (B_TIMEOUT) */
+	/* returns 1 if the cmd should be retried, 0 otherwise */
+	/* sets B_ERROR flag based on IOASA */
+
+	if (ioasa->ioasc == 0)
+		return 0;
+
+	spin_lock_irqsave(&cmd->slock, lock_flags);
+	ioasa->host_use_b[0] |= B_ERROR;
+	spin_unlock_irqrestore(&cmd->slock, lock_flags);
+
+	if (!(ioasa->host_use_b[1]++ < MC_RETRY_CNT))
+		return 0;
+
+	switch (ioasa->rc.afu_rc) {
+	case SISL_AFU_RC_NO_CHANNELS:
+	case SISL_AFU_RC_OUT_OF_DATA_BUFS:
+		msleep(20);
+		return 1;
+
+	case 0:
+		/* no afu_rc, but either scsi_rc and/or fc_rc is set */
+		/* retry all scsi_rc and fc_rc after a small delay */
+		msleep(20);
+		return 1;
+	}
+
+	return 0;
+}
+
+/**
+ * read_cap16() - issues a SCSI READ_CAP16 command
+ * @afu:	AFU associated with the host.
+ * @lun_info:	LUN to destined for capacity request.
+ * @port_sel:	Port to send request.
+ *
+ * Return: 0 on success, -1 on failure
+ */
+static int read_cap16(struct afu *afu, struct lun_info *lun_info, u32 port_sel)
+{
+	struct afu_cmd *cmd = NULL;
+	int rc = 0;
+
+	cmd = cxlflash_cmd_checkout(afu);
+	if (unlikely(!cmd)) {
+		pr_err("%s: could not get a free command\n", __func__);
+		return -1;
+	}
+
+	cmd->rcb.req_flags = (SISL_REQ_FLAGS_PORT_LUN_ID |
+			      SISL_REQ_FLAGS_SUP_UNDERRUN |
+			      SISL_REQ_FLAGS_HOST_READ);
+
+	cmd->rcb.port_sel = port_sel;
+	cmd->rcb.lun_id = lun_info->lun_id;
+	cmd->rcb.data_len = CMD_BUFSIZE;
+	cmd->rcb.data_ea = (u64) cmd->buf;
+	cmd->rcb.timeout = MC_DISCOVERY_TIMEOUT;
+
+	cmd->rcb.cdb[0] = 0x9E;	/* read cap(16) */
+	cmd->rcb.cdb[1] = 0x10;	/* service action */
+	put_unaligned_be32(CMD_BUFSIZE, &cmd->rcb.cdb[10]);
+
+	pr_debug("%s: sending cmd(0x%x) with RCB EA=%p data EA=0x%llx\n",
+		 __func__, cmd->rcb.cdb[0], &cmd->rcb, cmd->rcb.data_ea);
+
+	do {
+		rc = cxlflash_send_cmd(afu, cmd);
+		if (unlikely(rc))
+			goto out;
+		cxlflash_wait_resp(afu, cmd);
+	} while (cxlflash_check_status(cmd));
+
+	if (unlikely(cmd->sa.host_use_b[0] & B_ERROR)) {
+		pr_err("%s: command failed\n", __func__);
+		rc = -1;
+		goto out;
+	}
+
+	/*
+	 * Read cap was successful, grab values from the buffer;
+	 * note that we don't need to worry about unaligned access
+	 * as the buffer is allocated on an aligned boundary.
+	 */
+	spin_lock(&lun_info->slock);
+	lun_info->max_lba = swab64(*((u64 *)&cmd->buf[0]));
+	lun_info->blk_len = swab32(*((u32 *)&cmd->buf[8]));
+	spin_unlock(&lun_info->slock);
+
+out:
+	if (cmd)
+		cxlflash_cmd_checkin(cmd);
+	pr_debug("%s: maxlba=%lld blklen=%d pcmd %p\n",
+		 __func__, lun_info->max_lba, lun_info->blk_len, cmd);
+	return rc;
+}
+
+/**
+ * get_rhte() - obtains validated resource handle table entry reference
+ * @ctx_info:	Context owning the resource handle.
+ * @res_hndl:	Resource handle associated with entry.
+ * @lun_info:	LUN associated with request.
+ *
+ * Return: Validated RHTE on success, NULL on failure
+ */
+struct sisl_rht_entry *get_rhte(struct ctx_info *ctx_info, res_hndl_t res_hndl,
+				struct lun_info *lun_info)
+{
+	struct sisl_rht_entry *rhte = NULL;
+
+	if (unlikely(!ctx_info->rht_start)) {
+		pr_err("%s: Context does not have an allocated RHT!\n",
+		       __func__);
+		goto out;
+	}
+
+	if (unlikely(res_hndl >= MAX_RHT_PER_CONTEXT)) {
+		pr_err("%s: Invalid resource handle! (%d)\n",
+		       __func__, res_hndl);
+		goto out;
+	}
+
+	if (unlikely(ctx_info->rht_lun[res_hndl] != lun_info)) {
+		pr_err("%s: Resource handle invalid for LUN! (%d)\n",
+		       __func__, res_hndl);
+		goto out;
+	}
+
+	rhte = &ctx_info->rht_start[res_hndl];
+	if (unlikely(rhte->nmask == 0)) {
+		pr_err("%s: Unopened resource handle! (%d)\n",
+		       __func__, res_hndl);
+		rhte = NULL;
+		goto out;
+	}
+
+out:
+	return rhte;
+}
+
+/**
+ * rhte_checkout() - obtains free/empty resource handle table entry
+ * @ctx_info:	Context owning the resource handle.
+ * @lun_info:	LUN associated with request.
+ *
+ * Return: Free RHTE on success, NULL on failure
+ */
+struct sisl_rht_entry *rhte_checkout(struct ctx_info *ctx_info,
+				     struct lun_info *lun_info)
+{
+	struct sisl_rht_entry *rht_entry = NULL;
+	int i;
+
+	/* Find a free RHT entry */
+	for (i = 0; i < MAX_RHT_PER_CONTEXT; i++)
+		if (ctx_info->rht_start[i].nmask == 0) {
+			rht_entry = &ctx_info->rht_start[i];
+			ctx_info->rht_out++;
+			break;
+		}
+
+	if (likely(rht_entry))
+		ctx_info->rht_lun[i] = lun_info;
+
+	pr_debug("%s: returning rht_entry=%p (%d)\n", __func__, rht_entry, i);
+	return rht_entry;
+}
+
+/**
+ * rhte_checkin() - releases a resource handle table entry
+ * @ctx_info:	Context owning the resource handle.
+ * @rht_entry:	RHTE to release.
+ */
+void rhte_checkin(struct ctx_info *ctx_info,
+		  struct sisl_rht_entry *rht_entry)
+{
+	rht_entry->nmask = 0;
+	rht_entry->fp = 0;
+	ctx_info->rht_out--;
+	ctx_info->rht_lun[rht_entry - ctx_info->rht_start] = NULL;
+}
+
+/**
+ * rhte_format1() - populates a RHTE for format 1
+ * @rht_entry:	RHTE to populate.
+ * @lun_id:	LUN ID of LUN associated with RHTE.
+ * @perm:	Desired permissions for RHTE.
+ */
+static void rht_format1(struct sisl_rht_entry *rht_entry, u64 lun_id, u32 perm)
+{
+	/*
+	 * Populate the Format 1 RHT entry for direct access (physical
+	 * LUN) using the synchronization sequence defined in the
+	 * SISLite specification.
+	 */
+	struct sisl_rht_entry_f1 dummy = { 0 };
+	struct sisl_rht_entry_f1 *rht_entry_f1 =
+	    (struct sisl_rht_entry_f1 *)rht_entry;
+	memset(rht_entry_f1, 0, sizeof(struct sisl_rht_entry_f1));
+	rht_entry_f1->fp = SISL_RHT_FP(1U, 0);
+	smp_wmb(); /* Make setting of format bit visible */
+
+	rht_entry_f1->lun_id = lun_id;
+	smp_wmb(); /* Make setting of LUN id visible */
+
+	/*
+	 * Use a dummy RHT Format 1 entry to build the second dword
+	 * of the entry that must be populated in a single write when
+	 * enabled (valid bit set to TRUE).
+	 */
+	dummy.valid = 0x80;
+	dummy.fp = SISL_RHT_FP(1U, perm);
+	dummy.port_sel = BOTH_PORTS;
+	rht_entry_f1->dw = dummy.dw;
+
+	smp_wmb(); /* Make remaining RHT entry fields visible */
+}
+
+/**
+ * cxlflash_lun_attach() - attaches a user to a LUN and manages the LUN's mode
+ * @lun_info:	LUN to attach.
+ * @mode:	Desired mode of the LUN.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int cxlflash_lun_attach(struct lun_info *lun_info, enum lun_mode mode)
+{
+	int rc = 0;
+
+	spin_lock(&lun_info->slock);
+	if (lun_info->mode == MODE_NONE)
+		lun_info->mode = mode;
+	else if (lun_info->mode != mode) {
+		pr_err("%s: LUN operating in mode %d, requested mode %d\n",
+		       __func__, lun_info->mode, mode);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	lun_info->users++;
+	BUG_ON(lun_info->users <= 0);
+out:
+	pr_debug("%s: Returning rc=%d li_mode=%u li_users=%u\n",
+		 __func__, rc, lun_info->mode, lun_info->users);
+	spin_unlock(&lun_info->slock);
+	return rc;
+}
+
+/**
+ * cxlflash_lun_detach() - detaches a user from a LUN and resets the LUN's mode
+ * @lun_info:	LUN to detach.
+ */
+void cxlflash_lun_detach(struct lun_info *lun_info)
+{
+	spin_lock(&lun_info->slock);
+	if (--lun_info->users == 0)
+		lun_info->mode = MODE_NONE;
+	pr_debug("%s: li_users=%u\n", __func__, lun_info->users);
+	BUG_ON(lun_info->users < 0);
+	spin_unlock(&lun_info->slock);
+}
+
+/**
+ * cxlflash_disk_release() - releases the specified resource entry
+ * @sdev:	SCSI device associated with LUN.
+ * @release:	Release ioctl data structure.
+ *
+ * For LUN's in virtual mode, the virtual lun associated with the specified
+ * resource handle is resized to 0 prior to releasing the RHTE.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int cxlflash_disk_release(struct scsi_device *sdev,
+			  struct dk_cxlflash_release *release)
+{
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct lun_info *lun_info = sdev->hostdata;
+	struct afu *afu = cfg->afu;
+
+	res_hndl_t res_hndl = release->rsrc_handle;
+
+	int rc = 0;
+	u64 ctxid = DECODE_CTXID(release->context_id);
+
+	struct ctx_info *ctx_info = NULL;
+	struct sisl_rht_entry *rht_entry;
+	struct sisl_rht_entry_f1 *rht_entry_f1;
+
+	pr_debug("%s: ctxid=%llu res_hndl=0x%llx li->mode=%u li->users=%u\n",
+		 __func__, ctxid, release->rsrc_handle, lun_info->mode,
+		 lun_info->users);
+
+	ctx_info = get_context(cfg, ctxid, lun_info, 0);
+	if (unlikely(!ctx_info)) {
+		pr_err("%s: Invalid context! (%llu)\n", __func__, ctxid);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rht_entry = get_rhte(ctx_info, res_hndl, lun_info);
+	if (unlikely(!rht_entry)) {
+		pr_err("%s: Invalid resource handle! (%d)\n",
+		       __func__, res_hndl);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Resize to 0 for virtual LUNS by setting the size
+	 * to 0. This will clear LXT_START and LXT_CNT fields
+	 * in the RHT entry and properly sync with the AFU.
+	 *
+	 * Afterwards we clear the remaining fields.
+	 */
+	switch (lun_info->mode) {
+	case MODE_PHYSICAL:
+		/*
+		 * Clear the Format 1 RHT entry for direct access
+		 * (physical LUN) using the synchronization sequence
+		 * defined in the SISLite specification.
+		 */
+		rht_entry_f1 = (struct sisl_rht_entry_f1 *)rht_entry;
+
+		rht_entry_f1->valid = 0;
+		smp_wmb(); /* Make revocation of RHT entry visible */
+
+		rht_entry_f1->lun_id = 0;
+		smp_wmb(); /* Make clearing of LUN id visible */
+
+		rht_entry_f1->dw = 0;
+		smp_wmb(); /* Make RHT entry bottom-half clearing visible */
+
+		cxlflash_afu_sync(afu, ctxid, res_hndl, AFU_HW_SYNC);
+		break;
+	default:
+		BUG();
+		goto out;
+	}
+
+	rhte_checkin(ctx_info, rht_entry);
+	cxlflash_lun_detach(lun_info);
+
+out:
+	if (likely(ctx_info))
+		atomic_dec(&ctx_info->nrefs);
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+}
+
+/**
+ * destroy_context() - releases a context
+ * @cfg:	Internal structure associated with the host.
+ * @ctx_info:	Context to release.
+ *
+ * Note that the rht_lun member of the context was cut from a single
+ * allocation when the context was created and therefore does not need
+ * to be explicitly freed.
+ */
+static void destroy_context(struct cxlflash_cfg *cfg,
+			    struct ctx_info *ctx_info)
+{
+	BUG_ON(!list_empty(&ctx_info->luns));
+
+	/* Clear RHT registers and drop all capabilities for this context */
+	writeq_be(0, &ctx_info->ctrl_map->rht_start);
+	writeq_be(0, &ctx_info->ctrl_map->rht_cnt_id);
+	writeq_be(0, &ctx_info->ctrl_map->ctx_cap);
+
+	/* Free the RHT memory */
+	free_page((ulong)ctx_info->rht_start);
+
+	/* Free the context; note that rht_lun was allocated at same time */
+	kfree(ctx_info);
+	cfg->num_user_contexts--;
+}
+
+/**
+ * create_context() - allocates and initializes a context
+ * @cfg:	Internal structure associated with the host.
+ * @ctx:	Previously obtained CXL context reference.
+ * @ctxid:	Previously obtained process element associated with CXL context.
+ * @adap_fd:	Previously obtained adapter fd associated with CXL context.
+ * @perms:	User-specified permissions.
+ *
+ * Return: Allocated context on success, NULL on failure
+ */
+static struct ctx_info *create_context(struct cxlflash_cfg *cfg,
+				       struct cxl_context *ctx, int ctxid,
+				       int adap_fd, u32 perms)
+{
+	char *tmp = NULL;
+	size_t size;
+	struct afu *afu = cfg->afu;
+	struct ctx_info *ctx_info = NULL;
+	struct sisl_rht_entry *rht;
+
+	size = ((MAX_RHT_PER_CONTEXT * sizeof(*ctx_info->rht_lun)) +
+		sizeof(*ctx_info));
+
+	tmp = kzalloc(size, GFP_KERNEL);
+	if (unlikely(!tmp)) {
+		pr_err("%s: Unable to allocate context! (%ld)\n",
+		       __func__, size);
+		goto out;
+	}
+
+	rht = (struct sisl_rht_entry *)get_zeroed_page(GFP_KERNEL);
+	if (unlikely(!rht)) {
+		pr_err("%s: Unable to allocate RHT!\n", __func__);
+		goto err;
+	}
+
+	ctx_info = (struct ctx_info *)tmp;
+	ctx_info->rht_lun = (struct lun_info **)(tmp + sizeof(*ctx_info));
+	ctx_info->rht_start = rht;
+	ctx_info->rht_perms = perms;
+
+	ctx_info->ctrl_map = &afu->afu_map->ctrls[ctxid].ctrl;
+	ctx_info->ctxid = ENCODE_CTXID(ctx_info, ctxid);
+	ctx_info->lfd = adap_fd;
+	ctx_info->pid = current->tgid; /* tgid = pid */
+	ctx_info->ctx = ctx;
+	INIT_LIST_HEAD(&ctx_info->luns);
+	INIT_LIST_HEAD(&ctx_info->luns);
+	atomic_set(&ctx_info->nrefs, 1);
+
+	cfg->num_user_contexts++;
+
+out:
+	return ctx_info;
+
+err:
+	kfree(tmp);
+	goto out;
+}
+
+/**
+ * cxlflash_disk_detach() - detaches a LUN from a context
+ * @sdev:	SCSI device associated with LUN.
+ * @detach:	Detach ioctl data structure.
+ *
+ * As part of the detach, all per-context resources associated with the LUN
+ * are cleaned up. When detaching the last LUN for a context, the context
+ * itself is cleaned up and released.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int cxlflash_disk_detach(struct scsi_device *sdev,
+				struct dk_cxlflash_detach *detach)
+{
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct lun_info *lun_info = sdev->hostdata;
+	struct lun_access *lun_access, *t;
+	struct dk_cxlflash_release rel;
+	struct ctx_info *ctx_info = NULL;
+
+	int i;
+	int rc = 0;
+	int lfd;
+	u64 ctxid = DECODE_CTXID(detach->context_id);
+	ulong flags = 0;
+
+	pr_debug("%s: ctxid=%llu\n", __func__, ctxid);
+
+	ctx_info = get_context(cfg, ctxid, lun_info, 0);
+	if (unlikely(!ctx_info)) {
+		pr_err("%s: Invalid context! (%llu)\n", __func__, ctxid);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	/* Cleanup outstanding resources tied to this LUN */
+	if (ctx_info->rht_out) {
+		marshall_det_to_rele(detach, &rel);
+		for (i = 0; i < MAX_RHT_PER_CONTEXT; i++) {
+			if (ctx_info->rht_lun[i] == lun_info) {
+				rel.rsrc_handle = i;
+				cxlflash_disk_release(sdev, &rel);
+			}
+
+			/* No need to loop further if we're done */
+			if (ctx_info->rht_out == 0)
+				break;
+		}
+	}
+
+	/* Take our LUN out of context, free the node */
+	list_for_each_entry_safe(lun_access, t, &ctx_info->luns, list)
+		if (lun_access->lun_info == lun_info) {
+			list_del(&lun_access->list);
+			kfree(lun_access);
+			lun_access = NULL;
+			break;
+		}
+
+	/* Tear down context following last LUN cleanup */
+	if (list_empty(&ctx_info->luns)) {
+		spin_lock_irqsave(&cfg->ctx_tbl_slock, flags);
+		cfg->ctx_tbl[ctxid] = NULL;
+		spin_unlock_irqrestore(&cfg->ctx_tbl_slock, flags);
+
+		while (atomic_read(&ctx_info->nrefs) > 1) {
+			pr_debug("%s: waiting on threads... (%d)\n",
+				 __func__, atomic_read(&ctx_info->nrefs));
+			cpu_relax();
+		}
+
+		lfd = ctx_info->lfd;
+		destroy_context(cfg, ctx_info);
+		ctx_info = NULL;
+
+		/*
+		 * As a last step, clean up external resources when not
+		 * already on an external cleanup thread, ie: close(adap_fd).
+		 *
+		 * NOTE: this will free up the context from the CXL services,
+		 * allowing it to dole out the same context_id on a future
+		 * (or even currently in-flight) disk_attach operation.
+		 */
+		if (lfd != -1)
+			sys_close(lfd);
+	}
+
+out:
+	if (likely(ctx_info))
+		atomic_dec(&ctx_info->nrefs);
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+}
+
+/**
+ * cxlflash_cxl_release() - release handler for adapter file descriptor
+ * @inode:	Filesystem inode associated with fd.
+ * @file:	File installed with adapter file descriptor.
+ *
+ * This routine is the release handler for the fops registered with
+ * the CXL services on an initial attach for a context. It is called
+ * when a close is performed on the adapter file descriptor returned
+ * to the user. Programmatically, the user is not required to perform
+ * the close, as it is handled internally via the detach ioctl when
+ * a context is being removed. Note that nothing prevents the user
+ * from performing a close, but the user should be aware that doing
+ * so is considered catastrophic and subsequent usage of the superpipe
+ * API with previously saved off tokens will fail.
+ *
+ * When initiated from an external close (either by the user or via
+ * a process tear down), the routine derives the context reference
+ * and calls detach for each LUN associated with the context. The
+ * final detach operation will cause the context itself to be freed.
+ * Note that the saved off lfd is reset prior to calling detach to
+ * signify that the final detach should not perform a close.
+ *
+ * When initiated from a detach operation as part of the tear down
+ * of a context, the context is first completely freed and then the
+ * close is performed. This routine will fail to derive the context
+ * reference (due to the context having already been freed) and then
+ * call into the CXL release entry point.
+ *
+ * Thus, with exception to when the CXL process element (context id)
+ * lookup fails (a case that should theoretically never occur), every
+ * call into this routine results in a complete freeing of a context.
+ *
+ * As part of the detach, all per-context resources associated with the LUN
+ * are cleaned up. When detaching the last LUN for a context, the context
+ * itself is cleaned up and released.
+ *
+ * Return: 0 on success
+ */
+static int cxlflash_cxl_release(struct inode *inode, struct file *file)
+{
+	struct cxl_context *ctx = cxl_fops_get_context(file);
+	struct cxlflash_cfg *cfg = container_of(file->f_op, struct cxlflash_cfg,
+						cxl_fops);
+	struct ctx_info *ctx_info = NULL;
+	struct dk_cxlflash_detach detach = { { 0 }, 0 };
+	struct lun_access *lun_access, *t;
+	int ctxid;
+
+	ctxid = cxl_process_element(ctx);
+	if (unlikely(ctxid < 0)) {
+		pr_err("%s: Context %p was closed! (%d)\n",
+		       __func__, ctx, ctxid);
+		goto out;
+	}
+
+	ctx_info = get_context(cfg, ctxid, NULL, 0);
+	if (unlikely(!ctx_info)) {
+		ctx_info = get_context(cfg, ctxid, NULL, CTX_CTRL_CLONE);
+		if (!ctx_info) {
+			pr_debug("%s: Context %d already free!\n",
+				 __func__, ctxid);
+			goto out_release;
+		}
+
+		pr_debug("%s: Another process owns context %d!\n",
+			 __func__, ctxid);
+		goto out;
+	}
+
+	pr_debug("%s: close(%d) for context %d\n",
+		 __func__, ctx_info->lfd, ctxid);
+
+	/* Reset the file descriptor to indicate we're on a close() thread */
+	ctx_info->lfd = -1;
+	detach.context_id = ctx_info->ctxid;
+	atomic_dec(&ctx_info->nrefs); /* fix up reference count */
+	list_for_each_entry_safe(lun_access, t, &ctx_info->luns, list)
+		cxlflash_disk_detach(lun_access->sdev, &detach);
+
+	/*
+	 * Don't reference lun_access, or t (or ctx_info for that matter, even
+	 * though it's invalidated to appease the reference counting code).
+	 */
+	ctx_info = NULL;
+
+out_release:
+	cxl_fd_release(inode, file);
+out:
+	if (likely(ctx_info))
+		atomic_dec(&ctx_info->nrefs);
+	pr_debug("%s: returning\n", __func__);
+	return 0;
+}
+
+/**
+ * unmap_context() - clears a previously established mapping
+ * @ctx_info:	Context owning the mapping.
+ *
+ * This routine is used to switch between the error notification page
+ * (dummy page of all 1's) and the real mapping (established by the CXL
+ * fault handler).
+ */
+static void unmap_context(struct ctx_info *ctx_info)
+{
+	unmap_mapping_range(ctx_info->mapping, 0, 0, 1);
+}
+
+/**
+ * get_err_page() - obtains and allocates the error notification page
+ *
+ * Return: error notification page on success, NULL on failure
+ */
+static struct page *get_err_page(void)
+{
+	struct page *err_page = global.err_page;
+	ulong flags = 0;
+
+	if (unlikely(!err_page)) {
+		err_page = alloc_page(GFP_KERNEL);
+		if (unlikely(!err_page)) {
+			pr_err("%s: Unable to allocate err_page!\n", __func__);
+			goto out;
+		}
+
+		memset(page_address(err_page), -1, PAGE_SIZE);
+
+		/* Serialize update w/ other threads to avoid a leak */
+		spin_lock_irqsave(&global.slock, flags);
+		if (likely(!global.err_page))
+			global.err_page = err_page;
+		else {
+			__free_page(err_page);
+			err_page = global.err_page;
+		}
+		spin_unlock_irqrestore(&global.slock, flags);
+	}
+
+out:
+	pr_debug("%s: returning err_page=%p\n", __func__, err_page);
+	return err_page;
+}
+
+/**
+ * cxlflash_mmap_fault() - mmap fault handler for adapter file descriptor
+ * @vma:	VM area associated with mapping.
+ * @vmf:	VM fault associated with current fault.
+ *
+ * To support error notification via MMIO, faults are 'caught' by this routine
+ * that was inserted before passing back the adapter file descriptor on attach.
+ * When a fault occurs, this routine evaluates if error recovery is active and
+ * if so, installs the error page to 'notify' the user about the error state.
+ * During normal operation, the fault is simply handled by the original fault
+ * handler that was installed by CXL services as part of initializing the
+ * adapter file descriptor.
+ *
+ * Return: 0 on success, VM_FAULT_SIGBUS on failure
+ */
+static int cxlflash_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct file *file = vma->vm_file;
+	struct cxl_context *ctx = cxl_fops_get_context(file);
+	struct cxlflash_cfg *cfg = container_of(file->f_op, struct cxlflash_cfg,
+						cxl_fops);
+	struct ctx_info *ctx_info = NULL;
+	struct page *err_page = NULL;
+	int rc = 0;
+	int ctxid;
+
+	ctxid = cxl_process_element(ctx);
+	if (unlikely(ctxid < 0)) {
+		pr_err("%s: Context %p was closed! (%d)\n",
+		       __func__, ctx, ctxid);
+		goto err;
+	}
+
+	ctx_info = get_context(cfg, ctxid, NULL, 0);
+	if (unlikely(!ctx_info)) {
+		pr_err("%s: Invalid context! (%d)\n", __func__, ctxid);
+		goto err;
+	}
+
+	pr_debug("%s: fault(%d) for context %d\n",
+		 __func__, ctx_info->lfd, ctxid);
+
+	if (likely(!ctx_info->err_recovery_active))
+		rc = ctx_info->cxl_mmap_vmops->fault(vma, vmf);
+	else {
+		pr_debug("%s: err recovery active, use err_page!\n", __func__);
+
+		err_page = get_err_page();
+		if (unlikely(!err_page)) {
+			pr_err("%s: Could not obtain error page!\n", __func__);
+			rc = VM_FAULT_RETRY;
+			goto out;
+		}
+
+		get_page(err_page);
+		vmf->page = err_page;
+	}
+
+out:
+	if (likely(ctx_info))
+		atomic_dec(&ctx_info->nrefs);
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+
+err:
+	rc = VM_FAULT_SIGBUS;
+	goto out;
+}
+
+/*
+ * Local MMAP vmops to 'catch' faults
+ */
+static const struct vm_operations_struct cxlflash_mmap_vmops = {
+	.fault = cxlflash_mmap_fault,
+};
+
+/**
+ * cxlflash_cxl_mmap() - mmap handler for adapter file descriptor
+ * @file:	File installed with adapter file descriptor.
+ * @vma:	VM area associated with mapping.
+ *
+ * Installs local mmap vmops to 'catch' faults for error notification support.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int cxlflash_cxl_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct cxl_context *ctx = cxl_fops_get_context(file);
+	struct cxlflash_cfg *cfg = container_of(file->f_op, struct cxlflash_cfg,
+						cxl_fops);
+	struct ctx_info *ctx_info = NULL;
+	int ctxid;
+	int rc = 0;
+
+	ctxid = cxl_process_element(ctx);
+	if (unlikely(ctxid < 0)) {
+		pr_err("%s: Context %p was closed! (%d)\n",
+		       __func__, ctx, ctxid);
+		rc = -EIO;
+		goto out;
+	}
+
+	ctx_info = get_context(cfg, ctxid, NULL, 0);
+	if (unlikely(!ctx_info)) {
+		pr_err("%s: Invalid context! (%d)\n", __func__, ctxid);
+		rc = -EIO;
+		goto out;
+	}
+
+	pr_debug("%s: mmap(%d) for context %d\n",
+		 __func__, ctx_info->lfd, ctxid);
+
+	rc = cxl_fd_mmap(file, vma);
+	if (likely(!rc)) {
+		/*
+		 * Insert ourself in the mmap fault handler path and save off
+		 * the address space for toggling the mapping on error context.
+		 */
+		ctx_info->cxl_mmap_vmops = vma->vm_ops;
+		vma->vm_ops = &cxlflash_mmap_vmops;
+
+		ctx_info->mapping = file->f_inode->i_mapping;
+	}
+
+out:
+	if (likely(ctx_info))
+		atomic_dec(&ctx_info->nrefs);
+	return rc;
+}
+
+/*
+ * Local fops for adapter file descriptor
+ */
+static const struct file_operations cxlflash_cxl_fops = {
+	.owner = THIS_MODULE,
+	.mmap = cxlflash_cxl_mmap,
+	.release = cxlflash_cxl_release,
+};
+
+/**
+ * cxlflash_mark_contexts_error() - move contexts to error list and install
+ * error page
+ * @cfg:	Internal structure associated with the host.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int cxlflash_mark_contexts_error(struct cxlflash_cfg *cfg)
+{
+	int i, rc = 0;
+	ulong lock_flags;
+	struct ctx_info *ctx_info = NULL;
+
+	spin_lock_irqsave(&cfg->ctx_tbl_slock, lock_flags);
+
+	for (i = 0; i < MAX_CONTEXT; i++) {
+		ctx_info = cfg->ctx_tbl[i];
+
+		if (ctx_info) {
+			cfg->ctx_tbl[i] = NULL;
+			list_add(&ctx_info->list, &cfg->ctx_err_recovery);
+			ctx_info->err_recovery_active = true;
+			unmap_context(ctx_info);
+		}
+	}
+
+	spin_unlock_irqrestore(&cfg->ctx_tbl_slock, lock_flags);
+
+	return rc;
+}
+
+/**
+ * cxlflash_disk_attach() - attach a LUN to a context
+ * @sdev:	SCSI device associated with LUN.
+ * @attach:	Attach ioctl data structure.
+ *
+ * Creates a context and attaches LUN to it. A LUN can only be attached
+ * one time to a context (subsequent attaches for the same context/LUN pair
+ * are not supported). Additional LUNs can be attached to a context by
+ * specifying the 'reuse' flag defined in the cxlflash_ioctl.h header.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int cxlflash_disk_attach(struct scsi_device *sdev,
+				struct dk_cxlflash_attach *attach)
+{
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct afu *afu = cfg->afu;
+	struct lun_info *lun_info = sdev->hostdata;
+	struct cxl_ioctl_start_work *work;
+	struct ctx_info *ctx_info = NULL;
+	struct lun_access *lun_access = NULL;
+	int rc = 0;
+	u32 perms;
+	int ctxid = -1;
+	struct file *file;
+
+	struct cxl_context *ctx;
+
+	int fd = -1;
+
+	/* On first attach set fileops */
+	if (cfg->num_user_contexts == 0)
+		cfg->cxl_fops = cxlflash_cxl_fops;
+
+	if (attach->num_interrupts > 4) {
+		pr_err("%s: Cannot support this many interrupts %llu\n",
+		       __func__, attach->num_interrupts);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (lun_info->max_lba == 0) {
+		pr_debug("%s: No capacity info yet for this LUN "
+			"(%016llX)\n", __func__, lun_info->lun_id);
+		read_cap16(afu, lun_info, sdev->channel + 1);
+		pr_debug("%s: LBA = %016llX\n", __func__, lun_info->max_lba);
+		pr_debug("%s: BLK_LEN = %08X\n", __func__, lun_info->blk_len);
+	}
+
+	if (attach->hdr.flags & DK_CXLFLASH_ATTACH_REUSE_CONTEXT) {
+		ctxid = DECODE_CTXID(attach->context_id);
+		ctx_info = get_context(cfg, ctxid, NULL, 0);
+		if (!ctx_info) {
+			pr_err("%s: Invalid context! (%d)\n", __func__, ctxid);
+			rc = -EINVAL;
+			goto out;
+		}
+
+		list_for_each_entry(lun_access, &ctx_info->luns, list)
+			if (lun_access->lun_info == lun_info) {
+				pr_err("%s: Context already attached!\n",
+				       __func__);
+				rc = -EINVAL;
+				goto out;
+			}
+	}
+
+	lun_access = kzalloc(sizeof(*lun_access), GFP_KERNEL);
+	if (unlikely(!lun_access)) {
+		pr_err("%s: Unable to allocate lun_access!\n", __func__);
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	lun_access->lun_info = lun_info;
+	lun_access->sdev = sdev;
+
+	/* Non-NULL context indicates reuse */
+	if (ctx_info) {
+		pr_debug("%s: Reusing context for LUN! (%d)\n",
+			 __func__, ctxid);
+		list_add(&lun_access->list, &ctx_info->luns);
+		fd = ctx_info->lfd;
+		goto out_attach;
+	}
+
+	ctx = cxl_dev_context_init(cfg->dev);
+	if (!ctx) {
+		pr_err("%s: Could not initialize context\n", __func__);
+		rc = -ENODEV;
+		goto err0;
+	}
+
+	ctxid = cxl_process_element(ctx);
+	if ((ctxid > MAX_CONTEXT) || (ctxid < 0)) {
+		pr_err("%s: ctxid (%d) invalid!\n", __func__, ctxid);
+		rc = -EPERM;
+		goto err1;
+	}
+
+	file = cxl_get_fd(ctx, &cfg->cxl_fops, &fd);
+	if (fd < 0) {
+		rc = -ENODEV;
+		pr_err("%s: Could not get file descriptor\n", __func__);
+		goto err1;
+	}
+
+	/* Translate read/write O_* flags from fcntl.h to AFU permission bits */
+	perms = SISL_RHT_PERM(attach->hdr.flags + 1);
+
+	ctx_info = create_context(cfg, ctx, ctxid, fd, perms);
+	if (unlikely(!ctx_info)) {
+		pr_err("%s: Failed to create context! (%d)\n", __func__, ctxid);
+		goto err2;
+	}
+
+	work = &ctx_info->work;
+	work->num_interrupts = attach->num_interrupts;
+	work->flags = CXL_START_WORK_NUM_IRQS;
+
+	rc = cxl_start_work(ctx, work);
+	if (rc) {
+		pr_err("%s: Could not start context rc=%d\n", __func__, rc);
+		goto err3;
+	}
+
+	rc = afu_attach(cfg, ctx_info);
+	if (rc) {
+		pr_err("%s: Could not attach AFU rc %d\n", __func__, rc);
+		goto err4;
+	}
+
+	/*
+	 * No error paths after this point. Once the fd is installed it's
+	 * visible to user space and can't be undone safely on this thread.
+	 */
+	list_add(&lun_access->list, &ctx_info->luns);
+	cfg->ctx_tbl[ctxid] = ctx_info;
+	fd_install(fd, file);
+
+out_attach:
+	attach->hdr.return_flags = 0;
+	attach->context_id = ctx_info->ctxid;
+	attach->block_size = lun_info->blk_len;
+	attach->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
+	attach->last_lba = lun_info->max_lba;
+	attach->max_xfer = (sdev->host->max_sectors * 512) / lun_info->blk_len;
+
+out:
+	attach->adap_fd = fd;
+
+	if (likely(ctx_info))
+		atomic_dec(&ctx_info->nrefs);
+
+	pr_debug("%s: returning ctxid=%d fd=%d bs=%lld rc=%d llba=%lld\n",
+		 __func__, ctxid, fd, attach->block_size, rc, attach->last_lba);
+	return rc;
+
+err4:
+	cxl_stop_context(ctx);
+err3:
+	destroy_context(cfg, ctx_info);
+err2:
+	fput(file);
+	put_unused_fd(fd);
+	fd = -1;
+err1:
+	cxl_release_context(ctx);
+err0:
+	kfree(lun_access);
+	goto out;
+}
+
+/**
+ * cxlflash_manage_lun() - handles lun management activities
+ * @sdev:	SCSI device associated with LUN.
+ * @manage:	Manage ioctl data structure.
+ *
+ * This routine is used to notify the driver about a LUN's WWID and associate
+ * SCSI devices (sdev) with a global LUN instance. Additionally it serves to
+ * change a LUN's operating mode: legacy or superpipe.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int cxlflash_manage_lun(struct scsi_device *sdev,
+			       struct dk_cxlflash_manage_lun *manage)
+{
+	struct lun_info *lun_info = NULL;
+
+	lun_info = lookup_lun(sdev, manage->wwid);
+	pr_debug("%s: ENTER: WWID = %016llX%016llX, flags = %016llX li = %p\n",
+		 __func__, get_unaligned_le64(&manage->wwid[0]),
+		 get_unaligned_le64(&manage->wwid[8]),
+		 manage->hdr.flags, lun_info);
+	return 0;
+}
+
+/**
+ * recover_context() - recovers a context in error
+ * @cfg:	Internal structure associated with the host.
+ * @ctx_info:	Context to release.
+ *
+ * Restablishes the state for a context-in-error.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctx_info)
+{
+	int rc = 0;
+	int fd = -1;
+	int ctxid = -1;
+	struct file *file;
+	struct cxl_context *ctx;
+	struct afu *afu = cfg->afu;
+
+	ctx = cxl_dev_context_init(cfg->dev);
+	if (!ctx) {
+		pr_err("%s: Could not initialize context\n", __func__);
+		rc = -ENODEV;
+		goto out;
+	}
+
+	ctxid = cxl_process_element(ctx);
+	if ((ctxid > MAX_CONTEXT) || (ctxid < 0)) {
+		pr_err("%s: ctxid (%d) invalid!\n", __func__, ctxid);
+		rc = -EPERM;
+		goto err1;
+	}
+
+	file = cxl_get_fd(ctx, &cfg->cxl_fops, &fd);
+	if (fd < 0) {
+		rc = -ENODEV;
+		pr_err("%s: Could not get file descriptor\n", __func__);
+		goto err1;
+	}
+
+	rc = cxl_start_work(ctx, &ctx_info->work);
+	if (rc) {
+		pr_err("%s: Could not start context rc=%d\n", __func__, rc);
+		goto err2;
+	}
+
+	/* Update with new MMIO area based on updated context id */
+	ctx_info->ctrl_map = &afu->afu_map->ctrls[ctxid].ctrl;
+
+	rc = afu_attach(cfg, ctx_info);
+	if (rc) {
+		pr_err("%s: Could not attach AFU rc %d\n", __func__, rc);
+		goto err3;
+	}
+
+	/*
+	 * No error paths after this point. Once the fd is installed it's
+	 * visible to user space and can't be undone safely on this thread.
+	 */
+	ctx_info->ctxid = ENCODE_CTXID(ctx_info, ctxid);
+	ctx_info->lfd = fd;
+	ctx_info->ctx = ctx;
+
+	cfg->ctx_tbl[ctxid] = ctx_info;
+	fd_install(fd, file);
+
+out:
+	pr_debug("%s: returning ctxid=%d fd=%d rc=%d\n",
+		 __func__, ctxid, fd, rc);
+	return rc;
+
+err3:
+	cxl_stop_context(ctx);
+err2:
+	fput(file);
+	put_unused_fd(fd);
+err1:
+	cxl_release_context(ctx);
+	goto out;
+}
+
+/**
+ * cxlflash_afu_recover() - initiates AFU recovery
+ * @sdev:	SCSI device associated with LUN.
+ * @recover:	Recover ioctl data structure.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int cxlflash_afu_recover(struct scsi_device *sdev,
+				struct dk_cxlflash_recover_afu *recover)
+{
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct lun_info *lun_info = sdev->hostdata;
+	struct afu *afu = cfg->afu;
+	struct ctx_info *ctx_info = NULL;
+	u64 ctxid = DECODE_CTXID(recover->context_id);
+	long reg;
+	int rc = 0;
+
+	/* Ensure that this process is attached to the context */
+	ctx_info = get_context(cfg, ctxid, lun_info, 0);
+	if (unlikely(!ctx_info)) {
+		pr_err("%s: Invalid context! (%llu)\n", __func__, ctxid);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = recover_context(cfg, ctx_info);
+	if (unlikely(rc)) {
+		pr_err("%s: Error recovery failed for context %llu (rc=%d)\n",
+		       __func__, ctxid, rc);
+		goto out;
+	}
+
+	ctx_info->err_recovery_active = false;
+	recover->context_id = ctx_info->ctxid;
+	recover->adap_fd = ctx_info->lfd;
+	recover->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
+
+	reg = readq_be(&afu->ctrl_map->mbox_r);	/* Try MMIO */
+	/* MMIO returning 0xff, need to reset */
+	if (reg == -1) {
+		pr_info("%s: afu=%p reason 0x%llx\n",
+			__func__, afu, recover->reason);
+		cxlflash_afu_reset(cfg);
+	} else {
+		pr_debug("%s: reason 0x%llx MMIO working, no reset performed\n",
+			 __func__, recover->reason);
+		rc = -EINVAL;
+	}
+
+out:
+	if (likely(ctx_info))
+		atomic_dec(&ctx_info->nrefs);
+	return rc;
+}
+
+/**
+ * process_sense() - evaluates and processes sense data
+ * @sdev:	SCSI device associated with LUN.
+ * @verify:	Verify ioctl data structure.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int process_sense(struct scsi_device *sdev,
+			 struct dk_cxlflash_verify *verify)
+{
+	struct request_sense_data *sense_data = (struct request_sense_data *)
+		&verify->sense_data;
+	struct lun_info *lun_info = sdev->hostdata;
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct afu *afu = cfg->afu;
+	u64 prev_lba = lun_info->max_lba;
+	int rc = 0;
+
+	switch (sense_data->sense_key) {
+	case NO_SENSE:
+	case RECOVERED_ERROR:
+		/* fall through */
+	case NOT_READY:
+		break;
+	case UNIT_ATTENTION:
+		switch (sense_data->add_sense_key) {
+		case 0x29: /* Power on Reset or Device Reset */
+			/* fall through */
+		case 0x2A: /* Device settings/capacity changed */
+			read_cap16(afu, lun_info, sdev->channel + 1);
+			if (prev_lba != lun_info->max_lba)
+				pr_debug("%s: Capacity changed old=%lld "
+					 "new=%lld\n", __func__, prev_lba,
+					 lun_info->max_lba);
+			break;
+		case 0x3F: /* Report LUNs changed, Rescan. */
+			scsi_scan_host(cfg->host);
+			break;
+		default:
+			rc = -EIO;
+			break;
+		}
+		break;
+	default:
+		rc = -EIO;
+		break;
+	}
+	pr_debug("%s: sense_key %x asc %x rc %d\n", __func__,
+		 sense_data->sense_key, sense_data->add_sense_key, rc);
+	return rc;
+}
+
+/**
+ * cxlflash_disk_verify() - verifies a LUN is the same and handle size changes
+ * @sdev:	SCSI device associated with LUN.
+ * @verify:	Verify ioctl data structure.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int cxlflash_disk_verify(struct scsi_device *sdev,
+				struct dk_cxlflash_verify *verify)
+{
+	int rc = 0;
+	struct ctx_info *ctx_info = NULL;
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct lun_info *lun_info = sdev->hostdata;
+	struct sisl_rht_entry *rht_entry = NULL;
+	res_hndl_t res_hndl = verify->rsrc_handle;
+	u64 ctxid = DECODE_CTXID(verify->context_id);
+	u64 last_lba = 0;
+
+	pr_debug("%s: ctxid=%llu res_hndl=0x%llx, hint=0x%llx\n",
+		 __func__, ctxid, verify->rsrc_handle, verify->hint);
+
+	ctx_info = get_context(cfg, ctxid, lun_info, 0);
+	if (unlikely(!ctx_info)) {
+		pr_err("%s: Invalid context! (%llu)\n",
+		       __func__, ctxid);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rht_entry = get_rhte(ctx_info, res_hndl, lun_info);
+	if (unlikely(!rht_entry)) {
+		pr_err("%s: Invalid resource handle! (%d)\n",
+		       __func__, res_hndl);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Look at the hint/sense to see if it requires us to redrive
+	 * inquiry (i.e. the Unit attention is due to the WWN changing).
+	 */
+	if (verify->hint & DK_CXLFLASH_VERIFY_HINT_SENSE) {
+		rc = process_sense(sdev, verify);
+		if (unlikely(rc)) {
+			pr_err("%s: Failed to validate sense data! (%d)\n",
+			       __func__, rc);
+			goto out;
+		}
+	}
+
+	switch (lun_info->mode) {
+	case MODE_PHYSICAL:
+		last_lba = lun_info->max_lba;
+		break;
+	case MODE_VIRTUAL:
+		last_lba = (((rht_entry->lxt_cnt * MC_CHUNK_SIZE *
+			      lun_info->blk_len) / CXLFLASH_BLOCK_SIZE) - 1);
+		break;
+	default:
+		BUG();
+	}
+
+	verify->last_lba = last_lba;
+
+out:
+	if (likely(ctx_info))
+		atomic_dec(&ctx_info->nrefs);
+	pr_debug("%s: returning rc=%d llba=%lld\n",
+		 __func__, rc, verify->last_lba);
+	return rc;
+}
+
+/**
+ * decode_ioctl() - translates an encoded ioctl to an easily identifiable string
+ * @cmd:	The ioctl command to decode.
+ *
+ * Return: A string identifying the decoded ioctl.
+ */
+static char *decode_ioctl(int cmd)
+{
+	switch (cmd) {
+	case DK_CXLFLASH_ATTACH:
+		return __stringify_1(DK_CXLFLASH_ATTACH);
+	case DK_CXLFLASH_USER_DIRECT:
+		return __stringify_1(DK_CXLFLASH_USER_DIRECT);
+	case DK_CXLFLASH_USER_VIRTUAL:
+		return __stringify_1(DK_CXLFLASH_USER_VIRTUAL);
+	case DK_CXLFLASH_VLUN_RESIZE:
+		return __stringify_1(DK_CXLFLASH_VLUN_RESIZE);
+	case DK_CXLFLASH_RELEASE:
+		return __stringify_1(DK_CXLFLASH_RELEASE);
+	case DK_CXLFLASH_DETACH:
+		return __stringify_1(DK_CXLFLASH_DETACH);
+	case DK_CXLFLASH_VERIFY:
+		return __stringify_1(DK_CXLFLASH_VERIFY);
+	case DK_CXLFLASH_CLONE:
+		return __stringify_1(DK_CXLFLASH_CLONE);
+	case DK_CXLFLASH_RECOVER_AFU:
+		return __stringify_1(DK_CXLFLASH_RECOVER_AFU);
+	case DK_CXLFLASH_MANAGE_LUN:
+		return __stringify_1(DK_CXLFLASH_MANAGE_LUN);
+	}
+
+	return "UNKNOWN";
+}
+
+/**
+ * cxlflash_disk_direct_open() - opens a direct (physical) disk
+ * @sdev:	SCSI device associated with LUN.
+ * @arg:	UDirect ioctl data structure.
+ *
+ * On successful return, the user is informed of the resource handle
+ * to be used to identify the direct lun and the size (in blocks) of
+ * the direct lun in last LBA format.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int cxlflash_disk_direct_open(struct scsi_device *sdev, void *arg)
+{
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct afu *afu = cfg->afu;
+	struct lun_info *lun_info = sdev->hostdata;
+
+	struct dk_cxlflash_udirect *pphys = (struct dk_cxlflash_udirect *)arg;
+
+	u64 ctxid = DECODE_CTXID(pphys->context_id);
+	u64 lun_size = 0;
+	u64 last_lba = 0;
+	u64 rsrc_handle = -1;
+
+	int rc = 0;
+
+	struct ctx_info *ctx_info = NULL;
+	struct sisl_rht_entry *rht_entry = NULL;
+
+	pr_debug("%s: ctxid=%llu ls=0x%llx\n", __func__, ctxid, lun_size);
+
+	rc = cxlflash_lun_attach(lun_info, MODE_PHYSICAL);
+	if (unlikely(rc)) {
+		pr_err("%s: Failed to attach to LUN! mode=%u\n",
+		       __func__, MODE_PHYSICAL);
+		goto out;
+	}
+
+	ctx_info = get_context(cfg, ctxid, lun_info, 0);
+	if (unlikely(!ctx_info)) {
+		pr_err("%s: Invalid context! (%llu)\n", __func__, ctxid);
+		rc = -EINVAL;
+		goto err1;
+	}
+
+	rht_entry = rhte_checkout(ctx_info, lun_info);
+	if (unlikely(!rht_entry)) {
+		pr_err("%s: too many opens for this context\n", __func__);
+		rc = -EMFILE;	/* too many opens  */
+		goto err1;
+	}
+
+	rsrc_handle = (rht_entry - ctx_info->rht_start);
+
+	rht_format1(rht_entry, lun_info->lun_id, ctx_info->rht_perms);
+	cxlflash_afu_sync(afu, ctxid, rsrc_handle, AFU_LW_SYNC);
+
+	last_lba = lun_info->max_lba;
+	pphys->hdr.return_flags = 0;
+	pphys->last_lba = last_lba;
+	pphys->rsrc_handle = rsrc_handle;
+
+out:
+	if (likely(ctx_info))
+		atomic_dec(&ctx_info->nrefs);
+	pr_debug("%s: returning handle 0x%llx rc=%d llba %lld\n",
+		 __func__, rsrc_handle, rc, last_lba);
+	return rc;
+
+err1:
+	cxlflash_lun_detach(lun_info);
+	goto out;
+}
+
+/**
+ * cxlflash_ioctl() - IOCTL handler for driver
+ * @sdev:	SCSI device associated with LUN.
+ * @arg:	Userspace ioctl data structure.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int cxlflash_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
+{
+	typedef int (*sioctl) (struct scsi_device *, void *);
+
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct afu *afu = cfg->afu;
+	struct dk_cxlflash_hdr *hdr;
+	char buf[MAX_CXLFLASH_IOCTL_SZ];
+	size_t size = 0;
+	bool known_ioctl = false;
+	int idx;
+	int rc = 0;
+	struct Scsi_Host *shost = sdev->host;
+	sioctl do_ioctl = NULL;
+
+	static const struct {
+		size_t size;
+		sioctl ioctl;
+	} ioctl_tbl[] = {	/* NOTE: order matters here */
+	{sizeof(struct dk_cxlflash_attach), (sioctl)cxlflash_disk_attach},
+	{sizeof(struct dk_cxlflash_udirect), cxlflash_disk_direct_open},
+	{sizeof(struct dk_cxlflash_release), (sioctl)cxlflash_disk_release},
+	{sizeof(struct dk_cxlflash_detach), (sioctl)cxlflash_disk_detach},
+	{sizeof(struct dk_cxlflash_verify), (sioctl)cxlflash_disk_verify},
+	{sizeof(struct dk_cxlflash_recover_afu), (sioctl)cxlflash_afu_recover},
+	{sizeof(struct dk_cxlflash_manage_lun), (sioctl)cxlflash_manage_lun},
+	};
+
+	/* Restrict command set to physical support only for internal LUN */
+	if (afu->internal_lun)
+		switch (cmd) {
+		case DK_CXLFLASH_USER_VIRTUAL:
+		case DK_CXLFLASH_VLUN_RESIZE:
+		case DK_CXLFLASH_RELEASE:
+		case DK_CXLFLASH_CLONE:
+			pr_err("%s: %s not supported for lun_mode=%d\n",
+			       __func__, decode_ioctl(cmd), afu->internal_lun);
+			rc = -EINVAL;
+			goto cxlflash_ioctl_exit;
+		}
+
+	switch (cmd) {
+	case DK_CXLFLASH_ATTACH:
+	case DK_CXLFLASH_USER_DIRECT:
+	case DK_CXLFLASH_USER_VIRTUAL:
+	case DK_CXLFLASH_VLUN_RESIZE:
+	case DK_CXLFLASH_RELEASE:
+	case DK_CXLFLASH_DETACH:
+	case DK_CXLFLASH_VERIFY:
+	case DK_CXLFLASH_CLONE:
+	case DK_CXLFLASH_RECOVER_AFU:
+	case DK_CXLFLASH_MANAGE_LUN:
+		known_ioctl = true;
+		idx = _IOC_NR(cmd) - _IOC_NR(DK_CXLFLASH_ATTACH);
+		size = ioctl_tbl[idx].size;
+		do_ioctl = ioctl_tbl[idx].ioctl;
+
+		if (likely(do_ioctl))
+			break;
+
+		/* fall through */
+	default:
+		rc = -EINVAL;
+		goto cxlflash_ioctl_exit;
+	}
+
+	if (unlikely(copy_from_user(&buf, arg, size))) {
+		pr_err("%s: copy_from_user() fail! "
+		       "size=%lu cmd=%d (%s) arg=%p\n",
+		       __func__, size, cmd, decode_ioctl(cmd), arg);
+		rc = -EFAULT;
+		goto cxlflash_ioctl_exit;
+	}
+
+	hdr = (struct dk_cxlflash_hdr *)&buf;
+	if (hdr->version != 0) {
+		pr_err("%s: Version %u not supported for %s\n",
+		       __func__, hdr->version, decode_ioctl(cmd));
+		rc = -EINVAL;
+		goto cxlflash_ioctl_exit;
+	}
+
+	rc = do_ioctl(sdev, (void *)&buf);
+	if (likely(!rc))
+		if (unlikely(copy_to_user(arg, &buf, size))) {
+			pr_err("%s: copy_to_user() fail! "
+			       "size=%lu cmd=%d (%s) arg=%p\n",
+			       __func__, size, cmd, decode_ioctl(cmd), arg);
+			rc = -EFAULT;
+		}
+
+	/* fall through to exit */
+
+cxlflash_ioctl_exit:
+	if (unlikely(rc && known_ioctl))
+		pr_err("%s: ioctl %s (%08X) on dev(%d/%d/%d/%llu) "
+		       "returned rc %d\n", __func__,
+		       decode_ioctl(cmd), cmd, shost->host_no,
+		       sdev->channel, sdev->id, sdev->lun, rc);
+	else
+		pr_debug("%s: ioctl %s (%08X) on dev(%d/%d/%d/%llu) "
+			 "returned rc %d\n", __func__, decode_ioctl(cmd),
+			 cmd, shost->host_no, sdev->channel, sdev->id,
+			 sdev->lun, rc);
+	return rc;
+}
+
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
new file mode 100644
index 0000000..1bf9f60
--- /dev/null
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -0,0 +1,210 @@
+/*
+ * CXL Flash Device Driver
+ *
+ * Written by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>, IBM Corporation
+ *             Matthew R. Ochs <mrochs@linux.vnet.ibm.com>, IBM Corporation
+ *
+ * Copyright (C) 2015 IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _CXLFLASH_SUPERPIPE_H
+#define _CXLFLASH_SUPERPIPE_H
+
+extern struct cxlflash_global global;
+
+/*----------------------------------------------------------------------------*/
+/* Constants                                                                  */
+/*----------------------------------------------------------------------------*/
+
+#define SL_INI_SINI_MARKER      0x53494e49
+#define SL_INI_ELMD_MARKER      0x454c4d44
+/*----------------------------------------------------------------------------*/
+/* Types                                                                      */
+/*----------------------------------------------------------------------------*/
+
+#define MAX_AUN_CLONE_CNT    0xFF
+
+/*
+ * Terminology: use afu (and not adapter) to refer to the HW.
+ * Adapter is the entire slot and includes PSL out of which
+ * only the AFU is visible to user space.
+ */
+
+/* Chunk size parms: note sislite minimum chunk size is
+   0x10000 LBAs corresponding to a NMASK or 16.
+*/
+#define MC_RHT_NMASK      16	/* in bits */
+#define MC_CHUNK_SIZE     (1 << MC_RHT_NMASK)	/* in LBAs, see mclient.h */
+#define MC_CHUNK_SHIFT    MC_RHT_NMASK	/* shift to go from LBA to chunk# */
+#define LXT_LUNIDX_SHIFT  8	/* LXT entry, shift for LUN index */
+#define LXT_PERM_SHIFT    4	/* LXT entry, shift for permission bits */
+
+/* LXT tables are allocated dynamically in groups. This is done to
+   avoid a malloc/free overhead each time the LXT has to grow
+   or shrink.
+
+   Based on the current lxt_cnt (used), it is always possible to
+   know how many are allocated (used+free). The number of allocated
+   entries is not stored anywhere.
+
+   The LXT table is re-allocated whenever it needs to cross into
+   another group.
+*/
+#define LXT_GROUP_SIZE          8
+#define LXT_NUM_GROUPS(lxt_cnt) (((lxt_cnt) + 7)/8)	/* alloc'ed groups */
+
+#define MC_DISCOVERY_TIMEOUT 5  /* 5 secs */
+
+enum lun_mode {
+	MODE_NONE = 0,
+	MODE_VIRTUAL,
+	MODE_PHYSICAL
+};
+
+/* SCSI Defines                                                          */
+
+struct request_sense_data  {
+	uint8_t     err_code;        /* error class and code   */
+	uint8_t     rsvd0;
+	uint8_t     sense_key;
+#define CXLFLASH_VENDOR_UNIQUE         0x09
+#define CXLFLASH_EQUAL_CMD             0x0C
+	uint8_t     sense_byte0;
+	uint8_t     sense_byte1;
+	uint8_t     sense_byte2;
+	uint8_t     sense_byte3;
+	uint8_t     add_sense_length;
+	uint8_t     add_sense_byte0;
+	uint8_t     add_sense_byte1;
+	uint8_t     add_sense_byte2;
+	uint8_t     add_sense_byte3;
+	uint8_t     add_sense_key;
+	uint8_t     add_sense_qualifier;
+	uint8_t     fru;
+	uint8_t     flag_byte;
+	uint8_t     field_ptrM;
+	uint8_t     field_ptrL;
+};
+
+struct ba_lun {
+	u64 lun_id;
+	u64 wwpn;
+	size_t lsize;		/* LUN size in number of LBAs             */
+	size_t lba_size;	/* LBA size in number of bytes            */
+	size_t au_size;		/* Allocation Unit size in number of LBAs */
+	void *ba_lun_handle;
+};
+
+struct ba_lun_info {
+	u64 *lun_alloc_map;
+	u32 lun_bmap_size;
+	u32 total_aus;
+	u64 free_aun_cnt;
+
+	/* indices to be used for elevator lookup of free map */
+	u32 free_low_idx;
+	u32 free_curr_idx;
+	u32 free_high_idx;
+
+	u8 *aun_clone_map;
+};
+
+/* Block Allocator */
+struct blka {
+	struct ba_lun ba_lun;
+	u64 nchunk;		/* number of chunks */
+	struct mutex mutex;
+};
+
+/* LUN discovery results are in lun_info */
+struct lun_info {
+	u64 lun_id;		/* from REPORT_LUNS */
+	u64 max_lba;		/* from read cap(16) */
+	u32 blk_len;		/* from read cap(16) */
+	u32 lun_index;
+	int users;		/* Number of users w/ references to LUN */
+	enum lun_mode mode;	/* NONE, VIRTUAL, PHYSICAL */
+
+	__u8 wwid[16];
+
+	spinlock_t slock;
+
+	struct blka blka;
+	struct scsi_device *sdev;
+	struct list_head list;
+};
+
+struct lun_access {
+	struct lun_info *lun_info;
+	struct scsi_device *sdev;
+	struct list_head list;
+};
+
+enum ctx_ctrl {
+	CTX_CTRL_CLONE		= (1 << 1),
+	CTX_CTRL_ERR		= (1 << 2),
+	CTX_CTRL_ERR_FALLBACK	= (1 << 3),
+	CTX_CTRL_NOPID		= (1 << 4)
+};
+
+#define ENCODE_CTXID(_ctx, _id)	(((((u64)_ctx) & 0xFFFFFFFF0) << 28) | _id)
+#define DECODE_CTXID(_val)	(_val & 0xFFFFFFFF)
+
+struct ctx_info {
+	struct sisl_ctrl_map *ctrl_map; /* initialized at startup */
+	struct sisl_rht_entry *rht_start; /* 1 page (req'd for alignment),
+					     alloc/free on attach/detach */
+	u32 rht_out;		/* Number of checked out RHT entries */
+	u32 rht_perms;		/* User-defined permissions for RHT entries */
+	struct lun_info **rht_lun; /* Mapping of RHT entries to LUNs */
+
+	struct cxl_ioctl_start_work work;
+	u64 ctxid;
+	int lfd;
+	pid_t pid;
+	atomic_t nrefs;	/* Number of active references, must be 0 for removal */
+	bool err_recovery_active;
+	struct cxl_context *ctx;
+	struct list_head luns;	/* LUNs attached to this context */
+	const struct vm_operations_struct *cxl_mmap_vmops;
+	struct address_space *mapping;
+	struct list_head list; /* Link contexts in error recovery */
+};
+
+struct cxlflash_global {
+	spinlock_t slock;
+	struct list_head luns;  /* list of lun_info structs */
+	struct page *err_page; /* One page of all 0xF for error notification */
+};
+
+
+int cxlflash_vlun_resize(struct scsi_device *, struct dk_cxlflash_resize *);
+
+int cxlflash_disk_release(struct scsi_device *, struct dk_cxlflash_release *);
+
+int cxlflash_disk_clone(struct scsi_device *, struct dk_cxlflash_clone *);
+
+int cxlflash_disk_virtual_open(struct scsi_device *, void *);
+
+int cxlflash_lun_attach(struct lun_info *, enum lun_mode);
+void cxlflash_lun_detach(struct lun_info *);
+
+int cxlflash_check_status(struct afu_cmd *);
+
+struct ctx_info *get_context(struct cxlflash_cfg *, u64, struct lun_info *,
+			     enum ctx_ctrl);
+
+struct sisl_rht_entry *get_rhte(struct ctx_info *, res_hndl_t,
+				struct lun_info *);
+
+struct sisl_rht_entry *rhte_checkout(struct ctx_info *, struct lun_info *);
+void rhte_checkin(struct ctx_info *, struct sisl_rht_entry *);
+
+void cxlflash_ba_terminate(struct ba_lun *);
+
+#endif /* ifndef _CXLFLASH_SUPERPIPE_H */
diff --git a/include/uapi/scsi/cxlflash_ioctl.h b/include/uapi/scsi/cxlflash_ioctl.h
new file mode 100644
index 0000000..dd1f954
--- /dev/null
+++ b/include/uapi/scsi/cxlflash_ioctl.h
@@ -0,0 +1,159 @@
+/*
+ * CXL Flash Device Driver
+ *
+ * Written by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>, IBM Corporation
+ *             Matthew R. Ochs <mrochs@linux.vnet.ibm.com>, IBM Corporation
+ *
+ * Copyright (C) 2015 IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _CXLFLASH_IOCTL_H
+#define _CXLFLASH_IOCTL_H
+
+#include <linux/types.h>
+
+/*
+ * Structure and flag definitions CXL Flash superpipe ioctls
+ */
+
+struct dk_cxlflash_hdr {
+	__u16 version;			/* Version data */
+	__u16 rsvd[3];			/* Reserved for future use */
+	__u64 flags;			/* Input flags */
+	__u64 return_flags;		/* Returned flags */
+};
+
+/*
+ * Notes:
+ * -----
+ * The 'context_id' field of all ioctl structures contains the context
+ * identifier for a context in the lower 32-bits (upper 32-bits are not
+ * to be used when identifying a context to the AFU). That said, the value
+ * in its entirety (all 64-bits) is to be treated as an opaque cookie and
+ * should be presented as such when issuing ioctls.
+ *
+ * For DK_CXLFLASH_ATTACH ioctl, user specifies read/write access
+ * permissions via the O_RDONLY, O_WRONLY, and O_RDWR flags defined in
+ * the fcntl.h header file.
+ */
+#define DK_CXLFLASH_ATTACH_REUSE_CONTEXT	0x8000000000000000ULL
+
+struct dk_cxlflash_attach {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 num_interrupts;		/* Requested number of interrupts */
+	__u64 context_id;		/* Returned context */
+	__u64 mmio_size;		/* Returned size of MMIO area */
+	__u64 block_size;		/* Returned block size, in bytes */
+	__u64 adap_fd;			/* Returned adapter file descriptor */
+	__u64 last_lba;			/* Returned last LBA on the device */
+	__u64 max_xfer;			/* Returned max transfer size, blocks */
+};
+
+struct dk_cxlflash_detach {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 context_id;		/* Context to detach */
+};
+
+struct dk_cxlflash_udirect {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 context_id;		/* Context to own physical resources */
+	__u64 rsrc_handle;		/* Returned resource handle */
+	__u64 last_lba;			/* Returned last LBA on the device */
+};
+
+struct dk_cxlflash_uvirtual {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 context_id;		/* Context to own virtual resources */
+	__u64 lun_size;			/* Requested size, in 4K blocks */
+	__u64 rsrc_handle;		/* Returned resource handle */
+	__u64 last_lba;			/* Returned last LBA of LUN */
+};
+
+struct dk_cxlflash_release {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 context_id;		/* Context owning resources */
+	__u64 rsrc_handle;		/* Resource handle to release */
+};
+
+struct dk_cxlflash_resize {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 context_id;		/* Context owning resources */
+	__u64 rsrc_handle;		/* Resource handle of LUN to resize */
+	__u64 req_size;			/* New requested size, in 4K blocks */
+	__u64 last_lba;			/* Returned last LBA of LUN */
+};
+
+struct dk_cxlflash_clone {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 context_id_src;		/* Context to clone from */
+	__u64 context_id_dst;		/* Context to clone to */
+	__u64 adap_fd_src;		/* Source context adapter fd */
+};
+
+#define DK_CXLFLASH_VERIFY_SENSE_LEN	18
+#define DK_CXLFLASH_VERIFY_HINT_SENSE	0x8000000000000000ULL
+
+struct dk_cxlflash_verify {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 context_id;		/* Context owning resources to verify */
+	__u64 rsrc_handle;		/* Resource handle of LUN */
+	__u64 hint;			/* Reasons for verify */
+	__u64 last_lba;			/* Returned last LBA of device */
+	__u8 sense_data[DK_CXLFLASH_VERIFY_SENSE_LEN]; /* SCSI sense data */
+	__u8 pad[6];			/* Pad to next 8-byte boundary */
+};
+
+struct dk_cxlflash_recover_afu {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 reason;			/* Reason for recovery request */
+	__u64 context_id;		/* Context to recover / updated ID */
+	__u64 mmio_size;		/* Returned size of MMIO area */
+	__u64 adap_fd;			/* Returned adapter file descriptor */
+};
+
+#define DK_CXLFLASH_MANAGE_LUN_WWID_LEN			16
+#define DK_CXLFLASH_MANAGE_LUN_ENABLE_SUPERPIPE		0x8000000000000000ULL
+#define DK_CXLFLASH_MANAGE_LUN_DISABLE_SUPERPIPE	0x4000000000000000ULL
+#define DK_CXLFLASH_MANAGE_LUN_ALL_PORTS_ACCESSIBLE	0x2000000000000000ULL
+
+struct dk_cxlflash_manage_lun {
+	struct dk_cxlflash_hdr hdr;			/* Common fields */
+	__u8 wwid[DK_CXLFLASH_MANAGE_LUN_WWID_LEN];	/* Page83 WWID, NAA-6 */
+};
+
+union cxlflash_ioctls {
+	struct dk_cxlflash_attach attach;
+	struct dk_cxlflash_detach detach;
+	struct dk_cxlflash_udirect udirect;
+	struct dk_cxlflash_uvirtual uvirtual;
+	struct dk_cxlflash_release release;
+	struct dk_cxlflash_resize resize;
+	struct dk_cxlflash_clone clone;
+	struct dk_cxlflash_verify verify;
+	struct dk_cxlflash_recover_afu recover_afu;
+	struct dk_cxlflash_manage_lun manage_lun;
+};
+
+#define MAX_CXLFLASH_IOCTL_SZ	(sizeof(union cxlflash_ioctls))
+
+
+#define CXL_MAGIC 0xCA
+#define CXL_IOW(_n, _s)	_IOW(CXL_MAGIC, _n, struct _s)
+
+#define DK_CXLFLASH_ATTACH		CXL_IOW(0x80, dk_cxlflash_attach)
+#define DK_CXLFLASH_USER_DIRECT		CXL_IOW(0x81, dk_cxlflash_udirect)
+#define DK_CXLFLASH_USER_VIRTUAL	CXL_IOW(0x82, dk_cxlflash_uvirtual)
+#define DK_CXLFLASH_VLUN_RESIZE		CXL_IOW(0x83, dk_cxlflash_resize)
+#define DK_CXLFLASH_RELEASE		CXL_IOW(0x84, dk_cxlflash_release)
+#define DK_CXLFLASH_DETACH		CXL_IOW(0x85, dk_cxlflash_detach)
+#define DK_CXLFLASH_VERIFY		CXL_IOW(0x86, dk_cxlflash_verify)
+#define DK_CXLFLASH_CLONE		CXL_IOW(0x87, dk_cxlflash_clone)
+#define DK_CXLFLASH_RECOVER_AFU		CXL_IOW(0x88, dk_cxlflash_recover_afu)
+#define DK_CXLFLASH_MANAGE_LUN		CXL_IOW(0x89, dk_cxlflash_manage_lun)
+
+#endif /* ifndef _CXLFLASH_IOCTL_H */
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
