From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/9] lpfc 8.1.3 : PCI hrd_type should be obtained with pci_read_config_byte()
 macro
Date: Wed, 22 Feb 2006 12:33:24 -0500
Message-ID: <43FCA064.9020402@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51929 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030320AbWBVRdc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 12:33:32 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k1MHXQrf029887
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 09:33:27 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


PCI hrd_type should be obtained with pci_read_config_byte() macro

Driver keys off of this field to report the proper adapter type.
The pci subsystem explicitly clears the multiport bit in the copy of
the field given the driver. Thus, to properly name the card, obtain it
from config space.

Signed-off-by: James Smart <James.Smart@emulex.com>

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

