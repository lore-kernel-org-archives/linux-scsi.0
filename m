From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 2/4] libfc: Declare local functions static
Date: Fri, 13 Jan 2012 17:26:20 -0800
Message-ID: <20120114012620.19185.89189.stgit@localhost6.localdomain6>
References: <20120114012609.19185.66603.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54280 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab2ANB0V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2012 20:26:21 -0500
In-Reply-To: <20120114012609.19185.66603.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Yi Zou <yi.zou@intel.com>

From: Bart Van Assche <bvanassche@acm.org>

Avoid that sparse complains about missing declarations for local
functions by declaring these static or by adding an #include directive.
Add the __percpu annotation where it is missing.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_disc.c  |    6 +++---
 drivers/scsi/libfc/fc_elsct.c |    1 +
 drivers/scsi/libfc/fc_exch.c  |    2 +-
 drivers/scsi/libfc/fc_lport.c |    5 +++--
 drivers/scsi/libfc/fc_rport.c |   10 +++++-----
 include/scsi/libfc.h          |    2 +-
 6 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 7269e92..1d1b0c9 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -61,7 +61,7 @@ static void fc_disc_restart(struct fc_disc *);
  * Locking Note: This function expects that the lport mutex is locked before
  * calling it.
  */
-void fc_disc_stop_rports(struct fc_disc *disc)
+static void fc_disc_stop_rports(struct fc_disc *disc)
 {
 	struct fc_lport *lport;
 	struct fc_rport_priv *rdata;
@@ -682,7 +682,7 @@ static int fc_disc_single(struct fc_lport *lport, struct fc_disc_port *dp)
  * fc_disc_stop() - Stop discovery for a given lport
  * @lport: The local port that discovery should stop on
  */
-void fc_disc_stop(struct fc_lport *lport)
+static void fc_disc_stop(struct fc_lport *lport)
 {
 	struct fc_disc *disc = &lport->disc;
 
@@ -698,7 +698,7 @@ void fc_disc_stop(struct fc_lport *lport)
  * This function will block until discovery has been
  * completely stopped and all rports have been deleted.
  */
-void fc_disc_stop_final(struct fc_lport *lport)
+static void fc_disc_stop_final(struct fc_lport *lport)
 {
 	fc_disc_stop(lport);
 	lport->tt.rport_flush_queue();
diff --git a/drivers/scsi/libfc/fc_elsct.c b/drivers/scsi/libfc/fc_elsct.c
index fb9161d..e17a28d 100644
--- a/drivers/scsi/libfc/fc_elsct.c
+++ b/drivers/scsi/libfc/fc_elsct.c
@@ -28,6 +28,7 @@
 #include <scsi/fc/fc_els.h>
 #include <scsi/libfc.h>
 #include <scsi/fc_encode.h>
+#include "fc_libfc.h"
 
 /**
  * fc_elsct_send() - Send an ELS or CT frame
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 9de9db2..4d70d96 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -91,7 +91,7 @@ struct fc_exch_pool {
  * It manages the allocation of exchange IDs.
  */
 struct fc_exch_mgr {
-	struct fc_exch_pool *pool;
+	struct fc_exch_pool __percpu *pool;
 	mempool_t	*ep_pool;
 	enum fc_class	class;
 	struct kref	kref;
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e77094a..83750eb 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -677,7 +677,8 @@ EXPORT_SYMBOL(fc_set_mfs);
  * @lport: The local port receiving the event
  * @event: The discovery event
  */
-void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
+static void fc_lport_disc_callback(struct fc_lport *lport,
+				   enum fc_disc_event event)
 {
 	switch (event) {
 	case DISC_EV_SUCCESS:
@@ -1568,7 +1569,7 @@ EXPORT_SYMBOL(fc_lport_flogi_resp);
  * Locking Note: The lport lock is expected to be held before calling
  * this routine.
  */
-void fc_lport_enter_flogi(struct fc_lport *lport)
+static void fc_lport_enter_flogi(struct fc_lport *lport)
 {
 	struct fc_frame *fp;
 
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index b9e4348..83aa1ef 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -391,7 +391,7 @@ static void fc_rport_work(struct work_struct *work)
  * If it appears we are already logged in, ADISC is used to verify
  * the setup.
  */
-int fc_rport_login(struct fc_rport_priv *rdata)
+static int fc_rport_login(struct fc_rport_priv *rdata)
 {
 	mutex_lock(&rdata->rp_mutex);
 
@@ -451,7 +451,7 @@ static void fc_rport_enter_delete(struct fc_rport_priv *rdata,
  * function will hold the rport lock, call an _enter_*
  * function and then unlock the rport.
  */
-int fc_rport_logoff(struct fc_rport_priv *rdata)
+static int fc_rport_logoff(struct fc_rport_priv *rdata)
 {
 	mutex_lock(&rdata->rp_mutex);
 
@@ -653,8 +653,8 @@ static int fc_rport_login_complete(struct fc_rport_priv *rdata,
  * @fp:	    The FLOGI response frame
  * @rp_arg: The remote port that received the FLOGI response
  */
-void fc_rport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
-			 void *rp_arg)
+static void fc_rport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
+				void *rp_arg)
 {
 	struct fc_rport_priv *rdata = rp_arg;
 	struct fc_lport *lport = rdata->local_port;
@@ -1520,7 +1520,7 @@ reject:
  *
  * Locking Note: Called with the lport lock held.
  */
-void fc_rport_recv_req(struct fc_lport *lport, struct fc_frame *fp)
+static void fc_rport_recv_req(struct fc_lport *lport, struct fc_frame *fp)
 {
 	struct fc_seq_els_data els_data;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 5d1a758..6a3922f 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -857,7 +857,7 @@ struct fc_lport {
 	enum fc_lport_state	       state;
 	unsigned long		       boot_time;
 	struct fc_host_statistics      host_stats;
-	struct fcoe_dev_stats	       *dev_stats;
+	struct fcoe_dev_stats __percpu *dev_stats;
 	u8			       retry_count;
 
 	/* Fabric information */

