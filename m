From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH RFC 1/2] cxlflash: Base support for IBM CXL Flash Adapter
Date: Sun, 26 Apr 2015 23:50:20 -0500
Message-ID: <1430110220-13268-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:33029 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbbD0Euz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2015 00:50:55 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 27 Apr 2015 00:50:54 -0400
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id BF2B338C8041
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2015 00:50:50 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t3R4ooJO59375628
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2015 04:50:50 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t3R4ongW009888
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2015 00:50:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com
Cc: mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

SCSI device driver to support filesystem access on the IBM CXL Flash adapter.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 Documentation/powerpc/cxlflash.txt |  275 +++++
 drivers/scsi/Kconfig               |    1 +
 drivers/scsi/Makefile              |    1 +
 drivers/scsi/cxlflash/Kconfig      |   11 +
 drivers/scsi/cxlflash/Makefile     |    4 +
 drivers/scsi/cxlflash/common.h     |  287 +++++
 drivers/scsi/cxlflash/main.c       | 2081 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/main.h       |  124 +++
 drivers/scsi/cxlflash/sislite.h    |  407 +++++++
 9 files changed, 3191 insertions(+)
 create mode 100644 Documentation/powerpc/cxlflash.txt
 create mode 100644 drivers/scsi/cxlflash/Kconfig
 create mode 100644 drivers/scsi/cxlflash/Makefile
 create mode 100644 drivers/scsi/cxlflash/common.h
 create mode 100644 drivers/scsi/cxlflash/main.c
 create mode 100644 drivers/scsi/cxlflash/main.h
 create mode 100755 drivers/scsi/cxlflash/sislite.h

diff --git a/Documentation/powerpc/cxlflash.txt b/Documentation/powerpc/cxlflash.txt
new file mode 100644
index 0000000..c31d13e
--- /dev/null
+++ b/Documentation/powerpc/cxlflash.txt
@@ -0,0 +1,275 @@
+Introduction
+============
+
+    The IBM Power architecture provides support for CAPI (Coherent
+    Accelerator Power Interface), which is available to certain PCIe
+    slots on Power 8 systems. CAPI can be thought of as a special
+    tunneling protocol through PCIe that allow PCIe adapters to look
+    like special purpose co-processors which can read or write an
+    application's memory and generate page faults. As a result, the
+    host interface to an adapter running in CAPI mode do not require
+    the data buffers to be mapped to the device's memory (IOMMU bypass)
+    nor does it require memory to be pinned.
+
+    On Linux, Coherent Accelerator (CXL) kernel services present CAPI
+    devices as a PCI device by implementing a virtual PCI host bridge.
+    This abstraction simplifies the infrastructure and programming model,
+    allowing for drivers to look similar to other native PCI device drivers.
+
+    CXL provides a mechanism by which user space applications can
+    directly talk to a device (network or storage) bypassing the
+    typical kernel/device driver stack. The CXL Flash Adapter Driver
+    enables a user space application direct access to Flash storage.
+
+    The CXL Flash Adapter Driver is a kernel module that sits in
+    the SCSI stack as a low level device driver (below the SCSI disk
+    and protocol drivers) for the IBM CXL Flash Adapter. This driver
+    is responsible for the initialization of the adapter, setting up
+    the special path for user space access, and performing error
+    recovery. It communicates directly the Flash Accelerator Functional
+    Unit (AFU) as described in Documentation/powerpc/cxl.txt. 
+
+    The cxlflash driver supports two, mutually exclusive, modes of
+    operation at the device (LUN) level:
+
+        - Any flash device (LUN) can be configured to be accessed as a
+          regular disk device (ie: /dev/sdc). This is the default mode.
+
+        - Any flash device (LUN) can be configured to be accessed from
+          user space with a special block library. This mode further
+          specifies the means of accessing the device and provides for
+          either raw access to the entire LUN (referred to as direct or
+          physical LUN access) or access to a kernel/AFU-mediated partition
+          of the LUN (referred to as virtual LUN access). The segmentation
+          of a disk device into virtual LUNs is assisted by special
+          translation services provided by the Flash AFU.
+
+Overview
+========
+
+    The Coherent Accelerator Interface Architecture (CAIA) introduces
+    a concept of a master context. A master typically has special
+    privileges granted to it by the kernel or hypervisor allowing
+    it to perform AFU wide management and control. The master may or
+    may not be involved directly in each user I/O, but at the minimum
+    is involved in the initial setup before the user application is
+    allowed to send requests directly to the AFU.
+
+    The CXL Flash Adapter Driver establishes a master context with
+    the AFU. It uses memory mapped I/O (MMIO) for this control and
+    setup. The Adapter Problem Space Memory Map looks like this:
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
+    This driver configures itself into the SCSI software stack
+    as an adapter driver. The driver is the only entity that
+    is considered a Trusted Process to program the Provisioning and 
+    Control and Global areas in the MMIO Space shown above.
+    The master context driver discovers all LUNs attached to the
+    CXL Flash adapter and instantiates scsi block devices
+    (/dev/sdb, /dev/sdc etc.) for each unique LUN seen from each path.
+
+    Once these scsi block devices are instantiated, an application
+    written to a specification provided by the block library may
+    get access to the Flash from user space (without requiring
+    a system call).
+
+    This master context driver also provides a series of ioctls
+    for this block library to enable this user space access.
+    The driver supports two modes for accessing the block device.
+
+    The first mode is called a virtual mode. In this mode a single
+    scsi block device (/dev/sdb) may be carved up into any number
+    of distinct virtual LUNs. The virtual LUNs may be resized as long
+    as the sum of the sizes of all the virtual LUNs, along with
+    the meta-data associated with it does not exceed the physical
+    capacity.
+
+    The second mode is called the physical mode. IN this mode a
+    single block device (/dev/sdb) may be opened directly by
+    the block library and the entire space for the LUN is available
+    to the application.
+
+    Only the physical mode provides persistence of the data.
+    i.e. The data written to the block device will survive application
+    exit and restart and also reboot. The virtual LUNs do not
+    persist (i.e. do not survive after the application terminates or
+    the system reboots).
+
+
+Block library API
+=================
+
+    Applications intending to get access to the CXL Flash from user
+    space should use the block library, as it abstracts the details
+    of interfacing directly with the cxlflash driver that are necessary
+    for performing administrative actions (i.e.: setup, tear down, resize).
+    The block library can be thought of as a 'user' of services, implemented
+    as IOCTLs, that are provided by the cxlflash driver specifically for
+    devices (LUNs) operating in user space access mode. While it is not
+    a requirement that applications understand the interface between the
+    block library and the cxlflash driver, a high-level overview of each
+    supported service (IOCTL) is provided below.
+
+    The block library can be found on GitHub:
+    http://www.github.com/mikehollinger/ibmcapikv
+
+
+CXL Flash Driver IOCTLs
+=======================
+
+    Users, such as the block library, that wish to interface with a
+    flash device (LUN) via user space access need to use the services
+    provided by the cxlflash driver. As these services are implemented
+    as ioctls, a file descriptor handle must first be obtained in order
+    to establish the communication channel between a user and the kernel.
+    This file descriptor is obtained by opening the device special file
+    associated with the scsi disk device (/dev/sdb) that was created
+    during LUN discovery. As per the location of the cxlflash driver within
+    the SCSI protocol stack, this open is actually not seen by the cxlflash
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
+          the process under which they were created. Once either is destroyed,
+          the tokens are to be considered stale and subsequent usage will
+          result in errors.
+
+        - When a context is no longer needed, the user shall detach from
+          the context via the DK_CXLFLASH_DETACH ioctl.
+
+        - A close on fd2 will invalidate the tokens. This operation is not
+          required by the user.
+
+DK_CXLFLASH_USER_DIRECT
+-----------------------
+    This ioctl is responsible for transitioning the LUN to direct (physical)
+    mode access and configuring the AFU for direct access from user space on
+    a per-context basis. Additionally, the block size and last logical block
+    address (LBA) are returned to the user.
+
+    As mentioned previously, when operating in user space access mode, LUNs
+    may be accessed in whole or in part. Only one mode is allowed at a time
+    and if one mode is active (outstanding references exist), requests to use
+    the LUN in a different mode are denied.
+
+    The AFU is configured for direct access from user space by adding an entry
+    to the AFU's resource handle table. The index of the entry is treated as a
+    resource handle that is returned to the user. The user is then able to use
+    the handle to reference the LUN during I/O.
+    
+DK_CXLFLASH_USER_VIRTUAL
+------------------------
+    This ioctl is responsible for transitioning the LUN to virtual mode of
+    access and configuring the AFU for virtual access from user space on a
+    per-context basis. Additionally, the block size and last logical block
+    address (LBA) are returned to the user.
+
+    As mentioned previously, when operating in user space access mode, LUNs
+    may be accessed in whole or in part. Only one mode is allowed at a time
+    and if one mode is active (outstanding references exist), requests to use
+    the LUN in a different mode are denied.
+
+    The AFU is configured for virtual access from user space by adding an entry
+    to the AFU's resource handle table. The index of the entry is treated as a
+    resource handle that is returned to the user. The user is then able to use
+    the handle to reference the LUN during I/O.
+
+    By default, the virtual LUN is created with a size of 0. The user would
+    need to use the DK_CXLFLASH_VLUN_RESIZE ioctl to adjust the grow the virtual
+    LUN to a desired size. To avoid having to perform this resize for the
+    initial creation of the virtual LUN, the user has the option of specifying
+    a size as part of the DK_CXLFLASH_USER_VIRTUAL ioctl, such that when success
+    is returned to the user, the resource handle that is provided is already
+    referencing provisioned storage. This is reflected by the last LBA being
+    a non-zero value.
+
+DK_CXLFLASH_VLUN_RESIZE
+-----------------------
+    This ioctl is responsible for resizing a previously created virtual LUN
+    and will fail if invoked upon a LUN that is not in virtual mode. Upon
+    success, an updated last LBA is returned to the user indicating the new
+    size of the virtual LUN associated with the resource handle.
+
+    The partitioning of virtual LUNs is jointly mediated by the cxlflash driver
+    and the AFU. An allocation table is kept for each LUN that is operating
+    in the virtual mode and used to program a LUN translation table that the
+    AFU references when provided with a resource handle. 
+
+DK_CXLFLASH_RELEASE
+-------------------
+    This ioctl is responsible for releasing a previously obtained reference
+    to either a physical or virtual LUN. This can be thought of as the inverse
+    of the DK_CXLFLASH_USER_DIRECT or DK_CXLFLASH_USER_VIRTUAL ioctls. Upon
+    success, the resource handle is no longer valid and the entry in the
+    resource handle table is made available to be used again.
+
+    As part of the release process for virtual LUNs, the virtual LUN is first
+    resized to 0 to clear out and free the translation tables associated with
+    the virtual LUN reference.
+
+DK_CXLFLASH_DETACH
+------------------
+    This ioctl is responsible for unregistering a context with the cxlflash
+    driver and release outstanding resources that were not explicitly released
+    via the DK_CXLFLASH_RELEASE ioctl. Upon success, all "tokens" which had been
+    provided to the user from the DK_CXLFLASH_ATTACH onward are no longer valid.
+
+DK_CXLFLASH_CLONE
+-----------------
+    This ioctl is responsible for cloning a previously created context to a more
+    recently created context. It exists solely to support maintaining user space
+    access to storage after a process forks. Upon success, the child process
+    (which invoked the ioctl) will have access to the same LUNs via the same
+    resource handle(s) and fd2 as the parent, but under a different context.
+
+    Context sharing across processes is not supported with CXL and
+    therefore each fork must be met with establishing a new context for the
+    child process. This ioctl simplifies the state management and playback
+    required by a user in such a scenario. When a process forks, child
+    process can clone the parents context by first creating a context
+    (via DK_CXLFLASH_ATTACH) and then using this ioctl to perform the clone
+    from the parent to the child.
+
+    The clone itself is fairly simple. The resource handle and lun
+    translation tables are copied from the parent context to the child's
+    and then synced with the AFU.
+
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index b021bcb..ebb12a7 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -345,6 +345,7 @@ source "drivers/scsi/cxgbi/Kconfig"
 source "drivers/scsi/bnx2i/Kconfig"
 source "drivers/scsi/bnx2fc/Kconfig"
 source "drivers/scsi/be2iscsi/Kconfig"
+source "drivers/scsi/cxlflash/Kconfig"
 
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index dee160a..619f8fb 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_SCSI_7000FASST)	+= wd7000.o
 obj-$(CONFIG_SCSI_EATA)		+= eata.o
 obj-$(CONFIG_SCSI_DC395x)	+= dc395x.o
 obj-$(CONFIG_SCSI_AM53C974)	+= esp_scsi.o	am53c974.o
+obj-$(CONFIG_CXLFLASH)		+= cxlflash/
 obj-$(CONFIG_MEGARAID_LEGACY)	+= megaraid.o
 obj-$(CONFIG_MEGARAID_NEWGEN)	+= megaraid/
 obj-$(CONFIG_MEGARAID_SAS)	+= megaraid/
diff --git a/drivers/scsi/cxlflash/Kconfig b/drivers/scsi/cxlflash/Kconfig
new file mode 100644
index 0000000..e98c3f6
--- /dev/null
+++ b/drivers/scsi/cxlflash/Kconfig
@@ -0,0 +1,11 @@
+#
+# IBM CXL-attached Flash Accelerator SCSI Driver
+#
+
+config CXLFLASH
+	tristate "Support for IBM CAPI Flash"
+	depends on CXL
+	default m
+	help
+	  Allows CAPI Accelerated IO to Flash
+	  If unsure, say N.
diff --git a/drivers/scsi/cxlflash/Makefile b/drivers/scsi/cxlflash/Makefile
new file mode 100644
index 0000000..90e9382
--- /dev/null
+++ b/drivers/scsi/cxlflash/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_CXLFLASH) += cxlflash.o
+cxlflash-y += main.o
+
+ccflags-y += -DCONFIG_PRINTK
diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
new file mode 100644
index 0000000..edab06a
--- /dev/null
+++ b/drivers/scsi/cxlflash/common.h
@@ -0,0 +1,287 @@
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
+#ifndef _CXLFLASH_COMMON_H
+#define _CXLFLASH_COMMON_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+
+
+#define MAX_CONTEXT  CXLFLASH_MAX_CONTEXT       /* num contexts per afu */
+
+#define CXLFLASH_BLOCK_SIZE	4096	/* 4K blocks */
+#define CXLFLASH_MAX_XFER_SIZE	16777216	/* 16MB transfer */
+#define CXLFLASH_MAX_SECTORS	(CXLFLASH_MAX_XFER_SIZE/CXLFLASH_BLOCK_SIZE)
+
+#define NUM_RRQ_ENTRY    16     /* for master issued cmds */
+#define MAX_RHT_PER_CONTEXT 16  /* num resource hndls per context */
+
+/* Command management definitions */
+#define CXLFLASH_NUM_CMDS	(2 * CXLFLASH_MAX_CMDS)	/* Must be a pow2 for 
+							   alignment and more 
+							   efficient array 
+							   index derivation 
+							 */
+
+#define CXLFLASH_MAX_CMDS               16
+#define CXLFLASH_MAX_CMDS_PER_LUN       CXLFLASH_MAX_CMDS
+
+#define NOT_POW2(_x) ((_x) & ((_x) & ((_x) -1)))
+#if NOT_POW2(CXLFLASH_NUM_CMDS)
+#error "CXLFLASH_NUM_CMDS is not a power of 2!"
+#endif
+
+#define AFU_SYNC_INDEX  (CXLFLASH_NUM_CMDS - 1)	/* last cmd rsvd for afu sync */
+
+#define CMD_BUFSIZE     PAGE_SIZE_4K
+
+/* flags in IOA status area for host use */
+#define B_DONE       0x01
+#define B_ERROR      0x02	/* set with B_DONE */
+#define B_TIMEOUT    0x04	/* set with B_DONE & B_ERROR */
+
+/*
+ * Error logging macros
+ *
+ * These wrappers around pr|dev_* add the function name and newline character
+ * automatically, avoiding the need to include them inline with each trace
+ * statement and saving line width.
+ *
+ * The parameters must be split into the format string and variable list of
+ * parameters in order to support concatenation of the function format
+ * specifier and newline character. The CONFN macro is a helper to simplify
+ * the contactenation and make it easier to change the desired format. Lastly,
+ * the variable list is passed with a dummy concatenation. This trick is used
+ * to support the case where no parameters are passed and the user simply
+ * desires a single string trace.
+ */
+#define CONFN(_s) "%s: "_s"\n"
+#define cxlflash_err(_s,   ...)	pr_err(CONFN(_s),   __func__, ##__VA_ARGS__)
+#define cxlflash_warn(_s,  ...)	pr_warn(CONFN(_s),  __func__, ##__VA_ARGS__)
+#define cxlflash_info(_s,  ...)	pr_info(CONFN(_s),  __func__, ##__VA_ARGS__)
+#define cxlflash_dbg(_s, ...)	pr_debug(CONFN(_s), __func__, ##__VA_ARGS__)
+
+#define cxlflash_dev_err(_d, _s, ...)	\
+	dev_err(_d, CONFN(_s), __func__, ##__VA_ARGS__)
+#define cxlflash_dev_warn(_d, _s, ...)	\
+	dev_warn(_d, CONFN(_s), __func__, ##__VA_ARGS__)
+#define cxlflash_dev_info(_d, _s, ...)	\
+	dev_info(_d, CONFN(_s), __func__, ##__VA_ARGS__)
+#define cxlflash_dev_dbg(_d, _s, ...)	\
+	dev_dbg(_d, CONFN(_s), __func__, ##__VA_ARGS__)
+
+enum open_mode_type {
+	MODE_NONE = 0,
+	MODE_VIRTUAL,
+	MODE_PHYSICAL
+};
+
+enum cxlflash_lr_state {
+	LINK_RESET_INVALID,
+	LINK_RESET_REQUIRED,
+	LINK_RESET_COMPLETE
+};
+
+struct cxlflash_ctx {
+	struct cxl_ioctl_start_work work;
+	int lfd;
+	pid_t pid;
+	struct cxl_context *ctx;
+};
+
+/*
+ * Each context has its own set of resource handles that is visible
+ * only from that context.
+ *
+ * The rht_info refers to all resource handles of a context and not to
+ * a particular RHT entry or a single resource handle.
+ */
+struct rht_info {
+	struct sisl_rht_entry *rht_start;	/* initialized at startup */
+	int ref_cnt;		/* num ctx_infos pointing to me */
+	u32 perms;		/* User-defined (@attach) permissions for RHT entries */
+};
+
+/* Single AFU context can be pointed to by multiple client connections.
+ * The client can create multiple endpoints (mc_hndl_t) to the same
+ * (context + AFU).
+ */
+struct ctx_info {
+	volatile struct sisl_ctrl_map *ctrl_map;	/* initialized at startup */
+	struct rht_info *rht_info;	/* initialized when context created */
+
+	int ref_cnt;		/* num conn_infos pointing to me */
+};
+
+struct cxlflash {
+	struct afu *afu;
+	struct cxl_context *mcctx;
+
+	struct pci_dev *dev;
+	struct pci_device_id *dev_id;
+	struct Scsi_Host *host;
+
+	unsigned long cxlflash_regs_pci;
+	void __iomem *cxlflash_regs;
+
+	wait_queue_head_t reset_wait_q;
+	wait_queue_head_t msi_wait_q;
+	wait_queue_head_t eeh_wait_q;
+
+	struct work_struct work_q;
+	enum cxlflash_lr_state lr_state;
+	int lr_port;
+
+	struct cxl_afu *cxl_afu;
+	timer_t timer_hb;
+	timer_t timer_fc;
+
+	struct pci_pool *cxlflash_cmd_pool;
+	struct pci_dev *parent_dev;
+
+	int num_user_contexts;
+	struct cxlflash_ctx per_context[MAX_CONTEXT];
+	struct file_operations cxl_fops;
+
+	int last_lun_index;
+	int task_set;
+
+	wait_queue_head_t tmf_wait_q;
+	u8 context_reset_active:1;
+	u8 tmf_active:1;
+};
+
+struct afu_cmd {
+	struct sisl_ioarcb rcb;	/* IOARCB (cache line aligned) */
+	struct sisl_ioasa sa;	/* IOASA must follow IOARCB */
+	spinlock_t slock;
+	struct timer_list timer;
+	char *buf;		/* per command buffer */
+	struct afu *back;
+	int slot;
+	atomic_t free;
+	u8 special:1;
+	u8 internal:1;
+
+} __attribute__ ((aligned(cache_line_size())));
+
+struct afu {
+	/* Stuff requiring alignment go first. */
+
+	u64 rrq_entry[NUM_RRQ_ENTRY];	/* 128B RRQ (page aligned) */
+	/*
+	 * Command & data for AFU commands.
+	 */
+	struct afu_cmd cmd[CXLFLASH_NUM_CMDS];
+
+	/* Housekeeping data */
+	struct ctx_info ctx_info[MAX_CONTEXT];
+	struct rht_info rht_info[MAX_CONTEXT];
+	struct mutex afu_mutex;	/* for anything that needs serialization
+				   e. g. to access afu */
+	struct mutex err_mutex;	/* for signalling error thread */
+	wait_queue_head_t err_cv;
+	int err_flag;
+#define E_SYNC_INTR   0x1	/* synchronous error interrupt */
+#define E_ASYNC_INTR  0x2	/* asynchronous error interrupt */
+
+	/* AFU Shared Data */
+	struct sisl_rht_entry rht[MAX_CONTEXT][MAX_RHT_PER_CONTEXT];
+	/* LXTs are allocated dynamically in groups */
+	/* Beware of alignment till here. Preferably introduce new
+	 * fields after this point 
+	 */
+
+	/* AFU HW */
+	int afu_fd;
+	struct cxl_ioctl_start_work work;
+	volatile struct cxlflash_afu_map *afu_map;	/* entire MMIO map */
+	volatile struct sisl_host_map *host_map;	/* master's sislite host map */
+	volatile struct sisl_ctrl_map *ctrl_map;	/* master's control map */
+
+	ctx_hndl_t ctx_hndl;	/* master's context handle */
+	u64 *hrrq_start;
+	u64 *hrrq_end;
+	volatile u64 *hrrq_curr;
+	unsigned int toggle;
+	u64 room;
+	u64 hb;
+	u32 cmd_couts;		/* Number of command checkouts */
+	u32 internal_lun;	/* User-desired LUN mode for this AFU */
+
+	char version[8];
+	u64 interface_version;
+
+	struct list_head luns;	/* list of lun_info structs */
+	struct cxlflash *back;	/* Pointer back to parent cxlflash */
+
+} __attribute__ ((aligned(PAGE_SIZE_4K)));
+
+struct ba_lun {
+	u64 lun_id;
+	u64 wwpn;
+	size_t lsize;		/* Lun size in number of LBAs             */
+	size_t lba_size;	/* LBA size in number of bytes            */
+	size_t au_size;		/* Allocation Unit size in number of LBAs */
+	void *ba_lun_handle;
+};
+
+/* Block Alocator */
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
+	enum open_mode_type mode;
+
+	spinlock_t slock;
+
+	struct blka blka;
+	struct scsi_device *sdev;
+	struct list_head list;
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
+	unsigned char *aun_clone_map;
+};
+
+void cxlflash_send_cmd(struct afu *, struct afu_cmd *);
+void cxlflash_wait_resp(struct afu *, struct afu_cmd *);
+int cxlflash_check_status(struct sisl_ioasa *);
+int cxlflash_afu_reset(struct cxlflash *);
+struct afu_cmd *cxlflash_cmd_checkout(struct afu *);
+void cxlflash_cmd_checkin(struct afu_cmd *);
+int cxlflash_afu_sync(struct afu *, ctx_hndl_t, res_hndl_t, u8);
+#endif /* ifndef _CXLFLASH_COMMON_H */
+
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
new file mode 100644
index 0000000..2533ecb
--- /dev/null
+++ b/drivers/scsi/cxlflash/main.c
@@ -0,0 +1,2081 @@
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
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include <asm/unaligned.h>
+
+#include <misc/cxl.h>
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+
+#include "main.h"
+#include "sislite.h"
+#include "common.h"
+
+MODULE_DESCRIPTION(CXLFLASH_ADAPTER_NAME);
+MODULE_AUTHOR("Manoj N. Kumar <manoj@linux.vnet.ibm.com>");
+MODULE_AUTHOR("Matthew R. Ochs <mrochs@linux.vnet.ibm.com>");
+MODULE_LICENSE("GPL");
+
+u32 internal_lun = 0;
+u32 checkpid = 0;
+
+/*
+ * This is a temporary module parameter
+ *
+ * The CXL Flash AFU supports a dummy LUN mode where the external
+ * links and storage are not required. Space on the FPGA is used
+ * to create 1 or 2 small LUNs which are presented to the system
+ * as if they were a normal storage device. This feature is useful
+ * during development and also provides manufacturing with a way
+ * to test the AFU without an actual device. The setting for this
+ * mode will eventually be fully migrated to a per-adapter sysfs
+ * tunable.
+ */
+module_param_named(lun_mode, internal_lun, uint, 0);
+MODULE_PARM_DESC(lun_mode, " 0 = external LUN[s](default),\n"
+		 " 1 = internal LUN (1 x 64K, 512B blocks, id 0),\n"
+		 " 2 = internal LUN (1 x 64K, 4K blocks, id 0),\n"
+		 " 3 = internal LUN (2 x 32K, 512B blocks, ids 0,1),\n"
+		 " 4 = internal LUN (2 x 32K, 4K blocks, ids 0,1)");
+
+/*
+ * This is a temporary module parameter
+ *
+ * Contexts are only valid under the process that created them.
+ * This tunable enables logic to enforce this behavior. It is
+ * currently defaulted to disable as there are some tests that
+ * violate this rule. This will be removed in the near future.
+ */
+module_param_named(checkpid, checkpid, uint, 0);
+MODULE_PARM_DESC(checkpid, " 1 = Enforce PID/context ownership policy");
+
+/* Check out a command */
+struct afu_cmd *cxlflash_cmd_checkout(struct afu *afu)
+{
+	int k, dec = CXLFLASH_NUM_CMDS;
+	struct afu_cmd *cmd;
+
+	while (dec--) {
+		k = (afu->cmd_couts++ & (CXLFLASH_NUM_CMDS - 1));
+
+		/* The last command structure is reserved for SYNC */
+		if (k == AFU_SYNC_INDEX)
+			continue;
+
+		cmd = &afu->cmd[k];
+
+		if (!atomic_dec_if_positive(&cmd->free)) {
+			cxlflash_dbg("returning found index=%d", cmd->slot);
+			memset(cmd->buf, 0, CMD_BUFSIZE);
+			memset(cmd->rcb.cdb, 0, sizeof(cmd->rcb.cdb));
+			return cmd;
+		}
+	}
+
+	return NULL;
+}
+
+/* Check in the command */
+void cxlflash_cmd_checkin(struct afu_cmd *cmd)
+{
+	if (atomic_inc_return(&cmd->free) != 1) {
+		cxlflash_info("freeing command that is not in use");
+		return;
+	}
+	else {
+		cmd->special = 0;
+		cmd->internal = false;
+		cmd->rcb.timeout = 0;
+	}
+	cxlflash_dbg("releasing cmd index=%d", cmd->slot);
+
+}
+
+void cmd_complete(struct afu_cmd *cmd)
+{
+	unsigned long lock_flags = 0UL;
+	struct scsi_cmnd *scp;
+	struct afu *afu = cmd->back;
+	struct cxlflash *cxlflash = afu->back;
+
+	spin_lock_irqsave(&cmd->slock, lock_flags);
+	cmd->sa.host_use_b[0] |= B_DONE;
+	spin_unlock_irqrestore(&cmd->slock, lock_flags);
+
+	/* already stopped if timer fired */
+	del_timer(&cmd->timer);
+
+	if (cmd->rcb.rsvd2) {
+		scp = (struct scsi_cmnd *)cmd->rcb.rsvd2;
+		if (cmd->sa.rc.afu_rc || cmd->sa.rc.scsi_rc ||
+		    cmd->sa.rc.fc_rc) {
+			/* XXX: Needs to be decoded to report errors */
+			scp->result = (DID_OK << 16);
+		} else {
+			scp->result = (DID_OK << 16);
+		}
+		cxlflash_dbg("calling scsi_set_resid, scp=0x%llx "
+			     "resid=%d afu_rc=%d scsi_rc=%d fc_rc=%d",
+			     cmd->rcb.rsvd2, cmd->sa.resid,
+			     cmd->sa.rc.afu_rc, cmd->sa.rc.scsi_rc,
+			     cmd->sa.rc.fc_rc);
+
+		scsi_set_resid(scp, cmd->sa.resid);
+		scsi_dma_unmap(scp);
+		scp->scsi_done(scp);
+		cmd->rcb.rsvd2 = 0;
+		if (cmd->special) {
+			cxlflash->tmf_active = 0;
+			wake_up_all(&cxlflash->tmf_wait_q);
+		}
+	}
+
+	/* Done with command */
+	cxlflash_cmd_checkin(cmd);
+}
+
+/**
+ * cxlflash_send_tmf - Send a Task Management Function
+ * @afu:        struct afu pointer
+ * @scp:          scsi command passed in 
+ * cmd:           Kind of TMF command
+ *
+ * Returns:
+ *      SUCCESS, BUSY
+ */
+int cxlflash_send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
+{
+	struct afu_cmd *cmd;
+
+	u32 port_sel = scp->device->channel + 1;
+	short lflag = 0;
+	struct Scsi_Host *host = scp->device->host;
+	struct cxlflash *cxlflash = (struct cxlflash *)host->hostdata;
+	int rc = 0;
+
+	while (cxlflash->tmf_active)
+		wait_event(cxlflash->tmf_wait_q, !cxlflash->tmf_active);
+
+	cmd = cxlflash_cmd_checkout(afu);
+	if (unlikely(!cmd)) {
+		cxlflash_err("could not get a free command");
+		rc = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	}
+
+	cmd->rcb.ctx_id = afu->ctx_hndl;
+	cmd->rcb.port_sel = port_sel;
+	cmd->rcb.lun_id = lun_to_lunid(scp->device->lun);
+
+	lflag = SISL_REQ_FLAGS_TMF_CMD;
+
+	cmd->rcb.req_flags = (SISL_REQ_FLAGS_PORT_LUN_ID |
+				SISL_REQ_FLAGS_SUP_UNDERRUN | lflag);
+
+	/* Stash the scp in the reserved field, for reuse during interrupt */
+	cmd->rcb.rsvd2 = (u64) scp;
+	cmd->special = 0x1;
+	cxlflash->tmf_active = 0x1;
+
+	cmd->sa.host_use_b[1] = 0;	/* reset retry cnt */
+
+	/* Copy the CDB from the cmd passed in */
+	memcpy(cmd->rcb.cdb, &tmfcmd, sizeof(tmfcmd));
+
+	/* Send the command */
+	cxlflash_send_cmd(afu, cmd);
+	wait_event(cxlflash->tmf_wait_q, !cxlflash->tmf_active);
+out:
+	return rc;
+
+}
+
+/**
+ * cxlflash_driver_info - Get information about the card/driver
+ * @scsi_host:       scsi host struct
+ *
+ * Return value:
+ *      pointer to buffer with description string
+ **/
+static const char *cxlflash_driver_info(struct Scsi_Host *host)
+{
+	return CXLFLASH_ADAPTER_NAME;
+}
+
+/**
+ * cxlflash_queuecommand - Queue a mid-layer request
+ * @shost:               scsi host struct
+ * @scsi_cmd:            scsi command struct
+ *
+ * This function queues a request generated by the mid-layer.
+ *
+ * Return value:
+ *      0 on success
+ *      SCSI_MLQUEUE_DEVICE_BUSY if device is busy
+ *      SCSI_MLQUEUE_HOST_BUSY if host is busy
+ **/
+static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
+{
+	struct cxlflash *cxlflash = (struct cxlflash *)host->hostdata;
+	struct afu *afu = cxlflash->afu;
+	struct pci_dev *pdev = cxlflash->dev;
+	struct afu_cmd *cmd;
+	u32 port_sel = scp->device->channel + 1;
+	int nseg, i, ncount;
+	struct scatterlist *sg;
+	short lflag = 0;
+	int rc = 0;
+
+	cxlflash_dbg("(scp=%p) %d/%d/%d/%llu cdb=(%08x-%08x-%08x-%08x)",
+		     scp, host->host_no, scp->device->channel,
+		     scp->device->id, scp->device->lun,
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+
+	while (cxlflash->tmf_active)
+		wait_event(cxlflash->tmf_wait_q, !cxlflash->tmf_active);
+
+	cmd = cxlflash_cmd_checkout(afu);
+	if (unlikely(!cmd)) {
+		cxlflash_err("could not get a free command");
+		rc = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	}
+
+	cmd->rcb.ctx_id = afu->ctx_hndl;
+	cmd->rcb.port_sel = port_sel;
+	cmd->rcb.lun_id = lun_to_lunid(scp->device->lun);
+
+	if (scp->sc_data_direction == DMA_TO_DEVICE)
+		lflag = SISL_REQ_FLAGS_HOST_WRITE;
+	else
+		lflag = SISL_REQ_FLAGS_HOST_READ;
+
+	cmd->rcb.req_flags = (SISL_REQ_FLAGS_PORT_LUN_ID |
+				SISL_REQ_FLAGS_SUP_UNDERRUN | lflag);
+
+	/* Stash the scp in the reserved field, for reuse during interrupt */
+	cmd->rcb.rsvd2 = (u64) scp;
+
+	cmd->sa.host_use_b[1] = 0;	/* reset retry cnt */
+
+	nseg = scsi_dma_map(scp);
+	if (unlikely(nseg < 0)) {
+		cxlflash_dev_err(&pdev->dev, "Fail DMA map! nseg=%d", nseg);
+		rc = SCSI_MLQUEUE_DEVICE_BUSY;
+		goto out;
+	}
+
+	ncount = scsi_sg_count(scp);
+	scsi_for_each_sg(scp, sg, ncount, i) {
+		cmd->rcb.data_len = (sg_dma_len(sg));
+		cmd->rcb.data_ea = (sg_dma_address(sg));
+	}
+
+	/* Copy the CDB from the scsi_cmnd passed in */
+	memcpy(cmd->rcb.cdb, scp->cmnd, sizeof(cmd->rcb.cdb));
+
+	/* Send the command */
+	cxlflash_send_cmd(afu, cmd);
+
+out:
+	return rc;
+}
+
+/**
+ * cxlflash_eh_device_reset_handler - Reset a single LUN
+ * @cmd:        scsi command struct
+ *
+ * Returns:
+ *      SUCCESS / FAST_IO_FAIL / FAILED
+ **/
+static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
+{
+	int rc = SUCCESS;
+	struct Scsi_Host *host = scp->device->host;
+	struct cxlflash *cxlflash = (struct cxlflash *)host->hostdata;
+	struct afu *afu = cxlflash->afu;
+
+	cxlflash_dbg("(scp=%p) %d/%d/%d/%llu "
+		     "cdb=(%08x-%08x-%08x-%08x)", scp,
+		     host->host_no, scp->device->channel,
+		     scp->device->id, scp->device->lun,
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+
+	scp->result = (DID_OK << 16);;
+	cxlflash_send_tmf(afu, scp, TMF_LUN_RESET);
+
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+}
+
+/**
+ * cxlflash_eh_host_reset_handler - Reset the connection to the server
+ * @cmd:        struct scsi_cmnd having problems
+ *
+ **/
+static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
+{
+	int rc = SUCCESS;
+	int rcr = 0;
+	struct Scsi_Host *host = scp->device->host;
+	struct cxlflash *cxlflash = (struct cxlflash *)host->hostdata;
+
+	cxlflash_dbg("(scp=%p) %d/%d/%d/%llu "
+		     "cdb=(%08x-%08x-%08x-%08x)", scp,
+		     host->host_no, scp->device->channel,
+		     scp->device->id, scp->device->lun,
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+
+	scp->result = (DID_OK << 16);;
+	rcr = cxlflash_afu_reset(cxlflash);
+	if (rcr == 0)
+		rc = SUCCESS;
+	else
+		rc = FAILED;
+
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+}
+
+static struct lun_info *create_lun_info(struct scsi_device *sdev)
+{
+	struct lun_info *lun_info = NULL;
+
+	lun_info = kzalloc(sizeof(*lun_info), GFP_KERNEL);
+	if (unlikely(!lun_info)) {
+		cxlflash_err("could not allocate lun_info");
+		goto create_lun_info_exit;
+	}
+
+	lun_info->sdev = sdev;
+
+	spin_lock_init(&lun_info->slock);
+
+create_lun_info_exit:
+	cxlflash_info("returning %p", lun_info);
+	return lun_info;
+}
+
+/**
+ * cxlflash_slave_alloc - Setup the device's task set value
+ * @sdev:       struct scsi_device device to configure
+ *
+ * Set the device's task set value so that error handling works as
+ * expected.
+ *
+ * Returns:
+ *      0 on success / -ENOMEM when memory allocation fails
+ **/
+static int cxlflash_slave_alloc(struct scsi_device *sdev)
+{
+	struct lun_info *lun_info = NULL;
+	struct Scsi_Host *shost = sdev->host;
+	struct cxlflash *cxlflash = shost_priv(shost);
+	struct afu *afu = cxlflash->afu;
+	unsigned long flags = 0;
+	int rc = 0;
+
+	lun_info = create_lun_info(sdev);
+	if (unlikely(!lun_info)) {
+		cxlflash_err("failed to allocate lun_info!");
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	sdev->hostdata = lun_info;
+	list_add(&lun_info->list, &afu->luns);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+out:
+	cxlflash_info("returning task_set %d luninfo %p sdev %p",
+		      cxlflash->task_set, lun_info, sdev);
+	return rc;
+}
+
+/**
+ * cxlflash_slave_configure - Configure the device
+ * @sdev:       struct scsi_device device to configure
+ *
+ * Enable allow_restart for a device if it is a disk. Adjust the
+ * queue_depth here also.
+ *
+ * Returns:
+ *      0
+ **/
+static int cxlflash_slave_configure(struct scsi_device *sdev)
+{
+	struct lun_info *lun_info = sdev->hostdata;
+	int rc = 0;
+	struct Scsi_Host *shost = sdev->host;
+	struct cxlflash *cxlflash = shost_priv(shost);
+	struct afu *afu = cxlflash->afu;
+
+
+	cxlflash_info("ID = %08X", sdev->id);
+	cxlflash_info("CHANNEL = %08X", sdev->channel);
+	cxlflash_info("LUN = %016llX", sdev->lun);
+	cxlflash_info("sector_size = %u", sdev->sector_size);
+
+	/* Store off lun in unpacked, AFU-friendly format */
+	lun_info->lun_id = lun_to_lunid(sdev->lun);
+	cxlflash_info("LUN2 = %016llX", lun_info->lun_id);
+
+	writeq_be(lun_info->lun_id,
+		  &afu->afu_map->global.fc_port[sdev->channel]
+		  [cxlflash->last_lun_index++]);
+	cxlflash_info("LBA = %016llX", lun_info->max_lba);
+	cxlflash_info("BLK_LEN = %08X", lun_info->blk_len);
+
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+}
+
+static void ba_terminate(struct ba_lun *ba_lun)
+{
+	struct ba_lun_info *lun_info =
+	    (struct ba_lun_info *)ba_lun->ba_lun_handle;
+
+	if (lun_info) {
+		if (lun_info->aun_clone_map)
+			kfree(lun_info->aun_clone_map);
+		if (lun_info->lun_alloc_map)
+			kfree(lun_info->lun_alloc_map);
+		kfree(lun_info);
+		ba_lun->ba_lun_handle = NULL;
+	}
+}
+
+static void cxlflash_slave_destroy(struct scsi_device *sdev)
+{
+	struct lun_info *lun_info = sdev->hostdata;
+
+	if (lun_info) {
+		sdev->hostdata = NULL;
+		list_del(&lun_info->list);
+		ba_terminate(&lun_info->blka.ba_lun);
+		kfree(lun_info);
+	}
+
+	cxlflash_info("lun_info=%p", lun_info);
+	return;
+}
+
+/**
+ * cxlflash_change_queue_depth - Change the device's queue depth
+ * @sdev:       scsi device struct
+ * @qdepth:     depth to set
+ * @reason:     calling context
+ *
+ * Return value:
+ *      actual depth set
+ **/
+static int cxlflash_change_queue_depth(struct scsi_device *sdev, int qdepth)
+{
+
+	if (qdepth > CXLFLASH_MAX_CMDS_PER_LUN)
+		qdepth = CXLFLASH_MAX_CMDS_PER_LUN;
+
+	scsi_change_queue_depth(sdev, qdepth);
+	return sdev->queue_depth;
+}
+
+static ssize_t cxlflash_show_port_status(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash *cxlflash = (struct cxlflash *)shost->hostdata;
+	struct afu *afu = cxlflash->afu;
+
+	char *disp_status;
+	int rc;
+	u32 port;
+	u64 status;
+	volatile u64 *fc_regs;
+
+	rc = kstrtouint((attr->attr.name + 4), 10, &port);
+	if (rc || (port > NUM_FC_PORTS))
+		return 0;
+
+	fc_regs = &afu->afu_map->global.fc_regs[port][0];
+	status =
+	    (readq_be(&fc_regs[FC_MTIP_STATUS / 8]) & FC_MTIP_STATUS_MASK);
+
+	if (status == FC_MTIP_STATUS_ONLINE)
+		disp_status = "online";
+	else if (status == FC_MTIP_STATUS_OFFLINE)
+		disp_status = "offline";
+	else
+		disp_status = "unknown";
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", disp_status);
+}
+
+static ssize_t cxlflash_show_lun_mode(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash *cxlflash = (struct cxlflash *)shost->hostdata;
+	struct afu *afu = cxlflash->afu;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", afu->internal_lun);
+}
+
+static ssize_t cxlflash_store_lun_mode(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash *cxlflash = (struct cxlflash *)shost->hostdata;
+	struct afu *afu = cxlflash->afu;
+	int rc;
+	u32 lun_mode;
+
+	rc = kstrtouint(buf, 10, &lun_mode);
+	if (!rc && (lun_mode < 5) && (lun_mode != afu->internal_lun))
+		afu->internal_lun = lun_mode;
+
+	/* XXX - need to reset device w/ new lun mode */
+
+	return count;
+}
+
+/**
+ * cxlflash_wait_for_pci_err_recovery - Wait for any PCI error recovery to
+ *					complete during probe time
+ * @cxlflash:    cxlflash config struct
+ *
+ * Return value:
+ *	None
+ */
+static void cxlflash_wait_for_pci_err_recovery(struct cxlflash *cxlflash)
+{
+	struct pci_dev *pdev = cxlflash->dev;
+
+	if (pci_channel_offline(pdev))
+		wait_event_timeout(cxlflash->eeh_wait_q,
+				   !pci_channel_offline(pdev),
+				   CXLFLASH_PCI_ERROR_RECOVERY_TIMEOUT);
+}
+
+static DEVICE_ATTR(port0, S_IRUGO, cxlflash_show_port_status, NULL);
+static DEVICE_ATTR(port1, S_IRUGO, cxlflash_show_port_status, NULL);
+static DEVICE_ATTR(lun_mode, S_IRUGO | S_IWUSR, cxlflash_show_lun_mode,
+		   cxlflash_store_lun_mode);
+
+static struct device_attribute *cxlflash_attrs[] = {
+	&dev_attr_port0,
+	&dev_attr_port1,
+	&dev_attr_lun_mode,
+	NULL
+};
+
+static struct scsi_host_template driver_template = {
+	.module = THIS_MODULE,
+	.name = CXLFLASH_ADAPTER_NAME,
+	.info = cxlflash_driver_info,
+	.proc_name = CXLFLASH_NAME,
+	.queuecommand = cxlflash_queuecommand,
+	.eh_device_reset_handler = cxlflash_eh_device_reset_handler,
+	.eh_host_reset_handler = cxlflash_eh_host_reset_handler,
+	.slave_alloc = cxlflash_slave_alloc,
+	.slave_configure = cxlflash_slave_configure,
+	.slave_destroy = cxlflash_slave_destroy,
+	.change_queue_depth = cxlflash_change_queue_depth,
+	.cmd_per_lun = 16,
+	.can_queue = CXLFLASH_MAX_CMDS,
+	.this_id = -1,
+	.sg_tablesize = SG_NONE,	/* No scatter gather support. */
+	.max_sectors = CXLFLASH_MAX_SECTORS,
+	.use_clustering = ENABLE_CLUSTERING,
+	.shost_attrs = cxlflash_attrs,
+};
+
+static struct dev_dependent_vals dev_corsa_vals = { CXLFLASH_MAX_SECTORS };
+
+static struct pci_device_id cxlflash_pci_table[] = {
+	{PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CORSA,
+	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, (kernel_ulong_t)&dev_corsa_vals},
+	{}
+};
+
+#if 0 /* Temporarily disable auto-load */
+MODULE_DEVICE_TABLE(pci, cxlflash_pci_table);
+#endif
+
+/**
+ * cxlflash_free_mem - Frees memory allocated for an adapter
+ * @cxlflash:    struct cxlflash reference
+ *
+ * Return value:
+ *      nothing
+ **/
+static void cxlflash_free_mem(struct cxlflash *cxlflash)
+{
+	int i;
+	char *buf = NULL;
+	struct afu *afu = cxlflash->afu;
+	struct lun_info *lun_info, *temp;
+
+	if (cxlflash->afu) {
+		list_for_each_entry_safe(lun_info, temp, &afu->luns, list) {
+			list_del(&lun_info->list);
+			ba_terminate(&lun_info->blka.ba_lun);
+			kfree(lun_info);
+		}
+
+		for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
+			del_timer_sync(&cxlflash->afu->cmd[i].timer);
+			buf = cxlflash->afu->cmd[i].buf;
+			if (!((u64)buf & (PAGE_SIZE - 1)))
+				free_page((unsigned long)buf);
+		}
+
+		free_pages((unsigned long)cxlflash->afu,
+			   get_order(sizeof(struct afu)));
+		cxlflash->afu = NULL;
+	}
+
+	return;
+}
+
+/**
+ * cxlflash_stoafu - Stop AFU
+ * @cxlflash:       struct cxlflash
+ *
+ * Tear down timers, Unmap the MMIO space
+ *
+ * Return value:
+ *      none
+ **/
+static void cxlflash_stoafu(struct cxlflash *cxlflash)
+{
+	int i;
+	struct afu *afu = cxlflash->afu;
+
+	if (!afu) {
+		cxlflash_info("returning because afu is NULl");
+		return;
+	}
+
+	/* Need to stop timers before unmapping */
+	for (i = 0; i < CXLFLASH_NUM_CMDS; i++)
+		del_timer_sync(&cxlflash->afu->cmd[i].timer);
+
+	if (afu->afu_map) {
+		cxl_psa_unmap((void *)afu->afu_map);
+		afu->afu_map = NULL;
+	}
+}
+
+/**
+ * cxlflash_term_mc - Terminate the master context
+ * @cxlflash:        struct cxlflash pointer
+ * @level:           level to back out from
+ *
+ * Returns:
+ *      NONE
+ */
+void cxlflash_term_mc(struct cxlflash *cxlflash, enum undo_level level)
+{
+	struct afu *afu = cxlflash->afu;
+
+	if (!afu || !cxlflash->mcctx) {
+		cxlflash_info("returning from term_mc with NULL afu or MC");
+		return;
+	}
+
+	switch (level) {
+	case UNDO_START:
+		cxl_stop_context(cxlflash->mcctx);
+	case UNMAP_FOUR:
+		cxlflash_info("before unmap 4");
+		cxl_unmap_afu_irq(cxlflash->mcctx, 4, afu);
+	case UNMAP_THREE:
+		cxlflash_info("before unmap 3");
+		cxl_unmap_afu_irq(cxlflash->mcctx, 3, afu);
+	case UNMAP_TWO:
+		cxlflash_info("before unmap 2");
+		cxl_unmap_afu_irq(cxlflash->mcctx, 2, afu);
+	case UNMAP_ONE:
+		cxlflash_info("before unmap 1");
+		cxl_unmap_afu_irq(cxlflash->mcctx, 1, afu);
+	case FREE_IRQ:
+		cxlflash_info("before cxl_free_afu_irqs");
+		cxl_free_afu_irqs(cxlflash->mcctx);
+		cxlflash_info("before cxl_release_context");
+	case RELEASE_CONTEXT:
+		cxl_release_context(cxlflash->mcctx);
+		cxlflash->mcctx = NULL;
+	}
+}
+
+static void cxlflash_term_afu(struct cxlflash *cxlflash)
+{
+	cxlflash_term_mc(cxlflash, UNDO_START);
+
+	/* Need to stop timers before unmapping */
+	if (cxlflash->afu)
+		cxlflash_stoafu(cxlflash);
+
+	cxlflash_info("returning");
+}
+
+/**
+ * cxlflash_remove - CXLFLASH hot plug remove entry point
+ * @pdev:       pci device struct
+ *
+ * Adapter hot plug remove entry point.
+ *
+ * Return value:
+ *      none
+ **/
+static void cxlflash_remove(struct pci_dev *pdev)
+{
+	struct cxlflash *cxlflash = pci_get_drvdata(pdev);
+
+	cxlflash_dev_err(&pdev->dev, "enter cxlflash_remove!");
+
+	while (cxlflash->tmf_active)
+		wait_event(cxlflash->tmf_wait_q, !cxlflash->tmf_active);
+
+	/* Use this for now to indicate that scsi_add_host() was performed */
+	if (cxlflash->host->cmd_pool) {
+		scsi_remove_host(cxlflash->host);
+		cxlflash_dev_err(&pdev->dev, "after scsi_remove_host!");
+	}
+	flush_work(&cxlflash->work_q);
+
+	cxlflash_term_afu(cxlflash);
+	cxlflash_dev_dbg(&pdev->dev, "after struct cxlflash_term_afu!");
+
+	if (cxlflash->cxlflash_regs)
+		iounmap(cxlflash->cxlflash_regs);
+
+	pci_release_regions(cxlflash->dev);
+
+	cxlflash_free_mem(cxlflash);
+	scsi_host_put(cxlflash->host);
+	cxlflash_dev_dbg(&pdev->dev, "after scsi_host_put!");
+
+	pci_disable_device(pdev);
+
+	cxlflash_dbg("returning");
+}
+
+/**
+ * cxlflash_gb_alloc - Global allocator
+ * @cxlflash:       struct cxlflash
+ *
+ * Adapter hot plug remove entry point.
+ *
+ * Return value:
+ *      none
+ **/
+static int cxlflash_gb_alloc(struct cxlflash *cxlflash)
+{
+	int rc = 0;
+	int i;
+	char *buf = NULL;
+
+	cxlflash->afu = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+						 get_order(sizeof(struct afu)));
+	if (unlikely(!cxlflash->afu)) {
+		cxlflash_err("cannot get %d free pages",
+			     get_order(sizeof(struct afu)));
+		rc = -ENOMEM;
+		goto out;
+	}
+	cxlflash->afu->back = cxlflash;
+	cxlflash->afu->afu_map = NULL;
+
+	/* Allocate one extra, just in case the SYNC command needs a buffer */
+	for (i = 0; i < CXLFLASH_NUM_CMDS; buf+=CMD_BUFSIZE, i++) {
+		if (!((u64)buf & (PAGE_SIZE - 1))) {
+			buf = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+			if (unlikely(!buf)) {
+				cxlflash_err("Allocate command buffers fail!");
+				rc = -ENOMEM;
+				cxlflash_free_mem(cxlflash);
+				goto out;
+			}
+		}
+
+		cxlflash->afu->cmd[i].buf = buf;
+		atomic_set(&cxlflash->afu->cmd[i].free, 1);
+		cxlflash->afu->cmd[i].slot = i;
+		cxlflash->afu->cmd[i].special = 0;
+	}
+
+	for (i = 0; i < MAX_CONTEXT; i++)
+		cxlflash->per_context[i].lfd = -1;
+
+out:
+	return rc;
+}
+
+/**
+ * cxlflash_init_pci - Initialize PCI
+ * @cxlflash:       struct cxlflash
+ *
+ * All PCI setup
+ *
+ * Return value:
+ *      none
+ **/
+static int cxlflash_init_pci(struct cxlflash *cxlflash)
+{
+	struct pci_dev *pdev = cxlflash->dev;
+	int rc = 0;
+
+	cxlflash->cxlflash_regs_pci = pci_resource_start(pdev, 0);
+	rc = pci_request_regions(pdev, CXLFLASH_NAME);
+	if (rc < 0) {
+		cxlflash_dev_err(&pdev->dev,
+				 "Couldn't register memory range of registers");
+		goto out;
+	}
+
+	rc = pci_enable_device(pdev);
+	if (rc || pci_channel_offline(pdev)) {
+		if (pci_channel_offline(pdev)) {
+			cxlflash_wait_for_pci_err_recovery(cxlflash);
+			rc = pci_enable_device(pdev);
+		}
+
+		if (rc) {
+			cxlflash_dev_err(&pdev->dev, "Cannot enable adapter");
+			cxlflash_wait_for_pci_err_recovery(cxlflash);
+			goto out_release_regions;
+		}
+	}
+
+	/*
+	   cxlflash->cxlflash_regs = pci_ioremap_bar(pdev, 0);
+	   if (!cxlflash->cxlflash_regs) {
+	   cxlflash_dev_err(&pdev->dev,
+	   "Couldn't map memory range of registers");
+	   rc = -ENOMEM;
+	   goto out_disable;
+	   }
+	 */
+
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (rc < 0) {
+		cxlflash_dev_dbg(&pdev->dev,
+				 "Failed to set 64 bit PCI DMA mask");
+		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	}
+
+	if (rc < 0) {
+		cxlflash_dev_err(&pdev->dev, "Failed to set PCI DMA mask");
+		goto out_disable;
+	}
+
+	pci_set_master(pdev);
+
+	if (pci_channel_offline(pdev)) {
+		cxlflash_wait_for_pci_err_recovery(cxlflash);
+		if (pci_channel_offline(pdev)) {
+			rc = -EIO;
+			goto out_msi_disable;
+		}
+	}
+
+	rc = pci_save_state(pdev);
+
+	if (rc != PCIBIOS_SUCCESSFUL) {
+		cxlflash_dev_err(&pdev->dev, "Failed to save PCI config space");
+		rc = -EIO;
+		goto cleanup_nolog;
+	}
+
+out:
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+
+cleanup_nolog:
+out_msi_disable:
+	cxlflash_wait_for_pci_err_recovery(cxlflash);
+	iounmap(cxlflash->cxlflash_regs);
+out_disable:
+	pci_disable_device(pdev);
+out_release_regions:
+	pci_release_regions(pdev);
+	goto out;
+
+}
+
+static int cxlflash_init_scsi(struct cxlflash *cxlflash)
+{
+	struct pci_dev *pdev = cxlflash->dev;
+	int rc = 0;
+
+	cxlflash_dev_dbg(&pdev->dev, "before scsi_add_host");
+	rc = scsi_add_host(cxlflash->host, &pdev->dev);
+	if (rc) {
+		cxlflash_dev_err(&pdev->dev, "scsi_add_host failed (rc=%d)",
+				 rc);
+		goto out;
+	}
+
+	cxlflash_dev_dbg(&pdev->dev, "before scsi_scan_host");
+	scsi_scan_host(cxlflash->host);
+
+out:
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+}
+
+/* online means the FC link layer has sync and has completed the link
+ * layer handshake. It is ready for login to start.
+ */
+static void set_port_online(volatile u64 *fc_regs)
+{
+	u64 cmdcfg;
+
+	cmdcfg = readq_be(&fc_regs[FC_MTIP_CMDCONFIG / 8]);
+	cmdcfg &= (~FC_MTIP_CMDCONFIG_OFFLINE);	/* clear OFF_LINE */
+	cmdcfg |= (FC_MTIP_CMDCONFIG_ONLINE);	/* set ON_LINE */
+	writeq_be(cmdcfg, &fc_regs[FC_MTIP_CMDCONFIG / 8]);
+}
+
+static void set_port_offline(volatile u64 *fc_regs)
+{
+	u64 cmdcfg;
+
+	cmdcfg = readq_be(&fc_regs[FC_MTIP_CMDCONFIG / 8]);
+	cmdcfg &= (~FC_MTIP_CMDCONFIG_ONLINE);	/* clear ON_LINE */
+	cmdcfg |= (FC_MTIP_CMDCONFIG_OFFLINE);	/* set OFF_LINE */
+	writeq_be(cmdcfg, &fc_regs[FC_MTIP_CMDCONFIG / 8]);
+}
+
+/* returns 1 - went online */
+/* wait_port_xxx will timeout when cable is not pluggd in */
+static int wait_port_online(volatile u64 *fc_regs,
+			    useconds_t delay_us, unsigned int nretry)
+{
+	u64 status;
+
+	if (delay_us < 1000) {
+		cxlflash_err("invalid delay specified %d", delay_us);
+		return -EINVAL;
+	}
+
+	do {
+		msleep(delay_us / 1000);
+		status = readq_be(&fc_regs[FC_MTIP_STATUS / 8]);
+	} while ((status & FC_MTIP_STATUS_MASK) != FC_MTIP_STATUS_ONLINE &&
+		 nretry--);
+
+	return ((status & FC_MTIP_STATUS_MASK) == FC_MTIP_STATUS_ONLINE);
+}
+
+/* returns 1 - went offline */
+static int wait_port_offline(volatile u64 *fc_regs,
+			     useconds_t delay_us, unsigned int nretry)
+{
+	u64 status;
+
+	if (delay_us < 1000) {
+		cxlflash_err("invalid delay specified %d", delay_us);
+		return -EINVAL;
+	}
+
+	do {
+		msleep(delay_us / 1000);
+		status = readq_be(&fc_regs[FC_MTIP_STATUS / 8]);
+	} while ((status & FC_MTIP_STATUS_MASK) != FC_MTIP_STATUS_OFFLINE &&
+		 nretry--);
+
+	return ((status & FC_MTIP_STATUS_MASK) == FC_MTIP_STATUS_OFFLINE);
+}
+
+/* this function can block up to a few seconds */
+static int afu_set_wwpn(struct afu *afu,
+			int port, volatile u64 *fc_regs, u64 wwpn)
+{
+	int ret = 0;
+
+	set_port_offline(fc_regs);
+
+	if (!wait_port_offline(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
+			       FC_PORT_STATUS_RETRY_CNT)) {
+		cxlflash_dbg("wait on port %d to go offline timed out", port);
+		ret = -1;	/* but continue on to leave the port back online */
+	}
+
+	if (ret == 0)
+		writeq_be(wwpn, &fc_regs[FC_PNAME / 8]);
+
+	set_port_online(fc_regs);
+
+	if (!wait_port_online(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
+			      FC_PORT_STATUS_RETRY_CNT)) {
+		cxlflash_dbg("wait on port %d to go online timed out", port);
+		ret = -1;
+
+		/*
+		 * Override for internal lun!!!
+		 */
+		if (internal_lun) {
+			cxlflash_info("Overriding port %d online timeout!!!",
+				      port);
+			ret = 0;
+		}
+	}
+
+	cxlflash_info("returning rc=%d", ret);
+
+	return ret;
+}
+
+/* this function can block up to a few seconds */
+static void afu_link_reset(struct afu *afu, int port, volatile u64 *fc_regs)
+{
+	u64 port_sel;
+
+	/* first switch the AFU to the other links, if any */
+	port_sel = readq_be(&afu->afu_map->global.regs.afu_port_sel);
+	port_sel &= ~(1 << port);
+	writeq_be(port_sel, &afu->afu_map->global.regs.afu_port_sel);
+	cxlflash_afu_sync(afu, 0, 0, AFU_GSYNC);
+
+	set_port_offline(fc_regs);
+	if (!wait_port_offline(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
+			       FC_PORT_STATUS_RETRY_CNT))
+		cxlflash_err("wait on port %d to go offline timed out", port);
+
+	set_port_online(fc_regs);
+	if (!wait_port_online(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
+			      FC_PORT_STATUS_RETRY_CNT))
+		cxlflash_err("wait on port %d to go online timed out", port);
+
+	/* switch back to include this port */
+	port_sel |= (1 << port);
+	writeq_be(port_sel, &afu->afu_map->global.regs.afu_port_sel);
+	cxlflash_afu_sync(afu, 0, 0, AFU_GSYNC);
+
+	cxlflash_info("returning port_sel=%lld", port_sel);
+}
+
+static const struct asyc_intr_info ainfo[] = {
+	{SISL_ASTATUS_FC0_OTHER, "fc 0: other error", 0,
+		CLR_FC_ERROR | LINK_RESET},
+	{SISL_ASTATUS_FC0_LOGO, "fc 0: target initiated LOGO", 0, 0},
+	{SISL_ASTATUS_FC0_CRC_T, "fc 0: CRC threshold exceeded", 0, LINK_RESET},
+	{SISL_ASTATUS_FC0_LOGI_R, "fc 0: login timed out, retrying", 0, 0},
+	{SISL_ASTATUS_FC0_LOGI_F, "fc 0: login failed", 0, CLR_FC_ERROR},
+	{SISL_ASTATUS_FC0_LOGI_S, "fc 0: login succeeded", 0, 0},
+	{SISL_ASTATUS_FC0_LINK_DN, "fc 0: link down", 0, 0},
+	{SISL_ASTATUS_FC0_LINK_UP, "fc 0: link up", 0, 0},
+
+	{SISL_ASTATUS_FC1_OTHER, "fc 1: other error", 1,
+	 CLR_FC_ERROR | LINK_RESET},
+	{SISL_ASTATUS_FC1_LOGO, "fc 1: target initiated LOGO", 1, 0},
+	{SISL_ASTATUS_FC1_CRC_T, "fc 1: CRC threshold exceeded", 1, LINK_RESET},
+	{SISL_ASTATUS_FC1_LOGI_R, "fc 1: login timed out, retrying", 1, 0},
+	{SISL_ASTATUS_FC1_LOGI_F, "fc 1: login failed", 1, CLR_FC_ERROR},
+	{SISL_ASTATUS_FC1_LOGI_S, "fc 1: login succeeded", 1, 0},
+	{SISL_ASTATUS_FC1_LINK_DN, "fc 1: link down", 1, 0},
+	{SISL_ASTATUS_FC1_LINK_UP, "fc 1: link up", 1, 0},
+	{0x0, "", 0, 0}		/* terminator */
+};
+
+static const struct asyc_intr_info *find_ainfo(u64 status)
+{
+	const struct asyc_intr_info *info;
+
+	for (info = &ainfo[0]; info->status; info++)
+		if (info->status == status)
+			return info;
+
+	return NULL;
+}
+
+static void afu_err_intr_init(struct afu *afu)
+{
+	int i;
+	volatile u64 reg;
+
+	/* global async interrupts: AFU clears afu_ctrl on context exit
+	 * if async interrupts were sent to that context. This prevents
+	 * the AFU form sending further async interrupts when
+	 * there is
+	 * nobody to receive them.
+	 */
+
+	/* mask all */
+	writeq_be(-1ULL, &afu->afu_map->global.regs.aintr_mask);
+	/* set LISN# to send and point to master context */
+	reg = ((u64) (((afu->ctx_hndl << 8) | SISL_MSI_ASYNC_ERROR)) << 40);
+
+	if (internal_lun)
+		reg |= 1;	/* Bit 63 indicates local lun */
+	writeq_be(reg, &afu->afu_map->global.regs.afu_ctrl);
+	/* clear all */
+	writeq_be(-1ULL, &afu->afu_map->global.regs.aintr_clear);
+	/* unmask bits that are of interest */
+	/* note: afu can send an interrupt after this step */
+	writeq_be(SISL_ASTATUS_MASK, &afu->afu_map->global.regs.aintr_mask);
+	/* clear again in case a bit came on after previous clear but before */
+	/* unmask */
+	writeq_be(-1ULL, &afu->afu_map->global.regs.aintr_clear);
+
+	/* Clear/Set internal lun bits */
+	reg = readq_be(&afu->afu_map->global.fc_regs[0][FC_CONFIG2 / 8]);
+	cxlflash_info("ilun p0 = %016llX", reg);
+	reg &= SISL_FC_INTERNAL_MASK;
+	if (internal_lun)
+		reg |= ((u64) (internal_lun - 1) << SISL_FC_INTERNAL_SHIFT);
+	cxlflash_info("ilun p0 = %016llX", reg);
+	writeq_be(reg, &afu->afu_map->global.fc_regs[0][FC_CONFIG2 / 8]);
+
+	/* now clear FC errors */
+	for (i = 0; i < NUM_FC_PORTS; i++) {
+		writeq_be(0xFFFFFFFFU,
+			  &afu->afu_map->global.fc_regs[i][FC_ERROR / 8]);
+		writeq_be(0, &afu->afu_map->global.fc_regs[i][FC_ERRCAP / 8]);
+	}
+
+	/* sync interrupts for master's IOARRIN write */
+	/* note that unlike asyncs, there can be no pending sync interrupts */
+	/* at this time (this is a fresh context and master has not written */
+	/* IOARRIN yet), so there is nothing to clear. */
+
+	/* set LISN#, it is always sent to the context that wrote IOARRIN */
+	writeq_be(SISL_MSI_SYNC_ERROR, &afu->host_map->ctx_ctrl);
+	writeq_be(SISL_ISTATUS_MASK, &afu->host_map->intr_mask);
+}
+
+static irqreturn_t cxlflash_dummy_irq_handler(int irq, void *data)
+{
+	/* XXX - to be removed once we settle the 4th interrupt */
+	cxlflash_info("returning rc=%d", IRQ_HANDLED);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t cxlflash_sync_err_irq(int irq, void *data)
+{
+	struct afu *afu = (struct afu *)data;
+	u64 reg;
+	u64 reg_unmasked;
+
+	reg = readq_be(&afu->host_map->intr_status);
+	reg_unmasked = (reg & SISL_ISTATUS_UNMASK);
+
+	if (reg_unmasked == 0UL) {
+		cxlflash_err("%llX: spurious interrupt, intr_status %016llX",
+			     (u64) afu, reg);
+		goto cxlflash_sync_err_irq_exit;
+	}
+
+	cxlflash_err("%llX: unexpected interrupt, intr_status %016llX",
+		     (u64) afu, reg);
+
+	writeq_be(reg_unmasked, &afu->host_map->intr_clear);
+
+cxlflash_sync_err_irq_exit:
+	cxlflash_info("returning rc=%d", IRQ_HANDLED);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
+{
+	struct afu *afu = (struct afu *)data;
+	struct afu_cmd *cmd;
+
+	/*
+	 * XXX - might want to look at using locals for loop control
+	 * as an optimization
+	 */
+
+	/* Process however many RRQ entries that are ready */
+	while ((*afu->hrrq_curr & SISL_RESP_HANDLE_T_BIT) == afu->toggle) {
+		cmd = (struct afu_cmd *)
+		    ((*afu->hrrq_curr) & (~SISL_RESP_HANDLE_T_BIT));
+
+		cmd_complete(cmd);
+
+		/* Advance to next entry or wrap and flip the toggle bit */
+		if (afu->hrrq_curr < afu->hrrq_end)
+			afu->hrrq_curr++;
+		else {
+			afu->hrrq_curr = afu->hrrq_start;
+			afu->toggle ^= SISL_RESP_HANDLE_T_BIT;
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
+{
+	struct afu *afu = (struct afu *)data;
+	struct cxlflash *cxlflash;
+	u64 reg_unmasked;
+	const struct asyc_intr_info *info;
+	volatile struct sisl_global_map *global = &afu->afu_map->global;
+	u64 reg;
+	int i;
+
+	cxlflash = afu->back;
+
+	reg = readq_be(&global->regs.aintr_status);
+	reg_unmasked = (reg & SISL_ASTATUS_UNMASK);
+
+	if (reg_unmasked == 0) {
+		cxlflash_err("spurious interrupt, aintr_status 0x%016llx", reg);
+		goto out;
+	}
+
+	/* it is OK to clear AFU status before FC_ERROR */
+	writeq_be(reg_unmasked, &global->regs.aintr_clear);
+
+	/* check each bit that is on */
+	for (i = 0; reg_unmasked; i++, reg_unmasked = (reg_unmasked >> 1)) {
+		if ((reg_unmasked & 0x1) == 0 ||
+		    (info = find_ainfo(1ull << i)) == NULL) {
+			continue;
+		}
+
+		cxlflash_err("%s, fc_status 0x%08llx", info->desc,
+			     readq_be(&global->fc_regs
+				      [info->port][FC_STATUS / 8]));
+
+		/*
+		 * do link reset first, some OTHER errors will set FC_ERROR 
+		 * again if cleared before or w/o a reset
+		 */
+		if (info->action & LINK_RESET) {
+			cxlflash_err("fc %d: resetting link", info->port);
+			cxlflash->lr_state = LINK_RESET_REQUIRED;
+			cxlflash->lr_port = info->port;
+			schedule_work(&cxlflash->work_q);
+		}
+
+		if (info->action & CLR_FC_ERROR) {
+			reg = readq_be(&global->fc_regs[info->port]
+				       [FC_ERROR / 8]);
+
+			/*
+			 * since all errors are unmasked, FC_ERROR and FC_ERRCAP
+			 * should be the same and tracing one is sufficient.
+			 */
+
+			cxlflash_err("fc %d: clearing fc_error 0x%08llx",
+				     info->port, reg);
+
+			writeq_be(reg,
+				  &global->fc_regs[info->port][FC_ERROR /
+								   8]);
+			writeq_be(0,
+				  &global->fc_regs[info->port][FC_ERRCAP /
+								   8]);
+		}
+	}
+
+out:
+	cxlflash_info("returning rc=%d, afu=%p", IRQ_HANDLED, afu);
+	return IRQ_HANDLED;
+}
+
+/*
+ * Start the afu context.  This is calling into the generic CXL driver code
+ * (except for the contents of the WED).
+ */
+int cxlflash_start_context(struct cxlflash *cxlflash)
+{
+	int rc = 0;
+
+	rc = cxl_start_context(cxlflash->mcctx,
+			       cxlflash->afu->work.work_element_descriptor,
+			       NULL);
+
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+}
+
+/**
+ * cxlflash_read_vpd - Read the Vital Product Data on the Card.
+ * @cxlflash:       struct cxlflash
+ *
+ * Read and parse the VPD
+ *
+ * Return value:
+ *      WWPN for each port
+ **/
+int cxlflash_read_vpd(struct cxlflash *cxlflash, u64 wwpn[])
+{
+	struct pci_dev *dev = cxlflash->parent_dev;
+	int rc = 0;
+	int ro_start, ro_size, i, j, k;
+	ssize_t vpd_size;
+	char vpd_data[CXLFLASH_VPD_LEN];
+	char tmp_buf[WWPN_BUF_LEN] = { 0 };
+	char *wwpn_vpd_tags[NUM_FC_PORTS] = { "V5", "V6" };
+
+	/* Get the VPD data from the device */
+	vpd_size = pci_read_vpd(dev, 0, sizeof(vpd_data), vpd_data);
+	if (unlikely(vpd_size <= 0)) {
+		cxlflash_err("Unable to read VPD (size = %ld)", vpd_size);
+		rc = -ENODEV;
+		goto out;
+	}
+
+	/* Get the read only section offset */
+	ro_start = pci_vpd_find_tag(vpd_data, 0, vpd_size,
+				    PCI_VPD_LRDT_RO_DATA);
+	if (unlikely(ro_start < 0)) {
+		cxlflash_err("VPD Read-only not found");
+		rc = -ENODEV;
+		goto out;
+	}
+
+	/* Get the read only section size, cap when extends beyond read VPD */
+	ro_size = pci_vpd_lrdt_size(&vpd_data[ro_start]);
+	j = ro_size;
+	i = ro_start + PCI_VPD_LRDT_TAG_SIZE;
+	if (unlikely((i + j) > vpd_size)) {
+		cxlflash_warn("Might need to read more VPD (%d > %ld)",
+			      (i + j), vpd_size);
+		ro_size = vpd_size - i;
+	}
+
+	/*
+	 * Find the offset of the WWPN tag within the read only
+	 * VPD data and validate the found field (partials are
+	 * no good to us). Convert the ASCII data to an integer
+	 * value. Note that we must copy to a temporary buffer
+	 * because the conversion service requires that the ASCII
+	 * string be terminated.
+	 */
+	for (k = 0; k < NUM_FC_PORTS; k++) {
+		j = ro_size;
+		i = ro_start + PCI_VPD_LRDT_TAG_SIZE;
+
+		i = pci_vpd_find_info_keyword(vpd_data, i, j, wwpn_vpd_tags[k]);
+		if (unlikely(i < 0)) {
+			cxlflash_err("Port %d WWPN not found in VPD", k);
+			rc = -ENODEV;
+			goto out;
+		}
+
+		j = pci_vpd_info_field_size(&vpd_data[i]);
+		i += PCI_VPD_INFO_FLD_HDR_SIZE;
+		if (unlikely((i + j > vpd_size) || (j != WWPN_LEN))) {
+			cxlflash_err("Port %d WWPN incomplete or VPD corrupt",
+				     k);
+			rc = -ENODEV;
+			goto out;
+		}
+
+		memcpy(tmp_buf, &vpd_data[i], WWPN_LEN);
+		rc = kstrtoul(tmp_buf, WWPN_LEN, (unsigned long *)&wwpn[k]);
+		if (unlikely(rc)) {
+			cxlflash_err
+			    ("Unable to convert port 0 WWPN to integer");
+			rc = -ENODEV;
+			goto out;
+		}
+	}
+
+out:
+	cxlflash_dbg("returning rc=%d", rc);
+	return rc;
+}
+
+/**
+ * cxlflash_context_reset - perform a context reset
+ * @afu:        struct afu pointer
+ *
+ * Returns:
+ *      NONE
+ */
+void cxlflash_context_reset(struct afu_cmd *cmd)
+{
+	int nretry = 0;
+	u64 rrin = 0x1;
+	struct afu *afu = cmd->back;
+
+	cxlflash_info("cmd=%p", cmd);
+
+	/* First process completion of the command that timed out */
+	cmd_complete(cmd);
+
+	if (afu->room == 0) {
+		do {
+			afu->room = readq_be(&afu->host_map->cmd_room);
+			udelay(nretry);
+		} while ((afu->room == 0) && (nretry++ < MC_ROOM_RETRY_CNT));
+	}
+
+	if (afu->room) {
+		writeq_be((u64) rrin, &afu->host_map->ioarrin);
+		do {
+			rrin = readq_be(&afu->host_map->ioarrin);
+			/* Double delay each time */
+			udelay(2 ^ nretry);
+		} while ((rrin == 0x1) && (nretry++ < MC_ROOM_RETRY_CNT));
+	} else
+		cxlflash_err("no cmd_room to send reset");
+}
+
+/**
+ * init_pcr - Initialize the Provisioning and Control Registers.
+ * @cxlflash:        struct cxlflash pointer
+ *
+ * Returns:
+ *      NONE
+ */
+void init_pcr(struct cxlflash *cxlflash)
+{
+	struct afu *afu = cxlflash->afu;
+	int i;
+
+	for (i = 0; i < MAX_CONTEXT; i++) {
+		afu->ctx_info[i].ctrl_map = &afu->afu_map->ctrls[i].ctrl;
+		/* disrupt any clients that could be running */
+		/* e. g. clients that survived a master restart */
+		writeq_be(0, &afu->ctx_info[i].ctrl_map->rht_start);
+		writeq_be(0, &afu->ctx_info[i].ctrl_map->rht_cnt_id);
+		writeq_be(0, &afu->ctx_info[i].ctrl_map->ctx_cap);
+	}
+
+	/* copy frequently used fields into afu */
+	afu->ctx_hndl = (u16) cxl_process_element(cxlflash->mcctx);
+	/* ctx_hndl is 16 bits in CAIA */
+	afu->host_map = &afu->afu_map->hosts[afu->ctx_hndl].host;
+	afu->ctrl_map = &afu->afu_map->ctrls[afu->ctx_hndl].ctrl;
+
+	/* initialize cmd fields that never change */
+	for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
+		afu->cmd[i].rcb.ctx_id = afu->ctx_hndl;
+		afu->cmd[i].rcb.msi = SISL_MSI_RRQ_UPDATED;
+		afu->cmd[i].rcb.rrq = 0x0;
+	}
+
+}
+
+/**
+ * init_global - Initialize the AFU Global Registers
+ * @cxlflash:        struct cxlflash pointer
+ *
+ * Returns:
+ *      NONE
+ */
+int init_global(struct cxlflash *cxlflash)
+{
+	struct afu *afu = cxlflash->afu;
+	u64 wwpn[NUM_FC_PORTS];	/* wwpn of AFU ports */
+	int i = 0;
+	int rc = 0;
+	u64 reg;
+
+	rc = cxlflash_read_vpd(cxlflash, &wwpn[0]);
+	if (rc) {
+		cxlflash_err("could not read vpd rc=%d", rc);
+		goto out;
+	}
+	cxlflash_info("wwpn0=0x%llx wwpn1=0x%llx", wwpn[0], wwpn[1]);
+
+	/* set up RRQ in AFU for master issued cmds */
+	writeq_be((u64) afu->hrrq_start, &afu->host_map->rrq_start);
+	writeq_be((u64) afu->hrrq_end, &afu->host_map->rrq_end);
+
+	/* AFU configuration */
+	reg = readq_be(&afu->afu_map->global.regs.afu_config);
+	reg |= 0x7F20;		/* enable all auto retry options and LE */
+	/* leave others at default: */
+	/* CTX_CAP write protected, mbox_r does not clear on read and */
+	/* checker on if dual afu */
+	writeq_be(reg, &afu->afu_map->global.regs.afu_config);
+
+	/* global port select: select either port */
+#if 0				/* XXX - check with Andy/Todd b/c this doesn't work */
+	if (internal_lun)
+		writeq_be(0x1, &afu->afu_map->global.regs.afu_port_sel);
+	else
+#endif
+		writeq_be(0x3, &afu->afu_map->global.regs.afu_port_sel);
+
+	for (i = 0; i < NUM_FC_PORTS; i++) {
+		/* unmask all errors (but they are still masked at AFU) */
+		writeq_be(0, &afu->afu_map->global.fc_regs[i][FC_ERRMSK / 8]);
+		/* clear CRC error cnt & set a threshold */
+		(void)readq_be(&afu->afu_map->global.
+			       fc_regs[i][FC_CNT_CRCERR / 8]);
+		writeq_be(MC_CRC_THRESH, &afu->afu_map->global.fc_regs[i]
+			  [FC_CRC_THRESH / 8]);
+
+		/* set WWPNs. If already programmed, wwpn[i] is 0 */
+		if (wwpn[i] != 0 &&
+		    afu_set_wwpn(afu, i,
+				 &afu->afu_map->global.fc_regs[i][0],
+				 wwpn[i])) {
+			cxlflash_dbg("failed to set WWPN on port %d", i);
+			rc = -EIO;
+			goto out;
+		}
+		/* Programming WWPN back to back causes additional
+		 * offline/online transitions and a PLOGI
+		 */
+		msleep(100);
+
+	}
+
+	/* set up master's own CTX_CAP to allow real mode, host translation */
+	/* tbls, afu cmds and read/write GSCSI cmds. */
+	/* First, unlock ctx_cap write by reading mbox */
+	(void)readq_be(&afu->ctrl_map->mbox_r);	/* unlock ctx_cap */
+	writeq_be((SISL_CTX_CAP_REAL_MODE | SISL_CTX_CAP_HOST_XLATE |
+		   SISL_CTX_CAP_READ_CMD | SISL_CTX_CAP_WRITE_CMD |
+		   SISL_CTX_CAP_AFU_CMD | SISL_CTX_CAP_GSCSI_CMD),
+		  &afu->ctrl_map->ctx_cap);
+	/* init heartbeat */
+	afu->hb = readq_be(&afu->afu_map->global.regs.afu_hb);
+
+out:
+	return rc;
+}
+
+/**
+ * cxlflash_start_afu - Start the AFU, in a pristine state
+ * @cxlflash:        struct cxlflash pointer
+ *
+ * Returns:
+ *      NONE
+ */
+int cxlflash_start_afu(struct cxlflash *cxlflash)
+{
+	struct afu *afu = cxlflash->afu;
+
+	int i = 0;
+	int rc = 0;
+
+	for (i = 0; i < MAX_CONTEXT; i++)
+		afu->rht_info[i].rht_start = &afu->rht[i][0];
+
+	for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
+		struct timer_list *timer = &afu->cmd[i].timer;
+
+		init_timer(timer);
+		timer->data = (unsigned long)&afu->cmd[i];
+		timer->function = (void (*)(unsigned long))
+		    cxlflash_context_reset;
+
+		spin_lock_init(&afu->cmd[i].slock);
+		afu->cmd[i].back = afu;
+	}
+	init_pcr(cxlflash);
+
+	/* initialize RRQ pointers */
+	afu->hrrq_start = &afu->rrq_entry[0];
+	afu->hrrq_end = &afu->rrq_entry[NUM_RRQ_ENTRY - 1];
+	afu->hrrq_curr = afu->hrrq_start;
+	afu->toggle = 1;
+
+	rc = init_global(cxlflash);
+
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+}
+
+/**
+ * cxlflash_init_mc - setup the master context
+ * @cxlflash:        struct cxlflash pointer
+ *
+ * Returns:
+ *      NONE
+ */
+int cxlflash_init_mc(struct cxlflash *cxlflash)
+{
+	struct cxl_context *ctx;
+	struct device *dev = &cxlflash->dev->dev;
+	struct afu *afu = cxlflash->afu;
+	int rc = 0;
+	enum undo_level level;
+
+	ctx = cxl_dev_context_init(cxlflash->dev);
+	if (!ctx)
+		return -ENOMEM;
+	cxlflash->mcctx = ctx;
+
+	/* Set it up as a master with the CXL */
+	cxl_set_master(ctx);
+
+	/* During initialization reset the AFU to start from a clean slate */
+	rc = cxl_afu_reset(cxlflash->mcctx);
+	if (rc) {
+		cxlflash_dev_err(dev, "initial AFU reset failed rc=%d", rc);
+		level = RELEASE_CONTEXT;
+		goto out;
+	}
+
+	/* Allocate AFU generated interrupt handler */
+	rc = cxl_allocate_afu_irqs(ctx, 4);
+	if (rc) {
+		cxlflash_dev_err(dev, "call to allocate_afu_irqs failed rc=%d!",
+				 rc);
+		level = RELEASE_CONTEXT;
+		goto out;
+	}
+
+	/* Register AFU interrupt 1 (SISL_MSI_SYNC_ERROR) */
+	rc = cxl_map_afu_irq(ctx, 1, cxlflash_sync_err_irq, afu,
+			     "SISL_MSI_SYNC_ERROR");
+	if (!rc) {
+		cxlflash_dev_err(dev,
+				 "IRQ 1 (SISL_MSI_SYNC_ERROR) map failed!");
+		level = FREE_IRQ;
+		goto out;
+	}
+	/* Register AFU interrupt 2 (SISL_MSI_RRQ_UPDATED) */
+	rc = cxl_map_afu_irq(ctx, 2, cxlflash_rrq_irq, afu,
+			     "SISL_MSI_RRQ_UPDATED");
+	if (!rc) {
+		cxlflash_dev_err(dev,
+				 "IRQ 2 (SISL_MSI_RRQ_UPDATED) map failed!");
+		level = UNMAP_ONE;
+		goto out;
+	}
+	/* Register AFU interrupt 3 (SISL_MSI_ASYNC_ERROR) */
+	rc = cxl_map_afu_irq(ctx, 3, cxlflash_async_err_irq, afu,
+			     "SISL_MSI_ASYNC_ERROR");
+	if (!rc) {
+		cxlflash_dev_err(dev,
+				 "IRQ 3 (SISL_MSI_ASYNC_ERROR) map failed!");
+		level = UNMAP_TWO;
+		goto out;
+	}
+
+	/*
+	 * XXX - why did we put a 4th interrupt? Were we thinking this is
+	 * for the SISL_MSI_PSL_XLATE? Wouldn't that be covered under the
+	 * cxl_register_error_irq() ?
+	 */
+
+	/* Register AFU interrupt 4 for errors. */
+	rc = cxl_map_afu_irq(ctx, 4, cxlflash_dummy_irq_handler, afu, "err3");
+	if (!rc) {
+		cxlflash_dev_err(dev, "IRQ 4 map failed!");
+		level = UNMAP_THREE;
+		goto out;
+	}
+	rc = 0;
+
+	/* Register for PSL errors. TODO: implement this */
+	/* cxl_register_error_irq(dev,... ,callback function, private data); */
+
+	/* This performs the equivalent of the CXL_IOCTL_START_WORK.
+	 * The CXL_IOCTL_GET_PROCESS_ELEMENT is implicit in the process
+	 * element (pe) that is embedded in the context (ctx)
+	 */
+	cxlflash_start_context(cxlflash);
+ret:
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+out:
+	cxlflash_term_mc(cxlflash, level);
+	goto ret;
+}
+
+static int cxlflash_init_afu(struct cxlflash *cxlflash)
+{
+	u64 reg;
+	int rc = 0;
+	struct afu *afu = cxlflash->afu;
+	struct device *dev = &cxlflash->dev->dev;
+
+	rc = cxlflash_init_mc(cxlflash);
+	if (rc) {
+		cxlflash_dev_err(dev, "call to init_mc failed, rc=%d!", rc);
+		goto err1;
+	}
+
+	INIT_LIST_HEAD(&afu->luns);
+
+	/* Map the entire MMIO space of the AFU.
+	 */
+	afu->afu_map = cxl_psa_map(cxlflash->mcctx);
+	if (!afu->afu_map) {
+		rc = -ENOMEM;
+		cxlflash_term_mc(cxlflash, UNDO_START);
+		cxlflash_dev_err(dev, "call to cxl_psa_map failed!");
+		goto err1;
+	}
+
+	/* don't byte reverse on reading afu_version, else the string form */
+	/*     will be backwards */
+	reg = afu->afu_map->global.regs.afu_version;
+	memcpy(afu->version, &reg, 8);
+	afu->interface_version =
+	    readq_be(&afu->afu_map->global.regs.interface_version);
+	cxlflash_info("afu version %s, interface version 0x%llx",
+		      afu->version, afu->interface_version);
+
+	rc = cxlflash_start_afu(cxlflash);
+	if (rc) {
+		cxlflash_dev_err(dev, "call to start_afu failed, rc=%d!", rc);
+		cxlflash_term_mc(cxlflash, UNDO_START);
+		cxl_psa_unmap((void *)afu->afu_map);
+		afu->afu_map = NULL;
+	}
+
+	/* XXX: Add threads for afu_rrq_rx and afu_err_rx */
+	/* after creating afu_err_rx thread, unmask error interrupts */
+	afu_err_intr_init(cxlflash->afu);
+
+err1:
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+}
+
+/* do we need to retry AFU_CMDs (sync) on afu_rc = 0x30 ? */
+/* can we not avoid that ? */
+/* not retrying afu timeouts (B_TIMEOUT) */
+/* returns 1 if the cmd should be retried, 0 otherwise */
+/* sets B_ERROR flag based on IOASA */
+int cxlflash_check_status(struct sisl_ioasa *ioasa)
+{
+	if (ioasa->ioasc == 0)
+		return 0;
+
+	ioasa->host_use_b[0] |= B_ERROR;
+
+	if (!(ioasa->host_use_b[1]++ < MC_RETRY_CNT))
+		return 0;
+
+	switch (ioasa->rc.afu_rc) {
+	case SISL_AFU_RC_NO_CHANNELS:
+	case SISL_AFU_RC_OUT_OF_DATA_BUFS:
+		msleep(1);	/* 1 msec */
+		return 1;
+
+	case 0:
+		/* no afu_rc, but either scsi_rc and/or fc_rc is set */
+		/* retry all scsi_rc and fc_rc after a small delay */
+		msleep(1);	/* 1 msec */
+		return 1;
+	}
+
+	return 0;
+}
+
+void cxlflash_send_cmd(struct afu *afu, struct afu_cmd *cmd)
+{
+	int nretry = 0;
+
+	if (afu->room == 0)
+		do {
+			afu->room = readq_be(&afu->host_map->cmd_room);
+			udelay(nretry);
+		} while ((afu->room == 0) && (nretry++ < MC_ROOM_RETRY_CNT));
+
+	cmd->sa.host_use_b[0] = 0;	/* 0 means active */
+	cmd->sa.ioasc = 0;
+
+	/* make memory updates visible to AFU before MMIO */
+	smp_wmb();
+
+	/* Only kick off the timer for internal commands */
+	if (cmd->internal) {
+		cmd->timer.expires = (jiffies +
+					(cmd->rcb.timeout * 2 * HZ));
+		add_timer(&cmd->timer);
+	} else if (cmd->rcb.timeout)
+		cxlflash_err("timer not started %d", cmd->rcb.timeout);
+
+	/* Write IOARRIN */
+	if (afu->room)
+		writeq_be((u64)&cmd->rcb, &afu->host_map->ioarrin);
+	else
+		cxlflash_err("no cmd_room to send 0x%X", cmd->rcb.cdb[0]);
+
+	cxlflash_dbg("cmd=%p len=%d ea=%p", cmd, cmd->rcb.data_len,
+		     (void *)cmd->rcb.data_ea);
+
+	/* Let timer fire to complete the response... */
+}
+
+void cxlflash_wait_resp(struct afu *afu, struct afu_cmd *cmd)
+{
+	unsigned long lock_flags = 0;
+
+	spin_lock_irqsave(&cmd->slock, lock_flags);
+	while (!(cmd->sa.host_use_b[0] & B_DONE)) {
+		spin_unlock_irqrestore(&cmd->slock, lock_flags);
+		udelay(10);
+		spin_lock_irqsave(&cmd->slock, lock_flags);
+	}
+	spin_unlock_irqrestore(&cmd->slock, lock_flags);
+
+	del_timer(&cmd->timer);	/* already stopped if timer fired */
+
+	if (cmd->sa.ioasc != 0)
+		cxlflash_err("CMD 0x%x failed, IOASC: flags 0x%x, afu_rc 0x%x, "
+			     "scsi_rc 0x%x, fc_rc 0x%x",
+			     cmd->rcb.cdb[0],
+			     cmd->sa.rc.flags,
+			     cmd->sa.rc.afu_rc,
+			     cmd->sa.rc.scsi_rc, cmd->sa.rc.fc_rc);
+}
+
+/*
+ * afu_sync can be called from interrupt thread and the main processing
+ * thread. Caller is responsible for any serialization.
+ * Also, it can be called even before/during discovery, so we must use
+ * a dedicated cmd not used by discovery.
+ *
+ * AFU takes only 1 sync cmd at a time.
+ */
+int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
+		      res_hndl_t res_hndl_u, u8 mode)
+{
+	struct afu_cmd *cmd = &afu->cmd[AFU_SYNC_INDEX];
+	int rc = 0;
+
+	cxlflash_info("afu=%p cmd=%p %d", afu, cmd, ctx_hndl_u);
+
+	memset(cmd->rcb.cdb, 0, sizeof(cmd->rcb.cdb));
+
+	cmd->rcb.req_flags = SISL_REQ_FLAGS_AFU_CMD;
+	cmd->rcb.port_sel = 0x0;	/* NA */
+	cmd->rcb.lun_id = 0x0;	/* NA */
+	cmd->rcb.data_len = 0x0;
+	cmd->rcb.data_ea = 0x0;
+	cmd->internal = true;
+	cmd->rcb.timeout = MC_AFU_SYNC_TIMEOUT;
+
+	cmd->rcb.cdb[0] = 0xC0;	/* AFU Sync */
+	cmd->rcb.cdb[1] = mode;
+
+	/* The cdb is aligned, no unaligned accessors required */
+	*((u16 *)&cmd->rcb.cdb[2]) = swab16(ctx_hndl_u);
+	*((u32 *)&cmd->rcb.cdb[4]) = swab32(res_hndl_u);
+
+	cxlflash_send_cmd(afu, cmd);
+	cxlflash_wait_resp(afu, cmd);
+
+	if ((cmd->sa.ioasc != 0) || (cmd->sa.host_use_b[0] & B_ERROR)) {
+		rc = -1;
+		/* B_ERROR is set on timeout */
+	}
+
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+}
+
+int cxlflash_afu_reset(struct cxlflash *cxlflash)
+{
+	int rc = 0;
+	/* Stop the context before the reset. Since the context is
+	 * no longer available restart it after the reset is complete 
+	 */
+
+	cxlflash_term_afu(cxlflash);
+
+	rc = cxlflash_init_afu(cxlflash);
+
+	/* XXX: Need to restart/reattach all user contexts */
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+}
+
+/**
+ * cxlflash_worker_thread - Worker thread
+ * @work:               work queue pointer
+ *
+ * Called at task level from a work thread. This function takes care
+ * of adding and removing device from the mid-layer as configuration
+ * changes are detected by the adapter.
+ *
+ * Return value:
+ *      nothing
+ **/
+static void cxlflash_worker_thread(struct work_struct *work)
+{
+	struct cxlflash *cxlflash =
+	    container_of(work, struct cxlflash, work_q);
+	struct afu *afu = cxlflash->afu;
+	int port;
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(cxlflash->host->host_lock, lock_flags);
+
+	if (cxlflash->lr_state == LINK_RESET_REQUIRED) {
+		port = cxlflash->lr_port;
+		if (port < 0)
+			cxlflash_err("invalid port index %d", port);
+		else
+			afu_link_reset(afu, port,
+				       &afu->afu_map->
+				       global.fc_regs[port][0]);
+		cxlflash->lr_state = LINK_RESET_COMPLETE;
+	}
+
+	spin_unlock_irqrestore(cxlflash->host->host_lock, lock_flags);
+}
+
+/**
+ * cxlflash_probe - Adapter hot plug add entry point
+ * @pdev:       pci device struct
+ * @dev_id:     pci device id
+ *
+ * Return value:
+ *      0 on success / non-zero on failure
+ **/
+static int cxlflash_probe(struct pci_dev *pdev,
+			  const struct pci_device_id *dev_id)
+{
+	struct Scsi_Host *host;
+	struct cxlflash *cxlflash = NULL;
+	struct device *phys_dev;
+	struct dev_dependent_vals *ddv;
+	int rc = 0;
+
+	cxlflash_dev_dbg(&pdev->dev, "Found CXLFLASH with IRQ: %d", pdev->irq);
+
+	ddv = (struct dev_dependent_vals *)dev_id->driver_data;
+	driver_template.max_sectors = ddv->max_sectors;
+
+	host = scsi_host_alloc(&driver_template, sizeof(struct cxlflash));
+	if (!host) {
+		cxlflash_dev_err(&pdev->dev, "call to scsi_host_alloc failed!");
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	host->max_id = CXLFLASH_MAX_NUM_TARGETS_PER_BUS;
+	host->max_lun = CXLFLASH_MAX_NUM_LUNS_PER_TARGET;
+	host->max_channel = NUM_FC_PORTS - 1;
+	host->unique_id = host->host_no;
+	host->max_cmd_len = CXLFLASH_MAX_CDB_LEN;
+
+	cxlflash = (struct cxlflash *)host->hostdata;
+	cxlflash->host = host;
+	rc = cxlflash_gb_alloc(cxlflash);
+	if (rc) {
+		cxlflash_dev_err(&pdev->dev, "call to scsi_host_alloc failed!");
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	cxlflash->dev = pdev;
+	cxlflash->last_lun_index = 0;
+	cxlflash->task_set = 0;
+	cxlflash->dev_id = (struct pci_device_id *)dev_id;
+	cxlflash->tmf_active = 0;
+	cxlflash->mcctx = NULL;
+	cxlflash->context_reset_active = 0;
+	cxlflash->num_user_contexts = 0;
+
+	init_waitqueue_head(&cxlflash->tmf_wait_q);
+	init_waitqueue_head(&cxlflash->eeh_wait_q);
+
+	INIT_WORK(&cxlflash->work_q, cxlflash_worker_thread);
+	cxlflash->lr_state = LINK_RESET_INVALID;
+	cxlflash->lr_port = -1;
+
+	pci_set_drvdata(pdev, cxlflash);
+
+	/* Use the special service provided to look up the physical
+	 * PCI device, since we are called on the probe of the virtual
+	 * PCI host bus (vphb)
+	 */
+	phys_dev = cxl_get_phys_dev(pdev);
+	if (!dev_is_pci(phys_dev)) {	/* make sure it's pci */
+		cxlflash_err("not a pci dev");
+		rc = ENODEV;
+		goto out_remove;
+	}
+	cxlflash->parent_dev = to_pci_dev(phys_dev);
+
+	cxlflash->cxl_afu = cxl_pci_to_afu(pdev, NULL);
+	rc = cxlflash_init_afu(cxlflash);
+	if (rc) {
+		cxlflash_dev_err(&pdev->dev,
+				 "call to cxlflash_init_afu failed rc=%d!", rc);
+		goto out_remove;
+	}
+
+	rc = cxlflash_init_pci(cxlflash);
+	if (rc) {
+		cxlflash_dev_err(&pdev->dev,
+				 "call to cxlflash_init_pci failed rc=%d!", rc);
+		goto out_remove;
+	}
+
+	rc = cxlflash_init_scsi(cxlflash);
+	if (rc) {
+		cxlflash_dev_err(&pdev->dev,
+				 "call to cxlflash_init_scsi failed rc=%d!",
+				 rc);
+		goto out_remove;
+	}
+
+out:
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+
+out_remove:
+	cxlflash_remove(pdev);
+	goto out;
+}
+
+static struct pci_driver cxlflash_driver = {
+	.name = CXLFLASH_NAME,
+	.id_table = cxlflash_pci_table,
+	.probe = cxlflash_probe,
+	.remove = cxlflash_remove,
+};
+
+static int __init init_cxlflash(void)
+{
+	cxlflash_info("IBM Power CXL Flash Adapter version: %s %s",
+		      CXLFLASH_DRIVER_VERSION, CXLFLASH_DRIVER_DATE);
+
+	/* Validate module parameters */
+	if (internal_lun > 4) {
+		cxlflash_err("Invalid lun_mode parameter! (%d > 4)",
+			     internal_lun);
+		return (-EINVAL);
+	}
+
+	return pci_register_driver(&cxlflash_driver);
+}
+
+static void __exit exit_cxlflash(void)
+{
+	pci_unregister_driver(&cxlflash_driver);
+}
+
+module_init(init_cxlflash);
+module_exit(exit_cxlflash);
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
new file mode 100644
index 0000000..b79d4f3
--- /dev/null
+++ b/drivers/scsi/cxlflash/main.h
@@ -0,0 +1,124 @@
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
+#ifndef _CXLFLASH_MAIN_H
+#define _CXLFLASH_MAIN_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+
+typedef unsigned int useconds_t;        /* time in microseconds */
+
+#define CXLFLASH_NAME                      "cxlflash"
+#define CXLFLASH_ADAPTER_NAME              "IBM POWER CXL Flash Adapter"
+#define CXLFLASH_DRIVER_VERSION           "1.0.2"
+#define CXLFLASH_DRIVER_DATE              "(April 13, 2015)"
+
+#define PCI_DEVICE_ID_IBM_CORSA		0x04F0
+#define CXLFLASH_SUBS_DEV_ID		0x04F0
+
+/* Since there is only one target, make it 0 */
+#define CXLFLASH_TARGET                   0x0
+#define CXLFLASH_MAX_CDB_LEN		16
+
+/* Really only one target per bus since the Texan is directly attached */
+#define CXLFLASH_MAX_NUM_TARGETS_PER_BUS                     1
+#define CXLFLASH_MAX_NUM_LUNS_PER_TARGET                     65536
+
+#define CXLFLASH_PCI_ERROR_RECOVERY_TIMEOUT  (120 * HZ)
+
+#define NUM_FC_PORTS     CXLFLASH_NUM_FC_PORTS  /* ports per AFU */
+
+/* FC defines */
+#define FC_MTIP_CMDCONFIG 0x010
+#define FC_MTIP_STATUS 0x018
+
+#define FC_PNAME 0x300
+#define FC_CONFIG 0x320
+#define FC_CONFIG2 0x328
+#define FC_STATUS 0x330
+#define FC_ERROR 0x380
+#define FC_ERRCAP 0x388
+#define FC_ERRMSK 0x390
+#define FC_CNT_CRCERR 0x538
+#define FC_CRC_THRESH 0x580
+
+#define FC_MTIP_CMDCONFIG_ONLINE    0x20ull
+#define FC_MTIP_CMDCONFIG_OFFLINE   0x40ull
+
+#define FC_MTIP_STATUS_MASK         0x30ull
+#define FC_MTIP_STATUS_ONLINE       0x20ull
+#define FC_MTIP_STATUS_OFFLINE      0x10ull
+
+/* TIMEOUT and RETRY definitions */
+
+/* AFU command timeout values */
+#define MC_AFU_SYNC_TIMEOUT  5	/* 5 secs */
+
+/* AFU command retry limit */
+#define MC_RETRY_CNT         5	/* sufficient for SCSI check and
+				   certain AFU errors */
+
+/* AFU command room retry limit */
+#define MC_ROOM_RETRY_CNT    10
+
+/* FC CRC clear periodic timer */
+#define MC_CRC_THRESH 100	/* threshold in 5 mins */
+
+#define FC_PORT_STATUS_RETRY_CNT 100	/* 100 100ms retries = 10 seconds */
+#define FC_PORT_STATUS_RETRY_INTERVAL_US 100000	/* microseconds */
+
+/* VPD defines */
+#define CXLFLASH_VPD_LEN	256
+#define WWPN_LEN	16
+#define WWPN_BUF_LEN	(WWPN_LEN + 1)
+
+
+enum undo_level {
+	RELEASE_CONTEXT = 0,
+	FREE_IRQ,
+	UNMAP_ONE,
+	UNMAP_TWO,
+	UNMAP_THREE,
+	UNMAP_FOUR,
+	UNDO_START
+};
+
+struct dev_dependent_vals {
+	u64 max_sectors;
+};
+
+struct asyc_intr_info {
+	u64 status;
+	char *desc;
+	u8 port;
+	u8 action;
+#define CLR_FC_ERROR   0x01
+#define LINK_RESET     0x02
+};
+
+static inline u64 lun_to_lunid(u64 lun)
+{
+	u64 lun_id;
+
+	int_to_scsilun(lun, (struct scsi_lun *)&lun_id);
+	return swab64(lun_id);
+}
+/*
+ * Externs and Prototypes
+ */
+
+#endif /* _CXLFLASH_MAIN_H */
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
new file mode 100755
index 0000000..7a676b9
--- /dev/null
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -0,0 +1,407 @@
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
+#ifndef _SISLITE_H
+#define _SISLITE_H
+
+#include <linux/types.h>
+
+typedef u16 ctx_hndl_t;
+typedef u32 res_hndl_t;
+
+#define PAGE_SIZE_4K	4096
+#define PAGE_SIZE_64K	65536
+
+/*
+ * IOARCB: 64 bytes, min 16 byte alignment required, host native endianness
+ * except for SCSI CDB which remains big endian per SCSI standards.
+ */
+struct sisl_ioarcb {
+	u16 ctx_id;		/* ctx_hndl_t */
+	u16 req_flags;
+#define SISL_REQ_FLAGS_RES_HNDL       0x8000u	/* bit 0 (MSB) */
+#define SISL_REQ_FLAGS_PORT_LUN_ID    0x0000u
+
+#define SISL_REQ_FLAGS_SUP_UNDERRUN   0x4000u	/* bit 1 */
+
+#define SISL_REQ_FLAGS_TIMEOUT_SECS   0x0000u	/* bits 8,9 */
+#define SISL_REQ_FLAGS_TIMEOUT_MSECS  0x0040u
+#define SISL_REQ_FLAGS_TIMEOUT_USECS  0x0080u
+#define SISL_REQ_FLAGS_TIMEOUT_CYCLES 0x00C0u
+
+#define SISL_REQ_FLAGS_TMF_CMD        0x0004u	/* bit 13 */
+
+#define SISL_REQ_FLAGS_AFU_CMD        0x0002u	/* bit 14 */
+
+#define SISL_REQ_FLAGS_HOST_WRITE     0x0001u	/* bit 15 (LSB) */
+#define SISL_REQ_FLAGS_HOST_READ      0x0000u
+
+	union {
+		u32 res_hndl;	/* res_hndl_t */
+		u32 port_sel;	/* this is a selection mask:
+				 * 0x1 -> port#0 can be selected,
+				 * 0x2 -> port#1 can be selected.
+				 * Can be bitwise ORed.
+				 */
+	};
+	u64 lun_id;
+	u32 data_len;		/* 4K for read/write */
+	u32 ioadl_len;
+	union {
+		u64 data_ea;	/* min 16 byte aligned */
+		u64 ioadl_ea;
+	};
+	u8 msi;			/* LISN to send on RRQ write */
+#define SISL_MSI_PSL_XLATE         0	/* reserved for PSL */
+#define SISL_MSI_SYNC_ERROR        1	/* recommended for AFU sync error */
+#define SISL_MSI_RRQ_UPDATED       2	/* recommended for IO completion */
+#define SISL_MSI_ASYNC_ERROR       3	/* master only - for AFU async error */
+	/* The above LISN allocation permits user contexts to use 3 interrupts.
+	 * Only master needs 4. This saves IRQs on the system.
+	 */
+
+	u8 rrq;			/* 0 for a single RRQ */
+	u16 timeout;		/* in units specified by req_flags */
+	u32 rsvd1;
+	u8 cdb[16];		/* must be in big endian */
+	u64 rsvd2;
+};
+
+struct sisl_rc {
+	u8 flags;
+#define SISL_RC_FLAGS_SENSE_VALID         0x80u
+#define SISL_RC_FLAGS_FCP_RSP_CODE_VALID  0x40u
+#define SISL_RC_FLAGS_OVERRUN             0x20u
+#define SISL_RC_FLAGS_UNDERRUN            0x10u
+
+	u8 afu_rc;
+#define SISL_AFU_RC_RHT_INVALID           0x01u	/* user error */
+#define SISL_AFU_RC_RHT_UNALIGNED         0x02u	/* should never happen */
+#define SISL_AFU_RC_RHT_OUT_OF_BOUNDS     0x03u	/* user error */
+#define SISL_AFU_RC_RHT_DMA_ERR           0x04u	/* see afu_extra
+						   may retry if afu_retry is off
+						   possible on master exit
+						 */
+#define SISL_AFU_RC_RHT_RW_PERM           0x05u	/* no RW perms, user error */
+#define SISL_AFU_RC_LXT_UNALIGNED         0x12u	/* should never happen */
+#define SISL_AFU_RC_LXT_OUT_OF_BOUNDS     0x13u	/* user error */
+#define SISL_AFU_RC_LXT_DMA_ERR           0x14u	/* see afu_extra
+						   may retry if afu_retry is off
+						   possible on master exit
+						 */
+#define SISL_AFU_RC_LXT_RW_PERM           0x15u	/* no RW perms, user error */
+
+#define SISL_AFU_RC_NOT_XLATE_HOST        0x1au	/* possible when master exited */
+
+	/* NO_CHANNELS means the FC ports selected by dest_port in
+	 * IOARCB or in the LXT entry are down when the AFU tried to select
+	 * a FC port. If the port went down on an active IO, it will set
+	 * fc_rc to =0x54(NOLOGI) or 0x57(LINKDOWN) instead.
+	 */
+#define SISL_AFU_RC_NO_CHANNELS           0x20u	/* see afu_extra, may retry */
+#define SISL_AFU_RC_CAP_VIOLATION         0x21u	/* either user error or
+						   afu reset/master restart
+						 */
+#define SISL_AFU_RC_OUT_OF_DATA_BUFS      0x30u	/* always retry */
+#define SISL_AFU_RC_DATA_DMA_ERR          0x31u	/* see afu_extra
+						   may retry if afu_retry is off
+						 */
+
+	u8 scsi_rc;		/* SCSI status byte, retry as appropriate */
+#define SISL_SCSI_RC_CHECK                0x02u
+#define SISL_SCSI_RC_BUSY                 0x08u
+
+	u8 fc_rc;		/* retry */
+	/*
+	 * We should only see fc_rc=0x57 (LINKDOWN) or 0x54(NOLOGI)
+	 * for commands that are in flight when a link goes down or is logged out.
+	 * If the link is down or logged out before AFU selects the port, either
+	 * it will choose the other port or we will get afu_rc=0x20 (no_channel)
+	 * if there is no valid port to use.
+	 *
+	 * ABORTPEND/ABORTOK/ABORTFAIL/TGTABORT can be retried, typically these
+	 * would happen if a frame is dropped and something times out.
+	 * NOLOGI or LINKDOWN can be retried if the other port is up.
+	 * RESIDERR can be retried as well.
+	 *
+	 * ABORTFAIL might indicate that lots of frames are getting CRC errors.
+	 * So it maybe retried once and reset the link if it happens again.
+	 * The link can also be reset on the CRC error threshold interrupt.
+	 */
+#define SISL_FC_RC_ABORTPEND              0x52	/* exchange timeout or abort request */
+#define SISL_FC_RC_WRABORTPEND            0x53	/* due to write XFER_RDY invalid */
+#define SISL_FC_RC_NOLOGI                 0x54	/* port not logged in, in-flight cmds */
+#define SISL_FC_RC_NOEXP                  0x55	/* FC protocol error or HW bug */
+#define SISL_FC_RC_INUSE                  0x56	/* tag already in use, HW bug */
+#define SISL_FC_RC_LINKDOWN               0x57	/* link down, in-flight cmds */
+#define SISL_FC_RC_ABORTOK                0x58	/* pending abort completed w/success */
+#define SISL_FC_RC_ABORTFAIL              0x59	/* pending abort completed w/fail */
+#define SISL_FC_RC_RESID                  0x5A	/* ioasa underrun/overrun flags set */
+#define SISL_FC_RC_RESIDERR               0x5B	/* actual data len does not match SCSI
+						   reported len, possbly due to dropped
+						   frames */
+#define SISL_FC_RC_TGTABORT               0x5C	/* command aborted by target */
+
+};
+
+#define SISL_SENSE_DATA_LEN     20	/* Sense data length         */
+
+/*
+ * IOASA: 64 bytes & must follow IOARCB, min 16 byte alignment required,
+ * host native endianness
+ */
+struct sisl_ioasa {
+	union {
+		struct sisl_rc rc;
+		u32 ioasc;
+#define SISL_IOASC_GOOD_COMPLETION        0x00000000u
+	};
+	u32 resid;
+	u8 port;
+	u8 afu_extra;
+	/* when afu_rc=0x04, 0x14, 0x31 (_xxx_DMA_ERR):
+	 * afu_exta contains PSL response code. Useful codes are:
+	 */
+#define SISL_AFU_DMA_ERR_PAGE_IN      0x0A	/* AFU_retry_on_pagein SW_Implication
+						 *  Enabled            N/A
+						 *  Disabled           retry
+						 */
+#define SISL_AFU_DMA_ERR_INVALID_EA   0x0B	/* this is a hard error
+						 * afu_rc              SW_Implication
+						 * 0x04, 0x14          Indicates master exit.
+						 * 0x31                user error.
+						 */
+	/* when afu rc=0x20 (no channels):
+	 * afu_extra bits [4:5]: available portmask,  [6:7]: requested portmask.
+	 */
+#define SISL_AFU_NO_CLANNELS_AMASK(afu_extra) (((afu_extra) & 0x0C) >> 2)
+#define SISL_AFU_NO_CLANNELS_RMASK(afu_extra) ((afu_extra) & 0x03)
+
+	u8 scsi_extra;
+	u8 fc_extra;
+	u8 sense_data[SISL_SENSE_DATA_LEN];
+
+	union {
+		u64 host_use[4];
+		u8 host_use_b[32];
+	};
+};
+
+#define SISL_RESP_HANDLE_T_BIT        0x1ull	/* Toggle bit */
+
+/* MMIO space is required to support only 64-bit access */
+
+/* per context host transport MMIO  */
+struct sisl_host_map {
+	__be64 endian_ctrl;
+	__be64 intr_status;	/* this sends LISN# programmed in ctx_ctrl.
+				 * Only recovery in a PERM_ERR is a context exit since
+				 * there is no way to tell which command caused the error.
+				 */
+#define SISL_ISTATUS_PERM_ERR_CMDROOM    0x0010ull	/* b59, user error */
+#define SISL_ISTATUS_PERM_ERR_RCB_READ   0x0008ull	/* b60, user error */
+#define SISL_ISTATUS_PERM_ERR_SA_WRITE   0x0004ull	/* b61, user error */
+#define SISL_ISTATUS_PERM_ERR_RRQ_WRITE  0x0002ull	/* b62, user error */
+	/* Page in wait accessing RCB/IOASA/RRQ is reported in b63.
+	 * Same error in data/LXT/RHT access is reported via IOASA.
+	 */
+#define SISL_ISTATUS_TEMP_ERR_PAGEIN     0x0001ull	/* b63,  can be generated
+							 * only when AFU auto retry is
+							 * disabled. If user can determine
+							 * the command that caused the error,
+							 * it can be retried.
+							 */
+#define SISL_ISTATUS_UNMASK  (0x001Full)	/* 1 means unmasked */
+#define SISL_ISTATUS_MASK    ~(SISL_ISTATUS_UNMASK)	/* 1 means masked */
+
+	__be64 intr_clear;
+	__be64 intr_mask;
+	__be64 ioarrin;		/* only write what cmd_room permits */
+	__be64 rrq_start;	/* start & end are both inclusive */
+	__be64 rrq_end;		/* write sequence: start followed by end */
+	__be64 cmd_room;
+	__be64 ctx_ctrl;	/* least signiifcant byte or b56:63 is LISN# */
+	__be64 mbox_w;		/* restricted use */
+};
+
+/* per context provisioning & control MMIO */
+struct sisl_ctrl_map {
+	__be64 rht_start;
+	__be64 rht_cnt_id;
+	/* both cnt & ctx_id args must be ull */
+#define SISL_RHT_CNT_ID(cnt, ctx_id)  (((cnt) << 48) | ((ctx_id) << 32))
+
+	__be64 ctx_cap;		/* afu_rc below is when the capability is violated */
+#define SISL_CTX_CAP_PROXY_ISSUE       0x8000000000000000ull	/* afu_rc 0x21 */
+#define SISL_CTX_CAP_REAL_MODE         0x4000000000000000ull	/* afu_rc 0x21 */
+#define SISL_CTX_CAP_HOST_XLATE        0x2000000000000000ull	/* afu_rc 0x1a */
+#define SISL_CTX_CAP_PROXY_TARGET      0x1000000000000000ull	/* afu_rc 0x21 */
+#define SISL_CTX_CAP_AFU_CMD           0x0000000000000008ull	/* afu_rc 0x21 */
+#define SISL_CTX_CAP_GSCSI_CMD         0x0000000000000004ull	/* afu_rc 0x21 */
+#define SISL_CTX_CAP_WRITE_CMD         0x0000000000000002ull	/* afu_rc 0x21 */
+#define SISL_CTX_CAP_READ_CMD          0x0000000000000001ull	/* afu_rc 0x21 */
+	__be64 mbox_r;
+};
+
+/* single copy global regs */
+struct sisl_global_regs {
+	__be64 aintr_status;
+	/* In cxlflash, each FC port/link gets a byte of status */
+#define SISL_ASTATUS_FC0_OTHER    0x8000ull	/* b48, other err, FC_ERRCAP[31:20] */
+#define SISL_ASTATUS_FC0_LOGO     0x4000ull	/* b49, target sent FLOGI/PLOGI/LOGO
+						   while logged in */
+#define SISL_ASTATUS_FC0_CRC_T    0x2000ull	/* b50, CRC threshold exceeded */
+#define SISL_ASTATUS_FC0_LOGI_R   0x1000ull	/* b51, login state mechine timed out
+						   and retrying */
+#define SISL_ASTATUS_FC0_LOGI_F   0x0800ull	/* b52, login failed, FC_ERROR[19:0] */
+#define SISL_ASTATUS_FC0_LOGI_S   0x0400ull	/* b53, login succeeded */
+#define SISL_ASTATUS_FC0_LINK_DN  0x0200ull	/* b54, link online to offline */
+#define SISL_ASTATUS_FC0_LINK_UP  0x0100ull	/* b55, link offline to online */
+
+#define SISL_ASTATUS_FC1_OTHER    0x0080ull	/* b56 */
+#define SISL_ASTATUS_FC1_LOGO     0x0040ull	/* b57 */
+#define SISL_ASTATUS_FC1_CRC_T    0x0020ull	/* b58 */
+#define SISL_ASTATUS_FC1_LOGI_R   0x0010ull	/* b59 */
+#define SISL_ASTATUS_FC1_LOGI_F   0x0008ull	/* b60 */
+#define SISL_ASTATUS_FC1_LOGI_S   0x0004ull	/* b61 */
+#define SISL_ASTATUS_FC1_LINK_DN  0x0002ull	/* b62 */
+#define SISL_ASTATUS_FC1_LINK_UP  0x0001ull	/* b63 */
+
+#define SISL_FC_INTERNAL_UNMASK     0x0000000300000000ull	/* 1 means unmasked */
+#define SISL_FC_INTERNAL_MASK     ~(SISL_FC_INTERNAL_UNMASK)
+#define SISL_FC_INTERNAL_SHIFT     32
+
+#define SISL_ASTATUS_UNMASK       0xFFFFull	/* 1 means unmasked */
+#define SISL_ASTATUS_MASK         ~(SISL_ASTATUS_UNMASK)	/* 1 means masked */
+
+	__be64 aintr_clear;
+	__be64 aintr_mask;
+	__be64 afu_ctrl;
+	__be64 afu_hb;
+	__be64 afu_scratch_pad;
+	__be64 afu_port_sel;
+	__be64 afu_config;
+	__be64 rsvd[0xf8];
+	__be64 afu_version;
+	__be64 interface_version;
+};
+
+#define CXLFLASH_NUM_FC_PORTS   2
+#define CXLFLASH_MAX_CONTEXT  512	/* how many contexts per afu */
+#define CXLFLASH_NUM_VLUNS    512
+
+struct sisl_global_map {
+	union {
+		struct sisl_global_regs regs;
+		char page0[PAGE_SIZE_4K];	/* page 0 */
+	};
+
+	char page1[PAGE_SIZE_4K];	/* page 1 */
+	__be64 fc_regs[CXLFLASH_NUM_FC_PORTS][CXLFLASH_NUM_VLUNS];	/* pages 2 & 3, see afu_fc.h */
+	__be64 fc_port[CXLFLASH_NUM_FC_PORTS][CXLFLASH_NUM_VLUNS];	/* pages 4 & 5 (lun tbl) */
+
+};
+
+/* CXL Flash Memory Map 
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
+*/
+
+struct cxlflash_afu_map {
+	union {
+		struct sisl_host_map host;
+		char harea[PAGE_SIZE_64K];	/* 64KB each */
+	} hosts[CXLFLASH_MAX_CONTEXT];
+
+	union {
+		struct sisl_ctrl_map ctrl;
+		char carea[cache_line_size()];	/* 128B each */
+	} ctrls[CXLFLASH_MAX_CONTEXT];
+
+	union {
+		struct sisl_global_map global;
+		char garea[PAGE_SIZE_64K];	/* 64KB single block */
+	};
+};
+
+/* LBA translation control blocks */
+
+struct sisl_lxt_entry {
+	__be64 rlba_base;	/* bits 0:47 is base
+				 * b48:55 is lun index
+				 * b58:59 is write & read perms
+				 * (if no perm, afu_rc=0x15)
+				 * b60:63 is port_sel mask
+				 */
+
+};
+
+struct sisl_rht_entry {
+	struct sisl_lxt_entry *lxt_start;
+	__be32 lxt_cnt;
+	__be16 rsvd;
+	u8 fp;			/* format & perm nibbles.
+				 * (if no perm, afu_rc=0x05)
+				 */
+	u8 nmask;
+} __attribute__ ((aligned(16)));
+
+struct sisl_rht_entry_f1 {
+	__be64 lun_id;
+	union {
+		struct {
+			u8 valid;
+			u8 rsvd[5];
+			u8 fp;
+			u8 port_sel;
+		};
+
+		__be64 dw;
+	};
+} __attribute__ ((aligned(16)));
+
+/* make the fp byte */
+#define SISL_RHT_FP(fmt, perm) (((fmt) << 4) | (perm))
+
+/* make the fp byte for a clone from a source fp and clone flags
+ * flags must be only 2 LSB bits.
+ */
+#define SISL_RHT_FP_CLONE(src_fp, clone_flags) ((src_fp) & (0xFC | (clone_flags)))
+
+/* extract the perm bits from a fp */
+#define SISL_RHT_PERM(fp) ((fp) & 0x3)
+
+#define RHT_PERM_READ  0x01u
+#define RHT_PERM_WRITE 0x02u
+
+/* AFU Sync Mode byte */
+#define AFU_LW_SYNC 0x0u
+#define AFU_HW_SYNC 0x1u
+#define AFU_GSYNC   0x2u
+
+/* Special Task Management Function CDB */
+#define TMF_LUN_RESET  0x1u
+#define TMF_CLEAR_ACA  0x2u
+
+#endif /* _SISLITE_H */
-- 
2.1.0

