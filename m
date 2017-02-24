From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 03/14] qla2xxx: Allow vref count to timeout on vport delete.
Date: Fri, 24 Feb 2017 13:37:32 -0800
Message-ID: <1487972263-3795-4-git-send-email-himanshu.madhani@cavium.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0076.outbound.protection.outlook.com ([104.47.40.76]:42236
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751298AbdBXVhz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Feb 2017 16:37:55 -0500
In-Reply-To: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Cc: <stable@vger.kernel.org>
Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  4 +---
 drivers/scsi/qla2xxx/qla_def.h  |  6 +++++-
 drivers/scsi/qla2xxx/qla_init.c |  1 +
 drivers/scsi/qla2xxx/qla_mid.c  | 14 ++++++++------
 drivers/scsi/qla2xxx/qla_os.c   |  1 +
 5 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index f610103..435ff7f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2154,8 +2154,6 @@ struct device_attribute *qla2x00_host_attrs[] = {
 		    "Timer for the VP[%d] has stopped\n", vha->vp_idx);
 	}
 
-	BUG_ON(atomic_read(&vha->vref_count));
-
 	qla2x00_free_fcports(vha);
 
 	mutex_lock(&ha->vport_lock);
@@ -2166,7 +2164,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	dma_free_coherent(&ha->pdev->dev, vha->gnl.size, vha->gnl.l,
 	    vha->gnl.ldma);
 
-	if (vha->qpair->vp_idx == vha->vp_idx) {
+	if (vha->qpair && vha->qpair->vp_idx == vha->vp_idx) {
 		if (qla2xxx_delete_qpair(vha, vha->qpair) != QLA_SUCCESS)
 			ql_log(ql_log_warn, vha, 0x7087,
 			    "Queue Pair delete failed.\n");
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index fea4b79..e337020 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4086,6 +4086,7 @@ struct qla_tgt_counters {
 	/* Count of active session/fcport */
 	int fcport_count;
 	wait_queue_head_t fcport_waitQ;
+	wait_queue_head_t vref_waitq;
 } scsi_qla_host_t;
 
 struct qla27xx_image_status {
@@ -4141,14 +4142,17 @@ struct qla2_sgx {
 	mb();						\
 	if (__vha->flags.delete_progress) {		\
 		atomic_dec(&__vha->vref_count);		\
+		wake_up(&__vha->vref_waitq);		\
 		__bail = 1;				\
 	} else {					\
 		__bail = 0;				\
 	}						\
 } while (0)
 
-#define QLA_VHA_MARK_NOT_BUSY(__vha)			\
+#define QLA_VHA_MARK_NOT_BUSY(__vha) do {		\
 	atomic_dec(&__vha->vref_count);			\
+	wake_up(&__vha->vref_waitq);			\
+} while (0)						\
 
 #define QLA_QPAIR_MARK_BUSY(__qpair, __bail) do {	\
 	atomic_inc(&__qpair->ref_count);		\
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 08f8536..1f94003 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5158,6 +5158,7 @@ int qla2x00_perform_loop_resync(scsi_qla_host_t *ha)
 			}
 		}
 		atomic_dec(&vha->vref_count);
+		wake_up(&vha->vref_waitq);
 	}
 	spin_unlock_irqrestore(&ha->vport_slock, flags);
 }
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index c6d6f0d..09a490c 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -74,13 +74,14 @@
 	 * ensures no active vp_list traversal while the vport is removed
 	 * from the queue)
 	 */
-	spin_lock_irqsave(&ha->vport_slock, flags);
-	while (atomic_read(&vha->vref_count)) {
-		spin_unlock_irqrestore(&ha->vport_slock, flags);
-
-		msleep(500);
+	wait_event_timeout(vha->vref_waitq, atomic_read(&vha->vref_count),
+	    10*HZ);
 
-		spin_lock_irqsave(&ha->vport_slock, flags);
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	if (atomic_read(&vha->vref_count)) {
+		ql_dbg(ql_dbg_vport, vha, 0xfffa,
+		    "vha->vref_count=%u timeout\n", vha->vref_count.counter);
+		vha->vref_count = (atomic_t)ATOMIC_INIT(0);
 	}
 	list_del(&vha->list);
 	qlt_update_vp_map(vha, RESET_VP_IDX);
@@ -269,6 +270,7 @@
 
 			spin_lock_irqsave(&ha->vport_slock, flags);
 			atomic_dec(&vha->vref_count);
+			wake_up(&vha->vref_waitq);
 		}
 		i++;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 312972b..4867589 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4288,6 +4288,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	spin_lock_init(&vha->work_lock);
 	spin_lock_init(&vha->cmd_list_lock);
 	init_waitqueue_head(&vha->fcport_waitQ);
+	init_waitqueue_head(&vha->vref_waitq);
 
 	vha->gnl.size = sizeof(struct get_name_list_extended) *
 			(ha->max_loop_id + 1);
-- 
1.8.3.1
