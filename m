From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/22] libata-sff: port_task is SFF specific
Date: Tue, 21 Oct 2008 18:17:51 +0900
Message-ID: <1224580680-13698-14-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:46056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbYJUJUv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 05:20:51 -0400
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>

port_task is tightly bound to the standard SFF PIO HSM implementation.
Using it for any other purpose would be error-prone and there's no
such user and if some drivers need such feature, it would be much
better off using its own.  Move it inside CONFIG_ATA_SFF and rename it
to sff_pio_task.

The only function which is exposed to the core layer is
ata_sff_flush_pio_task() which is renamed from ata_port_flush_task()
and now also takes care of resetting hsm_task_state to HSM_ST_IDLE,
which is possible as it's now specific to PIO HSM.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-core.c |   62 +------------------------------------------
 drivers/ata/libata-eh.c   |    4 +-
 drivers/ata/libata-sff.c  |   64 ++++++++++++++++++++++++++++++++------------
 drivers/ata/libata.h      |    7 ++---
 include/linux/libata.h    |    3 +-
 5 files changed, 53 insertions(+), 87 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3dd8512..13ee83d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -93,7 +93,6 @@ static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
 unsigned int ata_print_id = 1;
-static struct workqueue_struct *ata_wq;
 
 struct workqueue_struct *ata_aux_wq;
 
@@ -1599,53 +1598,6 @@ unsigned long ata_id_xfermask(const u16 *id)
 	return ata_pack_xfermask(pio_mask, mwdma_mask, udma_mask);
 }
 
-/**
- *	ata_pio_queue_task - Queue port_task
- *	@ap: The ata_port to queue port_task for
- *	@fn: workqueue function to be scheduled
- *	@data: data for @fn to use
- *	@delay: delay time in msecs for workqueue function
- *
- *	Schedule @fn(@data) for execution after @delay jiffies using
- *	port_task.  There is one port_task per port and it's the
- *	user(low level driver)'s responsibility to make sure that only
- *	one task is active at any given time.
- *
- *	libata core layer takes care of synchronization between
- *	port_task and EH.  ata_pio_queue_task() may be ignored for EH
- *	synchronization.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-void ata_pio_queue_task(struct ata_port *ap, void *data, unsigned long delay)
-{
-	ap->port_task_data = data;
-
-	/* may fail if ata_port_flush_task() in progress */
-	queue_delayed_work(ata_wq, &ap->port_task, msecs_to_jiffies(delay));
-}
-
-/**
- *	ata_port_flush_task - Flush port_task
- *	@ap: The ata_port to flush port_task for
- *
- *	After this function completes, port_task is guranteed not to
- *	be running or scheduled.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep)
- */
-void ata_port_flush_task(struct ata_port *ap)
-{
-	DPRINTK("ENTER\n");
-
-	cancel_rearming_delayed_work(&ap->port_task);
-
-	if (ata_msg_ctl(ap))
-		ata_port_printk(ap, KERN_DEBUG, "%s: EXIT\n", __func__);
-}
-
 static void ata_qc_complete_internal(struct ata_queued_cmd *qc)
 {
 	struct completion *waiting = qc->private_data;
@@ -1767,7 +1719,7 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 
 	rc = wait_for_completion_timeout(&wait, msecs_to_jiffies(timeout));
 
-	ata_port_flush_task(ap);
+	ata_sff_flush_pio_task(ap);
 
 	if (!rc) {
 		spin_lock_irqsave(ap->lock, flags);
@@ -5285,11 +5237,6 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	ap->msg_enable = ATA_MSG_DRV | ATA_MSG_ERR | ATA_MSG_WARN;
 #endif
 
-#ifdef CONFIG_ATA_SFF
-	INIT_DELAYED_WORK(&ap->port_task, ata_pio_task);
-#else
-	INIT_DELAYED_WORK(&ap->port_task, NULL);
-#endif
 	INIT_DELAYED_WORK(&ap->hotplug_task, ata_scsi_hotplug);
 	INIT_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
 	INIT_LIST_HEAD(&ap->eh_done_q);
@@ -6228,10 +6175,6 @@ static int __init ata_init(void)
 
 	ata_parse_force_param();
 
-	ata_wq = create_workqueue("ata");
-	if (!ata_wq)
-		goto fail;
-
 	ata_aux_wq = create_singlethread_workqueue("ata_aux");
 	if (!ata_aux_wq)
 		goto fail;
@@ -6245,8 +6188,6 @@ static int __init ata_init(void)
 
  fail:
 	kfree(ata_force_tbl);
-	if (ata_wq)
-		destroy_workqueue(ata_wq);
 	if (ata_aux_wq)
 		destroy_workqueue(ata_aux_wq);
 	return rc;
@@ -6256,7 +6197,6 @@ static void __exit ata_exit(void)
 {
 	ata_sff_exit();
 	kfree(ata_force_tbl);
-	destroy_workqueue(ata_wq);
 	destroy_workqueue(ata_aux_wq);
 }
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 7ccd0ce..0ee48f7 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -511,8 +511,8 @@ void ata_scsi_error(struct Scsi_Host *host)
 
 	DPRINTK("ENTER\n");
 
-	/* synchronize with port task */
-	ata_port_flush_task(ap);
+	/* make sure sff pio task is not running */
+	ata_sff_flush_pio_task(ap);
 
 	/* synchronize with host lock and sort out timeouts */
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 9124f8d..4c9adc6 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -39,6 +39,8 @@
 
 #include "libata.h"
 
+static struct workqueue_struct *ata_sff_wq;
+
 const struct ata_port_operations ata_sff_port_ops = {
 	.inherits		= &ata_base_port_ops,
 
@@ -1172,7 +1174,7 @@ fsm_start:
 		if (in_wq)
 			spin_unlock_irqrestore(ap->lock, flags);
 
-		/* if polling, ata_pio_task() handles the rest.
+		/* if polling, ata_sff_pio_task() handles the rest.
 		 * otherwise, interrupt handler takes over from here.
 		 */
 		break;
@@ -1317,14 +1319,37 @@ fsm_start:
 	return poll_next;
 }
 
-void ata_pio_task(struct work_struct *work)
+static void ata_sff_queue_pio_task(struct ata_port *ap, unsigned long delay)
+{
+	/* may fail if ata_sff_flush_pio_task() in progress */
+	queue_delayed_work(ata_sff_wq, &ap->sff_pio_task,
+			   msecs_to_jiffies(delay));
+}
+
+void ata_sff_flush_pio_task(struct ata_port *ap)
+{
+	DPRINTK("ENTER\n");
+
+	cancel_rearming_delayed_work(&ap->sff_pio_task);
+	ap->hsm_task_state = HSM_ST_IDLE;
+
+	if (ata_msg_ctl(ap))
+		ata_port_printk(ap, KERN_DEBUG, "%s: EXIT\n", __func__);
+}
+
+static void ata_sff_pio_task(struct work_struct *work)
 {
 	struct ata_port *ap =
-		container_of(work, struct ata_port, port_task.work);
-	struct ata_queued_cmd *qc = ap->port_task_data;
+		container_of(work, struct ata_port, sff_pio_task.work);
+	struct ata_queued_cmd *qc;
 	u8 status;
 	int poll_next;
 
+	/* qc can be NULL if timeout occurred */
+	qc = ata_qc_from_tag(ap, ap->link.active_tag);
+	if (!qc)
+		return;
+
 fsm_start:
 	WARN_ON(ap->hsm_task_state == HSM_ST_IDLE);
 
@@ -1340,7 +1365,7 @@ fsm_start:
 		msleep(2);
 		status = ata_sff_busy_wait(ap, ATA_BUSY, 10);
 		if (status & ATA_BUSY) {
-			ata_pio_queue_task(ap, qc, ATA_SHORT_PAUSE);
+			ata_sff_queue_pio_task(ap, ATA_SHORT_PAUSE);
 			return;
 		}
 	}
@@ -1410,7 +1435,7 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 		ap->hsm_task_state = HSM_ST_LAST;
 
 		if (qc->tf.flags & ATA_TFLAG_POLLING)
-			ata_pio_queue_task(ap, qc, 0);
+			ata_sff_queue_pio_task(ap, 0);
 
 		break;
 
@@ -1432,20 +1457,21 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 		if (qc->tf.flags & ATA_TFLAG_WRITE) {
 			/* PIO data out protocol */
 			ap->hsm_task_state = HSM_ST_FIRST;
-			ata_pio_queue_task(ap, qc, 0);
+			ata_sff_queue_pio_task(ap, 0);
 
-			/* always send first data block using
-			 * the ata_pio_task() codepath.
+			/* always send first data block using the
+			 * ata_sff_pio_task() codepath.
 			 */
 		} else {
 			/* PIO data in protocol */
 			ap->hsm_task_state = HSM_ST;
 
 			if (qc->tf.flags & ATA_TFLAG_POLLING)
-				ata_pio_queue_task(ap, qc, 0);
+				ata_sff_queue_pio_task(ap, 0);
 
-			/* if polling, ata_pio_task() handles the rest.
-			 * otherwise, interrupt handler takes over from here.
+			/* if polling, ata_sff_pio_task() handles the
+			 * rest.  otherwise, interrupt handler takes
+			 * over from here.
 			 */
 		}
 
@@ -1463,7 +1489,7 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 		/* send cdb by polling if no cdb interrupt */
 		if ((!(qc->dev->flags & ATA_DFLAG_CDB_INTR)) ||
 		    (qc->tf.flags & ATA_TFLAG_POLLING))
-			ata_pio_queue_task(ap, qc, 0);
+			ata_sff_queue_pio_task(ap, 0);
 		break;
 
 	case ATAPI_PROT_DMA:
@@ -1475,7 +1501,7 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 
 		/* send cdb by polling if no cdb interrupt */
 		if (!(qc->dev->flags & ATA_DFLAG_CDB_INTR))
-			ata_pio_queue_task(ap, qc, 0);
+			ata_sff_queue_pio_task(ap, 0);
 		break;
 
 	default:
@@ -2080,8 +2106,6 @@ void ata_sff_error_handler(struct ata_port *ap)
 	/* reset PIO HSM and stop DMA engine */
 	spin_lock_irqsave(ap->lock, flags);
 
-	ap->hsm_task_state = HSM_ST_IDLE;
-
 	if (ap->ioaddr.bmdma_addr &&
 	    qc && (qc->tf.protocol == ATA_PROT_DMA ||
 		   qc->tf.protocol == ATAPI_PROT_DMA)) {
@@ -2141,8 +2165,6 @@ void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc)
 
 	spin_lock_irqsave(ap->lock, flags);
 
-	ap->hsm_task_state = HSM_ST_IDLE;
-
 	if (ap->ioaddr.bmdma_addr)
 		ata_bmdma_stop(qc);
 
@@ -2826,17 +2848,23 @@ void ata_pci_bmdma_init(struct ata_host *host)
  */
 void ata_sff_port_init(struct ata_port *ap)
 {
+	INIT_DELAYED_WORK(&ap->sff_pio_task, ata_sff_pio_task);
 	ap->ctl = ATA_DEVCTL_OBS;
 	ap->last_ctl = 0xFF;
 }
 
 int __init ata_sff_init(void)
 {
+	ata_sff_wq = create_workqueue("ata_sff");
+	if (!ata_sff_wq)
+		return -ENOMEM;
+
 	return 0;
 }
 
 void __exit ata_sff_exit(void)
 {
+	destroy_workqueue(ata_sff_wq);
 }
 
 EXPORT_SYMBOL_GPL(ata_sff_port_ops);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 31d89d9..81b6852 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -80,9 +80,6 @@ extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   unsigned int tag);
 extern u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev);
 extern void ata_dev_disable(struct ata_device *dev);
-extern void ata_pio_queue_task(struct ata_port *ap, void *data,
-			       unsigned long delay);
-extern void ata_port_flush_task(struct ata_port *ap);
 extern unsigned ata_exec_internal(struct ata_device *dev,
 				  struct ata_taskfile *tf, const u8 *cdb,
 				  int dma_dir, void *buf, unsigned int buflen,
@@ -201,11 +198,13 @@ static inline int sata_pmp_attach(struct ata_device *dev)
 
 /* libata-sff.c */
 #ifdef CONFIG_ATA_SFF
-extern void ata_pio_task(struct work_struct *work);
+extern void ata_sff_flush_pio_task(struct ata_port *ap);
 extern void ata_sff_port_init(struct ata_port *ap);
 extern int ata_sff_init(void);
 extern void ata_sff_exit(void);
 #else /* CONFIG_ATA_SFF */
+static inline void ata_sff_flush_pio_task(struct ata_port *ap)
+{ }
 static inline void ata_sff_port_init(struct ata_port *ap)
 { }
 static inline int ata_sff_init(void)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3125039..43b13cd 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -681,6 +681,7 @@ struct ata_port {
 	struct ata_ioports	ioaddr;	/* ATA cmd/ctl/dma register blocks */
 	u8			ctl;	/* cache of ATA control register */
 	u8			last_ctl;	/* Cache last written value */
+	struct delayed_work	sff_pio_task;
 #endif /* CONFIG_ATA_SFF */
 
 	unsigned int		pio_mask;
@@ -704,8 +705,6 @@ struct ata_port {
 	struct ata_host		*host;
 	struct device 		*dev;
 
-	void			*port_task_data;
-	struct delayed_work	port_task;
 	struct delayed_work	hotplug_task;
 	struct work_struct	scsi_rescan_task;
 
-- 
1.5.4.5

