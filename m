From: James Smart <james.smart@emulex.com>
Subject: [PATCH 05/21] lpfc 8.3.30: Fix RPI registered multiple times after
 HBA reset
Date: Thu, 1 Mar 2012 22:35:23 -0500
Message-ID: <1330659325.18500.32.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38853 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757328Ab2CBDfr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:35:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix RPI registered multiple times after HBA reset


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |    4 +---
 lpfc_sli.c  |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-03-01 17:33:36.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-03-01 17:33:39.000000000 -0500
@@ -5230,8 +5230,7 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba
 	 * rpi is normalized to a zero base because the physical rpi is
 	 * port based.
 	 */
-	curr_rpi_range = phba->sli4_hba.next_rpi -
-		phba->sli4_hba.max_cfg_param.rpi_base;
+	curr_rpi_range = phba->sli4_hba.next_rpi;
 	spin_unlock_irq(&phba->hbalock);
 
 	/*
@@ -6146,7 +6145,6 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 		phba->sli4_hba.next_xri = phba->sli4_hba.max_cfg_param.xri_base;
 		phba->vpi_base = phba->sli4_hba.max_cfg_param.vpi_base;
 		phba->vfi_base = phba->sli4_hba.max_cfg_param.vfi_base;
-		phba->sli4_hba.next_rpi = phba->sli4_hba.max_cfg_param.rpi_base;
 		phba->max_vpi = (phba->sli4_hba.max_cfg_param.max_vpi > 0) ?
 				(phba->sli4_hba.max_cfg_param.max_vpi - 1) : 0;
 		phba->max_vports = phba->max_vpi;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:39.000000000 -0500
@@ -5578,8 +5578,6 @@ lpfc_sli4_alloc_resource_identifiers(str
 		for (i = 0; i < count; i++)
 			phba->sli4_hba.rpi_ids[i] = base + i;
 
-		lpfc_sli4_node_prep(phba);
-
 		/* VPIs. */
 		count = phba->sli4_hba.max_cfg_param.max_vpi;
 		base = phba->sli4_hba.max_cfg_param.vpi_base;
@@ -6149,6 +6147,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 		rc = -ENODEV;
 		goto out_free_mbox;
 	}
+	lpfc_sli4_node_prep(phba);
 
 	/* Create all the SLI4 queues */
 	rc = lpfc_sli4_queue_create(phba);



