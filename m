From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] libfc: only restart discovery after timeout if not already running
Date: Tue, 30 May 2017 17:14:13 +0200
Message-ID: <1496157254-114166-3-git-send-email-hare@suse.de>
References: <1496157254-114166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58440 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750767AbdE3PPC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 May 2017 11:15:02 -0400
In-Reply-To: <1496157254-114166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

If a discovery is already running (ie if the 'pending' flags is set)
there is no need to restart discovery from the timeout handler.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_disc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 913beb5..82b1c97 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -503,10 +503,12 @@ static void fc_disc_timeout(struct work_struct *work)
 					    struct fc_disc,
 					    disc_work.work);
 	mutex_lock(&disc->disc_mutex);
-	disc->pending = 1;
-	disc->requested = 0;
+	if (!disc->pending) {
+		disc->pending = 1;
+		disc->requested = 0;
 
-	fc_disc_gpn_ft_req(disc);
+		fc_disc_gpn_ft_req(disc);
+	}
 	mutex_unlock(&disc->disc_mutex);
 }
 
-- 
1.8.5.6
