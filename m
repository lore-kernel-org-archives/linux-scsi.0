From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/4] scsi_debug: fix WRITE_SAME with virtual_gb > 0
Date: Mon, 15 Jul 2013 20:52:06 +0900
Message-ID: <1373889127-17083-4-git-send-email-akinobu.mita@gmail.com>
References: <1373889127-17083-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37144 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab3GOLxF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 07:53:05 -0400
Received: by mail-pa0-f52.google.com with SMTP id kq13so11042133pab.11
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jul 2013 04:53:04 -0700 (PDT)
In-Reply-To: <1373889127-17083-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

With module parameter virtual_gb > 0, the device accesses may go beyond
the actual ramdisk storage (fake_storep).  Such requests should be
treated as fake_storep is repeatedly mirrored up to virtual size
(virtual_gb * 1GB).

Unfortunately, WRITE_SAME commands with such requests access out of
fake_storep region.  For writing to the first LBA, this fixes it by
switching to use existing do_device_access() which does the correct
conversion of LBA.  For spreading the first LBA over the remaining
blocks, this fixes it by using newly introduced fake_store() for getting
valid address which is corresponding to a given LBA in fake_storep.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 01c0ffa..1e25c1e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -257,7 +257,7 @@ struct sdebug_queued_cmd {
 };
 static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
 
-static unsigned char * fake_storep;	/* ramdisk storage */
+static void *fake_storep;		/* ramdisk storage */
 static struct sd_dif_tuple *dif_storep;	/* protection info */
 static void *map_storep;		/* provisioning map */
 
@@ -293,6 +293,13 @@ static unsigned char ctrl_m_pg[] = {0xa, 10, 2, 0, 0, 0, 0, 0,
 static unsigned char iec_m_pg[] = {0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
 			           0, 0, 0x0, 0x0};
 
+static void *fake_store(unsigned long long lba)
+{
+	lba = do_div(lba, sdebug_store_sectors);
+
+	return fake_storep + lba * scsi_debug_sector_size;
+}
+
 static int sdebug_add_adapter(void);
 static void sdebug_remove_adapter(void);
 
@@ -2131,9 +2138,7 @@ static int resp_write_same(struct scsi_cmnd *scmd, unsigned long long lba,
 	}
 
 	/* Else fetch one logical block */
-	ret = fetch_to_dev_buffer(scmd,
-				  fake_storep + (lba * scsi_debug_sector_size),
-				  scsi_debug_sector_size);
+	ret = do_device_access(scmd, devip, lba, 1, 1);
 
 	if (-1 == ret) {
 		write_unlock_irqrestore(&atomic_rw, iflags);
@@ -2145,8 +2150,7 @@ static int resp_write_same(struct scsi_cmnd *scmd, unsigned long long lba,
 
 	/* Copy first sector to remaining blocks */
 	for (i = 1 ; i < num ; i++)
-		memcpy(fake_storep + ((lba + i) * scsi_debug_sector_size),
-		       fake_storep + (lba * scsi_debug_sector_size),
+		memcpy(fake_store(lba + i), fake_store(lba),
 		       scsi_debug_sector_size);
 
 	if (scsi_debug_lbp())
-- 
1.8.3.1

