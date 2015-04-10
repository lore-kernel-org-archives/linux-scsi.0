From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] block: don't overwrite max_sectors if user has set it
Date: Fri, 10 Apr 2015 02:08:40 -0500
Message-ID: <1428649720-14316-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45366 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbbDJHI6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Apr 2015 03:08:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@fb.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the user has set max_sectors in sysfs, but the disk is revalidated
due to it being removable or having write protections and it being
opened, or dm/md claiming it, or something like a scsi rescan, etc,
then we are overwriting the user specified max_sectors value. This patch
only has us set the max_sectors if the new max_hw_sectors is smaller
or if the user has not changed max_sectors.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/blk-settings.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 12600bf..d6c7b0c 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -248,6 +248,10 @@ EXPORT_SYMBOL(blk_queue_bounce_limit);
  *    filesystem type requests.  This value can be overridden on a
  *    per-device basis in /sys/block/<device>/queue/max_sectors_kb.
  *    The soft limit can not exceed max_hw_sectors.
+ *
+ *    If this is called as a result of a revalidation then we will only
+ *    override the user specified max_sectors if the new max_hw_sectors is
+ *    smaller.
  **/
 void blk_limits_max_hw_sectors(struct queue_limits *limits, unsigned int max_hw_sectors)
 {
@@ -257,7 +261,11 @@ void blk_limits_max_hw_sectors(struct queue_limits *limits, unsigned int max_hw_
 		       __func__, max_hw_sectors);
 	}
 
-	limits->max_sectors = limits->max_hw_sectors = max_hw_sectors;
+	if (limits->max_sectors == limits->max_hw_sectors ||
+	    max_hw_sectors < limits->max_sectors)
+		limits->max_sectors = limits->max_hw_sectors = max_hw_sectors;
+	else
+		limits->max_hw_sectors = max_hw_sectors;
 }
 EXPORT_SYMBOL(blk_limits_max_hw_sectors);
 
-- 
1.8.3.1

