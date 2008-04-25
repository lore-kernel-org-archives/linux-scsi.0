From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/6] block: no need to initialize rq->cmd with blk_get_request
Date: Sat, 26 Apr 2008 01:23:15 +0900
Message-ID: <1209140607-28654-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1209140607-28654-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1209140607-28654-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:39441 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761745AbYDYQas (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 12:30:48 -0400
In-Reply-To: <1209140607-28654-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org, bharrosh@panasas.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, dm-devel@redhat.com

blk_get_request initializes rq->cmd (rq_init does) so the users don't
need to do that.

The purpose of this patch is to remove sizeof(rq->cmd) and &rq->cmd,
as a preparation for large command support, which changes rq->cmd from
the static array to a pointer. sizeof(rq->cmd) will not make sense and
&rq->cmd won't work.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/scsi_ioctl.c          |    3 ---
 drivers/block/pktcdvd.c     |    2 --
 drivers/cdrom/cdrom.c       |    1 -
 drivers/md/dm-emc.c         |    2 --
 drivers/md/dm-mpath-hp-sw.c |    1 -
 drivers/md/dm-mpath-rdac.c  |    1 -
 6 files changed, 0 insertions(+), 10 deletions(-)

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
-- 
1.5.4.2

