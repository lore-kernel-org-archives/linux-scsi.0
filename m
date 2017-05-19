From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 24/25] qla2xxx: Remove extra register read
Date: Fri, 19 May 2017 14:53:43 -0700
Message-ID: <20170519215344.2168-25-himanshu.madhani@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0084.outbound.protection.outlook.com ([104.47.34.84]:61024
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753205AbdESWab (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 18:30:31 -0400
In-Reply-To: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Register read is expensive in IO path, remove extra register
read in each interrupt processing to improve performance.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c   |  4 +++-
 drivers/scsi/qla2xxx/qla_target.c | 11 ++---------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index ea027f6a7fd4..8404f17f3c6c 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -464,7 +464,9 @@ qla2x00_start_iocbs(struct scsi_qla_host *vha, struct req_que *req)
 			req->ring_ptr++;
 
 		/* Set chip new ring index. */
-		if (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
+		if (ha->mqenable || IS_QLA27XX(ha)) {
+			WRT_REG_DWORD(req->req_q_in, req->ring_index);
+		} else if (IS_QLA83XX(ha)) {
 			WRT_REG_DWORD(req->req_q_in, req->ring_index);
 			RD_REG_DWORD_RELAXED(&ha->iobase->isp24.hccr);
 		} else if (IS_QLAFX00(ha)) {
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 95aad9c329d7..f42313e49443 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2223,11 +2223,10 @@ static void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 static int qlt_check_reserve_free_req(struct scsi_qla_host *vha,
 	uint32_t req_cnt)
 {
-	uint32_t cnt, cnt_in;
+	uint32_t cnt;
 
 	if (vha->req->cnt < (req_cnt + 2)) {
 		cnt = (uint16_t)RD_REG_DWORD(vha->req->req_q_out);
-		cnt_in = (uint16_t)RD_REG_DWORD(vha->req->req_q_in);
 
 		if  (vha->req->ring_index < cnt)
 			vha->req->cnt = cnt - vha->req->ring_index;
@@ -2235,14 +2234,8 @@ static int qlt_check_reserve_free_req(struct scsi_qla_host *vha,
 			vha->req->cnt = vha->req->length -
 			    (vha->req->ring_index - cnt);
 
-		if (unlikely(vha->req->cnt < (req_cnt + 2))) {
-			ql_dbg(ql_dbg_io, vha, 0x305a,
-			    "qla_target(%d): There is no room in the request ring: vha->req->ring_index=%d, vha->req->cnt=%d, req_cnt=%d Req-out=%d Req-in=%d Req-Length=%d\n",
-			    vha->vp_idx, vha->req->ring_index,
-			    vha->req->cnt, req_cnt, cnt, cnt_in,
-			    vha->req->length);
+		if (unlikely(vha->req->cnt < (req_cnt + 2)))
 			return -EAGAIN;
-		}
 	}
 
 	vha->req->cnt -= req_cnt;
-- 
2.12.0
