From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 03/22] qla2xxx: Move session delete to driver work queue
Date: Wed, 29 Nov 2017 19:40:28 -0800
Message-ID: <20171130034047.15070-4-himanshu.madhani@cavium.com>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0056.outbound.protection.outlook.com ([104.47.36.56]:19653
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753066AbdK3Dk7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 22:40:59 -0500
In-Reply-To: <20171130034047.15070-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Move session delete from system work queue to driver's
work queue for in time processing.

Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c     | 3 ++-
 drivers/scsi/qla2xxx/qla_target.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 46f2d0cf7c0d..dfbf82e716b0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3193,10 +3193,11 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    host->can_queue, base_vha->req,
 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 
+	ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 0);
+
 	if (ha->mqenable) {
 		bool mq = false;
 		bool startit = false;
-		ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 0);
 
 		if (QLA_TGT_MODE_ENABLED()) {
 			mq = true;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1259ec85ec0a..924d58f5408f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1205,7 +1205,8 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess,
 	ql_dbg(ql_dbg_tgt, sess->vha, 0xe001,
 	    "Scheduling sess %p for deletion\n", sess);
 
-	schedule_work(&sess->del_work);
+	INIT_WORK(&sess->del_work, qla24xx_delete_sess_fn);
+	queue_work(sess->vha->hw->wq, &sess->del_work);
 }
 
 void qlt_schedule_sess_for_deletion_lock(struct fc_port *sess)
-- 
2.12.0
