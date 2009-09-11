From: HighPoint Linux Team <linux@highpoint-tech.com>
Subject: [PATCH][SCSI] hptiop: Add RR44xx adapter support
Date: Fri, 11 Sep 2009 17:21:27 +0800
Message-ID: <200909111721.27450.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp206.iad.emailsrvr.com ([207.97.245.206]:52558 "EHLO
	smtp206.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZIKJb5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2009 05:31:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Most code changes were made to support RR44xx adapters.
- add more PCI device ID.
- using PCI BAR[2] to access RR44xx IOP. 
- using PCI BAR[0] to check and clear RR44xx IRQ.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>

 Documentation/scsi/hptiop.txt |   21 ++++++++++++++++++++-
 drivers/scsi/hptiop.c         |   37 ++++++++++++++++++++++++++-----------
 drivers/scsi/hptiop.h         |    3 ++-
 3 files changed, 48 insertions(+), 13 deletions(-)

diff -urN linux-2.6.31.orig/Documentation/scsi/hptiop.txt linux-2.6.31/Documentation/scsi/hptiop.txt
--- linux-2.6.31.orig/Documentation/scsi/hptiop.txt	2009-09-11 16:11:48.000000000 +0800
+++ linux-2.6.31/Documentation/scsi/hptiop.txt	2009-09-11 16:11:48.000000000 +0800
@@ -3,6 +3,25 @@
 Controller Register Map
 -------------------------
 
+For RR44xx Intel IOP based adapters, the controller IOP is accessed via PCI BAR0 and BAR2:
+
+     BAR0 offset    Register
+            0x11C5C Link Interface IRQ Set
+            0x11C60 Link Interface IRQ Clear
+
+     BAR2 offset    Register
+            0x10    Inbound Message Register 0
+            0x14    Inbound Message Register 1
+            0x18    Outbound Message Register 0
+            0x1C    Outbound Message Register 1
+            0x20    Inbound Doorbell Register
+            0x24    Inbound Interrupt Status Register
+            0x28    Inbound Interrupt Mask Register
+            0x30    Outbound Interrupt Status Register
+            0x34    Outbound Interrupt Mask Register
+            0x40    Inbound Queue Port
+            0x44    Outbound Queue Port
+
 For Intel IOP based adapters, the controller IOP is accessed via PCI BAR0:
 
      BAR0 offset    Register
@@ -93,7 +112,7 @@
 
 
 -----------------------------------------------------------------------------
-Copyright (C) 2006-2007 HighPoint Technologies, Inc. All Rights Reserved.
+Copyright (C) 2006-2009 HighPoint Technologies, Inc. All Rights Reserved.
 
   This file is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
diff -urN linux-2.6.31.orig/drivers/scsi/hptiop.c linux-2.6.31/drivers/scsi/hptiop.c
--- linux-2.6.31.orig/drivers/scsi/hptiop.c	2009-09-11 16:11:48.000000000 +0800
+++ linux-2.6.31/drivers/scsi/hptiop.c	2009-09-11 16:11:48.000000000 +0800
@@ -1,6 +1,6 @@
 /*
  * HighPoint RR3xxx/4xxx controller driver for Linux
- * Copyright (C) 2006-2007 HighPoint Technologies, Inc. All Rights Reserved.
+ * Copyright (C) 2006-2009 HighPoint Technologies, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -41,7 +41,7 @@
 
 static char driver_name[] = "hptiop";
 static const char driver_name_long[] = "RocketRAID 3xxx/4xxx Controller driver";
-static const char driver_ver[] = "v1.3 (071203)";
+static const char driver_ver[] = "v1.6 (090910)";
 
 static int iop_send_sync_msg(struct hptiop_hba *hba, u32 msg, u32 millisec);
 static void hptiop_finish_scsi_req(struct hptiop_hba *hba, u32 tag,
@@ -115,9 +115,13 @@
 static int iop_intr_itl(struct hptiop_hba *hba)
 {
 	struct hpt_iopmu_itl __iomem *iop = hba->u.itl.iop;
+	void __iomem *plx = hba->u.itl.plx;
 	u32 status;
 	int ret = 0;
 
+	if (plx && readl(plx + 0x11C5C) & 0xf)
+		writel(1, plx + 0x11C60);
+
 	status = readl(&iop->outbound_intstatus);
 
 	if (status & IOPMU_OUTBOUND_INT_MSG0) {
@@ -460,15 +464,25 @@
 
 static int hptiop_map_pci_bar_itl(struct hptiop_hba *hba)
 {
+	struct pci_dev *pcidev = hba->pcidev;
 	hba->u.itl.iop = hptiop_map_pci_bar(hba, 0);
-	if (hba->u.itl.iop)
-		return 0;
-	else
+	if (hba->u.itl.iop == NULL)
 		return -1;
+	if ((pcidev->device & 0xff00) == 0x4400) {
+		hba->u.itl.plx = hba->u.itl.iop;
+		hba->u.itl.iop = hptiop_map_pci_bar(hba, 2);
+		if (hba->u.itl.iop == NULL) {
+			iounmap(hba->u.itl.plx);
+			return -1;
+		}
+	}
+	return 0;
 }
 
 static void hptiop_unmap_pci_bar_itl(struct hptiop_hba *hba)
 {
+	if (hba->u.itl.plx)
+		iounmap(hba->u.itl.plx);
 	iounmap(hba->u.itl.iop);
 }
 
@@ -1239,22 +1253,23 @@
 static struct pci_device_id hptiop_id_table[] = {
 	{ PCI_VDEVICE(TTI, 0x3220), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3320), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3520), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x4320), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3410), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3510), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3511), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3520), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3521), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3522), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3410), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3540), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3530), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3540), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3560), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x4321), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4210), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4211), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4310), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4311), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4320), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4321), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4400), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3120), (kernel_ulong_t)&hptiop_mv_ops },
 	{ PCI_VDEVICE(TTI, 0x3122), (kernel_ulong_t)&hptiop_mv_ops },
 	{ PCI_VDEVICE(TTI, 0x3020), (kernel_ulong_t)&hptiop_mv_ops },
diff -urN linux-2.6.31.orig/drivers/scsi/hptiop.h linux-2.6.31/drivers/scsi/hptiop.h
--- linux-2.6.31.orig/drivers/scsi/hptiop.h	2009-09-11 16:11:48.000000000 +0800
+++ linux-2.6.31/drivers/scsi/hptiop.h	2009-09-11 16:11:48.000000000 +0800
@@ -1,6 +1,6 @@
 /*
  * HighPoint RR3xxx/4xxx controller driver for Linux
- * Copyright (C) 2006-2007 HighPoint Technologies, Inc. All Rights Reserved.
+ * Copyright (C) 2006-2009 HighPoint Technologies, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -228,6 +228,7 @@
 	union {
 		struct {
 			struct hpt_iopmu_itl __iomem *iop;
+			void __iomem *plx;
 		} itl;
 		struct {
 			struct hpt_iopmv_regs *regs;

