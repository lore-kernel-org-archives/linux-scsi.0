From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: debug: remove jiffies_to_timespec
Date: Mon, 27 Nov 2017 12:36:25 +0100
Message-ID: <20171127113647.2352914-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bart.vanassche@wdc.com>, Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is no need to go through an intermediate timespec to convert
to ktime_t when we just want a simple multiplication. This gets
rid of one of the few users of jiffies_to_timespec, which I
hope to remove as part of the y2038 cleanup.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/scsi_debug.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index e4f037f0f38b..df7e9db44d44 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4085,10 +4085,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		ktime_t kt;
 
 		if (delta_jiff > 0) {
-			struct timespec ts;
-
-			jiffies_to_timespec(delta_jiff, &ts);
-			kt = ktime_set(ts.tv_sec, ts.tv_nsec);
+			kt = ns_to_ktime((u64)delta_jiff * (NSEC_PER_SEC / HZ));
 		} else
 			kt = sdebug_ndelay;
 		if (NULL == sd_dp) {
-- 
2.9.0
