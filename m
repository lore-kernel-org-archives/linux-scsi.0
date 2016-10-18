From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/20] libfc: Replace ->rport_flush_queue callback with function call
Date: Tue, 18 Oct 2016 10:01:46 +0200
Message-ID: <1476777714-3543-13-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47378 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758749AbcJRICb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:31 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->rport_flush_queue callback only ever had a single
implementation, so we can as well call it directly and
drop the callback.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 2 +-
 drivers/scsi/libfc/fc_disc.c  | 2 +-
 drivers/scsi/libfc/fc_lport.c | 2 +-
 drivers/scsi/libfc/fc_rport.c | 6 ++----
 include/scsi/libfc.h          | 8 +-------
 5 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 12aecf3..12efc1d 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2215,7 +2215,7 @@ static void fcoe_ctlr_disc_stop(struct fc_lport *lport)
 static void fcoe_ctlr_disc_stop_final(struct fc_lport *lport)
 {
 	fcoe_ctlr_disc_stop(lport);
-	lport->tt.rport_flush_queue();
+	fc_rport_flush_queue();
 	synchronize_rcu();
 }
 
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 7efa5a6..6103231 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -719,7 +719,7 @@ static void fc_disc_stop(struct fc_lport *lport)
 static void fc_disc_stop_final(struct fc_lport *lport)
 {
 	fc_disc_stop(lport);
-	lport->tt.rport_flush_queue();
+	fc_rport_flush_queue();
 }
 
 /**
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 937a442..7315675 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -625,7 +625,7 @@ int fc_fabric_logoff(struct fc_lport *lport)
 	if (lport->dns_rdata)
 		fc_rport_logoff(lport->dns_rdata);
 	mutex_unlock(&lport->lp_mutex);
-	lport->tt.rport_flush_queue();
+	fc_rport_flush_queue();
 	mutex_lock(&lport->lp_mutex);
 	fc_lport_enter_logo(lport);
 	mutex_unlock(&lport->lp_mutex);
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index feae7ab..6e50226 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -2175,10 +2175,11 @@ static void fc_rport_recv_logo_req(struct fc_lport *lport, struct fc_frame *fp)
 /**
  * fc_rport_flush_queue() - Flush the rport_event_queue
  */
-static void fc_rport_flush_queue(void)
+void fc_rport_flush_queue(void)
 {
 	flush_workqueue(rport_event_queue);
 }
+EXPORT_SYMBOL(fc_rport_flush_queue);
 
 /**
  * fc_rport_init() - Initialize the remote port layer for a local port
@@ -2186,9 +2187,6 @@ static void fc_rport_flush_queue(void)
  */
 int fc_rport_init(struct fc_lport *lport)
 {
-	if (!lport->tt.rport_flush_queue)
-		lport->tt.rport_flush_queue = fc_rport_flush_queue;
-
 	return 0;
 }
 EXPORT_SYMBOL(fc_rport_init);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 1e1dbc9..57630c5 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -583,13 +583,6 @@ struct libfc_function_template {
 	void (*exch_mgr_reset)(struct fc_lport *, u32 s_id, u32 d_id);
 
 	/*
-	 * Flush the rport work queue. Generally used before shutdown.
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	void (*rport_flush_queue)(void);
-
-	/*
 	 * Set the local port FC_ID.
 	 *
 	 * This may be provided by the LLD to allow it to be
@@ -994,6 +987,7 @@ struct fc_rport_priv *fc_rport_lookup(const struct fc_lport *lport,
 int fc_rport_login(struct fc_rport_priv *rdata);
 int fc_rport_logoff(struct fc_rport_priv *rdata);
 void fc_rport_recv_req(struct fc_lport *lport, struct fc_frame *fp);
+void fc_rport_flush_queue(void);
 
 /*
  * DISCOVERY LAYER
-- 
1.8.5.6

