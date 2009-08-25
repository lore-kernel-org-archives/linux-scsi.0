From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 64/64] fcoe: flush per-cpu thread work when destroying
	interface
Date: Tue, 25 Aug 2009 14:04:08 -0700
Message-ID: <20090825210408.1553.94579.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9227 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237AbZHYVEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:04:06 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

This fixes one cause of an occational problem when unloading
libfc where the exchange manager pool doesn't have all items freed.

The existing WARN_ON(mp->total_exches <= 0) isn't hit.
However, note that total_exches is decremented when the
exchange is completed, and it can be held with a refcnt
for a while after that.

I'm not sure what the offending exchange is, but I suspect
it is an incoming request, because outgoing state machines
should be all stopped at this point.

Note that although receive is stopped before the exchange
manager is freed, there could still be active threads
handling received frames.

This patch flushes the queues by allocating a new skb
and sending it through, and have the thread handle
this new skb specially.  This is similar to the way the work
queues are flushed now by putting work items in them and waiting
until they make it through the queue.

An skb->destructor function is used to inform us of
the completion of the flush, and the fr_dev() is left
NULL to indicate to fcoe_percpu_receive_thread() that
the skb should be just freed.  There's already a check
for the lp being NULL which prints a message.
We skip printing the message if the destructor is for flushing.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ac481ad..704b8e0 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -57,6 +57,9 @@ MODULE_PARM_DESC(ddp_min, "Minimum I/O size in bytes for "	\
 
 DEFINE_MUTEX(fcoe_config_mutex);
 
+/* fcoe_percpu_clean completion.  Waiter protected by fcoe_create_mutex */
+static DECLARE_COMPLETION(fcoe_flush_completion);
+
 /* fcoe host list */
 /* must only by accessed under the RTNL mutex */
 LIST_HEAD(fcoe_hostlist);
@@ -827,7 +830,7 @@ static void fcoe_percpu_thread_create(unsigned int cpu)
 	thread = kthread_create(fcoe_percpu_receive_thread,
 				(void *)p, "fcoethread/%d", cpu);
 
-	if (likely(!IS_ERR(p->thread))) {
+	if (likely(!IS_ERR(thread))) {
 		kthread_bind(thread, cpu);
 		wake_up_process(thread);
 
@@ -1300,6 +1303,15 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 }
 
 /**
+ * fcoe_percpu_flush_done() - Indicate percpu queue flush completion.
+ * @skb: the skb being completed.
+ */
+static void fcoe_percpu_flush_done(struct sk_buff *skb)
+{
+	complete(&fcoe_flush_completion);
+}
+
+/**
  * fcoe_percpu_receive_thread() - recv thread per cpu
  * @arg: ptr to the fcoe per cpu struct
  *
@@ -1338,7 +1350,8 @@ int fcoe_percpu_receive_thread(void *arg)
 		fr = fcoe_dev_from_skb(skb);
 		lp = fr->fr_dev;
 		if (unlikely(lp == NULL)) {
-			FCOE_NETDEV_DBG(skb->dev, "Invalid HBA Structure");
+			if (skb->destructor != fcoe_percpu_flush_done)
+				FCOE_NETDEV_DBG(skb->dev, "NULL lport in skb");
 			kfree_skb(skb);
 			continue;
 		}
@@ -1799,6 +1812,13 @@ int fcoe_link_ok(struct fc_lport *lp)
 /**
  * fcoe_percpu_clean() - Clear the pending skbs for an lport
  * @lp: the fc_lport
+ *
+ * Must be called with fcoe_create_mutex held to single-thread completion.
+ *
+ * This flushes the pending skbs by adding a new skb to each queue and
+ * waiting until they are all freed.  This assures us that not only are
+ * there no packets that will be handled by the lport, but also that any
+ * threads already handling packet have returned.
  */
 void fcoe_percpu_clean(struct fc_lport *lp)
 {
@@ -1823,7 +1843,25 @@ void fcoe_percpu_clean(struct fc_lport *lp)
 				kfree_skb(skb);
 			}
 		}
+
+		if (!pp->thread || !cpu_online(cpu)) {
+			spin_unlock_bh(&pp->fcoe_rx_list.lock);
+			continue;
+		}
+
+		skb = dev_alloc_skb(0);
+		if (!skb) {
+			spin_unlock_bh(&pp->fcoe_rx_list.lock);
+			continue;
+		}
+		skb->destructor = fcoe_percpu_flush_done;
+
+		__skb_queue_tail(&pp->fcoe_rx_list, skb);
+		if (pp->fcoe_rx_list.qlen == 1)
+			wake_up_process(pp->thread);
 		spin_unlock_bh(&pp->fcoe_rx_list.lock);
+
+		wait_for_completion(&fcoe_flush_completion);
 	}
 }
 

