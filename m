From: James.Smart@Emulex.Com
Subject: [PATCH 7/11]  lpfc 8.1.1 : Add support for more members of the Light Pulse 11xxx (4Gb) family
Date: Mon, 28 Nov 2005 11:42:12 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C4B@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44533 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751294AbVK1QmO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 11:42:14 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id jASGgDs3014154
	for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2005 08:42:13 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com


Add support for more members of the Light Pulse 11xxx (4Gb) family


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2005-11-28 10:36:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2005-11-28 10:51:01.000000000 -0500
@@ -1027,23 +1027,32 @@ typedef struct {
 /* Start FireFly Register definitions */
 #define PCI_VENDOR_ID_EMULEX        0x10df
 #define PCI_DEVICE_ID_FIREFLY       0x1ae5
-#define PCI_DEVICE_ID_SUPERFLY      0xf700
-#define PCI_DEVICE_ID_DRAGONFLY     0xf800
 #define PCI_DEVICE_ID_RFLY          0xf095
 #define PCI_DEVICE_ID_PFLY          0xf098
+#define PCI_DEVICE_ID_LP101         0xf0a1
 #define PCI_DEVICE_ID_TFLY          0xf0a5
+#define PCI_DEVICE_ID_BSMB          0xf0d1
+#define PCI_DEVICE_ID_BMID          0xf0d5
+#define PCI_DEVICE_ID_ZSMB          0xf0e1
+#define PCI_DEVICE_ID_ZMID          0xf0e5
+#define PCI_DEVICE_ID_NEPTUNE       0xf0f5
+#define PCI_DEVICE_ID_NEPTUNE_SCSP  0xf0f6
+#define PCI_DEVICE_ID_NEPTUNE_DCSP  0xf0f7
+#define PCI_DEVICE_ID_SUPERFLY      0xf700
+#define PCI_DEVICE_ID_DRAGONFLY     0xf800
 #define PCI_DEVICE_ID_CENTAUR       0xf900
 #define PCI_DEVICE_ID_PEGASUS       0xf980
 #define PCI_DEVICE_ID_THOR          0xfa00
 #define PCI_DEVICE_ID_VIPER         0xfb00
+#define PCI_DEVICE_ID_LP10000S      0xfc00
+#define PCI_DEVICE_ID_LP11000S      0xfc10
+#define PCI_DEVICE_ID_LPE11000S     0xfc20
 #define PCI_DEVICE_ID_HELIOS        0xfd00
-#define PCI_DEVICE_ID_BMID          0xf0d5
-#define PCI_DEVICE_ID_BSMB          0xf0d1
+#define PCI_DEVICE_ID_HELIOS_SCSP   0xfd11
+#define PCI_DEVICE_ID_HELIOS_DCSP   0xfd12
 #define PCI_DEVICE_ID_ZEPHYR        0xfe00
-#define PCI_DEVICE_ID_ZMID          0xf0e5
-#define PCI_DEVICE_ID_ZSMB          0xf0e1
-#define PCI_DEVICE_ID_LP101	    0xf0a1
-#define PCI_DEVICE_ID_LP10000S	    0xfc00
+#define PCI_DEVICE_ID_ZEPHYR_SCSP   0xfe11
+#define PCI_DEVICE_ID_ZEPHYR_DCSP   0xfe12
 
 #define JEDEC_ID_ADDRESS            0x0080001c
 #define FIREFLY_JEDEC_ID            0x1ACC
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2005-11-28 10:36:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2005-11-28 10:51:01.000000000 -0500
@@ -759,15 +759,15 @@ static void
 lpfc_get_hba_model_desc(struct lpfc_hba * phba, uint8_t * mdp, uint8_t * descp)
 {
 	lpfc_vpd_t *vp;
-	uint32_t id;
+	uint16_t dev_id;
 	uint8_t hdrtype;
 	char str[16];
 
 	vp = &phba->vpd;
-	pci_read_config_dword(phba->pcidev, PCI_VENDOR_ID, &id);
+	pci_read_config_word(phba->pcidev, PCI_DEVICE_ID, &dev_id);
 	pci_read_config_byte(phba->pcidev, PCI_HEADER_TYPE, &hdrtype);
 
-	switch ((id >> 16) & 0xffff) {
+	switch (dev_id) {
 	case PCI_DEVICE_ID_FIREFLY:
 		strcpy(str, "LP6000 1");
 		break;
@@ -816,6 +816,24 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		else
 			strcpy(str, "LP11000 4");
 		break;
+	case PCI_DEVICE_ID_HELIOS_SCSP:
+		strcpy(str, "LP11000-SP 4");
+		break;
+	case PCI_DEVICE_ID_HELIOS_DCSP:
+		strcpy(str, "LP11002-SP 4");
+		break;
+	case PCI_DEVICE_ID_NEPTUNE:
+		if (hdrtype == 0x80)
+			strcpy(str, "LPe1002 4");
+		else
+			strcpy(str, "LPe1000 4");
+		break;
+	case PCI_DEVICE_ID_NEPTUNE_SCSP:
+		strcpy(str, "LPe1000-SP 4");
+		break;
+	case PCI_DEVICE_ID_NEPTUNE_DCSP:
+		strcpy(str, "LPe1002-SP 4");
+		break;
 	case PCI_DEVICE_ID_BMID:
 		strcpy(str, "LP1150 4");
 		break;
@@ -828,6 +846,12 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		else
 			strcpy(str, "LPe11000 4");
 		break;
+	case PCI_DEVICE_ID_ZEPHYR_SCSP:
+		strcpy(str, "LPe11000-SP 4");
+		break;
+	case PCI_DEVICE_ID_ZEPHYR_DCSP:
+		strcpy(str, "LPe11002-SP 4");
+		break;
 	case PCI_DEVICE_ID_ZMID:
 		strcpy(str, "LPe1150 4");
 		break;
@@ -843,6 +867,18 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 	default:
 		memset(str, 0, 16);
 		break;
+	case PCI_DEVICE_ID_LP11000S:
+		if (hdrtype == 0x80)
+			strcpy(str, "LP11002-S 4");
+		else
+			strcpy(str, "LP11000-S 4");
+		break;
+	case PCI_DEVICE_ID_LPE11000S:
+		if (hdrtype == 0x80)
+			strcpy(str, "LPe11002-S 4");
+		else
+			strcpy(str, "LPe11000-S 4");
+		break;
 	}
 	if (mdp)
 		sscanf(str, "%s", mdp);
@@ -1673,14 +1709,28 @@ static struct pci_device_id lpfc_id_tabl
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PFLY,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_NEPTUNE,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_NEPTUNE_SCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_NEPTUNE_DCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HELIOS,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HELIOS_SCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HELIOS_DCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_BMID,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_BSMB,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR_SCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR_DCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZMID,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZSMB,
@@ -1691,6 +1741,10 @@ static struct pci_device_id lpfc_id_tabl
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LP10000S,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LP11000S,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LPE11000S,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 }
 };
 
