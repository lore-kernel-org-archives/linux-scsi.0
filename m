From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 10/37] qla2xxx: Use shadow register for ISP27XX
Date: Thu, 28 Dec 2017 12:33:18 -0800
Message-ID: <20171228203345.2702-11-himanshu.madhani@cavium.com>
References: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0047.outbound.protection.outlook.com ([104.47.36.47]:15520
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754537AbdL1UeD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Dec 2017 15:34:03 -0500
In-Reply-To: <20171228203345.2702-1-himanshu.madhani@cavium.com>
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
index 2d523b71cc1f..d1dfa784d895 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2158,7 +2158,9 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
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
