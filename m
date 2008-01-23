From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/10] [FCoE] Remove ASSERTs from libsa.
Date: Tue, 22 Jan 2008 16:36:40 -0800
Message-ID: <20080123003640.8469.43628.stgit@fritz>
References: <20080123003523.8469.62236.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24523 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbYAWAuc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 19:50:32 -0500
In-Reply-To: <20080123003523.8469.62236.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/ofc/libsa/sa_event.c     |   24 ------------------------
 drivers/scsi/ofc/libsa/sa_hash_kern.c |    7 -------
 drivers/scsi/ofc/libsa/sa_timer.c     |    1 -
 3 files changed, 0 insertions(+), 32 deletions(-)


diff --git a/drivers/scsi/ofc/libsa/sa_event.c b/drivers/scsi/ofc/libsa/sa_event.c
index cf6596a..7d9850b 100644
--- a/drivers/scsi/ofc/libsa/sa_event.c
+++ b/drivers/scsi/ofc/libsa/sa_event.c
@@ -18,7 +18,6 @@
  */
 
 #include "sa_kernel.h"
-#include "sa_assert.h"
 #include "ofc_dbg.h"
 #include "sa_event.h"
 #include "queue.h"
@@ -66,7 +65,6 @@ struct sa_event_list *sa_event_list_alloc(void)
 		TAILQ_INIT(&lp->se_head);
 		atomic_set(&lp->se_refcnt, 1);
 		spin_lock_init(&lp->se_lock);
-		ASSERT(sa_event_list_initialized(lp));
 	}
 	return lp;
 }
@@ -77,7 +75,6 @@ void sa_event_list_free(struct sa_event_list *lp)
 	struct sa_event *next;
 	unsigned long flags;
 
-	ASSERT(sa_event_list_initialized(lp));
 	spin_lock_irqsave(&lp->se_lock, flags);
 	TAILQ_FOREACH_SAFE(ev, &lp->se_head, se_list, next) {
 		if ((ev->se_flags & SEV_MARK) == 0) {
@@ -91,19 +88,16 @@ void sa_event_list_free(struct sa_event_list *lp)
 
 static void sa_event_list_free_int(struct sa_event_list *lp)
 {
-	ASSERT(!atomic_read(&lp->se_refcnt));
 	sa_free(lp);
 }
 
 static void sa_event_list_hold(struct sa_event_list *lp)
 {
 	atomic_inc(&lp->se_refcnt);
-	ASSERT(atomic_read(&lp->se_refcnt));
 }
 
 static void sa_event_list_release(struct sa_event_list *lp)
 {
-	ASSERT(atomic_read(&lp->se_refcnt));
 	if (atomic_dec_and_test(&lp->se_refcnt))
 		sa_event_list_free_int(lp);
 }
@@ -120,8 +114,6 @@ struct sa_event *sa_event_enq(struct sa_event_list *lp,
 	struct sa_event_head *hp;
 	unsigned long flags;
 
-	ASSERT(sa_event_list_initialized(lp));
-	ASSERT(handler != NULL);
 	spin_lock_irqsave(&lp->se_lock, flags);
 	hp = &lp->se_head;
 	TAILQ_FOREACH(ev, &lp->se_head, se_list) {
@@ -147,8 +139,6 @@ void sa_event_deq_ev(struct sa_event_list *lp, struct sa_event *ev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&lp->se_lock, flags);
-	ASSERT(sa_event_list_initialized(lp));
-	ASSERT((ev->se_flags & SEV_MARK) == 0);
 	TAILQ_REMOVE(&lp->se_head, ev, se_list);
 	spin_unlock_irqrestore(&lp->se_lock, flags);
 	sa_free(ev);
@@ -162,7 +152,6 @@ sa_event_deq(struct sa_event_list *lp, void (*handler) (int, void *), void *arg)
 	unsigned long flags;
 
 	spin_lock_irqsave(&lp->se_lock, flags);
-	ASSERT(sa_event_list_initialized(lp));
 
 	TAILQ_FOREACH_SAFE(ev, &lp->se_head, se_list, next) {
 		if (ev->se_handler == handler && ev->se_arg == arg) {
@@ -187,7 +176,6 @@ void sa_event_call(struct sa_event_list *lp, int rc)
 	unsigned long flags;
 
 	spin_lock_irqsave(&lp->se_lock, flags);
-	ASSERT(sa_event_list_initialized(lp));
 	memset(&mark, 0, sizeof(mark));
 	mark.se_flags = SEV_MARK;
 
@@ -202,7 +190,6 @@ void sa_event_call(struct sa_event_list *lp, int rc)
 		TAILQ_INSERT_AFTER(&lp->se_head, ev, &mark, se_list);
 		spin_unlock_irqrestore(&lp->se_lock, flags);
 
-		ASSERT(ev->se_handler != NULL);
 		(*ev->se_handler) (rc, ev->se_arg);
 
 		spin_lock_irqsave(&lp->se_lock, flags);
@@ -218,9 +205,6 @@ void sa_event_call(struct sa_event_list *lp, int rc)
  */
 void sa_event_call_defer(struct sa_event_list *lp, int event)
 {
-	ASSERT(sa_event_list_initialized(lp));
-	ASSERT(event >= 0);
-	ASSERT(event < sizeof(lp->se_pending_events) * 8);
 	atomic_set_mask(1 << event, &lp->se_pending_events);
 }
 
@@ -229,9 +213,6 @@ void sa_event_call_defer(struct sa_event_list *lp, int event)
  */
 void sa_event_call_cancel(struct sa_event_list *lp, int event)
 {
-	ASSERT(sa_event_list_initialized(lp));
-	ASSERT(event >= 0);
-	ASSERT(event < sizeof(lp->se_pending_events) * 8);
 	atomic_clear_mask(1 << event, &lp->se_pending_events);
 }
 
@@ -243,13 +224,8 @@ void sa_event_send_deferred(struct sa_event_list *lp)
 	u_int32_t mask;
 	u_int event;
 
-	ASSERT(sa_event_list_initialized(lp));
-	ASSERT(sizeof(mask) == sizeof(lp->se_pending_events));
-
 	while ((mask = atomic_read(&lp->se_pending_events)) != 0) {
 		event = ffs(mask) - 1;
-		ASSERT(event >= 0);
-		ASSERT(event < sizeof(lp->se_pending_events) * 8);
 		atomic_clear_mask(1 << event, &lp->se_pending_events);
 		sa_event_call(lp, event);
 	}
diff --git a/drivers/scsi/ofc/libsa/sa_hash_kern.c b/drivers/scsi/ofc/libsa/sa_hash_kern.c
index 6046758..f1103a5 100644
--- a/drivers/scsi/ofc/libsa/sa_hash_kern.c
+++ b/drivers/scsi/ofc/libsa/sa_hash_kern.c
@@ -18,7 +18,6 @@
  */
 
 #include "sa_kernel.h"
-#include "sa_assert.h"
 #include "ofc_dbg.h"
 #include "sa_hash.h"
 
@@ -51,9 +50,6 @@ struct sa_hash *sa_hash_create(const struct sa_hash_type *tp, uint32_t req_size)
 	for (size = 4; size < (1UL << 31); size <<= 1)
 		if (size >= req_size)
 			break;
-	ASSERT(size >= req_size);
-	ASSERT(size < (1UL << 31));
-	ASSERT((size & (size - 1)) == 0);	/* test for a power of 2 */
 
 	len = sizeof(*hp) + size * sizeof(struct hlist_head);
 	hp = sa_malloc(len);
@@ -67,7 +63,6 @@ struct sa_hash *sa_hash_create(const struct sa_hash_type *tp, uint32_t req_size)
 
 void sa_hash_destroy(struct sa_hash *hp)
 {
-	ASSERT(hp->sh_entries == 0);
 	sa_free(hp);
 }
 
@@ -117,7 +112,6 @@ void sa_hash_insert(struct sa_hash *hp, const sa_hash_key_t key, void *ep)
 	hhp = sa_hash_bucket(hp, key);
 	hlist_add_head_rcu(lp, hhp);
 	hp->sh_entries++;
-	ASSERT(hp->sh_entries > 0);	/* check for overflow */
 }
 
 /*
@@ -144,5 +138,4 @@ sa_hash_iterate(struct sa_hash *hp,
 	}
 	if (count != hp->sh_entries)
 		OFC_DBG("sh_entries %d != count %d", hp->sh_entries, count);
-	ASSERT(count == hp->sh_entries);
 }
diff --git a/drivers/scsi/ofc/libsa/sa_timer.c b/drivers/scsi/ofc/libsa/sa_timer.c
index 0e3d422..df87fbd 100644
--- a/drivers/scsi/ofc/libsa/sa_timer.c
+++ b/drivers/scsi/ofc/libsa/sa_timer.c
@@ -22,7 +22,6 @@
 #include <linux/timer.h>
 #include <linux/jiffies.h>
 
-#include "sa_assert.h"
 #include "ofc_dbg.h"
 #include "sa_timer.h"
 

