From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
Date: Fri, 09 Jul 2010 12:27:07 -0400
Message-ID: <yq1eifc1uzo.fsf@sermon.lab.mkp.net>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
	<20100706213136.GA21246@redhat.com> <4C33BEDF.7050602@interlog.com>
	<20100707004748.GA3068@redhat.com>
	<yq1ocek6pf4.fsf@sermon.lab.mkp.net> <4C33F619.4010302@interlog.com>
	<20100708191146.GA1538@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:58357 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab0GIQ1r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2010 12:27:47 -0400
In-Reply-To: <20100708191146.GA1538@redhat.com> (Mike Snitzer's message of
	"Thu, 8 Jul 2010 15:11:46 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, axboe@kernel.dk

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Turns out that this LUN has a 4K granularity requirement (will
Mike> fail the WRITE SAME if the granularity requirements are not met).

That's lame.  The devices I've been working with just ignore the
portions of the block range that are not aligned / do not constitute
entire blocks.

I've had the following patch kicking around in my tree for a while.  It
does not yet handle offset discard alignment, though.

-- 
Martin K. Petersen	Oracle Linux Engineering

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2e9c6bd..60632ed 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -420,12 +420,22 @@ static int sd_prepare_discard(struct request *rq)
 {
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	struct bio *bio = rq->bio;
-	sector_t sector = bio->bi_sector;
-	unsigned int num = bio_sectors(bio);
+	sector_t lba;
+	unsigned int xfer_length, logical_block_shift;
+	unsigned int discard_shift, discard_mask;
+
+	logical_block_shift = blksize_bits(sdkp->device->sector_size) - 9;
+	lba = bio->bi_sector >> logical_block_shift;
+	xfer_length = bio_sectors(bio) >> logical_block_shift;
+
+	discard_shift = blksize_bits(rq->q->limits.discard_granularity) - 9;
+
+	if (discard_shift) {
+		discard_mask = (1 << discard_shift) - 1;
+		sector_t end_lba = (lba + xfer_length) & ~discard_mask;
 
-	if (sdkp->device->sector_size == 4096) {
-		sector >>= 3;
-		num >>= 3;
+		lba = (lba + discard_mask) & ~discard_mask;
+		xfer_length = end_lba - lba;
 	}
 
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
@@ -445,15 +455,15 @@ static int sd_prepare_discard(struct request *rq)
 
 		put_unaligned_be16(6 + 16, &buf[0]);
 		put_unaligned_be16(16, &buf[2]);
-		put_unaligned_be64(sector, &buf[8]);
-		put_unaligned_be32(num, &buf[16]);
+		put_unaligned_be64(lba, &buf[8]);
+		put_unaligned_be32(xfer_length, &buf[16]);
 
 		kunmap_atomic(buf, KM_USER0);
 	} else {
 		rq->cmd[0] = WRITE_SAME_16;
 		rq->cmd[1] = 0x8; /* UNMAP */
-		put_unaligned_be64(sector, &rq->cmd[2]);
-		put_unaligned_be32(num, &rq->cmd[10]);
+		put_unaligned_be64(lba, &rq->cmd[2]);
+		put_unaligned_be32(xfer_length, &rq->cmd[10]);
 		rq->cmd_len = 16;
 	}
 
