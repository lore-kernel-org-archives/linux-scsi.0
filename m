From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 08/35] qla2xxx: ISP25xx multiqueue shadow register crash fix.
Date: Wed, 24 Sep 2014 03:08:11 -0400
Message-ID: <1411542518-2477-9-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:22688 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715AbaIXHmn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:42:43 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

When creating request/response queues from qla25xx_setup_mode(),
the shadow index register pointers were not being initialized
to point at the registers.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mid.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 8999824..5c2e031 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -702,6 +702,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	req->req_q_in = &reg->isp25mq.req_q_in;
 	req->req_q_out = &reg->isp25mq.req_q_out;
 	req->max_q_depth = ha->req_q_map[0]->max_q_depth;
+	req->out_ptr = (void *)(req->ring + req->length);
 	mutex_unlock(&ha->vport_lock);
 	ql_dbg(ql_dbg_multiq, base_vha, 0xc004,
 	    "ring_ptr=%p ring_index=%d, "
@@ -811,6 +812,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	reg = ISP_QUE_REG(ha, que_id);
 	rsp->rsp_q_in = &reg->isp25mq.rsp_q_in;
 	rsp->rsp_q_out = &reg->isp25mq.rsp_q_out;
+	rsp->in_ptr = (void *)(rsp->ring + rsp->length);
 	mutex_unlock(&ha->vport_lock);
 	ql_dbg(ql_dbg_multiq, base_vha, 0xc00b,
 	    "options=%x id=%d rsp_q_in=%p rsp_q_out=%p",
-- 
1.7.7

