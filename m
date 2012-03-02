From: James Smart <james.smart@emulex.com>
Subject: [PATCH 03/21] lpfc 8.3.30: Fix port and system failure in SLI4 FC
 function reset
Date: Thu, 1 Mar 2012 22:34:19 -0500
Message-ID: <1330659262.18500.30.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38849 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752690Ab2CBDem (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:34:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed port and system failure in handling SLI4 FC port function reset


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |    6 +++++-
 lpfc_sli.c  |    2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-02-27 23:35:05.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-03-01 17:33:36.000000000 -0500
@@ -2786,9 +2786,13 @@ lpfc_scsi_buf_update(struct lpfc_hba *ph
 
 	spin_lock_irq(&phba->hbalock);
 	spin_lock(&phba->scsi_buf_list_lock);
-	list_for_each_entry_safe(sb, sb_next, &phba->lpfc_scsi_buf_list, list)
+	list_for_each_entry_safe(sb, sb_next, &phba->lpfc_scsi_buf_list, list) {
 		sb->cur_iocbq.sli4_xritag =
 			phba->sli4_hba.xri_ids[sb->cur_iocbq.sli4_lxritag];
+		set_bit(sb->cur_iocbq.sli4_lxritag, phba->sli4_hba.xri_bmask);
+		phba->sli4_hba.max_cfg_param.xri_used++;
+		phba->sli4_hba.xri_count++;
+	}
 	spin_unlock(&phba->scsi_buf_list_lock);
 	spin_unlock_irq(&phba->hbalock);
 	return 0;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:35.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:36.000000000 -0500
@@ -5613,6 +5613,8 @@ lpfc_sli4_alloc_resource_identifiers(str
 			rc = -ENOMEM;
 			goto free_vpi_ids;
 		}
+		phba->sli4_hba.max_cfg_param.xri_used = 0;
+		phba->sli4_hba.xri_count = 0;
 		phba->sli4_hba.xri_ids = kzalloc(count *
 						 sizeof(uint16_t),
 						 GFP_KERNEL);



