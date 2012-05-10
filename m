From: James Smart <james.smart@emulex.com>
Subject: [PATCH 01/20] lpfc 8.3.31: Fix bug with driver unload leaving a
 scsi host for a vport around
Date: Wed, 9 May 2012 21:16:03 -0400
Message-ID: <1336612572.1996.30.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27863 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751648Ab2EJBQX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:16:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix bug with driver unload leaving a scsi host for a vport around.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-05-06 13:15:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-05-07 10:00:48.000000000 -0400
@@ -8694,8 +8694,11 @@ lpfc_pci_remove_one_s3(struct pci_dev *p
 	/* Release all the vports against this physical port */
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for (i = 1; i <= phba->max_vports && vports[i] != NULL; i++)
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
+			if (vports[i]->port_type == LPFC_PHYSICAL_PORT)
+				continue;
 			fc_vport_terminate(vports[i]->fc_vport);
+		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
 	/* Remove FC host and then SCSI host with the physical port */
@@ -9455,8 +9458,11 @@ lpfc_pci_remove_one_s4(struct pci_dev *p
 	/* Release all the vports against this physical port */
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for (i = 1; i <= phba->max_vports && vports[i] != NULL; i++)
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
+			if (vports[i]->port_type == LPFC_PHYSICAL_PORT)
+				continue;
 			fc_vport_terminate(vports[i]->fc_vport);
+		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
 	/* Remove FC host and then SCSI host with the physical port */



