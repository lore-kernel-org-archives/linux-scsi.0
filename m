From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/15] libfc: Convert debug statements in fc_rport.c to use
	new libfc debug macros.
Date: Fri, 03 Apr 2009 14:59:05 -0700
Message-ID: <20090403215905.10856.27743.stgit@fritz>
References: <20090403215758.10856.6946.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31135 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934422AbZDCV7Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Apr 2009 17:59:25 -0400
In-Reply-To: <20090403215758.10856.6946.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Convert debug statements in fc_rport.c to use new libfc
debug macros.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |  120 +++++++++++++++++------------------------
 1 files changed, 50 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index e675f5a..b6c8528 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -55,14 +55,6 @@
 #include <scsi/libfc.h>
 #include <scsi/fc_encode.h>
 
-static int fc_rport_debug;
-
-#define FC_DEBUG_RPORT(fmt...)			\
-	do {					\
-		if (fc_rport_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
-
 struct workqueue_struct *rport_event_queue;
 
 static void fc_rport_enter_plogi(struct fc_rport *);
@@ -97,7 +89,7 @@ static const char *fc_rport_state_names[] = {
 static void fc_rport_rogue_destroy(struct device *dev)
 {
 	struct fc_rport *rport = dev_to_rport(dev);
-	FC_DEBUG_RPORT("Destroying rogue rport (%6x)\n", rport->port_id);
+	FC_RPORT_DBG(rport, "Destroying rogue rport\n");
 	kfree(rport);
 }
 
@@ -263,8 +255,8 @@ static void fc_rport_work(struct work_struct *work)
 
 			fc_rport_state_enter(new_rport, RPORT_ST_READY);
 		} else {
-			FC_DBG("Failed to create the rport for port "
-			       "(%6x).\n", ids.port_id);
+			printk(KERN_WARNING "libfc: Failed to allocate "
+			       " memory for rport (%6x)\n", ids.port_id);
 			event = RPORT_EV_FAILED;
 		}
 		if (rport->port_id != FC_FID_DIR_SERV)
@@ -309,7 +301,7 @@ int fc_rport_login(struct fc_rport *rport)
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Login to port (%6x)\n", rport->port_id);
+	FC_RPORT_DBG(rport, "Login to port\n");
 
 	fc_rport_enter_plogi(rport);
 
@@ -329,16 +321,13 @@ int fc_rport_login(struct fc_rport *rport)
 int fc_rport_logoff(struct fc_rport *rport)
 {
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
-	struct fc_lport *lport = rdata->local_port;
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Remove port (%6x)\n", rport->port_id);
+	FC_RPORT_DBG(rport, "Remove port\n");
 
 	if (rdata->rp_state == RPORT_ST_NONE) {
-		FC_DEBUG_RPORT("(%6x): Port (%6x) in NONE state,"
-			       " not removing", fc_host_port_id(lport->host),
-			       rport->port_id);
+		FC_RPORT_DBG(rport, "Port in NONE state, not removing\n");
 		mutex_unlock(&rdata->rp_mutex);
 		goto out;
 	}
@@ -379,7 +368,7 @@ static void fc_rport_enter_ready(struct fc_rport *rport)
 
 	fc_rport_state_enter(rport, RPORT_ST_READY);
 
-	FC_DEBUG_RPORT("Port (%6x) is Ready\n", rport->port_id);
+	FC_RPORT_DBG(rport, "Port is Ready\n");
 
 	rdata->event = RPORT_EV_CREATED;
 	queue_work(rport_event_queue, &rdata->event_work);
@@ -436,8 +425,8 @@ static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
 {
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 
-	FC_DEBUG_RPORT("Error %ld in state %s, retries %d\n",
-		       PTR_ERR(fp), fc_rport_state(rport), rdata->retries);
+	FC_RPORT_DBG(rport, "Error %ld in state %s, retries %d\n",
+		     PTR_ERR(fp), fc_rport_state(rport), rdata->retries);
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_PLOGI:
@@ -479,8 +468,8 @@ static void fc_rport_error_retry(struct fc_rport *rport, struct fc_frame *fp)
 		return fc_rport_error(rport, fp);
 
 	if (rdata->retries < rdata->local_port->max_retry_count) {
-		FC_DEBUG_RPORT("Error %ld in state %s, retrying\n",
-			       PTR_ERR(fp), fc_rport_state(rport));
+		FC_RPORT_DBG(rport, "Error %ld in state %s, retrying\n",
+			     PTR_ERR(fp), fc_rport_state(rport));
 		rdata->retries++;
 		/* no additional delay on exchange timeouts */
 		if (PTR_ERR(fp) == -FC_EX_TIMEOUT)
@@ -517,12 +506,11 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Received a PLOGI response from port (%6x)\n",
-		       rport->port_id);
+	FC_RPORT_DBG(rport, "Received a PLOGI response\n");
 
 	if (rdata->rp_state != RPORT_ST_PLOGI) {
-		FC_DBG("Received a PLOGI response, but in state %s\n",
-		       fc_rport_state(rport));
+		FC_RPORT_DBG(rport, "Received a PLOGI response, but in state "
+			     "%s\n", fc_rport_state(rport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -583,8 +571,8 @@ static void fc_rport_enter_plogi(struct fc_rport *rport)
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp;
 
-	FC_DEBUG_RPORT("Port (%6x) entered PLOGI state from %s state\n",
-		       rport->port_id, fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Port entered PLOGI state from %s state\n",
+		     fc_rport_state(rport));
 
 	fc_rport_state_enter(rport, RPORT_ST_PLOGI);
 
@@ -628,12 +616,11 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Received a PRLI response from port (%6x)\n",
-		       rport->port_id);
+	FC_RPORT_DBG(rport, "Received a PRLI response\n");
 
 	if (rdata->rp_state != RPORT_ST_PRLI) {
-		FC_DBG("Received a PRLI response, but in state %s\n",
-		       fc_rport_state(rport));
+		FC_RPORT_DBG(rport, "Received a PRLI response, but in state "
+			     "%s\n", fc_rport_state(rport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -663,7 +650,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		fc_rport_enter_rtv(rport);
 
 	} else {
-		FC_DBG("Bad ELS response\n");
+		FC_RPORT_DBG(rport, "Bad ELS response for PRLI command\n");
 		rdata->event = RPORT_EV_FAILED;
 		fc_rport_state_enter(rport, RPORT_ST_NONE);
 		queue_work(rport_event_queue, &rdata->event_work);
@@ -695,12 +682,11 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Received a LOGO response from port (%6x)\n",
-		       rport->port_id);
+	FC_RPORT_DBG(rport, "Received a LOGO response\n");
 
 	if (rdata->rp_state != RPORT_ST_LOGO) {
-		FC_DEBUG_RPORT("Received a LOGO response, but in state %s\n",
-			       fc_rport_state(rport));
+		FC_RPORT_DBG(rport, "Received a LOGO response, but in state "
+			     "%s\n", fc_rport_state(rport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -715,7 +701,7 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 	if (op == ELS_LS_ACC) {
 		fc_rport_enter_rtv(rport);
 	} else {
-		FC_DBG("Bad ELS response\n");
+		FC_RPORT_DBG(rport, "Bad ELS response for LOGO command\n");
 		rdata->event = RPORT_EV_LOGO;
 		fc_rport_state_enter(rport, RPORT_ST_NONE);
 		queue_work(rport_event_queue, &rdata->event_work);
@@ -745,8 +731,8 @@ static void fc_rport_enter_prli(struct fc_rport *rport)
 	} *pp;
 	struct fc_frame *fp;
 
-	FC_DEBUG_RPORT("Port (%6x) entered PRLI state from %s state\n",
-		       rport->port_id, fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Port entered PRLI state from %s state\n",
+		     fc_rport_state(rport));
 
 	fc_rport_state_enter(rport, RPORT_ST_PRLI);
 
@@ -784,12 +770,11 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Received a RTV response from port (%6x)\n",
-		       rport->port_id);
+	FC_RPORT_DBG(rport, "Received a RTV response\n");
 
 	if (rdata->rp_state != RPORT_ST_RTV) {
-		FC_DBG("Received a RTV response, but in state %s\n",
-		       fc_rport_state(rport));
+		FC_RPORT_DBG(rport, "Received a RTV response, but in state "
+			     "%s\n", fc_rport_state(rport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -844,8 +829,8 @@ static void fc_rport_enter_rtv(struct fc_rport *rport)
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 
-	FC_DEBUG_RPORT("Port (%6x) entered RTV state from %s state\n",
-		       rport->port_id, fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Port entered RTV state from %s state\n",
+		     fc_rport_state(rport));
 
 	fc_rport_state_enter(rport, RPORT_ST_RTV);
 
@@ -875,8 +860,8 @@ static void fc_rport_enter_logo(struct fc_rport *rport)
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp;
 
-	FC_DEBUG_RPORT("Port (%6x) entered LOGO state from %s state\n",
-		       rport->port_id, fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Port entered LOGO state from %s state\n",
+		     fc_rport_state(rport));
 
 	fc_rport_state_enter(rport, RPORT_ST_LOGO);
 
@@ -983,14 +968,13 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 
 	fh = fc_frame_header_get(fp);
 
-	FC_DEBUG_RPORT("Received PLOGI request from port (%6x) "
-		       "while in state %s\n", ntoh24(fh->fh_s_id),
-		       fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Received PLOGI request while in state %s\n",
+		     fc_rport_state(rport));
 
 	sid = ntoh24(fh->fh_s_id);
 	pl = fc_frame_payload_get(fp, sizeof(*pl));
 	if (!pl) {
-		FC_DBG("incoming PLOGI from %x too short\n", sid);
+		FC_RPORT_DBG(rport, "Received PLOGI too short\n");
 		WARN_ON(1);
 		/* XXX TBD: send reject? */
 		fc_frame_free(fp);
@@ -1012,26 +996,26 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 	 */
 	switch (rdata->rp_state) {
 	case RPORT_ST_INIT:
-		FC_DEBUG_RPORT("incoming PLOGI from %6x wwpn %llx state INIT "
-			       "- reject\n", sid, (unsigned long long)wwpn);
+		FC_RPORT_DBG(rport, "Received PLOGI, wwpn %llx state INIT "
+			     "- reject\n", (unsigned long long)wwpn);
 		reject = ELS_RJT_UNSUP;
 		break;
 	case RPORT_ST_PLOGI:
-		FC_DEBUG_RPORT("incoming PLOGI from %x in PLOGI state %d\n",
-			       sid, rdata->rp_state);
+		FC_RPORT_DBG(rport, "Received PLOGI in PLOGI state %d\n",
+			     rdata->rp_state);
 		if (wwpn < lport->wwpn)
 			reject = ELS_RJT_INPROG;
 		break;
 	case RPORT_ST_PRLI:
 	case RPORT_ST_READY:
-		FC_DEBUG_RPORT("incoming PLOGI from %x in logged-in state %d "
-			       "- ignored for now\n", sid, rdata->rp_state);
+		FC_RPORT_DBG(rport, "Received PLOGI in logged-in state %d "
+			     "- ignored for now\n", rdata->rp_state);
 		/* XXX TBD - should reset */
 		break;
 	case RPORT_ST_NONE:
 	default:
-		FC_DEBUG_RPORT("incoming PLOGI from %x in unexpected "
-			       "state %d\n", sid, rdata->rp_state);
+		FC_RPORT_DBG(rport, "Received PLOGI in unexpected "
+			     "state %d\n", rdata->rp_state);
 		fc_frame_free(fp);
 		return;
 		break;
@@ -1115,9 +1099,8 @@ static void fc_rport_recv_prli_req(struct fc_rport *rport,
 
 	fh = fc_frame_header_get(rx_fp);
 
-	FC_DEBUG_RPORT("Received PRLI request from port (%6x) "
-		       "while in state %s\n", ntoh24(fh->fh_s_id),
-		       fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Received PRLI request while in state %s\n",
+		     fc_rport_state(rport));
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_PRLI:
@@ -1252,9 +1235,8 @@ static void fc_rport_recv_prlo_req(struct fc_rport *rport, struct fc_seq *sp,
 
 	fh = fc_frame_header_get(fp);
 
-	FC_DEBUG_RPORT("Received PRLO request from port (%6x) "
-		       "while in state %s\n", ntoh24(fh->fh_s_id),
-		       fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Received PRLO request while in state %s\n",
+		     fc_rport_state(rport));
 
 	if (rdata->rp_state == RPORT_ST_NONE) {
 		fc_frame_free(fp);
@@ -1286,9 +1268,8 @@ static void fc_rport_recv_logo_req(struct fc_rport *rport, struct fc_seq *sp,
 
 	fh = fc_frame_header_get(fp);
 
-	FC_DEBUG_RPORT("Received LOGO request from port (%6x) "
-		       "while in state %s\n", ntoh24(fh->fh_s_id),
-		       fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Received LOGO request while in state %s\n",
+		     fc_rport_state(rport));
 
 	if (rdata->rp_state == RPORT_ST_NONE) {
 		fc_frame_free(fp);
@@ -1308,7 +1289,6 @@ static void fc_rport_flush_queue(void)
 	flush_workqueue(rport_event_queue);
 }
 
-
 int fc_rport_init(struct fc_lport *lport)
 {
 	if (!lport->tt.rport_create)

