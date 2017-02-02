From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 03/15] qla2xxx: Allow vref count to timeout on vport delete.
Date: Thu, 2 Feb 2017 11:42:26 -0800
Message-ID: <1486064558-365-4-git-send-email-himanshu.madhani@cavium.com>
References: <1486064558-365-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0080.outbound.protection.outlook.com ([104.47.38.80]:26467
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751500AbdBBT7Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Feb 2017 14:59:16 -0500
In-Reply-To: <1486064558-365-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  4 +---
 drivers/scsi/qla2xxx/qla_mid.c  | 12 +++++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 5d450c0..091adab 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2147,8 +2147,6 @@ struct device_attribute *qla2x00_host_attrs[] = {
 		    "Timer for the VP[%d] has stopped\n", vha->vp_idx);
 	}
 
-	BUG_ON(atomic_read(&vha->vref_count));
-
 	qla2x00_free_fcports(vha);
 
 	mutex_lock(&ha->vport_lock);
@@ -2159,7 +2157,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	dma_free_coherent(&ha->pdev->dev, vha->gnl.size, vha->gnl.l,
 	    vha->gnl.ldma);
 
-	if (vha->qpair->vp_idx == vha->vp_idx) {
+	if (vha->qpair && vha->qpair->vp_idx == vha->vp_idx) {
 		if (qla2xxx_delete_qpair(vha, vha->qpair) != QLA_SUCCESS)
 			ql_log(ql_log_warn, vha, 0x7087,
 			    "Queue Pair delete failed.\n");
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index c6d6f0d..bf8e1e2 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -65,6 +65,7 @@
 	uint16_t vp_id;
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags = 0;
+	unsigned int count = 10;
 
 	mutex_lock(&ha->vport_lock);
 	/*
@@ -74,13 +75,14 @@
 	 * ensures no active vp_list traversal while the vport is removed
 	 * from the queue)
 	 */
-	spin_lock_irqsave(&ha->vport_slock, flags);
-	while (atomic_read(&vha->vref_count)) {
-		spin_unlock_irqrestore(&ha->vport_slock, flags);
-
+	while (count-- && atomic_read(&vha->vref_count))
 		msleep(500);
 
-		spin_lock_irqsave(&ha->vport_slock, flags);
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	if (atomic_read(&vha->vref_count)) {
+		ql_dbg(ql_dbg_vport, vha, 0xfffa,
+		    "vha->vref_count=%u timeout\n", vha->vref_count.counter);
+		vha->vref_count = (atomic_t)ATOMIC_INIT(0);
 	}
 	list_del(&vha->list);
 	qlt_update_vp_map(vha, RESET_VP_IDX);
-- 
1.8.3.1
