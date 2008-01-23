From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH] Removed sa_timer functions as part of libsa cleanup
Date: Wed, 23 Jan 2008 03:27:10 -0800
Message-ID: <20080123112710.28745.80782.stgit@vdinit.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:44809 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbYAWTdj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2008 14:33:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Instead used standard Linux timer functions directly

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/ofc/include/sa_timer.h         |   96 ---------------------------
 drivers/scsi/ofc/libfc/fc_disc_targ.c       |   20 +++---
 drivers/scsi/ofc/libfc/fc_exch.c            |   19 +++--
 drivers/scsi/ofc/libfc/fc_exch_impl.h       |    4 +
 drivers/scsi/ofc/libfc/fc_local_port.c      |   19 +++--
 drivers/scsi/ofc/libfc/fc_local_port_impl.h |   10 ++-
 drivers/scsi/ofc/libfc/fc_sess.c            |   18 +++--
 drivers/scsi/ofc/libfc/fc_sess_impl.h       |    4 +
 drivers/scsi/ofc/libfc/fcs_state_impl.h     |    2 -
 drivers/scsi/ofc/libsa/Makefile             |    3 -
 drivers/scsi/ofc/libsa/sa_timer.c           |   80 -----------------------
 11 files changed, 53 insertions(+), 222 deletions(-)

diff --git a/drivers/scsi/ofc/include/sa_timer.h b/drivers/scsi/ofc/include/sa_timer.h
deleted file mode 100644
index 9c06c05..0000000
--- a/drivers/scsi/ofc/include/sa_timer.h
+++ /dev/null
@@ -1,96 +0,0 @@
-/*
- * Copyright(c) 2007 Intel Corporation. All rights reserved.
- * 
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- * 
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- * 
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * 
- * Maintained at www.Open-FCoE.org
- */
-
-#ifndef _LIBSA_TIMER_H_
-#define _LIBSA_TIMER_H_
-
-#include <linux/timer.h>
-
-/*
- * Timer facility.
- */
-
-struct sa_timer {
-	struct timer_list tm_list;
-};
-
-
-#define SA_TIMER_UNITS  (1000 * 1000UL)	/* number of timer ticks per second */
-
-/*
- * Initialize a timer structure.  Set handler.
- */
-static inline void sa_timer_init(struct sa_timer *tm,
-					void (*handler)(void *), void *arg)
-{
-	setup_timer(&tm->tm_list, (void (*)(unsigned long)) handler,
-			    (unsigned long) arg);
-}
-
-/*
- * Test whether the timer is active.
- */
-static inline int sa_timer_active(struct sa_timer *tm)
-{
-	return timer_pending(&tm->tm_list);
-}
-
-/*
- * Allocate a timer structure.  Set handler.
- */
-struct sa_timer *sa_timer_alloc(void (*)(void *arg), void *arg);
-
-/*
- * Set timer to fire.   Delta is in microseconds from now.
- */
-void sa_timer_set(struct sa_timer *, u_long delta);
-
-/*
- * Cancel timer.
- */
-void sa_timer_cancel(struct sa_timer *);
-
-/*
- * Free (and cancel) timer.
- */
-void sa_timer_free(struct sa_timer *);
-
-
-/*
- * Handle timer checks.  Called from select loop or other periodic function.
- *
- * The struct timeval passed in indicates how much time has passed since
- * the last call, and is set before returning to the maximum amount of time
- * that should elapse before the next call.
- *
- * Returns 1 if any timer handlers were invoked, 0 otherwise.
- */
-int sa_timer_check(struct timeval *);
-
-/*
- * Get time in nanoseconds since some arbitrary time.
- */
-u_int64_t sa_timer_get(void);
-
-/*
- * Get time in seconds since some arbitrary time.
- */
-u_int sa_timer_get_secs(void);
-
-#endif /* _LIBSA_TIMER_H_ */
diff --git a/drivers/scsi/ofc/libfc/fc_disc_targ.c b/drivers/scsi/ofc/libfc/fc_disc_targ.c
index 4906a2b..5c41c75 100644
--- a/drivers/scsi/ofc/libfc/fc_disc_targ.c
+++ b/drivers/scsi/ofc/libfc/fc_disc_targ.c
@@ -22,13 +22,13 @@
  * Actually, this discovers all FC-4 remote ports, including FCP initiators.
  */
 
+#include <linux/timer.h>
 #include "sa_kernel.h"
 #undef LIST_HEAD
 #include "net_types.h"
 
 #include "sa_assert.h"
 #include "ofc_dbg.h"
-#include "sa_timer.h"
 #include "sa_event.h"
 
 #include "fc_encaps.h"
@@ -65,7 +65,7 @@ static int fcdt_new_target(struct fc_local_port *, struct fc_remote_port *,
 static void fcdt_del_target(struct fc_local_port *, struct fc_remote_port *);
 static void fcdt_done(struct fc_local_port *);
 static void fcdt_error(enum fc_event, void *);
-static void fcdt_timeout(void *);
+static void fcdt_timeout(unsigned long);
 static int fcdt_gpn_id_req(struct fc_local_port *, struct fc_remote_port *);
 static void fcdt_gpn_id_resp(struct fc_seq *, struct fc_frame *, void *);
 static void fcdt_gpn_id_error(enum fc_event, void *);
@@ -102,9 +102,8 @@ int fc_disc_targ_register_callback(struct fc_local_port *lp,
 	lp->fl_disc_cb = callback;
 	lp->fl_disc_cb_arg = arg;
 	lp->fl_disc_type = fc4_type;
-	sa_timer_init(&lp->fl_disc_timer, fcdt_timeout, lp);
+	setup_timer(&lp->fl_disc_timer, fcdt_timeout, (unsigned long)lp);
 	fc_local_port_unlock(lp);
-
 	return (0);
 }
 
@@ -116,8 +115,8 @@ int fc_disc_targ_restart(struct fc_local_port *lp)
 {
 	fc_local_port_lock(lp);
 	if (!lp->fl_disc_req && !lp->fl_disc_in_prog) {
-		sa_timer_set(&lp->fl_disc_timer,
-			     lp->fl_disc_holdoff * SA_TIMER_UNITS);
+		mod_timer(&lp->fl_disc_timer,
+			jiffies + msecs_to_jiffies(lp->fl_disc_holdoff * 1000));
 	}
 	lp->fl_disc_req = 1;
 	fc_local_port_unlock(lp);
@@ -173,12 +172,13 @@ static int fcdt_disc_targ(struct fc_local_port *lp)
  */
 static void fcdt_retry(struct fc_local_port *lp)
 {
-	u_long delay = SA_TIMER_UNITS / 2;	/* 500 mS timeout */
+	u_long delay = FCDT_RETRY_DELAY;
 
 	if (!lp->fl_disc_retries)
 		delay /= 4;	/* timeout faster first time */
 	if (lp->fl_disc_retries++ < FCDT_RETRY_LIMIT)
-		sa_timer_set(&lp->fl_disc_timer, delay);
+		mod_timer(&lp->fl_disc_timer,
+			jiffies + msecs_to_jiffies(delay));
 	else
 		fcdt_done(lp);
 }
@@ -467,9 +467,9 @@ static int fcdt_gpn_ft_parse(struct fc_local_port *lp, void *buf, size_t len)
 /*
  * Handle retry of memory allocation for remote ports.
  */
-static void fcdt_timeout(void *lp_arg)
+static void fcdt_timeout(unsigned long lp_arg)
 {
-	struct fc_local_port *lp = lp_arg;
+	struct fc_local_port *lp = (struct fc_local_port *)lp_arg;
 
 	if (lp->fl_disc_in_prog)
 		fcdt_gpn_ft_req(lp);
diff --git a/drivers/scsi/ofc/libfc/fc_exch.c b/drivers/scsi/ofc/libfc/fc_exch.c
index 4a19936..ca0f1a3 100644
--- a/drivers/scsi/ofc/libfc/fc_exch.c
+++ b/drivers/scsi/ofc/libfc/fc_exch.c
@@ -21,12 +21,12 @@
  * Fibre Channel exchange and sequence handling.
  */
 
+#include <linux/timer.h>
 #include "sa_kernel.h"
 #include "sa_assert.h"
 #include "net_types.h"
 #include "ofc_dbg.h"
 #include "sa_hash.h"
-#include "sa_timer.h"
 
 #include <linux/gfp.h>
 
@@ -60,7 +60,7 @@ static void fc_seq_fill_hdr(struct fc_seq *, struct fc_frame *);
 static void fc_exch_hold(struct fc_exch *);
 static void fc_exch_release(struct fc_exch *);
 static void fc_exch_complete_locked(struct fc_exch *);
-static void fc_exch_timeout(void *);
+static void fc_exch_timeout(unsigned long);
 
 /*
  * Internal implementation notes.
@@ -257,7 +257,8 @@ static int fc_exch_mgr_init(struct fc_exch_mgr *mp, enum fc_class class,
 			ep->ex_xid = xid;
 			ep->ex_e_stat = ESB_ST_COMPLETE;
 			spin_lock_init(&ep->ex_lock);
-			sa_timer_init(&ep->ex_timer, fc_exch_timeout, ep);
+			setup_timer(&ep->ex_timer,
+				 fc_exch_timeout, (unsigned long)ep);
 			list_add_tail(&ep->ex_list, &pp->emp_exch_free);
 			pp->emp_exch_total++;
 		}
@@ -344,7 +345,7 @@ static void fc_exch_release(struct fc_exch *ep)
 
 	if (atomic_dec_and_test(&ep->ex_refcnt) &&
 	    (ep->ex_e_stat & ESB_ST_COMPLETE)) {
-		sa_timer_cancel(&ep->ex_timer);
+		del_timer(&ep->ex_timer);
 		pp = ep->ex_pool;
 		spin_lock_bh(&pp->emp_lock);
 		ASSERT(pp->emp_exch_in_use > 0);
@@ -423,9 +424,9 @@ inline void fc_seq_complete(struct fc_seq *sp)
  * Exchange timeout - handle exchange timer expiration.
  * The timer will have been cancelled before this is called.
  */
-static void fc_exch_timeout(void *ep_arg)
+static void fc_exch_timeout(unsigned long ep_arg)
 {
-	struct fc_exch *ep = ep_arg;
+	struct fc_exch *ep = (struct fc_exch *)ep_arg;
 	struct fc_seq *sp = &ep->ex_seq;
 	void (*errh) (enum fc_event, void *);
 	void *arg;
@@ -457,7 +458,7 @@ static void fc_exch_timeout(void *ep_arg)
 void fc_exch_timer_set(struct fc_exch *ep, u_int timer_msec)
 {
 	spin_lock_bh(&ep->ex_lock);
-	sa_timer_set(&ep->ex_timer, timer_msec * 1000);
+	mod_timer(&ep->ex_timer, jiffies + msecs_to_jiffies(timer_msec));
 	spin_unlock_bh(&ep->ex_lock);
 }
 
@@ -534,8 +535,8 @@ static void fc_exch_complete_locked(struct fc_exch *ep)
 	ep->ex_e_stat |= ESB_ST_COMPLETE;
 	ep->ex_recv = NULL;
 	ep->ex_errh = NULL;
-	if (sa_timer_active(&ep->ex_timer))
-		sa_timer_cancel(&ep->ex_timer);
+	if (timer_pending(&ep->ex_timer))
+		del_timer(&ep->ex_timer);
 }
 
 /*
diff --git a/drivers/scsi/ofc/libfc/fc_exch_impl.h b/drivers/scsi/ofc/libfc/fc_exch_impl.h
index e1bb200..98eeee2 100644
--- a/drivers/scsi/ofc/libfc/fc_exch_impl.h
+++ b/drivers/scsi/ofc/libfc/fc_exch_impl.h
@@ -20,8 +20,8 @@
 #ifndef _LIBFC_FC_EXCH_IMPL_H_
 #define _LIBFC_FC_EXCH_IMPL_H_
 
+#include <linux/timer.h>
 #include "sa_kernel.h"
-#include "sa_timer.h"
 #include "fc_ils.h"
 
 /*
@@ -72,7 +72,7 @@ struct fc_exch {
 	struct list_head	ex_list;	/* free or busy list linkage */
 	spinlock_t 	ex_lock;	/* lock covering exchange state */
 	atomic_t 	ex_refcnt;	/* reference counter */
-	struct sa_timer ex_timer;	/* timer for upper level protocols */
+	struct timer_list ex_timer;	/* timer for upper level protocols */
 
 	/*
 	 * Fields after ex_refcnt are cleared when an exchange is reallocated.
diff --git a/drivers/scsi/ofc/libfc/fc_local_port.c b/drivers/scsi/ofc/libfc/fc_local_port.c
index 311b5e9..0441e9b 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port.c
+++ b/drivers/scsi/ofc/libfc/fc_local_port.c
@@ -21,12 +21,12 @@
  * Logical interface support.
  */
 
+#include <linux/timer.h>
 #include "sa_kernel.h"
 #undef LIST_HEAD
 #include "net_types.h"
 #include "sa_assert.h"
 #include "ofc_dbg.h"
-#include "sa_timer.h"
 #include "sa_event.h"
 #include "sa_hash.h"
 
@@ -96,7 +96,7 @@ static inline void fc_local_port_enter_state(struct fc_local_port *lp,
 				      enum fc_local_port_state state)
 {
 	WARN_ON(!fc_local_port_locked(lp));
-	sa_timer_cancel(&lp->fl_timer);
+	del_timer(&lp->fl_timer);
 	if (state != lp->fl_state)
 		lp->fl_retry_count = 0;
 	lp->fl_state = state;
@@ -171,9 +171,9 @@ static void fc_local_port_enter_reject(struct fc_local_port *lp)
 	}
 }
 
-static void fc_local_port_timeout(void *lp_arg)
+static void fc_local_port_timeout(unsigned long lp_arg)
 {
-	struct fc_local_port *lp = lp_arg;
+	struct fc_local_port *lp = (struct fc_local_port *)lp_arg;
 
 	fc_local_port_lock(lp);
 	fc_local_port_enter_retry(lp);
@@ -215,7 +215,8 @@ static void fc_local_port_retry(struct fc_local_port *lp)
 			"- will retry", lp->fl_fid, fc_local_port_state(lp));
 	if (lp->fl_retry_count < lp->fl_retry_limit) {
 		lp->fl_retry_count++;
-		sa_timer_set(&lp->fl_timer, lp->fl_e_d_tov * 1000);
+		mod_timer(&lp->fl_timer,
+			jiffies + msecs_to_jiffies(lp->fl_e_d_tov));
 	} else {
 		OFC_DBG("local port %6x alloc failure in state %s "
 			"- retries exhausted", lp->fl_fid,
@@ -536,7 +537,7 @@ static void fc_local_port_sess_event(int event, void *lp_arg)
 
 	fc_local_port_hold(lp);
 	fc_local_port_lock(lp);
-	sa_timer_cancel(&lp->fl_timer);
+	del_timer(&lp->fl_timer);
 
 	if (fc_local_port_debug) {
 		OFC_DBG("local fid %6x dNS session event %d\n", lp->fl_fid,
@@ -604,7 +605,7 @@ static void fc_local_port_enter_dns(struct fc_local_port *lp)
 	if (sess->fs_state != SESS_ST_READY) {
 		fc_sess_start(sess);	/* start the PLOGI ASAP */
 	} else {
-		sa_timer_cancel(&lp->fl_timer);
+		del_timer(&lp->fl_timer);
 		fc_local_port_enter_reg_pn(lp);
 	}
 	return;
@@ -688,7 +689,7 @@ fc_local_port_ns_resp(struct fc_seq *sp, struct fc_frame *fp, void *lp_arg)
 	struct fc_local_port *lp = lp_arg;
 
 	fc_local_port_lock(lp);
-	sa_timer_cancel(&lp->fl_timer);
+	del_timer(&lp->fl_timer);
 	if (fc_local_port_dns_acc(fp)) {
 		if (lp->fl_state == LOCAL_PORT_ST_REG_PN)
 			fc_local_port_enter_reg_ft(lp);
@@ -918,7 +919,7 @@ struct fc_local_port *fc_local_port_create(struct fc_virt_fab *vf,
 		goto err;
 	lp->fl_next_sess_id = 1;
 
-	sa_timer_init(&lp->fl_timer, fc_local_port_timeout, lp);
+	setup_timer(&lp->fl_timer, fc_local_port_timeout, (unsigned long)lp);
 
 	INIT_LIST_HEAD(&lp->fl_sess_list);
 	spin_lock_init(&lp->fl_lock);
diff --git a/drivers/scsi/ofc/libfc/fc_local_port_impl.h b/drivers/scsi/ofc/libfc/fc_local_port_impl.h
index d5825f1..12bdab7 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port_impl.h
+++ b/drivers/scsi/ofc/libfc/fc_local_port_impl.h
@@ -20,6 +20,7 @@
 #ifndef _LIBFC_FC_LOCAL_PORT_IMPL_H_
 #define _LIBFC_FC_LOCAL_PORT_IMPL_H_
 
+#include <linux/timer.h>
 #include "fc_sess.h"
 #include "fc_sess_impl.h"
 #include "sa_hash.h"
@@ -82,7 +83,7 @@ struct fc_local_port {
 	void		*fl_prli_cb_arg;	/* arg for PRLI callback */
 	struct sa_event_list *fl_events;	/* event list head */
 	struct sa_hash_link fl_hash_link;	/* hash list linkage */
-	struct sa_timer	fl_timer;		/* timer for state events */
+	struct timer_list fl_timer;		/* timer for state events */
 
 	/*
 	 * Callback and state for target discoveries.
@@ -97,7 +98,7 @@ struct fc_local_port {
 	u_char		fl_disc_holdoff;	/* (secs) delay after RSCN */
 	u_char		fl_disc_in_prog;	/* discovery in progress */
 	u_char		fl_disc_req;		/* discovery requested */
-	struct sa_timer	fl_disc_timer;		/* timer for continuing */
+	struct timer_list fl_disc_timer;	/* timer for continuing */
 	u_short		fl_disc_seq_cnt;	/* sequence count expected */
 	u_char		fl_disc_buf_len;	/* valid bytes in buffer */
 	struct fc_gpn_ft_resp fl_disc_buf;	/* partial name buffer */
@@ -123,6 +124,11 @@ struct fc_local_port {
 #define	FCDT_HOLDOFF		3	/* (secs) delay discovery after RSCN */
 
 /*
+ * Delay for discovery retry
+ */
+#define FCDT_RETRY_DELAY        500UL	/* (msecs) delay */
+
+/*
  * Locking code.
  */
 static inline void fc_local_port_lock(struct fc_local_port *lp)
diff --git a/drivers/scsi/ofc/libfc/fc_sess.c b/drivers/scsi/ofc/libfc/fc_sess.c
index 65204ae..0965187 100644
--- a/drivers/scsi/ofc/libfc/fc_sess.c
+++ b/drivers/scsi/ofc/libfc/fc_sess.c
@@ -24,13 +24,13 @@
  * a local port and a remote port.
  */
 
+#include <linux/timer.h>
 #include "sa_kernel.h"
 #undef LIST_HEAD
 #include "net_types.h"
 
 #include "sa_assert.h"
 #include "ofc_dbg.h"
-#include "sa_timer.h"
 #include "sa_event.h"
 #include "sa_hash.h"
 
@@ -98,7 +98,7 @@ static void fc_sess_recv_prlo_req(struct fc_sess *,
 static void fc_sess_recv_logo_req(struct fc_sess *,
 				  struct fc_seq *, struct fc_frame *);
 static void fc_sess_delete(struct fc_sess *, void *);
-static void fc_sess_timeout(void *);
+static void fc_sess_timeout(unsigned long);
 
 /*
  * Lock session.
@@ -318,7 +318,8 @@ struct fc_sess *fc_sess_create(struct fc_local_port *lp,
 			sess->fs_max_payload = lp->fl_max_payload;
 			sess->fs_e_d_tov = lp->fl_e_d_tov;
 			sess->fs_r_a_tov = lp->fl_r_a_tov;
-			sa_timer_init(&sess->fs_timer, fc_sess_timeout, sess);
+			setup_timer(&sess->fs_timer,
+					fc_sess_timeout, (unsigned long)sess);
 
 			rp->rp_sess = sess;
 			rp->rp_sess_ready = (sess->fs_state == SESS_ST_READY);
@@ -388,7 +389,7 @@ static void fc_sess_delete(struct fc_sess *sess, void *arg)
 	list_del(&sess->fs_list);			/* under vf_lock */
 	fc_virt_fab_unlock(vp);
 
-	sa_timer_cancel(&sess->fs_timer);
+	del_timer(&sess->fs_timer);
 	call_rcu(&sess->fs_rcu, fc_sess_rcu_free);
 
 	fc_remote_port_release(rp);
@@ -634,9 +635,9 @@ static void fc_sess_reject(struct fc_sess *sess)
 /*
  * Timeout handler for retrying after allocation failures or exchange timeout.
  */
-static void fc_sess_timeout(void *sess_arg)
+static void fc_sess_timeout(unsigned long sess_arg)
 {
-	struct fc_sess *sess = sess_arg;
+	struct fc_sess *sess = (struct fc_sess *)sess_arg;
 
 	switch (sess->fs_state) {
 	case SESS_ST_PLOGI:
@@ -675,7 +676,8 @@ static void fc_sess_retry(struct fc_sess *sess)
 
 	if (sess->fs_retries < lp->fl_retry_limit) {
 		sess->fs_retries++;
-		sa_timer_set(&sess->fs_timer, sess->fs_e_d_tov * 1000);
+		mod_timer(&sess->fs_timer,
+			jiffies + msecs_to_jiffies(sess->fs_e_d_tov));
 	} else {
 		OFC_DBG("sess %6x alloc failure in state %d, retries exhausted",
 			sess->fs_remote_fid, sess->fs_state);
@@ -697,7 +699,7 @@ static void fc_sess_error(enum fc_event event, void *sess_arg)
 
 	if (event == FC_EV_TIMEOUT &&
 	    sess->fs_retries++ >= sess->fs_local_port->fl_retry_limit)
-		fc_sess_timeout(sess);
+		fc_sess_timeout((unsigned long)sess);
 	else
 		fc_sess_reject(sess);
 
diff --git a/drivers/scsi/ofc/libfc/fc_sess_impl.h b/drivers/scsi/ofc/libfc/fc_sess_impl.h
index 37166fb..d844cba 100644
--- a/drivers/scsi/ofc/libfc/fc_sess_impl.h
+++ b/drivers/scsi/ofc/libfc/fc_sess_impl.h
@@ -20,9 +20,9 @@
 #ifndef _LIBFC_FC_SESS_IMPL_H_
 #define _LIBFC_FC_SESS_IMPL_H_
 
+#include <linux/timer.h>
 #include "fc_exch.h"
 #include "sa_hash.h"
-#include "sa_timer.h"
 
 #include <linux/rcupdate.h>
 
@@ -52,7 +52,7 @@ struct fc_sess {
 	uint		fs_sess_id;	/* session ID under the LIF */
 	atomic_t	fs_refcnt;	/* reference count */
 	uint		fs_retries;	/* retry count in current state */
-	struct sa_timer fs_timer;	/* retry timer */
+	struct timer_list fs_timer;	/* retry timer */
 	uint16_t	fs_max_payload;	/* max payload size in bytes */
 	uint16_t	fs_max_seq;	/* max concurrent sequences */
 	uint		fs_e_d_tov;	/* negotiated e_d_tov (msec) */
diff --git a/drivers/scsi/ofc/libfc/fcs_state_impl.h b/drivers/scsi/ofc/libfc/fcs_state_impl.h
index a25b2ea..9f4ecc1 100644
--- a/drivers/scsi/ofc/libfc/fcs_state_impl.h
+++ b/drivers/scsi/ofc/libfc/fcs_state_impl.h
@@ -20,8 +20,6 @@
 #ifndef _OPENFC_FCS_STATE_IMPL_H_
 #define _OPENFC_FCS_STATE_IMPL_H_
 
-#include "sa_timer.h"
-
 /*
  * Private state structure.
  */
diff --git a/drivers/scsi/ofc/libsa/Makefile b/drivers/scsi/ofc/libsa/Makefile
index 42b8733..3f2e675 100644
--- a/drivers/scsi/ofc/libsa/Makefile
+++ b/drivers/scsi/ofc/libsa/Makefile
@@ -7,5 +7,4 @@ obj-y += libsa.o
 libsa-y := \
 	sa_assert.o \
 	sa_event.o \
-	sa_hash_kern.o \
-	sa_timer.o
+	sa_hash_kern.o
diff --git a/drivers/scsi/ofc/libsa/sa_timer.c b/drivers/scsi/ofc/libsa/sa_timer.c
deleted file mode 100644
index 0e3d422..0000000
--- a/drivers/scsi/ofc/libsa/sa_timer.c
+++ /dev/null
@@ -1,80 +0,0 @@
-/*
- * Copyright(c) 2007 Intel Corporation. All rights reserved.
- * 
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- * 
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- * 
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * 
- * Maintained at www.Open-FCoE.org
- */
-
-#include "sa_kernel.h"
-
-#include <linux/timer.h>
-#include <linux/jiffies.h>
-
-#include "sa_assert.h"
-#include "ofc_dbg.h"
-#include "sa_timer.h"
-
-/*
- * Allocate a timer structure.  Set handler.
- */
-struct sa_timer *sa_timer_alloc(void (*handler) (void *), void *arg)
-{
-	struct sa_timer *tm;
-
-	tm = sa_malloc(sizeof(*tm));
-	if (tm)
-		sa_timer_init(tm, handler, arg);
-	return tm;
-}
-
-u_int64_t sa_timer_get(void)
-{
-	return (u_int64_t) get_jiffies_64() * TICK_NSEC;
-}
-
-/*
- * Get monotonic time since some arbitrary time in the past.
- * If _POSIX_MONOTONIC_CLOCK isn't available, we'll use time of day.
- */
-u_int sa_timer_get_secs(void)
-{
-	return jiffies_to_msecs(get_jiffies_64()) / 1000;
-}
-
-/*
- * Set timer to fire.   Delta is in microseconds from now.
- */
-void sa_timer_set(struct sa_timer *tm, u_long delta_usec)
-{
-	mod_timer((struct timer_list *)tm,
-		  jiffies + usecs_to_jiffies(delta_usec));
-}
-
-/*
- * Cancel timer if it is active.
- */
-void sa_timer_cancel(struct sa_timer *tm)
-{
-	del_timer((struct timer_list *)tm);
-}
-
-/*
- * Free (and cancel) timer.
- */
-void sa_timer_free(struct sa_timer *tm)
-{
-	del_timer_sync((struct timer_list *)tm);
-	sa_free(tm);
-}

