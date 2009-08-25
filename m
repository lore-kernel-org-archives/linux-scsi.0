From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 30/64] libfc: rearrange code in fc_rport_work
Date: Tue, 25 Aug 2009 14:01:06 -0700
Message-ID: <20090825210106.1553.21133.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37567 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbZHYVBH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:01:07 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

This is a cleanup without semantic changes to use a switch
statement instead of a series of if-statements in fc_rport_work(),
and to move some declarations up to the top.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 69f6e58..d0a4542 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -233,6 +233,9 @@ static void fc_rport_work(struct work_struct *work)
 	enum fc_rport_trans_state trans_state;
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_rport_operations *rport_ops;
+	struct fc_rport *new_rport;
+	struct fc_rport_priv *new_rdata;
+	struct fc_rport_identifiers ids;
 	struct fc_rport *rport;
 
 	mutex_lock(&rdata->rp_mutex);
@@ -240,11 +243,8 @@ static void fc_rport_work(struct work_struct *work)
 	rport_ops = rdata->ops;
 	rport = rdata->rport;
 
-	if (event == RPORT_EV_CREATED) {
-		struct fc_rport *new_rport;
-		struct fc_rport_priv *new_rdata;
-		struct fc_rport_identifiers ids;
-
+	switch (event) {
+	case RPORT_EV_CREATED:
 		ids = rdata->ids;
 		rdata->event = RPORT_EV_NONE;
 		mutex_unlock(&rdata->rp_mutex);
@@ -289,9 +289,11 @@ static void fc_rport_work(struct work_struct *work)
 		rdata = new_rport->dd_data;
 		if (rport_ops->event_callback)
 			rport_ops->event_callback(lport, rdata, event);
-	} else if ((event == RPORT_EV_FAILED) ||
-		   (event == RPORT_EV_LOGO) ||
-		   (event == RPORT_EV_STOP)) {
+		break;
+
+	case RPORT_EV_FAILED:
+	case RPORT_EV_LOGO:
+	case RPORT_EV_STOP:
 		trans_state = rdata->trans_state;
 		mutex_unlock(&rdata->rp_mutex);
 		if (rport_ops->event_callback)
@@ -305,8 +307,12 @@ static void fc_rport_work(struct work_struct *work)
 			lport->tt.exch_mgr_reset(lport, 0, port_id);
 			lport->tt.exch_mgr_reset(lport, port_id, 0);
 		}
-	} else
+		break;
+
+	default:
 		mutex_unlock(&rdata->rp_mutex);
+		break;
+	}
 }
 
 /**

