From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] libfc: fixup locking in fc_disc_stop()
Date: Tue, 30 May 2017 17:14:14 +0200
Message-ID: <1496157254-114166-4-git-send-email-hare@suse.de>
References: <1496157254-114166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58439 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750841AbdE3POi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 May 2017 11:14:38 -0400
In-Reply-To: <1496157254-114166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

fc_disc_stop() calls fc_disc_stop_rports(), which requires the
disc_mutex to be held.
And we need to ensure that no fc_disc_timeout functions are queued
after this function, so set the callback to NULL and ensure that
all functions terminate early when the callback is not set.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_disc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 82b1c97..109174f 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -283,6 +283,7 @@ static void fc_disc_done(struct fc_disc *disc, enum fc_disc_event event)
 {
 	struct fc_lport *lport = fc_disc_lport(disc);
 	struct fc_rport_priv *rdata;
+	void (*callback)(struct fc_lport *, enum fc_disc_event);
 
 	FC_DISC_DBG(disc, "Discovery complete\n");
 
@@ -311,8 +312,10 @@ static void fc_disc_done(struct fc_disc *disc, enum fc_disc_event event)
 		kref_put(&rdata->kref, fc_rport_destroy);
 	}
 	rcu_read_unlock();
+	callback = disc->disc_callback;
 	mutex_unlock(&disc->disc_mutex);
-	disc->disc_callback(lport, event);
+	if (callback)
+		callback(lport, event);
 	mutex_lock(&disc->disc_mutex);
 }
 
@@ -711,9 +714,13 @@ static void fc_disc_stop(struct fc_lport *lport)
 {
 	struct fc_disc *disc = &lport->disc;
 
-	if (disc->pending)
-		cancel_delayed_work_sync(&disc->disc_work);
+	mutex_lock(&disc->disc_mutex);
+	disc->disc_callback = NULL;
+	mutex_unlock(&disc->disc_mutex);
+	cancel_delayed_work_sync(&disc->disc_work);
+	mutex_lock(&disc->disc_mutex);
 	fc_disc_stop_rports(disc);
+	mutex_unlock(&disc->disc_mutex);
 }
 
 /**
-- 
1.8.5.6
