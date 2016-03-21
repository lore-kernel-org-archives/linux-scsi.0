From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] sd: fixup capacity calculation for 4k drives
Date: Mon, 21 Mar 2016 13:27:29 +0100
Message-ID: <1458563249-91200-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbcCUM1d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2016 08:27:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

in sd_read_capacity() the sdkp->capacity field changes its meaning:
after the call to read_capacity_XX() it carries the _unscaled_ values,
making the comparison between the original value and the new value
always false for drives with a sector size != 512.
So introduce a 'new_capacity' carrying the new, scaled, capacity.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5a5457a..fbb8daa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2312,8 +2312,13 @@ got_data:
 	}
 	blk_queue_logical_block_size(sdp->request_queue, sector_size);
 
+	/*
+	 * Note: up to this point sdkp->capacity carries the
+	 * _unscaled_ capacity (cf the scaling after this block).
+	 */
 	{
 		char cap_str_2[10], cap_str_10[10];
+		size_t new_capacity = sdkp->capacity >> (ilog2(sector_size) - 9);
 
 		string_get_size(sdkp->capacity, sector_size,
 				STRING_UNITS_2, cap_str_2, sizeof(cap_str_2));
@@ -2321,7 +2326,7 @@ got_data:
 				STRING_UNITS_10, cap_str_10,
 				sizeof(cap_str_10));
 
-		if (sdkp->first_scan || old_capacity != sdkp->capacity) {
+		if (sdkp->first_scan || old_capacity != new_capacity) {
 			sd_printk(KERN_NOTICE, sdkp,
 				  "%llu %d-byte logical blocks: (%s/%s)\n",
 				  (unsigned long long)sdkp->capacity,
-- 
1.8.5.6

