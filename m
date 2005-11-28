From: James.Smart@Emulex.Com
Subject: [PATCH 12/11]  lpfc 8.1.1 : kill use of pci_read_config_xxx
Date: Mon, 28 Nov 2005 15:08:56 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B75@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:5274 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S932231AbVK1UJE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 15:09:04 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id jASK8ws3023018
	for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2005 12:08:59 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Here's the promised patch to address the comments on pci_read_config_xxx.

-- james s



--- a/drivers/scsi/lpfc/lpfc_init.c	2005-11-28 11:58:18.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2005-11-28 12:02:15.000000000 -0500
@@ -763,14 +763,12 @@ static void
 lpfc_get_hba_model_desc(struct lpfc_hba * phba, uint8_t * mdp, uint8_t * descp)
 {
 	lpfc_vpd_t *vp;
-	uint16_t dev_id;
-	uint16_t dev_subid;
-	uint8_t hdrtype;
+	uint16_t dev_id = phba->pcidev->device;
+	uint16_t dev_subid = phba->pcidev->subsystem_device;
+	uint8_t hdrtype = phba->pcidev->hdr_type;
 	char *model_str = "";
 
 	vp = &phba->vpd;
-	pci_read_config_word(phba->pcidev, PCI_DEVICE_ID, &dev_id);
-	pci_read_config_byte(phba->pcidev, PCI_HEADER_TYPE, &hdrtype);
 
 	switch (dev_id) {
 	case PCI_DEVICE_ID_FIREFLY:
@@ -871,8 +869,6 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		break;
 	case PCI_DEVICE_ID_LP11000S:
 	case PCI_DEVICE_ID_LPE11000S:
-		pci_read_config_word(phba->pcidev, PCI_SUBSYSTEM_ID,
-				     &dev_subid);
 		switch (dev_subid) {
 		case PCI_SUBSYSTEM_ID_LP11000S:
 			model_str = "LP11002-S 4Gb PCI-X2";
