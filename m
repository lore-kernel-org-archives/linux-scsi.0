From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 1/6] qla2xxx: Fix a locking imbalance in qlt_24xx_handle_els()
Date: Tue, 23 Jan 2018 16:33:46 -0800
Message-ID: <20180124003351.2616-2-bart.vanassche@wdc.com>
References: <20180124003351.2616-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51749 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752692AbeAXAdw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2018 19:33:52 -0500
In-Reply-To: <20180124003351.2616-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Quinn Tran <quinn.tran@cavium.com>

Ensure that upon return the tgt->ha->tgt.sess_lock spin lock is
unlocked no matter which code path is taken through this function.
This was detected by sparse.

Fixes: 82abdcaf3ede ("scsi: qla2xxx: Allow target mode to accept PRLI in dual mode")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: Quinn Tran <quinn.tran@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index fc89af8fe256..896b2d8bd803 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4871,8 +4871,6 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 				    sess);
 				qlt_send_term_imm_notif(vha, iocb, 1);
 				res = 0;
-				spin_lock_irqsave(&tgt->ha->tgt.sess_lock,
-				    flags);
 				break;
 			}
 
-- 
2.15.1
