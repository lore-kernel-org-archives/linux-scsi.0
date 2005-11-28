From: James.Smart@Emulex.Com
Subject: [PATCH 8/11]  lpfc 8.1.1 : Bring model descriptions in sync with Emulex standard generic names
Date: Mon, 28 Nov 2005 11:42:19 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C4C@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45557 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751293AbVK1QmW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 11:42:22 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id jASGgKs3014159
	for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2005 08:42:21 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com


Bring model descriptions in sync with Emulex standard generic names.


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2005-11-28 10:51:01.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2005-11-28 10:55:21.000000000 -0500
@@ -1054,6 +1054,12 @@ typedef struct {
 #define PCI_DEVICE_ID_ZEPHYR_SCSP   0xfe11
 #define PCI_DEVICE_ID_ZEPHYR_DCSP   0xfe12
 
+#define PCI_SUBSYSTEM_ID_LP11000S      0xfc11
+#define PCI_SUBSYSTEM_ID_LP11002S      0xfc12
+#define PCI_SUBSYSTEM_ID_LPE11000S     0xfc21
+#define PCI_SUBSYSTEM_ID_LPE11002S     0xfc22
+#define PCI_SUBSYSTEM_ID_LPE11010S     0xfc2A
+
 #define JEDEC_ID_ADDRESS            0x0080001c
 #define FIREFLY_JEDEC_ID            0x1ACC
 #define SUPERFLY_JEDEC_ID           0x0020
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2005-11-28 10:51:01.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2005-11-28 10:55:21.000000000 -0500
@@ -760,8 +760,9 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 {
 	lpfc_vpd_t *vp;
 	uint16_t dev_id;
+	uint16_t dev_subid;
 	uint8_t hdrtype;
-	char str[16];
+	char *model_str = "";
 
 	vp = &phba->vpd;
 	pci_read_config_word(phba->pcidev, PCI_DEVICE_ID, &dev_id);
@@ -769,122 +770,132 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 
 	switch (dev_id) {
 	case PCI_DEVICE_ID_FIREFLY:
-		strcpy(str, "LP6000 1");
+		model_str = "LP6000 1Gb PCI";
 		break;
 	case PCI_DEVICE_ID_SUPERFLY:
 		if (vp->rev.biuRev >= 1 && vp->rev.biuRev <= 3)
-			strcpy(str, "LP7000 1");
+			model_str = "LP7000 1Gb PCI";
 		else
-			strcpy(str, "LP7000E 1");
+			model_str = "LP7000E 1Gb PCI";
 		break;
 	case PCI_DEVICE_ID_DRAGONFLY:
-		strcpy(str, "LP8000 1");
+		model_str = "LP8000 1Gb PCI";
 		break;
 	case PCI_DEVICE_ID_CENTAUR:
 		if (FC_JEDEC_ID(vp->rev.biuRev) == CENTAUR_2G_JEDEC_ID)
-			strcpy(str, "LP9002 2");
+			model_str = "LP9002 2Gb PCI";
 		else
-			strcpy(str, "LP9000 1");
+			model_str = "LP9000 1Gb PCI";
 		break;
 	case PCI_DEVICE_ID_RFLY:
-		strcpy(str, "LP952 2");
+		model_str = "LP952 2Gb PCI";
 		break;
 	case PCI_DEVICE_ID_PEGASUS:
-		strcpy(str, "LP9802 2");
+		model_str = "LP9802 2Gb PCI-X";
 		break;
 	case PCI_DEVICE_ID_THOR:
 		if (hdrtype == 0x80)
-			strcpy(str, "LP10000DC 2");
+			model_str = "LP10000DC 2Gb 2-port PCI-X";
 		else
-			strcpy(str, "LP10000 2");
+			model_str = "LP10000 2Gb PCI-X";
 		break;
 	case PCI_DEVICE_ID_VIPER:
-		strcpy(str, "LPX1000 10");
+		model_str = "LPX1000 10Gb PCI-X";
 		break;
 	case PCI_DEVICE_ID_PFLY:
-		strcpy(str, "LP982 2");
+		model_str = "LP982 2Gb PCI-X";
 		break;
 	case PCI_DEVICE_ID_TFLY:
 		if (hdrtype == 0x80)
-			strcpy(str, "LP1050DC 2");
+			model_str = "LP1050DC 2Gb 2-port PCI-X";
 		else
-			strcpy(str, "LP1050 2");
+			model_str = "LP1050 2Gb PCI-X";
 		break;
 	case PCI_DEVICE_ID_HELIOS:
 		if (hdrtype == 0x80)
-			strcpy(str, "LP11002 4");
+			model_str = "LP11002 4Gb 2-port PCI-X2";
 		else
-			strcpy(str, "LP11000 4");
+			model_str = "LP11000 4Gb PCI-X2";
 		break;
 	case PCI_DEVICE_ID_HELIOS_SCSP:
-		strcpy(str, "LP11000-SP 4");
+		model_str = "LP11000-SP 4Gb PCI-X2";
 		break;
 	case PCI_DEVICE_ID_HELIOS_DCSP:
-		strcpy(str, "LP11002-SP 4");
+		model_str = "LP11002-SP 4Gb 2-port PCI-X2";
 		break;
 	case PCI_DEVICE_ID_NEPTUNE:
 		if (hdrtype == 0x80)
-			strcpy(str, "LPe1002 4");
+			model_str = "LPe1002 4Gb 2-port";
 		else
-			strcpy(str, "LPe1000 4");
+			model_str = "LPe1000 4Gb PCIe";
 		break;
 	case PCI_DEVICE_ID_NEPTUNE_SCSP:
-		strcpy(str, "LPe1000-SP 4");
+		model_str = "LPe1000-SP 4Gb PCIe";
 		break;
 	case PCI_DEVICE_ID_NEPTUNE_DCSP:
-		strcpy(str, "LPe1002-SP 4");
+		model_str = "LPe1002-SP 4Gb 2-port PCIe";
 		break;
 	case PCI_DEVICE_ID_BMID:
-		strcpy(str, "LP1150 4");
+		model_str = "LP1150 4Gb PCI-X2";
 		break;
 	case PCI_DEVICE_ID_BSMB:
-		strcpy(str, "LP111 4");
+		model_str = "LP111 4Gb PCI-X2";
 		break;
 	case PCI_DEVICE_ID_ZEPHYR:
 		if (hdrtype == 0x80)
-			strcpy(str, "LPe11002 4");
+			model_str = "LPe11002 4Gb 2-port PCIe";
 		else
-			strcpy(str, "LPe11000 4");
+			model_str = "LPe11000 4Gb PCIe";
 		break;
 	case PCI_DEVICE_ID_ZEPHYR_SCSP:
-		strcpy(str, "LPe11000-SP 4");
+		model_str = "LPe11000-SP 4Gb PCIe";
 		break;
 	case PCI_DEVICE_ID_ZEPHYR_DCSP:
-		strcpy(str, "LPe11002-SP 4");
+		model_str = "LPe11002-SP 4Gb 2-port PCIe";
 		break;
 	case PCI_DEVICE_ID_ZMID:
-		strcpy(str, "LPe1150 4");
+		model_str = "LPe1150 4Gb PCIe";
 		break;
 	case PCI_DEVICE_ID_ZSMB:
-		strcpy(str, "LPe111 4");
+		model_str = "LPe111 4Gb PCIe";
 		break;
 	case PCI_DEVICE_ID_LP101:
-		strcpy(str, "LP101 2");
+		model_str = "LP101 2Gb PCI-X";
 		break;
 	case PCI_DEVICE_ID_LP10000S:
-		strcpy(str, "LP10000-S 2");
-		break;
-	default:
-		memset(str, 0, 16);
+		model_str = "LP10000-S 2Gb PCI";
 		break;
 	case PCI_DEVICE_ID_LP11000S:
-		if (hdrtype == 0x80)
-			strcpy(str, "LP11002-S 4");
-		else
-			strcpy(str, "LP11000-S 4");
-		break;
 	case PCI_DEVICE_ID_LPE11000S:
-		if (hdrtype == 0x80)
-			strcpy(str, "LPe11002-S 4");
-		else
-			strcpy(str, "LPe11000-S 4");
+		pci_read_config_word(phba->pcidev, PCI_SUBSYSTEM_ID,
+				     &dev_subid);
+		switch (dev_subid) {
+		case PCI_SUBSYSTEM_ID_LP11000S:
+			model_str = "LP11002-S 4Gb PCI-X2";
+			break;
+		case PCI_SUBSYSTEM_ID_LP11002S:
+			model_str = "LP11000-S 4Gb 2-port PCI-X2";
+			break;
+		case PCI_SUBSYSTEM_ID_LPE11000S:
+			model_str = "LPe11002-S 4Gb PCIe";
+			break;
+		case PCI_SUBSYSTEM_ID_LPE11002S:
+			model_str = "LPe11002-S 4Gb 2-port PCIe";
+			break;
+		case PCI_SUBSYSTEM_ID_LPE11010S:
+			model_str = "LPe11010-S 4Gb 10-port PCIe";
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
 		break;
 	}
 	if (mdp)
-		sscanf(str, "%s", mdp);
+		sscanf(model_str, "%s", mdp);
 	if (descp)
-		sprintf(descp, "Emulex LightPulse %s Gigabit PCI Fibre "
-			"Channel Adapter", str);
+		sprintf(descp, "Emulex %s Fibre Channel Adapter", model_str);
 }
 
 /**************************************************/
