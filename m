From: James Smart <james.smart@emulex.com>
Subject: [PATCH 04/21] lpfc 8.3.33: Fix error of not reiniting mbx cmd
 before reissue
Date: Fri, 3 Aug 2012 12:34:29 -0400
Message-ID: <1344011669.6110.29.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:40308 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2HCQef (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:34:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix error of not reiniting mbx cmd before reissue


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-07-22 11:35:19.830631891 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-07-22 11:35:20.235631877 -0400
@@ -7595,10 +7595,11 @@ lpfc_sli4_send_nop_mbox_cmds(struct lpfc
 	/* Set up NOP SLI4_CONFIG mailbox-ioctl command */
 	length = (sizeof(struct lpfc_mbx_nop) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
-	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
-			 LPFC_MBOX_OPCODE_NOP, length, LPFC_SLI4_MBX_EMBED);
 
 	for (cmdsent = 0; cmdsent < cnt; cmdsent++) {
+		lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
+				 LPFC_MBOX_OPCODE_NOP, length,
+				 LPFC_SLI4_MBX_EMBED);
 		if (!phba->sli4_hba.intr_enable)
 			rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
 		else {



