From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] [FCoE] Removal of state machine transition abstraction layer.
Date: Fri, 11 Jan 2008 16:17:28 -0800
Message-ID: <20080112001728.30934.9915.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:25043 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762654AbYALAul (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 19:50:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Part of effort to remove libsa.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/ofc/include/sa_state.h    |  164 -------------
 drivers/scsi/ofc/libfc/fc_local_port.c |  402 ++++++++++++++------------------
 drivers/scsi/ofc/libfc/fc_sess.c       |  398 ++++++++++----------------------
 drivers/scsi/ofc/libfc/fc_sess_impl.h  |    1 
 drivers/scsi/ofc/libfc/fcs_state.c     |    4 
 drivers/scsi/ofc/libsa/Makefile        |    1 
 drivers/scsi/ofc/libsa/sa_state.c      |  371 ------------------------------
 7 files changed, 308 insertions(+), 1033 deletions(-)
 delete mode 100644 drivers/scsi/ofc/include/sa_state.h
 delete mode 100644 drivers/scsi/ofc/libsa/sa_state.c


diff --git a/drivers/scsi/ofc/include/sa_state.h b/drivers/scsi/ofc/include/sa_state.h
deleted file mode 100644
index 8a7ee8d..0000000
--- a/drivers/scsi/ofc/include/sa_state.h
+++ /dev/null
@@ -1,164 +0,0 @@
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
-#ifndef _LIBSA_SA_STATE_H_
-#define _LIBSA_SA_STATE_H_
-
-/*
- * State transition table handling.
- */
-struct sa_state_table;
-
-/*
- * State transition description.
- * There are the following entry types:
- * - END simply indicates the end of the table.
- * - STATE gives the number and name of a state.
- * - EVENT gives the number and name of an event
- * - HANDLER gives the number and function pointer to a handler.
- * - FROM sets the current state.
- * - NEXT gives a state transition from the current state on.
- * a given event; the next state and/or a handler to call are given.
- *
- * A handler can also be associated with a particular state, in which
- * case the handler will be called on every entry to the state.
- */
-struct sa_state_desc {
-	enum {
-		SST_END,	/* end of table */
-		SST_STATE,	/* state definition */
-		SST_EVENT,	/* event definition */
-		SST_HANDLER,	/* handler */
-		SST_FROM,	/* old state definition */
-		SST_NEXT,	/* state transition definition */
-	} sd_type;
-	u_char	sd_in;		/* event or state number */
-	u_char	sd_next;	/* next state number */
-	const char *sd_ptr;	/* name of state or event or function or NULL */
-};
-
-typedef void (sa_state_handler_t)(void *arg, u_int next_state, u_int event);
-
-/*
- * Convenience macros for filling in descriptors.
- */
-
-/**
- * SA_STATE_LABEL(state, name) - declare a state name and number.
- *
- * @param state symbol with value of state.
- * @param name human-readable name for state.
- *
- * This sets the current state for the following state event initializations.
- */
-#define SA_STATE_LABEL(state, name) { \
-        .sd_type = SST_STATE, .sd_ptr = name, .sd_in = state }
-
-/**
- * SA_STATE_NAME(state) - declare a state name and number.
- *
- * @param state symbol with value of state, also used for state name
- *
- * This sets the current state for the following state event initializations.
- */
-#define SA_STATE_NAME(state) SA_STATE_LABEL(state, #state)
-
-/**
- * SA_STATE_HANDLER(state, handler) - declare function to handle entry to state.
- *
- * @param state the state number.
- * @param handler the handler function pointer.
- */
-#define SA_STATE_HANDLER(state, handler) { \
-        .sd_type = SST_HANDLER, .sd_ptr = (void *) handler, .sd_in = state }
-
-/*
- * SA_STATE_EVENT(event)
- *
- * @param event symbol with value of event, also used for the event name.
- *
- * This declares an event which can be used in the state transition table.
- */
-#define SA_STATE_EVENT(event) { \
-        .sd_type = SST_EVENT, .sd_ptr = #event, .sd_in = event }
-
-/**
- * SA_STATE_FROM(val) - set the state number for subsequent SA_STATE_NEXT*()s.
- */
-#define SA_STATE_FROM(val) {            /* not really needed */ \
-        .sd_type = SST_STATE, .sd_in = val }
-
-/**
- * SA_STATE_NEXT_FUNC(event, next, handler) - declare transition entry.
- *
- * @param event the event number.
- * @param next the state to which to transition.
- * @param handler a pointer to a function to call before the transition.
- */
-#define SA_STATE_NEXT_FUNC(event, next, handler) { \
-        .sd_type = SST_NEXT, .sd_in = event, .sd_next = next, \
-        .sd_ptr = (void *) handler }
-
-/**
- * SA_STATE_NEXT(event, next) - declare transition entry.
- *
- * @param event the event number.
- * @param next the state to which to transition.
- */
-#define SA_STATE_NEXT(event, next)  SA_STATE_NEXT_FUNC(event, next, NULL)
-
-/**
- * SA_STATE_END - declare end of state table description.
- */
-#define SA_STATE_END    { .sd_type = SST_END }
-
-/*
- * State transition table initialization.
- */
-struct sa_state_table *sa_state_table_alloc(const char *name,
-					    const struct sa_state_desc
-					    *state_desc);
-
-/*
- * Free state table.
- */
-void sa_state_table_free(struct sa_state_table *);
-
-/*
- * Handle event for a state transition table.
- */
-void sa_state_table_step(struct sa_state_table *tp, void *statep,
-			 u_int event, void *arg);
-
-/*
- * Transition to the specified state.  Run the handler if any.
- */
-void sa_state_table_enter(struct sa_state_table *, void *statep,
-			  u_int new_state, u_int event, void *arg);
-
-/**
- * sa_state_table_log() - set function to log state table transitions.
- */
-void sa_state_table_log(struct sa_state_table *tp,
-			void (*log_func) (void *arg, const char *msg));
-
-const char *sa_state_event_name(struct sa_state_table *, u_int);
-const char *sa_state_name(struct sa_state_table *, u_int);
-
-#endif /* _LIBSA_SA_STATE_H_ */
diff --git a/drivers/scsi/ofc/libfc/fc_local_port.c b/drivers/scsi/ofc/libfc/fc_local_port.c
index 1911405..7430da4 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port.c
+++ b/drivers/scsi/ofc/libfc/fc_local_port.c
@@ -29,7 +29,6 @@
 #include "sa_timer.h"
 #include "sa_event.h"
 #include "sa_hash.h"
-#include "sa_state.h"
 
 #include "fc_fs.h"
 #include "fc_gs.h"
@@ -49,7 +48,6 @@
 #include "fc_port.h"
 #include "fc_frame.h"
 #include "fc_exch.h"
-#include "fc_event.h"
 
 #include "fc_sess_impl.h"
 #include "fc_local_port_impl.h"
@@ -94,123 +92,83 @@ static void fc_local_port_port_event(int, void *);
 static void fc_local_port_set_fid_int(struct fc_local_port *, fc_fid_t);
 static void fc_local_port_gid_pn_error(enum fc_event, void *arg);
 
+static inline void fc_local_port_enter_state(struct fc_local_port *lp,
+				      enum fc_local_port_state state)
+{
+	WARN_ON(!fc_local_port_locked(lp));
+	sa_timer_cancel(&lp->fl_timer);
+	if (state != lp->fl_state)
+		lp->fl_retry_count = 0;
+	lp->fl_state = state;
+}
+
 /*
- * Session state transition table.
+ * re-enter state for retrying a request after a timeout or alloc failure.
  */
-static const struct sa_state_desc fc_local_port_state_desc[] = {
-	/*
-	 * Declare events.
-	 * The event meanings are slightly different than the generic ones.
-	 */
-	SA_STATE_EVENT(FC_EV_ACC),	/* exchange accepted */
-	SA_STATE_EVENT(FC_EV_RJT),	/* exchange rejected */
-	SA_STATE_EVENT(FC_EV_TIMEOUT),	/* exchange timed out */
-	SA_STATE_EVENT(FC_EV_START),	/* upper layer requested FLOGI */
-	SA_STATE_EVENT(FC_EV_STOP),	/* upper layer requested LOGO */
-	SA_STATE_EVENT(FC_EV_READY),	/* dNS session ready */
-	SA_STATE_EVENT(FC_EV_CLOSED),	/* dNS session closed */
-	SA_STATE_EVENT(FC_EV_DOWN),	/* event shouldn't be seen */
-
-	/*
-	 * Associate handlers for entering specific states.
-	 */
-	SA_STATE_HANDLER(LOCAL_PORT_ST_INIT, fc_local_port_enter_init),
-	SA_STATE_HANDLER(LOCAL_PORT_ST_FLOGI, fc_local_port_enter_flogi),
-	SA_STATE_HANDLER(LOCAL_PORT_ST_DNS, fc_local_port_enter_dns),
-	SA_STATE_HANDLER(LOCAL_PORT_ST_REG_PN, fc_local_port_enter_reg_pn),
-	SA_STATE_HANDLER(LOCAL_PORT_ST_REG_FT, fc_local_port_enter_reg_ft),
-	SA_STATE_HANDLER(LOCAL_PORT_ST_SCR, fc_local_port_enter_scr),
-	SA_STATE_HANDLER(LOCAL_PORT_ST_READY, fc_local_port_enter_ready),
-	SA_STATE_HANDLER(LOCAL_PORT_ST_DNS_STOP, fc_local_port_enter_dns_stop),
-	SA_STATE_HANDLER(LOCAL_PORT_ST_LOGO, fc_local_port_enter_logo),
-
-	/*
-	 * Declare states and transitions.
-	 */
-	SA_STATE_LABEL(LOCAL_PORT_ST_INIT, "idle"),	/* idle state */
-	SA_STATE_NEXT(FC_EV_START, LOCAL_PORT_ST_FLOGI),
-	SA_STATE_NEXT(FC_EV_STOP, LOCAL_PORT_ST_INIT),
-	SA_STATE_NEXT(FC_EV_TIMEOUT, LOCAL_PORT_ST_INIT),
-	SA_STATE_NEXT(FC_EV_CLOSED, LOCAL_PORT_ST_INIT),
-
-	SA_STATE_LABEL(LOCAL_PORT_ST_FLOGI, "FLOGI"),	/* login to fabric */
-	SA_STATE_NEXT(FC_EV_ACC, LOCAL_PORT_ST_DNS),
-	SA_STATE_NEXT(FC_EV_RJT, LOCAL_PORT_ST_FLOGI),
-	SA_STATE_NEXT(FC_EV_TIMEOUT, LOCAL_PORT_ST_FLOGI),
-	SA_STATE_NEXT(FC_EV_CLOSED, LOCAL_PORT_ST_FLOGI),
-	SA_STATE_NEXT(FC_EV_STOP, LOCAL_PORT_ST_INIT),
-
-	SA_STATE_LABEL(LOCAL_PORT_ST_DNS, "dNS"),	/* wait for dNS sess */
-	SA_STATE_NEXT(FC_EV_READY, LOCAL_PORT_ST_REG_PN),
-	SA_STATE_NEXT(FC_EV_CLOSED, LOCAL_PORT_ST_FLOGI),
-	SA_STATE_NEXT(FC_EV_STOP, LOCAL_PORT_ST_LOGO),
-	SA_STATE_NEXT(FC_EV_TIMEOUT, LOCAL_PORT_ST_DNS),
-	SA_STATE_NEXT(FC_EV_RJT, LOCAL_PORT_ST_INIT),
-
-	SA_STATE_LABEL(LOCAL_PORT_ST_REG_PN, "REG_PN"), /* reg. ID with dNS */
-	SA_STATE_NEXT(FC_EV_ACC, LOCAL_PORT_ST_REG_FT),
-	SA_STATE_NEXT(FC_EV_RJT, LOCAL_PORT_ST_REG_FT),
-	SA_STATE_NEXT(FC_EV_TIMEOUT, LOCAL_PORT_ST_FLOGI),
-	SA_STATE_NEXT(FC_EV_CLOSED, LOCAL_PORT_ST_FLOGI),
-	SA_STATE_NEXT(FC_EV_STOP, LOCAL_PORT_ST_DNS_STOP),
-
-	SA_STATE_LABEL(LOCAL_PORT_ST_REG_FT, "REG_FT"),	/* register FC-4 type */
-	SA_STATE_NEXT(FC_EV_ACC, LOCAL_PORT_ST_SCR),
-	SA_STATE_NEXT(FC_EV_RJT, LOCAL_PORT_ST_SCR),
-	SA_STATE_NEXT(FC_EV_TIMEOUT, LOCAL_PORT_ST_FLOGI),
-	SA_STATE_NEXT(FC_EV_CLOSED, LOCAL_PORT_ST_FLOGI),
-	SA_STATE_NEXT(FC_EV_STOP, LOCAL_PORT_ST_DNS_STOP),
-
-	SA_STATE_LABEL(LOCAL_PORT_ST_SCR, "SCR"),	/* state change reg. */
-	SA_STATE_NEXT(FC_EV_ACC, LOCAL_PORT_ST_READY),
-	SA_STATE_NEXT(FC_EV_RJT, LOCAL_PORT_ST_SCR),	/* XXX wrong */
-	SA_STATE_NEXT(FC_EV_TIMEOUT, LOCAL_PORT_ST_FLOGI),
-	SA_STATE_NEXT(FC_EV_CLOSED, LOCAL_PORT_ST_FLOGI),
-	SA_STATE_NEXT(FC_EV_STOP, LOCAL_PORT_ST_DNS_STOP),
-
-	SA_STATE_LABEL(LOCAL_PORT_ST_READY, "ready"),	/* ready */
-	SA_STATE_NEXT(FC_EV_STOP, LOCAL_PORT_ST_DNS_STOP),
-	SA_STATE_NEXT(FC_EV_CLOSED, LOCAL_PORT_ST_FLOGI),
-	SA_STATE_NEXT(FC_EV_TIMEOUT, LOCAL_PORT_ST_READY),
-	SA_STATE_NEXT(FC_EV_RJT, LOCAL_PORT_ST_READY),	/* late response */
-
-	SA_STATE_LABEL(LOCAL_PORT_ST_DNS_STOP, "stop"),	/* dNS session logout */
-	SA_STATE_NEXT(FC_EV_CLOSED, LOCAL_PORT_ST_LOGO),
-	SA_STATE_NEXT(FC_EV_TIMEOUT, LOCAL_PORT_ST_DNS_STOP),
-	SA_STATE_NEXT(FC_EV_RJT, LOCAL_PORT_ST_DNS_STOP),
-
-	SA_STATE_LABEL(LOCAL_PORT_ST_LOGO, "LOGO"),	/* logout */
-	SA_STATE_NEXT(FC_EV_ACC, LOCAL_PORT_ST_INIT),
-	SA_STATE_NEXT(FC_EV_RJT, LOCAL_PORT_ST_INIT),
-	SA_STATE_NEXT(FC_EV_TIMEOUT, LOCAL_PORT_ST_LOGO),
-	SA_STATE_NEXT(FC_EV_STOP, LOCAL_PORT_ST_LOGO),
-	SA_STATE_NEXT(FC_EV_CLOSED, LOCAL_PORT_ST_INIT),
-
-	SA_STATE_LABEL(LOCAL_PORT_ST_RESET, "reset"),
-
-	SA_STATE_END
-};
-
-static struct sa_state_table *fc_local_port_state_table;
-static int fc_local_port_state_table_refcnt;
+static void fc_local_port_enter_retry(struct fc_local_port *lp)
+{
+	switch (lp->fl_state) {
+	case LOCAL_PORT_ST_NONE:
+	case LOCAL_PORT_ST_INIT:
+	case LOCAL_PORT_ST_READY:
+	case LOCAL_PORT_ST_RESET:
+		WARN_ON(1);
+		break;
+	case LOCAL_PORT_ST_FLOGI:
+		fc_local_port_enter_flogi(lp);
+		break;
+	case LOCAL_PORT_ST_DNS:
+		fc_local_port_enter_dns(lp);
+		break;
+	case LOCAL_PORT_ST_DNS_STOP:
+		fc_local_port_enter_dns_stop(lp);
+		break;
+	case LOCAL_PORT_ST_REG_PN:
+		fc_local_port_enter_reg_pn(lp);
+		break;
+	case LOCAL_PORT_ST_REG_FT:
+		fc_local_port_enter_reg_ft(lp);
+		break;
+	case LOCAL_PORT_ST_SCR:
+		fc_local_port_enter_scr(lp);
+		break;
+	case LOCAL_PORT_ST_LOGO:
+		fc_local_port_enter_logo(lp);
+		break;
+	}
+}
 
 /*
- * Transition a local port state due to an event.
+ * enter next state for handling an exchange reject or retry exhaustion
+ * in the current state.
  */
-static void fc_local_port_state_event(struct fc_local_port *lp,
-				      enum fc_event event)
-{
-	enum fc_local_port_state old_state;
-
-	ASSERT(fc_local_port_locked(lp));
-	old_state = lp->fl_state;
-	ASSERT(old_state != LOCAL_PORT_ST_RESET);
-	sa_timer_cancel(&lp->fl_timer);
-	sa_state_table_step(fc_local_port_state_table, &lp->fl_state,
-			    event, lp);
-	ASSERT(fc_local_port_locked(lp));
-	if (lp->fl_state != old_state)
-		lp->fl_retry_count = 0;
+static void fc_local_port_enter_reject(struct fc_local_port *lp)
+{
+	switch (lp->fl_state) {
+	case LOCAL_PORT_ST_NONE:
+	case LOCAL_PORT_ST_INIT:
+	case LOCAL_PORT_ST_READY:
+	case LOCAL_PORT_ST_RESET:
+		WARN_ON(1);
+		break;
+	case LOCAL_PORT_ST_FLOGI:
+		fc_local_port_enter_flogi(lp);
+		break;
+	case LOCAL_PORT_ST_REG_PN:
+		fc_local_port_enter_reg_ft(lp);
+		break;
+	case LOCAL_PORT_ST_REG_FT:
+		fc_local_port_enter_scr(lp);
+		break;
+	case LOCAL_PORT_ST_SCR:
+	case LOCAL_PORT_ST_DNS_STOP:
+		fc_local_port_enter_dns_stop(lp);
+		break;
+	case LOCAL_PORT_ST_DNS:
+	case LOCAL_PORT_ST_LOGO:
+		fc_local_port_enter_init(lp);
+		break;
+	}
 }
 
 static void fc_local_port_timeout(void *lp_arg)
@@ -218,32 +176,51 @@ static void fc_local_port_timeout(void *lp_arg)
 	struct fc_local_port *lp = lp_arg;
 
 	fc_local_port_lock(lp);
-	fc_local_port_state_event(lp, FC_EV_TIMEOUT);
+	fc_local_port_enter_retry(lp);
 	fc_local_port_unlock_send(lp);
 }
 
+static const char *fc_local_port_state_names[] = {
+ 	[LOCAL_PORT_ST_NONE] =	"none",
+ 	[LOCAL_PORT_ST_INIT] =	"idle",
+ 	[LOCAL_PORT_ST_FLOGI] =	"FLOGI",
+ 	[LOCAL_PORT_ST_DNS] =	"dNS",
+ 	[LOCAL_PORT_ST_REG_PN] = "REG_PN",
+ 	[LOCAL_PORT_ST_REG_FT] = "REG_FT",
+ 	[LOCAL_PORT_ST_SCR] =	"SCR",
+ 	[LOCAL_PORT_ST_READY] =	"ready",
+ 	[LOCAL_PORT_ST_DNS_STOP] = "stop",
+ 	[LOCAL_PORT_ST_LOGO] =	"LOGO",
+ 	[LOCAL_PORT_ST_RESET] =	"reset",
+};
+
 const char *fc_local_port_state(struct fc_local_port *lp)
 {
-	return sa_state_name(fc_local_port_state_table, lp->fl_state);
+ 	const char *cp;
+
+ 	cp = fc_local_port_state_names[lp->fl_state];
+	if (!cp)
+		cp = "unknown";
+	return cp;
 }
 
+/*
+ * Handle resource allocation problem by retrying in a bit.
+ */
 static void fc_local_port_retry(struct fc_local_port *lp)
 {
-	const char *state;
-
 	ASSERT(fc_local_port_locked(lp));
-	state = fc_local_port_state(lp);
-	if (lp->fl_retry_count == 0) {
+	if (lp->fl_retry_count == 0)
 		OFC_DBG("local port %6x alloc failure in state %s "
-		       "- will retry", lp->fl_fid, state);
-	}
+			"- will retry", lp->fl_fid, fc_local_port_state(lp));
 	if (lp->fl_retry_count < lp->fl_retry_limit) {
 		lp->fl_retry_count++;
 		sa_timer_set(&lp->fl_timer, lp->fl_e_d_tov * 1000);
 	} else {
 		OFC_DBG("local port %6x alloc failure in state %s "
-		       "- retries exhausted", lp->fl_fid, state);
-		fc_local_port_state_event(lp, FC_EV_RJT);
+			"- retries exhausted", lp->fl_fid,
+			fc_local_port_state(lp));
+ 		fc_local_port_enter_reject(lp);
 	}
 }
 
@@ -281,9 +258,8 @@ static void fc_local_port_ptp_setup(struct fc_local_port *lp,
 		if (lp->fl_ptp_rp)
 			fc_remote_port_release(lp->fl_ptp_rp);
 		lp->fl_ptp_rp = rp;
+		fc_local_port_enter_ready(lp);
 	}
-	sa_state_table_enter(fc_local_port_state_table, &lp->fl_state,
-			     LOCAL_PORT_ST_READY, FC_EV_NONE, lp);
 }
 
 static void fc_local_port_ptp_clear(struct fc_local_port *lp)
@@ -404,10 +380,8 @@ fc_local_port_flogi_resp(struct fc_seq *sp, struct fc_frame *fp, void *lp_arg)
 			} else {
 				lp->fl_e_d_tov = e_d_tov;
 				lp->fl_r_a_tov = r_a_tov;
-				fc_local_port_state_event(lp, FC_EV_ACC);
+				fc_local_port_enter_dns(lp);
 			}
-		} else {
-			fc_local_port_state_event(lp, FC_EV_RJT);
 		}
 		fc_local_port_unlock_send(lp);
 	} else {
@@ -513,8 +487,7 @@ static void fc_local_port_recv_flogi_req(struct fc_seq *sp_in,
 	}
 	fc_local_port_set_fid_int(lp, local_fid);
 
-	sa_state_table_enter(fc_local_port_state_table, &lp->fl_state,
-			     LOCAL_PORT_ST_READY, FC_EV_NONE, lp);
+	fc_local_port_enter_ready(lp);
 
 	fp = fc_frame_alloc(lp->fl_port, sizeof(*flp));
 	if (fp) {
@@ -545,7 +518,7 @@ out:
 
 static void fc_local_port_enter_flogi(struct fc_local_port *lp)
 {
-	ASSERT(fc_local_port_locked(lp));
+	fc_local_port_enter_state(lp, LOCAL_PORT_ST_FLOGI);
 	fc_local_port_ptp_clear(lp);
 	fc_local_port_flogi_send(lp);
 }
@@ -563,19 +536,25 @@ static void fc_local_port_sess_event(int event, void *lp_arg)
 
 	fc_local_port_hold(lp);
 	fc_local_port_lock(lp);
+	sa_timer_cancel(&lp->fl_timer);
+
 	if (fc_local_port_debug) {
 		OFC_DBG("local fid %6x dNS session event %d\n", lp->fl_fid,
 		       event);
 	}
 	switch (event) {
 	case FC_EV_READY:
-		fc_local_port_state_event(lp, event);
+		if (lp->fl_state == LOCAL_PORT_ST_DNS)
+ 			fc_local_port_enter_reg_pn(lp);
 		break;
 	case FC_EV_CLOSED:
 		sess = lp->fl_dns_sess;
 		ASSERT(sess);
 		lp->fl_dns_sess = NULL;
-		fc_local_port_state_event(lp, event);
+ 		if (lp->fl_state == LOCAL_PORT_ST_DNS_STOP)
+ 			fc_local_port_enter_logo(lp);
+ 		else
+ 			fc_local_port_enter_flogi(lp);
 		break;
 	default:
 		OFC_DBG("unexpected event %d from dNS session", event);
@@ -597,7 +576,7 @@ static void fc_local_port_enter_dns(struct fc_local_port *lp)
 	struct fc_sess *sess;
 	struct fc_remote_port *rp;
 
-	ASSERT(fc_local_port_locked(lp));
+	fc_local_port_enter_state(lp, LOCAL_PORT_ST_DNS);
 	sess = lp->fl_dns_sess;
 	if (!sess) {
 		/*
@@ -625,7 +604,8 @@ static void fc_local_port_enter_dns(struct fc_local_port *lp)
 	if (sess->fs_state != SESS_ST_READY) {
 		fc_sess_start(sess);	/* start the PLOGI ASAP */
 	} else {
-		fc_local_port_state_event(lp, FC_EV_READY);
+		sa_timer_cancel(&lp->fl_timer);
+		fc_local_port_enter_reg_pn(lp);
 	}
 	return;
 
@@ -681,6 +661,7 @@ static void fc_local_port_enter_reg_pn(struct fc_local_port *lp)
 		struct fc_ns_rn_id rn;
 	} *rp;
 
+	fc_local_port_enter_state(lp, LOCAL_PORT_ST_REG_PN);
 	fp = fc_frame_alloc(lp->fl_port, sizeof(*rp));
 	if (!fp) {
 		fc_local_port_retry(lp);
@@ -707,10 +688,15 @@ fc_local_port_ns_resp(struct fc_seq *sp, struct fc_frame *fp, void *lp_arg)
 	struct fc_local_port *lp = lp_arg;
 
 	fc_local_port_lock(lp);
+	sa_timer_cancel(&lp->fl_timer);
 	if (fc_local_port_dns_acc(fp)) {
-		fc_local_port_state_event(lp, FC_EV_ACC);
+		if (lp->fl_state == LOCAL_PORT_ST_REG_PN)
+			fc_local_port_enter_reg_ft(lp);
+		else
+			fc_local_port_enter_scr(lp);
+
 	} else {
-		fc_local_port_state_event(lp, FC_EV_RJT);
+		fc_local_port_retry(lp);
 	}
 	fc_local_port_unlock_send(lp);
 	fc_frame_free(fp);
@@ -730,7 +716,7 @@ static void fc_local_port_enter_reg_ft(struct fc_local_port *lp)
 	struct fc_ns_fts *lps;
 	int i;
 
-	ASSERT(fc_local_port_locked(lp));
+	fc_local_port_enter_state(lp, LOCAL_PORT_ST_REG_FT);
 	lps = &lp->fl_ns_fts;
 	i = sizeof(lps->ff_type_map) / sizeof(lps->ff_type_map[0]);
 	while (--i >= 0)
@@ -756,7 +742,7 @@ static void fc_local_port_enter_reg_ft(struct fc_local_port *lp)
 			fc_local_port_retry(lp);
 		}
 	} else {
-		fc_local_port_state_event(lp, FC_EV_ACC);
+		fc_local_port_enter_scr(lp);
 	}
 }
 
@@ -766,6 +752,7 @@ static void fc_local_port_enter_scr(struct fc_local_port *lp)
 	struct fc_els_scr *scr;
 	struct fc_seq *sp;
 
+	fc_local_port_enter_state(lp, LOCAL_PORT_ST_SCR);
 	sp = fc_seq_start_exch(lp->fl_vf->vf_exch_mgr,
 			       fc_local_port_scr_resp, fc_local_port_error,
 			       lp, lp->fl_fid, FC_FID_FCTRL);
@@ -784,26 +771,16 @@ static void
 fc_local_port_scr_resp(struct fc_seq *sp, struct fc_frame *fp, void *lp_arg)
 {
 	struct fc_local_port *lp = lp_arg;
-	struct fc_frame_header *fh;
 
 	fc_local_port_lock(lp);
-	fh = fc_frame_header_get(fp);
-	ASSERT(fh);
-	switch (fc_frame_payload_op(fp)) {
-	case ELS_LS_ACC:
-		fc_local_port_state_event(lp, FC_EV_ACC);
-		break;
-	default:
-		fc_local_port_state_event(lp, FC_EV_RJT);
-		break;
-	}
+	fc_local_port_enter_ready(lp);
 	fc_local_port_unlock_send(lp);
 	fc_frame_free(fp);
 }
 
 static void fc_local_port_enter_ready(struct fc_local_port *lp)
 {
-	ASSERT(fc_local_port_locked(lp));
+	fc_local_port_enter_state(lp, LOCAL_PORT_ST_READY);
 	sa_event_call_cancel(lp->fl_events, FC_EV_CLOSED);
 	sa_event_call_defer(lp->fl_events, FC_EV_READY);
 }
@@ -816,12 +793,12 @@ static void fc_local_port_enter_dns_stop(struct fc_local_port *lp)
 {
 	struct fc_sess *sess;
 
-	ASSERT(fc_local_port_locked(lp));
+	fc_local_port_enter_state(lp, LOCAL_PORT_ST_DNS_STOP);
 	sess = lp->fl_dns_sess;
 	if (sess) {
 		fc_sess_stop(sess);
 	} else {
-		fc_local_port_state_event(lp, FC_EV_CLOSED);
+		fc_local_port_enter_logo(lp);
 	}
 }
 
@@ -830,15 +807,10 @@ static void fc_local_port_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 {
 	struct fc_local_port *lp = lp_arg;
 
-	ASSERT(lp);
+	fc_frame_free(fp);
 	fc_local_port_lock(lp);
-	if (fc_frame_payload_op(fp) == ELS_LS_ACC) {
-		fc_local_port_state_event(lp, FC_EV_ACC);
-	} else {
-		fc_local_port_state_event(lp, FC_EV_RJT);
-	}
+	fc_local_port_enter_init(lp);
 	fc_local_port_unlock_send(lp);
-	fc_frame_free(fp);
 }
 
 /*
@@ -854,6 +826,7 @@ static void fc_local_port_enter_logo(struct fc_local_port *lp)
 	/*
 	 * DNS session should be closed so we can release it here.
 	 */
+	fc_local_port_enter_state(lp, LOCAL_PORT_ST_LOGO);
 	sess = lp->fl_dns_sess;
 	if (sess) {
 		fc_sess_release(sess);
@@ -876,20 +849,9 @@ static void fc_local_port_enter_logo(struct fc_local_port *lp)
 	fc_local_port_els_send(lp, sp, fp);
 }
 
-/*
- * Log state transition messages.
- */
-static void fc_local_port_log(void *lp_arg, const char *msg)
-{
-	struct fc_local_port *lp = lp_arg;
-
-	OFC_DBG("local_port %6x %s", lp->fl_fid, msg);
-}
-
 int fc_local_port_table_create(struct fc_virt_fab *vp)
 {
 	struct sa_hash *hp;
-	struct sa_state_table *tp;
 
 	ASSERT(vp);
 	ASSERT(!vp->vf_lport_by_fid);
@@ -901,21 +863,7 @@ int fc_local_port_table_create(struct fc_virt_fab *vp)
 		return -1;
 	vp->vf_lport_by_fid = hp;
 	INIT_LIST_HEAD(&vp->vf_local_ports);
-	if (!fc_local_port_state_table) {
-
-		tp = sa_state_table_alloc("local_port",
-					  fc_local_port_state_desc);
 
-		if (!tp) {
-			sa_hash_destroy(hp);
-			vp->vf_lport_by_fid = NULL;
-			return -1;
-		}
-		fc_local_port_state_table = tp;
-		if (fc_local_port_debug)
-			sa_state_table_log(tp, fc_local_port_log);
-	}
-	fc_local_port_state_table_refcnt++;
 	return 0;
 }
 
@@ -923,12 +871,6 @@ void fc_local_port_table_destroy(struct fc_virt_fab *vp)
 {
 	ASSERT(list_empty(&vp->vf_local_ports));
 	sa_hash_destroy(vp->vf_lport_by_fid);
-	ASSERT(fc_local_port_state_table_refcnt > 0);
-	fc_local_port_state_table_refcnt--;
-	if (!fc_local_port_state_table_refcnt) {
-		sa_state_table_free(fc_local_port_state_table);
-		fc_local_port_state_table = NULL;
-	}
 }
 
 /*
@@ -1010,7 +952,6 @@ static void fc_local_port_set_fid_int(struct fc_local_port *lp, fc_fid_t fid)
 	struct fc_virt_fab *vf;
 
 	ASSERT(fc_local_port_locked(lp));
-
 	vf = lp->fl_vf;
 	if (lp->fl_fid != fid) {
 		if (fc_local_port_debug) {
@@ -1043,15 +984,9 @@ void fc_local_port_set_fid(struct fc_local_port *lp, fc_fid_t fid)
 		fc_local_port_set_fid_int(lp, fid);
 
 		if (fid != 0 && lp->fl_state == LOCAL_PORT_ST_INIT)
-			sa_state_table_enter(fc_local_port_state_table,
-					     &lp->fl_state,
-					     LOCAL_PORT_ST_READY,
-					     FC_EV_NONE, lp);
+			fc_local_port_enter_ready(lp);
 		else
-			sa_state_table_enter(fc_local_port_state_table,
-					     &lp->fl_state,
-					     LOCAL_PORT_ST_INIT,
-					     FC_EV_NONE, lp);
+			fc_local_port_enter_init(lp);
 	}
 	fc_local_port_unlock_send(lp);
 }
@@ -1170,7 +1105,7 @@ void fc_local_port_logon(struct fc_local_port *lp, sa_event_handler_t *cb,
 	fc_local_port_lock(lp);
 	lp->fl_logon_req = 1;
 	if (lp->fl_state == LOCAL_PORT_ST_INIT) {
-		fc_local_port_state_event(lp, FC_EV_START);
+		fc_local_port_enter_flogi(lp);
 	} else if (lp->fl_state == LOCAL_PORT_ST_READY) {
 		event = FC_EV_READY;
 	}
@@ -1186,7 +1121,26 @@ void fc_local_port_logoff(struct fc_local_port *lp)
 {
 	fc_local_port_lock(lp);
 	lp->fl_logon_req = 0;
-	fc_local_port_state_event(lp, FC_EV_STOP);
+	switch (lp->fl_state) {
+	case LOCAL_PORT_ST_NONE:
+	case LOCAL_PORT_ST_INIT:
+		break;
+	case LOCAL_PORT_ST_FLOGI:
+	case LOCAL_PORT_ST_LOGO:
+	case LOCAL_PORT_ST_RESET:
+		fc_local_port_enter_init(lp);
+		break;
+	case LOCAL_PORT_ST_DNS:
+	case LOCAL_PORT_ST_DNS_STOP:
+		fc_local_port_enter_logo(lp);
+		break;
+	case LOCAL_PORT_ST_REG_PN:
+	case LOCAL_PORT_ST_REG_FT:
+	case LOCAL_PORT_ST_SCR:
+	case LOCAL_PORT_ST_READY:
+		fc_local_port_enter_dns_stop(lp);
+		break;
+	}
 	fc_local_port_unlock_send(lp);
 }
 
@@ -1227,18 +1181,18 @@ static void fc_local_port_enter_init(struct fc_local_port *lp)
 	/*
 	 * Setting state RESET keeps fc_local_port_error() callbacks
 	 * by fc_exch_mgr_reset() from recursing on the lock.
-	 * It also prevents fc_sess_reset_list() from generating events.
+	 * It also causes fc_local_port_sess_event() to ignore events.
 	 * The lock is held for the duration of the time in RESET state.
 	 */
 	lp->fl_state = LOCAL_PORT_ST_RESET;
 	fc_exch_mgr_reset(lp->fl_vf->vf_exch_mgr, 0, 0);
 	fc_sess_reset_list(lp->fl_vf, &lp->fl_sess_list);
 	fc_local_port_set_fid_int(lp, 0);
-	lp->fl_state = LOCAL_PORT_ST_INIT;
+	fc_local_port_enter_state(lp, LOCAL_PORT_ST_INIT);
 	sa_event_call_cancel(lp->fl_events, FC_EV_READY);
 	sa_event_call_defer(lp->fl_events, FC_EV_CLOSED);
 	if (lp->fl_logon_req && fc_port_ready(lp->fl_port))
-		fc_local_port_state_event(lp, FC_EV_START);
+		fc_local_port_enter_flogi(lp);
 }
 
 /*
@@ -1250,8 +1204,7 @@ static void fc_local_port_enter_init(struct fc_local_port *lp)
 void fc_local_port_reset(struct fc_local_port *lp)
 {
 	fc_local_port_lock(lp);
-	sa_state_table_enter(fc_local_port_state_table, &lp->fl_state,
-			     LOCAL_PORT_ST_INIT, FC_EV_NONE, lp);
+	fc_local_port_enter_init(lp);
 	fc_local_port_unlock_send(lp);
 }
 
@@ -1658,28 +1611,29 @@ void fc_local_port_recv(struct fc_local_port *lp, struct fc_frame *fp)
  * Handle errors on local port requests.
  * Just put event into the state machine.
  * Don't get locks if in RESET state.
+ * The only events possible here so far are exchange TIMEOUT and CLOSED (reset).
  */
 static void fc_local_port_error(enum fc_event event, void *lp_arg)
 {
 	struct fc_local_port *lp = lp_arg;
 
-	if (lp->fl_state != LOCAL_PORT_ST_RESET) {
-		fc_local_port_lock(lp);
-		if (event == FC_EV_TIMEOUT) {
-			if (lp->fl_retry_count < lp->fl_retry_limit)
-				lp->fl_retry_count++;
-			else
-				event = FC_EV_RJT;
+ 	if (lp->fl_state == LOCAL_PORT_ST_RESET)
+ 		return;
+
+ 	fc_local_port_lock(lp);
+ 	if (event == FC_EV_TIMEOUT) {
+ 		if (lp->fl_retry_count < lp->fl_retry_limit) {
+ 			lp->fl_retry_count++;
+ 			fc_local_port_enter_retry(lp);
+ 		} else {
+ 			fc_local_port_enter_reject(lp);
+			
 		}
-		if (fc_local_port_debug)
-			OFC_DBG("event %x %s retries %d limit %d",
-			       event,
-			       sa_state_event_name(fc_local_port_state_table,
-						   event),
-			       lp->fl_retry_count, lp->fl_retry_limit);
-		fc_local_port_state_event(lp, event);
-		fc_local_port_unlock_send(lp);
 	}
+ 	if (fc_local_port_debug)
+ 		OFC_DBG("event %x retries %d limit %d",
+ 		       event, lp->fl_retry_count, lp->fl_retry_limit);
+ 	fc_local_port_unlock_send(lp);
 }
 
 static int fc_local_port_fid_match(const sa_hash_key_t key, void *lp_arg)
@@ -1709,7 +1663,7 @@ static void fc_local_port_port_event(int event, void *lp_arg)
 	case FC_EV_READY:
 		fc_local_port_lock(lp);
 		if (lp->fl_logon_req && lp->fl_state == LOCAL_PORT_ST_INIT)
-			fc_local_port_state_event(lp, FC_EV_START);
+			fc_local_port_enter_flogi(lp);
 		fc_local_port_unlock_send(lp);
 		break;
 
diff --git a/drivers/scsi/ofc/libfc/fc_sess.c b/drivers/scsi/ofc/libfc/fc_sess.c
index 8ac6811..11cd05e 100644
--- a/drivers/scsi/ofc/libfc/fc_sess.c
+++ b/drivers/scsi/ofc/libfc/fc_sess.c
@@ -33,7 +33,6 @@
 #include "sa_timer.h"
 #include "sa_event.h"
 #include "sa_hash.h"
-#include "sa_state.h"
 
 #include "fc_fs.h"
 #include "fc_els.h"
@@ -100,111 +99,6 @@ static void fc_sess_recv_logo_req(struct fc_sess *,
 				  struct fc_seq *, struct fc_frame *);
 static void fc_sess_delete(struct fc_sess *, void *);
 static void fc_sess_timeout(void *);
-static void fc_sess_state_event(struct fc_sess *, enum fc_event);
-
-/*
- * Session state transition table.
- */
-static const struct sa_state_desc fc_sess_state_desc[] = {
-	/*
-	 * Declare events.
-	 */
-	SA_STATE_EVENT(FC_EV_ACC),
-	SA_STATE_EVENT(FC_EV_RJT),
-	SA_STATE_EVENT(FC_EV_TIMEOUT),
-	SA_STATE_EVENT(FC_EV_READY),
-	SA_STATE_EVENT(FC_EV_DOWN),
-	SA_STATE_EVENT(FC_EV_CLOSED),
-	SA_STATE_EVENT(FC_EV_START),
-	SA_STATE_EVENT(FC_EV_STOP),
-
-	/*
-	 * Associate handlers for entering specific states.
-	 */
-	SA_STATE_HANDLER(SESS_ST_INIT, fc_sess_enter_init),
-	SA_STATE_HANDLER(SESS_ST_STARTED, fc_sess_enter_started),
-	SA_STATE_HANDLER(SESS_ST_PLOGI, fc_sess_enter_plogi),
-	SA_STATE_HANDLER(SESS_ST_PRLI, fc_sess_enter_prli),
-	SA_STATE_HANDLER(SESS_ST_RTV, fc_sess_enter_rtv),
-	SA_STATE_HANDLER(SESS_ST_READY, fc_sess_enter_ready),
-	SA_STATE_HANDLER(SESS_ST_LOGO, fc_sess_enter_logo),
-	SA_STATE_HANDLER(SESS_ST_RESTART, fc_sess_enter_logo),
-	SA_STATE_HANDLER(SESS_ST_ERROR, fc_sess_enter_error),
-
-	/*
-	 * Declare states and transitions.
-	 */
-	SA_STATE_NAME(SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_START, SESS_ST_STARTED),
-	SA_STATE_NEXT(FC_EV_DOWN, SESS_ST_INIT),	/* link down */
-	SA_STATE_NEXT(FC_EV_CLOSED, SESS_ST_INIT),	/* received LOGO */
-	SA_STATE_NEXT(FC_EV_STOP, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_RJT, SESS_ST_INIT),
-
-	SA_STATE_NAME(SESS_ST_STARTED),	/* wait for local_port ready */
-	SA_STATE_NEXT(FC_EV_ACC, SESS_ST_PLOGI),
-	SA_STATE_NEXT(FC_EV_READY, SESS_ST_PLOGI),
-	SA_STATE_NEXT(FC_EV_STOP, SESS_ST_INIT),	/* TBD need handler */
-	SA_STATE_NEXT(FC_EV_DOWN, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_CLOSED, SESS_ST_INIT),
-
-	SA_STATE_NAME(SESS_ST_PLOGI),
-	SA_STATE_NEXT(FC_EV_ACC, SESS_ST_PRLI),
-	SA_STATE_NEXT(FC_EV_TIMEOUT, SESS_ST_PLOGI),
-	SA_STATE_NEXT(FC_EV_RJT, SESS_ST_ERROR),
-	SA_STATE_NEXT(FC_EV_DOWN, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_CLOSED, SESS_ST_INIT),
-
-	SA_STATE_NAME(SESS_ST_PLOGI_RECV),
-	SA_STATE_NEXT(FC_EV_CLOSED, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_DOWN, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_CLOSED, SESS_ST_INIT),
-
-	SA_STATE_NAME(SESS_ST_PRLI),
-	SA_STATE_NEXT(FC_EV_ACC, SESS_ST_RTV),
-	SA_STATE_NEXT(FC_EV_STOP, SESS_ST_LOGO),
-	SA_STATE_NEXT(FC_EV_TIMEOUT, SESS_ST_PRLI),
-	SA_STATE_NEXT(FC_EV_RJT, SESS_ST_ERROR),
-	SA_STATE_NEXT(FC_EV_DOWN, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_CLOSED, SESS_ST_INIT),
-
-	SA_STATE_NAME(SESS_ST_RTV),
-	SA_STATE_NEXT(FC_EV_ACC, SESS_ST_READY),
-	SA_STATE_NEXT(FC_EV_STOP, SESS_ST_LOGO),
-	SA_STATE_NEXT(FC_EV_TIMEOUT, SESS_ST_RTV),
-	SA_STATE_NEXT(FC_EV_RJT, SESS_ST_READY),
-	SA_STATE_NEXT(FC_EV_DOWN, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_CLOSED, SESS_ST_INIT),
-
-	SA_STATE_NAME(SESS_ST_READY),
-	SA_STATE_NEXT(FC_EV_STOP, SESS_ST_LOGO),
-	SA_STATE_NEXT(FC_EV_DOWN, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_CLOSED, SESS_ST_INIT),
-
-	SA_STATE_NAME(SESS_ST_LOGO),
-	SA_STATE_NEXT(FC_EV_ACC, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_TIMEOUT, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_DOWN, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_CLOSED, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_STOP, SESS_ST_LOGO),
-
-	SA_STATE_NAME(SESS_ST_RESTART),
-	SA_STATE_NEXT(FC_EV_ACC, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_TIMEOUT, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_DOWN, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_CLOSED, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_STOP, SESS_ST_INIT),
-
-	SA_STATE_NAME(SESS_ST_ERROR),
-	SA_STATE_NEXT(FC_EV_START, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_STOP, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_DOWN, SESS_ST_INIT),
-	SA_STATE_NEXT(FC_EV_CLOSED, SESS_ST_INIT),
-	SA_STATE_END
-};
-
-static struct sa_state_table *fc_sess_state_table;
-static u_int fc_sess_table_refcnt;
 
 /*
  * Lock session.
@@ -264,7 +158,7 @@ static inline void fc_sess_unlock_send(struct fc_sess *sess)
 			return;
 		}
 		if (state == SESS_ST_READY)
-			fc_sess_state_event(sess, FC_EV_STOP);
+			fc_sess_enter_logo(sess);
 	}
 
 	/*
@@ -284,33 +178,12 @@ static inline void fc_sess_unlock_send(struct fc_sess *sess)
 	fc_sess_release(sess);
 }
 
-/*
- * Handle next session state after a successful completion.
- */
-static void fc_sess_state_event(struct fc_sess *sess, enum fc_event event)
+static void fc_sess_state_enter(struct fc_sess *sess, enum fc_sess_state new)
 {
 	ASSERT(fc_sess_locked(sess));
-	if (event != FC_EV_TIMEOUT)
+ 	if (sess->fs_state != new)
 		sess->fs_retries = 0;
-	sa_state_table_step(fc_sess_state_table, &sess->fs_state, event, sess);
-}
-
-static void fc_sess_state_enter(struct fc_sess *sess,
-				enum fc_sess_state next_state)
-{
-	ASSERT(fc_sess_locked(sess));
-	sa_state_table_enter(fc_sess_state_table, &sess->fs_state,
-			     next_state, FC_EV_ACC, sess);
-}
-
-/*
- * Log state transition messages.
- */
-static void fc_sess_log(void *sess_arg, const char *msg)
-{
-	struct fc_sess *sess = sess_arg;
-
-	OFC_DBG("sess to %6x %s", sess->fs_remote_fid, msg);
+ 	sess->fs_state = new;
 }
 
 /*
@@ -321,21 +194,8 @@ int fc_sess_table_create(struct fc_virt_fab *vf)
 	struct sa_hash *tp;
 
 	tp = sa_hash_create(&fc_sess_hash_type, FC_SESS_HASH_SIZE);
-
 	if (!tp)
 		return -1;
-	if (!fc_sess_state_table) {
-		fc_sess_state_table =
-		    sa_state_table_alloc("session", fc_sess_state_desc);
-
-		if (!fc_sess_state_table) {
-			sa_hash_destroy(tp);
-			return -1;
-		}
-		if (fc_sess_debug)
-			sa_state_table_log(fc_sess_state_table, fc_sess_log);
-	}
-	fc_sess_table_refcnt++;
 	vf->vf_sess_by_fids = tp;
 	return 0;
 }
@@ -410,14 +270,7 @@ void fc_sess_table_destroy(struct fc_virt_fab *vf)
 	sa_hash_destroy(vf->vf_sess_by_fids);
 	vf->vf_sess_by_fids = NULL;
 	fc_virt_fab_unlock(vf);
-	ASSERT(fc_sess_state_table);
-	ASSERT(fc_sess_table_refcnt != 0);
-	fc_sess_table_refcnt--;
-	if (fc_sess_state_table && fc_sess_table_refcnt == 0) {
-		sa_state_table_free(fc_sess_state_table);
-		fc_sess_state_table = NULL;
-		synchronize_rcu();
-	}
+	synchronize_rcu();
 }
 
 /*
@@ -566,8 +419,10 @@ void fc_sess_start(struct fc_sess *sess)
 		sess->fs_started = 1;
 		fc_sess_hold(sess);	/* internal hold while active */
 	}
-	if (sess->fs_state == SESS_ST_INIT || sess->fs_state == SESS_ST_ERROR)
-		fc_sess_state_event(sess, FC_EV_START);
+	if (sess->fs_state == SESS_ST_INIT)
+		fc_sess_enter_started(sess);
+	else if (sess->fs_state == SESS_ST_ERROR)
+		fc_sess_enter_init(sess);
 	fc_sess_unlock_send(sess);
 }
 
@@ -577,7 +432,16 @@ void fc_sess_start(struct fc_sess *sess)
 void fc_sess_stop(struct fc_sess *sess)
 {
 	fc_sess_lock(sess);
-	fc_sess_state_event(sess, FC_EV_STOP);
+	switch (sess->fs_state) {
+	case SESS_ST_PRLI:
+	case SESS_ST_RTV:
+	case SESS_ST_READY:
+		fc_sess_enter_logo(sess);
+		break;
+	default:
+		fc_sess_enter_init(sess);
+		break;
+	}
 	fc_sess_unlock_send(sess);
 }
 
@@ -614,7 +478,7 @@ void fc_sess_reset(struct fc_sess *sess)
 		key = fc_sess_key(sess->fs_local_fid, sess->fs_remote_fid);
 		sa_hash_insert(vp->vf_sess_by_fids, &key, sess);
 	}
-	fc_sess_state_enter(sess, SESS_ST_INIT);
+	fc_sess_enter_init(sess);
 	fc_sess_unlock_send(sess);
 	if (started)
 		fc_sess_release(sess);
@@ -711,12 +575,18 @@ int fc_sess_send_req(struct fc_sess *sess, struct fc_frame *fp,
 	return rc;
 }
 
+/*
+ * Handle events from the local port.  These can be READY or CLOSED.
+ */
 static void fc_sess_local_port_event(int event, void *sess_arg)
 {
 	struct fc_sess *sess = sess_arg;
 
 	fc_sess_lock(sess);
-	fc_sess_state_event(sess, event);
+	if (event == FC_EV_READY && sess->fs_state == SESS_ST_STARTED)
+		fc_sess_enter_plogi(sess);
+	else if (event == FC_EV_CLOSED)
+		fc_sess_enter_init(sess);
 	fc_sess_unlock_send(sess);
 }
 
@@ -728,19 +598,68 @@ static void fc_sess_enter_started(struct fc_sess *sess)
 	 * If the local port is already logged on, advance to next state.
 	 * Otherwise the local port will be logged on by fc_sess_unlock().
 	 */
-	ASSERT(fc_sess_locked(sess));
-	ASSERT(sess->fs_state == SESS_ST_STARTED);
+	fc_sess_state_enter(sess, SESS_ST_STARTED);
 	lp = sess->fs_local_port;
 	if (sess == lp->fl_dns_sess || fc_local_port_test_ready(lp))
-		fc_sess_state_event(sess, FC_EV_ACC);
+		fc_sess_enter_plogi(sess);
 }
 
 /*
- * Timeout handler for retrying after allocation failures.
+ * Handle exchange reject or retry exhaustion in various states.
+ */
+static void fc_sess_reject(struct fc_sess *sess)
+{
+	switch (sess->fs_state) {
+	case SESS_ST_PLOGI:
+	case SESS_ST_PRLI:
+		fc_sess_enter_error(sess);
+		break;
+	case SESS_ST_RTV:
+		fc_sess_enter_ready(sess);
+		break;
+	case SESS_ST_LOGO:
+		fc_sess_enter_init(sess);
+		break;
+	case SESS_ST_NONE:
+	case SESS_ST_READY:
+	case SESS_ST_ERROR:
+	case SESS_ST_PLOGI_RECV:
+	case SESS_ST_STARTED:
+	case SESS_ST_INIT:
+		BUG();
+		break;
+	}
+}
+
+/*
+ * Timeout handler for retrying after allocation failures or exchange timeout.
  */
 static void fc_sess_timeout(void *sess_arg)
 {
-	fc_sess_state_event((struct fc_sess *)sess_arg, FC_EV_TIMEOUT);
+	struct fc_sess *sess = sess_arg;
+
+	switch (sess->fs_state) {
+	case SESS_ST_PLOGI:
+		fc_sess_enter_plogi(sess);
+		break;
+	case SESS_ST_PRLI:
+		fc_sess_enter_prli(sess);
+		break;
+	case SESS_ST_RTV:
+		fc_sess_enter_rtv(sess);
+		break;
+	case SESS_ST_LOGO:
+		fc_sess_enter_logo(sess);
+		break;
+	case SESS_ST_NONE:
+	case SESS_ST_READY:
+	case SESS_ST_ERROR:
+	case SESS_ST_PLOGI_RECV:
+	case SESS_ST_STARTED:
+	case SESS_ST_INIT:
+		BUG();
+		break;
+	}
 }
 
 /*
@@ -748,22 +667,19 @@ static void fc_sess_timeout(void *sess_arg)
  */
 static void fc_sess_retry(struct fc_sess *sess)
 {
-	const char *state;
 	struct fc_local_port *lp;
 
 	ASSERT(fc_sess_locked(sess));
-	state = sa_state_name(fc_sess_state_table, sess->fs_state);
+
 	lp = sess->fs_local_port;
-	if (sess->fs_retries == 0)
-		OFC_DBG("sess %6x alloc failure in state %s - will retry",
-		       sess->fs_remote_fid, state);
+
 	if (sess->fs_retries < lp->fl_retry_limit) {
 		sess->fs_retries++;
 		sa_timer_set(&sess->fs_timer, sess->fs_e_d_tov * 1000);
 	} else {
-		OFC_DBG("sess %6x alloc failure in state %s retries exhausted",
-						sess->fs_remote_fid, state);
-		fc_sess_state_event(sess, FC_EV_RJT);
+ 		OFC_DBG("sess %6x alloc failure in state %d - retries exhausted",
+			sess->fs_remote_fid, sess->fs_state);
+ 		fc_sess_reject(sess);
 	}
 }
 
@@ -775,14 +691,16 @@ static void fc_sess_error(enum fc_event event, void *sess_arg)
 	struct fc_sess *sess = sess_arg;
 
 	fc_sess_lock(sess);
+ 	if (fc_sess_debug)
+ 		OFC_DBG("state %d event %d retries %d",
+ 		       sess->fs_state, event, sess->fs_retries);
+
 	if (event == FC_EV_TIMEOUT &&
 	    sess->fs_retries++ >= sess->fs_local_port->fl_retry_limit)
-		event = FC_EV_RJT;
-	if (fc_sess_debug)
-		OFC_DBG("event %s retries %d",
-		       sa_state_event_name(fc_sess_state_table, event),
-		       sess->fs_retries);
-	fc_sess_state_event(sess_arg, event);
+ 		fc_sess_timeout(sess);
+ 	else
+ 		fc_sess_reject(sess);
+	
 	fc_sess_unlock_send(sess);
 }
 
@@ -818,21 +736,20 @@ static void fc_sess_plogi_recv_resp(struct fc_seq *sp, struct fc_frame *fp,
 		if (cssp_seq < csp_seq)
 			csp_seq = cssp_seq;
 		sess->fs_max_seq = csp_seq;
-		fc_sess_state_event(sess, FC_EV_ACC);
+		if (sess->fs_state == SESS_ST_PLOGI)
+ 			fc_sess_enter_prli(sess);
 	} else {
 		if (fc_sess_debug) {
 			OFC_DBG("bad PLOGI response");
 			fc_print_frame_hdr((char *)__FUNCTION__, fp);
 		}
+		
 		rjp = fc_frame_payload_get(fp, sizeof(*rjp));
-#if 0				/* XXX */
 		if (op == ELS_LS_RJT && rjp != NULL &&
 		    rjp->er_reason == ELS_RJT_INPROG)
-			fc_sess_state_event(sess, FC_EV_TIMEOUT);
-/* XXX not right either.   Should have a wait state ... retry after a bit. */
+			fc_sess_retry(sess);    /* try again in a while */
 		else
-#endif
-			fc_sess_state_event(sess, FC_EV_RJT);
+			fc_sess_reject(sess);   /* error */
 	}
 	fc_sess_unlock_send(sess);
 	fc_frame_free(fp);
@@ -847,6 +764,7 @@ static void fc_sess_enter_plogi(struct fc_sess *sess)
 	struct fc_els_flogi *rp;
 
 	ASSERT(fc_sess_locked(sess));
+	fc_sess_state_enter(sess, SESS_ST_PLOGI);
 	sess->fs_max_payload = sess->fs_local_port->fl_max_payload;
 	fp = fc_frame_alloc(sess->fs_local_port->fl_port, sizeof(*rp));
 	if (!fp) {
@@ -872,31 +790,38 @@ static void fc_sess_els_recv_resp(struct fc_seq *sp, struct fc_frame *fp,
 {
 	struct fc_sess *sess = sess_arg;
 	u_char op;
+	struct {
+		struct fc_els_prli prli;
+		struct fc_els_spp spp;
+	} *pp;
 
 	fc_sess_lock(sess);
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC) {
-
 		/*
 		 * For PRLI, get the remote port's service parameter flags.
 		 */
-		if (sess->fs_state == SESS_ST_PRLI) {
-			struct {
-				struct fc_els_prli prli;
-				struct fc_els_spp spp;
-			} *pp;
-
+		switch (sess->fs_state) {
+ 		case SESS_ST_PRLI:
 			pp = fc_frame_payload_get(fp, sizeof(*pp));
 			if (pp && pp->prli.prli_spp_len >= sizeof(pp->spp)) {
 				sess->fs_remote_port->rp_fcp_parm =
-				    net32_get(&pp->spp.spp_params);
+					net32_get(&pp->spp.spp_params);
 			}
+			fc_sess_enter_rtv(sess);
+			break;
+		case SESS_ST_LOGO:
+			fc_sess_enter_rtv(sess);
+			break;
+		default:
+			OFC_DBG("ELS ACC in state %d ignored", sess->fs_state);
+			break;
 		}
-		fc_sess_state_event(sess, FC_EV_ACC);
+		
 	} else {
 		OFC_DBG("bad ELS response\n");
 		fc_print_frame_hdr((char *)__FUNCTION__, fp);	/* XXX */
-		fc_sess_state_event(sess, FC_EV_RJT);
+		fc_sess_enter_error(sess);
 	}
 	fc_sess_unlock_send(sess);
 	fc_frame_free(fp);
@@ -914,6 +839,7 @@ static void fc_sess_enter_prli(struct fc_sess *sess)
 	struct fc_frame *fp;
 
 	ASSERT(fc_sess_locked(sess));
+	fc_sess_state_enter(sess, SESS_ST_PRLI);
 
 	/*
 	 * Special case if session is for name server or any other
@@ -921,7 +847,7 @@ static void fc_sess_enter_prli(struct fc_sess *sess)
 	 * This should be made more general, possibly moved to the FCP layer.
 	 */
 	if (sess->fs_remote_fid >= FC_FID_DOM_MGR) {
-		fc_sess_state_enter(sess, SESS_ST_READY);
+		fc_sess_enter_ready(sess);
 		return;
 	}
 	fp = fc_frame_alloc(sess->fs_local_port->fl_port, sizeof(*pp));
@@ -976,10 +902,8 @@ static void fc_sess_els_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 				tov = 1;
 			sess->fs_e_d_tov = tov;
 		}
-		fc_sess_state_event(sess, FC_EV_ACC);
-	} else {
-		fc_sess_state_event(sess, FC_EV_RJT);
 	}
+	fc_sess_enter_ready(sess);
 	fc_sess_unlock_send(sess);
 	fc_frame_free(fp);
 }
@@ -993,6 +917,7 @@ static void fc_sess_enter_rtv(struct fc_sess *sess)
 	struct fc_frame *fp;
 
 	ASSERT(fc_sess_locked(sess));
+	fc_sess_state_enter(sess, SESS_ST_RTV);
 
 	fp = fc_frame_alloc(sess->fs_local_port->fl_port, sizeof(*rtv));
 	if (!fp) {
@@ -1033,6 +958,7 @@ void fc_sess_event_deq(struct fc_sess *sess, sa_event_handler_t handler,
 static void fc_sess_enter_ready(struct fc_sess *sess)
 {
 	ASSERT(fc_sess_locked(sess));
+	fc_sess_state_enter(sess, SESS_ST_READY);
 	sa_event_call_cancel(sess->fs_events, FC_EV_CLOSED);
 	sa_event_call_cancel(sess->fs_events, FC_EV_RJT);
 	sa_event_call_defer(sess->fs_events, FC_EV_READY);
@@ -1041,6 +967,7 @@ static void fc_sess_enter_ready(struct fc_sess *sess)
 static void fc_sess_enter_init(struct fc_sess *sess)
 {
 	ASSERT(fc_sess_locked(sess));
+	fc_sess_state_enter(sess, SESS_ST_INIT);
 	sa_event_call_cancel(sess->fs_events, FC_EV_READY);
 	sa_event_call_cancel(sess->fs_events, FC_EV_RJT);
 	sa_event_call_defer(sess->fs_events, FC_EV_CLOSED);
@@ -1049,6 +976,7 @@ static void fc_sess_enter_init(struct fc_sess *sess)
 static void fc_sess_enter_error(struct fc_sess *sess)
 {
 	ASSERT(fc_sess_locked(sess));
+	fc_sess_state_enter(sess, SESS_ST_ERROR);
 	sa_event_call_cancel(sess->fs_events, FC_EV_READY);
 	sa_event_call_cancel(sess->fs_events, FC_EV_CLOSED);
 	sa_event_call_defer(sess->fs_events, FC_EV_RJT);
@@ -1061,6 +989,7 @@ static void fc_sess_enter_logo(struct fc_sess *sess)
 	struct fc_local_port *lp;
 
 	ASSERT(fc_sess_locked(sess));
+	fc_sess_state_enter(sess, SESS_ST_LOGO);
 	lp = sess->fs_local_port;
 	fp = fc_frame_alloc(lp->fl_port, sizeof(*logo));
 	if (!fp) {
@@ -1310,7 +1239,7 @@ static void fc_sess_recv_plogi_req(struct fc_sess *sess,
 		 */
 		fc_seq_send_last(sp, fp, FC_RCTL_ELS_REP, FC_TYPE_ELS);
 		if (sess->fs_state == SESS_ST_PLOGI)
-			fc_sess_state_enter(sess, SESS_ST_PRLI);
+			fc_sess_enter_prli(sess);
 		else
 			fc_sess_state_enter(sess, SESS_ST_PLOGI_RECV);
 		fc_sess_hold(sess);	/* represents login */
@@ -1436,7 +1365,7 @@ static void fc_sess_recv_prli_req(struct fc_sess *sess,
 		switch (sess->fs_state) {
 		case SESS_ST_PLOGI_RECV:
 		case SESS_ST_PRLI:
-			fc_sess_state_enter(sess, SESS_ST_READY);
+			fc_sess_enter_ready(sess);
 			break;
 		case SESS_ST_READY:
 			break;
@@ -1473,15 +1402,10 @@ static void fc_sess_recv_logo_req(struct fc_sess *sess, struct fc_seq *sp,
 	u_int held;
 
 	fh = fc_frame_header_get(fp);
-	if (fc_sess_debug)
-		OFC_DBG("incoming LOGO from %x state %s %s",
-			net24_get(&fh->fh_s_id),
-			sa_state_name(fc_sess_state_table, sess->fs_state),
-			sess->fs_started ? "started" : "not started");
 	fc_sess_lock(sess);
-	fc_sess_state_event(sess, FC_EV_CLOSED);
 	held = sess->fs_plogi_held;
 	sess->fs_plogi_held = 0;
+	fc_sess_enter_init(sess);
 	fc_sess_unlock_send(sess);
 	if (held)
 		fc_sess_release(sess);
@@ -1545,69 +1469,3 @@ struct fc_sess *fc_sess_lookup_create(struct fc_local_port *lp,
 	}
 	return sess;
 }
-
-struct fc_sess_disp_arg {
-	char *da_buf;
-	size_t da_len;
-	size_t da_off;
-};
-
-/*
- * Print session state for debugging.
- */
-static void fc_sess_disp_one(struct fc_sess *sess, void *arg)
-{
-	struct fc_sess_disp_arg *ap = arg;
-	struct fc_local_port *lp;
-	struct fc_remote_port *rp;
-
-	lp = sess->fs_local_port;
-	rp = sess->fs_remote_port;
-	ASSERT(lp);
-	ASSERT(rp);
-	if (ap->da_off < ap->da_len) {
-		ap->da_off += snprintf(ap->da_buf + ap->da_off,
-				       ap->da_len - ap->da_off,
-				       "sess %u ref %u state %d %s\n"
-				       "\tlocal  fid %6x "
-				       "wwpn %16.16llx wwnn %16.16llx\n"
-				       "\tremote fid %6x "
-				       "wwpn %16.16llx wwnn %16.16llx\n",
-				       sess->fs_sess_id,
-				       atomic_read(&sess->fs_refcnt),
-				       sess->fs_state,
-				       sa_state_name(fc_sess_state_table,
-						     sess->fs_state),
-				       sess->fs_local_fid, lp->fl_port_wwn,
-				       lp->fl_node_wwn, sess->fs_remote_fid,
-				       rp->rp_port_wwn, rp->rp_node_wwn);
-	}
-}
-
-/*
- * Print session state for debugging.
- */
-size_t fc_sess_disp(struct fc_sess *sess, char *buf, size_t len)
-{
-	struct fc_sess_disp_arg arg;
-
-	arg.da_buf = buf;
-	arg.da_len = len;
-	arg.da_off = 0;
-	fc_sess_disp_one(sess, &arg);
-	return arg.da_off;
-}
-
-/*
- * Supply session states for entire virtual fabric for debugging.
- */
-size_t fc_sess_disp_all(struct fc_virt_fab *vf, char *buf, size_t len)
-{
-	struct fc_sess_disp_arg arg;
-
-	arg.da_buf = buf;
-	arg.da_len = len;
-	arg.da_off = 0;
-	fc_sess_iterate(vf, fc_sess_disp_one, &arg);
-	return arg.da_off;
-}
diff --git a/drivers/scsi/ofc/libfc/fc_sess_impl.h b/drivers/scsi/ofc/libfc/fc_sess_impl.h
index 2660f1a..37166fb 100644
--- a/drivers/scsi/ofc/libfc/fc_sess_impl.h
+++ b/drivers/scsi/ofc/libfc/fc_sess_impl.h
@@ -37,7 +37,6 @@ enum fc_sess_state {
 	SESS_ST_ERROR,		/* error */
 	SESS_ST_READY,		/* ready for use */
 	SESS_ST_LOGO,		/* port logout sent */
-	SESS_ST_RESTART,	/* restarting */
 };
 
 /*
diff --git a/drivers/scsi/ofc/libfc/fcs_state.c b/drivers/scsi/ofc/libfc/fcs_state.c
index d970ac9..794f440 100644
--- a/drivers/scsi/ofc/libfc/fcs_state.c
+++ b/drivers/scsi/ofc/libfc/fcs_state.c
@@ -108,11 +108,11 @@ struct fcs_state *fcs_create(struct fcs_create_args *ap)
 	outer_port = ap->fca_port;
 	mfs = fc_port_get_max_frame_size(outer_port);
 	if (mfs < FC_MIN_MAX_PAYLOAD) {
-		OFC_DBG("port max frame size only %d (0x%x) bytes - "
+		OFC_DBG("port max frame size only %zx (0x%zx) bytes - "
 		       "setting to %d", mfs, mfs, FC_MIN_MAX_PAYLOAD);
 		mfs = 1024;
 	} else if (mfs > FC_MAX_PAYLOAD + sizeof(struct fc_frame_header)) {
-		OFC_DBG("port max frame size too large: %d (0x%x) bytes\n",
+		OFC_DBG("port max frame size too large: %zx (0x%zx) bytes\n",
 		       mfs, mfs);
 		mfs = FC_MAX_PAYLOAD + sizeof(struct fc_frame_header);
 	}
diff --git a/drivers/scsi/ofc/libsa/Makefile b/drivers/scsi/ofc/libsa/Makefile
index 7f13291..42b8733 100644
--- a/drivers/scsi/ofc/libsa/Makefile
+++ b/drivers/scsi/ofc/libsa/Makefile
@@ -8,5 +8,4 @@ libsa-y := \
 	sa_assert.o \
 	sa_event.o \
 	sa_hash_kern.o \
-	sa_state.o \
 	sa_timer.o
diff --git a/drivers/scsi/ofc/libsa/sa_state.c b/drivers/scsi/ofc/libsa/sa_state.c
deleted file mode 100644
index 732d26d..0000000
--- a/drivers/scsi/ofc/libsa/sa_state.c
+++ /dev/null
@@ -1,371 +0,0 @@
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
-#include "sa_assert.h"
-#include "ofc_dbg.h"
-#include "sa_state.h"
-
-/*
- * Transition descriptor table size limit of 256 will allow the transition
- * table to contain just bytes.  A larger limit will make it twice as big.
- * Don't make this more than 65536.
- */
-#ifdef SA_STATE_DESC_LARGE	/* not usually defined */
-#define SA_STATE_DESC_LIMIT (1 << 16)	/* max fc_sess_desc table size */
-typedef u_int16_t sa_state_t;
-#else
-#define SA_STATE_DESC_LIMIT 256	/* max fc_sess_desc table size */
-typedef u_int8_t sa_state_t;
-#endif /* SA_STATE_DESC_LARGE */
-
-/*
- * State descriptor structure.
- */
-struct sa_state {
-	const char *st_name;	/* state name */
-	sa_state_handler_t *st_handler;	/* handler function if any */
-};
-
-/*
- * State transition table handling.
- */
-struct sa_state_table {
-	const char *st_name;	/* name of state table */
-	const struct sa_state_desc *st_desc;	/* condensed description */
-	uint st_desc_limit;	/* size of condensed desc. table */
-	void (*st_log_func) (void *, const char *);	/* log func */
-	u_short st_state_limit;	/* limit on state number */
-	u_short st_event_limit;	/* limit on event index */
-	struct sa_state *st_states;	/* array of state structures */
-	const char **st_event_name;
-
-	/*
-	 * Variable sized state table, indexed by state and event.
-	 */
-	sa_state_t st_next_table[0];
-
-	/*
-	 * Followed by array of struct sa_state
-	 * and then by event names pointers.
-	 */
-};
-
-/*
- * Return the transition table entry for state, event
- */
-static inline sa_state_t *sa_state_table_entry(struct sa_state_table *tp,
-					       u_int state, u_int event)
-{
-	sa_state_t *ep;
-
-	ASSERT(state < tp->st_state_limit);
-	ASSERT(event < tp->st_event_limit);
-
-	ep = &tp->st_next_table[state * tp->st_event_limit + event];
-	ASSERT(*ep < tp->st_desc_limit);
-	return ep;
-}
-
-/*
- * State transition table initialization.
- */
-struct sa_state_table *sa_state_table_alloc(const char *name,
-					    const struct sa_state_desc
-					    *state_desc)
-{
-	u_int state_limit = 0;
-	u_int event_limit = 0;
-	u_int cur_state = 0;
-	u_int desc;
-	int error = 0;
-	size_t len;
-	size_t table_size;
-	u_int event;
-	u_int state;
-	const struct sa_state_desc *dp;
-	struct sa_state_table *tp;
-	struct sa_state *sp;
-	sa_state_t *ep;
-
-	/*
-	 * Find the dimensions of the table we need.
-	 * Validate the table while we're at it.
-	 */
-	for (dp = state_desc; dp->sd_type != SST_END; dp++) {
-		switch (dp->sd_type) {
-		case SST_STATE:
-			if (dp->sd_in == 0) {
-				OFC_DBG("state table %s has invalid state %d "
-				       "at STATE entry %d",
-				       name, dp->sd_in, dp - state_desc);
-				error++;
-			}
-			if (dp->sd_in >= state_limit)
-				state_limit = dp->sd_in + 1;
-			cur_state = dp->sd_in;
-			break;
-		case SST_FROM:
-			if (dp->sd_in == 0) {
-				OFC_DBG("state table %s has invalid state %d "
-				       "at FROM entry %d",
-				       name, dp->sd_in, dp - state_desc);
-				error++;
-			}
-			cur_state = dp->sd_in;
-			break;
-		case SST_EVENT:
-			if (dp->sd_in == 0) {
-				OFC_DBG("state table %s has invalid event %d "
-				       "at EVENT entry %d",
-				       name, dp->sd_in, dp - state_desc);
-				error++;
-			}
-			if (dp->sd_in >= event_limit)
-				event_limit = dp->sd_in + 1;
-			break;
-		case SST_HANDLER:
-			if (dp->sd_ptr == NULL) {
-				OFC_DBG("state table %s has invalid hander %d "
-				       "at HANDLER entry %d",
-				       name, dp->sd_in, dp - state_desc);
-				error++;
-			}
-			if (dp->sd_in >= state_limit)
-				state_limit = dp->sd_in + 1;
-			break;
-		case SST_NEXT:
-			if (cur_state == 0) {
-				OFC_DBG("state table %s has no current state "
-				       "for NEXT entry %d",
-				       name, dp - state_desc);
-				error++;
-			}
-			if (dp->sd_in >= event_limit) {
-				OFC_DBG("state table %s has event %d "
-				       "out of range at NEXT entry %d",
-				       name, dp->sd_in, dp - state_desc);
-				error++;
-			}
-			if (dp->sd_next == 0 || dp->sd_next >= state_limit) {
-				OFC_DBG("state table %s has state %d "
-				       "out of range at NEXT entry %d",
-				       name, dp->sd_next, dp - state_desc);
-				error++;
-			}
-			break;
-		case SST_END:
-			break;
-		}
-	}
-
-	/*
-	 * Allocate the state transition table.
-	 */
-	if (error) {
-		tp = NULL;
-		goto out;
-	}
-	ASSERT_NOTIMPL(state_limit * event_limit <= SA_STATE_DESC_LIMIT);
-	table_size = state_limit * event_limit * sizeof(sa_state_t);
-	table_size = (table_size + sizeof(char *) - 1) & ~(sizeof(char *) - 1);
-	len = sizeof(*tp) + table_size +
-	    state_limit * sizeof(struct sa_state) +
-	    event_limit * sizeof(char *);
-	tp = sa_malloc(len);
-	if (!tp)
-		goto out;
-	memset(tp, 0, len);
-	tp->st_name = name;
-	tp->st_desc = state_desc;
-	tp->st_desc_limit = (uint) (dp - state_desc);
-	ASSERT_NOTIMPL(tp->st_desc_limit <= SA_STATE_DESC_LIMIT);
-	tp->st_state_limit = (u_short) state_limit;
-	tp->st_event_limit = (u_short) event_limit;
-	ep = (sa_state_t *) (tp + 1);
-	tp->st_event_name = (const char **)(ep + table_size / sizeof(*ep));
-	tp->st_states = (struct sa_state *)(tp->st_event_name + event_limit);
-	ASSERT(len == (char *)(tp->st_states + state_limit) - (char *)tp);
-	cur_state = 0;
-
-	/*
-	 * Set up the big table from the compact descriptor table.
-	 */
-	for (dp = state_desc, desc = 0; dp->sd_type != SST_END; dp++, desc++) {
-		switch (dp->sd_type) {
-		case SST_STATE:
-			cur_state = dp->sd_in;
-			ASSERT(cur_state < state_limit);
-			sp = &tp->st_states[cur_state];
-			sp->st_name = dp->sd_ptr;
-			break;
-		case SST_EVENT:
-			ASSERT(dp->sd_in < event_limit);
-			tp->st_event_name[dp->sd_in] = dp->sd_ptr;
-			break;
-		case SST_HANDLER:
-			cur_state = dp->sd_in;
-			ASSERT(cur_state < state_limit);
-			sp = &tp->st_states[cur_state];
-			sp->st_handler =
-			    (/*const */ sa_state_handler_t *) dp->sd_ptr;
-			break;
-		case SST_FROM:
-			ASSERT(dp->sd_in < state_limit);
-			cur_state = dp->sd_in;
-			break;
-		case SST_NEXT:
-			ASSERT(dp->sd_next < state_limit);
-			ASSERT(desc <= SA_STATE_DESC_LIMIT);
-			ep = sa_state_table_entry(tp, cur_state, dp->sd_in);
-			*ep = (sa_state_t) desc;
-			break;
-		case SST_END:
-			break;
-		}
-	}
-
-	/*
-	 * Go through the names entries and make sure none are NULL.
-	 */
-	tp->st_event_name[0] = "none";
-	for (event = 0; event < event_limit; event++)
-		ASSERT(tp->st_event_name[event] != NULL);
-	tp->st_states[0].st_name = "none";
-	for (state = 0; state < state_limit; state++)
-		ASSERT(tp->st_states[state].st_name != NULL);
-out:
-	return tp;
-}
-
-/*
- * Free state table.
- */
-void sa_state_table_free(struct sa_state_table *tp)
-{
-	sa_free(tp);
-}
-
-/*
- * Get an event name.
- */
-const char *sa_state_event_name(struct sa_state_table *tp, u_int event)
-{
-	ASSERT(event < tp->st_event_limit);
-	return tp->st_event_name[event];
-}
-
-/*
- * Get a state name.
- */
-const char *sa_state_name(struct sa_state_table *tp, u_int state)
-{
-	ASSERT(state < tp->st_state_limit);
-	return tp->st_states[state].st_name;
-}
-
-/*
- * Run a step of the state transition table.
- */
-void
-sa_state_table_step(struct sa_state_table *tp, void *statep_arg,
-		    u_int event, void *arg)
-{
-	u_int *statep = statep_arg;
-	u_int old_state;
-	u_int next;
-	sa_state_t entry;
-	const struct sa_state_desc *np;
-	sa_state_handler_t *handler;
-
-	old_state = *statep;
-	ASSERT(old_state < tp->st_state_limit);
-	ASSERT(event < tp->st_event_limit);
-
-	next = 0;
-	handler = NULL;
-	entry = *sa_state_table_entry(tp, old_state, event);
-	if (entry) {
-		np = &tp->st_desc[entry];
-		ASSERT(np->sd_type == SST_NEXT);
-		next = np->sd_next;
-		ASSERT(next < tp->st_state_limit);
-		handler = (sa_state_handler_t *) np->sd_ptr;
-	}
-	if (handler) {
-		(*handler) (arg, next, event);
-	} else if (next != 0) {
-		sa_state_table_enter(tp, statep, next, event, arg);
-	} else {
-		OFC_DBG("state_table %s state %s (%d) "
-		       "event %s (%d) has no handler",
-		       tp->st_name, tp->st_states[old_state].st_name,
-		       old_state, tp->st_event_name[event], event);
-		if (tp->st_log_func) {
-			char buf[128];
-
-			snprintf(buf, sizeof(buf),
-				 "state %s (%d) event %s (%d) has no handler",
-				 tp->st_states[old_state].st_name,
-				 old_state, tp->st_event_name[event], event);
-			(*tp->st_log_func) (arg, buf);
-		}
-	}
-}
-
-/*
- * Transition to the specified state.  Run the handler if any.
- */
-void
-sa_state_table_enter(struct sa_state_table *tp, void *statep_arg,
-		     u_int next, u_int event, void *arg)
-{
-	u_int *statep = statep_arg;
-	u_int old_state;
-	sa_state_handler_t *handler;
-	struct sa_state *sp;
-
-	old_state = *statep;
-	ASSERT(old_state < tp->st_state_limit);
-	ASSERT(next < tp->st_state_limit);
-
-	sp = &tp->st_states[next];
-	if (tp->st_log_func != NULL) {
-		char buf[128];
-
-		snprintf(buf, sizeof(buf), "event %s state %s -> %s",
-			 tp->st_event_name[event],
-			 tp->st_states[old_state].st_name, sp->st_name);
-		(*tp->st_log_func) (arg, buf);
-	}
-	*statep = next;
-	handler = sp->st_handler;
-	if (handler)
-		(*handler) (arg, next, event);
-}
-
-/*
- * sa_state_table_log() - set function to log state table transitions.
- */
-void
-sa_state_table_log(struct sa_state_table *tp,
-		   void (*log_func) (void *arg, const char *msg))
-{
-	tp->st_log_func = log_func;
-}

