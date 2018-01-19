From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 4/5] qla2xxx: Restore ZIO threshold setting
Date: Fri, 19 Jan 2018 12:29:27 -0800
Message-ID: <20180119202928.13239-5-himanshu.madhani@cavium.com>
References: <20180119202928.13239-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0049.outbound.protection.outlook.com ([104.47.38.49]:7344
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932231AbeASU3r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jan 2018 15:29:47 -0500
In-Reply-To: <20180119202928.13239-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, hch@lst.de, sagi@grimberg.me, james.smart@broadcom.com, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Darren Trapp <darren.trapp@cavium.com>

Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index a8e81fc14c44..5ee447680ddd 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -464,11 +464,6 @@ static int qla2x00_start_nvme_mq(srb_t *sp)
 	/* Set chip new ring index. */
 	WRT_REG_DWORD(req->req_q_in, req->ring_index);
 
-	/* Manage unprocessed RIO/ZIO commands in response queue. */
-	if (vha->flags.process_response_queue &&
-	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
-		qla24xx_process_response_queue(vha, rsp);
-
 queuing_error:
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 	return rval;
-- 
2.12.0
