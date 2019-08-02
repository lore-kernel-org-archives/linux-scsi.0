From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 36/42] scsi: scsi_dh_alua: always use a 2 second delay before retrying RTPG
Date: Fri,  2 Aug 2019 09:22:56 -0400
Message-ID: <20190802132302.13537-36-sashal@kernel.org>
References: <20190802132302.13537-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190802132302.13537-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>, Zhangguanghui <zhang.guanghui@h3c.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 20122994e38aef0ae50555884d287adde6641c94 ]

Retrying immediately after we've received a 'transitioning' sense code is
pretty much pointless, we should always use a delay before retrying.  So
ensure the default delay is applied before retrying.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Tested-by: Zhangguanghui <zhang.guanghui@h3c.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index d1154baa9436a..9c21938ed67ed 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -54,6 +54,7 @@
 #define ALUA_FAILOVER_TIMEOUT		60
 #define ALUA_FAILOVER_RETRIES		5
 #define ALUA_RTPG_DELAY_MSECS		5
+#define ALUA_RTPG_RETRY_DELAY		2
 
 /* device handler flags */
 #define ALUA_OPTIMIZE_STPG		0x01
@@ -696,7 +697,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	case SCSI_ACCESS_STATE_TRANSITIONING:
 		if (time_before(jiffies, pg->expiry)) {
 			/* State transition, retry */
-			pg->interval = 2;
+			pg->interval = ALUA_RTPG_RETRY_DELAY;
 			err = SCSI_DH_RETRY;
 		} else {
 			struct alua_dh_data *h;
@@ -821,6 +822,8 @@ static void alua_rtpg_work(struct work_struct *work)
 				spin_lock_irqsave(&pg->lock, flags);
 				pg->flags &= ~ALUA_PG_RUNNING;
 				pg->flags |= ALUA_PG_RUN_RTPG;
+				if (!pg->interval)
+					pg->interval = ALUA_RTPG_RETRY_DELAY;
 				spin_unlock_irqrestore(&pg->lock, flags);
 				queue_delayed_work(kaluad_wq, &pg->rtpg_work,
 						   pg->interval * HZ);
@@ -832,6 +835,8 @@ static void alua_rtpg_work(struct work_struct *work)
 		spin_lock_irqsave(&pg->lock, flags);
 		if (err == SCSI_DH_RETRY || pg->flags & ALUA_PG_RUN_RTPG) {
 			pg->flags &= ~ALUA_PG_RUNNING;
+			if (!pg->interval && !(pg->flags & ALUA_PG_RUN_RTPG))
+				pg->interval = ALUA_RTPG_RETRY_DELAY;
 			pg->flags |= ALUA_PG_RUN_RTPG;
 			spin_unlock_irqrestore(&pg->lock, flags);
 			queue_delayed_work(kaluad_wq, &pg->rtpg_work,
-- 
2.20.1
