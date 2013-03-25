From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 5/5] libfcoe: Fix fcoe_sysfs VN2VN mode
Date: Mon, 25 Mar 2013 16:36:06 -0700
Message-ID: <20130325233606.17257.42919.stgit@fritz>
References: <20130325233539.17257.76078.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:22214 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab3CYXgI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Mar 2013 19:36:08 -0400
In-Reply-To: <20130325233539.17257.76078.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Morgan <jack.morgan@intel.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

The libfc discovery layer is being initialized in the
'create' paths for both legacy libfcoe module parameters
and fcoe_sysfs control interfaces. The problem is that
for VN2VN mode the discovery layer is initialized as if
it were in 'fabric' mode and it is not re-configured when
the mode is changed to 'vn2vn'.

This patch splits out code that needs to be initialized
once and code that can, and should be, re-configured when
the mode changes. Additionally this patch makes that change
so that the discovery layer can be reconfigured to the
libfcoe implementation when in 'vn2vn' mode.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Jack Morgan <jack.morgan@intel.com>
Reviewed-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |   60 +++++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 34ee56c..a762472 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2815,6 +2815,47 @@ unlock:
 }
 
 /**
+ * fcoe_ctlr_mode_set() - Set or reset the ctlr's mode
+ * @lport: The local port to be (re)configured
+ * @fip:   The FCoE controller whose mode is changing
+ * @fip_mode: The new fip mode
+ *
+ * Note that the we shouldn't be changing the libfc discovery settings
+ * (fc_disc_config) while an lport is going through the libfc state
+ * machine. The mode can only be changed when a fcoe_ctlr device is
+ * disabled, so that should ensure that this routine is only called
+ * when nothing is happening.
+ */
+void fcoe_ctlr_mode_set(struct fc_lport *lport, struct fcoe_ctlr *fip,
+			enum fip_state fip_mode)
+{
+	void *priv;
+
+	WARN_ON(lport->state != LPORT_ST_RESET &&
+		lport->state != LPORT_ST_DISABLED);
+
+	if (fip_mode == FIP_MODE_VN2VN) {
+		lport->rport_priv_size = sizeof(struct fcoe_rport);
+		lport->point_to_multipoint = 1;
+		lport->tt.disc_recv_req = fcoe_ctlr_disc_recv;
+		lport->tt.disc_start = fcoe_ctlr_disc_start;
+		lport->tt.disc_stop = fcoe_ctlr_disc_stop;
+		lport->tt.disc_stop_final = fcoe_ctlr_disc_stop_final;
+		priv = fip;
+	} else {
+		lport->rport_priv_size = 0;
+		lport->point_to_multipoint = 0;
+		lport->tt.disc_recv_req = NULL;
+		lport->tt.disc_start = NULL;
+		lport->tt.disc_stop = NULL;
+		lport->tt.disc_stop_final = NULL;
+		priv = lport;
+	}
+
+	fc_disc_config(lport, priv);
+}
+
+/**
  * fcoe_libfc_config() - Sets up libfc related properties for local port
  * @lport:    The local port to configure libfc for
  * @fip:      The FCoE controller in use by the local port
@@ -2826,8 +2867,6 @@ unlock:
 int fcoe_libfc_config(struct fc_lport *lport, struct fcoe_ctlr *fip,
 		      const struct libfc_function_template *tt, int init_fcp)
 {
-	void *priv = lport;
-
 	/* Set the function pointers set by the LLDD */
 	memcpy(&lport->tt, tt, sizeof(*tt));
 	if (init_fcp && fc_fcp_init(lport))
@@ -2835,21 +2874,9 @@ int fcoe_libfc_config(struct fc_lport *lport, struct fcoe_ctlr *fip,
 	fc_exch_init(lport);
 	fc_elsct_init(lport);
 	fc_lport_init(lport);
-	if (fip->mode == FIP_MODE_VN2VN)
-		lport->rport_priv_size = sizeof(struct fcoe_rport);
 	fc_rport_init(lport);
-	if (fip->mode == FIP_MODE_VN2VN) {
-		lport->point_to_multipoint = 1;
-		lport->tt.disc_recv_req = fcoe_ctlr_disc_recv;
-		lport->tt.disc_start = fcoe_ctlr_disc_start;
-		lport->tt.disc_stop = fcoe_ctlr_disc_stop;
-		lport->tt.disc_stop_final = fcoe_ctlr_disc_stop_final;
-		priv = fip;
-	}
-
 	fc_disc_init(lport);
-	fc_disc_config(lport, priv);
-
+	fcoe_ctlr_mode_set(lport, fip, fip->mode);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fcoe_libfc_config);
@@ -2877,6 +2904,7 @@ EXPORT_SYMBOL(fcoe_fcf_get_selected);
 void fcoe_ctlr_set_fip_mode(struct fcoe_ctlr_device *ctlr_dev)
 {
 	struct fcoe_ctlr *ctlr = fcoe_ctlr_device_priv(ctlr_dev);
+	struct fc_lport *lport = ctlr->lp;
 
 	mutex_lock(&ctlr->ctlr_mutex);
 	switch (ctlr_dev->mode) {
@@ -2890,5 +2918,7 @@ void fcoe_ctlr_set_fip_mode(struct fcoe_ctlr_device *ctlr_dev)
 	}
 
 	mutex_unlock(&ctlr->ctlr_mutex);
+
+	fcoe_ctlr_mode_set(lport, ctlr, ctlr->mode);
 }
 EXPORT_SYMBOL(fcoe_ctlr_set_fip_mode);

