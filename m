From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/30] libfc: Fixup disc_mutex handling
Date: Fri, 26 Aug 2016 14:01:34 +0200
Message-ID: <1472212913-39810-12-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35179 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752176AbcHZMCL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:11 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The list of attached 'rdata' remote port structures is RCU
protected, so there is no need to take the 'disc_mutex' when
traversing it.
Rather we should be using rcu_read_lock() and kref_get_unless_zero()
to validate the entries.
We need, however, take the disc_mutex when deleting an entry;
otherwise we risk clashes with list_add.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 28 ++++++++++++++++++++++------
 drivers/scsi/libfc/fc_disc.c  | 30 +++++++++++++++++++-----------
 drivers/scsi/libfc/fc_rport.c |  2 ++
 3 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index a569c65..5eacd33 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2145,9 +2145,15 @@ static void fcoe_ctlr_disc_stop_locked(struct fc_lport *lport)
 {
 	struct fc_rport_priv *rdata;
 
+	rcu_read_lock();
+	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers) {
+		if (kref_get_unless_zero(&rdata->kref)) {
+			lport->tt.rport_logoff(rdata);
+			kref_put(&rdata->kref, lport->tt.rport_destroy);
+		}
+	}
+	rcu_read_unlock();
 	mutex_lock(&lport->disc.disc_mutex);
-	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers)
-		lport->tt.rport_logoff(rdata);
 	lport->disc.disc_callback = NULL;
 	mutex_unlock(&lport->disc.disc_mutex);
 }
@@ -2638,11 +2644,15 @@ static unsigned long fcoe_ctlr_vn_age(struct fcoe_ctlr *fip)
 	unsigned long deadline;
 
 	next_time = jiffies + msecs_to_jiffies(FIP_VN_BEACON_INT * 10);
-	mutex_lock(&lport->disc.disc_mutex);
+	rcu_read_lock();
 	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers) {
+		if (!kref_get_unless_zero(&rdata->kref))
+			continue;
 		frport = fcoe_ctlr_rport(rdata);
-		if (!frport->time)
+		if (!frport->time) {
+			kref_put(&rdata->kref, lport->tt.rport_destroy);
 			continue;
+		}
 		deadline = frport->time +
 			   msecs_to_jiffies(FIP_VN_BEACON_INT * 25 / 10);
 		if (time_after_eq(jiffies, deadline)) {
@@ -2653,8 +2663,9 @@ static unsigned long fcoe_ctlr_vn_age(struct fcoe_ctlr *fip)
 			lport->tt.rport_logoff(rdata);
 		} else if (time_before(deadline, next_time))
 			next_time = deadline;
+		kref_put(&rdata->kref, lport->tt.rport_destroy);
 	}
-	mutex_unlock(&lport->disc.disc_mutex);
+	rcu_read_unlock();
 	return next_time;
 }
 
@@ -2991,12 +3002,17 @@ static void fcoe_ctlr_vn_disc(struct fcoe_ctlr *fip)
 	mutex_lock(&disc->disc_mutex);
 	callback = disc->pending ? disc->disc_callback : NULL;
 	disc->pending = 0;
+	mutex_unlock(&disc->disc_mutex);
+	rcu_read_lock();
 	list_for_each_entry_rcu(rdata, &disc->rports, peers) {
+		if (!kref_get_unless_zero(&rdata->kref))
+			continue;
 		frport = fcoe_ctlr_rport(rdata);
 		if (frport->time)
 			lport->tt.rport_login(rdata);
+		kref_put(&rdata->kref, lport->tt.rport_destroy);
 	}
-	mutex_unlock(&disc->disc_mutex);
+	rcu_read_unlock();
 	if (callback)
 		callback(lport, DISC_EV_SUCCESS);
 }
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 880a906..351022a 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -68,10 +68,14 @@ static void fc_disc_stop_rports(struct fc_disc *disc)
 
 	lport = fc_disc_lport(disc);
 
-	mutex_lock(&disc->disc_mutex);
-	list_for_each_entry_rcu(rdata, &disc->rports, peers)
-		lport->tt.rport_logoff(rdata);
-	mutex_unlock(&disc->disc_mutex);
+	rcu_read_lock();
+	list_for_each_entry_rcu(rdata, &disc->rports, peers) {
+		if (kref_get_unless_zero(&rdata->kref)) {
+			lport->tt.rport_logoff(rdata);
+			kref_put(&rdata->kref, lport->tt.rport_destroy);
+		}
+	}
+	rcu_read_unlock();
 }
 
 /**
@@ -289,16 +293,20 @@ static void fc_disc_done(struct fc_disc *disc, enum fc_disc_event event)
 	 * Skip ports which were never discovered.  These are the dNS port
 	 * and ports which were created by PLOGI.
 	 */
+	mutex_unlock(&disc->disc_mutex);
+	rcu_read_lock();
 	list_for_each_entry_rcu(rdata, &disc->rports, peers) {
-		if (!rdata->disc_id)
+		if (!kref_get_unless_zero(&rdata->kref))
 			continue;
-		if (rdata->disc_id == disc->disc_id)
-			lport->tt.rport_login(rdata);
-		else
-			lport->tt.rport_logoff(rdata);
+		if (rdata->disc_id) {
+			if (rdata->disc_id == disc->disc_id)
+				lport->tt.rport_login(rdata);
+			else
+				lport->tt.rport_logoff(rdata);
+		}
+		kref_put(&rdata->kref, lport->tt.rport_destroy);
 	}
-
-	mutex_unlock(&disc->disc_mutex);
+	rcu_read_unlock();
 	disc->disc_callback(lport, event);
 	mutex_lock(&disc->disc_mutex);
 }
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 91866a5..fa716f5 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -380,7 +380,9 @@ static void fc_rport_work(struct work_struct *work)
 				mutex_unlock(&rdata->rp_mutex);
 			} else {
 				FC_RPORT_DBG(rdata, "work delete\n");
+				mutex_lock(&lport->disc.disc_mutex);
 				list_del_rcu(&rdata->peers);
+				mutex_unlock(&lport->disc.disc_mutex);
 				mutex_unlock(&rdata->rp_mutex);
 				kref_put(&rdata->kref, lport->tt.rport_destroy);
 			}
-- 
1.8.5.6

