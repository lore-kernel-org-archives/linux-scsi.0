From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: 09 Jun 2004 17:30:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086823857.5997.124.camel@patibmrh9>
References: <1086710016.3647.4.camel@patibmrh9><20040609080013.GS13836@suse
	.de>  <20040609082045.GT13836@suse.de><1086798154.7074.24.camel@patibmrh9>
	 <1086805796.3741.5.camel@patibmrh9><1086807083.3741.21.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:4835 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265996AbUFIXbJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jun 2004 19:31:09 -0400
In-Reply-To: <1086807083.3741.21.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Jens A:

> > a) ...
> > ...
> > e) ...
> ...
> f) issue some command that transfers data as well.

I tried an op x12 (18) Inquiry for up to x24 (36) bytes.

I got back zeroes even when I memset my data originally to equal
catenated copies of "\xAE" (174).

Under such provocations, dmesg then consistently reports:

hdd: The disk reports a capacity of 250640384 bytes, but the drive only handles 250609664
hdd: unknown partition table
hdd: leftover data in idefloppy_input_buffers, bcount == 36

Also I saw:

$ sudo /sbin/hdparm /dev/hdd
 
/dev/hdd:
 HDIO_GET_MULTCOUNT failed: Invalid argument
 IO_support   =  0 (default 16-bit)
 unmaskirq    =  0 (off)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 readonly     =  0 (off)
 readahead    = 256 (on)
 geometry     = 239/64/32, sectors = 489472, start = 0
$

Also the open-ioctl-close spins up the disk, despite O_NONBLOCK.

> if you use the 2nd patch I posted.

I tried the only patch I have yet found.  It applied clean.  Below I
quote the resulting diff.

Pat LaVarre

diff -urp linux-2.6.7-rc3/drivers/ide/ide-floppy.c linux-2.6.7-rc3-pel/drivers/ide/ide-floppy.c
--- linux-2.6.7-rc3/drivers/ide/ide-floppy.c	2004-06-09 11:01:25.000000000 -0600
+++ linux-2.6.7-rc3-pel/drivers/ide/ide-floppy.c	2004-06-09 12:04:24.000000000 -0600
@@ -1210,19 +1210,23 @@ static void idefloppy_create_rw_cmd (ide
 	set_bit(PC_DMA_RECOMMENDED, &pc->flags);
 }
 
-static int
+static void
 idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct request *rq)
 {
-	/*
-	 * just support eject for now, it would not be hard to make the
-	 * REQ_BLOCK_PC support fully-featured
-	 */
-	if (rq->cmd[0] != IDEFLOPPY_START_STOP_CMD)
-		return 1;
-
 	idefloppy_init_pc(pc);
+	pc->callback = &idefloppy_rw_callback;
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
-	return 0;
+	pc->rq = rq;
+	pc->b_count = rq->data_len;
+	if (rq_data_dir(rq) == WRITE)
+		set_bit(PC_WRITING, &pc->flags);
+	pc->buffer = NULL;
+	/*
+	 * possibly problematic, doesn't look like ide-floppy correctly
+	 * handled scattered requests if dma fails...
+	 */
+	pc->request_transfer = pc->buffer_size = rq->data_len;
+	set_bit(PC_DMA_RECOMMENDED, &pc->flags);
 }
 
 /*
@@ -1267,10 +1271,7 @@ static ide_startstop_t idefloppy_do_requ
 		pc = (idefloppy_pc_t *) rq->buffer;
 	} else if (rq->flags & REQ_BLOCK_PC) {
 		pc = idefloppy_next_pc_storage(drive);
-		if (idefloppy_blockpc_cmd(floppy, pc, rq)) {
-			idefloppy_do_end_request(drive, 0, 0);
-			return ide_stopped;
-		}
+		idefloppy_blockpc_cmd(floppy, pc, rq);
 	} else {
 		blk_dump_rq_flags(rq,
 			"ide-floppy: unsupported command in queue");


