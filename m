From: heinzm@redhat.com
Subject: [PATCH] md: raid10: add prerequisite to run underneath dm-raid
Date: Tue,  3 May 2016 19:42:58 +0200
Message-ID: <1462297378-771-1-git-send-email-heinzm@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip5f587210.dynamic.kabel-deutschland.de ([95.88.114.16]:51212
	"EHLO o.ww.redhat.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933831AbcECRnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2016 13:43:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Heinz Mauelshagen <heinzm@redhat.com>

From: Heinz Mauelshagen <heinzm@redhat.com>

In case md runs underneath the dm-raid target, the mddev does not have
a request queue or gendisk, thus avoid accesses to it.

This patch adds two missing conditionals to the raid10 personality.


Signed-of-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/raid10.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e3fd725..84e24e6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3782,8 +3782,10 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 			return ret;
 	}
 	md_set_array_sectors(mddev, size);
-	set_capacity(mddev->gendisk, mddev->array_sectors);
-	revalidate_disk(mddev->gendisk);
+	if (mddev->queue) {
+		set_capacity(mddev->gendisk, mddev->array_sectors);
+		revalidate_disk(mddev->gendisk);
+	}
 	if (sectors > mddev->dev_sectors &&
 	    mddev->recovery_cp > oldsize) {
 		mddev->recovery_cp = oldsize;
@@ -4593,8 +4595,10 @@ static void raid10_finish_reshape(struct mddev *mddev)
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		}
 		mddev->resync_max_sectors = size;
-		set_capacity(mddev->gendisk, mddev->array_sectors);
-		revalidate_disk(mddev->gendisk);
+		if (mddev->queue) {
+			set_capacity(mddev->gendisk, mddev->array_sectors);
+			revalidate_disk(mddev->gendisk);
+		}
 	} else {
 		int d;
 		for (d = conf->geo.raid_disks ;
-- 
2.5.5

