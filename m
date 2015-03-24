From: Fam Zheng <famz@redhat.com>
Subject: [PATCH 1/3] block: Return error in rescan_partitions if revalidating disk failed
Date: Tue, 24 Mar 2015 18:16:13 +0800
Message-ID: <1427192175-23802-2-git-send-email-famz@redhat.com>
References: <1427192175-23802-1-git-send-email-famz@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbbCXKQa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Mar 2015 06:16:30 -0400
In-Reply-To: <1427192175-23802-1-git-send-email-famz@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, famz@redhat.com

If the disk can't read capacity, we should return an error.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 block/partition-generic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index 0d9e5f9..1e60d7d 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -427,11 +427,11 @@ rescan:
 		return res;
 
 	if (disk->fops->revalidate_disk)
-		disk->fops->revalidate_disk(disk);
+		res = disk->fops->revalidate_disk(disk);
 	check_disk_size_change(disk, bdev);
 	bdev->bd_invalidated = 0;
-	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
-		return 0;
+	if (res || !get_capacity(disk) || !(state = check_partition(disk, bdev)))
+		return res;
 	if (IS_ERR(state)) {
 		/*
 		 * I/O error reading the partition table.  If any
-- 
1.9.3

