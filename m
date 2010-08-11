From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] scsi/block: increase flush/sync timeout v2
Date: Wed, 11 Aug 2010 11:06:25 -0500
Message-ID: <1281542785-31395-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab0HKQCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2010 12:02:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@kernel.dk
Cc: Mike Christie <mchristi@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <mchristi@redhat.com>

We have been seeing the flush request timeout with a wide
range of hardware from tgt+iser to FC targets from a major vendor.

After discussions about if the value should be configurable and
what the best value should be, this patch just increases the flush/sync
cache timeout to 1 minute. 2 minutes was determined to be too long, and
making it configurable was troublesome for users.

This patch was made over Linus's tree. It is not made over scsi-misc
or scsi-rc-fixes, because Linus's had block layer changes that my
patch was built over.


v2
- Decreased timeout to 60 secs.

v1
- Initial patch with 120 sec timeout.

v0
- Initial patch that allowed user to set timeout
in sysfs.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/sd.c |    4 ++--
 drivers/scsi/sd.h |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8e2e893..f7e79e3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -477,7 +477,7 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 
 static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 {
-	rq->timeout = SD_TIMEOUT;
+	rq->timeout = SD_FLUSH_TIMEOUT;
 	rq->retries = SD_MAX_RETRIES;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
 	rq->cmd_len = 10;
@@ -1072,7 +1072,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		 * flush everything.
 		 */
 		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-				       SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+				       SD_FLUSH_TIMEOUT, SD_MAX_RETRIES, NULL);
 		if (res == 0)
 			break;
 	}
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index f81a930..315ce9d 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -19,6 +19,7 @@
  */
 #define SD_TIMEOUT		(30 * HZ)
 #define SD_MOD_TIMEOUT		(75 * HZ)
+#define SD_FLUSH_TIMEOUT	(60 * HZ)
 
 /*
  * Number of allowed retries
-- 
1.6.6.1

