From: Abhijeet Joglekar <abjoglek@cisco.com>
Subject: [PATCH 1/3] fnic: Change link transition handling
Date: Wed, 25 Mar 2009 10:43:58 -0700
Message-ID: <20090325173858.21346.40592.stgit@feynman.nuovasystems.com>
References: <20090325173136.21346.86030.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.nuovasystems.com ([67.91.200.194]:40770 "EHLO
	feynman.nuovasystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763493AbZCYRoA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 13:44:00 -0400
In-Reply-To: <20090325173136.21346.86030.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, jeykholt@cisco.com

Events were used to wrap a link transition (up or down) and an embedded workQ
item would then be posted for fnic workQ thread to pass the event to libFC.
This required allocation of event, which if it fails, was not handled.

This fix removes the event wrapper and event allocation. Each fnic structure
has an embedded workQ item, and the link ISR simply queues the workQ item. The
workQ link handler then decides based on link down count and previous
and current link status, how to process the link transition. This does not
require the allocation of events and is safer in the face of memory pressure.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
---
 drivers/scsi/fnic/fnic.h      |    5 ++
 drivers/scsi/fnic/fnic_fcs.c  |   89 ++++++++++++++++++++++++++++-------------
 drivers/scsi/fnic/fnic_main.c |   29 +------------
 3 files changed, 68 insertions(+), 55 deletions(-)


diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index e76fb35..8a057cd 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -188,6 +188,8 @@ struct fnic {
 	u64 fcp_input_bytes;		/* internal statistic */
 	u64 fcp_output_bytes;		/* internal statistic */
 	int event_count;                /* number of events queued in workq */
+	u32 link_down_cnt;
+	int link_status;
 
 	struct list_head list;
 	struct pci_dev *pdev;
@@ -206,6 +208,8 @@ struct fnic {
 	mempool_t *io_sgl_pool[FNIC_SGL_NUM_CACHES];
 	spinlock_t io_req_lock[FNIC_IO_LOCKS];	/* locks for scsi cmnds */
 
+	struct work_struct link_work;
+
 	/* copy work queue cache line section */
 	____cacheline_aligned struct vnic_wq_copy wq_copy[FNIC_WQ_COPY_MAX];
 	/* completion queue cache line section */
@@ -254,6 +258,7 @@ int fnic_request_intr(struct fnic *fnic);
 int fnic_send(struct fc_lport *, struct fc_frame *);
 void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic_wq_buf *buf);
 void fnic_event_work(struct work_struct *work);
+void fnic_handle_link(struct work_struct *work);
 int fnic_rq_cmpl_handler(struct fnic *fnic, int);
 int fnic_alloc_rq_frame(struct vnic_rq *rq);
 void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic_rq_buf *buf);
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 17cfe9b..ab0eaea 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -38,6 +38,59 @@
 
 struct workqueue_struct *fnic_event_queue;
 
+void fnic_handle_link(struct work_struct *work)
+{
+	struct fnic *fnic = container_of(work, struct fnic, link_work);
+	unsigned long flags;
+	int old_link_status;
+	u32 old_link_down_cnt;
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+
+	if (fnic->stop_rx_link_events) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		return;
+	}
+
+	old_link_down_cnt = fnic->link_down_cnt;
+	old_link_status = fnic->link_status;
+	fnic->link_status = vnic_dev_link_status(fnic->vdev);
+	fnic->link_down_cnt = vnic_dev_link_down_cnt(fnic->vdev);
+
+	if (old_link_status == fnic->link_status) {
+		if (!fnic->link_status)
+			/* DOWN -> DOWN */
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		else {
+			if (old_link_down_cnt != fnic->link_down_cnt) {
+				/* UP -> DOWN -> UP */
+				fnic->lport->host_stats.link_failure_count++;
+				spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+				FNIC_FCS_DBG(KERN_DEBUG, DFX "link down\n",
+					     fnic->fnic_no);
+				fc_linkdown(fnic->lport);
+				FNIC_FCS_DBG(KERN_DEBUG, DFX "link up\n",
+					     fnic->fnic_no);
+				fc_linkup(fnic->lport);
+			} else
+				/* UP -> UP */
+				spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		}
+	} else if (fnic->link_status) {
+		/* DOWN -> UP */
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		FNIC_FCS_DBG(KERN_DEBUG, DFX "link up\n", fnic->fnic_no);
+		fc_linkup(fnic->lport);
+	} else {
+		/* UP -> DOWN */
+		fnic->lport->host_stats.link_failure_count++;
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		FNIC_FCS_DBG(KERN_DEBUG, DFX "link down\n", fnic->fnic_no);
+		fc_linkdown(fnic->lport);
+	}
+
+}
+
 /*
  * This function passes events and incoming fabric frames to libFC
  */
@@ -51,44 +104,22 @@ void fnic_event_work(struct work_struct *work)
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 
+	fnic->event_count--;
 	if (fnic->stop_rx_link_events) {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		if (event->ev_type == EV_TYPE_FRAME)
-			dev_kfree_skb_irq(fp_skb(event->fp));
+		dev_kfree_skb_irq(fp_skb(event->fp));
 		kmem_cache_free(fnic_ev_cache, event);
-		spin_lock_irqsave(&fnic->fnic_lock, flags);
-		fnic->event_count--;
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		return;
 	}
 
-	switch (event->ev_type) {
-	case EV_TYPE_FRAME:
-		if (event->is_flogi_resp_frame)
-			vnic_dev_add_addr(fnic->vdev,
-					  fnic->data_src_addr);
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		fc_exch_recv(lp, lp->emp, event->fp);
-		break;
-	case EV_TYPE_LINK_UP:
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		fc_linkup(lp);
-		break;
-	case EV_TYPE_LINK_DOWN:
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		fc_linkdown(lp);
-		break;
-	default:
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		break;
-	}
+	if (event->is_flogi_resp_frame)
+		vnic_dev_add_addr(fnic->vdev,
+				  fnic->data_src_addr);
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
+	fc_exch_recv(lp, lp->emp, event->fp);
 	kmem_cache_free(fnic_ev_cache, event);
 
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	fnic->event_count--;
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-
 }
 
 static inline void fnic_import_rq_fc_frame(struct sk_buff *skb,
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 97d2f32..11eecac 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -237,8 +237,6 @@ void fnic_log_q_error(struct fnic *fnic)
 
 void fnic_handle_link_event(struct fnic *fnic)
 {
-	int link_status = vnic_dev_link_status(fnic->vdev);
-	struct fnic_event *event;
 	unsigned long flags;
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
@@ -246,32 +244,9 @@ void fnic_handle_link_event(struct fnic *fnic)
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		return;
 	}
-
-	FNIC_MAIN_DBG(KERN_DEBUG, DFX "link %s\n", fnic->fnic_no,
-		      (link_status ? "up" : "down"));
-
-	event = kmem_cache_alloc(fnic_ev_cache, GFP_ATOMIC);
-	if (!event) {
-		FNIC_MAIN_DBG(KERN_DEBUG, DFX "Cannot allocate a event, "
-			      "cannot indicate link event to FCS\n",
-			      fnic->fnic_no);
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		return;
-	}
-
-	/* Queue the link event in fnic workQ */
-	memset(event, 0, sizeof(struct fnic_event));
-	event->fnic = fnic;
-	event->ev_type = EV_TYPE_LINK_UP;
-	if (!link_status) {
-		event->ev_type = EV_TYPE_LINK_DOWN;
-		fnic->lport->host_stats.link_failure_count++;
-	}
-	fnic->event_count++;
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-	INIT_WORK(&event->event_work, fnic_event_work);
-	queue_work(fnic_event_queue, &event->event_work);
+	queue_work(fnic_event_queue, &fnic->link_work);
 
 }
 
@@ -745,6 +720,8 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	list_add_tail(&fnic->list, &fnic_list);
 	spin_unlock_irqrestore(&fnic_list_lock, flags);
 
+	INIT_WORK(&fnic->link_work, fnic_handle_link);
+
 	/* Enable all queues */
 	for (i = 0; i < fnic->raw_wq_count; i++)
 		vnic_wq_enable(&fnic->wq[i]);


