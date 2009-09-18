From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/24] libfcoe: Allow FIP to be disabled by the driver
Date: Fri, 18 Sep 2009 15:48:58 -0700
Message-ID: <20090918224858.5928.50377.stgit@localhost.localdomain>
References: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12201 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757655AbZIRWsz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:48:55 -0400
In-Reply-To: <20090918224847.5928.52092.stgit@localhost.localdomain>
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
index a563c99..b1e4d25 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -110,6 +110,7 @@ static inline int fcoe_ctlr_fcf_usable(struct fcoe_fcf *fcf)
 void fcoe_ctlr_init(struct fcoe_ctlr *fip)
 {
 	fip->state = FIP_ST_LINK_WAIT;
+	fip->mode = FIP_ST_AUTO;
 	INIT_LIST_HEAD(&fip->fcfs);
 	spin_lock_init(&fip->lock);
 	fip->flogi_oxid = FC_XID_UNKNOWN;
@@ -262,11 +263,12 @@ void fcoe_ctlr_link_up(struct fcoe_ctlr *fip)
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

