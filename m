From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 52/54] libfc: fix an issue of pending exch/es after i/f
	destroyed or rmmod fcoe
Date: Tue, 03 Nov 2009 11:50:10 -0800
Message-ID: <20091103195010.4085.48488.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36436 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbZKCTuF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:50:05 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

All exches must be freed before its EM mempool destroyed in this
case but currently some exches could be still pending in their
scheduled delayed work after EM mempool is destroyed causing
this issue discussed and reported in this latest email thread:-

 http://www.open-fcoe.org/pipermail/devel/2009-October/004788.html

This patch fixes this issue by adding dedicated work queue thread
fc_exch_workqueue for exch delayed work and then flush this work
queue before destroying EM mempool.

The cancel_delayed_work_sync cannot be called during final
fc_exch_reset due to lport and exch locking ordering, so removes
related comment block not relevant any more with this patch.

Reported-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 0f45bb8..19d711c 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -38,6 +38,7 @@ u16	fc_cpu_mask;		/* cpu mask for possible cpus */
 EXPORT_SYMBOL(fc_cpu_mask);
 static u16	fc_cpu_order;	/* 2's power to represent total possible cpus */
 static struct kmem_cache *fc_em_cachep;	       /* cache for exchanges */
+struct workqueue_struct *fc_exch_workqueue;
 
 /*
  * Structure and function definitions for managing Fibre Channel Exchanges
@@ -427,8 +428,8 @@ static inline void fc_exch_timer_set_locked(struct fc_exch *ep,
 
 	FC_EXCH_DBG(ep, "Exchange timer armed\n");
 
-	if (schedule_delayed_work(&ep->timeout_work,
-				  msecs_to_jiffies(timer_msec)))
+	if (queue_delayed_work(fc_exch_workqueue, &ep->timeout_work,
+			       msecs_to_jiffies(timer_msec)))
 		fc_exch_hold(ep);		/* hold for timer */
 }
 
@@ -1619,12 +1620,6 @@ static void fc_exch_reset(struct fc_exch *ep)
 
 	spin_lock_bh(&ep->ex_lock);
 	ep->state |= FC_EX_RST_CLEANUP;
-	/*
-	 * we really want to call del_timer_sync, but cannot due
-	 * to the lport calling with the lport lock held (some resp
-	 * functions can also grab the lport lock which could cause
-	 * a deadlock).
-	 */
 	if (cancel_delayed_work(&ep->timeout_work))
 		atomic_dec(&ep->ex_refcnt);	/* drop hold for timer */
 	resp = ep->resp;
@@ -2203,6 +2198,7 @@ void fc_exch_mgr_free(struct fc_lport *lport)
 {
 	struct fc_exch_mgr_anchor *ema, *next;
 
+	flush_workqueue(fc_exch_workqueue);
 	list_for_each_entry_safe(ema, next, &lport->ema_list, ema_list)
 		fc_exch_mgr_del(ema);
 }
@@ -2338,6 +2334,9 @@ int fc_setup_exch_mgr()
 	}
 	fc_cpu_mask--;
 
+	fc_exch_workqueue = create_singlethread_workqueue("fc_exch_workqueue");
+	if (!fc_exch_workqueue)
+		return -ENOMEM;
 	return 0;
 }
 
@@ -2346,5 +2345,6 @@ int fc_setup_exch_mgr()
  */
 void fc_destroy_exch_mgr()
 {
+	destroy_workqueue(fc_exch_workqueue);
 	kmem_cache_destroy(fc_em_cachep);
 }

