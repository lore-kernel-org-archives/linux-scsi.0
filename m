Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C959AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 05:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbiGMFVJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 01:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiGMFVA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 01:21:00 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266E0D5142
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:59 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D2Lj1V025309
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=TmHP1RTO15zDCV/zgx7RQkywPvI522V/rryh4aCh3nc=;
 b=YvrQqfF9JfGr335dovGKzh62WX82NUfxghB03S0FcXop9ekvLKYiDMbpD32AYCvxnXrw
 TsFkkWryqdALGg5HraWCoxXjcenIDcX8Q/nUywbAZiEJ6SUKVNPf0AzoL4vTWP6XSDW7
 XgRiAnwlZ3g8PGrIZEAnmO5Jl5J4rYmtyLMmqSteiu4GYWarQ6ugBTmTnGgCcWm5cvxs
 3aN4lC+CekEdTAo0u5S29jViUrzZgq7iL+b75pkCre7+Mn7Or7P0LyaCTEadBocxZP/r
 k32yjjDiQ51mpVnYrJFVIXS/0oFnQkzGSPnSq/MudsxhVzdHf0stWLAdn7JpHV5Fam19 Dg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h9n6n0f0h-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Jul
 2022 22:20:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Jul 2022 22:20:55 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2A7113F70B5;
        Tue, 12 Jul 2022 22:20:55 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 05/10] qla2xxx: edif: Fix dropped IKE message
Date:   Tue, 12 Jul 2022 22:20:40 -0700
Message-ID: <20220713052045.10683-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220713052045.10683-1-njavali@marvell.com>
References: <20220713052045.10683-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: felI3D6OWmqgF6CxM--6tCfj_GKYBtiU
X-Proofpoint-GUID: felI3D6OWmqgF6CxM--6tCfj_GKYBtiU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-12_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

This patch fixes IKE message being dropped due to error in processing
Purex IOCB and Continuation IOCBs.

Fixes: fac2807946c1 ("scsi: qla2xxx: edif: Add extraction of auth_els from the wire")
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 54 +++++++++++++++-------------------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 35b425c446b9..76e79f350a22 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3720,12 +3720,11 @@ void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
  * Return: 0 all iocbs has arrived, xx- all iocbs have not arrived.
  */
 static int qla_chk_cont_iocb_avail(struct scsi_qla_host *vha,
-	struct rsp_que *rsp, response_t *pkt)
+	struct rsp_que *rsp, response_t *pkt, u32 rsp_q_in)
 {
-	int start_pkt_ring_index, end_pkt_ring_index, n_ring_index;
-	response_t *end_pkt;
+	int start_pkt_ring_index;
+	u32 iocb_cnt = 0;
 	int rc = 0;
-	u32 rsp_q_in;
 
 	if (pkt->entry_count == 1)
 		return rc;
@@ -3736,34 +3735,18 @@ static int qla_chk_cont_iocb_avail(struct scsi_qla_host *vha,
 	else
 		start_pkt_ring_index = rsp->ring_index - 1;
 
-	if ((start_pkt_ring_index + pkt->entry_count) >= rsp->length)
-		end_pkt_ring_index = start_pkt_ring_index + pkt->entry_count -
-			rsp->length - 1;
+	if (rsp_q_in < start_pkt_ring_index)
+		/* q in ptr is wrapped */
+		iocb_cnt = rsp->length - start_pkt_ring_index + rsp_q_in;
 	else
-		end_pkt_ring_index = start_pkt_ring_index + pkt->entry_count - 1;
+		iocb_cnt = rsp_q_in - start_pkt_ring_index;
 
-	end_pkt = rsp->ring + end_pkt_ring_index;
-
-	/*  next pkt = end_pkt + 1 */
-	n_ring_index = end_pkt_ring_index + 1;
-	if (n_ring_index >= rsp->length)
-		n_ring_index = 0;
-
-	rsp_q_in = rsp->qpair->use_shadow_reg ? *rsp->in_ptr :
-		rd_reg_dword(rsp->rsp_q_in);
-
-	/* rsp_q_in is either wrapped or pointing beyond endpkt */
-	if ((rsp_q_in < start_pkt_ring_index && rsp_q_in < n_ring_index) ||
-			rsp_q_in >= n_ring_index)
-		/* all IOCBs arrived. */
-		rc = 0;
-	else
+	if (iocb_cnt < pkt->entry_count)
 		rc = -EIO;
 
-	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x5091,
-	    "%s - ring %p pkt %p end pkt %p entry count %#x rsp_q_in %d rc %d\n",
-	    __func__, rsp->ring, pkt, end_pkt, pkt->entry_count,
-	    rsp_q_in, rc);
+	ql_dbg(ql_dbg_init, vha, 0x5091,
+	       "%s - ring %p pkt %p entry count %d iocb_cnt %d rsp_q_in %d rc %d\n",
+	       __func__, rsp->ring, pkt, pkt->entry_count, iocb_cnt, rsp_q_in, rc);
 
 	return rc;
 }
@@ -3780,7 +3763,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
-	u16 rsp_in = 0;
+	u16 rsp_in = 0, cur_ring_index;
 	int follow_inptr, is_shadow_hba;
 
 	if (!ha->flags.fw_started)
@@ -3811,6 +3794,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		       (!follow_inptr &&
 			rsp->ring_ptr->signature != RESPONSE_PROCESSED)) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
+		cur_ring_index = rsp->ring_index;
 
 		rsp->ring_index++;
 		if (rsp->ring_index == rsp->length) {
@@ -3931,7 +3915,17 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				break;
 
 			case ELS_AUTH_ELS:
-				if (qla_chk_cont_iocb_avail(vha, rsp, (response_t *)pkt)) {
+				if (qla_chk_cont_iocb_avail(vha, rsp, (response_t *)pkt, rsp_in)) {
+					/*
+					 * ring_ptr and ring_index were
+					 * pre-incremented above. Reset them
+					 * back to current. Wait for next
+					 * interrupt with all IOCBs to arrive
+					 * and re-process.
+					 */
+					rsp->ring_ptr = (response_t *)pkt;
+					rsp->ring_index = cur_ring_index;
+
 					ql_dbg(ql_dbg_init, vha, 0x5091,
 					    "Defer processing ELS opcode %#x...\n",
 					    purex_entry->els_frame_payload[3]);
-- 
2.19.0.rc0

