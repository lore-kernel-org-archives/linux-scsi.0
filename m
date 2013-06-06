From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/3] scsi_debug: fix do_device_access() with wrap around range
Date: Thu,  6 Jun 2013 21:52:58 +0900
Message-ID: <1370523178-5437-4-git-send-email-akinobu.mita@gmail.com>
References: <1370523178-5437-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:64967 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121Ab3FFMxb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jun 2013 08:53:31 -0400
In-Reply-To: <1370523178-5437-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

do_device_access() is a function that abstracts copying SG list from/to
ramdisk storage (fake_storep).

It must deal with the ranges exceeding actual fake_storep size, because
such ranges are valid if virtual_gb is set greater than zero, and they
should be treated as fake_storep is repeatedly mirrored up to virtual size.

Unfortunately, it can't deal with the range which wraps around the end of
fake_storep. A wrap around range is copied by two sg_copy_{from,to}_buffer()
calls, but sg_copy_{from,to}_buffer() can't copy from/to in the middle of
SG list, therefore the second call can't copy correctly.

This fixes it by using sg_pcopy_{from,to}_buffer() that can copy from/to
the middle of SG list.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 21239b3..c1efaf8 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1614,24 +1614,48 @@ static int check_device_access_params(struct sdebug_dev_info *devi,
 	return 0;
 }
 
+/* Returns number of bytes copied or -1 if error. */
 static int do_device_access(struct scsi_cmnd *scmd,
 			    struct sdebug_dev_info *devi,
 			    unsigned long long lba, unsigned int num, int write)
 {
 	int ret;
 	unsigned long long block, rest = 0;
-	int (*func)(struct scsi_cmnd *, unsigned char *, int);
+	struct scsi_data_buffer *sdb;
+	enum dma_data_direction dir;
+	size_t (*func)(struct scatterlist *, unsigned int, void *, size_t,
+		       off_t);
+
+	if (write) {
+		sdb = scsi_out(scmd);
+		dir = DMA_TO_DEVICE;
+		func = sg_pcopy_to_buffer;
+	} else {
+		sdb = scsi_in(scmd);
+		dir = DMA_FROM_DEVICE;
+		func = sg_pcopy_from_buffer;
+	}
 
-	func = write ? fetch_to_dev_buffer : fill_from_dev_buffer;
+	if (!sdb->length)
+		return 0;
+	if (!(scsi_bidi_cmnd(scmd) || scmd->sc_data_direction == dir))
+		return -1;
 
 	block = do_div(lba, sdebug_store_sectors);
 	if (block + num > sdebug_store_sectors)
 		rest = block + num - sdebug_store_sectors;
 
-	ret = func(scmd, fake_storep + (block * scsi_debug_sector_size),
-		   (num - rest) * scsi_debug_sector_size);
-	if (!ret && rest)
-		ret = func(scmd, fake_storep, rest * scsi_debug_sector_size);
+	ret = func(sdb->table.sgl, sdb->table.nents,
+		   fake_storep + (block * scsi_debug_sector_size),
+		   (num - rest) * scsi_debug_sector_size, 0);
+	if (ret != (num - rest) * scsi_debug_sector_size)
+		return ret;
+
+	if (rest) {
+		ret += func(sdb->table.sgl, sdb->table.nents,
+			    fake_storep, rest * scsi_debug_sector_size,
+			    (num - rest) * scsi_debug_sector_size);
+	}
 
 	return ret;
 }
@@ -1888,7 +1912,12 @@ static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
 	read_lock_irqsave(&atomic_rw, iflags);
 	ret = do_device_access(SCpnt, devip, lba, num, 0);
 	read_unlock_irqrestore(&atomic_rw, iflags);
-	return ret;
+	if (ret == -1)
+		return DID_ERROR << 16;
+
+	scsi_in(SCpnt)->resid = scsi_bufflen(SCpnt) - ret;
+
+	return 0;
 }
 
 static void dump_sector(unsigned char *buf, int len)
-- 
1.8.1.4

