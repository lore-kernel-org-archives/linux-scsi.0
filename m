From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 30/54] libfcoe: Allow FIP to be disabled by the driver
Date: Tue, 03 Nov 2009 11:48:11 -0800
Message-ID: <20091103194811.4085.98808.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2649 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991AbZKCTsM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:48:12 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Allow FIP to be disabled by the driver for devices
that want to use libfcoe in non-FIP mode.

The driver merely sets the fcoe_ctlr mode to the state which
should be entered when the link comes up.  The default is auto.
No change is needed for fcoe.c which uses auto mode.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    6 ++++--
 include/scsi/libfcoe.h      |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 6b07a84..1ea17a3 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -109,6 +109,7 @@ static inline int fcoe_ctlr_fcf_usable(struct fcoe_fcf *fcf)
 void fcoe_ctlr_init(struct fcoe_ctlr *fip)
 {
 	fip->state = FIP_ST_LINK_WAIT;
+	fip->mode = FIP_ST_AUTO;
 	INIT_LIST_HEAD(&fip->fcfs);
 	spin_lock_init(&fip->lock);
 	fip->flogi_oxid = FC_XID_UNKNOWN;
@@ -261,11 +262,12 @@ void fcoe_ctlr_link_up(struct fcoe_ctlr *fip)
 		spin_unlock_bh(&fip->lock);
 		fc_linkup(fip->lp);
 	} else if (fip->state == FIP_ST_LINK_WAIT) {
-		fip->state = FIP_ST_AUTO;
+		fip->state = fip->mode;
 		fip->last_link = 1;
 		fip->link = 1;
 		spin_unlock_bh(&fip->lock);
-		LIBFCOE_FIP_DBG("%s", "setting AUTO mode.\n");
+		if (fip->state == FIP_ST_AUTO)
+			LIBFCOE_FIP_DBG("%s", "setting AUTO mode.\n");
 		fc_linkup(fip->lp);
 		fcoe_ctlr_solicit(fip, NULL);
 	} else
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 76d08c9..2344a00 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -55,6 +55,7 @@ enum fip_state {
 /**
  * struct fcoe_ctlr - FCoE Controller and FIP state
  * @state:	   internal FIP state for network link and FIP or non-FIP mode.
+ * @mode:	   LLD-selected mode.
  * @lp:		   &fc_lport: libfc local port.
  * @sel_fcf:	   currently selected FCF, or NULL.
  * @fcfs:	   list of discovered FCFs.
@@ -89,6 +90,7 @@ enum fip_state {
  */
 struct fcoe_ctlr {
 	enum fip_state state;
+	enum fip_state mode;
 	struct fc_lport *lp;
 	struct fcoe_fcf *sel_fcf;
 	struct list_head fcfs;

