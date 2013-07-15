From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 4/4] scsi_debug: fix out of range access by Get_LBA_status with virtual_gb > 0
Date: Mon, 15 Jul 2013 20:52:07 +0900
Message-ID: <1373889127-17083-5-git-send-email-akinobu.mita@gmail.com>
References: <1373889127-17083-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43890 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab3GOLxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 07:53:07 -0400
Received: by mail-pd0-f169.google.com with SMTP id y10so10720963pdj.14
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jul 2013 04:53:06 -0700 (PDT)
In-Reply-To: <1373889127-17083-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

With logical block provisioning support enabled, the provisioning map
(map_storep) keeps track of the provisioning status (mapped or unmapped)
for actual ramdisk storage range (fake_storep).  The provisioning status
for out of fake_storep range with module parameter virtual_gb > 0 is
not tracked, and it should be assumed always mapped.  It is reasonable,
because Unmap commands for such virtual range are always ignored.

Unfortunately, Get_LBA_status command for virtual range accesses out of
map_storep range.  This fixes invalid access and makes it return correct
provisioning status.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1e25c1e..c519c9f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2014,6 +2014,7 @@ static sector_t map_index_to_lba(unsigned long index)
 	return lba;
 }
 
+/* LBA from sdebug_store_sectors to sdebug_capacity is assumed mapped */
 static unsigned int map_state(sector_t lba, unsigned int *num)
 {
 	sector_t end;
@@ -2022,6 +2023,10 @@ static unsigned int map_state(sector_t lba, unsigned int *num)
 	unsigned long next;
 
 	index = lba_to_map_index(lba);
+	if (index >= map_size) {
+		*num = sdebug_capacity - lba;
+		return 1;
+	}
 	mapped = test_bit(index, map_storep);
 
 	if (mapped)
@@ -2029,7 +2034,11 @@ static unsigned int map_state(sector_t lba, unsigned int *num)
 	else
 		next = find_next_bit(map_storep, map_size, index);
 
-	end = min_t(sector_t, sdebug_store_sectors,  map_index_to_lba(next));
+	if (next >= map_size)
+		end = mapped ? sdebug_capacity : sdebug_store_sectors;
+	else
+		end = map_index_to_lba(next);
+
 	*num = end - lba;
 
 	return mapped;
-- 
1.8.3.1

