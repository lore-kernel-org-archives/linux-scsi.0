From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 20/22] qla2xxx: Fix system crash in qlt_plogi_ack_unref
Date: Tue, 28 Nov 2017 11:35:01 -0800
Message-ID: <20171128193503.13695-21-himanshu.madhani@cavium.com>
References: <20171128193503.13695-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0084.outbound.protection.outlook.com ([104.47.42.84]:60709
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932171AbdK1Tfi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Nov 2017 14:35:38 -0500
In-Reply-To: <20171128193503.13695-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Fix system crash due to NULL pointer access.

qlt_plogi_ack_t and fc_port structures were not properly
bound before calling qlt_plogi_ack_unref().

RIP: 0010:qlt_plogi_ack_unref+0xa1/0x150 [qla2xxx]
Call Trace:
qla24xx_create_new_sess+0xb1/0x320 [qla2xxx]
qla2x00_do_work+0x123/0x260 [qla2xxx]
qla2x00_iocb_work_fn+0x30/0x40 [qla2xxx]
process_one_work+0x1f3/0x530
worker_thread+0x4e/0x480
kthread+0x10c/0x140

Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2ec77b9f78b8..789030c9dd26 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4750,11 +4750,11 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 		} else {
 			list_add_tail(&fcport->list, &vha->vp_fcports);
 
-			if (pla) {
-				qlt_plogi_ack_link(vha, pla, fcport,
-				    QLT_PLOGI_LINK_SAME_WWN);
-				pla->ref_count--;
-			}
+		}
+		if (pla) {
+			qlt_plogi_ack_link(vha, pla, fcport,
+			    QLT_PLOGI_LINK_SAME_WWN);
+			pla->ref_count--;
 		}
 	}
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
-- 
2.12.0
