From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 17/20] qla2xxx: Reduce lock-contention during do-work processing.
Date: Wed,  3 Jun 2009 09:55:28 -0700
Message-ID: <1244048131-56590-18-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4855 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364AbZFCQzv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:51 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Queued work processing will now be serialized with its own
lower-priority spinlock.  This also simplifies the work-queue
interface for future work-queue consumers.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    2 +
 drivers/scsi/qla2xxx/qla_os.c  |   45 +++++++++++++++++++--------------------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 88ddae0..00aa48d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2561,6 +2561,8 @@ typedef struct scsi_qla_host {
 	struct list_head list;
 	struct list_head vp_fcports;	/* list of fcports */
 	struct list_head work_list;
+	spinlock_t work_lock;
+
 	/* Commonly used flags and state information. */
 	struct Scsi_Host *host;
 	unsigned long	host_no;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 128b3d5..dcf0116 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2533,6 +2533,8 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	INIT_LIST_HEAD(&vha->work_list);
 	INIT_LIST_HEAD(&vha->list);
 
+	spin_lock_init(&vha->work_lock);
+
 	sprintf(vha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, vha->host_no);
 	return vha;
 
@@ -2541,13 +2543,11 @@ fail:
 }
 
 static struct qla_work_evt *
-qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type,
-    int locked)
+qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type)
 {
 	struct qla_work_evt *e;
 
-	e = kzalloc(sizeof(struct qla_work_evt), locked ? GFP_ATOMIC:
-	    GFP_KERNEL);
+	e = kzalloc(sizeof(struct qla_work_evt), GFP_ATOMIC);
 	if (!e)
 		return NULL;
 
@@ -2558,17 +2558,15 @@ qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type,
 }
 
 static int
-qla2x00_post_work(struct scsi_qla_host *vha, struct qla_work_evt *e, int locked)
+qla2x00_post_work(struct scsi_qla_host *vha, struct qla_work_evt *e)
 {
-	unsigned long uninitialized_var(flags);
-	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
 
-	if (!locked)
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&vha->work_lock, flags);
 	list_add_tail(&e->list, &vha->work_list);
+	spin_unlock_irqrestore(&vha->work_lock, flags);
 	qla2xxx_wake_dpc(vha);
-	if (!locked)
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	return QLA_SUCCESS;
 }
 
@@ -2578,13 +2576,13 @@ qla2x00_post_aen_work(struct scsi_qla_host *vha, enum fc_host_event_code code,
 {
 	struct qla_work_evt *e;
 
-	e = qla2x00_alloc_work(vha, QLA_EVT_AEN, 1);
+	e = qla2x00_alloc_work(vha, QLA_EVT_AEN);
 	if (!e)
 		return QLA_FUNCTION_FAILED;
 
 	e->u.aen.code = code;
 	e->u.aen.data = data;
-	return qla2x00_post_work(vha, e, 1);
+	return qla2x00_post_work(vha, e);
 }
 
 int
@@ -2592,25 +2590,27 @@ qla2x00_post_idc_ack_work(struct scsi_qla_host *vha, uint16_t *mb)
 {
 	struct qla_work_evt *e;
 
-	e = qla2x00_alloc_work(vha, QLA_EVT_IDC_ACK, 1);
+	e = qla2x00_alloc_work(vha, QLA_EVT_IDC_ACK);
 	if (!e)
 		return QLA_FUNCTION_FAILED;
 
 	memcpy(e->u.idc_ack.mb, mb, QLA_IDC_ACK_REGS * sizeof(uint16_t));
-	return qla2x00_post_work(vha, e, 1);
+	return qla2x00_post_work(vha, e);
 }
 
 static void
 qla2x00_do_work(struct scsi_qla_host *vha)
 {
-	struct qla_work_evt *e;
-	struct qla_hw_data *ha = vha->hw;
+	struct qla_work_evt *e, *tmp;
+	unsigned long flags;
+	LIST_HEAD(work);
 
-	spin_lock_irq(&ha->hardware_lock);
-	while (!list_empty(&vha->work_list)) {
-		e = list_entry(vha->work_list.next, struct qla_work_evt, list);
+	spin_lock_irqsave(&vha->work_lock, flags);
+	list_splice_init(&vha->work_list, &work);
+	spin_unlock_irqrestore(&vha->work_lock, flags);
+
+	list_for_each_entry_safe(e, tmp, &work, list) {
 		list_del_init(&e->list);
-		spin_unlock_irq(&ha->hardware_lock);
 
 		switch (e->type) {
 		case QLA_EVT_AEN:
@@ -2623,10 +2623,9 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
-		spin_lock_irq(&ha->hardware_lock);
 	}
-	spin_unlock_irq(&ha->hardware_lock);
 }
+
 /* Relogins all the fcports of a vport
  * Context: dpc thread
  */
-- 
1.6.3.1.244.gf9275

