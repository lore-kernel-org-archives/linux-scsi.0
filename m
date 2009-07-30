From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/22] libfc: rename lport NONE state to DISABLED
Date: Wed, 29 Jul 2009 17:04:22 -0700
Message-ID: <20090730000422.24658.30983.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10105 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391AbZG3AEV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:04:21 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The state NONE was meant to be invalid, but has been used as
the initial state.  Rename it to be DISABLED, as more descriptive.
Further patches will make it the like the RESET state, except
it won't transition to FLOGI until fc_lport_fabric_login() is called.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c  |    2 +-
 drivers/scsi/libfc/fc_lport.c |   12 ++++++------
 include/scsi/libfc.h          |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 145ab9b..e6d82d7 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1875,7 +1875,7 @@ void fc_exch_recv(struct fc_lport *lp, struct fc_exch_mgr *mp,
 	u32 f_ctl;
 
 	/* lport lock ? */
-	if (!lp || !mp || (lp->state == LPORT_ST_NONE)) {
+	if (!lp || !mp || lp->state == LPORT_ST_DISABLED) {
 		FC_LPORT_DBG(lp, "Receiving frames for an lport that "
 			     "has not been initialized correctly\n");
 		fc_frame_free(fp);
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 745fa55..3b28190 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -113,7 +113,7 @@ static void fc_lport_enter_ready(struct fc_lport *);
 static void fc_lport_enter_logo(struct fc_lport *);
 
 static const char *fc_lport_state_names[] = {
-	[LPORT_ST_NONE] =     "none",
+	[LPORT_ST_DISABLED] = "disabled",
 	[LPORT_ST_FLOGI] =    "FLOGI",
 	[LPORT_ST_DNS] =      "dNS",
 	[LPORT_ST_RPN_ID] =   "RPN_ID",
@@ -550,7 +550,7 @@ int fc_fabric_login(struct fc_lport *lport)
 	int rc = -1;
 
 	mutex_lock(&lport->lp_mutex);
-	if (lport->state == LPORT_ST_NONE) {
+	if (lport->state == LPORT_ST_DISABLED) {
 		fc_lport_enter_reset(lport);
 		rc = 0;
 	}
@@ -637,7 +637,7 @@ EXPORT_SYMBOL(fc_fabric_logoff);
 int fc_lport_destroy(struct fc_lport *lport)
 {
 	mutex_lock(&lport->lp_mutex);
-	lport->state = LPORT_ST_NONE;
+	lport->state = LPORT_ST_DISABLED;
 	lport->link_up = 0;
 	lport->tt.frame_send = fc_frame_drop;
 	mutex_unlock(&lport->lp_mutex);
@@ -992,7 +992,7 @@ static void fc_lport_error(struct fc_lport *lport, struct fc_frame *fp)
 			schedule_delayed_work(&lport->retry_work, delay);
 		} else {
 			switch (lport->state) {
-			case LPORT_ST_NONE:
+			case LPORT_ST_DISABLED:
 			case LPORT_ST_READY:
 			case LPORT_ST_RESET:
 			case LPORT_ST_RPN_ID:
@@ -1316,7 +1316,7 @@ static void fc_lport_timeout(struct work_struct *work)
 	mutex_lock(&lport->lp_mutex);
 
 	switch (lport->state) {
-	case LPORT_ST_NONE:
+	case LPORT_ST_DISABLED:
 	case LPORT_ST_READY:
 	case LPORT_ST_RESET:
 		WARN_ON(1);
@@ -1550,7 +1550,7 @@ int fc_lport_config(struct fc_lport *lport)
 	INIT_DELAYED_WORK(&lport->retry_work, fc_lport_timeout);
 	mutex_init(&lport->lp_mutex);
 
-	fc_lport_state_enter(lport, LPORT_ST_NONE);
+	fc_lport_state_enter(lport, LPORT_ST_DISABLED);
 
 	fc_lport_add_fc4_type(lport, FC_TYPE_FCP);
 	fc_lport_add_fc4_type(lport, FC_TYPE_CT);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index efdb6ba..b5c9b28 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -129,7 +129,7 @@ do {									\
  * FC HBA status
  */
 enum fc_lport_state {
-	LPORT_ST_NONE = 0,
+	LPORT_ST_DISABLED = 0,
 	LPORT_ST_FLOGI,
 	LPORT_ST_DNS,
 	LPORT_ST_RPN_ID,

