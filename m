From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] add IS_ISP* helpers
Date: Sun, 6 Jun 2004 14:57:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040606125735.GC31063@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:26826 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263555AbUFFM5i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2004 08:57:38 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org

The code is already messy due to the explicit pci id checks for
1280 vs 1x160, so add some nice helpers for that.


diff -Nru a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c	2004-06-06 14:44:56 +02:00
+++ b/drivers/scsi/qla1280.c	2004-06-06 14:44:56 +02:00
@@ -485,6 +485,14 @@
 #define ia64_platform_is(foo)		(!strcmp(x, platform_name))
 #endif
 
+
+#define IS_ISP1040(ha) (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP1020)
+#define IS_ISP1x40(ha) (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP1020 || \
+			ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP1240)
+#define IS_ISP1x160(ha)        (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP10160 || \
+				ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP12160)
+
+
 static int qla1280_probe_one(struct pci_dev *, const struct pci_device_id *);
 static void qla1280_remove_one(struct pci_dev *);
 
@@ -1384,16 +1392,10 @@
 	uint8_t mr;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	struct nvram *nv;
-	int is1x160, status;
+	int status;
 
 	nv = &ha->nvram;
 
-	if (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP12160 ||
-	    ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP10160)
-		is1x160 = 1;
-	else
-		is1x160 = 0;
-
 	mr = BIT_3 | BIT_2 | BIT_1 | BIT_0;
 
 	/* Set Target Parameters. */
@@ -1403,17 +1405,16 @@
 
 	mb[2] = (nv->bus[bus].target[target].parameter.c << 8);
 
-	if (is1x160)
-		mb[3] =	nv->bus[bus].target[target].flags.flags1x160.sync_offset << 8;
-	else
-		mb[3] =	nv->bus[bus].target[target].flags.flags1x80.sync_offset << 8;
-	mb[3] |= nv->bus[bus].target[target].sync_period;
-
-	if (is1x160) {
+	if (IS_ISP1x160(ha)) {
 		mb[2] |= nv->bus[bus].target[target].ppr_1x160.flags.enable_ppr << 5;
-		mb[6] =	nv->bus[bus].target[target].ppr_1x160.flags.ppr_options << 8;
-		mb[6] |= nv->bus[bus].target[target].ppr_1x160.flags.ppr_bus_width;
+		mb[3] =	(nv->bus[bus].target[target].flags.flags1x160.sync_offset << 8) |
+			 nv->bus[bus].target[target].sync_period;
+		mb[6] =	(nv->bus[bus].target[target].ppr_1x160.flags.ppr_options << 8) |
+			 nv->bus[bus].target[target].ppr_1x160.flags.ppr_bus_width;
 		mr |= BIT_6;
+	} else {
+		mb[3] =	(nv->bus[bus].target[target].flags.flags1x80.sync_offset << 8) |
+			 nv->bus[bus].target[target].sync_period;
 	}
 
 	status = qla1280_mailbox_command(ha, mr, &mb[0]);
@@ -1476,8 +1477,7 @@
 	    (driver_setup.wide_mask &&
 	     (~driver_setup.wide_mask & (1 << target))))
 		nv->bus[bus].target[target].parameter.f.enable_wide = 0;
-	if (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP12160 ||
-	    ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP10160) {
+	if (IS_ISP1x160(ha)) {
 		if (driver_setup.no_ppr ||
 		    (driver_setup.ppr_mask &&
 		     (~driver_setup.ppr_mask & (1 << target))))
@@ -2289,19 +2289,13 @@
 {
 	struct device_reg *reg = ha->iobase;
 	struct nvram *nv;
-	int is1x160, status = 0;
+	int status = 0;
 	int bus, target, lun;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	uint16_t mask;
 
 	ENTER("qla1280_nvram_config");
 
-	if (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP12160 ||
-	    ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP10160)
-		is1x160 = 1;
-	else
-		is1x160 = 0;
-
 	nv = &ha->nvram;
 	if (!ha->nvram_valid) {
 		dprintk(1, "Using defaults for NVRAM: \n");
@@ -2325,7 +2319,7 @@
 		 */
 		nv->isp_config.c = 0x44;
 
-		if (is1x160)
+		if (IS_ISP1x160(ha))
 			nv->isp_parameter = 0x01;
 
 		for (bus = 0; bus < MAX_BUSES; bus++) {
@@ -2357,7 +2351,7 @@
 					disconnect_allowed = 1;
 				nv->bus[bus].target[target].execution_throttle=
 					nv->bus[bus].max_queue_depth - 1;
-				if (is1x160) {
+				if (IS_ISP1x160(ha)) {
 					nv->bus[bus].target[target].flags.
 						flags1x160.device_enable = 1;
 					nv->bus[bus].target[target].flags.
@@ -2558,16 +2552,18 @@
 			nv->bus[bus].target[target].parameter.f.
 				stop_queue_on_check = 0;
 
-			if (is1x160)
+			if (IS_ISP1x160(ha)) {
 				nv->bus[bus].target[target].ppr_1x160.
 					flags.enable_ppr = 0;
+			}
+
 			/*
 			 * No sync, wide, etc. while probing
 			 */
 			mb[2] = (nv->bus[bus].target[target].parameter.c << 8)&
 				~(TP_SYNC /*| TP_WIDE | TP_PPR*/);
 
-			if (is1x160)
+			if (IS_ISP1x160(ha))
 				mb[3] =	nv->bus[bus].target[target].flags.flags1x160.sync_offset << 8;
 			else
 				mb[3] =	nv->bus[bus].target[target].flags.flags1x80.sync_offset << 8;
@@ -2579,7 +2575,7 @@
 			 * determined that the target actually supports it
 			 */
 #if 0
-			if (is1x160) {
+			if (IS_ISP1x160(ha)) {
 				mb[2] |= nv->bus[bus].target[target].ppr_1x160.flags.enable_ppr << 5;
 
 				mb[6] =	nv->bus[bus].target[target].ppr_1x160.flags.ppr_options << 8;
@@ -2596,7 +2592,7 @@
 				ha->bus_settings[bus].qtag_enables |= mb[0];
 
 			/* Save Device enable flag. */
-			if (is1x160) {
+			if (IS_ISP1x160(ha)) {
 				if (nv->bus[bus].target[target].flags.flags1x160.device_enable)
 					ha->bus_settings[bus].device_enables |= mb[0];
 				ha->bus_settings[bus].lun_disables |= 0;
