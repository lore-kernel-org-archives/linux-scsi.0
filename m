From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v4 2/3] cxlflash: Superpipe support
Date: Mon, 10 Aug 2015 12:09:48 -0500
Message-ID: <1439226588-7886-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:43043 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbbHJRK4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2015 13:10:56 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 10 Aug 2015 11:10:55 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 587E619D804A
	for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2015 11:01:50 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7AHAr4845940868
	for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2015 10:10:53 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7AHApuS012631
	for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2015 11:10:52 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Add superpipe supporting infrastructure to device driver for the IBM CXL
Flash adapter. This patch allows userspace applications to take advantage
of the accelerated I/O features that this adapter provides and bypass the
traditional filesystem stack.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 Documentation/ioctl/ioctl-number.txt |    1 +
 Documentation/powerpc/cxlflash.txt   |  297 +++++
 drivers/scsi/cxlflash/Makefile       |    2 +-
 drivers/scsi/cxlflash/common.h       |   19 +
 drivers/scsi/cxlflash/main.c         |   21 +-
 drivers/scsi/cxlflash/superpipe.c    | 2206 ++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/superpipe.h    |  127 ++
 include/uapi/scsi/Kbuild             |    1 +
 include/uapi/scsi/cxlflash_ioctl.h   |  139 +++
 9 files changed, 2810 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/powerpc/cxlflash.txt
 create mode 100644 drivers/scsi/cxlflash/superpipe.c
 create mode 100644 drivers/scsi/cxlflash/superpipe.h
 create mode 100644 include/uapi/scsi/cxlflash_ioctl.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index fdd35bf..67273e1 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -315,6 +315,7 @@ Code  Seq#(hex)	Include File		Comments
 0xC0	00-0F	linux/usb/iowarrior.h
 0xC9	00-0F	uapi/cxl-memcpy.h       Reserved for non-upstream prototype
 0xCA	00-0F	uapi/misc/cxl.h
+0xCA	80-8F	uapi/scsi/cxlflash_ioctl.h
 0xCB	00-1F	CBM serial IEC bus	in development:
 					<mailto:michael.klein@puffin.lb.shuttle.de>
 0xCD	01	linux/reiserfs_fs.h
diff --git a/Documentation/powerpc/cxlflash.txt b/Documentation/powerpc/cxlflash.txt
new file mode 100644
index 0000000..4a59f1a
--- /dev/null
+++ b/Documentation/powerpc/cxlflash.txt
@@ -0,0 +1,297 @@
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
+    This ioctl is used to detect various changes such as the capacity of
+    the disk changing, the number of LUNs visible changing, etc. In cases
+    where the changes affect the application (such as a LUN resize), the
+    cxlflash driver will report the changed state to the application.
+
+DK_CXLFLASH_RECOVER_AFU
+-----------------------
+    This ioctl is used to drive recovery (if such an action is warranted)
+    of a specified user context. Any state associated with the user context
+    is re-established upon successful recovery.
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
index 7e663f4..a890a9a 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -107,6 +107,18 @@ struct cxlflash_cfg {
 	struct pci_pool *cxlflash_cmd_pool;
 	struct pci_dev *parent_dev;
 
+	atomic_t recovery_threads;
+	struct mutex ctx_recovery_mutex;
+	struct mutex ctx_tbl_list_mutex;
+	struct ctx_info *ctx_tbl[MAX_CONTEXT];
+	struct list_head ctx_err_recovery; /* contexts w/ recovery pending */
+	struct file_operations cxl_fops;
+
+	atomic_t num_user_contexts;
+
+	struct list_head lluns; /* list of llun_info structs */
+	spinlock_t slock;
+
 	wait_queue_head_t tmf_waitq;
 	bool tmf_active;
 	wait_queue_head_t limbo_waitq;
@@ -182,5 +194,12 @@ int cxlflash_afu_reset(struct cxlflash_cfg *);
 struct afu_cmd *cxlflash_cmd_checkout(struct afu *);
 void cxlflash_cmd_checkin(struct afu_cmd *);
 int cxlflash_afu_sync(struct afu *, ctx_hndl_t, res_hndl_t, u8);
+void cxlflash_list_init(void);
+void cxlflash_list_terminate(void);
+int cxlflash_ioctl(struct scsi_device *, int, void __user *);
+void cxlflash_stop_term_user_contexts(struct cxlflash_cfg *);
+int cxlflash_mark_contexts_error(struct cxlflash_cfg *);
+void cxlflash_term_luns(struct cxlflash_cfg *);
+
 #endif /* ifndef _CXLFLASH_COMMON_H */
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 18359d4..eb1bdd7 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -519,7 +519,7 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
 	case STATE_NORMAL:
 		cfg->state = STATE_LIMBO;
 		scsi_block_requests(cfg->host);
-
+		cxlflash_mark_contexts_error(cfg);
 		rcr = cxlflash_afu_reset(cfg);
 		if (!rcr)
 			rc = FAILED;
@@ -723,6 +723,7 @@ static struct scsi_host_template driver_template = {
 	.module = THIS_MODULE,
 	.name = CXLFLASH_ADAPTER_NAME,
 	.info = cxlflash_driver_info,
+	.ioctl = cxlflash_ioctl,
 	.proc_name = CXLFLASH_NAME,
 	.queuecommand = cxlflash_queuecommand,
 	.eh_device_reset_handler = cxlflash_eh_device_reset_handler,
@@ -870,9 +871,11 @@ static void cxlflash_remove(struct pci_dev *pdev)
 	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
 
 	cfg->state = STATE_FAILTERM;
+	cxlflash_stop_term_user_contexts(cfg);
 
 	switch (cfg->init_state) {
 	case INIT_STATE_SCSI:
+		cxlflash_term_luns(cfg);
 		scsi_remove_host(cfg->host);
 		scsi_host_put(cfg->host);
 		/* Fall through */
@@ -2272,6 +2275,11 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	INIT_WORK(&cfg->work_q, cxlflash_worker_thread);
 	cfg->lr_state = LINK_RESET_INVALID;
 	cfg->lr_port = -1;
+	mutex_init(&cfg->ctx_tbl_list_mutex);
+	mutex_init(&cfg->ctx_recovery_mutex);
+	spin_lock_init(&cfg->slock);
+	INIT_LIST_HEAD(&cfg->ctx_err_recovery);
+	INIT_LIST_HEAD(&cfg->lluns);
 
 	pci_set_drvdata(pdev, cfg);
 
@@ -2333,7 +2341,9 @@ out_remove:
 static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
 						    pci_channel_state_t state)
 {
+	int rc = 0;
 	struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
+	struct device *dev = &cfg->dev->dev;
 
 	pr_debug("%s: pdev=%p state=%u\n", __func__, pdev, state);
 
@@ -2343,7 +2353,10 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
 
 		/* Turn off legacy I/O */
 		scsi_block_requests(cfg->host);
-
+		rc = cxlflash_mark_contexts_error(cfg);
+		if (unlikely(rc))
+			dev_err(dev, "%s: Failed to mark user contexts!(%d)\n",
+				__func__, rc);
 		term_mc(cfg, UNDO_START);
 		stop_afu(cfg);
 
@@ -2427,6 +2440,8 @@ static int __init init_cxlflash(void)
 	pr_info("%s: IBM Power CXL Flash Adapter: %s\n",
 		__func__, CXLFLASH_DRIVER_DATE);
 
+	cxlflash_list_init();
+
 	return pci_register_driver(&cxlflash_driver);
 }
 
@@ -2435,6 +2450,8 @@ static int __init init_cxlflash(void)
  */
 static void __exit exit_cxlflash(void)
 {
+	cxlflash_list_terminate();
+
 	pci_unregister_driver(&cxlflash_driver);
 }
 
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
new file mode 100644
index 0000000..802f1f5
--- /dev/null
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -0,0 +1,2206 @@
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
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_eh.h>
+#include <uapi/scsi/cxlflash_ioctl.h>
+
+#include "sislite.h"
+#include "common.h"
+#include "superpipe.h"
+
+static struct cxlflash_global global;
+
+/**
+ * marshal_det_to_rele() - translate detach to release structure
+ * @detach:	Destination structure for the translate/copy.
+ * @rele:	Source structure from which to translate/copy.
+ */
+static void marshal_det_to_rele(struct dk_cxlflash_detach *detach,
+				struct dk_cxlflash_release *release)
+{
+	release->hdr = detach->hdr;
+	release->context_id = detach->context_id;
+}
+
+/**
+ * create_local() - allocate and initialize a local LUN information structure
+ * @sdev:	SCSI device associated with LUN.
+ * @wwid:	World Wide Node Name for LUN.
+ *
+ * Return: Allocated local llun_info structure on success, NULL on failure
+ */
+static struct llun_info *create_local(struct scsi_device *sdev, u8 *wwid)
+{
+	struct llun_info *lli = NULL;
+
+	lli = kzalloc(sizeof(*lli), GFP_KERNEL);
+	if (unlikely(!lli)) {
+		pr_err("%s: could not allocate lli\n", __func__);
+		goto out;
+	}
+
+	lli->sdev = sdev;
+	lli->newly_created = true;
+	lli->host_no = sdev->host->host_no;
+
+	memcpy(lli->wwid, wwid, DK_CXLFLASH_MANAGE_LUN_WWID_LEN);
+out:
+	return lli;
+}
+
+/**
+ * create_global() - allocate and initialize a global LUN information structure
+ * @sdev:	SCSI device associated with LUN.
+ * @wwid:	World Wide Node Name for LUN.
+ *
+ * Return: Allocated global glun_info structure on success, NULL on failure
+ */
+static struct glun_info *create_global(struct scsi_device *sdev, u8 *wwid)
+{
+	struct glun_info *gli = NULL;
+
+	gli = kzalloc(sizeof(*gli), GFP_KERNEL);
+	if (unlikely(!gli)) {
+		pr_err("%s: could not allocate gli\n", __func__);
+		goto out;
+	}
+
+	memcpy(gli->wwid, wwid, DK_CXLFLASH_MANAGE_LUN_WWID_LEN);
+out:
+	return gli;
+}
+
+/**
+ * lookup_local() - find a local LUN information structure by WWID
+ * @cfg:	Internal structure associated with the host.
+ * @wwid:	WWID associated with LUN.
+ *
+ * Return: Found local lun_info structure on success, NULL on failure
+ */
+static struct llun_info *lookup_local(struct cxlflash_cfg *cfg, u8 *wwid)
+{
+	struct llun_info *lli, *temp;
+	ulong lock_flags;
+
+	spin_lock_irqsave(&cfg->slock, lock_flags);
+
+	list_for_each_entry_safe(lli, temp, &cfg->lluns, list)
+		if (!memcmp(lli->wwid, wwid, DK_CXLFLASH_MANAGE_LUN_WWID_LEN)) {
+			lli->newly_created = false;
+			spin_unlock_irqrestore(&cfg->slock, lock_flags);
+			return lli;
+		}
+
+	spin_unlock_irqrestore(&cfg->slock, lock_flags);
+	return NULL;
+}
+
+/**
+ * lookup_global() - find a global LUN information structure by WWID
+ * @wwid:	WWID associated with LUN.
+ *
+ * Return: Found global lun_info structure on success, NULL on failure
+ */
+static struct glun_info *lookup_global(u8 *wwid)
+{
+	struct glun_info *gli, *temp;
+	ulong lock_flags;
+
+	spin_lock_irqsave(&global.slock, lock_flags);
+
+	list_for_each_entry_safe(gli, temp, &global.gluns, list)
+		if (!memcmp(gli->wwid, wwid, DK_CXLFLASH_MANAGE_LUN_WWID_LEN)) {
+			spin_unlock_irqrestore(&global.slock, lock_flags);
+			return gli;
+		}
+
+	spin_unlock_irqrestore(&global.slock, lock_flags);
+	return NULL;
+}
+
+/**
+ * lookup_lun() - find or create a local LUN information structure
+ * @sdev:	SCSI device associated with LUN.
+ * @wwid:	WWID associated with LUN.
+ *
+ * When a local LUN is not found and a global LUN is also not found, both
+ * a global LUN and local LUN are created. The global LUN is added to the
+ * global list and the local LUN is returned.
+ *
+ * Return: Found/Allocated local lun_info structure on success, NULL on failure
+ */
+static struct llun_info *lookup_lun(struct scsi_device *sdev, u8 *wwid)
+{
+	struct llun_info *lli = NULL;
+	struct glun_info *gli = NULL;
+	struct Scsi_Host *shost = sdev->host;
+	struct cxlflash_cfg *cfg = shost_priv(shost);
+	ulong lock_flags;
+
+	if (unlikely(!wwid))
+		goto out;
+
+	lli = lookup_local(cfg, wwid);
+	if (lli)
+		goto out;
+
+	lli = create_local(sdev, wwid);
+	if (unlikely(!lli))
+		goto out;
+
+	gli = lookup_global(wwid);
+	if (gli) {
+		lli->parent = gli;
+		spin_lock_irqsave(&cfg->slock, lock_flags);
+		list_add(&lli->list, &cfg->lluns);
+		spin_unlock_irqrestore(&cfg->slock, lock_flags);
+		goto out;
+	}
+
+	gli = create_global(sdev, wwid);
+	if (unlikely(!gli)) {
+		kfree(lli);
+		lli = NULL;
+		goto out;
+	}
+
+	lli->parent = gli;
+	spin_lock_irqsave(&cfg->slock, lock_flags);
+	list_add(&lli->list, &cfg->lluns);
+	spin_unlock_irqrestore(&cfg->slock, lock_flags);
+
+	spin_lock_irqsave(&global.slock, lock_flags);
+	list_add(&gli->list, &global.gluns);
+	spin_unlock_irqrestore(&global.slock, lock_flags);
+
+out:
+	pr_debug("%s: returning %p\n", __func__, lli);
+	return lli;
+}
+
+/**
+ * cxlflash_term_luns() - Delete all entries from local lun list, free.
+ * @cfg:	Internal structure associated with the host.
+ */
+void cxlflash_term_luns(struct cxlflash_cfg *cfg)
+{
+	struct llun_info *lli, *temp;
+	ulong lock_flags;
+
+	spin_lock_irqsave(&cfg->slock, lock_flags);
+	list_for_each_entry_safe(lli, temp, &cfg->lluns, list) {
+		list_del(&lli->list);
+		kfree(lli);
+	}
+	spin_unlock_irqrestore(&cfg->slock, lock_flags);
+}
+
+/**
+ * cxlflash_list_init() - initializes the global LUN list
+ */
+void cxlflash_list_init(void)
+{
+	INIT_LIST_HEAD(&global.gluns);
+	spin_lock_init(&global.slock);
+	global.err_page = NULL;
+}
+
+/**
+ * cxlflash_list_terminate() - frees resources associated with global LUN list
+ */
+void cxlflash_list_terminate(void)
+{
+	struct glun_info *gli, *temp;
+	ulong flags = 0;
+
+	spin_lock_irqsave(&global.slock, flags);
+	list_for_each_entry_safe(gli, temp, &global.gluns, list) {
+		list_del(&gli->list);
+		kfree(gli);
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
+ * cxlflash_stop_term_user_contexts() - stops/terminates known user contexts
+ * @cfg:	Internal structure associated with the host.
+ *
+ * When the host needs to go down, all users must be quiesced and their
+ * memory freed. This is accomplished by putting the contexts in error
+ * state which will notify the user and let them 'drive' the teardown.
+ * Meanwhile, this routine camps until all user contexts have been removed.
+ */
+void cxlflash_stop_term_user_contexts(struct cxlflash_cfg *cfg)
+{
+	int i, found;
+
+	cxlflash_mark_contexts_error(cfg);
+
+	while (true) {
+		found = false;
+
+		for (i = 0; i < MAX_CONTEXT; i++)
+			if (cfg->ctx_tbl[i]) {
+				found = true;
+				break;
+			}
+
+		if (!found && list_empty(&cfg->ctx_err_recovery))
+			return;
+
+		pr_debug("%s: Wait for user context to quiesce...\n", __func__);
+		wake_up_all(&cfg->limbo_waitq);
+		ssleep(1);
+	}
+}
+
+/**
+ * find_error_context() - locates a context by cookie on the error recovery list
+ * @cfg:	Internal structure associated with the host.
+ * @rctxid:	Desired context by id.
+ * @file:	Desired context by file.
+ *
+ * Return: Found context on success, NULL on failure
+ */
+static struct ctx_info *find_error_context(struct cxlflash_cfg *cfg, u64 rctxid,
+					   struct file *file)
+{
+	struct ctx_info *ctxi;
+
+	list_for_each_entry(ctxi, &cfg->ctx_err_recovery, list)
+		if ((ctxi->ctxid == rctxid) || (ctxi->file == file))
+			return ctxi;
+
+	return NULL;
+}
+
+/**
+ * get_context() - obtains a validated and locked context reference
+ * @cfg:	Internal structure associated with the host.
+ * @rctxid:	Desired context (raw, undecoded format).
+ * @arg:	LUN information or file associated with request.
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
+struct ctx_info *get_context(struct cxlflash_cfg *cfg, u64 rctxid,
+			     void *arg, enum ctx_ctrl ctx_ctrl)
+{
+	struct ctx_info *ctxi = NULL;
+	struct lun_access *lun_access = NULL;
+	struct file *file = NULL;
+	struct llun_info *lli = arg;
+	u64 ctxid = DECODE_CTXID(rctxid);
+	int rc;
+	pid_t pid = current->tgid, ctxpid = 0;
+
+	if (ctx_ctrl & CTX_CTRL_FILE) {
+		lli = NULL;
+		file = (struct file *)arg;
+	}
+
+	if (ctx_ctrl & CTX_CTRL_CLONE)
+		pid = current->parent->tgid;
+
+	if (likely(ctxid < MAX_CONTEXT)) {
+retry:
+		rc = mutex_lock_interruptible(&cfg->ctx_tbl_list_mutex);
+		if (rc)
+			goto out;
+
+		ctxi = cfg->ctx_tbl[ctxid];
+		if (ctxi)
+			if ((file && (ctxi->file != file)) ||
+			    (!file && (ctxi->ctxid != rctxid)))
+				ctxi = NULL;
+
+		if ((ctx_ctrl & CTX_CTRL_ERR) ||
+		    (!ctxi && (ctx_ctrl & CTX_CTRL_ERR_FALLBACK)))
+			ctxi = find_error_context(cfg, rctxid, file);
+		if (!ctxi) {
+			mutex_unlock(&cfg->ctx_tbl_list_mutex);
+			goto out;
+		}
+
+		/*
+		 * Need to acquire ownership of the context while still under
+		 * the table/list lock to serialize with a remove thread. Use
+		 * the 'try' to avoid stalling the table/list lock for a single
+		 * context.
+		 */
+		rc = mutex_trylock(&ctxi->mutex);
+		mutex_unlock(&cfg->ctx_tbl_list_mutex);
+		if (!rc)
+			goto retry;
+
+		if (ctxi->unavail)
+			goto denied;
+
+		ctxpid = ctxi->pid;
+		if (likely(!(ctx_ctrl & CTX_CTRL_NOPID)))
+			if (pid != ctxpid)
+				goto denied;
+
+		if (lli) {
+			list_for_each_entry(lun_access, &ctxi->luns, list)
+				if (lun_access->lli == lli)
+					goto out;
+			goto denied;
+		}
+	}
+
+out:
+	pr_debug("%s: rctxid=%016llX ctxinfo=%p ctxpid=%u pid=%u ctx_ctrl=%u\n",
+		 __func__, rctxid, ctxi, ctxpid, pid, ctx_ctrl);
+
+	return ctxi;
+
+denied:
+	mutex_unlock(&ctxi->mutex);
+	ctxi = NULL;
+	goto out;
+}
+
+/**
+ * afu_attach() - attach a context to the AFU
+ * @cfg:	Internal structure associated with the host.
+ * @ctxi:	Context to attach.
+ *
+ * Upon setting the context capabilities, they must be confirmed with
+ * a read back operation as the context might have been closed since
+ * the mailbox was unlocked. When this occurs, registration is failed.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int afu_attach(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
+{
+	struct afu *afu = cfg->afu;
+	struct sisl_ctrl_map *ctrl_map = ctxi->ctrl_map;
+	int rc = 0;
+	u64 val;
+
+	/* Unlock cap and restrict user to read/write cmds in translated mode */
+	readq_be(&ctrl_map->mbox_r);
+	val = (SISL_CTX_CAP_READ_CMD | SISL_CTX_CAP_WRITE_CMD);
+	writeq_be(val, &ctrl_map->ctx_cap);
+	val = readq_be(&ctrl_map->ctx_cap);
+	if (val != (SISL_CTX_CAP_READ_CMD | SISL_CTX_CAP_WRITE_CMD)) {
+		pr_err("%s: ctx may be closed val=%016llX\n", __func__, val);
+		rc = -EAGAIN;
+		goto out;
+	}
+
+	/* Set up MMIO registers pointing to the RHT */
+	writeq_be((u64)ctxi->rht_start, &ctrl_map->rht_start);
+	val = SISL_RHT_CNT_ID((u64)MAX_RHT_PER_CONTEXT, (u64)(afu->ctx_hndl));
+	writeq_be(val, &ctrl_map->rht_cnt_id);
+out:
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+}
+
+/**
+ * read_cap16() - issues a SCSI READ_CAP16 command
+ * @sdev:	SCSI device associated with LUN.
+ * @lli:	LUN destined for capacity request.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
+{
+	struct glun_info *gli = lli->parent;
+	u8 *buf = NULL;
+	u8 *cmd_buf = NULL;
+	u8 *scsi_cmd = NULL;
+	u8 *sense_buf = NULL;
+	int rc = 0;
+	int result = 0;
+	int retry_cnt = 0;
+	u32 tout = (MC_DISCOVERY_TIMEOUT * HZ);
+	size_t size;
+
+	size = CMD_BUFSIZE + MAX_COMMAND_SIZE + SCSI_SENSE_BUFFERSIZE;
+retry:
+	buf = kzalloc(size, GFP_KERNEL);
+	if (unlikely(!buf)) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	cmd_buf = buf;
+	scsi_cmd = cmd_buf + CMD_BUFSIZE;
+	sense_buf = scsi_cmd + MAX_COMMAND_SIZE;
+
+	scsi_cmd[0] = SERVICE_ACTION_IN_16;	/* read cap(16) */
+	scsi_cmd[1] = SAI_READ_CAPACITY_16;	/* service action */
+	put_unaligned_be32(CMD_BUFSIZE, &scsi_cmd[10]);
+
+	pr_debug("%s: %ssending cmd(0x%x)\n", __func__, retry_cnt ? "re" : "",
+		 scsi_cmd[0]);
+
+	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
+			      CMD_BUFSIZE, sense_buf, tout, 5, 0, NULL);
+
+	if (driver_byte(result) == DRIVER_SENSE) {
+		result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
+		if (result & SAM_STAT_CHECK_CONDITION) {
+			struct scsi_sense_hdr sshdr;
+
+			scsi_normalize_sense(sense_buf, SCSI_SENSE_BUFFERSIZE,
+					    &sshdr);
+			switch (sshdr.sense_key) {
+			case NO_SENSE:
+			case RECOVERED_ERROR:
+				/* fall through */
+			case NOT_READY:
+				result &= ~SAM_STAT_CHECK_CONDITION;
+				break;
+			case UNIT_ATTENTION:
+				switch (sshdr.asc) {
+				case 0x29: /* Power on Reset or Device Reset */
+					/* fall through */
+				case 0x2A: /* Device capacity changed */
+				case 0x3F: /* Report LUNs changed */
+					/* Retry the command once more */
+					if (retry_cnt++ < 1) {
+						kfree(buf);
+						goto retry;
+					}
+				}
+				break;
+			default:
+				break;
+			}
+		}
+	}
+
+	if (result) {
+		pr_err("%s: command failed, result=0x%x\n", __func__, result);
+		rc = -EIO;
+		goto out;
+	}
+
+	/*
+	 * Read cap was successful, grab values from the buffer;
+	 * note that we don't need to worry about unaligned access
+	 * as the buffer is allocated on an aligned boundary.
+	 */
+	spin_lock(&gli->slock);
+	gli->max_lba = be64_to_cpu(*((u64 *)&cmd_buf[0]));
+	gli->blk_len = be32_to_cpu(*((u32 *)&cmd_buf[8]));
+	spin_unlock(&gli->slock);
+
+out:
+	kfree(buf);
+	pr_debug("%s: maxlba=%lld blklen=%d rc=%d\n", __func__,
+		 gli->max_lba, gli->blk_len, rc);
+	return rc;
+}
+
+/**
+ * get_rhte() - obtains validated resource handle table entry reference
+ * @ctxi:	Context owning the resource handle.
+ * @rhndl:	Resource handle associated with entry.
+ * @lli:	LUN associated with request.
+ *
+ * Return: Validated RHTE on success, NULL on failure
+ */
+struct sisl_rht_entry *get_rhte(struct ctx_info *ctxi, res_hndl_t rhndl,
+				struct llun_info *lli)
+{
+	struct sisl_rht_entry *rhte = NULL;
+
+	if (unlikely(!ctxi->rht_start)) {
+		pr_err("%s: Context does not have allocated RHT!\n", __func__);
+		goto out;
+	}
+
+	if (unlikely(rhndl >= MAX_RHT_PER_CONTEXT)) {
+		pr_err("%s: Bad resource handle! (%d)\n", __func__, rhndl);
+		goto out;
+	}
+
+	if (unlikely(ctxi->rht_lun[rhndl] != lli)) {
+		pr_err("%s: Bad resource handle LUN! (%d)\n", __func__, rhndl);
+		goto out;
+	}
+
+	rhte = &ctxi->rht_start[rhndl];
+	if (unlikely(rhte->nmask == 0)) {
+		pr_err("%s: Unopened resource handle! (%d)\n", __func__, rhndl);
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
+ * @ctxi:	Context owning the resource handle.
+ * @lli:	LUN associated with request.
+ *
+ * Return: Free RHTE on success, NULL on failure
+ */
+struct sisl_rht_entry *rhte_checkout(struct ctx_info *ctxi,
+				     struct llun_info *lli)
+{
+	struct sisl_rht_entry *rhte = NULL;
+	int i;
+
+	/* Find a free RHT entry */
+	for (i = 0; i < MAX_RHT_PER_CONTEXT; i++)
+		if (ctxi->rht_start[i].nmask == 0) {
+			rhte = &ctxi->rht_start[i];
+			ctxi->rht_out++;
+			break;
+		}
+
+	if (likely(rhte))
+		ctxi->rht_lun[i] = lli;
+
+	pr_debug("%s: returning rhte=%p (%d)\n", __func__, rhte, i);
+	return rhte;
+}
+
+/**
+ * rhte_checkin() - releases a resource handle table entry
+ * @ctxi:	Context owning the resource handle.
+ * @rhte:	RHTE to release.
+ */
+void rhte_checkin(struct ctx_info *ctxi,
+		  struct sisl_rht_entry *rhte)
+{
+	u32 rsrc_handle = rhte - ctxi->rht_start;
+
+	rhte->nmask = 0;
+	rhte->fp = 0;
+	ctxi->rht_out--;
+	ctxi->rht_lun[rsrc_handle] = NULL;
+}
+
+/**
+ * rhte_format1() - populates a RHTE for format 1
+ * @rhte:	RHTE to populate.
+ * @lun_id:	LUN ID of LUN associated with RHTE.
+ * @perm:	Desired permissions for RHTE.
+ * @port_sel:	Port selection mask
+ */
+static void rht_format1(struct sisl_rht_entry *rhte, u64 lun_id, u32 perm,
+			u32 port_sel)
+{
+	/*
+	 * Populate the Format 1 RHT entry for direct access (physical
+	 * LUN) using the synchronization sequence defined in the
+	 * SISLite specification.
+	 */
+	struct sisl_rht_entry_f1 dummy = { 0 };
+	struct sisl_rht_entry_f1 *rhte_f1 = (struct sisl_rht_entry_f1 *)rhte;
+
+	memset(rhte_f1, 0, sizeof(*rhte_f1));
+	rhte_f1->fp = SISL_RHT_FP(1U, 0);
+	dma_wmb(); /* Make setting of format bit visible */
+
+	rhte_f1->lun_id = lun_id;
+	dma_wmb(); /* Make setting of LUN id visible */
+
+	/*
+	 * Use a dummy RHT Format 1 entry to build the second dword
+	 * of the entry that must be populated in a single write when
+	 * enabled (valid bit set to TRUE).
+	 */
+	dummy.valid = 0x80;
+	dummy.fp = SISL_RHT_FP(1U, perm);
+	dummy.port_sel = port_sel;
+	rhte_f1->dw = dummy.dw;
+
+	dma_wmb(); /* Make remaining RHT entry fields visible */
+}
+
+/**
+ * cxlflash_lun_attach() - attaches a user to a LUN and manages the LUN's mode
+ * @gli:	LUN to attach.
+ * @mode:	Desired mode of the LUN.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int cxlflash_lun_attach(struct glun_info *gli, enum lun_mode mode)
+{
+	int rc = 0;
+
+	spin_lock(&gli->slock);
+	if (gli->mode == MODE_NONE)
+		gli->mode = mode;
+	else if (gli->mode != mode) {
+		pr_err("%s: LUN operating in mode %d, requested mode %d\n",
+		       __func__, gli->mode, mode);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	gli->users++;
+	WARN_ON(gli->users <= 0);
+out:
+	pr_debug("%s: Returning rc=%d gli->mode=%u gli->users=%u\n",
+		 __func__, rc, gli->mode, gli->users);
+	spin_unlock(&gli->slock);
+	return rc;
+}
+
+/**
+ * cxlflash_lun_detach() - detaches a user from a LUN and resets the LUN's mode
+ * @gli:	LUN to detach.
+ *
+ * When resetting the mode, terminate block allocation resources as they
+ * are no longer required (service is safe to call even when block allocation
+ * resources were not present - such as when transitioning from physical mode).
+ * These resources will be reallocated when needed (subsequent transition to
+ * virtual mode).
+ */
+void cxlflash_lun_detach(struct glun_info *gli)
+{
+	spin_lock(&gli->slock);
+	WARN_ON(gli->mode == MODE_NONE);
+	if (--gli->users == 0)
+		gli->mode = MODE_NONE;
+	pr_debug("%s: gli->users=%u\n", __func__, gli->users);
+	WARN_ON(gli->users < 0);
+	spin_unlock(&gli->slock);
+}
+
+/**
+ * _cxlflash_disk_release() - releases the specified resource entry
+ * @sdev:	SCSI device associated with LUN.
+ * @ctxi:	Context owning resources.
+ * @release:	Release ioctl data structure.
+ *
+ * For LUN's in virtual mode, the virtual lun associated with the specified
+ * resource handle is resized to 0 prior to releasing the RHTE. Note that the
+ * AFU sync should _not_ be performed when the context is sitting on the error
+ * recovery list. A context on the error recovery list is not known to the AFU
+ * due to reset. When the context is recovered, it will be reattached and made
+ * known again to the AFU.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int _cxlflash_disk_release(struct scsi_device *sdev,
+			   struct ctx_info *ctxi,
+			   struct dk_cxlflash_release *release)
+{
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct llun_info *lli = sdev->hostdata;
+	struct glun_info *gli = lli->parent;
+	struct afu *afu = cfg->afu;
+	bool unlock_ctx = false;
+
+	res_hndl_t rhndl = release->rsrc_handle;
+
+	int rc = 0;
+	u64 ctxid = DECODE_CTXID(release->context_id),
+	    rctxid = release->context_id;
+
+	struct sisl_rht_entry *rhte;
+	struct sisl_rht_entry_f1 *rhte_f1;
+
+	pr_debug("%s: ctxid=%llu rhndl=0x%llx gli->mode=%u gli->users=%u\n",
+		 __func__, ctxid, release->rsrc_handle, gli->mode, gli->users);
+
+	if (!ctxi) {
+		ctxi = get_context(cfg, rctxid, lli, CTX_CTRL_ERR_FALLBACK);
+		if (unlikely(!ctxi)) {
+			pr_err("%s: Bad context! (%llu)\n", __func__, ctxid);
+			rc = -EINVAL;
+			goto out;
+		}
+
+		unlock_ctx = true;
+	}
+
+	rhte = get_rhte(ctxi, rhndl, lli);
+	if (unlikely(!rhte)) {
+		pr_err("%s: Bad resource handle! (%d)\n", __func__, rhndl);
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
+	switch (gli->mode) {
+	case MODE_PHYSICAL:
+		/*
+		 * Clear the Format 1 RHT entry for direct access
+		 * (physical LUN) using the synchronization sequence
+		 * defined in the SISLite specification.
+		 */
+		rhte_f1 = (struct sisl_rht_entry_f1 *)rhte;
+
+		rhte_f1->valid = 0;
+		dma_wmb(); /* Make revocation of RHT entry visible */
+
+		rhte_f1->lun_id = 0;
+		dma_wmb(); /* Make clearing of LUN id visible */
+
+		rhte_f1->dw = 0;
+		dma_wmb(); /* Make RHT entry bottom-half clearing visible */
+
+		if (!ctxi->err_recovery_active)
+			cxlflash_afu_sync(afu, ctxid, rhndl, AFU_HW_SYNC);
+		break;
+	default:
+		WARN(1, "Unsupported LUN mode!");
+		goto out;
+	}
+
+	rhte_checkin(ctxi, rhte);
+	cxlflash_lun_detach(gli);
+
+out:
+	if (unlock_ctx)
+		mutex_unlock(&ctxi->mutex);
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+}
+
+int cxlflash_disk_release(struct scsi_device *sdev,
+			  struct dk_cxlflash_release *release)
+{
+	return _cxlflash_disk_release(sdev, NULL, release);
+}
+
+/**
+ * destroy_context() - releases a context
+ * @cfg:	Internal structure associated with the host.
+ * @ctxi:	Context to release.
+ *
+ * Note that the rht_lun member of the context was cut from a single
+ * allocation when the context was created and therefore does not need
+ * to be explicitly freed. Also note that we conditionally check for the
+ * existence of the context control map before clearing the RHT registers
+ * and context capbilities because it is possible to destroy a context
+ * while the context is in the error state (previous mapping was removed
+ * [so we don't have to worry about clearing] and context is waiting for
+ * a new mapping).
+ */
+static void destroy_context(struct cxlflash_cfg *cfg,
+			    struct ctx_info *ctxi)
+{
+	struct afu *afu = cfg->afu;
+
+	WARN_ON(!list_empty(&ctxi->luns));
+
+	/* Clear RHT registers and drop all capabilities for this context */
+	if (afu->afu_map && ctxi->ctrl_map) {
+		writeq_be(0, &ctxi->ctrl_map->rht_start);
+		writeq_be(0, &ctxi->ctrl_map->rht_cnt_id);
+		writeq_be(0, &ctxi->ctrl_map->ctx_cap);
+	}
+
+	/*
+	 * Free the RHT memory and context; note that rht_lun
+	 * was carved from the same memory as the context.
+	 */
+	free_page((ulong)ctxi->rht_start);
+	kfree(ctxi);
+	atomic_dec_if_positive(&cfg->num_user_contexts);
+}
+
+/**
+ * create_context() - allocates and initializes a context
+ * @cfg:	Internal structure associated with the host.
+ * @ctx:	Previously obtained CXL context reference.
+ * @ctxid:	Previously obtained process element associated with CXL context.
+ * @adap_fd:	Previously obtained adapter fd associated with CXL context.
+ * @file:	Previously obtained file associated with CXL context.
+ * @perms:	User-specified permissions.
+ *
+ * The context's mutex is locked when an allocated context is returned.
+ *
+ * Return: Allocated context on success, NULL on failure
+ */
+static struct ctx_info *create_context(struct cxlflash_cfg *cfg,
+				       struct cxl_context *ctx, int ctxid,
+				       int adap_fd, struct file *file,
+				       u32 perms)
+{
+	char *tmp = NULL;
+	size_t size;
+	struct afu *afu = cfg->afu;
+	struct ctx_info *ctxi = NULL;
+	struct sisl_rht_entry *rhte;
+
+	size = (MAX_RHT_PER_CONTEXT * sizeof(*ctxi->rht_lun));
+	size += sizeof(*ctxi);
+
+	tmp = kzalloc(size, GFP_KERNEL);
+	if (unlikely(!tmp)) {
+		pr_err("%s: Unable to allocate context! (%ld)\n",
+		       __func__, size);
+		goto out;
+	}
+
+	rhte = (struct sisl_rht_entry *)get_zeroed_page(GFP_KERNEL);
+	if (unlikely(!rhte)) {
+		pr_err("%s: Unable to allocate RHT!\n", __func__);
+		goto err;
+	}
+
+	ctxi = (struct ctx_info *)tmp;
+	tmp += sizeof(*ctxi);
+	ctxi->rht_lun = (struct llun_info **)tmp;
+	ctxi->rht_start = rhte;
+	ctxi->rht_perms = perms;
+
+	ctxi->ctrl_map = &afu->afu_map->ctrls[ctxid].ctrl;
+	ctxi->ctxid = ENCODE_CTXID(ctxi, ctxid);
+	ctxi->lfd = adap_fd;
+	ctxi->pid = current->tgid; /* tgid = pid */
+	ctxi->ctx = ctx;
+	ctxi->file = file;
+	mutex_init(&ctxi->mutex);
+	INIT_LIST_HEAD(&ctxi->luns);
+	INIT_LIST_HEAD(&ctxi->list); /* initialize for list_empty() */
+
+	atomic_inc(&cfg->num_user_contexts);
+	mutex_lock(&ctxi->mutex);
+out:
+	return ctxi;
+
+err:
+	kfree(tmp);
+	goto out;
+}
+
+/**
+ * _cxlflash_disk_detach() - detaches a LUN from a context
+ * @sdev:	SCSI device associated with LUN.
+ * @ctxi:	Context owning resources.
+ * @detach:	Detach ioctl data structure.
+ *
+ * As part of the detach, all per-context resources associated with the LUN
+ * are cleaned up. When detaching the last LUN for a context, the context
+ * itself is cleaned up and released.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int _cxlflash_disk_detach(struct scsi_device *sdev,
+				 struct ctx_info *ctxi,
+				 struct dk_cxlflash_detach *detach)
+{
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct llun_info *lli = sdev->hostdata;
+	struct lun_access *lun_access, *t;
+	struct dk_cxlflash_release rel;
+	bool unlock_ctx = false;
+
+	int i;
+	int rc = 0;
+	int lfd;
+	u64 ctxid = DECODE_CTXID(detach->context_id),
+	    rctxid = detach->context_id;
+
+	pr_debug("%s: ctxid=%llu\n", __func__, ctxid);
+
+	if (!ctxi) {
+		ctxi = get_context(cfg, rctxid, lli, CTX_CTRL_ERR_FALLBACK);
+		if (unlikely(!ctxi)) {
+			pr_err("%s: Bad context! (%llu)\n", __func__, ctxid);
+			rc = -EINVAL;
+			goto out;
+		}
+
+		unlock_ctx = true;
+	}
+
+	/* Cleanup outstanding resources tied to this LUN */
+	if (ctxi->rht_out) {
+		marshal_det_to_rele(detach, &rel);
+		for (i = 0; i < MAX_RHT_PER_CONTEXT; i++) {
+			if (ctxi->rht_lun[i] == lli) {
+				rel.rsrc_handle = i;
+				_cxlflash_disk_release(sdev, ctxi, &rel);
+			}
+
+			/* No need to loop further if we're done */
+			if (ctxi->rht_out == 0)
+				break;
+		}
+	}
+
+	/* Take our LUN out of context, free the node */
+	list_for_each_entry_safe(lun_access, t, &ctxi->luns, list)
+		if (lun_access->lli == lli) {
+			list_del(&lun_access->list);
+			kfree(lun_access);
+			lun_access = NULL;
+			break;
+		}
+
+	/* Tear down context following last LUN cleanup */
+	if (list_empty(&ctxi->luns)) {
+		ctxi->unavail = true;
+		mutex_unlock(&ctxi->mutex);
+		mutex_lock(&cfg->ctx_tbl_list_mutex);
+		mutex_lock(&ctxi->mutex);
+
+		/* Might not have been in error list so conditionally remove */
+		if (!list_empty(&ctxi->list))
+			list_del(&ctxi->list);
+		cfg->ctx_tbl[ctxid] = NULL;
+		mutex_unlock(&cfg->ctx_tbl_list_mutex);
+		mutex_unlock(&ctxi->mutex);
+
+		lfd = ctxi->lfd;
+		destroy_context(cfg, ctxi);
+		ctxi = NULL;
+		unlock_ctx = false;
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
+	if (unlock_ctx)
+		mutex_unlock(&ctxi->mutex);
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+}
+
+static int cxlflash_disk_detach(struct scsi_device *sdev,
+				struct dk_cxlflash_detach *detach)
+{
+	return _cxlflash_disk_detach(sdev, NULL, detach);
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
+	struct ctx_info *ctxi = NULL;
+	struct dk_cxlflash_detach detach = { { 0 }, 0 };
+	struct lun_access *lun_access, *t;
+	enum ctx_ctrl ctrl = CTX_CTRL_ERR_FALLBACK | CTX_CTRL_FILE;
+	int ctxid;
+
+	ctxid = cxl_process_element(ctx);
+	if (unlikely(ctxid < 0)) {
+		pr_err("%s: Context %p was closed! (%d)\n",
+		       __func__, ctx, ctxid);
+		goto out;
+	}
+
+	ctxi = get_context(cfg, ctxid, file, ctrl);
+	if (unlikely(!ctxi)) {
+		ctxi = get_context(cfg, ctxid, file, ctrl | CTX_CTRL_CLONE);
+		if (!ctxi) {
+			pr_debug("%s: Context %d already free!\n",
+				 __func__, ctxid);
+			goto out_release;
+		}
+
+		pr_debug("%s: Another process owns context %d!\n",
+			 __func__, ctxid);
+		mutex_unlock(&ctxi->mutex);
+		goto out;
+	}
+
+	pr_debug("%s: close(%d) for context %d\n",
+		 __func__, ctxi->lfd, ctxid);
+
+	/* Reset the file descriptor to indicate we're on a close() thread */
+	ctxi->lfd = -1;
+	detach.context_id = ctxi->ctxid;
+	list_for_each_entry_safe(lun_access, t, &ctxi->luns, list)
+		_cxlflash_disk_detach(lun_access->sdev, ctxi, &detach);
+out_release:
+	cxl_fd_release(inode, file);
+out:
+	pr_debug("%s: returning\n", __func__);
+	return 0;
+}
+
+/**
+ * unmap_context() - clears a previously established mapping
+ * @ctxi:	Context owning the mapping.
+ *
+ * This routine is used to switch between the error notification page
+ * (dummy page of all 1's) and the real mapping (established by the CXL
+ * fault handler).
+ */
+static void unmap_context(struct ctx_info *ctxi)
+{
+	unmap_mapping_range(ctxi->file->f_mapping, 0, 0, 1);
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
+ * adapter file descriptor. The VMA's page protection bits are toggled to
+ * indicate cached/not-cached depending on the memory backing the fault.
+ *
+ * Return: 0 on success, VM_FAULT_SIGBUS on failure
+ */
+static int cxlflash_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct file *file = vma->vm_file;
+	struct cxl_context *ctx = cxl_fops_get_context(file);
+	struct cxlflash_cfg *cfg = container_of(file->f_op, struct cxlflash_cfg,
+						cxl_fops);
+	struct ctx_info *ctxi = NULL;
+	struct page *err_page = NULL;
+	enum ctx_ctrl ctrl = CTX_CTRL_ERR_FALLBACK | CTX_CTRL_FILE;
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
+	ctxi = get_context(cfg, ctxid, file, ctrl);
+	if (unlikely(!ctxi)) {
+		pr_err("%s: Bad context! (%d)\n", __func__, ctxid);
+		goto err;
+	}
+
+	pr_debug("%s: fault(%d) for context %d\n",
+		 __func__, ctxi->lfd, ctxid);
+
+	if (likely(!ctxi->err_recovery_active)) {
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+		rc = ctxi->cxl_mmap_vmops->fault(vma, vmf);
+	} else {
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
+		vma->vm_page_prot = pgprot_cached(vma->vm_page_prot);
+	}
+
+out:
+	if (likely(ctxi))
+		mutex_unlock(&ctxi->mutex);
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
+	struct ctx_info *ctxi = NULL;
+	enum ctx_ctrl ctrl = CTX_CTRL_ERR_FALLBACK | CTX_CTRL_FILE;
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
+	ctxi = get_context(cfg, ctxid, file, ctrl);
+	if (unlikely(!ctxi)) {
+		pr_err("%s: Bad context! (%d)\n", __func__, ctxid);
+		rc = -EIO;
+		goto out;
+	}
+
+	pr_debug("%s: mmap(%d) for context %d\n", __func__, ctxi->lfd, ctxid);
+
+	rc = cxl_fd_mmap(file, vma);
+	if (likely(!rc)) {
+		/* Insert ourself in the mmap fault handler path */
+		ctxi->cxl_mmap_vmops = vma->vm_ops;
+		vma->vm_ops = &cxlflash_mmap_vmops;
+	}
+
+out:
+	if (likely(ctxi))
+		mutex_unlock(&ctxi->mutex);
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
+ * cxlflash_mark_contexts_error() - move contexts to error state and list
+ * @cfg:	Internal structure associated with the host.
+ *
+ * A context is only moved over to the error list when there are no outstanding
+ * references to it. This ensures that a running operation has completed.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int cxlflash_mark_contexts_error(struct cxlflash_cfg *cfg)
+{
+	int i, rc = 0;
+	struct ctx_info *ctxi = NULL;
+
+	mutex_lock(&cfg->ctx_tbl_list_mutex);
+
+	for (i = 0; i < MAX_CONTEXT; i++) {
+		ctxi = cfg->ctx_tbl[i];
+		if (ctxi) {
+			mutex_lock(&ctxi->mutex);
+			cfg->ctx_tbl[i] = NULL;
+			list_add(&ctxi->list, &cfg->ctx_err_recovery);
+			ctxi->err_recovery_active = true;
+			ctxi->ctrl_map = NULL;
+			unmap_context(ctxi);
+			mutex_unlock(&ctxi->mutex);
+		}
+	}
+
+	mutex_unlock(&cfg->ctx_tbl_list_mutex);
+	return rc;
+}
+
+/*
+ * Dummy NULL fops
+ */
+static const struct file_operations null_fops = {
+	.owner = THIS_MODULE,
+};
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
+	struct llun_info *lli = sdev->hostdata;
+	struct glun_info *gli = lli->parent;
+	struct cxl_ioctl_start_work *work;
+	struct ctx_info *ctxi = NULL;
+	struct lun_access *lun_access = NULL;
+	int rc = 0;
+	u32 perms;
+	int ctxid = -1;
+	u64 rctxid = 0UL;
+	struct file *file;
+
+	struct cxl_context *ctx;
+
+	int fd = -1;
+
+	/* On first attach set fileops */
+	if (atomic_read(&cfg->num_user_contexts) == 0)
+		cfg->cxl_fops = cxlflash_cxl_fops;
+
+	if (attach->num_interrupts > 4) {
+		pr_err("%s: Cannot support this many interrupts %llu\n",
+		       __func__, attach->num_interrupts);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (gli->max_lba == 0) {
+		pr_debug("%s: No capacity info yet for this LUN (%016llX)\n",
+			 __func__, lli->lun_id[sdev->channel]);
+		rc = read_cap16(sdev, lli);
+		if (rc) {
+			pr_err("%s: Invalid device! (%d)\n", __func__, rc);
+			rc = -ENODEV;
+			goto out;
+		}
+		pr_debug("%s: LBA = %016llX\n", __func__, gli->max_lba);
+		pr_debug("%s: BLK_LEN = %08X\n", __func__, gli->blk_len);
+	}
+
+	if (attach->hdr.flags & DK_CXLFLASH_ATTACH_REUSE_CONTEXT) {
+		rctxid = attach->context_id;
+		ctxi = get_context(cfg, rctxid, NULL, 0);
+		if (!ctxi) {
+			pr_err("%s: Bad context! (%016llX)\n",
+			       __func__, rctxid);
+			rc = -EINVAL;
+			goto out;
+		}
+
+		list_for_each_entry(lun_access, &ctxi->luns, list)
+			if (lun_access->lli == lli) {
+				pr_err("%s: Already attached!\n", __func__);
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
+	lun_access->lli = lli;
+	lun_access->sdev = sdev;
+
+	/* Non-NULL context indicates reuse */
+	if (ctxi) {
+		pr_debug("%s: Reusing context for LUN! (%016llX)\n",
+			 __func__, rctxid);
+		list_add(&lun_access->list, &ctxi->luns);
+		fd = ctxi->lfd;
+		goto out_attach;
+	}
+
+	ctx = cxl_dev_context_init(cfg->dev);
+	if (unlikely(IS_ERR_OR_NULL(ctx))) {
+		pr_err("%s: Could not initialize context %p\n", __func__, ctx);
+		rc = -ENODEV;
+		goto err0;
+	}
+
+	ctxid = cxl_process_element(ctx);
+	if (unlikely((ctxid > MAX_CONTEXT) || (ctxid < 0))) {
+		pr_err("%s: ctxid (%d) invalid!\n", __func__, ctxid);
+		rc = -EPERM;
+		goto err1;
+	}
+
+	file = cxl_get_fd(ctx, &cfg->cxl_fops, &fd);
+	if (unlikely(fd < 0)) {
+		rc = -ENODEV;
+		pr_err("%s: Could not get file descriptor\n", __func__);
+		goto err1;
+	}
+
+	/* Translate read/write O_* flags from fcntl.h to AFU permission bits */
+	perms = SISL_RHT_PERM(attach->hdr.flags + 1);
+
+	ctxi = create_context(cfg, ctx, ctxid, fd, file, perms);
+	if (unlikely(!ctxi)) {
+		pr_err("%s: Failed to create context! (%d)\n", __func__, ctxid);
+		goto err2;
+	}
+
+	work = &ctxi->work;
+	work->num_interrupts = attach->num_interrupts;
+	work->flags = CXL_START_WORK_NUM_IRQS;
+
+	rc = cxl_start_work(ctx, work);
+	if (unlikely(rc)) {
+		pr_debug("%s: Could not start context rc=%d\n", __func__, rc);
+		goto err3;
+	}
+
+	rc = afu_attach(cfg, ctxi);
+	if (unlikely(rc)) {
+		pr_err("%s: Could not attach AFU rc %d\n", __func__, rc);
+		goto err4;
+	}
+
+	/*
+	 * No error paths after this point. Once the fd is installed it's
+	 * visible to user space and can't be undone safely on this thread.
+	 * There is no need to worry about a deadlock here because no one
+	 * knows about us yet; we can be the only one holding our mutex.
+	 */
+	list_add(&lun_access->list, &ctxi->luns);
+	mutex_unlock(&ctxi->mutex);
+	mutex_lock(&cfg->ctx_tbl_list_mutex);
+	mutex_lock(&ctxi->mutex);
+	cfg->ctx_tbl[ctxid] = ctxi;
+	mutex_unlock(&cfg->ctx_tbl_list_mutex);
+	fd_install(fd, file);
+
+out_attach:
+	attach->hdr.return_flags = 0;
+	attach->context_id = ctxi->ctxid;
+	attach->block_size = gli->blk_len;
+	attach->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
+	attach->last_lba = gli->max_lba;
+	attach->max_xfer = (sdev->host->max_sectors * 512) / gli->blk_len;
+
+out:
+	attach->adap_fd = fd;
+
+	if (ctxi)
+		mutex_unlock(&ctxi->mutex);
+
+	pr_debug("%s: returning ctxid=%d fd=%d bs=%lld rc=%d llba=%lld\n",
+		 __func__, ctxid, fd, attach->block_size, rc, attach->last_lba);
+	return rc;
+
+err4:
+	cxl_stop_context(ctx);
+err3:
+	mutex_unlock(&ctxi->mutex);
+	destroy_context(cfg, ctxi);
+	ctxi = NULL;
+err2:
+	/*
+	 * Here, we're overriding the fops with a dummy all-NULL fops because
+	 * fput() calls the release fop, which will cause us to mistakenly
+	 * call into the CXL code. Rather than try to add yet more complexity
+	 * to that routine (cxlflash_cxl_release) we should try to fix the
+	 * issue here.
+	 */
+	file->f_op = &null_fops;
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
+	int rc = 0;
+	struct llun_info *lli = NULL;
+	u64 flags = manage->hdr.flags;
+	u32 chan = sdev->channel;
+
+	lli = lookup_lun(sdev, manage->wwid);
+	pr_debug("%s: ENTER: WWID = %016llX%016llX, flags = %016llX li = %p\n",
+		 __func__, get_unaligned_le64(&manage->wwid[0]),
+		 get_unaligned_le64(&manage->wwid[8]),
+		 manage->hdr.flags, lli);
+	if (unlikely(!lli)) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (flags & DK_CXLFLASH_MANAGE_LUN_ENABLE_SUPERPIPE) {
+		if (lli->newly_created)
+			lli->port_sel = CHAN2PORT(chan);
+		else
+			lli->port_sel = BOTH_PORTS;
+		/* Store off lun in unpacked, AFU-friendly format */
+		lli->lun_id[chan] = lun_to_lunid(sdev->lun);
+		sdev->hostdata = lli;
+	} else if (flags & DK_CXLFLASH_MANAGE_LUN_DISABLE_SUPERPIPE) {
+		if (lli->parent->mode != MODE_NONE)
+			rc = -EBUSY;
+		else
+			sdev->hostdata = NULL;
+	}
+
+out:
+	pr_debug("%s: returning rc=%d\n", __func__, rc);
+	return rc;
+}
+
+/**
+ * recover_context() - recovers a context in error
+ * @cfg:	Internal structure associated with the host.
+ * @ctxi:	Context to release.
+ *
+ * Restablishes the state for a context-in-error.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
+{
+	int rc = 0;
+	int old_fd, fd = -1;
+	int ctxid = -1;
+	struct file *file;
+	struct cxl_context *ctx;
+	struct afu *afu = cfg->afu;
+
+	ctx = cxl_dev_context_init(cfg->dev);
+	if (unlikely(IS_ERR_OR_NULL(ctx))) {
+		pr_err("%s: Could not initialize context %p\n", __func__, ctx);
+		rc = -ENODEV;
+		goto out;
+	}
+
+	ctxid = cxl_process_element(ctx);
+	if (unlikely((ctxid > MAX_CONTEXT) || (ctxid < 0))) {
+		pr_err("%s: ctxid (%d) invalid!\n", __func__, ctxid);
+		rc = -EPERM;
+		goto err1;
+	}
+
+	file = cxl_get_fd(ctx, &cfg->cxl_fops, &fd);
+	if (unlikely(fd < 0)) {
+		rc = -ENODEV;
+		pr_err("%s: Could not get file descriptor\n", __func__);
+		goto err1;
+	}
+
+	rc = cxl_start_work(ctx, &ctxi->work);
+	if (unlikely(rc)) {
+		pr_err("%s: Could not start context rc=%d\n", __func__, rc);
+		goto err2;
+	}
+
+	/* Update with new MMIO area based on updated context id */
+	ctxi->ctrl_map = &afu->afu_map->ctrls[ctxid].ctrl;
+
+	rc = afu_attach(cfg, ctxi);
+	if (rc) {
+		pr_err("%s: Could not attach AFU rc %d\n", __func__, rc);
+		goto err3;
+	}
+
+	/*
+	 * No error paths after this point. Once the fd is installed it's
+	 * visible to user space and can't be undone safely on this thread.
+	 */
+	old_fd = ctxi->lfd;
+	ctxi->ctxid = ENCODE_CTXID(ctxi, ctxid);
+	ctxi->lfd = fd;
+	ctxi->ctx = ctx;
+	ctxi->file = file;
+
+	/*
+	 * Put context back in table (note the reinit of the context list);
+	 * we must first drop the context's mutex and then acquire it in
+	 * order with the table/list mutex to avoid a deadlock - safe to do
+	 * here because no one can find us at this moment in time.
+	 */
+	mutex_unlock(&ctxi->mutex);
+	mutex_lock(&cfg->ctx_tbl_list_mutex);
+	mutex_lock(&ctxi->mutex);
+	list_del_init(&ctxi->list);
+	cfg->ctx_tbl[ctxid] = ctxi;
+	mutex_unlock(&cfg->ctx_tbl_list_mutex);
+	fd_install(fd, file);
+
+	/* Release the original adapter fd and associated CXL resources */
+	sys_close(old_fd);
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
+ * check_state() - checks and responds to the current adapter state
+ * @cfg:	Internal structure associated with the host.
+ *
+ * This routine can block and should only be used on process context.
+ * Note that when waking up from waiting in limbo, the state is unknown
+ * and must be checked again before proceeding.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int check_state(struct cxlflash_cfg *cfg)
+{
+	int rc = 0;
+
+retry:
+	switch (cfg->state) {
+	case STATE_LIMBO:
+		pr_debug("%s: Limbo, going to wait...\n", __func__);
+		rc = wait_event_interruptible(cfg->limbo_waitq,
+					      cfg->state != STATE_LIMBO);
+		if (unlikely(rc))
+			goto out;
+		goto retry;
+	case STATE_FAILTERM:
+		pr_debug("%s: Failed/Terminating!\n", __func__);
+		rc = -ENODEV;
+		goto out;
+	default:
+		break;
+	}
+out:
+	return rc;
+}
+
+/**
+ * cxlflash_afu_recover() - initiates AFU recovery
+ * @sdev:	SCSI device associated with LUN.
+ * @recover:	Recover ioctl data structure.
+ *
+ * Only a single recovery is allowed at a time to avoid exhausting CXL
+ * resources (leading to recovery failure) in the event that we're up
+ * against the maximum number of contexts limit. For similar reasons,
+ * a context recovery is retried if there are multiple recoveries taking
+ * place at the same time and the failure was due to CXL services being
+ * unable to keep up.
+ *
+ * Because a user can detect an error condition before the kernel, it is
+ * quite possible for this routine to act as the kernel's EEH detection
+ * source (MMIO read of mbox_r). Because of this, there is a window of
+ * time where an EEH might have been detected but not yet 'serviced'
+ * (callback invoked, causing the device to enter limbo state). To avoid
+ * looping in this routine during that window, a 1 second sleep is in place
+ * between the time the MMIO failure is detected and the time a wait on the
+ * limbo wait queue is attempted via check_state().
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int cxlflash_afu_recover(struct scsi_device *sdev,
+				struct dk_cxlflash_recover_afu *recover)
+{
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct llun_info *lli = sdev->hostdata;
+	struct afu *afu = cfg->afu;
+	struct ctx_info *ctxi = NULL;
+	struct mutex *mutex = &cfg->ctx_recovery_mutex;
+	u64 ctxid = DECODE_CTXID(recover->context_id),
+	    rctxid = recover->context_id;
+	long reg;
+	int lretry = 20; /* up to 2 seconds */
+	int rc = 0;
+
+	atomic_inc(&cfg->recovery_threads);
+	rc = mutex_lock_interruptible(mutex);
+	if (rc)
+		goto out;
+
+	pr_debug("%s: reason 0x%016llX rctxid=%016llX\n", __func__,
+		 recover->reason, rctxid);
+
+retry:
+	/* Ensure that this process is attached to the context */
+	ctxi = get_context(cfg, rctxid, lli, CTX_CTRL_ERR_FALLBACK);
+	if (unlikely(!ctxi)) {
+		pr_err("%s: Bad context! (%llu)\n", __func__, ctxid);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (ctxi->err_recovery_active) {
+retry_recover:
+		rc = recover_context(cfg, ctxi);
+		if (unlikely(rc)) {
+			pr_err("%s: Recovery failed for context %llu (rc=%d)\n",
+			       __func__, ctxid, rc);
+			if ((rc == -ENODEV) &&
+			    ((atomic_read(&cfg->recovery_threads) > 1) ||
+			     (lretry--))) {
+				pr_debug("%s: Going to try again!\n", __func__);
+				mutex_unlock(mutex);
+				msleep(100);
+				rc = mutex_lock_interruptible(mutex);
+				if (rc)
+					goto out;
+				goto retry_recover;
+			}
+
+			goto out;
+		}
+
+		ctxi->err_recovery_active = false;
+		recover->context_id = ctxi->ctxid;
+		recover->adap_fd = ctxi->lfd;
+		recover->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
+		recover->hdr.return_flags |=
+			DK_CXLFLASH_RECOVER_AFU_CONTEXT_RESET;
+		goto out;
+	}
+
+	/* Test if in error state */
+	reg = readq_be(&afu->ctrl_map->mbox_r);
+	if (reg == -1) {
+		pr_info("%s: MMIO read fail! Wait for recovery...\n", __func__);
+		mutex_unlock(&ctxi->mutex);
+		ctxi = NULL;
+		ssleep(1);
+		rc = check_state(cfg);
+		if (unlikely(rc))
+			goto out;
+		goto retry;
+	}
+
+	pr_debug("%s: MMIO working, no recovery required!\n", __func__);
+out:
+	if (likely(ctxi))
+		mutex_unlock(&ctxi->mutex);
+	mutex_unlock(mutex);
+	atomic_dec_if_positive(&cfg->recovery_threads);
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
+	struct llun_info *lli = sdev->hostdata;
+	struct glun_info *gli = lli->parent;
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	u64 prev_lba = gli->max_lba;
+	struct scsi_sense_hdr sshdr = { 0 };
+	int rc = 0;
+
+	rc = scsi_normalize_sense((const u8 *)&verify->sense_data,
+				  DK_CXLFLASH_VERIFY_SENSE_LEN, &sshdr);
+	if (!rc) {
+		pr_err("%s: Failed to normalize sense data!\n", __func__);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	switch (sshdr.sense_key) {
+	case NO_SENSE:
+	case RECOVERED_ERROR:
+		/* fall through */
+	case NOT_READY:
+		break;
+	case UNIT_ATTENTION:
+		switch (sshdr.asc) {
+		case 0x29: /* Power on Reset or Device Reset */
+			/* fall through */
+		case 0x2A: /* Device settings/capacity changed */
+			rc = read_cap16(sdev, lli);
+			if (rc) {
+				rc = -ENODEV;
+				break;
+			}
+			if (prev_lba != gli->max_lba)
+				pr_debug("%s: Capacity changed old=%lld "
+					 "new=%lld\n", __func__, prev_lba,
+					 gli->max_lba);
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
+out:
+	pr_debug("%s: sense_key %x asc %x ascq %x rc %d\n", __func__,
+		 sshdr.sense_key, sshdr.asc, sshdr.ascq, rc);
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
+	struct ctx_info *ctxi = NULL;
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct llun_info *lli = sdev->hostdata;
+	struct glun_info *gli = lli->parent;
+	struct sisl_rht_entry *rhte = NULL;
+	res_hndl_t rhndl = verify->rsrc_handle;
+	u64 ctxid = DECODE_CTXID(verify->context_id),
+	    rctxid = verify->context_id;
+	u64 last_lba = 0;
+
+	pr_debug("%s: ctxid=%llu rhndl=%016llX, hint=%016llX, flags=%016llX\n",
+		 __func__, ctxid, verify->rsrc_handle, verify->hint,
+		 verify->hdr.flags);
+
+	ctxi = get_context(cfg, rctxid, lli, 0);
+	if (unlikely(!ctxi)) {
+		pr_err("%s: Bad context! (%llu)\n", __func__, ctxid);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rhte = get_rhte(ctxi, rhndl, lli);
+	if (unlikely(!rhte)) {
+		pr_err("%s: Bad resource handle! (%d)\n", __func__, rhndl);
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
+	switch (gli->mode) {
+	case MODE_PHYSICAL:
+		last_lba = gli->max_lba;
+		break;
+	default:
+		WARN(1, "Unsupported LUN mode!");
+	}
+
+	verify->last_lba = last_lba;
+
+out:
+	if (likely(ctxi))
+		mutex_unlock(&ctxi->mutex);
+	pr_debug("%s: returning rc=%d llba=%llX\n",
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
+	case DK_CXLFLASH_RELEASE:
+		return __stringify_1(DK_CXLFLASH_RELEASE);
+	case DK_CXLFLASH_DETACH:
+		return __stringify_1(DK_CXLFLASH_DETACH);
+	case DK_CXLFLASH_VERIFY:
+		return __stringify_1(DK_CXLFLASH_VERIFY);
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
+	struct device *dev = &cfg->dev->dev;
+	struct afu *afu = cfg->afu;
+	struct llun_info *lli = sdev->hostdata;
+	struct glun_info *gli = lli->parent;
+
+	struct dk_cxlflash_udirect *pphys = (struct dk_cxlflash_udirect *)arg;
+
+	u64 ctxid = DECODE_CTXID(pphys->context_id),
+	    rctxid = pphys->context_id;
+	u64 lun_size = 0;
+	u64 last_lba = 0;
+	u64 rsrc_handle = -1;
+	u32 port = CHAN2PORT(sdev->channel);
+
+	int rc = 0;
+
+	struct ctx_info *ctxi = NULL;
+	struct sisl_rht_entry *rhte = NULL;
+
+	pr_debug("%s: ctxid=%llu ls=0x%llx\n", __func__, ctxid, lun_size);
+
+	rc = cxlflash_lun_attach(gli, MODE_PHYSICAL);
+	if (unlikely(rc)) {
+		dev_err(dev, "%s: Failed to attach to LUN! (PHYSICAL)\n",
+			__func__);
+		goto out;
+	}
+
+	ctxi = get_context(cfg, rctxid, lli, 0);
+	if (unlikely(!ctxi)) {
+		dev_err(dev, "%s: Bad context! (%llu)\n", __func__, ctxid);
+		rc = -EINVAL;
+		goto err1;
+	}
+
+	rhte = rhte_checkout(ctxi, lli);
+	if (unlikely(!rhte)) {
+		dev_err(dev, "%s: too many opens for this context\n", __func__);
+		rc = -EMFILE;	/* too many opens  */
+		goto err1;
+	}
+
+	rsrc_handle = (rhte - ctxi->rht_start);
+
+	rht_format1(rhte, lli->lun_id[sdev->channel], ctxi->rht_perms, port);
+	cxlflash_afu_sync(afu, ctxid, rsrc_handle, AFU_LW_SYNC);
+
+	last_lba = gli->max_lba;
+	pphys->hdr.return_flags = 0;
+	pphys->last_lba = last_lba;
+	pphys->rsrc_handle = rsrc_handle;
+
+out:
+	if (likely(ctxi))
+		mutex_unlock(&ctxi->mutex);
+	pr_debug("%s: returning handle 0x%llx rc=%d llba %lld\n",
+		 __func__, rsrc_handle, rc, last_lba);
+	return rc;
+
+err1:
+	cxlflash_lun_detach(gli);
+	goto out;
+}
+
+/**
+ * ioctl_common() - common IOCTL handler for driver
+ * @sdev:	SCSI device associated with LUN.
+ * @cmd:	IOCTL command.
+ *
+ * Handles common fencing operations that are valid for multiple ioctls. Always
+ * allow through ioctls that are cleanup oriented in nature, even when operating
+ * in a failed/terminating state.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int ioctl_common(struct scsi_device *sdev, int cmd)
+{
+	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)sdev->host->hostdata;
+	struct llun_info *lli = sdev->hostdata;
+	int rc = 0;
+
+	if (unlikely(!lli)) {
+		pr_debug("%s: Unknown LUN\n", __func__);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = check_state(cfg);
+	if (unlikely(rc) && (cfg->state == STATE_FAILTERM)) {
+		switch (cmd) {
+		case DK_CXLFLASH_RELEASE:
+		case DK_CXLFLASH_DETACH:
+			pr_debug("%s: Command override! (%d)\n", __func__, rc);
+			rc = 0;
+			break;
+		}
+	}
+out:
+	return rc;
+}
+
+/**
+ * cxlflash_ioctl() - IOCTL handler for driver
+ * @sdev:	SCSI device associated with LUN.
+ * @cmd:	IOCTL command.
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
+		case DK_CXLFLASH_RELEASE:
+			pr_err("%s: %s not supported for lun_mode=%d\n",
+			       __func__, decode_ioctl(cmd), afu->internal_lun);
+			rc = -EINVAL;
+			goto cxlflash_ioctl_exit;
+		}
+
+	switch (cmd) {
+	case DK_CXLFLASH_ATTACH:
+	case DK_CXLFLASH_USER_DIRECT:
+	case DK_CXLFLASH_RELEASE:
+	case DK_CXLFLASH_DETACH:
+	case DK_CXLFLASH_VERIFY:
+	case DK_CXLFLASH_RECOVER_AFU:
+		pr_debug("%s: %s (%08X) on dev(%d/%d/%d/%llu)\n", __func__,
+			 decode_ioctl(cmd), cmd, shost->host_no, sdev->channel,
+			 sdev->id, sdev->lun);
+		rc = ioctl_common(sdev, cmd);
+		if (unlikely(rc))
+			goto cxlflash_ioctl_exit;
+
+		/* fall through */
+
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
index 0000000..030892b
--- /dev/null
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -0,0 +1,127 @@
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
+/*
+ * Terminology: use afu (and not adapter) to refer to the HW.
+ * Adapter is the entire slot and includes PSL out of which
+ * only the AFU is visible to user space.
+ */
+
+/* Chunk size parms: note sislite minimum chunk size is
+   0x10000 LBAs corresponding to a NMASK or 16.
+*/
+#define MC_CHUNK_SIZE     (1 << MC_RHT_NMASK)	/* in LBAs, see mclient.h */
+
+#define MC_DISCOVERY_TIMEOUT 5  /* 5 secs */
+
+#define CHAN2PORT(_x)	((_x) + 1)
+
+enum lun_mode {
+	MODE_NONE = 0,
+	MODE_PHYSICAL
+};
+
+/* Global (entire driver, spans adapters) lun_info structure */
+struct glun_info {
+	u64 max_lba;		/* from read cap(16) */
+	u32 blk_len;		/* from read cap(16) */
+	enum lun_mode mode;	/* NONE, PHYSICAL */
+	int users;		/* Number of users w/ references to LUN */
+
+	u8 wwid[16];
+
+	spinlock_t slock;
+
+	struct list_head list;
+};
+
+/* Local (per-adapter) lun_info structure */
+struct llun_info {
+	u64 lun_id[CXLFLASH_NUM_FC_PORTS]; /* from REPORT_LUNS */
+	u32 lun_index;		/* Index in the lun table */
+	u32 host_no;		/* host_no from Scsi_host */
+	u32 port_sel;		/* What port to use for this LUN */
+	bool newly_created;	/* Whether the LUN was just discovered */
+
+	u8 wwid[16];		/* Keep a duplicate copy here? */
+
+	struct glun_info *parent; /* Pointer to entry in global lun structure */
+	struct scsi_device *sdev;
+	struct list_head list;
+};
+
+struct lun_access {
+	struct llun_info *lli;
+	struct scsi_device *sdev;
+	struct list_head list;
+};
+
+enum ctx_ctrl {
+	CTX_CTRL_CLONE		= (1 << 1),
+	CTX_CTRL_ERR		= (1 << 2),
+	CTX_CTRL_ERR_FALLBACK	= (1 << 3),
+	CTX_CTRL_NOPID		= (1 << 4),
+	CTX_CTRL_FILE		= (1 << 5)
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
+	struct llun_info **rht_lun;       /* Mapping of RHT entries to LUNs */
+
+	struct cxl_ioctl_start_work work;
+	u64 ctxid;
+	int lfd;
+	pid_t pid;
+	bool unavail;
+	bool err_recovery_active;
+	struct mutex mutex; /* Context protection */
+	struct cxl_context *ctx;
+	struct list_head luns;	/* LUNs attached to this context */
+	const struct vm_operations_struct *cxl_mmap_vmops;
+	struct file *file;
+	struct list_head list; /* Link contexts in error recovery */
+};
+
+struct cxlflash_global {
+	spinlock_t slock;
+	struct list_head gluns;/* list of glun_info structs */
+	struct page *err_page; /* One page of all 0xF for error notification */
+};
+
+int cxlflash_disk_release(struct scsi_device *, struct dk_cxlflash_release *);
+int _cxlflash_disk_release(struct scsi_device *, struct ctx_info *,
+			   struct dk_cxlflash_release *);
+
+int cxlflash_lun_attach(struct glun_info *, enum lun_mode);
+void cxlflash_lun_detach(struct glun_info *);
+
+struct ctx_info *get_context(struct cxlflash_cfg *, u64, void *, enum ctx_ctrl);
+
+struct sisl_rht_entry *get_rhte(struct ctx_info *, res_hndl_t,
+				struct llun_info *);
+
+struct sisl_rht_entry *rhte_checkout(struct ctx_info *, struct llun_info *);
+void rhte_checkin(struct ctx_info *, struct sisl_rht_entry *);
+
+#endif /* ifndef _CXLFLASH_SUPERPIPE_H */
diff --git a/include/uapi/scsi/Kbuild b/include/uapi/scsi/Kbuild
index 75746d5..d791e0a 100644
--- a/include/uapi/scsi/Kbuild
+++ b/include/uapi/scsi/Kbuild
@@ -3,3 +3,4 @@ header-y += fc/
 header-y += scsi_bsg_fc.h
 header-y += scsi_netlink.h
 header-y += scsi_netlink_fc.h
+header-y += cxlflash_ioctl.h
diff --git a/include/uapi/scsi/cxlflash_ioctl.h b/include/uapi/scsi/cxlflash_ioctl.h
new file mode 100644
index 0000000..f11bdcf
--- /dev/null
+++ b/include/uapi/scsi/cxlflash_ioctl.h
@@ -0,0 +1,139 @@
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
+	__u64 reserved[8];		/* Reserved for future use */
+};
+
+struct dk_cxlflash_detach {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 context_id;		/* Context to detach */
+	__u64 reserved[8];		/* Reserved for future use */
+};
+
+struct dk_cxlflash_udirect {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 context_id;		/* Context to own physical resources */
+	__u64 rsrc_handle;		/* Returned resource handle */
+	__u64 last_lba;			/* Returned last LBA on the device */
+	__u64 reserved[8];		/* Reserved for future use */
+};
+
+struct dk_cxlflash_release {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 context_id;		/* Context owning resources */
+	__u64 rsrc_handle;		/* Resource handle to release */
+	__u64 reserved[8];		/* Reserved for future use */
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
+	__u64 reserved[8];		/* Reserved for future use */
+};
+
+#define DK_CXLFLASH_RECOVER_AFU_CONTEXT_RESET	0x8000000000000000ULL
+
+struct dk_cxlflash_recover_afu {
+	struct dk_cxlflash_hdr hdr;	/* Common fields */
+	__u64 reason;			/* Reason for recovery request */
+	__u64 context_id;		/* Context to recover / updated ID */
+	__u64 mmio_size;		/* Returned size of MMIO area */
+	__u64 adap_fd;			/* Returned adapter file descriptor */
+	__u64 reserved[8];		/* Reserved for future use */
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
+	__u64 reserved[8];				/* Rsvd, future use */
+};
+
+union cxlflash_ioctls {
+	struct dk_cxlflash_attach attach;
+	struct dk_cxlflash_detach detach;
+	struct dk_cxlflash_udirect udirect;
+	struct dk_cxlflash_release release;
+	struct dk_cxlflash_verify verify;
+	struct dk_cxlflash_recover_afu recover_afu;
+	struct dk_cxlflash_manage_lun manage_lun;
+};
+
+#define MAX_CXLFLASH_IOCTL_SZ	(sizeof(union cxlflash_ioctls))
+
+
+#define CXL_MAGIC 0xCA
+#define CXL_IOWR(_n, _s)	_IOWR(CXL_MAGIC, _n, struct _s)
+
+#define DK_CXLFLASH_ATTACH		CXL_IOWR(0x80, dk_cxlflash_attach)
+#define DK_CXLFLASH_USER_DIRECT		CXL_IOWR(0x81, dk_cxlflash_udirect)
+#define DK_CXLFLASH_RELEASE		CXL_IOWR(0x84, dk_cxlflash_release)
+#define DK_CXLFLASH_DETACH		CXL_IOWR(0x85, dk_cxlflash_detach)
+#define DK_CXLFLASH_VERIFY		CXL_IOWR(0x86, dk_cxlflash_verify)
+#define DK_CXLFLASH_RECOVER_AFU		CXL_IOWR(0x88, dk_cxlflash_recover_afu)
+#define DK_CXLFLASH_MANAGE_LUN		CXL_IOWR(0x89, dk_cxlflash_manage_lun)
+
+#endif /* ifndef _CXLFLASH_IOCTL_H */
-- 
2.1.0

