From: michaelc@cs.wisc.edu
Subject: [PATCH 03/13] libfc: fix locking in tt.rport_lookup_create paths
Date: Sun, 29 Jun 2008 13:23:53 -0500
Message-ID: <1214763843-5548-4-git-send-email-michaelc@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-2-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757532AbYF2SYK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2008 14:24:10 -0400
In-Reply-To: <1214763843-5548-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

In some code paths we had the fl_lock when calling
tt.rport_lookup_create. tt.rport_lookup_create can sleep if
it needs to create a new rport (fc class uses GFP_KERNEL
for example), so we need to have the spin locks dropped.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libfc/fc_disc.c  |    7 +++++++
 drivers/scsi/libfc/fc_lport.c |    7 +++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 45210c3..a1b5171 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -907,7 +907,14 @@ static void fc_disc_enter_dns(struct fc_lport *lp)
 		/*
 		 * Set up remote port to directory server.
 		 */
+
+		/*
+		 * we are called with the fl_lock, but if rport_lookup_create
+		 * needs to create a rport then it will sleep.
+		 */
+		spin_unlock_bh(&lp->fl_lock);
 		rp = lp->tt.rport_lookup_create(lp, &ids);
+		spin_lock_bh(&lp->fl_lock);
 		if (!rp)
 			goto err;
 		lp->tt.sess_init(lp, rp);
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e3eae92..a7ffab7 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -177,7 +177,14 @@ static void fc_lport_ptp_setup(struct fc_lport *lp,
 		.node_name = remote_wwnn,
 	};
 
+
+	/*
+	 * if we have to create a rport the fc class can sleep so we must
+	 * drop the lock here
+	 */
+	spin_unlock_bh(&lp->fl_lock);
 	rp = lp->tt.rport_lookup_create(lp, &ids);
+	spin_lock_bh(&lp->fl_lock);
 	if (rp) {
 		if (lp->fl_ptp_rp)
 			lp->tt.rport_release(lp->fl_ptp_rp);
-- 
1.5.4.1

