From: James Smart <james.smart@emulex.com>
Subject: [PATCH 03/21] lpfc: EnableBootCode from hbacmd fails on Lancer
Date: Thu, 5 Feb 2015 14:23:21 -0500
Message-ID: <1423164201.7917.27.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:47563 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbbBETXz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 14:23:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


---
 drivers/scsi/lpfc/lpfc_bsg.c | 1 +
 drivers/scsi/lpfc/lpfc_bsg.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index a7bf359..6b4cf31 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -4179,6 +4179,7 @@ lpfc_bsg_handle_sli_cfg_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
 			switch (opcode) {
 			case COMN_OPCODE_GET_CNTL_ADDL_ATTRIBUTES:
 			case COMN_OPCODE_GET_CNTL_ATTRIBUTES:
+			case COMN_OPCODE_GET_PROFILE_CONFIG:
 				lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 						"3106 Handled SLI_CONFIG "
 						"subsys_comn, opcode:x%x\n",
diff --git a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
index 928ef60..7f26a9b 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.h
+++ b/drivers/scsi/lpfc/lpfc_bsg.h
@@ -246,6 +246,7 @@ struct lpfc_sli_config_emb1_subsys {
 #define lpfc_emb1_subcmnd_subsys_WORD	word6
 /* Subsystem COMN (0x01) OpCodes */
 #define SLI_CONFIG_SUBSYS_COMN		0x01
+#define COMN_OPCODE_GET_PROFILE_CONFIG	0xA4
 #define COMN_OPCODE_READ_OBJECT		0xAB
 #define COMN_OPCODE_WRITE_OBJECT	0xAC
 #define COMN_OPCODE_READ_OBJECT_LIST	0xAD
-- 
1.7.11.7

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>



