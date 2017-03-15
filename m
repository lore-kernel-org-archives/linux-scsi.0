From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 01/14] qla2xxx: Allow vref count to timeout on vport delete.
Date: Wed, 15 Mar 2017 09:48:43 -0700
Message-ID: <20170315164856.17255-2-himanshu.madhani@cavium.com>
References: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

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
index f610103994af..435ff7fd6384 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2154,8 +2154,6 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 		    "Timer for the VP[%d] has stopped\n", vha->vp_idx);
 	}
 
-	BUG_ON(atomic_read(&vha->vref_count));
-
 	qla2x00_free_fcports(vha);
 
 	mutex_lock(&ha->vport_lock);
@@ -2166,7 +2164,7 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	dma_free_coherent(&ha->pdev->dev, vha->gnl.size, vha->gnl.l,
 	    vha->gnl.ldma);
 
-	if (vha->qpair->vp_idx == vha->vp_idx) {
+	if (vha->qpair && vha->qpair->vp_idx == vha->vp_idx) {
 		if (qla2xxx_delete_qpair(vha, vha->qpair) != QLA_SUCCESS)
 			ql_log(ql_log_warn, vha, 0x7087,
 			    "Queue Pair delete failed.\n");
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 625d438e3cce..8662ef4192db 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4076,6 +4076,7 @@ typedef struct scsi_qla_host {
 	/* Count of active session/fcport */
 	int fcport_count;
 	wait_queue_head_t fcport_waitQ;
+	wait_queue_head_t vref_waitq;
 } scsi_qla_host_t;
 
 struct qla27xx_image_status {
@@ -4131,14 +4132,17 @@ struct qla2_sgx {
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
index 32fb9007f137..9f3740c68cc8 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5148,6 +5148,7 @@ qla2x00_update_fcports(scsi_qla_host_t *base_vha)
 			}
 		}
 		atomic_dec(&vha->vref_count);
+		wake_up(&vha->vref_waitq);
 	}
 	spin_unlock_irqrestore(&ha->vport_slock, flags);
 }
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index c6d6f0d912ff..09a490c98763 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -74,13 +74,14 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
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
@@ -269,6 +270,7 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 
 			spin_lock_irqsave(&ha->vport_slock, flags);
 			atomic_dec(&vha->vref_count);
+			wake_up(&vha->vref_waitq);
 		}
 		i++;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1fed235a1b4a..54d4e802bde0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4268,6 +4268,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	spin_lock_init(&vha->work_lock);
 	spin_lock_init(&vha->cmd_list_lock);
 	init_waitqueue_head(&vha->fcport_waitQ);
+	init_waitqueue_head(&vha->vref_waitq);
 
 	vha->gnl.size = sizeof(struct get_name_list_extended) *
 			(ha->max_loop_id + 1);
-- 
2.12.0
