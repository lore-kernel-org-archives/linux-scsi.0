From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] block: check for GENHD_FL_UP in del_gendisk()
Date: Tue, 12 Dec 2017 09:57:49 +0100
Message-ID: <1513069072-32514-2-git-send-email-hare@suse.de>
References: <1513069072-32514-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46997 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752155AbdLLI55 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Dec 2017 03:57:57 -0500
In-Reply-To: <1513069072-32514-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

From: Hannes Reinecke <hare@suse.com>

When a device is probed asynchronously del_gendisk() might be called
before the async probing was run, causing del_gendisk() to crash
due to uninitialized sysfs objects.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 block/genhd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index c2223f1..cc40d95 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -697,6 +697,9 @@ void del_gendisk(struct gendisk *disk)
 	struct disk_part_iter piter;
 	struct hd_struct *part;
 
+	if (!(disk->flags & GENHD_FL_UP))
+		return;
+
 	blk_integrity_del(disk);
 	disk_del_events(disk);
 
-- 
1.8.5.6
