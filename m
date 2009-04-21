From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/11] libfc: Track rogue remote ports
Date: Tue, 21 Apr 2009 16:27:04 -0700
Message-ID: <20090421232703.8165.52227.stgit@fritz>
References: <20090421232647.8165.46673.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48826 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbZDUX1F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 19:27:05 -0400
In-Reply-To: <20090421232647.8165.46673.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Abhijeet Joglekar <abjoglek@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Abhijeet Joglekar <abjoglek@cisco.com>

Rogue ports are currently not tracked on any list. The only reference
to them is through any outstanding exchanges pending on the rogue ports.
If the module is removed while a retry is set on a rogue port
(say a Plogi retry for instance), this retry is not cancelled because there
is no reference to the rogue port in the discovery rports list. Thus the
local port can clean itself up, delete the exchange pool, and then the
rogue port timeout can fire and try to start up another exchange.

This patch tracks the rogue ports in a new list disc->rogue_rports. Creating
a new list instead of using the disc->rports list keeps remote port code
change to a minimum.

1)  Whenever a rogue port is created, it is immediately added to the
disc->rogue_rports list.

2) When the rogues port goes to ready, it is removed from the rogue list
and the real remote port is added to the disc->rports list

3) The removal of the rogue from the disc->rogue_rports list is done in
the context of the fc_rport_work() workQ thread in discovery callback.

4) Real rports are removed from the disc->rports list like before. Lookup
is done only in the real rports list. This avoids making large changes
to the remote port code.

5) In fc_disc_stop_rports, the rogues list is traversed in addition to the
real list to stop the rogue ports and issue logoffs on them. This way, rogue
ports get cleaned up when the local port goes away.

6) rogue remote ports are not removed from the list right away, but
removed late in fc_rport_work() context, multiple threads can find the same
remote port in the list and call rport_logoff(). Rport_logoff() only
continues with the logoff if port is not in NONE state, thus preventing
multiple logoffs and multiple list deletions.

7) Since the rport is removed from the disc list at a later stage
(in the disc callback), incoming frames can find the rport even if
rport_logoff() has been called on the rport. When rport_logoff() is called,
the rport state is set to NONE, and we are trying to cancel all exchanges
and retries on that port. While in this state, if an incoming
Plogi/Prli/Logo or other frames match the rport, we should not reply
because the rport is in the NONE state. Just drop the frame, since the
rport will be deleted soon in the disc callback (fc_rport_work)

8)  In fc_disc_single(), remove rport lookup and call to fc_disc_del_target.
fc_disc_single() is called from recv_rscn_req() where rport lookup
and rport_logoff is already done.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |   36 +++++++++++++++++++++++++-----------
 drivers/scsi/libfc/fc_rport.c |   28 ++++++++++++++++++++++++++++
 include/scsi/libfc.h          |    1 +
 3 files changed, 54 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 4480630..4c88065 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -113,6 +113,11 @@ void fc_disc_stop_rports(struct fc_disc *disc)
 		lport->tt.rport_logoff(rport);
 	}
 
+	list_for_each_entry_safe(rdata, next, &disc->rogue_rports, peers) {
+		rport = PRIV_TO_RPORT(rdata);
+		lport->tt.rport_logoff(rport);
+	}
+
 	mutex_unlock(&disc->disc_mutex);
 }
 
@@ -131,23 +136,32 @@ static void fc_disc_rport_callback(struct fc_lport *lport,
 {
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 	struct fc_disc *disc = &lport->disc;
-	int found = 0;
 
 	FC_DEBUG_DISC("Received a %d event for port (%6x)\n", event,
 		      rport->port_id);
 
-	if (event == RPORT_EV_CREATED) {
+	switch (event) {
+	case RPORT_EV_CREATED:
 		if (disc) {
-			found = 1;
 			mutex_lock(&disc->disc_mutex);
 			list_add_tail(&rdata->peers, &disc->rports);
 			mutex_unlock(&disc->disc_mutex);
 		}
+		break;
+	case RPORT_EV_LOGO:
+	case RPORT_EV_FAILED:
+	case RPORT_EV_STOP:
+		mutex_lock(&disc->disc_mutex);
+		mutex_lock(&rdata->rp_mutex);
+		if (rdata->trans_state == FC_PORTSTATE_ROGUE)
+			list_del(&rdata->peers);
+		mutex_unlock(&rdata->rp_mutex);
+		mutex_unlock(&disc->disc_mutex);
+		break;
+	default:
+		break;
 	}
 
-	if (!found)
-		FC_DEBUG_DISC("The rport (%6x) is not maintained "
-			      "by the discovery layer\n", rport->port_id);
 }
 
 /**
@@ -439,6 +453,7 @@ static int fc_disc_new_target(struct fc_disc *disc,
 			rdata = rport->dd_data;
 			rdata->ops = &fc_disc_rport_ops;
 			rdata->rp_state = RPORT_ST_INIT;
+			list_add_tail(&rdata->peers, &disc->rogue_rports);
 			lport->tt.rport_login(rport);
 		}
 	}
@@ -630,6 +645,8 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 				rdata = rport->dd_data;
 				rdata->ops = &fc_disc_rport_ops;
 				rdata->local_port = lport;
+				list_add_tail(&rdata->peers,
+					      &disc->rogue_rports);
 				lport->tt.rport_login(rport);
 			} else
 				FC_DBG("Failed to allocate memory for "
@@ -769,7 +786,6 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 {
 	struct fc_lport *lport;
-	struct fc_rport *rport;
 	struct fc_rport *new_rport;
 	struct fc_rport_libfc_priv *rdata;
 
@@ -778,15 +794,12 @@ static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 	if (dp->ids.port_id == fc_host_port_id(lport->host))
 		goto out;
 
-	rport = lport->tt.rport_lookup(lport, dp->ids.port_id);
-	if (rport)
-		fc_disc_del_target(disc, rport);
-
 	new_rport = lport->tt.rport_create(dp);
 	if (new_rport) {
 		rdata = new_rport->dd_data;
 		rdata->ops = &fc_disc_rport_ops;
 		kfree(dp);
+		list_add_tail(&rdata->peers, &disc->rogue_rports);
 		lport->tt.rport_login(new_rport);
 	}
 	return;
@@ -848,6 +861,7 @@ int fc_disc_init(struct fc_lport *lport)
 	INIT_DELAYED_WORK(&disc->disc_work, fc_disc_timeout);
 	mutex_init(&disc->disc_mutex);
 	INIT_LIST_HEAD(&disc->rports);
+	INIT_LIST_HEAD(&disc->rogue_rports);
 
 	disc->lport = lport;
 	disc->delay = FC_DISC_DELAY;
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index eef70b4..5bf7a94 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -267,6 +267,10 @@ static void fc_rport_work(struct work_struct *work)
 			       "(%6x).\n", ids.port_id);
 			event = RPORT_EV_FAILED;
 		}
+		if (rport->port_id != FC_FID_DIR_SERV)
+			if (rport_ops->event_callback)
+				rport_ops->event_callback(lport, rport,
+							  RPORT_EV_FAILED);
 		put_device(&rport->dev);
 		rport = new_rport;
 		rdata = new_rport->dd_data;
@@ -325,11 +329,20 @@ int fc_rport_login(struct fc_rport *rport)
 int fc_rport_logoff(struct fc_rport *rport)
 {
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_lport *lport = rdata->local_port;
 
 	mutex_lock(&rdata->rp_mutex);
 
 	FC_DEBUG_RPORT("Remove port (%6x)\n", rport->port_id);
 
+	if (rdata->rp_state == RPORT_ST_NONE) {
+		FC_DEBUG_RPORT("(%6x): Port (%6x) in NONE state,"
+			       " not removing", fc_host_port_id(lport->host),
+			       rport->port_id);
+		mutex_unlock(&rdata->rp_mutex);
+		goto out;
+	}
+
 	fc_rport_enter_logo(rport);
 
 	/*
@@ -349,6 +362,7 @@ int fc_rport_logoff(struct fc_rport *rport)
 
 	mutex_unlock(&rdata->rp_mutex);
 
+out:
 	return 0;
 }
 
@@ -1015,6 +1029,8 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 	default:
 		FC_DEBUG_RPORT("incoming PLOGI from %x in unexpected "
 			       "state %d\n", sid, rdata->rp_state);
+		fc_frame_free(fp);
+		return;
 		break;
 	}
 
@@ -1106,6 +1122,8 @@ static void fc_rport_recv_prli_req(struct fc_rport *rport,
 		reason = ELS_RJT_NONE;
 		break;
 	default:
+		fc_frame_free(rx_fp);
+		return;
 		break;
 	}
 	len = fr_len(rx_fp) - sizeof(*fh);
@@ -1235,6 +1253,11 @@ static void fc_rport_recv_prlo_req(struct fc_rport *rport, struct fc_seq *sp,
 		       "while in state %s\n", ntoh24(fh->fh_s_id),
 		       fc_rport_state(rport));
 
+	if (rdata->rp_state == RPORT_ST_NONE) {
+		fc_frame_free(fp);
+		return;
+	}
+
 	rjt_data.fp = NULL;
 	rjt_data.reason = ELS_RJT_UNAB;
 	rjt_data.explan = ELS_EXPL_NONE;
@@ -1264,6 +1287,11 @@ static void fc_rport_recv_logo_req(struct fc_rport *rport, struct fc_seq *sp,
 		       "while in state %s\n", ntoh24(fh->fh_s_id),
 		       fc_rport_state(rport));
 
+	if (rdata->rp_state == RPORT_ST_NONE) {
+		fc_frame_free(fp);
+		return;
+	}
+
 	rdata->event = RPORT_EV_LOGO;
 	queue_work(rport_event_queue, &rdata->event_work);
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 0303a6a..45f9cc6 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -637,6 +637,7 @@ struct fc_disc {
 			      enum fc_disc_event);
 
 	struct list_head	 rports;
+	struct list_head	 rogue_rports;
 	struct fc_lport		*lport;
 	struct mutex		disc_mutex;
 	struct fc_gpn_ft_resp	partial_buf;	/* partial name buffer */

