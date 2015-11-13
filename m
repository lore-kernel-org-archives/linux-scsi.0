From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Fri, 13 Nov 2015 14:46:43 +0100
Message-ID: <1447422410-20891-3-git-send-email-hch@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447422410-20891-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This adds an abstraction that allows ULP to simply pass a completion
object and completion callback with each submitted WR and let the RDMA
core handle the nitty gritty details of how to handle completion
interrupts and poll the CQ.

In detail there is a new ib_cqe structure which just contains the
completion callback, and which can be used to get at the containing
object using container_of.  It is pointed to by the WR and WC as an
alternative to the wr_id field, similar to how many ULPs already use
the field to store a pointer using casts.

A driver using the new completion callbacks allocates it's CQs using
the new ib_create_cq API, which in addition to the number of CQEs and
the completion vectors also takes a mode on how we poll for CQEs.
Three modes are available: direct for drivers that never take CQ
interrupts and just poll for them, softirq to poll from softirq context
using the to be renamed blk-iopoll infrastructure which takes care of
rearming and budgeting, or a workqueue for consumer who want to be
called from user context.

Thanks a lot to Sagi Grimberg who helped reviewing the API, wrote
the current version of the workqueue code because my two previous
attempts sucked too much and converted the iSER initiator to the new
API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/Kconfig              |   1 +
 drivers/infiniband/core/Makefile        |   2 +-
 drivers/infiniband/core/cq.c            | 208 ++++++++++++++++++++++++++++++++
 drivers/infiniband/core/device.c        |  15 ++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c     |   6 +-
 include/rdma/ib_verbs.h                 |  38 +++++-
 7 files changed, 263 insertions(+), 9 deletions(-)
 create mode 100644 drivers/infiniband/core/cq.c

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index aa26f3c..282ec0b 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -5,6 +5,7 @@ menuconfig INFINIBAND
 	depends on NET
 	depends on INET
 	depends on m || IPV6 != m
+	select IRQ_POLL
 	---help---
 	  Core support for InfiniBand (IB).  Make sure to also select
 	  any protocols you wish to use as well as drivers for your
diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index d43a899..ae48d8740 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_INFINIBAND_USER_MAD) +=	ib_umad.o
 obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 					$(user_access-y)
 
-ib_core-y :=			packer.o ud_header.o verbs.o sysfs.o \
+ib_core-y :=			packer.o ud_header.o verbs.o cq.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o \
 				roce_gid_mgmt.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
new file mode 100644
index 0000000..d9eb796
--- /dev/null
+++ b/drivers/infiniband/core/cq.c
@@ -0,0 +1,208 @@
+/*
+ * Copyright (c) 2015 HGST, a Western Digital Company.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <rdma/ib_verbs.h>
+
+/* # of WCs to poll for with a single call to ib_poll_cq */
+#define IB_POLL_BATCH			16
+
+/* # of WCs to iterate over before yielding */
+#define IB_POLL_BUDGET_IRQ		256
+#define IB_POLL_BUDGET_WORKQUEUE	65536
+
+#define IB_POLL_FLAGS \
+	(IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS)
+
+static int __ib_process_cq(struct ib_cq *cq, int budget)
+{
+	int i, n, completed = 0;
+
+	while ((n = ib_poll_cq(cq, IB_POLL_BATCH, cq->wc)) > 0) {
+		for (i = 0; i < n; i++) {
+			struct ib_wc *wc = &cq->wc[i];
+
+			if (wc->wr_cqe)
+				wc->wr_cqe->done(cq, wc);
+			else
+				WARN_ON_ONCE(wc->status == IB_WC_SUCCESS);
+		}
+
+		completed += n;
+		if (completed >= budget)
+			break;
+	}
+
+	return completed;
+}
+
+/**
+ * ib_process_direct_cq - process a CQ in caller context
+ * @cq:		CQ to process
+ *
+ * This function is used to process all outstanding CQ entries on a
+ * %IB_POLL_DIRECT CQ.  It does not offload CQ processing to a different
+ * context and does not ask from completion interrupts from the HCA.
+ */
+void ib_process_cq_direct(struct ib_cq *cq)
+{
+	WARN_ON_ONCE(cq->poll_ctx != IB_POLL_DIRECT);
+
+	__ib_process_cq(cq, INT_MAX);
+}
+EXPORT_SYMBOL(ib_process_cq_direct);
+
+static void ib_cq_completion_direct(struct ib_cq *cq, void *private)
+{
+	WARN_ONCE(1, "got unsolicited completion for CQ 0x%p\n", cq);
+}
+
+static int ib_poll_handler(struct irq_poll *iop, int budget)
+{
+	struct ib_cq *cq = container_of(iop, struct ib_cq, iop);
+	int completed;
+
+	completed = __ib_process_cq(cq, budget);
+	if (completed < budget) {
+		irq_poll_complete(&cq->iop);
+		if (ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0) {
+			if (!irq_poll_sched_prep(&cq->iop))
+				irq_poll_sched(&cq->iop);
+		}
+			
+	}
+
+	return completed;
+}
+
+static void ib_cq_completion_softirq(struct ib_cq *cq, void *private)
+{
+	if (!irq_poll_sched_prep(&cq->iop))
+		irq_poll_sched(&cq->iop);
+}
+
+static void ib_cq_poll_work(struct work_struct *work)
+{
+	struct ib_cq *cq = container_of(work, struct ib_cq, work);
+	int completed;
+
+	completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE);
+	if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
+	    ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
+		queue_work(ib_comp_wq, &cq->work);
+}
+
+static void ib_cq_completion_workqueue(struct ib_cq *cq, void *private)
+{
+	queue_work(ib_comp_wq, &cq->work);
+}
+
+/**
+ * ib_alloc_cq - allocate a completion queue
+ * @dev:		device to allocate the CQ for
+ * @private:		driver private data, accessible from cq->cq_context
+ * @nr_cqe:		number of CQEs to allocate
+ * @comp_vector:	HCA completion vectors for this CQ
+ * @poll_ctx:		context to poll the CQ from.
+ *
+ * This is the proper interface to allocate a CQ for in-kernel users. A
+ * CQ allocated with this interface will automatically be polled from the
+ * specified context.  The ULP needs must use wr->wr_cqe instead of wr->wr_id
+ * to use this CQ abstraction.
+ */
+struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
+		int nr_cqe, int comp_vector, enum ib_poll_context poll_ctx)
+{
+	struct ib_cq_init_attr cq_attr = {
+		.cqe		= nr_cqe,
+		.comp_vector	= comp_vector,
+	};
+	struct ib_cq *cq;
+	int ret = -ENOMEM;
+
+	cq = dev->create_cq(dev, &cq_attr, NULL, NULL);
+	if (IS_ERR(cq))
+		return cq;
+
+	cq->device = dev;
+	cq->uobject = NULL;
+	cq->event_handler = NULL;
+	cq->cq_context = private;;
+	cq->poll_ctx = poll_ctx;
+	atomic_set(&cq->usecnt, 0);
+
+	cq->wc = kmalloc_array(IB_POLL_BATCH, sizeof(*cq->wc), GFP_KERNEL);
+	if (!cq->wc)
+		goto out_destroy_cq;
+
+	switch (cq->poll_ctx) {
+	case IB_POLL_DIRECT:
+		cq->comp_handler = ib_cq_completion_direct;
+		break;
+	case IB_POLL_SOFTIRQ:
+		cq->comp_handler = ib_cq_completion_softirq;
+
+		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
+		irq_poll_enable(&cq->iop);
+		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
+		break;
+	case IB_POLL_WORKQUEUE:
+		cq->comp_handler = ib_cq_completion_workqueue;
+		INIT_WORK(&cq->work, ib_cq_poll_work);
+		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
+		break;
+	default:
+		ret = -EINVAL;
+		goto out_free_wc;
+	}
+
+	return cq;
+
+out_free_wc:
+	kfree(cq->wc);
+out_destroy_cq:
+	cq->device->destroy_cq(cq);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(ib_alloc_cq);
+
+/**
+ * ib_free_cq - free a completion queue
+ * @cq:		completion queue to free.
+ */
+void ib_free_cq(struct ib_cq *cq)
+{
+	int ret;
+
+	if (WARN_ON_ONCE(atomic_read(&cq->usecnt)))
+		return;
+
+	switch (cq->poll_ctx) {
+	case IB_POLL_DIRECT:
+		break;
+	case IB_POLL_SOFTIRQ:
+		irq_poll_disable(&cq->iop);
+		break;
+	case IB_POLL_WORKQUEUE:
+		flush_work(&cq->work);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+
+	kfree(cq->wc);
+	ret = cq->device->destroy_cq(cq);
+	WARN_ON_ONCE(ret);
+}
+EXPORT_SYMBOL(ib_free_cq);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 0315bd7..f0ac300 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -58,6 +58,7 @@ struct ib_client_data {
 	bool		  going_down;
 };
 
+struct workqueue_struct *ib_comp_wq;
 struct workqueue_struct *ib_wq;
 EXPORT_SYMBOL_GPL(ib_wq);
 
@@ -934,10 +935,18 @@ static int __init ib_core_init(void)
 	if (!ib_wq)
 		return -ENOMEM;
 
+	ib_comp_wq = alloc_workqueue("ib-comp-wq",
+			WQ_UNBOUND | WQ_HIGHPRI | WQ_MEM_RECLAIM,
+			WQ_UNBOUND_MAX_ACTIVE);
+	if (!ib_comp_wq) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
 	ret = class_register(&ib_class);
 	if (ret) {
 		printk(KERN_WARNING "Couldn't create InfiniBand device class\n");
-		goto err;
+		goto err_comp;
 	}
 
 	ret = ibnl_init();
@@ -952,7 +961,8 @@ static int __init ib_core_init(void)
 
 err_sysfs:
 	class_unregister(&ib_class);
-
+err_comp:
+	destroy_workqueue(ib_comp_wq);
 err:
 	destroy_workqueue(ib_wq);
 	return ret;
@@ -963,6 +973,7 @@ static void __exit ib_core_cleanup(void)
 	ib_cache_cleanup();
 	ibnl_cleanup();
 	class_unregister(&ib_class);
+	destroy_workqueue(ib_comp_wq);
 	/* Make sure that any pending umem accounting work is done. */
 	destroy_workqueue(ib_wq);
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 737d273..d315367 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -70,7 +70,6 @@ static struct ib_qp_attr ipoib_cm_err_attr = {
 #define IPOIB_CM_RX_DRAIN_WRID 0xffffffff
 
 static struct ib_send_wr ipoib_cm_rx_drain_wr = {
-	.wr_id = IPOIB_CM_RX_DRAIN_WRID,
 	.opcode = IB_WR_SEND,
 };
 
@@ -223,6 +222,7 @@ static void ipoib_cm_start_rx_drain(struct ipoib_dev_priv *priv)
 	 * error" WC will be immediately generated for each WR we post.
 	 */
 	p = list_entry(priv->cm.rx_flush_list.next, typeof(*p), list);
+	ipoib_cm_rx_drain_wr.wr_id = IPOIB_CM_RX_DRAIN_WRID;
 	if (ib_post_send(p->qp, &ipoib_cm_rx_drain_wr, &bad_wr))
 		ipoib_warn(priv, "failed to post drain wr\n");
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 62b6cba..3027824 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -457,10 +457,11 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
 static void srp_destroy_qp(struct srp_rdma_ch *ch)
 {
 	static struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
-	static struct ib_recv_wr wr = { .wr_id = SRP_LAST_WR_ID };
+	static struct ib_recv_wr wr = { 0 };
 	struct ib_recv_wr *bad_wr;
 	int ret;
 
+	wr.wr_id = SRP_LAST_WR_ID;
 	/* Destroying a QP and reusing ch->done is only safe if not connected */
 	WARN_ON_ONCE(ch->connected);
 
@@ -1042,13 +1043,14 @@ static int srp_inv_rkey(struct srp_rdma_ch *ch, u32 rkey)
 	struct ib_send_wr *bad_wr;
 	struct ib_send_wr wr = {
 		.opcode		    = IB_WR_LOCAL_INV,
-		.wr_id		    = LOCAL_INV_WR_ID_MASK,
 		.next		    = NULL,
 		.num_sge	    = 0,
 		.send_flags	    = 0,
 		.ex.invalidate_rkey = rkey,
 	};
 
+	wr.wr_id = LOCAL_INV_WR_ID_MASK;
+
 	return ib_post_send(ch->qp, &wr, &bad_wr);
 }
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 45ce36e..e11e038 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -49,6 +49,7 @@
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 #include <linux/socket.h>
+#include <linux/irq_poll.h>
 #include <uapi/linux/if_ether.h>
 
 #include <linux/atomic.h>
@@ -56,6 +57,7 @@
 #include <asm/uaccess.h>
 
 extern struct workqueue_struct *ib_wq;
+extern struct workqueue_struct *ib_comp_wq;
 
 union ib_gid {
 	u8	raw[16];
@@ -710,7 +712,10 @@ enum ib_wc_flags {
 };
 
 struct ib_wc {
-	u64			wr_id;
+	union {
+		u64		wr_id;
+		struct ib_cqe	*wr_cqe;
+	};
 	enum ib_wc_status	status;
 	enum ib_wc_opcode	opcode;
 	u32			vendor_err;
@@ -1014,6 +1019,10 @@ struct ib_sge {
 	u32	lkey;
 };
 
+struct ib_cqe {
+	void (*done)(struct ib_cq *cq, struct ib_wc *wc);
+};
+
 /**
  * struct ib_mw_bind_info - Parameters for a memory window bind operation.
  * @mr: A memory region to bind the memory window to.
@@ -1033,7 +1042,10 @@ struct ib_mw_bind_info {
 
 struct ib_send_wr {
 	struct ib_send_wr      *next;
-	u64			wr_id;
+	union {
+		u64		wr_id;
+		struct ib_cqe	*wr_cqe;
+	};
 	struct ib_sge	       *sg_list;
 	int			num_sge;
 	enum ib_wr_opcode	opcode;
@@ -1127,7 +1139,10 @@ static inline struct ib_sig_handover_wr *sig_handover_wr(struct ib_send_wr *wr)
 
 struct ib_recv_wr {
 	struct ib_recv_wr      *next;
-	u64			wr_id;
+	union {
+		u64		wr_id;
+		struct ib_cqe	*wr_cqe;
+	};
 	struct ib_sge	       *sg_list;
 	int			num_sge;
 };
@@ -1258,6 +1273,12 @@ struct ib_ah {
 
 typedef void (*ib_comp_handler)(struct ib_cq *cq, void *cq_context);
 
+enum ib_poll_context {
+	IB_POLL_DIRECT,		/* caller context, no hw completions */
+	IB_POLL_SOFTIRQ,	/* poll from softirq context */
+	IB_POLL_WORKQUEUE,	/* poll from workqueue */
+};
+
 struct ib_cq {
 	struct ib_device       *device;
 	struct ib_uobject      *uobject;
@@ -1266,6 +1287,12 @@ struct ib_cq {
 	void                   *cq_context;
 	int               	cqe;
 	atomic_t          	usecnt; /* count number of work queues */
+	enum ib_poll_context	poll_ctx;
+	struct ib_wc		*wc;
+	union {
+		struct irq_poll		iop;
+		struct work_struct	work;
+	};
 };
 
 struct ib_srq {
@@ -2447,6 +2474,11 @@ static inline int ib_post_recv(struct ib_qp *qp,
 	return qp->device->post_recv(qp, recv_wr, bad_recv_wr);
 }
 
+struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
+		int nr_cqe, int comp_vector, enum ib_poll_context poll_ctx);
+void ib_free_cq(struct ib_cq *cq);
+void ib_process_cq_direct(struct ib_cq *cq);
+
 /**
  * ib_create_cq - Creates a CQ on the specified device.
  * @device: The device on which to create the CQ.
-- 
1.9.1
