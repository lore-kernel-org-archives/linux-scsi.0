From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/4] scsi_dh_alua: Do not modify the interval value for retries
Date: Fri, 12 May 2017 15:15:05 +0200
Message-ID: <20170512131508.3231-2-mwilck@suse.com>
References: <20170512131508.3231-1-mwilck@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:54827 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751900AbdELNPp (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Fri, 12 May 2017 09:15:45 -0400
In-Reply-To: <20170512131508.3231-1-mwilck@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

We shouldn't set the interval value to 0 in alua_rtpg_work(), as the struct
is accessed from different devices and hence we might end up scheduling
too early.

With this change, pg->interval is now effectively constant, thus we might
as well replace it with a contant expression.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index c01b47e5b55a..f17dccb2f72b 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -53,6 +53,7 @@
 #define ALUA_FAILOVER_TIMEOUT		60
 #define ALUA_FAILOVER_RETRIES		5
 #define ALUA_RTPG_DELAY_MSECS		5
+#define ALUA_RTPG_RETRY_INTERVAL	(2*HZ)
 
 /* device handler flags */
 #define ALUA_OPTIMIZE_STPG		0x01
@@ -86,7 +87,6 @@ struct alua_port_group {
 	unsigned		flags; /* used for optimizing STPG */
 	unsigned char		transition_tmo;
 	unsigned long		expiry;
-	unsigned long		interval;
 	struct delayed_work	rtpg_work;
 	spinlock_t		lock;
 	struct list_head	rtpg_list;
@@ -681,7 +681,6 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	case SCSI_ACCESS_STATE_TRANSITIONING:
 		if (time_before(jiffies, pg->expiry)) {
 			/* State transition, retry */
-			pg->interval = 2;
 			err = SCSI_DH_RETRY;
 		} else {
 			struct alua_dh_data *h;
@@ -811,7 +810,7 @@ static void alua_rtpg_work(struct work_struct *work)
 				pg->flags |= ALUA_PG_RUN_RTPG;
 				spin_unlock_irqrestore(&pg->lock, flags);
 				queue_delayed_work(alua_wq, &pg->rtpg_work,
-						   pg->interval * HZ);
+						   ALUA_RTPG_RETRY_INTERVAL);
 				return;
 			}
 			/* Send RTPG on failure or if TUR indicates SUCCESS */
@@ -823,7 +822,7 @@ static void alua_rtpg_work(struct work_struct *work)
 			pg->flags |= ALUA_PG_RUN_RTPG;
 			spin_unlock_irqrestore(&pg->lock, flags);
 			queue_delayed_work(alua_wq, &pg->rtpg_work,
-					   pg->interval * HZ);
+					   ALUA_RTPG_RETRY_INTERVAL);
 			return;
 		}
 		if (err != SCSI_DH_OK)
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
@@ -886,7 +883,6 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
 		force = true;
 	}
 	if (pg->rtpg_sdev == NULL) {
-		pg->interval = 0;
 		pg->flags |= ALUA_PG_RUN_RTPG;
 		kref_get(&pg->kref);
 		pg->rtpg_sdev = sdev;
-- 
2.12.2
