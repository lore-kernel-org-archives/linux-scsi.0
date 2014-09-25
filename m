From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 07/19] qla2xxx: Add counter for message
Date: Thu, 25 Sep 2014 04:10:00 -0400
Message-ID: <1411632612-7320-8-git-send-email-saurav.kashyap@qlogic.com>
References: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:10066 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbaIYIoN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 04:44:13 -0400
In-Reply-To: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2d4003f..4989bf7 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1429,10 +1429,11 @@ static inline void qlt_unmap_sg(struct scsi_qla_host *vha,
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
@@ -1443,10 +1444,9 @@ static int qlt_check_reserve_free_req(struct scsi_qla_host *vha,
 
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

