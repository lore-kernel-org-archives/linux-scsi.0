From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 6/6] scsi_debug: fix logical block provisioning support
Date: Tue, 16 Apr 2013 22:12:00 +0900
Message-ID: <1366117920-11740-7-git-send-email-akinobu.mita@gmail.com>
References: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f51.google.com ([209.85.210.51]:44383 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934807Ab3DPNMf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 09:12:35 -0400
Received: by mail-da0-f51.google.com with SMTP id g27so246018dan.24
        for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2013 06:12:34 -0700 (PDT)
In-Reply-To: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

I tried testing the logical block provisioning support in scsi_debug,
but it didn't work as I expected.

For example, load scsi_debug module with UNMAP command supported
and fill the storage with random data.

        # modprobe scsi_debug lbpu=1
        # dd if=/dev/urandom of=/dev/sdb

Then, try to unmap LBA 0, but Get LBA status reports:

        # sg_unmap --lba=0 --num=1 /dev/sdb
        # sg_get_lba_status --lba=0 /dev/sdb
        descriptor LBA: 0x0000000000000000  blocks: 16384  mapped

This is unexpected result.  Because UNMAP command to LBA 0 finished
without any errors, but Get LBA status shows that LBA 0 is still mapped.

This problem is due to the wrong translation between LBA and index of
provisioning map.  Fix it by using correct translation functions added
previously.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 55 ++++++++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6581549..154d987 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2016,22 +2016,20 @@ static sector_t map_index_to_lba(unsigned long index)
 
 static unsigned int map_state(sector_t lba, unsigned int *num)
 {
-	unsigned int granularity, alignment, mapped;
-	sector_t block, next, end;
+	sector_t end;
+	unsigned int mapped;
+	unsigned long index;
+	unsigned long next;
 
-	granularity = scsi_debug_unmap_granularity;
-	alignment = granularity - scsi_debug_unmap_alignment;
-	block = lba + alignment;
-	do_div(block, granularity);
-
-	mapped = test_bit(block, map_storep);
+	index = lba_to_map_index(lba);
+	mapped = test_bit(index, map_storep);
 
 	if (mapped)
-		next = find_next_zero_bit(map_storep, map_size, block);
+		next = find_next_zero_bit(map_storep, map_size, index);
 	else
-		next = find_next_bit(map_storep, map_size, block);
+		next = find_next_bit(map_storep, map_size, index);
 
-	end = next * granularity - scsi_debug_unmap_alignment;
+	end = min_t(sector_t, sdebug_store_sectors,  map_index_to_lba(next));
 	*num = end - lba;
 
 	return mapped;
@@ -2039,48 +2037,37 @@ static unsigned int map_state(sector_t lba, unsigned int *num)
 
 static void map_region(sector_t lba, unsigned int len)
 {
-	unsigned int granularity, alignment;
 	sector_t end = lba + len;
 
-	granularity = scsi_debug_unmap_granularity;
-	alignment = granularity - scsi_debug_unmap_alignment;
-
 	while (lba < end) {
-		sector_t block, rem;
-
-		block = lba + alignment;
-		rem = do_div(block, granularity);
+		unsigned long index = lba_to_map_index(lba);
 
-		if (block < map_size)
-			set_bit(block, map_storep);
+		if (index < map_size)
+			set_bit(index, map_storep);
 
-		lba += granularity - rem;
+		lba = map_index_to_lba(index + 1);
 	}
 }
 
 static void unmap_region(sector_t lba, unsigned int len)
 {
-	unsigned int granularity, alignment;
 	sector_t end = lba + len;
 
-	granularity = scsi_debug_unmap_granularity;
-	alignment = granularity - scsi_debug_unmap_alignment;
-
 	while (lba < end) {
-		sector_t block, rem;
-
-		block = lba + alignment;
-		rem = do_div(block, granularity);
+		unsigned long index = lba_to_map_index(lba);
 
-		if (rem == 0 && lba + granularity < end && block < map_size) {
-			clear_bit(block, map_storep);
-			if (scsi_debug_lbprz)
+		if (lba == map_index_to_lba(index) &&
+		    lba + scsi_debug_unmap_granularity <= end &&
+		    index < map_size) {
+			clear_bit(index, map_storep);
+			if (scsi_debug_lbprz) {
 				memset(fake_storep +
 				       lba * scsi_debug_sector_size, 0,
 				       scsi_debug_sector_size *
 				       scsi_debug_unmap_granularity);
+			}
 		}
-		lba += granularity - rem;
+		lba = map_index_to_lba(index + 1);
 	}
 }
 
-- 
1.8.1.4

