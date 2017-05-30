From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] libfc: move 'pending' and 'requested' setting
Date: Tue, 30 May 2017 17:14:12 +0200
Message-ID: <1496157254-114166-2-git-send-email-hare@suse.de>
References: <1496157254-114166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58442 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751126AbdE3POr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 May 2017 11:14:47 -0400
In-Reply-To: <1496157254-114166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Move 'pending' and 'requested' setting out of fc_disc_gpn_fc_req()
into the calling function.

No functional change.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_disc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index fd501f8..913beb5 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -242,6 +242,9 @@ static void fc_disc_restart(struct fc_disc *disc)
 	 */
 	disc->disc_id = (disc->disc_id + 2) | 1;
 	disc->retry_count = 0;
+	disc->pending = 1;
+	disc->requested = 0;
+
 	fc_disc_gpn_ft_req(disc);
 }
 
@@ -371,9 +374,6 @@ static void fc_disc_gpn_ft_req(struct fc_disc *disc)
 
 	WARN_ON(!fc_lport_test_ready(lport));
 
-	disc->pending = 1;
-	disc->requested = 0;
-
 	disc->buf_len = 0;
 	disc->seq_count = 0;
 	fp = fc_frame_alloc(lport,
@@ -503,6 +503,9 @@ static void fc_disc_timeout(struct work_struct *work)
 					    struct fc_disc,
 					    disc_work.work);
 	mutex_lock(&disc->disc_mutex);
+	disc->pending = 1;
+	disc->requested = 0;
+
 	fc_disc_gpn_ft_req(disc);
 	mutex_unlock(&disc->disc_mutex);
 }
-- 
1.8.5.6
