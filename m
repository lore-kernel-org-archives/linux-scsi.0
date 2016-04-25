From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] libfc: replace 'rp_mutex' with 'rp_lock'
Date: Mon, 25 Apr 2016 10:01:33 +0200
Message-ID: <1461571293-953-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbcDYIBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 04:01:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

We cannot use an embedded mutex in a structure with reference
counting, as mutex unlock might be delayed, and the waiters
might then access an already freed memory area.
So convert it to a spinlock.

For details cf https://lkml.org/lkml/2015/2/11/245

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/libfc/fc_rport.c | 90 +++++++++++++++++++++----------------------
 include/scsi/libfc.h          |  4 +-
 2 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 589ff9a..4520b5a 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -136,7 +136,7 @@ static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
 	rdata->ids.roles = FC_RPORT_ROLE_UNKNOWN;
 
 	kref_init(&rdata->kref);
-	mutex_init(&rdata->rp_mutex);
+	spin_lock_init(&rdata->rp_lock);
 	rdata->local_port = lport;
 	rdata->rp_state = RPORT_ST_INIT;
 	rdata->event = RPORT_EV_NONE;
@@ -251,7 +251,7 @@ static void fc_rport_work(struct work_struct *work)
 	struct fc4_prov *prov;
 	u8 type;
 
-	mutex_lock(&rdata->rp_mutex);
+	spin_lock(&rdata->rp_lock);
 	event = rdata->event;
 	rport_ops = rdata->ops;
 	rport = rdata->rport;
@@ -264,7 +264,7 @@ static void fc_rport_work(struct work_struct *work)
 		rdata->event = RPORT_EV_NONE;
 		rdata->major_retries = 0;
 		kref_get(&rdata->kref);
-		mutex_unlock(&rdata->rp_mutex);
+		spin_unlock(&rdata->rp_lock);
 
 		if (!rport)
 			rport = fc_remote_port_add(lport->host, 0, &ids);
@@ -274,7 +274,7 @@ static void fc_rport_work(struct work_struct *work)
 			kref_put(&rdata->kref, lport->tt.rport_destroy);
 			return;
 		}
-		mutex_lock(&rdata->rp_mutex);
+		spin_lock(&rdata->rp_lock);
 		if (rdata->rport)
 			FC_RPORT_DBG(rdata, "rport already allocated\n");
 		rdata->rport = rport;
@@ -287,7 +287,7 @@ static void fc_rport_work(struct work_struct *work)
 		rpriv->flags = rdata->flags;
 		rpriv->e_d_tov = rdata->e_d_tov;
 		rpriv->r_a_tov = rdata->r_a_tov;
-		mutex_unlock(&rdata->rp_mutex);
+		spin_unlock(&rdata->rp_lock);
 
 		if (rport_ops && rport_ops->event_callback) {
 			FC_RPORT_DBG(rdata, "callback ev %d\n", event);
@@ -313,7 +313,7 @@ static void fc_rport_work(struct work_struct *work)
 			mutex_unlock(&fc_prov_mutex);
 		}
 		port_id = rdata->ids.port_id;
-		mutex_unlock(&rdata->rp_mutex);
+		spin_unlock(&rdata->rp_lock);
 
 		if (rport_ops && rport_ops->event_callback) {
 			FC_RPORT_DBG(rdata, "callback ev %d\n", event);
@@ -334,18 +334,18 @@ static void fc_rport_work(struct work_struct *work)
 		if (rport) {
 			rpriv = rport->dd_data;
 			rpriv->rp_state = RPORT_ST_DELETE;
-			mutex_lock(&rdata->rp_mutex);
+			spin_lock(&rdata->rp_lock);
 			rdata->rport = NULL;
-			mutex_unlock(&rdata->rp_mutex);
+			spin_unlock(&rdata->rp_lock);
 			fc_remote_port_delete(rport);
 		}
 
 		mutex_lock(&lport->disc.disc_mutex);
-		mutex_lock(&rdata->rp_mutex);
+		spin_lock(&rdata->rp_lock);
 		if (rdata->rp_state == RPORT_ST_DELETE) {
 			if (port_id == FC_FID_DIR_SERV) {
 				rdata->event = RPORT_EV_NONE;
-				mutex_unlock(&rdata->rp_mutex);
+				spin_unlock(&rdata->rp_lock);
 				kref_put(&rdata->kref, lport->tt.rport_destroy);
 			} else if ((rdata->flags & FC_RP_STARTED) &&
 				   rdata->major_retries <
@@ -354,11 +354,11 @@ static void fc_rport_work(struct work_struct *work)
 				rdata->event = RPORT_EV_NONE;
 				FC_RPORT_DBG(rdata, "work restart\n");
 				fc_rport_enter_flogi(rdata);
-				mutex_unlock(&rdata->rp_mutex);
+				spin_unlock(&rdata->rp_lock);
 			} else {
 				FC_RPORT_DBG(rdata, "work delete\n");
 				list_del_rcu(&rdata->peers);
-				mutex_unlock(&rdata->rp_mutex);
+				spin_unlock(&rdata->rp_lock);
 				kref_put(&rdata->kref, lport->tt.rport_destroy);
 			}
 		} else {
@@ -368,13 +368,13 @@ static void fc_rport_work(struct work_struct *work)
 			rdata->event = RPORT_EV_NONE;
 			if (rdata->rp_state == RPORT_ST_READY)
 				fc_rport_enter_ready(rdata);
-			mutex_unlock(&rdata->rp_mutex);
+			spin_unlock(&rdata->rp_lock);
 		}
 		mutex_unlock(&lport->disc.disc_mutex);
 		break;
 
 	default:
-		mutex_unlock(&rdata->rp_mutex);
+		spin_unlock(&rdata->rp_lock);
 		break;
 	}
 }
@@ -393,7 +393,7 @@ static void fc_rport_work(struct work_struct *work)
  */
 static int fc_rport_login(struct fc_rport_priv *rdata)
 {
-	mutex_lock(&rdata->rp_mutex);
+	spin_lock(&rdata->rp_lock);
 
 	rdata->flags |= FC_RP_STARTED;
 	switch (rdata->rp_state) {
@@ -409,7 +409,7 @@ static int fc_rport_login(struct fc_rport_priv *rdata)
 		fc_rport_enter_flogi(rdata);
 		break;
 	}
-	mutex_unlock(&rdata->rp_mutex);
+	spin_unlock(&rdata->rp_lock);
 
 	return 0;
 }
@@ -453,7 +453,7 @@ static void fc_rport_enter_delete(struct fc_rport_priv *rdata,
  */
 static int fc_rport_logoff(struct fc_rport_priv *rdata)
 {
-	mutex_lock(&rdata->rp_mutex);
+	spin_lock(&rdata->rp_lock);
 
 	FC_RPORT_DBG(rdata, "Remove port\n");
 
@@ -470,7 +470,7 @@ static int fc_rport_logoff(struct fc_rport_priv *rdata)
 	 */
 	fc_rport_enter_delete(rdata, RPORT_EV_STOP);
 out:
-	mutex_unlock(&rdata->rp_mutex);
+	spin_unlock(&rdata->rp_lock);
 	return 0;
 }
 
@@ -505,7 +505,7 @@ static void fc_rport_timeout(struct work_struct *work)
 	struct fc_rport_priv *rdata =
 		container_of(work, struct fc_rport_priv, retry_work.work);
 
-	mutex_lock(&rdata->rp_mutex);
+	spin_lock(&rdata->rp_lock);
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_FLOGI:
@@ -530,7 +530,7 @@ static void fc_rport_timeout(struct work_struct *work)
 		break;
 	}
 
-	mutex_unlock(&rdata->rp_mutex);
+	spin_unlock(&rdata->rp_lock);
 }
 
 /**
@@ -666,7 +666,7 @@ static void fc_rport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	if (fp == ERR_PTR(-FC_EX_CLOSED))
 		goto put;
 
-	mutex_lock(&rdata->rp_mutex);
+	spin_lock(&rdata->rp_lock);
 
 	if (rdata->rp_state != RPORT_ST_FLOGI) {
 		FC_RPORT_DBG(rdata, "Received a FLOGI response, but in state "
@@ -700,7 +700,7 @@ static void fc_rport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 out:
 	fc_frame_free(fp);
 err:
-	mutex_unlock(&rdata->rp_mutex);
+	spin_unlock(&rdata->rp_lock);
 put:
 	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 	return;
@@ -783,7 +783,7 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 		rjt_data.explan = ELS_EXPL_NOT_NEIGHBOR;
 		goto reject;
 	}
-	mutex_lock(&rdata->rp_mutex);
+	spin_lock(&rdata->rp_lock);
 
 	FC_RPORT_DBG(rdata, "Received FLOGI in %s state\n",
 		     fc_rport_state(rdata));
@@ -805,7 +805,7 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 		if (lport->point_to_multipoint)
 			break;
 	case RPORT_ST_DELETE:
-		mutex_unlock(&rdata->rp_mutex);
+		spin_unlock(&rdata->rp_lock);
 		rjt_data.reason = ELS_RJT_FIP;
 		rjt_data.explan = ELS_EXPL_NOT_NEIGHBOR;
 		goto reject;
@@ -822,13 +822,13 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 		 * This queues work to be sure exchanges are reset.
 		 */
 		fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
-		mutex_unlock(&rdata->rp_mutex);
+		spin_unlock(&rdata->rp_lock);
 		rjt_data.reason = ELS_RJT_BUSY;
 		rjt_data.explan = ELS_EXPL_NONE;
 		goto reject;
 	}
 	if (fc_rport_login_complete(rdata, fp)) {
-		mutex_unlock(&rdata->rp_mutex);
+		spin_unlock(&rdata->rp_lock);
 		rjt_data.reason = ELS_RJT_LOGIC;
 		rjt_data.explan = ELS_EXPL_NONE;
 		goto reject;
@@ -850,7 +850,7 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 	else
 		fc_rport_state_enter(rdata, RPORT_ST_PLOGI_WAIT);
 out:
-	mutex_unlock(&rdata->rp_mutex);
+	spin_unlock(&rdata->rp_lock);
 	mutex_unlock(&disc->disc_mutex);
 	fc_frame_free(rx_fp);
 	return;
@@ -881,7 +881,7 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	u16 cssp_seq;
 	u8 op;
 
-	mutex_lock(&rdata->rp_mutex);
+	spin_lock(&rdata->rp_lock);
 
 	FC_RPORT_DBG(rdata, "Received a PLOGI %s\n", fc_els_resp_type(fp));
 
@@ -922,7 +922,7 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 out:
 	fc_frame_free(fp);
 err:
-	mutex_unlock(&rdata->rp_mutex);
+	spin_unlock(&rdata->rp_lock);
 	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 }
 
@@ -1005,7 +1005,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 	u8 op;
 	u8 resp_code = 0;
 
-	mutex_lock(&rdata->rp_mutex);
+	spin_lock(&rdata->rp_lock);
 
 	FC_RPORT_DBG(rdata, "Received a PRLI %s\n", fc_els_resp_type(fp));
 
@@ -1075,7 +1075,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 out:
 	fc_frame_free(fp);
 err:
-	mutex_unlock(&rdata->rp_mutex);
+	spin_unlock(&rdata->rp_lock);
 	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 }
 
@@ -1153,7 +1153,7 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_rport_priv *rdata = rdata_arg;
 	u8 op;
 
-	mutex_lock(&rdata->rp_mutex);
+	spin_lock(&rdata->rp_lock);
 
 	FC_RPORT_DBG(rdata, "Received a RTV %s\n", fc_els_resp_type(fp));
 
@@ -1197,7 +1197,7 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 out:
 	fc_frame_free(fp);
 err:
-	mutex_unlock(&rdata->rp_mutex);
+	spin_unlock(&rdata->rp_lock);
 	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 }
 
@@ -1289,7 +1289,7 @@ static void fc_rport_adisc_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_els_adisc *adisc;
 	u8 op;
 
-	mutex_lock(&rdata->rp_mutex);
+	spin_lock(&rdata->rp_lock);
 
 	FC_RPORT_DBG(rdata, "Received a ADISC response\n");
 
@@ -1326,7 +1326,7 @@ static void fc_rport_adisc_resp(struct fc_seq *sp, struct fc_frame *fp,
 out:
 	fc_frame_free(fp);
 err:
-	mutex_unlock(&rdata->rp_mutex);
+	spin_unlock(&rdata->rp_lock);
 	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 }
 
@@ -1483,7 +1483,7 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
 		mutex_unlock(&lport->disc.disc_mutex);
 		goto reject;
 	}
-	mutex_lock(&rdata->rp_mutex);
+	spin_lock(&rdata->rp_lock);
 	mutex_unlock(&lport->disc.disc_mutex);
 
 	switch (rdata->rp_state) {
@@ -1493,7 +1493,7 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
 	case RPORT_ST_ADISC:
 		break;
 	default:
-		mutex_unlock(&rdata->rp_mutex);
+		spin_unlock(&rdata->rp_lock);
 		goto reject;
 	}
 
@@ -1523,7 +1523,7 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
 		break;
 	}
 
-	mutex_unlock(&rdata->rp_mutex);
+	spin_unlock(&rdata->rp_lock);
 	return;
 
 reject:
@@ -1616,7 +1616,7 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 		goto reject;
 	}
 
-	mutex_lock(&rdata->rp_mutex);
+	spin_lock(&rdata->rp_lock);
 	mutex_unlock(&disc->disc_mutex);
 
 	rdata->ids.port_name = get_unaligned_be64(&pl->fl_wwpn);
@@ -1643,7 +1643,7 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 	case RPORT_ST_PLOGI:
 		FC_RPORT_DBG(rdata, "Received PLOGI in PLOGI state\n");
 		if (rdata->ids.port_name < lport->wwpn) {
-			mutex_unlock(&rdata->rp_mutex);
+			spin_unlock(&rdata->rp_lock);
 			rjt_data.reason = ELS_RJT_INPROG;
 			rjt_data.explan = ELS_EXPL_NONE;
 			goto reject;
@@ -1661,14 +1661,14 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 	case RPORT_ST_DELETE:
 		FC_RPORT_DBG(rdata, "Received PLOGI in state %s - send busy\n",
 			     fc_rport_state(rdata));
-		mutex_unlock(&rdata->rp_mutex);
+		spin_unlock(&rdata->rp_lock);
 		rjt_data.reason = ELS_RJT_BUSY;
 		rjt_data.explan = ELS_EXPL_NONE;
 		goto reject;
 	}
 	if (!fc_rport_compatible_roles(lport, rdata)) {
 		FC_RPORT_DBG(rdata, "Received PLOGI for incompatible role\n");
-		mutex_unlock(&rdata->rp_mutex);
+		spin_unlock(&rdata->rp_lock);
 		rjt_data.reason = ELS_RJT_LOGIC;
 		rjt_data.explan = ELS_EXPL_NONE;
 		goto reject;
@@ -1691,7 +1691,7 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 	lport->tt.frame_send(lport, fp);
 	fc_rport_enter_prli(rdata);
 out:
-	mutex_unlock(&rdata->rp_mutex);
+	spin_unlock(&rdata->rp_lock);
 	fc_frame_free(rx_fp);
 	return;
 
@@ -1910,12 +1910,12 @@ static void fc_rport_recv_logo_req(struct fc_lport *lport, struct fc_frame *fp)
 	mutex_lock(&lport->disc.disc_mutex);
 	rdata = lport->tt.rport_lookup(lport, sid);
 	if (rdata) {
-		mutex_lock(&rdata->rp_mutex);
+		spin_lock(&rdata->rp_lock);
 		FC_RPORT_DBG(rdata, "Received LOGO request while in state %s\n",
 			     fc_rport_state(rdata));
 
 		fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
-		mutex_unlock(&rdata->rp_mutex);
+		spin_unlock(&rdata->rp_lock);
 	} else
 		FC_RPORT_ID_DBG(lport, sid,
 				"Received LOGO from non-logged-in port\n");
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 93d14da..7d63d23 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -187,7 +187,7 @@ struct fc_rport_libfc_priv {
  * @major_retries:  The retry count for the entire PLOGI/PRLI state machine
  * @e_d_tov:        Error detect timeout value (in msec)
  * @r_a_tov:        Resource allocation timeout value (in msec)
- * @rp_mutex:       The mutex that protects the remote port
+ * @rp_lock:        The lock that protects the remote port
  * @retry_work:     Handle for retries
  * @event_callback: Callback when READY, FAILED or LOGO states complete
  * @prli_count:     Count of open PRLI sessions in providers
@@ -207,7 +207,7 @@ struct fc_rport_priv {
 	unsigned int	            major_retries;
 	unsigned int	            e_d_tov;
 	unsigned int	            r_a_tov;
-	struct mutex                rp_mutex;
+	spinlock_t		    rp_lock;
 	struct delayed_work	    retry_work;
 	enum fc_rport_event         event;
 	struct fc_rport_operations  *ops;
-- 
1.8.5.6

