From: Jens Axboe <axboe@suse.de>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: Fri, 11 Jun 2004 11:38:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040611093815.GX13836@suse.de>
References: <1086807083.3741.21.camel@patibmrh9> <1086823857.5997.124.camel@patibmrh9> <20040611093027.GW13836@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:64969 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262932AbUFKJiW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2004 05:38:22 -0400
Content-Disposition: inline
In-Reply-To: <20040611093027.GW13836@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Fri, Jun 11 2004, Jens Axboe wrote:
> On Wed, Jun 09 2004, Pat LaVarre wrote:
> > Jens A:
> > 
> > > > a) ...
> > > > ...
> > > > e) ...
> > > ...
> > > f) issue some command that transfers data as well.
> > 
> > I tried an op x12 (18) Inquiry for up to x24 (36) bytes.
> > 
> > I got back zeroes even when I memset my data originally to equal
> > catenated copies of "\xAE" (174).
> > 
> > Under such provocations, dmesg then consistently reports:
> > 
> > hdd: The disk reports a capacity of 250640384 bytes, but the drive only handles 250609664
> > hdd: unknown partition table
> > hdd: leftover data in idefloppy_input_buffers, bcount == 36
> 
> Ah that's a good hint. Can you try changing the pc->buffer = NULL in
> idefloppy_blockpc_cmd() to pc->buffer = rq->data? Also, only set
> PC_DMA_RECOMMENDED if it isn't set. Something ala
> 
> 	pc->buffer = rq->data;
> 	if (rq->bio)
> 		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
> 
> that should work, I think. Do this on top of the patch you are already
> using.

Here's an updated version.

===== drivers/ide/ide.c 1.149 vs edited =====
--- 1.149/drivers/ide/ide.c	2004-06-04 21:14:59 +02:00
+++ edited/drivers/ide/ide.c	2004-06-11 11:37:32 +02:00
@@ -1458,9 +1458,14 @@
 {
 	ide_drive_t *drive = bdev->bd_disk->private_data;
 	ide_settings_t *setting;
-	int err = 0;
+	int err;
 	void __user *p = (void __user *)arg;
 
+	err = scsi_cmd_ioctl(bdev->bd_disk, cmd, p);
+	if (err != -ENOTTY)
+		return err;
+
+	err = 0;
 	down(&ide_setting_sem);
 	if ((setting = ide_find_setting_by_ioctl(drive, cmd)) != NULL) {
 		if (cmd == setting->read_ioctl) {
@@ -1602,10 +1607,6 @@
 			}
 			return 0;
 		}
-
-		case CDROMEJECT:
-		case CDROMCLOSETRAY:
-			return scsi_cmd_ioctl(bdev->bd_disk, cmd, p);
 
 		case HDIO_GET_BUSSTATE:
 			if (!capable(CAP_SYS_ADMIN))
===== drivers/ide/ide-floppy.c 1.39 vs edited =====
--- 1.39/drivers/ide/ide-floppy.c	2004-06-04 06:12:07 +02:00
+++ edited/drivers/ide/ide-floppy.c	2004-06-11 11:36:30 +02:00
@@ -1210,19 +1210,25 @@
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
+	if (rq->data_len && rq_data_dir(rq) == WRITE)
+		set_bit(PC_WRITING, &pc->flags);
+	pc->buffer = rq->data;
+	if (rq->bio)
+		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
+		
+	/*
+	 * possibly problematic, doesn't look like ide-floppy correctly
+	 * handled scattered requests if dma fails...
+	 */
+	pc->request_transfer = pc->buffer_size = rq->data_len;
 }
 
 /*
@@ -1267,10 +1273,7 @@
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

-- 
Jens Axboe

