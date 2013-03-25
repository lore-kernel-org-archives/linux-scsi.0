From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/5] libfc, fcoe,
 bnx2fc: Always use fcoe_disc_init for discovery layer initialization
Date: Mon, 25 Mar 2013 16:35:56 -0700
Message-ID: <20130325233556.17257.56489.stgit@fritz>
References: <20130325233539.17257.76078.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48318 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933598Ab3CYXf5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Mar 2013 19:35:57 -0400
In-Reply-To: <20130325233539.17257.76078.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Morgan <jack.morgan@intel.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Currently libfcoe is doing some libfc discovery layer initialization outside of
libfc. This patch moves this code into libfc and sets up a split in discovery
(one time) initialization code and (re-configurable) settings that will come in
the next patch.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Jack Morgan <jack.morgan@intel.com>
Reviewed-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
 drivers/scsi/fcoe/fcoe_ctlr.c     |   11 ++++++-----
 drivers/scsi/libfc/fc_disc.c      |    5 +++--
 include/scsi/libfc.h              |    2 +-
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index cc4791c..b867b1b 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -939,7 +939,7 @@ static int bnx2fc_libfc_config(struct fc_lport *lport)
 	fc_elsct_init(lport);
 	fc_exch_init(lport);
 	fc_rport_init(lport);
-	fc_disc_init(lport);
+	fc_disc_init(lport, lport);
 	return 0;
 }
 
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 08c3bc3..ba2f977 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2826,6 +2826,8 @@ unlock:
 int fcoe_libfc_config(struct fc_lport *lport, struct fcoe_ctlr *fip,
 		      const struct libfc_function_template *tt, int init_fcp)
 {
+	void *priv = lport;
+
 	/* Set the function pointers set by the LLDD */
 	memcpy(&lport->tt, tt, sizeof(*tt));
 	if (init_fcp && fc_fcp_init(lport))
@@ -2842,12 +2844,11 @@ int fcoe_libfc_config(struct fc_lport *lport, struct fcoe_ctlr *fip,
 		lport->tt.disc_start = fcoe_ctlr_disc_start;
 		lport->tt.disc_stop = fcoe_ctlr_disc_stop;
 		lport->tt.disc_stop_final = fcoe_ctlr_disc_stop_final;
-		mutex_init(&lport->disc.disc_mutex);
-		INIT_LIST_HEAD(&lport->disc.rports);
-		lport->disc.priv = fip;
-	} else {
-		fc_disc_init(lport);
+		priv = fip;
 	}
+
+	fc_disc_init(lport, priv);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fcoe_libfc_config);
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 8e561e6..141c54b 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -714,8 +714,9 @@ static void fc_disc_stop_final(struct fc_lport *lport)
 /**
  * fc_disc_init() - Initialize the discovery layer for a local port
  * @lport: The local port that needs the discovery layer to be initialized
+ * @priv: Private data structre for users of the discovery layer
  */
-int fc_disc_init(struct fc_lport *lport)
+int fc_disc_init(struct fc_lport *lport, void *priv)
 {
 	struct fc_disc *disc;
 
@@ -736,7 +737,7 @@ int fc_disc_init(struct fc_lport *lport)
 	mutex_init(&disc->disc_mutex);
 	INIT_LIST_HEAD(&disc->rports);
 
-	disc->priv = lport;
+	disc->priv = priv;
 
 	return 0;
 }
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 399162b..add2a49 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -1074,7 +1074,7 @@ void fc_rport_terminate_io(struct fc_rport *);
 /*
  * DISCOVERY LAYER
  *****************************/
-int fc_disc_init(struct fc_lport *);
+int fc_disc_init(struct fc_lport *, void *);
 
 static inline struct fc_lport *fc_disc_lport(struct fc_disc *disc)
 {

