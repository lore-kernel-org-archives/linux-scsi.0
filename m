From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/8] lpfc 8.3.45: Added dport mailbox pass through support.
Date: Thu, 20 Feb 2014 09:56:28 -0500
Message-ID: <1392908188.31081.13.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:16701 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbaBTO4a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 09:56:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Added dport mailbox pass through support.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |    3 +++
 lpfc_bsg.h |    2 ++
 2 files changed, 5 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2014-02-12 10:40:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2014-02-19 15:29:25.278023648 -0500
@@ -4153,6 +4153,7 @@ lpfc_bsg_handle_sli_cfg_mbox(struct lpfc
 		if (subsys == SLI_CONFIG_SUBSYS_FCOE) {
 			switch (opcode) {
 			case FCOE_OPCODE_READ_FCF:
+			case FCOE_OPCODE_GET_DPORT_RESULTS:
 				lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 						"2957 Handled SLI_CONFIG "
 						"subsys_fcoe, opcode:x%x\n",
@@ -4161,6 +4162,8 @@ lpfc_bsg_handle_sli_cfg_mbox(struct lpfc
 							nemb_mse, dmabuf);
 				break;
 			case FCOE_OPCODE_ADD_FCF:
+			case FCOE_OPCODE_SET_DPORT_MODE:
+			case LPFC_MBOX_OPCODE_FCOE_LINK_DIAG_STATE:
 				lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 						"2958 Handled SLI_CONFIG "
 						"subsys_fcoe, opcode:x%x\n",
diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
--- a/drivers/scsi/lpfc/lpfc_bsg.h	2014-02-11 16:07:17.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.h	2014-02-19 15:29:25.282023648 -0500
@@ -231,6 +231,8 @@ struct lpfc_sli_config_emb0_subsys {
 #define SLI_CONFIG_SUBSYS_FCOE		0x0C
 #define FCOE_OPCODE_READ_FCF		0x08
 #define FCOE_OPCODE_ADD_FCF		0x09
+#define FCOE_OPCODE_SET_DPORT_MODE	0x27
+#define FCOE_OPCODE_GET_DPORT_RESULTS	0x28
 };
 
 struct lpfc_sli_config_emb1_subsys {



