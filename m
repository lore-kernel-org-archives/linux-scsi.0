From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 4/5] libfc, fcoe, bnx2fc: Split fc_disc_init into fc_disc_{init,
 config}
Date: Mon, 25 Mar 2013 16:36:01 -0700
Message-ID: <20130325233601.17257.88496.stgit@fritz>
References: <20130325233539.17257.76078.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12603 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab3CYXgC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Mar 2013 19:36:02 -0400
In-Reply-To: <20130325233539.17257.76078.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Morgan <jack.morgan@intel.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Split discovery initialization in code that is setup once (fcoe_disc_init)
and code that can be re-configured (fcoe_disc_config).

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Jack Morgan <jack.morgan@intel.com>
Reviewed-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    3 ++-
 drivers/scsi/fcoe/fcoe_ctlr.c     |    3 ++-
 drivers/scsi/libfc/fc_disc.c      |   25 +++++++++++++++++--------
 include/scsi/libfc.h              |    3 ++-
 4 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index b867b1b..90bc7bd 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -939,7 +939,8 @@ static int bnx2fc_libfc_config(struct fc_lport *lport)
 	fc_elsct_init(lport);
 	fc_exch_init(lport);
 	fc_rport_init(lport);
-	fc_disc_init(lport, lport);
+	fc_disc_init(lport);
+	fc_disc_config(lport, lport);
 	return 0;
 }
 
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index ba2f977..34ee56c 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2847,7 +2847,8 @@ int fcoe_libfc_config(struct fc_lport *lport, struct fcoe_ctlr *fip,
 		priv = fip;
 	}
 
-	fc_disc_init(lport, priv);
+	fc_disc_init(lport);
+	fc_disc_config(lport, priv);
 
 	return 0;
 }
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 141c54b..880a906 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -712,13 +712,13 @@ static void fc_disc_stop_final(struct fc_lport *lport)
 }
 
 /**
- * fc_disc_init() - Initialize the discovery layer for a local port
- * @lport: The local port that needs the discovery layer to be initialized
+ * fc_disc_config() - Configure the discovery layer for a local port
+ * @lport: The local port that needs the discovery layer to be configured
  * @priv: Private data structre for users of the discovery layer
  */
-int fc_disc_init(struct fc_lport *lport, void *priv)
+void fc_disc_config(struct fc_lport *lport, void *priv)
 {
-	struct fc_disc *disc;
+	struct fc_disc *disc = &lport->disc;
 
 	if (!lport->tt.disc_start)
 		lport->tt.disc_start = fc_disc_start;
@@ -733,12 +733,21 @@ int fc_disc_init(struct fc_lport *lport, void *priv)
 		lport->tt.disc_recv_req = fc_disc_recv_req;
 
 	disc = &lport->disc;
-	INIT_DELAYED_WORK(&disc->disc_work, fc_disc_timeout);
-	mutex_init(&disc->disc_mutex);
-	INIT_LIST_HEAD(&disc->rports);
 
 	disc->priv = priv;
+}
+EXPORT_SYMBOL(fc_disc_config);
 
-	return 0;
+/**
+ * fc_disc_init() - Initialize the discovery layer for a local port
+ * @lport: The local port that needs the discovery layer to be initialized
+ */
+void fc_disc_init(struct fc_lport *lport)
+{
+	struct fc_disc *disc = &lport->disc;
+
+	INIT_DELAYED_WORK(&disc->disc_work, fc_disc_timeout);
+	mutex_init(&disc->disc_mutex);
+	INIT_LIST_HEAD(&disc->rports);
 }
 EXPORT_SYMBOL(fc_disc_init);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index add2a49..e1379b4 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -1074,7 +1074,8 @@ void fc_rport_terminate_io(struct fc_rport *);
 /*
  * DISCOVERY LAYER
  *****************************/
-int fc_disc_init(struct fc_lport *, void *);
+void fc_disc_init(struct fc_lport *);
+void fc_disc_config(struct fc_lport *, void *);
 
 static inline struct fc_lport *fc_disc_lport(struct fc_disc *disc)
 {

