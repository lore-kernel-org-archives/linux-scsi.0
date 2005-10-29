From: James.Smart@Emulex.Com
Subject: [PATCH 2/15]  lpfc 8.1.0 : Update to Emulex hba model names
Date: Fri, 28 Oct 2005 20:29:01 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A51@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61904 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750903AbVJ2A3D convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:29:03 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0T2Dp018495
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:29:02 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update to Emulex hba model names

Fix: Update adapter names to match Emulex naming conventions.


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -766,10 +766,12 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 {
 	lpfc_vpd_t *vp;
 	uint32_t id;
+	uint8_t hdrtype;
 	char str[16];
 
 	vp = &phba->vpd;
 	pci_read_config_dword(phba->pcidev, PCI_VENDOR_ID, &id);
+	pci_read_config_byte(phba->pcidev, PCI_HEADER_TYPE, &hdrtype);
 
 	switch ((id >> 16) & 0xffff) {
 	case PCI_DEVICE_ID_FIREFLY:
@@ -797,7 +799,10 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		strcpy(str, "LP9802 2");
 		break;
 	case PCI_DEVICE_ID_THOR:
-		strcpy(str, "LP10000 2");
+		if (hdrtype == 0x80)
+			strcpy(str, "LP10000DC 2");
+		else
+			strcpy(str, "LP10000 2");
 		break;
 	case PCI_DEVICE_ID_VIPER:
 		strcpy(str, "LPX1000 10");
@@ -806,10 +811,16 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		strcpy(str, "LP982 2");
 		break;
 	case PCI_DEVICE_ID_TFLY:
-		strcpy(str, "LP1050 2");
+		if (hdrtype == 0x80)
+			strcpy(str, "LP1050DC 2");
+		else
+			strcpy(str, "LP1050 2");
 		break;
 	case PCI_DEVICE_ID_HELIOS:
-		strcpy(str, "LP11000 4");
+		if (hdrtype == 0x80)
+			strcpy(str, "LP11002 4");
+		else
+			strcpy(str, "LP11000 4");
 		break;
 	case PCI_DEVICE_ID_BMID:
 		strcpy(str, "LP1150 4");
@@ -818,13 +829,16 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		strcpy(str, "LP111 4");
 		break;
 	case PCI_DEVICE_ID_ZEPHYR:
-		strcpy(str, "LP11000e 4");
+		if (hdrtype == 0x80)
+			strcpy(str, "LPe11002 4");
+		else
+			strcpy(str, "LPe11000 4");
 		break;
 	case PCI_DEVICE_ID_ZMID:
-		strcpy(str, "LP1150e 4");
+		strcpy(str, "LPe1150 4");
 		break;
 	case PCI_DEVICE_ID_ZSMB:
-		strcpy(str, "LP111e 4");
+		strcpy(str, "LPe111 4");
 		break;
 	case PCI_DEVICE_ID_LP101:
 		strcpy(str, "LP101 2");
