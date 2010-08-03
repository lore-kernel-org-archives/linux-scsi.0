From: michaelc@cs.wisc.edu
Subject: [PATCH] scsi/block: increase flush/sync timeout
Date: Tue,  3 Aug 2010 14:26:00 -0500
Message-ID: <1280863560-4747-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab0HCTWN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Aug 2010 15:22:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@kernel.dk, bs_lists@aakef.fastmail.fm
Cc: Mike Christie <mchristi@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <mchristi@redhat.com>

We have been seeing the flush request timeout with a wide
range of hardware from tgt+iser to FC targets from a major vendor.

I did this patch which added a flush timeout:
http://marc.info/?l=linux-scsi&m=127957359200466&w=2

A problem with that patch is how to determine what value
should be set and when you need to set it. You will
not know that you need to increase until it times out
and fails, then to figure out what to set it to you
need to set the timeout and try it out a couple times.

So this patch just increases the flush/sync cache timeout
to 2 minutes. In testing, it has taken at most around 60
seconds to complete the operation, so I thought 120 would
be safe and not add that long of delay if the device was
really jammed and needed the scsi eh.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/sd.c |    4 ++--
 drivers/scsi/sd.h |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 108daea..3ef08bd 100644
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
@@ -1064,7 +1064,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		 * flush everything.
 		 */
 		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-				       SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+				       SD_FLUSH_TIMEOUT, SD_MAX_RETRIES, NULL);
 		if (res == 0)
 			break;
 	}
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index f81a930..86e6dc3 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -19,6 +19,7 @@
  */
 #define SD_TIMEOUT		(30 * HZ)
 #define SD_MOD_TIMEOUT		(75 * HZ)
+#define SD_FLUSH_TIMEOUT	(120 * HZ)
 
 /*
  * Number of allowed retries
-- 
1.6.6.1

