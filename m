From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 13/43] qla2xxx: Use shadow register for ISP27XX
Date: Tue, 19 Dec 2017 22:56:14 -0800
Message-ID: <20171220065644.21511-14-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0059.outbound.protection.outlook.com ([104.47.36.59]:62584
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932424AbdLTG5M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:12 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

For ISP27XX, use shadow register to read FW provided REQQ's consumer
index. The shadow register is dma'ed by firmware.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 417c40f21244..519a0d2920b8 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2192,7 +2192,9 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 skip_cmd_array:
 	/* Check for room on request queue. */
 	if (req->cnt < req_cnt + 2) {
-		if (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha))
+		if (qpair->use_shadow_reg)
+			cnt = *req->out_ptr;
+		else if (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha))
 			cnt = RD_REG_DWORD(&reg->isp25mq.req_q_out);
 		else if (IS_P3P_TYPE(ha))
 			cnt = RD_REG_DWORD(&reg->isp82.req_q_out);
-- 
2.12.0
