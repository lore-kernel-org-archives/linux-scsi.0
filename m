From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESUBMIT 15/23] qla2xxx: Avoid poisoning in the response queue for ISPFX00.
Date: Wed, 26 Feb 2014 04:15:10 -0500
Message-ID: <1393406118-6586-16-git-send-email-saurav.kashyap@qlogic.com>
References: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:53723 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177AbaBZJuu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Feb 2014 04:50:50 -0500
In-Reply-To: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 03e2050..290322f 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2821,16 +2821,22 @@ qlafx00_process_response_queue(struct scsi_qla_host *vha,
 {
 	struct sts_entry_fx00 *pkt;
 	response_t *lptr;
+	uint16_t lreq_q_in = 0;
+	uint16_t lreq_q_out = 0;
 
-	while (RD_REG_DWORD((void __iomem *)&(rsp->ring_ptr->signature)) !=
-	    RESPONSE_PROCESSED) {
+	lreq_q_in = RD_REG_DWORD(rsp->rsp_q_in);
+	lreq_q_out = RD_REG_DWORD(rsp->rsp_q_out);
+
+	while (lreq_q_in != lreq_q_out) {
 		lptr = rsp->ring_ptr;
 		memcpy_fromio(rsp->rsp_pkt, (void __iomem *)lptr,
 		    sizeof(rsp->rsp_pkt));
 		pkt = (struct sts_entry_fx00 *)rsp->rsp_pkt;
 
 		rsp->ring_index++;
+		lreq_q_out++;
 		if (rsp->ring_index == rsp->length) {
+			lreq_q_out = 0;
 			rsp->ring_index = 0;
 			rsp->ring_ptr = rsp->ring;
 		} else {
@@ -2842,7 +2848,6 @@ qlafx00_process_response_queue(struct scsi_qla_host *vha,
 			qlafx00_error_entry(vha, rsp,
 			    (struct sts_entry_fx00 *)pkt, pkt->entry_status,
 			    pkt->entry_type);
-			goto next_iter;
 			continue;
 		}
 
@@ -2876,10 +2881,6 @@ qlafx00_process_response_queue(struct scsi_qla_host *vha,
 			    pkt->entry_type, pkt->entry_status);
 			break;
 		}
-next_iter:
-		WRT_REG_DWORD((void __iomem *)&lptr->signature,
-		    RESPONSE_PROCESSED);
-		wmb();
 	}
 
 	/* Adjust ring index */
-- 
1.7.7

