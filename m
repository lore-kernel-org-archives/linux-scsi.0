From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/5] block: no need to initialize rq->cmd
Date: Wed, 23 Apr 2008 17:57:39 +0300
Message-ID: <480F4E63.2090604@panasas.com>
References: <480F4CC2.7070804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <480F4CC2.7070804@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Pete Wyckoff <pw@osc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-ide <linux-ide@vger.kernel.org>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
List-Id: linux-scsi@vger.kernel.org


blk_get_request and queue_flush initializes rq->cmd (rq_init does)
so the users don't need to do that.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/scsi_ioctl.c          |    3 ---
 drivers/block/pktcdvd.c     |    2 --
 drivers/block/ps3disk.c     |    1 -
 drivers/cdrom/cdrom.c       |    1 -
 drivers/md/dm-emc.c         |    2 --
 drivers/md/dm-mpath-hp-sw.c |    1 -
 drivers/md/dm-mpath-rdac.c  |    1 -
 drivers/scsi/sd.c           |    1 -
 8 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a2c3a93..ffa3720 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -217,8 +217,6 @@ EXPORT_SYMBOL_GPL(blk_verify_command);
 static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 			     struct sg_io_hdr *hdr, int has_write_perm)
 {
-	memset(rq->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
-
 	if (copy_from_user(rq->cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
 	if (blk_verify_command(rq->cmd, has_write_perm))
@@ -531,7 +529,6 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	rq->data_len = 0;
 	rq->extra_len = 0;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
-	memset(rq->cmd, 0, sizeof(rq->cmd));
 	rq->cmd[0] = cmd;
 	rq->cmd[4] = data;
 	rq->cmd_len = 6;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 18feb1c..3b806c9 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -776,8 +776,6 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 
 	rq->cmd_len = COMMAND_SIZE(cgc->cmd[0]);
 	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
-	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
-		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PACKET_SIZE);
 
 	rq->timeout = 60*HZ;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 7483f94..9c32b75 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -406,7 +406,6 @@ static void ps3disk_prepare_flush(struct request_queue *q, struct request *req)
 
 	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
 
-	memset(req->cmd, 0, sizeof(req->cmd));
 	req->cmd_type = REQ_TYPE_FLUSH;
 }
 
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index ac38290..69f26eb 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2194,7 +2194,6 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 		if (ret)
 			break;
 
-		memset(rq->cmd, 0, sizeof(rq->cmd));
 		rq->cmd[0] = GPCMD_READ_CD;
 		rq->cmd[1] = 1 << 2;
 		rq->cmd[2] = (lba >> 24) & 0xff;
diff --git a/drivers/md/dm-emc.c b/drivers/md/dm-emc.c
index 6b91b9a..3ea5ad4 100644
--- a/drivers/md/dm-emc.c
+++ b/drivers/md/dm-emc.c
@@ -110,8 +110,6 @@ static struct request *get_failover_req(struct emc_handler *h,
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = 0;
 
-	memset(&rq->cmd, 0, BLK_MAX_CDB);
-
 	rq->timeout = EMC_FAILOVER_TIMEOUT;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
diff --git a/drivers/md/dm-mpath-hp-sw.c b/drivers/md/dm-mpath-hp-sw.c
index 204bf42..b63a0ab 100644
--- a/drivers/md/dm-mpath-hp-sw.c
+++ b/drivers/md/dm-mpath-hp-sw.c
@@ -137,7 +137,6 @@ static struct request *hp_sw_get_request(struct dm_path *path)
 	req->sense = h->sense;
 	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
 
-	memset(&req->cmd, 0, BLK_MAX_CDB);
 	req->cmd[0] = START_STOP;
 	req->cmd[4] = 1;
 	req->cmd_len = COMMAND_SIZE(req->cmd[0]);
diff --git a/drivers/md/dm-mpath-rdac.c b/drivers/md/dm-mpath-rdac.c
index e04eb5c..95e7773 100644
--- a/drivers/md/dm-mpath-rdac.c
+++ b/drivers/md/dm-mpath-rdac.c
@@ -284,7 +284,6 @@ static struct request *get_rdac_req(struct rdac_handler *h,
 		return NULL;
 	}
 
- 	memset(&rq->cmd, 0, BLK_MAX_CDB);
 	rq->sense = h->sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = 0;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3cea17d..01cefbb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -860,7 +860,6 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 
 static void sd_prepare_flush(struct request_queue *q, struct request *rq)
 {
-	memset(rq->cmd, 0, sizeof(rq->cmd));
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = SD_TIMEOUT;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
-- 
1.5.3.3

