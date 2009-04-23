From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2 of 8] block: Export I/O topology for block devices and  partitions
Date: Thu, 23 Apr 2009 07:22:37 -0600
Message-ID: <20090423132237.GM1926@parisc-linux.org>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <cbdae69a14895dab8ba7.1240464569@sermon.lab.mkp.net> <20090423105145.GW4593@kernel.dk> <20090423114959.GL1926@parisc-linux.org> <20090423115508.GE4593@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45702 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbZDWNWk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2009 09:22:40 -0400
Content-Disposition: inline
In-Reply-To: <20090423115508.GE4593@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Apr 23, 2009 at 01:55:09PM +0200, Jens Axboe wrote:
> On Thu, Apr 23 2009, Matthew Wilcox wrote:
> > ATA reports this in the INQUIRY data.  SCSI reports it in READ CAPACITY 16.
> 
> OK, I wasn't aware of that. That's a relief!

Here's a patch to translate ATA to SCSI (extracted from the 4k work I
did last year).  Jeff, could you apply this?

--- 

libata: Report number of logical sectors per physical sector

Translate the information from IDENTIFY DEVICE into SCSI's READ CAPACITY 16.
Note that ATA reports the offset of the first sector from the alignment
whereas SCSI reports the first aligned sector.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2733b0c..e8a83d9 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2376,10 +2374,25 @@ saving_not_supp:
  */
 static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 {
-	u64 last_lba = args->dev->n_sectors - 1; /* LBA of the last block */
+	struct ata_device *dev = args->dev;
+	u64 last_lba = dev->n_sectors - 1; /* LBA of the last block */
+	u8 log_per_phys = 0;
+	u16 lowest_aligned = 0;
+	u16 word_106 = dev->id[106];
 
 	VPRINTK("ENTER\n");
 
+	if ((word_106 & 0xc000) == 0x4000) {
+		/* Number and offset of logical sectors per physical sector */
+		if (word_106 & (1 << 13))
+			log_per_phys = word_106 & 0xf;
+		if ((dev->id[209] & 0xc000) == 0x4000) {
+			u16 first = dev->id[209] & 0x3fff;
+			if (first > 0)
+				lowest_aligned = (1 << log_per_phys) - first;
+		}
+	}
+
 	if (args->cmd->cmnd[0] == READ_CAPACITY) {
 		if (last_lba >= 0xffffffffULL)
 			last_lba = 0xffffffff;
@@ -2407,6 +2420,11 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 		/* sector size */
 		rbuf[10] = ATA_SECT_SIZE >> 8;
 		rbuf[11] = ATA_SECT_SIZE & 0xff;
+
+		rbuf[12] = 0;
+		rbuf[13] = log_per_phys;
+		rbuf[14] = lowest_aligned >> 8;
+		rbuf[15] = lowest_aligned;
 	}
 
 	return 0;

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
