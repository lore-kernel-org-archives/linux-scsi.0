From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/3] scsi_dh_alua: Do not modify the interval value for retries
Date: Fri, 28 Apr 2017 15:06:24 +0200
Message-ID: <20170428130626.32162-2-mwilck@suse.com>
References: <20170428130626.32162-1-mwilck@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46138 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755456AbdD1NG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Apr 2017 09:06:57 -0400
In-Reply-To: <20170428130626.32162-1-mwilck@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

We shouldn't modify the interval value, as the struct is accessed
from different devices and hence we might end up scheduling too
early.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index c01b47e5b55a..b90a5dec199f 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -681,7 +681,6 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	case SCSI_ACCESS_STATE_TRANSITIONING:
 		if (time_before(jiffies, pg->expiry)) {
 			/* State transition, retry */
-			pg->interval = 2;
 			err = SCSI_DH_RETRY;
 		} else {
 			struct alua_dh_data *h;
@@ -836,11 +835,9 @@ static void alua_rtpg_work(struct work_struct *work)
 		spin_lock_irqsave(&pg->lock, flags);
 		if (err == SCSI_DH_RETRY || pg->flags & ALUA_PG_RUN_RTPG) {
 			pg->flags |= ALUA_PG_RUN_RTPG;
-			pg->interval = 0;
 			pg->flags &= ~ALUA_PG_RUNNING;
 			spin_unlock_irqrestore(&pg->lock, flags);
-			queue_delayed_work(alua_wq, &pg->rtpg_work,
-					   pg->interval * HZ);
+			queue_delayed_work(alua_wq, &pg->rtpg_work, 0);
 			return;
 		}
 	}
@@ -886,7 +883,7 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
 		force = true;
 	}
 	if (pg->rtpg_sdev == NULL) {
-		pg->interval = 0;
+		pg->interval = 2;
 		pg->flags |= ALUA_PG_RUN_RTPG;
 		kref_get(&pg->kref);
 		pg->rtpg_sdev = sdev;
-- 
2.12.2
