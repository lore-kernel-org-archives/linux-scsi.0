From: linas <linas@austin.ibm.com>
Subject: [linas@austin.ibm.com: [PATCH 7/22] PCI Error Recovery: header file patch]
Date: Fri, 7 Oct 2005 15:33:13 -0500
Message-ID: <20051007203313.GJ29826@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42369 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1030553AbVJGUd0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2005 16:33:26 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j97KXQMJ027499
	for <linux-scsi@vger.kernel.org>; Fri, 7 Oct 2005 16:33:26 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j97KXQGk094226
	for <linux-scsi@vger.kernel.org>; Fri, 7 Oct 2005 16:33:26 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j97KXEmQ023829
	for <linux-scsi@vger.kernel.org>; Fri, 7 Oct 2005 16:33:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: groudier@free.fr, axboe@suse.de, dgilbert@interlog.com, James.Bottomley@SteelEye.com
Cc: Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org


Header file changes for the previous email.

--linas

----- Forwarded message from linas <linas@austin.ibm.com> -----

To: paulus@samba.org
Cc: linuxppc64-dev@ozlabs.org, linux-pci@atrey.karlin.mff.cuni.cz,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/22] PCI Error Recovery: header file patch

PCI Error Recovery: header file patch

Various PCI bus errors can be signaled by newer PCI controllers. Recovering 
from those errors requires an infrastructure to notify affected device drivers 
of the error, and a way of walking through a reset sequence.  This patch adds 
a set of callbacks to be used by error recovery routines to notify device 
drivers of the various stages of recovery.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>

--
 include/linux/pci.h |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+)

Index: linux-2.6.14-rc2-git6/include/linux/pci.h
===================================================================
--- linux-2.6.14-rc2-git6.orig/include/linux/pci.h	2005-10-06 17:50:29.442032212 -0500
+++ linux-2.6.14-rc2-git6/include/linux/pci.h	2005-10-06 17:52:50.634221570 -0500
@@ -78,6 +78,16 @@
 #define PCI_UNKNOWN	((pci_power_t __force) 5)
 #define PCI_POWER_ERROR	((pci_power_t __force) -1)
 
+/** The pci_channel state describes connectivity between the CPU and
+ *  the pci device.  If some PCI bus between here and the pci device
+ *  has crashed or locked up, this info is reflected here.
+ */
+enum pci_channel_state {
+	pci_channel_io_normal = 0, /* I/O channel is in normal state */
+	pci_channel_io_frozen = 1, /* I/O to channel is blocked */
+	pci_channel_io_perm_failure, /* PCI card is dead */
+};
+
 /*
  * The pci_dev structure is used to describe PCI devices.
  */
@@ -110,6 +120,7 @@
 					   this is D0-D3, D0 being fully functional,
 					   and D3 being off. */
 
+	enum pci_channel_state error_state;  /* current connectivity state */
 	struct	device	dev;		/* Generic device interface */
 
 	/* device is compatible with these IDs */
@@ -231,6 +242,43 @@
 	unsigned int use_driver_data:1; /* pci_driver->driver_data is used */
 };
 
+/* ---------------------------------------------------------------- */
+/** PCI error recovery infrastructure.  If a PCI device driver provides
+ *  a set fof callbacks in struct pci_error_handlers, then that device driver
+ *  will be notified of PCI bus errors, and will be driven to recovery
+ *  when an error occurs.
+ */
+
+enum pcierr_result {
+	PCIERR_RESULT_NONE=0,        /* no result/none/not supported in device driver */
+	PCIERR_RESULT_CAN_RECOVER=1, /* Device driver can recover without slot reset */
+	PCIERR_RESULT_NEED_RESET,    /* Device driver wants slot to be reset. */
+	PCIERR_RESULT_DISCONNECT,    /* Device has completely failed, is unrecoverable */
+	PCIERR_RESULT_RECOVERED,     /* Device driver is fully recovered and operational */
+};
+
+/* PCI bus error event callbacks */
+struct pci_error_handlers
+{
+	/* PCI bus error detected on this device */
+	int (*error_detected)(struct pci_dev *dev,
+	                      enum pci_channel_state error);
+
+	/* MMIO has been re-enabled, but not DMA */
+	int (*mmio_enabled)(struct pci_dev *dev);
+
+	/* PCI Express link has been reset */
+	int (*link_reset)(struct pci_dev *dev);
+
+	/* PCI slot has been reset */
+	int (*slot_reset)(struct pci_dev *dev);
+
+	/* Device driver may resume normal operations */
+	void (*resume)(struct pci_dev *dev);
+};
+
+/* ---------------------------------------------------------------- */
+
 struct module;
 struct pci_driver {
 	struct list_head node;
@@ -244,6 +292,7 @@
 	int  (*enable_wake) (struct pci_dev *dev, pci_power_t state, int enable);   /* Enable wake event */
 	void (*shutdown) (struct pci_dev *dev);
 
+	struct pci_error_handlers *err_handler;
 	struct device_driver	driver;
 	struct pci_dynids dynids;
 };
_______________________________________________
Linuxppc64-dev mailing list
Linuxppc64-dev@ozlabs.org
https://ozlabs.org/mailman/listinfo/linuxppc64-dev


----- End forwarded message -----
