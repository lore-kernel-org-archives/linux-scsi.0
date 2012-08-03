From: James Smart <james.smart@emulex.com>
Subject: [PATCH 01/21] lpfc 8.3.33: When doing loopback testing, set the
 diag valid bit
Date: Fri, 3 Aug 2012 12:32:52 -0400
Message-ID: <1344011572.6110.25.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:40281 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab2HCQc6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:32:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When doing loopback testing, set the diag valid bit


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |    2 ++
 lpfc_hw4.h |    5 +++++
 2 files changed, 7 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2012-07-22 10:46:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2012-07-22 13:49:24.562352455 -0400
@@ -1714,6 +1714,8 @@ lpfc_sli4_bsg_set_link_diag_state(struct
 			phba->sli4_hba.lnk_info.lnk_no);
 
 	link_diag_state = &pmboxq->u.mqe.un.link_diag_state;
+	bf_set(lpfc_mbx_set_diag_state_diag_bit_valid, &link_diag_state->u.req,
+	       LPFC_DIAG_STATE_DIAG_BIT_VALID_CHANGE);
 	bf_set(lpfc_mbx_set_diag_state_link_num, &link_diag_state->u.req,
 	       phba->sli4_hba.lnk_info.lnk_no);
 	bf_set(lpfc_mbx_set_diag_state_link_type, &link_diag_state->u.req,
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2012-07-22 11:18:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2012-07-22 13:49:24.564352455 -0400
@@ -1382,6 +1382,11 @@ struct lpfc_mbx_set_link_diag_state {
 #define lpfc_mbx_set_diag_state_diag_SHIFT	0
 #define lpfc_mbx_set_diag_state_diag_MASK	0x00000001
 #define lpfc_mbx_set_diag_state_diag_WORD	word0
+#define lpfc_mbx_set_diag_state_diag_bit_valid_SHIFT	2
+#define lpfc_mbx_set_diag_state_diag_bit_valid_MASK	0x00000001
+#define lpfc_mbx_set_diag_state_diag_bit_valid_WORD	word0
+#define LPFC_DIAG_STATE_DIAG_BIT_VALID_NO_CHANGE	0
+#define LPFC_DIAG_STATE_DIAG_BIT_VALID_CHANGE		1
 #define lpfc_mbx_set_diag_state_link_num_SHIFT	16
 #define lpfc_mbx_set_diag_state_link_num_MASK	0x0000003F
 #define lpfc_mbx_set_diag_state_link_num_WORD	word0



