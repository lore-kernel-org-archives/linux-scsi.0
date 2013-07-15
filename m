From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/13] lpfc 8.3.41: Ensure driver properly zeros unused
 fields in SLI4 mailbox commands
Date: Mon, 15 Jul 2013 18:33:04 -0400
Message-ID: <1373927584.15647.22.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:4535 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156Ab3GOWdH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 18:33:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Ensure driver properly zeros unused fields in SLI4 mailbox commands


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_mbox.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2013-07-15 06:56:23.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2013-07-15 07:15:19.437055870 -0400
@@ -178,7 +178,8 @@ lpfc_dump_wakeup_param(struct lpfc_hba *
 	mb->mbxOwner = OWN_HOST;
 	mb->un.varDmp.cv = 1;
 	mb->un.varDmp.type = DMP_NV_PARAMS;
-	mb->un.varDmp.entry_index = 0;
+	if (phba->sli_rev < LPFC_SLI_REV4)
+		mb->un.varDmp.entry_index = 0;
 	mb->un.varDmp.region_id = WAKE_UP_PARMS_REGION_ID;
 	mb->un.varDmp.word_cnt = WAKE_UP_PARMS_WORD_SIZE;
 	mb->un.varDmp.co = 0;
@@ -361,7 +362,7 @@ lpfc_config_link(struct lpfc_hba * phba,
 	/* NEW_FEATURE
 	 * SLI-2, Coalescing Response Feature.
 	 */
-	if (phba->cfg_cr_delay) {
+	if (phba->cfg_cr_delay && (phba->sli_rev < LPFC_SLI_REV4)) {
 		mb->un.varCfgLnk.cr = 1;
 		mb->un.varCfgLnk.ci = 1;
 		mb->un.varCfgLnk.cr_delay = phba->cfg_cr_delay;
@@ -377,7 +378,7 @@ lpfc_config_link(struct lpfc_hba * phba,
 	mb->un.varCfgLnk.crtov = phba->fc_crtov;
 	mb->un.varCfgLnk.citov = phba->fc_citov;
 
-	if (phba->cfg_ack0)
+	if (phba->cfg_ack0 && (phba->sli_rev < LPFC_SLI_REV4))
 		mb->un.varCfgLnk.ack0_enable = 1;
 
 	mb->mbxCommand = MBX_CONFIG_LINK;




