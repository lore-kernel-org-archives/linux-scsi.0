From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 21/43] qla2xxx: Remove calling cancel_work_sync()
Date: Tue, 19 Dec 2017 22:56:22 -0800
Message-ID: <20171220065644.21511-22-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0048.outbound.protection.outlook.com ([104.47.40.48]:27088
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932388AbdLTG5P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:15 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@cavium.com>

This is blocking call and issue is seen, when called in interrupt context.

__cancel_work_timer+0x140/0x210
? ql_dbg+0xcb/0x110 [qla2xxx]
cancel_work_sync+0x10/0x20
qlt_schedule_sess_for_deletion+0x89/0x170 [qla2xxx]
qla24xx_handle_gpnid_event+0x146/0x4a0 [qla2xxx]
qla2x00_fcport_event_handler+0x14b/0x290 [qla2xxx]
qla2x00_async_gpnid_sp_done+0x118/0x240 [qla2xxx]
qla24xx_els_ct_entry.isra.15+0x1df/0x2b0 [qla2xxx]
? qla24xx_msix_rsp_q+0x39/0xf0 [qla2xxx]
qla24xx_process_response_queue+0xae/0x270 [qla2xxx]
qla24xx_msix_rsp_q+0x8a/0xf0 [qla2xxx]
__handle_irq_event_percpu+0x3c/0x350
handle_irq_event_percpu+0x32/0x80
handle_irq_event+0x39/0x60
handle_edge_irq+0x8c/0x140
handle_irq+0xab/0x130
? _local_bh_enable+0x21/0x50
do_IRQ+0x5e/0x120
common_interrupt+0x9d/0x9d
RIP: 0010:cpuidle_enter_state+0xe9/0x320

Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 71be1a95ba86..002fe05dd344 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1234,8 +1234,6 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess,
 	ql_dbg(ql_dbg_tgt, sess->vha, 0xe001,
 	    "Scheduling sess %p for deletion\n", sess);
 
-	/* use cancel to push work element through before re-queue */
-	cancel_work_sync(&sess->del_work);
 	INIT_WORK(&sess->del_work, qla24xx_delete_sess_fn);
 	queue_work(sess->vha->hw->wq, &sess->del_work);
 }
-- 
2.12.0
