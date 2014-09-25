From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 07/17] qla2xxx: Add counter for message
Date: Thu, 25 Sep 2014 06:14:49 -0400
Message-ID: <1411640099-7856-8-git-send-email-saurav.kashyap@qlogic.com>
References: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 85587fc..1a546bc 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1434,10 +1434,11 @@ static inline void qlt_unmap_sg(struct scsi_qla_host *vha,
 static int qlt_check_reserve_free_req(struct scsi_qla_host *vha,
 	uint32_t req_cnt)
 {
-	uint32_t cnt;
+	uint32_t cnt, cnt_in;
 
 	if (vha->req->cnt < (req_cnt + 2)) {
 		cnt = (uint16_t)RD_REG_DWORD(vha->req->req_q_out);
+		cnt_in = (uint16_t)RD_REG_DWORD(vha->req->req_q_in);
 
 		if  (vha->req->ring_index < cnt)
 			vha->req->cnt = cnt - vha->req->ring_index;
@@ -1448,10 +1449,9 @@ static int qlt_check_reserve_free_req(struct scsi_qla_host *vha,
 
 	if (unlikely(vha->req->cnt < (req_cnt + 2))) {
 		ql_dbg(ql_dbg_io, vha, 0x305a,
-		    "qla_target(%d): There is no room in the "
-		    "request ring: vha->req->ring_index=%d, vha->req->cnt=%d, "
-		    "req_cnt=%d\n", vha->vp_idx, vha->req->ring_index,
-		    vha->req->cnt, req_cnt);
+		    "qla_target(%d): There is no room in the request ring: vha->req->ring_index=%d, vha->req->cnt=%d, req_cnt=%d Req-out=%d Req-in=%d Req-Length=%d\n",
+		    vha->vp_idx, vha->req->ring_index,
+		    vha->req->cnt, req_cnt, cnt, cnt_in, vha->req->length);
 		return -EAGAIN;
 	}
 	vha->req->cnt -= req_cnt;
-- 
1.7.7
