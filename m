From: Jes Sorensen <jes@trained-monkey.org>
Subject: [patch] qla1280 compile fix for CONFIG_HOTPLUG in 2.6
Date: Mon, 12 Jan 2004 07:47:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <16386.38762.670634.620111@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:7620 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S266167AbUALMrm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2004 07:47:42 -0500
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

Hi Andrew,

Would you mind adding this patch on top of 2.6.1-mmX. It fixes a compile
problem with the 1280 driver when compiling it statically into the
kernel when CONFIG_HOTPLUG is enabled in 2.6.

Thanks,
Jes

--- orig/linux-2.6.0-test11-ia64/drivers/scsi/qla1280.c	Tue Jan  6 04:22:31 2004
+++ linux-2.6.0-test11-ia64/drivers/scsi/qla1280.c	Mon Jan 12 03:08:58 2004
@@ -20,6 +20,8 @@
 #define QLA1280_VERSION      "3.24.1"
 /*****************************************************************************
     Revision History:
+    Rev  3.24.2 January 12, 2004, Jes Sorensen
+	- Fix static compile with CONFIG_HOTPLUG enabled
     Rev  3.24.1 January 5, 2004, Jes Sorensen
 	- Initialize completion queue to avoid OOPS on probe
 	- Handle interrupts during mailbox testing
@@ -481,7 +483,7 @@
 #endif
 
 static int qla1280_probe_one(struct pci_dev *, const struct pci_device_id *);
-#if defined(CONFIG_SCSI_QLOGIC_1280_MODULE) || (LINUX_VERSION_CODE < 0x020600)
+#if defined(CONFIG_SCSI_QLOGIC_1280_MODULE) || (LINUX_VERSION_CODE < 0x020600) || defined(CONFIG_HOTPLUG)
 static void qla1280_remove_one(struct pci_dev *);
 #endif
 
@@ -4812,7 +4814,7 @@
 }
 
 
-#if defined(CONFIG_SCSI_QLOGIC_1280_MODULE) || (LINUX_VERSION_CODE < 0x020600)
+#if defined(CONFIG_SCSI_QLOGIC_1280_MODULE) || (LINUX_VERSION_CODE < 0x020600) || defined(CONFIG_HOTPLUG)
 static void __devexit
 qla1280_remove_one(struct pci_dev *pdev)
 {
