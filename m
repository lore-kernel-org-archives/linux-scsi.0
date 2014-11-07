From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
Date: Thu, 06 Nov 2014 20:56:14 -0500
Message-ID: <yq1zjc3ai4h.fsf@sermon.lab.mkp.net>
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>
	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>
	<yq1fvdwb3lq.fsf@sermon.lab.mkp.net> <545BC88A.7060706@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <545BC88A.7060706@windriver.com> (Chris Friesen's message of
	"Thu, 6 Nov 2014 13:14:18 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Friesen <chris.friesen@windriver.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Chris" == Chris Friesen <chris.friesen@windriver.com> writes:

Chris,

Chris> For a RAID card I expect it would be related to chunk size or
Chris> stripe width or something...but even then I would expect to be
Chris> able to cap it at 100MB or so.  Or are there storage systems on
Chris> really fast interfaces that could legitimately want a hundred meg
Chris> of data at a time?

Well, there are several devices that report their capacity to indicate
that they don't suffer any performance (RMW) penalties for large
commands regardless of size. I would personally prefer them to report 0
in that case.

Chris> Yep, in all three wonky cases so far "optimal_io_size" ended up
Chris> as 4294966784, which is 0xfffffe00.  Does something mask out the
Chris> lower bits?

Ignoring reported values of UINT_MAX and 0xfffffe000 only works until
the next spec-dyslexic firmware writer comes along.

I also think that singling out the OPTIMAL TRANSFER LENGTH is a bit of a
red herring. A vendor could mess up any value in that VPD and it would
still cause us grief. There's no rational explanation for why OTL would
be more prone to being filled out incorrectly than any of the other
parameters in that page.

I do concur, though, that io_opt is problematic by virtue of being
32-bits and that gets multiplied by the sector size. So things can
easily get out of whack for fdisk and friends (by comparison the value
that we use for io_min is only 16 bits).

I'm still partial to just blacklisting that entire Seagate family. We
don't have any details on the alleged SSD having the same problem. For
all we know it could be the same SAS disk drive and not an SSD at all.

If there are compelling arguments or other supporting data for sanity
checking OTL I'd suggest the following patch that caps it at 1GB. I know
of a few devices that prefer alignment at that granularity.

-- 
Martin K. Petersen	Oracle Linux Engineering

commit 87c0103ea3f96615b8a9816b8aee8a7ccdf55d50
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Thu Nov 6 12:31:43 2014 -0500

    [SCSI] sd: Sanity check the optimal I/O size
    
    We have come across a couple of devices that report crackpot values in
    the optimal I/O size in the Block Limits VPD page. Since this is a
    32-bit entity that gets multiplied by the logical block size we can get
    disproportionately large values reported to the block layer.
    
    Cap io_opt at 1 GB.
    
    Reported-by: Chris Friesen <chris.friesen@windriver.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
    Cc: stable@vger.kernel.org

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b041eca8955d..806e06c2575f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2591,7 +2591,8 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	blk_queue_io_min(sdkp->disk->queue,
 			 get_unaligned_be16(&buffer[6]) * sector_sz);
 	blk_queue_io_opt(sdkp->disk->queue,
-			 get_unaligned_be32(&buffer[12]) * sector_sz);
+			 min_t(unsigned int, SD_MAX_IO_OPT_BYTES,
+			       get_unaligned_be32(&buffer[12]) * sector_sz));
 
 	if (buffer[3] == 0x3c) {
 		unsigned int lba_count, desc_count;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 63ba5ca7f9a1..3492779d9d3e 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -44,10 +44,11 @@ enum {
 };
 
 enum {
-	SD_DEF_XFER_BLOCKS = 0xffff,
-	SD_MAX_XFER_BLOCKS = 0xffffffff,
-	SD_MAX_WS10_BLOCKS = 0xffff,
-	SD_MAX_WS16_BLOCKS = 0x7fffff,
+	SD_DEF_XFER_BLOCKS	= 0xffff,
+	SD_MAX_XFER_BLOCKS	= 0xffffffff,
+	SD_MAX_WS10_BLOCKS	= 0xffff,
+	SD_MAX_WS16_BLOCKS	= 0x7fffff,
+	SD_MAX_IO_OPT_BYTES	= 1024 * 1024 * 1024,
 };
 
 enum {
