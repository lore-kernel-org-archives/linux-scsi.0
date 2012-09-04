From: Aaron Lu <aaron.lwe@gmail.com>
Subject: [PATCH v6 2/7] block: genhd: export disk_(un)block_events
Date: Tue,  4 Sep 2012 22:24:35 +0800
Message-ID: <1346768680-7287-3-git-send-email-aaron.lwe@gmail.com>
References: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62706 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab2IDOZa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2012 10:25:30 -0400
In-Reply-To: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>, Aaron Lu <aaron.lwe@gmail.com>

From: Aaron Lu <aaron.lu@intel.com>

When ODD is runtime powered off, there is no meaning to check events for
it, so disk_(un)block_events will be called in its suspend/resume
callback.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 block/genhd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index cac7366..f630150 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1468,6 +1468,7 @@ void disk_block_events(struct gendisk *disk)
 
 	mutex_unlock(&ev->block_mutex);
 }
+EXPORT_SYMBOL(disk_block_events);
 
 static void __disk_unblock_events(struct gendisk *disk, bool check_now)
 {
@@ -1512,6 +1513,7 @@ void disk_unblock_events(struct gendisk *disk)
 	if (disk->ev)
 		__disk_unblock_events(disk, false);
 }
+EXPORT_SYMBOL(disk_unblock_events);
 
 /**
  * disk_flush_events - schedule immediate event checking and flushing
-- 
1.7.11.3

