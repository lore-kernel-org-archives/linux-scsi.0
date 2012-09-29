From: James Smart <james.smart@emulex.com>
Subject: [PATCH 07/16] lpfc 8.3.35: Fix FCP2 Retries for non-r/w commands.
Date: Sat, 29 Sep 2012 11:30:31 -0400
Message-ID: <1348932631.23909.26.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:35013 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab2I2PgE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:36:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix FCP2 Retries for non-r/w commands.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |    2 ++
 1 file changed, 2 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-09-26 21:11:34.543153866 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-09-26 21:11:38.481153956 -0400
@@ -8109,6 +8109,8 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		bf_set(wqe_lenloc, &wqe->fcp_icmd.wqe_com,
 		       LPFC_WQE_LENLOC_NONE);
 		bf_set(wqe_ebde_cnt, &wqe->fcp_icmd.wqe_com, 0);
+		bf_set(wqe_erp, &wqe->fcp_icmd.wqe_com,
+		       iocbq->iocb.ulpFCP2Rcvy);
 		break;
 	case CMD_GEN_REQUEST64_CR:
 		/* For this command calculate the xmit length of the



