From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/20] libfc: Replace ->rport_destroy callback with function call
Date: Tue, 18 Oct 2016 10:01:39 +0200
Message-ID: <1476777714-3543-6-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47328 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751993AbcJRIC2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:28 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->rport_destroy callback only ever had one implementation,
so we can as well call it directly and drop the callback.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 12 ++++----
 drivers/scsi/libfc/fc_disc.c  |  6 ++--
 drivers/scsi/libfc/fc_lport.c |  6 ++--
 drivers/scsi/libfc/fc_rport.c | 68 +++++++++++++++++++------------------------
 include/scsi/libfc.h          |  7 +----
 5 files changed, 43 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 6cedc51..4fc7677 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2180,7 +2180,7 @@ static void fcoe_ctlr_disc_stop_locked(struct fc_lport *lport)
 	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers) {
 		if (kref_get_unless_zero(&rdata->kref)) {
 			lport->tt.rport_logoff(rdata);
-			kref_put(&rdata->kref, lport->tt.rport_destroy);
+			kref_put(&rdata->kref, fc_rport_destroy);
 		}
 	}
 	rcu_read_unlock();
@@ -2566,7 +2566,7 @@ static int fcoe_ctlr_vn_lookup(struct fcoe_ctlr *fip, u32 port_id, u8 *mac)
 		frport = fcoe_ctlr_rport(rdata);
 		memcpy(mac, frport->enode_mac, ETH_ALEN);
 		ret = 0;
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 	}
 	return ret;
 }
@@ -2678,7 +2678,7 @@ static void fcoe_ctlr_vn_beacon(struct fcoe_ctlr *fip,
 			}
 			frport->time = jiffies;
 		}
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 		return;
 	}
 	if (fip->state != FIP_ST_VNMP_UP)
@@ -2719,7 +2719,7 @@ static unsigned long fcoe_ctlr_vn_age(struct fcoe_ctlr *fip)
 			continue;
 		frport = fcoe_ctlr_rport(rdata);
 		if (!frport->time) {
-			kref_put(&rdata->kref, lport->tt.rport_destroy);
+			kref_put(&rdata->kref, fc_rport_destroy);
 			continue;
 		}
 		deadline = frport->time +
@@ -2732,7 +2732,7 @@ static unsigned long fcoe_ctlr_vn_age(struct fcoe_ctlr *fip)
 			lport->tt.rport_logoff(rdata);
 		} else if (time_before(deadline, next_time))
 			next_time = deadline;
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 	}
 	rcu_read_unlock();
 	return next_time;
@@ -3089,7 +3089,7 @@ static void fcoe_ctlr_vn_disc(struct fcoe_ctlr *fip)
 		frport = fcoe_ctlr_rport(rdata);
 		if (frport->time)
 			lport->tt.rport_login(rdata);
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 	}
 	rcu_read_unlock();
 	if (callback)
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 4e31152..e5ffeab 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -72,7 +72,7 @@ static void fc_disc_stop_rports(struct fc_disc *disc)
 	list_for_each_entry_rcu(rdata, &disc->rports, peers) {
 		if (kref_get_unless_zero(&rdata->kref)) {
 			lport->tt.rport_logoff(rdata);
-			kref_put(&rdata->kref, lport->tt.rport_destroy);
+			kref_put(&rdata->kref, fc_rport_destroy);
 		}
 	}
 	rcu_read_unlock();
@@ -303,7 +303,7 @@ static void fc_disc_done(struct fc_disc *disc, enum fc_disc_event event)
 			else
 				lport->tt.rport_logoff(rdata);
 		}
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 	}
 	rcu_read_unlock();
 	mutex_unlock(&disc->disc_mutex);
@@ -649,7 +649,7 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 		mutex_unlock(&disc->disc_mutex);
 	}
 out:
-	kref_put(&rdata->kref, lport->tt.rport_destroy);
+	kref_put(&rdata->kref, fc_rport_destroy);
 }
 
 /**
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 1a4f176..ad45808 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -247,7 +247,7 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
 {
 	if (lport->ptp_rdata) {
 		lport->tt.rport_logoff(lport->ptp_rdata);
-		kref_put(&lport->ptp_rdata->kref, lport->tt.rport_destroy);
+		kref_put(&lport->ptp_rdata->kref, fc_rport_destroy);
 	}
 	mutex_lock(&lport->disc.disc_mutex);
 	lport->ptp_rdata = lport->tt.rport_create(lport, remote_fid);
@@ -1017,7 +1017,7 @@ static void fc_lport_reset_locked(struct fc_lport *lport)
 
 	if (lport->ptp_rdata) {
 		lport->tt.rport_logoff(lport->ptp_rdata);
-		kref_put(&lport->ptp_rdata->kref, lport->tt.rport_destroy);
+		kref_put(&lport->ptp_rdata->kref, fc_rport_destroy);
 		lport->ptp_rdata = NULL;
 	}
 
@@ -2129,7 +2129,7 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 			if (!rdata)
 				break;
 			tov = rdata->e_d_tov;
-			kref_put(&rdata->kref, lport->tt.rport_destroy);
+			kref_put(&rdata->kref, fc_rport_destroy);
 		}
 
 		rc = fc_lport_ct_request(job, lport, did, tov);
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index d275df0..47ab962 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -176,13 +176,14 @@ static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
  * fc_rport_destroy() - Free a remote port after last reference is released
  * @kref: The remote port's kref
  */
-static void fc_rport_destroy(struct kref *kref)
+void fc_rport_destroy(struct kref *kref)
 {
 	struct fc_rport_priv *rdata;
 
 	rdata = container_of(kref, struct fc_rport_priv, kref);
 	kfree_rcu(rdata, rcu);
 }
+EXPORT_SYMBOL(fc_rport_destroy);
 
 /**
  * fc_rport_state() - Return a string identifying the remote port's state
@@ -294,7 +295,7 @@ static void fc_rport_work(struct work_struct *work)
 		if (!rport) {
 			FC_RPORT_DBG(rdata, "Failed to add the rport\n");
 			lport->tt.rport_logoff(rdata);
-			kref_put(&rdata->kref, lport->tt.rport_destroy);
+			kref_put(&rdata->kref, fc_rport_destroy);
 			return;
 		}
 		mutex_lock(&rdata->rp_mutex);
@@ -320,7 +321,7 @@ static void fc_rport_work(struct work_struct *work)
 			FC_RPORT_DBG(rdata, "lld callback ev %d\n", event);
 			rdata->lld_event_callback(lport, rdata, event);
 		}
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 		break;
 
 	case RPORT_EV_FAILED:
@@ -347,7 +348,7 @@ static void fc_rport_work(struct work_struct *work)
 			rdata->lld_event_callback(lport, rdata, event);
 		}
 		if (cancel_delayed_work_sync(&rdata->retry_work))
-			kref_put(&rdata->kref, lport->tt.rport_destroy);
+			kref_put(&rdata->kref, fc_rport_destroy);
 
 		/*
 		 * Reset any outstanding exchanges before freeing rport.
@@ -369,7 +370,7 @@ static void fc_rport_work(struct work_struct *work)
 			if (port_id == FC_FID_DIR_SERV) {
 				rdata->event = RPORT_EV_NONE;
 				mutex_unlock(&rdata->rp_mutex);
-				kref_put(&rdata->kref, lport->tt.rport_destroy);
+				kref_put(&rdata->kref, fc_rport_destroy);
 			} else if ((rdata->flags & FC_RP_STARTED) &&
 				   rdata->major_retries <
 				   lport->max_rport_retry_count) {
@@ -384,7 +385,7 @@ static void fc_rport_work(struct work_struct *work)
 				list_del_rcu(&rdata->peers);
 				mutex_unlock(&lport->disc.disc_mutex);
 				mutex_unlock(&rdata->rp_mutex);
-				kref_put(&rdata->kref, lport->tt.rport_destroy);
+				kref_put(&rdata->kref, fc_rport_destroy);
 			}
 		} else {
 			/*
@@ -403,7 +404,7 @@ static void fc_rport_work(struct work_struct *work)
 		mutex_unlock(&rdata->rp_mutex);
 		break;
 	}
-	kref_put(&rdata->kref, lport->tt.rport_destroy);
+	kref_put(&rdata->kref, fc_rport_destroy);
 }
 
 /**
@@ -470,8 +471,6 @@ static int fc_rport_login(struct fc_rport_priv *rdata)
 static void fc_rport_enter_delete(struct fc_rport_priv *rdata,
 				  enum fc_rport_event event)
 {
-	struct fc_lport *lport = rdata->local_port;
-
 	if (rdata->rp_state == RPORT_ST_DELETE)
 		return;
 
@@ -482,7 +481,7 @@ static void fc_rport_enter_delete(struct fc_rport_priv *rdata,
 	kref_get(&rdata->kref);
 	if (rdata->event == RPORT_EV_NONE &&
 	    !queue_work(rport_event_queue, &rdata->event_work))
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 
 	rdata->event = event;
 }
@@ -541,8 +540,6 @@ static int fc_rport_logoff(struct fc_rport_priv *rdata)
  */
 static void fc_rport_enter_ready(struct fc_rport_priv *rdata)
 {
-	struct fc_lport *lport = rdata->local_port;
-
 	fc_rport_state_enter(rdata, RPORT_ST_READY);
 
 	FC_RPORT_DBG(rdata, "Port is Ready\n");
@@ -550,7 +547,7 @@ static void fc_rport_enter_ready(struct fc_rport_priv *rdata)
 	kref_get(&rdata->kref);
 	if (rdata->event == RPORT_EV_NONE &&
 	    !queue_work(rport_event_queue, &rdata->event_work))
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 
 	rdata->event = RPORT_EV_READY;
 }
@@ -569,7 +566,6 @@ static void fc_rport_timeout(struct work_struct *work)
 {
 	struct fc_rport_priv *rdata =
 		container_of(work, struct fc_rport_priv, retry_work.work);
-	struct fc_lport *lport = rdata->local_port;
 
 	mutex_lock(&rdata->rp_mutex);
 	FC_RPORT_DBG(rdata, "Port timeout, state %s\n", fc_rport_state(rdata));
@@ -598,7 +594,7 @@ static void fc_rport_timeout(struct work_struct *work)
 	}
 
 	mutex_unlock(&rdata->rp_mutex);
-	kref_put(&rdata->kref, lport->tt.rport_destroy);
+	kref_put(&rdata->kref, fc_rport_destroy);
 }
 
 /**
@@ -661,7 +657,6 @@ static void fc_rport_error(struct fc_rport_priv *rdata, int err)
 static void fc_rport_error_retry(struct fc_rport_priv *rdata, int err)
 {
 	unsigned long delay = msecs_to_jiffies(rdata->e_d_tov);
-	struct fc_lport *lport = rdata->local_port;
 
 	/* make sure this isn't an FC_EX_CLOSED error, never retry those */
 	if (err == -FC_EX_CLOSED)
@@ -676,7 +671,7 @@ static void fc_rport_error_retry(struct fc_rport_priv *rdata, int err)
 			delay = 0;
 		kref_get(&rdata->kref);
 		if (!schedule_delayed_work(&rdata->retry_work, delay))
-			kref_put(&rdata->kref, lport->tt.rport_destroy);
+			kref_put(&rdata->kref, fc_rport_destroy);
 		return;
 	}
 
@@ -802,7 +797,7 @@ static void fc_rport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 err:
 	mutex_unlock(&rdata->rp_mutex);
 put:
-	kref_put(&rdata->kref, lport->tt.rport_destroy);
+	kref_put(&rdata->kref, fc_rport_destroy);
 	return;
 bad:
 	FC_RPORT_DBG(rdata, "Bad FLOGI response\n");
@@ -841,7 +836,7 @@ static void fc_rport_enter_flogi(struct fc_rport_priv *rdata)
 				  fc_rport_flogi_resp, rdata,
 				  2 * lport->r_a_tov)) {
 		fc_rport_error_retry(rdata, -FC_EX_XMIT_ERR);
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 	}
 }
 
@@ -960,12 +955,12 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 	}
 out:
 	mutex_unlock(&rdata->rp_mutex);
-	kref_put(&rdata->kref, lport->tt.rport_destroy);
+	kref_put(&rdata->kref, fc_rport_destroy);
 	fc_frame_free(rx_fp);
 	return;
 
 reject_put:
-	kref_put(&rdata->kref, lport->tt.rport_destroy);
+	kref_put(&rdata->kref, fc_rport_destroy);
 reject:
 	fc_seq_els_rsp_send(rx_fp, ELS_LS_RJT, &rjt_data);
 	fc_frame_free(rx_fp);
@@ -1042,7 +1037,7 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 err:
 	mutex_unlock(&rdata->rp_mutex);
 put:
-	kref_put(&rdata->kref, lport->tt.rport_destroy);
+	kref_put(&rdata->kref, fc_rport_destroy);
 }
 
 static bool
@@ -1098,7 +1093,7 @@ static void fc_rport_enter_plogi(struct fc_rport_priv *rdata)
 				  fc_rport_plogi_resp, rdata,
 				  2 * lport->r_a_tov)) {
 		fc_rport_error_retry(rdata, -FC_EX_XMIT_ERR);
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 	}
 }
 
@@ -1218,7 +1213,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 err:
 	mutex_unlock(&rdata->rp_mutex);
 put:
-	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
+	kref_put(&rdata->kref, fc_rport_destroy);
 }
 
 /**
@@ -1285,7 +1280,7 @@ static void fc_rport_enter_prli(struct fc_rport_priv *rdata)
 	if (!fc_exch_seq_send(lport, fp, fc_rport_prli_resp,
 			      NULL, rdata, 2 * lport->r_a_tov)) {
 		fc_rport_error_retry(rdata, -FC_EX_XMIT_ERR);
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 	}
 }
 
@@ -1358,7 +1353,7 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 err:
 	mutex_unlock(&rdata->rp_mutex);
 put:
-	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
+	kref_put(&rdata->kref, fc_rport_destroy);
 }
 
 /**
@@ -1391,7 +1386,7 @@ static void fc_rport_enter_rtv(struct fc_rport_priv *rdata)
 				  fc_rport_rtv_resp, rdata,
 				  2 * lport->r_a_tov)) {
 		fc_rport_error_retry(rdata, -FC_EX_XMIT_ERR);
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 	}
 }
 
@@ -1446,7 +1441,7 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 			"Received a LOGO %s\n", fc_els_resp_type(fp));
 	if (!IS_ERR(fp))
 		fc_frame_free(fp);
-	kref_put(&rdata->kref, lport->tt.rport_destroy);
+	kref_put(&rdata->kref, fc_rport_destroy);
 }
 
 /**
@@ -1472,7 +1467,7 @@ static void fc_rport_enter_logo(struct fc_rport_priv *rdata)
 	kref_get(&rdata->kref);
 	if (!lport->tt.elsct_send(lport, rdata->ids.port_id, fp, ELS_LOGO,
 				  fc_rport_logo_resp, rdata, 0))
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 }
 
 /**
@@ -1534,7 +1529,7 @@ static void fc_rport_adisc_resp(struct fc_seq *sp, struct fc_frame *fp,
 err:
 	mutex_unlock(&rdata->rp_mutex);
 put:
-	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
+	kref_put(&rdata->kref, fc_rport_destroy);
 }
 
 /**
@@ -1566,7 +1561,7 @@ static void fc_rport_enter_adisc(struct fc_rport_priv *rdata)
 				  fc_rport_adisc_resp, rdata,
 				  2 * lport->r_a_tov)) {
 		fc_rport_error_retry(rdata, -FC_EX_XMIT_ERR);
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 	}
 }
 
@@ -1711,7 +1706,7 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
 				     "while in state %s\n",
 				     fc_rport_state(rdata));
 			mutex_unlock(&rdata->rp_mutex);
-			kref_put(&rdata->kref, lport->tt.rport_destroy);
+			kref_put(&rdata->kref, fc_rport_destroy);
 			goto busy;
 		}
 	default:
@@ -1719,7 +1714,7 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
 			     "Reject ELS 0x%02x while in state %s\n",
 			     fc_frame_payload_op(fp), fc_rport_state(rdata));
 		mutex_unlock(&rdata->rp_mutex);
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 		goto reject;
 	}
 
@@ -1753,7 +1748,7 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
 	}
 
 	mutex_unlock(&rdata->rp_mutex);
-	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
+	kref_put(&rdata->kref, fc_rport_destroy);
 	return;
 
 reject:
@@ -2158,7 +2153,7 @@ static void fc_rport_recv_logo_req(struct fc_lport *lport, struct fc_frame *fp)
 
 		fc_rport_enter_delete(rdata, RPORT_EV_STOP);
 		mutex_unlock(&rdata->rp_mutex);
-		kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
+		kref_put(&rdata->kref, fc_rport_destroy);
 	} else
 		FC_RPORT_ID_DBG(lport, sid,
 				"Received LOGO from non-logged-in port\n");
@@ -2197,9 +2192,6 @@ int fc_rport_init(struct fc_lport *lport)
 	if (!lport->tt.rport_flush_queue)
 		lport->tt.rport_flush_queue = fc_rport_flush_queue;
 
-	if (!lport->tt.rport_destroy)
-		lport->tt.rport_destroy = fc_rport_destroy;
-
 	return 0;
 }
 EXPORT_SYMBOL(fc_rport_init);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 5e8a208..cec450f 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -652,12 +652,6 @@ struct libfc_function_template {
 	struct fc_rport_priv *(*rport_lookup)(const struct fc_lport *, u32);
 
 	/*
-	 * Destroy an rport after final kref_put().
-	 * The argument is a pointer to the kref inside the fc_rport_priv.
-	 */
-	void (*rport_destroy)(struct kref *);
-
-	/*
 	 * Callback routine after the remote port is logged in
 	 *
 	 * STATUS: OPTIONAL
@@ -1035,6 +1029,7 @@ static inline bool fc_fcp_is_read(const struct fc_fcp_pkt *fsp)
  *****************************/
 int fc_rport_init(struct fc_lport *);
 void fc_rport_terminate_io(struct fc_rport *);
+void fc_rport_destroy(struct kref *kref);
 
 /*
  * DISCOVERY LAYER
-- 
1.8.5.6

