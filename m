From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 24/64] libfc: prepare to split off struct fc_rport_priv from
	fc_rport_libfc_priv
Date: Tue, 25 Aug 2009 14:00:34 -0700
Message-ID: <20090825210034.1553.98914.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41749 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbZHYVAc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:00:32 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

While the I/O and LLD interfaces use fc_rport_libfc_priv, the
disc and rport interfaces will use fc_rport_priv, which will
be separately allocated.

Change the disc and rport usage of fc_rport_libfc_priv to fc_rport_priv.

Use #define temporarily to make both names equivalent until a
subsequent patch splits them.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |   18 ++++++------
 drivers/scsi/libfc/fc_lport.c |    2 +
 drivers/scsi/libfc/fc_rport.c |   60 +++++++++++++++++++++--------------------
 include/scsi/libfc.h          |   10 ++++++-
 4 files changed, 49 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 6fabf66..4c8d893 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -65,7 +65,7 @@ struct fc_rport *fc_disc_lookup_rport(const struct fc_lport *lport,
 {
 	const struct fc_disc *disc = &lport->disc;
 	struct fc_rport *rport, *found = NULL;
-	struct fc_rport_libfc_priv *rdata;
+	struct fc_rport_priv *rdata;
 	int disc_found = 0;
 
 	list_for_each_entry(rdata, &disc->rports, peers) {
@@ -94,7 +94,7 @@ void fc_disc_stop_rports(struct fc_disc *disc)
 {
 	struct fc_lport *lport;
 	struct fc_rport *rport;
-	struct fc_rport_libfc_priv *rdata, *next;
+	struct fc_rport_priv *rdata, *next;
 
 	lport = disc->lport;
 
@@ -126,7 +126,7 @@ static void fc_disc_rport_callback(struct fc_lport *lport,
 				   struct fc_rport *rport,
 				   enum fc_rport_event event)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_disc *disc = &lport->disc;
 
 	FC_DISC_DBG(disc, "Received a %d event for port (%6x)\n", event,
@@ -170,7 +170,7 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 {
 	struct fc_lport *lport;
 	struct fc_rport *rport;
-	struct fc_rport_libfc_priv *rdata;
+	struct fc_rport_priv *rdata;
 	struct fc_els_rscn *rp;
 	struct fc_els_rscn_page *pp;
 	struct fc_seq_els_data rjt_data;
@@ -309,7 +309,7 @@ static void fc_disc_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 static void fc_disc_restart(struct fc_disc *disc)
 {
 	struct fc_rport *rport;
-	struct fc_rport_libfc_priv *rdata, *next;
+	struct fc_rport_priv *rdata, *next;
 	struct fc_lport *lport = disc->lport;
 
 	FC_DISC_DBG(disc, "Restarting discovery\n");
@@ -400,7 +400,7 @@ static int fc_disc_new_target(struct fc_disc *disc,
 			      struct fc_rport_identifiers *ids)
 {
 	struct fc_lport *lport = disc->lport;
-	struct fc_rport_libfc_priv *rdata;
+	struct fc_rport_priv *rdata;
 	int error = 0;
 
 	if (rport && ids->port_name) {
@@ -458,7 +458,7 @@ static int fc_disc_new_target(struct fc_disc *disc,
 static void fc_disc_del_target(struct fc_disc *disc, struct fc_rport *rport)
 {
 	struct fc_lport *lport = disc->lport;
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	list_del(&rdata->peers);
 	lport->tt.rport_logoff(rport);
 }
@@ -580,7 +580,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	int error = 0;
 	struct fc_disc_port dp;
 	struct fc_rport *rport;
-	struct fc_rport_libfc_priv *rdata;
+	struct fc_rport_priv *rdata;
 
 	lport = disc->lport;
 
@@ -774,7 +774,7 @@ static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 {
 	struct fc_lport *lport;
 	struct fc_rport *new_rport;
-	struct fc_rport_libfc_priv *rdata;
+	struct fc_rport_priv *rdata;
 
 	lport = disc->lport;
 
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index ca8ea26..f7f328f 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1306,7 +1306,7 @@ static struct fc_rport_operations fc_lport_rport_ops = {
 static void fc_lport_enter_dns(struct fc_lport *lport)
 {
 	struct fc_rport *rport;
-	struct fc_rport_libfc_priv *rdata;
+	struct fc_rport_priv *rdata;
 	struct fc_disc_port dp;
 
 	dp.ids.port_id = FC_FID_DIR_SERV;
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 90cc90d..5f8f437 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -96,7 +96,7 @@ static void fc_rport_rogue_destroy(struct device *dev)
 struct fc_rport *fc_rport_rogue_create(struct fc_disc_port *dp)
 {
 	struct fc_rport *rport;
-	struct fc_rport_libfc_priv *rdata;
+	struct fc_rport_priv *rdata;
 	rport = kzalloc(sizeof(*rport) + sizeof(*rdata), GFP_KERNEL);
 
 	if (!rport)
@@ -144,7 +144,7 @@ struct fc_rport *fc_rport_rogue_create(struct fc_disc_port *dp)
 static const char *fc_rport_state(struct fc_rport *rport)
 {
 	const char *cp;
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 
 	cp = fc_rport_state_names[rdata->rp_state];
 	if (!cp)
@@ -199,7 +199,7 @@ static unsigned int fc_plogi_get_maxframe(struct fc_els_flogi *flp,
 static void fc_rport_state_enter(struct fc_rport *rport,
 				 enum fc_rport_state new)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	if (rdata->rp_state != new)
 		rdata->retries = 0;
 	rdata->rp_state = new;
@@ -208,8 +208,8 @@ static void fc_rport_state_enter(struct fc_rport *rport,
 static void fc_rport_work(struct work_struct *work)
 {
 	u32 port_id;
-	struct fc_rport_libfc_priv *rdata =
-		container_of(work, struct fc_rport_libfc_priv, event_work);
+	struct fc_rport_priv *rdata =
+		container_of(work, struct fc_rport_priv, event_work);
 	enum fc_rport_event event;
 	enum fc_rport_trans_state trans_state;
 	struct fc_lport *lport = rdata->local_port;
@@ -222,7 +222,7 @@ static void fc_rport_work(struct work_struct *work)
 
 	if (event == RPORT_EV_CREATED) {
 		struct fc_rport *new_rport;
-		struct fc_rport_libfc_priv *new_rdata;
+		struct fc_rport_priv *new_rdata;
 		struct fc_rport_identifiers ids;
 
 		ids.port_id = rport->port_id;
@@ -299,7 +299,7 @@ static void fc_rport_work(struct work_struct *work)
  */
 int fc_rport_login(struct fc_rport *rport)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 
 	mutex_lock(&rdata->rp_mutex);
 
@@ -329,7 +329,7 @@ int fc_rport_login(struct fc_rport *rport)
 static void fc_rport_enter_delete(struct fc_rport *rport,
 				  enum fc_rport_event event)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 
 	if (rdata->rp_state == RPORT_ST_DELETE)
 		return;
@@ -353,7 +353,7 @@ static void fc_rport_enter_delete(struct fc_rport *rport,
  */
 int fc_rport_logoff(struct fc_rport *rport)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 
 	mutex_lock(&rdata->rp_mutex);
 
@@ -387,7 +387,7 @@ out:
  */
 static void fc_rport_enter_ready(struct fc_rport *rport)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 
 	fc_rport_state_enter(rport, RPORT_ST_READY);
 
@@ -400,7 +400,7 @@ static void fc_rport_enter_ready(struct fc_rport *rport)
 
 /**
  * fc_rport_timeout() - Handler for the retry_work timer.
- * @work: The work struct of the fc_rport_libfc_priv
+ * @work: The work struct of the fc_rport_priv
  *
  * Locking Note: Called without the rport lock held. This
  * function will hold the rport lock, call an _enter_*
@@ -408,8 +408,8 @@ static void fc_rport_enter_ready(struct fc_rport *rport)
  */
 static void fc_rport_timeout(struct work_struct *work)
 {
-	struct fc_rport_libfc_priv *rdata =
-		container_of(work, struct fc_rport_libfc_priv, retry_work.work);
+	struct fc_rport_priv *rdata =
+		container_of(work, struct fc_rport_priv, retry_work.work);
 	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
 
 	mutex_lock(&rdata->rp_mutex);
@@ -446,7 +446,7 @@ static void fc_rport_timeout(struct work_struct *work)
  */
 static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 
 	FC_RPORT_DBG(rport, "Error %ld in state %s, retries %d\n",
 		     PTR_ERR(fp), fc_rport_state(rport), rdata->retries);
@@ -480,7 +480,7 @@ static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
  */
 static void fc_rport_error_retry(struct fc_rport *rport, struct fc_frame *fp)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	unsigned long delay = FC_DEF_E_D_TOV;
 
 	/* make sure this isn't an FC_EX_CLOSED error, never retry those */
@@ -515,7 +515,7 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				void *rp_arg)
 {
 	struct fc_rport *rport = rp_arg;
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_els_flogi *plp = NULL;
 	unsigned int tov;
@@ -586,7 +586,7 @@ err:
  */
 static void fc_rport_enter_plogi(struct fc_rport *rport)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp;
 
@@ -624,7 +624,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 			       void *rp_arg)
 {
 	struct fc_rport *rport = rp_arg;
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	struct {
 		struct fc_els_prli prli;
 		struct fc_els_spp spp;
@@ -694,7 +694,7 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 			       void *rp_arg)
 {
 	struct fc_rport *rport = rp_arg;
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	u8 op;
 
 	mutex_lock(&rdata->rp_mutex);
@@ -738,7 +738,7 @@ err:
  */
 static void fc_rport_enter_prli(struct fc_rport *rport)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 	struct {
 		struct fc_els_prli prli;
@@ -780,7 +780,7 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 			      void *rp_arg)
 {
 	struct fc_rport *rport = rp_arg;
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	u8 op;
 
 	mutex_lock(&rdata->rp_mutex);
@@ -841,7 +841,7 @@ err:
 static void fc_rport_enter_rtv(struct fc_rport *rport)
 {
 	struct fc_frame *fp;
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 
 	FC_RPORT_DBG(rport, "Port entered RTV state from %s state\n",
@@ -871,7 +871,7 @@ static void fc_rport_enter_rtv(struct fc_rport *rport)
  */
 static void fc_rport_enter_logo(struct fc_rport *rport)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp;
 
@@ -907,7 +907,7 @@ static void fc_rport_enter_logo(struct fc_rport *rport)
 void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 		       struct fc_rport *rport)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 
 	struct fc_frame_header *fh;
@@ -967,7 +967,7 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 				    struct fc_seq *sp, struct fc_frame *rx_fp)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp = rx_fp;
 	struct fc_exch *ep;
@@ -1090,7 +1090,7 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 static void fc_rport_recv_prli_req(struct fc_rport *rport,
 				   struct fc_seq *sp, struct fc_frame *rx_fp)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_exch *ep;
 	struct fc_frame *fp;
@@ -1242,7 +1242,7 @@ static void fc_rport_recv_prli_req(struct fc_rport *rport,
 static void fc_rport_recv_prlo_req(struct fc_rport *rport, struct fc_seq *sp,
 				   struct fc_frame *fp)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 
 	struct fc_frame_header *fh;
@@ -1278,7 +1278,7 @@ static void fc_rport_recv_logo_req(struct fc_rport *rport, struct fc_seq *sp,
 				   struct fc_frame *fp)
 {
 	struct fc_frame_header *fh;
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+	struct fc_rport_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 
 	fh = fc_frame_header_get(fp);
@@ -1342,8 +1342,8 @@ EXPORT_SYMBOL(fc_destroy_rport);
 
 void fc_rport_terminate_io(struct fc_rport *rport)
 {
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
-	struct fc_lport *lport = rdata->local_port;
+	struct fc_rport_libfc_priv *rp = rport->dd_data;
+	struct fc_lport *lport = rp->local_port;
 
 	lport->tt.exch_mgr_reset(lport, 0, rport->port_id);
 	lport->tt.exch_mgr_reset(lport, rport->port_id, 0);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 53b3881..aa21951 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -77,7 +77,7 @@ do {								\
 
 #define FC_RPORT_DBG(rport, fmt, args...)				\
 do {									\
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;		\
+	struct fc_rport_priv *rdata = rport->dd_data;			\
 	struct fc_lport *lport = rdata->local_port;			\
 	FC_RPORT_ID_DBG(lport, rport->port_id, fmt, ##args);		\
 } while (0)
@@ -177,6 +177,14 @@ enum fc_rport_event {
 	RPORT_EV_LOGO
 };
 
+/*
+ * Temporary definition to prepare for split off from fc_rport_libfc_priv
+ * of a separately-allocated structure called fc_rport_priv.  This will
+ * be the primary object for the discovery and rport state machines.
+ * This definition is just to make this patch series easier to review.
+ */
+#define fc_rport_priv fc_rport_libfc_priv
+
 struct fc_rport_operations {
 	void (*event_callback)(struct fc_lport *, struct fc_rport *,
 			       enum fc_rport_event);

