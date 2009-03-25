From: Abhijeet Joglekar <abjoglek@cisco.com>
Subject: [PATCH 2/3] fnic: Change FCS frame handling to use skb queues and no
	events
Date: Wed, 25 Mar 2009 10:45:00 -0700
Message-ID: <20090325174403.21346.48076.stgit@feynman.nuovasystems.com>
References: <20090325173136.21346.86030.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.nuovasystems.com ([67.91.200.194]:41182 "EHLO
	feynman.nuovasystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764070AbZCYRpD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 13:45:03 -0400
In-Reply-To: <20090325173136.21346.86030.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, jeykholt@cisco.com

Events were used to wrap incoming frames, and an embedded workQ item in
the event would then get queued. The workQ handler would then invoke libFC
to process the incoming FCS frame. However, this required allocation of event
in the critical path, which if failed, could stall fabric login and fail.

This fix uses a per fnic skb queue and per fnic workQ item. Incoming frames
are enqueued on the skb queue, and fnic's statically allocated workQ item
is queued. The workQ frame handler loops through the skb queue, and forwards
the frames to libFC. This avoids memory allocations in critical path.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
---
 drivers/scsi/fnic/fnic.h      |   24 ++-------------
 drivers/scsi/fnic/fnic_fcs.c  |   66 ++++++++++++++++-------------------------
 drivers/scsi/fnic/fnic_main.c |   41 +++----------------------
 drivers/scsi/fnic/fnic_scsi.c |   28 ++++-------------
 4 files changed, 39 insertions(+), 120 deletions(-)


diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 8a057cd..13fa4c5 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -187,7 +187,6 @@ struct fnic {
 	u8 data_src_addr[ETH_ALEN];
 	u64 fcp_input_bytes;		/* internal statistic */
 	u64 fcp_output_bytes;		/* internal statistic */
-	int event_count;                /* number of events queued in workq */
 	u32 link_down_cnt;
 	int link_status;
 
@@ -209,6 +208,8 @@ struct fnic {
 	spinlock_t io_req_lock[FNIC_IO_LOCKS];	/* locks for scsi cmnds */
 
 	struct work_struct link_work;
+	struct work_struct frame_work;
+	struct sk_buff_head frame_queue;
 
 	/* copy work queue cache line section */
 	____cacheline_aligned struct vnic_wq_copy wq_copy[FNIC_WQ_COPY_MAX];
@@ -228,26 +229,7 @@ struct fnic {
 	____cacheline_aligned struct vnic_intr intr[FNIC_MSIX_INTR_MAX];
 };
 
-/*
- * This is used to pass incoming frames, link notifications from ISR
- * to fnic workQ which passes it to libFC
- */
-enum fnic_thread_event_type {
-	EV_TYPE_LINK_DOWN = 0,
-	EV_TYPE_LINK_UP,
-	EV_TYPE_FRAME,
-};
-
-struct fnic_event {
-	struct fc_frame *fp;
-	struct fnic *fnic;
-	enum fnic_thread_event_type ev_type;
-	u32 is_flogi_resp_frame:1;
-	struct work_struct event_work;
-};
-
 extern struct workqueue_struct *fnic_event_queue;
-extern struct kmem_cache *fnic_ev_cache;
 extern struct device_attribute *fnic_attrs[];
 
 void fnic_clear_intr_mode(struct fnic *fnic);
@@ -257,7 +239,7 @@ int fnic_request_intr(struct fnic *fnic);
 
 int fnic_send(struct fc_lport *, struct fc_frame *);
 void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic_wq_buf *buf);
-void fnic_event_work(struct work_struct *work);
+void fnic_handle_frame(struct work_struct *work);
 void fnic_handle_link(struct work_struct *work);
 int fnic_rq_cmpl_handler(struct fnic *fnic, int);
 int fnic_alloc_rq_frame(struct vnic_rq *rq);
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index ab0eaea..9233b8e 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -92,33 +92,35 @@ void fnic_handle_link(struct work_struct *work)
 }
 
 /*
- * This function passes events and incoming fabric frames to libFC
+ * This function passes incoming fabric frames to libFC
  */
-void fnic_event_work(struct work_struct *work)
+void fnic_handle_frame(struct work_struct *work)
 {
-	struct fnic_event *event =
-		container_of(work, struct fnic_event, event_work);
-	struct fnic *fnic = event->fnic;
+	struct fnic *fnic = container_of(work, struct fnic, frame_work);
 	struct fc_lport *lp = fnic->lport;
 	unsigned long flags;
+	struct sk_buff *skb;
+	struct fc_frame *fp;
 
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	while ((skb = skb_dequeue(&fnic->frame_queue))) {
 
-	fnic->event_count--;
-	if (fnic->stop_rx_link_events) {
+		spin_lock_irqsave(&fnic->fnic_lock, flags);
+		if (fnic->stop_rx_link_events) {
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+			dev_kfree_skb(skb);
+			return;
+		}
+		fp = (struct fc_frame *)skb;
+		/* if Flogi resp frame, register the address */
+		if (fr_flags(fp)) {
+			vnic_dev_add_addr(fnic->vdev,
+					  fnic->data_src_addr);
+			fr_flags(fp) = 0;
+		}
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		dev_kfree_skb_irq(fp_skb(event->fp));
-		kmem_cache_free(fnic_ev_cache, event);
-		return;
-	}
 
-	if (event->is_flogi_resp_frame)
-		vnic_dev_add_addr(fnic->vdev,
-				  fnic->data_src_addr);
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-
-	fc_exch_recv(lp, lp->emp, event->fp);
-	kmem_cache_free(fnic_ev_cache, event);
+		fc_exch_recv(lp, lp->emp, fp);
+	}
 
 }
 
@@ -310,7 +312,6 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 	struct sk_buff *skb;
 	struct fc_frame *fp;
 	unsigned int eth_hdrs_stripped;
-	struct fnic_event *event = NULL;
 	u8 type, color, eop, sop, ingress_port, vlan_stripped;
 	u8 fcoe = 0, fcoe_sof, fcoe_eof;
 	u8 fcoe_fc_crc_ok = 1, fcoe_enc_error = 0;
@@ -398,30 +399,13 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		goto drop;
 	}
-
-
-	/* Queue the frame to fnic workQ */
-	event = kmem_cache_alloc(fnic_ev_cache, GFP_ATOMIC);
-	if (event == NULL) {
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_FCS_DBG(KERN_DEBUG, DFX "Cannot allocate a event, "
-			     "dropping the FCS Rx frame\n", fnic->fnic_no);
-		goto drop;
-	}
-
-	memset(event, 0, sizeof(struct fnic_event));
-
-	/* initialize the event structure*/
-	event->fp = fp;
+	/* Use fr_flags to indicate whether flogi resp or not */
+	fr_flags(fp) = 0;
 	fr_dev(fp) = fnic->lport;
-	event->fnic = fnic;
-	event->ev_type = EV_TYPE_FRAME;
-	event->is_flogi_resp_frame = 0;
-	fnic->event_count++;
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-	INIT_WORK(&event->event_work, fnic_event_work);
-	queue_work(fnic_event_queue, &event->event_work);
+	skb_queue_tail(&fnic->frame_queue, skb);
+	queue_work(fnic_event_queue, &fnic->frame_work);
 
 	return;
 drop:
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 11eecac..e66d5d1 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -52,8 +52,6 @@
 /* Timer to poll notification area for events. Used for MSI interrupts */
 #define FNIC_NOTIFY_TIMER_PERIOD	(2 * HZ)
 
-/* Cache to pass events from ISR to fnic work queue */
-struct kmem_cache *fnic_ev_cache;
 static struct kmem_cache *fnic_sgl_cache[FNIC_SGL_NUM_CACHES];
 static struct kmem_cache *fnic_io_req_cache;
 static atomic_t fnic_no;
@@ -721,6 +719,8 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	spin_unlock_irqrestore(&fnic_list_lock, flags);
 
 	INIT_WORK(&fnic->link_work, fnic_handle_link);
+	INIT_WORK(&fnic->frame_work, fnic_handle_frame);
+	skb_queue_head_init(&fnic->frame_queue);
 
 	/* Enable all queues */
 	for (i = 0; i < fnic->raw_wq_count; i++)
@@ -781,7 +781,6 @@ static void __devexit fnic_remove(struct pci_dev *pdev)
 {
 	struct fnic *fnic = pci_get_drvdata(pdev);
 	unsigned long flags;
-	unsigned long wait_flush;
 
 	/*
 	 * Mark state so that the workqueue thread stops forwarding
@@ -798,6 +797,7 @@ static void __devexit fnic_remove(struct pci_dev *pdev)
 	 * be no event queued for this fnic device in the workqueue
 	 */
 	flush_workqueue(fnic_event_queue);
+	skb_queue_purge(&fnic->frame_queue);
 
 	/*
 	 * Log off the fabric. This stops all remote ports, dns port,
@@ -810,26 +810,6 @@ static void __devexit fnic_remove(struct pci_dev *pdev)
 	fnic->in_remove = 1;
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-	/*
-	 * There might still be some events which had begun processing
-	 * before stop_rx_link_events was set, and whose processing was
-	 * not flushed in the flush_workqueue above. Wait for those events
-	 * to complete
-	 */
-	wait_flush = jiffies + 5 * HZ;
-	while (time_before(jiffies, wait_flush)) {
-		BUG_ON(fnic->event_count < 0);
-		if (!fnic->event_count)
-			break;
-		ssleep(1);
-	}
-
-	if (fnic->event_count) {
-		printk(KERN_DEBUG DFX "event count = %d\n", fnic->fnic_no,
-		       fnic->event_count);
-		BUG_ON(1);
-	}
-
 	fc_lport_destroy(fnic->lport);
 
 	/*
@@ -839,6 +819,8 @@ static void __devexit fnic_remove(struct pci_dev *pdev)
 	 */
 	fnic_cleanup(fnic);
 
+	BUG_ON(!skb_queue_empty(&fnic->frame_queue));
+
 	spin_lock_irqsave(&fnic_list_lock, flags);
 	list_del(&fnic->list);
 	spin_unlock_irqrestore(&fnic_list_lock, flags);
@@ -897,16 +879,6 @@ static int __init fnic_init_module(void)
 		goto err_create_fnic_sgl_slab_max;
 	}
 
-	/* Create a cache of events to post work to fnic workQ */
-	len = sizeof(struct fnic_event);
-	fnic_ev_cache = kmem_cache_create("fnic_event", len,
-					  0, 0, NULL);
-	if (!fnic_ev_cache) {
-		printk(KERN_ERR PFX "failed to create fnic event slab\n");
-		err = -ENOMEM;
-		goto err_create_fnic_ev_slab;
-	}
-
 	/* Create a cache of io_req structs for use via mempool */
 	fnic_io_req_cache = kmem_cache_create("fnic_io_req",
 					      sizeof(struct fnic_io_req),
@@ -951,8 +923,6 @@ err_fc_transport:
 err_create_fnic_workq:
 	kmem_cache_destroy(fnic_io_req_cache);
 err_create_fnic_ioreq_slab:
-	kmem_cache_destroy(fnic_ev_cache);
-err_create_fnic_ev_slab:
 	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
 err_create_fnic_sgl_slab_max:
 	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
@@ -964,7 +934,6 @@ static void __exit fnic_cleanup_module(void)
 {
 	pci_unregister_driver(&fnic_driver);
 	destroy_workqueue(fnic_event_queue);
-	kmem_cache_destroy(fnic_ev_cache);
 	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
 	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
 	kmem_cache_destroy(fnic_io_req_cache);
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 6db6359..0760abe 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -543,10 +543,10 @@ static int fnic_fcpio_flogi_reg_cmpl_handler(struct fnic *fnic,
 	u8 type;
 	u8 hdr_status;
 	struct fcpio_tag tag;
-	struct fnic_event *event;
 	int ret = 0;
 	struct fc_frame *flogi_resp = NULL;
 	unsigned long flags;
+	struct sk_buff *skb;
 
 	fcpio_header_dec(&desc->hdr, &type, &hdr_status, &tag);
 
@@ -584,30 +584,14 @@ static int fnic_fcpio_flogi_reg_cmpl_handler(struct fnic *fnic,
 			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 			goto reg_cmpl_handler_end;
 		}
-
-		event = kmem_cache_alloc(fnic_ev_cache, GFP_ATOMIC);
-
-		if (!event) {
-			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-			dev_kfree_skb_irq(fp_skb(flogi_resp));
-			ret = -1;
-			goto reg_cmpl_handler_end;
-		}
-
-		memset(event, 0, sizeof(struct fnic_event));
-
-		/* initialize the event structure */
-		event->fp = flogi_resp;
+		skb = (struct sk_buff *)flogi_resp;
+		/* Use fr_flags to indicate whether flogi resp or not */
+		fr_flags(flogi_resp) = 1;
 		fr_dev(flogi_resp) = fnic->lport;
-		event->fnic = fnic;
-		event->ev_type = EV_TYPE_FRAME;
-		event->is_flogi_resp_frame = 1;
-		fnic->event_count++;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-		/* insert it into event queue */
-		INIT_WORK(&event->event_work, fnic_event_work);
-		queue_work(fnic_event_queue, &event->event_work);
+		skb_queue_tail(&fnic->frame_queue, skb);
+		queue_work(fnic_event_queue, &fnic->frame_work);
 
 	} else {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);


