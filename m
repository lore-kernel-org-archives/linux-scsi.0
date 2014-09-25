From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 04/17] qla2xxx: Increase room in request queue for sending priority packets
Date: Thu, 25 Sep 2014 06:14:46 -0400
Message-ID: <1411640099-7856-5-git-send-email-saurav.kashyap@qlogic.com>
References: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com
List-Id: linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@qlogic.com>

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 6a6867d..c787847 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1901,7 +1901,7 @@ qla2x00_alloc_iocbs(scsi_qla_host_t *vha, srb_t *sp)
 
 skip_cmd_array:
 	/* Check for room on request queue. */
-	if (req->cnt < req_cnt) {
+	if (req->cnt < req_cnt + 2) {
 		if (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha))
 			cnt = RD_REG_DWORD(&reg->isp25mq.req_q_out);
 		else if (IS_P3P_TYPE(ha))
@@ -1920,7 +1920,7 @@ skip_cmd_array:
 			req->cnt = req->length -
 			    (req->ring_index - cnt);
 	}
-	if (req->cnt < req_cnt)
+	if (req->cnt < req_cnt + 2)
 		goto queuing_error;
 
 	/* Prep packet */
-- 
1.7.7
