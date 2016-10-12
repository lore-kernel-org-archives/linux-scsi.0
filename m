From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 05/17 v2] lpfc: Make lpfc_prot_xxx params per hba
 parameters
Date: Wed, 12 Oct 2016 13:14:08 -0700
Message-ID: <57fe9990.25qwuBlXi+1mWUZs%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([199.3.246.86]:59039 "EHLO
        sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755988AbcJLUOk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2016 16:14:40 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp2.avagotech.com (Postfix) with SMTP id B5E47120992
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 13:14:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Make lpfc_prot_mask and lpfc_prot_guard per hba parameters

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc.h      |  2 ++
 drivers/scsi/lpfc/lpfc_attr.c | 23 ++++++++++++++---------
 drivers/scsi/lpfc/lpfc_crtn.h |  2 --
 drivers/scsi/lpfc/lpfc_init.c | 28 +++++++++++++++-------------
 4 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index b484859..debba5e 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -746,6 +746,8 @@ struct lpfc_hba {
 	uint32_t cfg_oas_priority;
 	uint32_t cfg_XLanePriority;
 	uint32_t cfg_enable_bg;
+	uint32_t cfg_prot_mask;
+	uint32_t cfg_prot_guard;
 	uint32_t cfg_hostmem_hgp;
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_aer_support;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f101990..be81e61 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4691,12 +4691,15 @@ unsigned int lpfc_fcp_look_ahead = LPFC_LOOK_AHEAD_OFF;
 #		HBA supports DIX Type 1: Host to HBA  Type 1 protection
 #
 */
-unsigned int lpfc_prot_mask = SHOST_DIF_TYPE1_PROTECTION |
-			      SHOST_DIX_TYPE0_PROTECTION |
-			      SHOST_DIX_TYPE1_PROTECTION;
-
-module_param(lpfc_prot_mask, uint, S_IRUGO);
-MODULE_PARM_DESC(lpfc_prot_mask, "host protection mask");
+LPFC_ATTR(prot_mask,
+	(SHOST_DIF_TYPE1_PROTECTION |
+	SHOST_DIX_TYPE0_PROTECTION |
+	SHOST_DIX_TYPE1_PROTECTION),
+	0,
+	(SHOST_DIF_TYPE1_PROTECTION |
+	SHOST_DIX_TYPE0_PROTECTION |
+	SHOST_DIX_TYPE1_PROTECTION),
+	"T10-DIF host protection capabilities mask");
 
 /*
 # lpfc_prot_guard: i
@@ -4706,9 +4709,9 @@ MODULE_PARM_DESC(lpfc_prot_mask, "host protection mask");
 #	- Default will result in registering capabilities for all guard types
 #
 */
-unsigned char lpfc_prot_guard = SHOST_DIX_GUARD_IP;
-module_param(lpfc_prot_guard, byte, S_IRUGO);
-MODULE_PARM_DESC(lpfc_prot_guard, "host protection guard type");
+LPFC_ATTR(prot_guard,
+	SHOST_DIX_GUARD_IP, SHOST_DIX_GUARD_CRC, SHOST_DIX_GUARD_IP,
+	"T10-DIF host protection guard type");
 
 /*
  * Delay initial NPort discovery when Clean Address bit is cleared in
@@ -5828,6 +5831,8 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	phba->cfg_oas_flags = 0;
 	phba->cfg_oas_priority = 0;
 	lpfc_enable_bg_init(phba, lpfc_enable_bg);
+	lpfc_prot_mask_init(phba, lpfc_prot_mask);
+	lpfc_prot_guard_init(phba, lpfc_prot_guard);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		phba->cfg_poll = 0;
 	else
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index bd7576d..16195b7 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -397,8 +397,6 @@ extern spinlock_t _dump_buf_lock;
 extern int _dump_buf_done;
 extern spinlock_t pgcnt_lock;
 extern unsigned int pgcnt;
-extern unsigned int lpfc_prot_mask;
-extern unsigned char lpfc_prot_guard;
 extern unsigned int lpfc_fcp_look_ahead;
 
 /* Interface exported by fabric iocb scheduler */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index af64d70..117c69a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6279,34 +6279,36 @@ lpfc_setup_bg(struct lpfc_hba *phba, struct Scsi_Host *shost)
 	uint32_t old_guard;
 
 	int pagecnt = 10;
-	if (lpfc_prot_mask && lpfc_prot_guard) {
+	if (phba->cfg_prot_mask && phba->cfg_prot_guard) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"1478 Registering BlockGuard with the "
 				"SCSI layer\n");
 
-		old_mask = lpfc_prot_mask;
-		old_guard = lpfc_prot_guard;
+		old_mask = phba->cfg_prot_mask;
+		old_guard = phba->cfg_prot_guard;
 
 		/* Only allow supported values */
-		lpfc_prot_mask &= (SHOST_DIF_TYPE1_PROTECTION |
+		phba->cfg_prot_mask &= (SHOST_DIF_TYPE1_PROTECTION |
 			SHOST_DIX_TYPE0_PROTECTION |
 			SHOST_DIX_TYPE1_PROTECTION);
-		lpfc_prot_guard &= (SHOST_DIX_GUARD_IP | SHOST_DIX_GUARD_CRC);
+		phba->cfg_prot_guard &= (SHOST_DIX_GUARD_IP |
+					 SHOST_DIX_GUARD_CRC);
 
 		/* DIF Type 1 protection for profiles AST1/C1 is end to end */
-		if (lpfc_prot_mask == SHOST_DIX_TYPE1_PROTECTION)
-			lpfc_prot_mask |= SHOST_DIF_TYPE1_PROTECTION;
+		if (phba->cfg_prot_mask == SHOST_DIX_TYPE1_PROTECTION)
+			phba->cfg_prot_mask |= SHOST_DIF_TYPE1_PROTECTION;
 
-		if (lpfc_prot_mask && lpfc_prot_guard) {
-			if ((old_mask != lpfc_prot_mask) ||
-				(old_guard != lpfc_prot_guard))
+		if (phba->cfg_prot_mask && phba->cfg_prot_guard) {
+			if ((old_mask != phba->cfg_prot_mask) ||
+				(old_guard != phba->cfg_prot_guard))
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"1475 Registering BlockGuard with the "
 					"SCSI layer: mask %d  guard %d\n",
-					lpfc_prot_mask, lpfc_prot_guard);
+					phba->cfg_prot_mask,
+					phba->cfg_prot_guard);
 
-			scsi_host_set_prot(shost, lpfc_prot_mask);
-			scsi_host_set_guard(shost, lpfc_prot_guard);
+			scsi_host_set_prot(shost, phba->cfg_prot_mask);
+			scsi_host_set_guard(shost, phba->cfg_prot_guard);
 		} else
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1479 Not Registering BlockGuard with the SCSI "
-- 
2.5.0


