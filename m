From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Fri, 20 Nov 2015 08:50:00 -0800
Message-ID: <564F4F38.9040505@sandisk.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de> <564B697A.2020601@sandisk.com>
 <564C2F01.6020407@dev.mellanox.co.il> <564CC15E.7030602@sandisk.com>
 <20151120101644.GC24298@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151120101644.GC24298@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/20/2015 02:16 AM, Christoph Hellwig wrote:
> On Wed, Nov 18, 2015 at 10:20:14AM -0800, Bart Van Assche wrote:
>> Are you perhaps referring to the sysfs CPU mask that allows to control
>> workqueue affinity ?
> 
> I think he is referring to the defintion of WQ_UNBOUND:
> 
>    WQ_UNBOUND
> 
> 	Work items queued to an unbound wq are served by the special
> 	woker-pools which host workers which are not bound to any
> 	specific CPU.  This makes the wq behave as a simple execution
> 	context provider without concurrency management.  The unbound
> 	worker-pools try to start execution of work items as soon as
> 	possible.  Unbound wq sacrifices locality but is useful for
> 	the following cases.
> 
> 	* Wide fluctuation in the concurrency level requirement is
> 	  expected and using bound wq may end up creating large number
> 	  of mostly unused workers across different CPUs as the issuer
> 	  hops through different CPUs.
> 
> 	* Long running CPU intensive workloads which can be better
> 	  managed by the system scheduler.
 
Hello Christoph,

The comment about locality in the above quote is interesting. How about
modifying patch 2/9 as indicated below ? The modification below does not
change the behavior of this patch if ib_cq.w.cpu is not modified. And it
allows users who care about locality and who want to skip the scheduler
overhead by setting ib_cq.w.cpu to the index of the CPU they want the
work to be processed on.

Thanks,

Bart.

---
 drivers/infiniband/core/cq.c | 11 ++++++-----
 include/rdma/ib_verbs.h      |  5 ++++-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index bf2a079..4d80d8c 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -94,18 +94,18 @@ static void ib_cq_completion_softirq(struct ib_cq *cq, void *private)
 
 static void ib_cq_poll_work(struct work_struct *work)
 {
-	struct ib_cq *cq = container_of(work, struct ib_cq, work);
+	struct ib_cq *cq = container_of(work, struct ib_cq, w.work);
 	int completed;
 
 	completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE);
 	if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
 	    ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
-		queue_work(ib_comp_wq, &cq->work);
+		queue_work_on(cq->w.cpu, ib_comp_wq, &cq->w.work);
 }
 
 static void ib_cq_completion_workqueue(struct ib_cq *cq, void *private)
 {
-	queue_work(ib_comp_wq, &cq->work);
+	queue_work_on(cq->w.cpu, ib_comp_wq, &cq->w.work);
 }
 
 /**
@@ -159,7 +159,8 @@ struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
 		break;
 	case IB_POLL_WORKQUEUE:
 		cq->comp_handler = ib_cq_completion_workqueue;
-		INIT_WORK(&cq->work, ib_cq_poll_work);
+		INIT_WORK(&cq->w.work, ib_cq_poll_work);
+		cq->w.cpu = WORK_CPU_UNBOUND;
 		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 		break;
 	default:
@@ -195,7 +196,7 @@ void ib_free_cq(struct ib_cq *cq)
 		irq_poll_disable(&cq->iop);
 		break;
 	case IB_POLL_WORKQUEUE:
-		flush_work(&cq->work);
+		flush_work(&cq->w.work);
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f59a8d3..b1344f8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1291,7 +1291,10 @@ struct ib_cq {
 	struct ib_wc		*wc;
 	union {
 		struct irq_poll		iop;
-		struct work_struct	work;
+		struct {
+			struct work_struct	work;
+			int			cpu;
+		} w;
 	};
 };
 
-- 
2.1.4
