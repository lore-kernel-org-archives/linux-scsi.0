From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/22] libfc: stop login after fabric logoff
Date: Wed, 29 Jul 2009 17:04:27 -0700
Message-ID: <20090730000427.24658.63712.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:15905 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391AbZG3AE1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:04:27 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

When removing the fcoe module, several lports were being shut down
through fc_lport_fabric_logoff().

Occasionally, one would enter reset state before fc_lport_destroy()
was called, and since link_up was still true, it would log back in.

If we just clear link_up earlier, then we wouldn't be accepting LOGO
requests from other initiators while we are shutting down.

Fix by changing the LOGO response handler to enter DISABLED instead
of RESET.  Add an fc_lport_enter_disabled() function which does
what fc_lport_enter_reset() did, except it doesn't proceed to FLOGI state.

Move the code that was common between fc_lport_enter_reset() and
fc_lport_enter_disabled() into a new fc_lport_reset_locked() function.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |   42 +++++++++++++++++++++++++++++++++--------
 1 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 3b28190..7bb451a 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -930,19 +930,14 @@ int fc_lport_reset(struct fc_lport *lport)
 EXPORT_SYMBOL(fc_lport_reset);
 
 /**
- * fc_rport_enter_reset() - Reset the local port
+ * fc_lport_reset_locked() - Reset the local port
  * @lport: Fibre Channel local port to be reset
  *
  * Locking Note: The lport lock is expected to be held before calling
  * this routine.
  */
-static void fc_lport_enter_reset(struct fc_lport *lport)
+static void fc_lport_reset_locked(struct fc_lport *lport)
 {
-	FC_LPORT_DBG(lport, "Entered RESET state from %s state\n",
-		     fc_lport_state(lport));
-
-	fc_lport_state_enter(lport, LPORT_ST_RESET);
-
 	if (lport->dns_rp)
 		lport->tt.rport_logoff(lport->dns_rp);
 
@@ -956,12 +951,43 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 	lport->tt.exch_mgr_reset(lport, 0, 0);
 	fc_host_fabric_name(lport->host) = 0;
 	fc_host_port_id(lport->host) = 0;
+}
+
+/**
+ * fc_lport_enter_reset() - Reset the local port
+ * @lport: Fibre Channel local port to be reset
+ *
+ * Locking Note: The lport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_lport_enter_reset(struct fc_lport *lport)
+{
+	FC_LPORT_DBG(lport, "Entered RESET state from %s state\n",
+		     fc_lport_state(lport));
 
+	fc_lport_state_enter(lport, LPORT_ST_RESET);
+	fc_lport_reset_locked(lport);
 	if (lport->link_up)
 		fc_lport_enter_flogi(lport);
 }
 
 /**
+ * fc_lport_enter_disabled() - disable the local port
+ * @lport: Fibre Channel local port to be reset
+ *
+ * Locking Note: The lport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_lport_enter_disabled(struct fc_lport *lport)
+{
+	FC_LPORT_DBG(lport, "Entered disabled state from %s state\n",
+		     fc_lport_state(lport));
+
+	fc_lport_state_enter(lport, LPORT_ST_DISABLED);
+	fc_lport_reset_locked(lport);
+}
+
+/**
  * fc_lport_error() - Handler for any errors
  * @lport: The fc_lport object
  * @fp: The frame pointer
@@ -1382,7 +1408,7 @@ static void fc_lport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC)
-		fc_lport_enter_reset(lport);
+		fc_lport_enter_disabled(lport);
 	else
 		fc_lport_error(lport, fp);
 

