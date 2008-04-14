From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/4] block: replace sizeof(rq->cmd) with BLK_MAX_CDB
Date: Mon, 14 Apr 2008 19:50:36 +0900
Message-ID: <1208170266-1676-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <20080414010112W.tomof@acm.org>
 <1208170266-1676-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1208170266-1676-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1208170266-1676-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:33924 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYDNLFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2008 07:05:22 -0400
In-Reply-To: <1208170266-1676-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bharrosh@panasas.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org

This is a preparation for changing rq->cmd from the static array to a
pointer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c             |    4 ++--
 drivers/ide/ide-cd.c         |    4 ++--
 drivers/ide/ide-cd_verbose.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2a438a9..6669238 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -132,7 +132,7 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->errors = 0;
 	rq->ref_count = 1;
 	rq->cmd_len = 0;
-	memset(rq->cmd, 0, sizeof(rq->cmd));
+	memset(rq->cmd, 0, BLK_MAX_CDB);
 	rq->data_len = 0;
 	rq->extra_len = 0;
 	rq->sense_len = 0;
@@ -194,7 +194,7 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
 
 	if (blk_pc_request(rq)) {
 		printk(KERN_INFO "  cdb: ");
-		for (bit = 0; bit < sizeof(rq->cmd); bit++)
+		for (bit = 0; bit < BLK_MAX_CDB; bit++)
 			printk("%02x ", rq->cmd[bit]);
 		printk("\n");
 	}
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index f8cea94..db29bde 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -879,7 +879,7 @@ static ide_startstop_t cdrom_start_seek_continuation (ide_drive_t *drive)
 
 	sector_div(frame, queue_hardsect_size(drive->queue) >> SECTOR_BITS);
 
-	memset(rq->cmd, 0, sizeof(rq->cmd));
+	memset(rq->cmd, 0, BLK_MAX_CDB);
 	rq->cmd[0] = GPCMD_SEEK;
 	put_unaligned(cpu_to_be32(frame), (unsigned int *) &rq->cmd[2]);
 
@@ -1812,7 +1812,7 @@ static int ide_cdrom_prep_fs(struct request_queue *q, struct request *rq)
 	long block = (long)rq->hard_sector / (hard_sect >> 9);
 	unsigned long blocks = rq->hard_nr_sectors / (hard_sect >> 9);
 
-	memset(rq->cmd, 0, sizeof(rq->cmd));
+	memset(rq->cmd, 0, BLK_MAX_CDB);
 
 	if (rq_data_dir(rq) == READ)
 		rq->cmd[0] = GPCMD_READ_10;
diff --git a/drivers/ide/ide-cd_verbose.c b/drivers/ide/ide-cd_verbose.c
index 6ed7ca0..6490a2d 100644
--- a/drivers/ide/ide-cd_verbose.c
+++ b/drivers/ide/ide-cd_verbose.c
@@ -326,7 +326,7 @@ void ide_cd_log_error(const char *name, struct request *failed_command,
 
 		printk(KERN_ERR "  The failed \"%s\" packet command "
 				"was: \n  \"", s);
-		for (i = 0; i < sizeof(failed_command->cmd); i++)
+		for (i = 0; i < BLK_MAX_CDB; i++)
 			printk(KERN_CONT "%02x ", failed_command->cmd[i]);
 		printk(KERN_CONT "\"\n");
 	}
-- 
1.5.4.2

