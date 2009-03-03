From: Matthew Wilcox <matthew@wil.cx>
Subject: Getting TRIM working
Date: Tue, 3 Mar 2009 12:07:00 -0700
Message-ID: <20090303190700.GD20511@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51658 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbZCCTHC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2009 14:07:02 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org


I'm having trouble getting Linux to spit out an appropriate TRIM
command, and I've hit a bit of a wall, so I thought I'd appeal for help.

The symptom is that we send out only 24 bytes and then stop rather than
sending out a full 512 byte "sector".

Here's what goes on, as far as I understand it.

We call 'blkdiscard /dev/sda 0 1' which is supposed to TRIM just LBA 0.

We create a bio in blk_ioctl_discard() which sets bi_size to 512 (1 << 9).
This is necessary to let the elevators know how many bytes we're going
to discard, so it can do merging correctly.

Then, in sd_discard_fn(), we do this:

        bio->bi_size = 0;
        if (bio_add_pc_page(q, bio, page, 24, 0) < 24) {
                __free_page(page);
                return -ENOMEM;
        }

This is where the 24 comes from -- it's the length of the data transmitted
to the drive for an unmap of a single range.

Now in ata_scsi_unmap_xlat() we need to turn this SCSI UNMAP command
into an ATA TRIM command.  So I do this:

        size = ALIGN(i * 8, 512);
        memset(buffer + i * 8, 0, size - i * 8);
        old_size = bio_iovec(bio)->bv_len;
printk("before: bi_size %d, data_len %d, bv_len %d\n", bio->bi_size,
                req->data_len, old_size);
        if (size > old_size) {
                bio_add_pc_page(req->q, bio, bio_page(bio),
                                        size - old_size, old_size);
                req->data_len = size;
        }
printk("after: bi_size %d, data_len %d, bv_len %d\n", bio->bi_size,
                req->data_len, bio_iovec(bio)->bv_len);

Now req->data_len, bio->bi_size and bio_iovec(bio)->bv_len are all 512.
Yet the AHCI driver still spits out 24 bytes and then stops (which hangs
the drive).  What am I missing?

The current git tree can be found at
http://git.kernel.org/?p=linux/kernel/git/willy/ssd.git;a=shortlog;h=trim-20090212

I tried a few things yesterday with access to the ATA bus analyser,
and the results of that are not found in the git tree.  This patch on
top of that git tree makes things better (before yesterday, I didn't
know about bv_len, for example):

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 591d7a1..dea97e6 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1714,9 +1714,10 @@ nothing_to_do:
 static unsigned int ata_scsi_unmap_xlat(struct ata_queued_cmd *qc)
 {
 	struct request *req = qc->scsicmd->request;
-	char *buffer = bio_data(req->bio);
+	struct bio *bio = req->bio;
+	char *buffer = bio_data(bio);
 	struct ata_taskfile *tf = &qc->tf;
-	unsigned size, i = 0;
+	unsigned old_size, size, i = 0;
 
 	/*
 	 * Ignore what SCSI has written to the buffer.  Will make it easier
@@ -1727,6 +1728,16 @@ static unsigned int ata_scsi_unmap_xlat(struct ata_queued_cmd *qc)
 					req->sector, req->nr_sectors);
 	size = ALIGN(i * 8, 512);
 	memset(buffer + i * 8, 0, size - i * 8);
+	old_size = bio_iovec(bio)->bv_len;
+printk("before: bi_size %d, data_len %d, bv_len %d\n", bio->bi_size,
+		req->data_len, old_size);
+	if (size > old_size) {
+		bio_add_pc_page(req->q, bio, bio_page(bio),
+					size - old_size, old_size);
+		req->data_len = size;
+	}
+printk("after: bi_size %d, data_len %d, bv_len %d\n", bio->bi_size,
+		req->data_len, bio_iovec(bio)->bv_len);
 
 	qc->flags |= ATA_QCFLAG_IO;
 	qc->nbytes = size;
@@ -1741,8 +1752,6 @@ static unsigned int ata_scsi_unmap_xlat(struct ata_queued_cmd *qc)
 			ATA_TFLAG_LBA48 | ATA_TFLAG_LBA;
 	tf->device = ATA_LBA;
 
-	req->bio->bi_size = req->data_len = size;
-
 	return 0;
 }
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d7539d5..2d5fbd1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -375,11 +375,22 @@ static int sd_discard_fn(struct request_queue *q, struct request *rq,
 	struct page *page = alloc_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
+
+	/*
+	 * Earlier, we set bi_size to the number of bytes to be discarded so
+	 * that the elevators understood what was going on.  The bi_size
+	 * has been copied to req->data_len so we don't need to be
+	 * concerned with that any more.  Zero it out so it accurately
+	 * reflects the length of the data we're now sending to the drive.
+	 */
+	bio->bi_size = 0;
 	if (bio_add_pc_page(q, bio, page, 24, 0) < 24) {
 		__free_page(page);
 		return -ENOMEM;
 	}
 
+printk("bio->bi_size = %d\n", bio->bi_size);
+
 	unmap = bio_data(bio);
 	memset(unmap, 0, 12);
 	put_unaligned_be64(bio->bi_sector, unmap + 12);

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
