From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Getting TRIM working
Date: Mon, 9 Mar 2009 02:36:14 -0600
Message-ID: <20090309083614.GP25995@parisc-linux.org>
References: <20090303190700.GD20511@parisc-linux.org> <49AE47DB.4030200@panasas.com> <20090306191620.GA25995@parisc-linux.org> <49B39DCB.3040203@panasas.com> <1236547480.4861.12.camel@localhost.localdomain> <1236547956.4861.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54019 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZCIIgc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2009 04:36:32 -0400
Content-Disposition: inline
In-Reply-To: <1236547956.4861.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jeff Garzik <jeff@garzik.org>

On Sun, Mar 08, 2009 at 04:32:36PM -0500, James Bottomley wrote:
> Actually, found the reason, blk_rq_map_kern will blast the original bio
> from the request.  You could fix this by chaining it back again at the
> beginning.  If that works, we could just wrap it into a block API to
> prevent users from having to muck with bios.

How about constructing the TRIM entirely within libata?  I won't be able
to test this patch until Oregon wakes up, but is this acceptable?

Advantages:
 - Don't need to wait for T10 to finish designing UNMAP
 - Uses well-tested ATA_16 passthrough layer
 - Changing the UNMAP implementation to do multiple ranges won't break TRIM
 - Will be easier to adapt to a future separation of scsi and libata

Disadvantages:
 - UNMAP gets less testing

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9747fa..edcf9db 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1029,6 +1029,55 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	desc[11] = block;
 }
 
+static int ata_discard_fn(struct request_queue *q, struct request *req,
+							struct bio *bio)
+{
+	char *trim;
+	unsigned i, size;
+	struct page *page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+	/*
+	 * Earlier, we set bi_size to the number of bytes to be discarded so
+	 * that the elevators understood what was going on.  The bi_size
+	 * has been copied to req->data_len so we don't need to be
+	 * concerned with that any more.  Zero it out so it accurately
+	 * reflects the length of the data we're now sending to the drive.
+	 */
+	bio->bi_size = 0;
+
+	trim = bio_data(bio);
+	i = ata_set_lba_range_entries(trim, PAGE_SIZE / 8,
+					bio->bi_sector, bio_sectors(bio));
+	size = ALIGN(i * 8, 512);
+	memset(trim + i * 8, 0, size - i * 8);
+	if (bio_add_pc_page(q, bio, page, size, 0) < size) {
+		__free_page(page);
+		return -ENOMEM;
+	}
+
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_len = 16;
+	req->cmd[0] = ATA_16;
+	req->cmd[1] = (ATA_PROT_DMA << 1) | 1;	/* 48-bit, protocol */
+	req->cmd[2] = 0x6;			/* length, direction */
+	req->cmd[3] = 0;			/* feature high */
+	req->cmd[4] = ATA_DSM_TRIM;		/* feature low */
+	req->cmd[5] = (size / 512) >> 8;	/* nsect high */
+	req->cmd[6] = size / 512;		/* nsect low */
+	req->cmd[7] = 0;			/* lba */
+	req->cmd[8] = 0;			/* lba */
+	req->cmd[9] = 0;			/* lba */
+	req->cmd[10] = 0;			/* lba */
+	req->cmd[11] = 0;			/* lba */
+	req->cmd[12] = 0;			/* lba */
+	req->cmd[13] = ATA_LBA;			/* device */
+	req->cmd[14] = ATA_CMD_DSM;		/* command */
+	req->cmd[15] = 0;			/* control */
+
+	return 0;
+}
+
 static void ata_scsi_sdev_config(struct scsi_device *sdev)
 {
 	sdev->use_10_for_rw = 1;
@@ -1077,6 +1126,9 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
 
+	if (ata_id_has_trim(dev->id))
+		blk_queue_set_discard(sdev->request_queue, ata_discard_fn);
+
 	if (dev->class == ATA_DEV_ATAPI) {
 		struct request_queue *q = sdev->request_queue;
 		void *buf;
@@ -2385,6 +2437,9 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 		/* sector size */
 		rbuf[10] = ATA_SECT_SIZE >> 8;
 		rbuf[11] = ATA_SECT_SIZE & 0xff;
+
+		if (ata_id_has_trim(args->id))
+			rbuf[14] = 0x80;
 	}
 
 	return 0;

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
