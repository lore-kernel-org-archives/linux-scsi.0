From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 2/9] lpfc 8.1.3: PCI hrd_type should be obtained with pci_read_config_byte() macro
Date: Tue, 28 Feb 2006 22:33:05 -0500
Message-ID: <20060301033305.GA21493@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:50384 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S1750781AbWCADdH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 22:33:07 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k213X5Pb021500
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 22:33:05 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k213X5jK021498
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 22:33:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

PCI hrd_type should be obtained with pci_read_config_byte() macro

Driver keys off of this field to report the proper adapter type.
The pci subsystem explicitly clears the multiport bit in the copy of
the field given the driver. Thus, to properly name the card, obtain it
from config space.

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -796,9 +796,9 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 	lpfc_vpd_t *vp;
 	uint16_t dev_id = phba->pcidev->device;
 	uint16_t dev_subid = phba->pcidev->subsystem_device;
-	uint8_t hdrtype = phba->pcidev->hdr_type;
+	uint8_t hdrtype;
 	int max_speed;
-	char * ports = (hdrtype == 0x80) ? "2-port " : "";
+	char * ports;
 	struct {
 		char * name;
 		int    max_speed;
@@ -806,6 +806,8 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		char * bus;
 	} m;
 
+	pci_read_config_byte(phba->pcidev, PCI_HEADER_TYPE, &hdrtype);
+	ports = (hdrtype == 0x80) ? "2-port " : "";
 	if (mdp && mdp[0] != '\0'
 		&& descp && descp[0] != '\0')
 		return;
