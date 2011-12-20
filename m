From: Tao Ma <tm@tao.ma>
Subject: [PATCH] block: warn the wrong tag only if it is greater than real_max_depth.
Date: Tue, 20 Dec 2011 23:58:47 +0800
Message-ID: <1324396727-2840-1-git-send-email-tm@tao.ma>
References: <4EF0940D.7070304@kernel.dk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:49340 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752766Ab1LTQBI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2011 11:01:08 -0500
In-Reply-To: <4EF0940D.7070304@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dan.j.williams@intel.com, Jens Axboe <axboe@kernel.dk>

From: Tao Ma <boyu.mt@taobao.com>

In queue depth decreases, we could meet with a tag greater than max_depth,
but it should never be greater than real_max_depth. So only WARN if
it is greater than real_max_depth and let it complets if it is greater
than max_depth.

Reported-by: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 block/blk-tag.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index e74d6d1..1c50d34 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -286,12 +286,12 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 
 	BUG_ON(tag == -1);
 
-	if (unlikely(tag >= bqt->max_depth)) {
+	if (unlikely(tag >= bqt->real_max_depth)) {
 		/*
-		 * This can happen after tag depth has been reduced.
-		 * But tag shouldn't be larger than real_max_depth.
+		 * tag shouldn't be larger than real_max_depth.
 		 */
-		WARN_ON(tag >= bqt->real_max_depth);
+		WARN(1, "tag %d, bqt->real_max_depth %d\n",
+		     tag, bqt->real_max_depth);
 		return;
 	}
 
-- 
1.7.4.1

