From: Jens Axboe <axboe@suse.de>
Subject: Re: PROBLEM: 2.6.3 hangs when writing to scsi-dvd
Date: Mon, 23 Feb 2004 14:26:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040223132634.GD32010@suse.de>
References: <403512B8.2060403@ics.uci.edu> <4036867C.60803@ics.uci.edu> <Pine.LNX.4.58.0402231329480.1749@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:7580 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261843AbUBWN0m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 08:26:42 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0402231329480.1749@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Joachim Feise <jfeise@ics.uci.edu>, linux-scsi@vger.kernel.org, Michael Guntsche <mike@it-loops.com>, Andrew Morton <akpm@osdl.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Frank Pieczynski <pieczy@web.de>

On Mon, Feb 23 2004, Kai Makisara wrote:
> Please trim the cc list as appropriate. I am including all of the people 
> from the various messages related to probably one problem to get all of us 
> on the same track. Jens is included because he might directly see a 
> solution.
> 
> On Fri, 20 Feb 2004, Joachim Feise wrote:
> 
> > Joachim Feise wrote on 2/19/2004 11:47:
> > 
> > > [1.] One line summary of the problem:
> > > 2.6.3 hangs when writing to scsi-dvd
> > > 
> > > [2.] Full description of the problem/report:
> > > 
> > > I have a DVD drive (BTC1004) connected via an IDE-SCSI bridge to
> > > an Adaptec 29160 host adapter.
> > > With kernel 2.6.3, I experience a complete system hang whenever I try
> > > to record data on a DVD.
> > > It requires a reboot.
> > 
> > More info:
> > on the cdwrite list, somebody reported a similar problem
> > (http://lists.debian.org/cdwrite/2004/cdwrite-200402/msg00081.html)
> > 
> > His quick-n-dirty fix works for me:
> > 
> > --- linux-2.6.3/drivers/scsi/scsi_lib.c.orig    2004-02-17 19:57:57.000000000 -0800
> > +++ linux-2.6.3/drivers/scsi/scsi_lib.c 2004-02-20 13:52:46.000000000 -0800
> > @@ -1292,7 +1292,7 @@
> >          * host adapters.  A host driver can alter this mask in its
> >          * slave_alloc() or slave_configure() callback if necessary.
> >          */
> > -       blk_queue_dma_alignment(q, (8 - 1));
> > +       /* blk_queue_dma_alignment(q, (8 - 1)); */
> > 
> >         if (!shost->use_clustering)
> >                 clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
> > 
> > But without knowing what this particular line does, it is impossible for me
> > to say if commenting out the line is the right thing to do.
> > 
> This line has has several duties. For me, it sets the alignment constaint 
> used by st for deciding whether to use direct i/o or internal buffer. For 
> other people more important is that it is used for similar purpose in 
> linux/fs/bio.c. The beginning of __bio_map_user contains the following:
> 
>         /*
>          * transfer and buffer must be aligned to at least hardsector
>          * size for now, in the future we can relax this restriction
>          */
>         if ((uaddr & queue_dma_alignment(q)) || (len & queue_dma_alignment(q)))
>                 return NULL;
> 
> Without the call to blk_queue_alignment() in scsi_lib.c, the queue 
> alignment is to 512 byte boundary and the transfer size must be a multiple 
> of 512 bytes. With the calls, the unit is 8 bytes.
> 
> The function sg_io in linux/drivers/scsi/scsi_ioctl.c contains this:
> 
>                 /*
>                  * first try to map it into a bio. reading from device will
>                  * be a write to vm.
>                  */
>                 bio = bio_map_user(q, NULL, (unsigned long) hdr->dxferp,
>                                    hdr->dxfer_len, reading);
> 
>                 /*
>                  * if bio setup failed, fall back to slow approach
>                  */
>                 if (!bio) {
> 
> bio_map_user() calls __bio_map_user() and so the previous conditions are 
> used in sg_io() to decide on bouncing.
> 
> I made a test program that uses sg_io() to send a command to a SCSI 
> device. I tested it with a SCSI tape device. Without any changes the 
> program hung. The SCSI driver was sym53c8xx_2 and it loops on the 
> following error:
> 
> Feb 23 13:24:17 box kernel: sym1:5:0:extraneous data discarded.
> Feb 23 13:24:17 box kernel: sym1:5:0:COMMAND FAILED (87 0 1).
> Feb 23 13:24:17 box kernel: SCSI error : <1 0 5 0> return code = 0x70000
> 
> The I modified the program to align the buffer to 512 byte boundary. This 
> did not help. The next step was to set the transfer size to 512 bytes. 
> This helps!! Restoring the non-512 byte alignment did not cause any 
> problems.
> 
> The conclusion at this phase is that _the tranfer length in bio must be a 
> multiple of 512 bytes_.
> 
> I hope someone sees no where the real problem is.

SCSI io completion path (sr/sd/st rw_intr() -> scsi_io_completion() ->
scsi_end_request()) doesn't properly handle non-sector aligned data
transfers. This patch should fix it up. Warning: untested.

===== drivers/scsi/scsi_lib.c 1.118 vs edited =====
--- 1.118/drivers/scsi/scsi_lib.c	Mon Feb  2 17:14:22 2004
+++ edited/drivers/scsi/scsi_lib.c	Mon Feb 23 14:21:36 2004
@@ -493,7 +493,7 @@
  *		at some point during this call.
  */
 static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
-					  int sectors, int requeue)
+					  int bytes, int requeue)
 {
 	request_queue_t *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
@@ -503,12 +503,15 @@
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
 	 */
-	if (end_that_request_first(req, uptodate, sectors)) {
-		int leftover = req->hard_nr_sectors - sectors;
+	if (end_that_request_chunk(req, uptodate, bytes)) {
+		int leftover = (req->hard_nr_sectors << 9) - bytes;
+
+		if (blk_pc_request(req))
+			leftover = req->data_len - bytes;
 
 		/* kill remainder if no retrys */
 		if (!uptodate && blk_noretry_request(req))
-			end_that_request_first(req, 0, leftover);
+			end_that_request_chunk(req, 0, leftover);
 		else {
 			if (requeue)
 				/*
@@ -649,11 +652,11 @@
  *		b) We can just use scsi_requeue_command() here.  This would
  *		   be used if we just wanted to retry, for example.
  */
-void scsi_io_completion(struct scsi_cmnd *cmd, int good_sectors,
-			int block_sectors)
+void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes,
+			unsigned int block_bytes)
 {
 	int result = cmd->result;
-	int this_count = cmd->bufflen >> 9;
+	int this_count = cmd->bufflen;
 	request_queue_t *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int clear_errors = 1;
@@ -705,9 +708,9 @@
 	 * Next deal with any sectors which we were able to correctly
 	 * handle.
 	 */
-	if (good_sectors >= 0) {
-		SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, %d sectors done.\n",
-					      req->nr_sectors, good_sectors));
+	if (good_bytes >= 0) {
+		SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, %d bytes done.\n",
+					      req->nr_sectors, good_bytes));
 		SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n", cmd->use_sg));
 
 		if (clear_errors)
@@ -717,13 +720,13 @@
 		 * they will have been finished off by the first command.
 		 * If not, then we have a multi-buffer command.
 		 *
-		 * If block_sectors != 0, it means we had a medium error
+		 * If block_bytes != 0, it means we had a medium error
 		 * of some sort, and that we want to mark some number of
 		 * sectors as not uptodate.  Thus we want to inhibit
 		 * requeueing right here - we will requeue down below
 		 * when we handle the bad sectors.
 		 */
-		cmd = scsi_end_request(cmd, 1, good_sectors, result == 0);
+		cmd = scsi_end_request(cmd, 1, good_bytes, result == 0);
 
 		/*
 		 * If the command completed without error, then either finish off the
@@ -808,7 +811,7 @@
 			       (int) cmd->device->id, (int) cmd->device->lun);
 			print_command(cmd->data_cmnd);
 			print_sense("", cmd);
-			cmd = scsi_end_request(cmd, 0, block_sectors, 1);
+			cmd = scsi_end_request(cmd, 0, block_bytes, 1);
 			return;
 		default:
 			break;
@@ -837,8 +840,10 @@
 		 * We sometimes get this cruft in the event that a medium error
 		 * isn't properly reported.
 		 */
-		cmd = scsi_end_request(cmd, 0, req->current_nr_sectors, 1);
-		return;
+		block_bytes = req->hard_cur_sectors << 9;
+		if (!block_bytes)
+			block_bytes = req->data_len;
+		cmd = scsi_end_request(cmd, 0, block_bytes, 1);
 	}
 }
 
===== drivers/scsi/sd.c 1.140 vs edited =====
--- 1.140/drivers/scsi/sd.c	Wed Feb  4 20:20:06 2004
+++ edited/drivers/scsi/sd.c	Mon Feb 23 14:10:00 2004
@@ -661,8 +661,8 @@
 static void sd_rw_intr(struct scsi_cmnd * SCpnt)
 {
 	int result = SCpnt->result;
-	int this_count = SCpnt->bufflen >> 9;
-	int good_sectors = (result == 0 ? this_count : 0);
+	int this_count = SCpnt->bufflen;
+	int good_bytes = (result == 0 ? this_count : 0);
 	sector_t block_sectors = 1;
 	sector_t error_sector;
 #ifdef CONFIG_SCSI_LOGGING
@@ -688,6 +688,8 @@
 		case MEDIUM_ERROR:
 			if (!(SCpnt->sense_buffer[0] & 0x80))
 				break;
+			if (!blk_fs_request(SCpnt->request))
+				break;
 			error_sector = (SCpnt->sense_buffer[3] << 24) |
 			(SCpnt->sense_buffer[4] << 16) |
 			(SCpnt->sense_buffer[5] << 8) |
@@ -718,9 +720,9 @@
 			}
 
 			error_sector &= ~(block_sectors - 1);
-			good_sectors = error_sector - SCpnt->request->sector;
-			if (good_sectors < 0 || good_sectors >= this_count)
-				good_sectors = 0;
+			good_bytes = (error_sector - SCpnt->request->sector) << 9;
+			if (good_bytes < 0 || good_bytes >= this_count)
+				good_bytes = 0;
 			break;
 
 		case RECOVERED_ERROR:
@@ -732,7 +734,7 @@
 			print_sense("sd", SCpnt);
 			SCpnt->result = 0;
 			SCpnt->sense_buffer[0] = 0x0;
-			good_sectors = this_count;
+			good_bytes = this_count;
 			break;
 
 		case ILLEGAL_REQUEST:
@@ -755,7 +757,7 @@
 	 * how many actual sectors finished, and how many sectors we need
 	 * to say have failed.
 	 */
-	scsi_io_completion(SCpnt, good_sectors, block_sectors);
+	scsi_io_completion(SCpnt, good_bytes, block_sectors << 9);
 }
 
 static int media_not_present(struct scsi_disk *sdkp, struct scsi_request *srp)
===== drivers/scsi/sr.c 1.98 vs edited =====
--- 1.98/drivers/scsi/sr.c	Mon Feb  9 21:59:10 2004
+++ edited/drivers/scsi/sr.c	Mon Feb 23 14:20:57 2004
@@ -179,14 +179,14 @@
 static void rw_intr(struct scsi_cmnd * SCpnt)
 {
 	int result = SCpnt->result;
-	int this_count = SCpnt->bufflen >> 9;
-	int good_sectors = (result == 0 ? this_count : 0);
+	int this_count = SCpnt->bufflen;
+	int good_bytes = (result == 0 ? this_count : 0);
 	int block_sectors = 0;
 	long error_sector;
 	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
 
 #ifdef DEBUG
-	printk("sr.c done: %x %p\n", result, SCpnt->request->bh->b_data);
+	printk("sr.c done: %x\n", result);
 #endif
 
 	/*
@@ -203,6 +203,8 @@
 		case ILLEGAL_REQUEST:
 			if (!(SCpnt->sense_buffer[0] & 0x90))
 				break;
+			if (!blk_fs_request(SCpnt->request))
+				break;
 			error_sector = (SCpnt->sense_buffer[3] << 24) |
 				(SCpnt->sense_buffer[4] << 16) |
 				(SCpnt->sense_buffer[5] << 8) |
@@ -215,9 +217,9 @@
 			if (cd->device->sector_size == 2048)
 				error_sector <<= 2;
 			error_sector &= ~(block_sectors - 1);
-			good_sectors = error_sector - SCpnt->request->sector;
-			if (good_sectors < 0 || good_sectors >= this_count)
-				good_sectors = 0;
+			good_bytes = (error_sector - SCpnt->request->sector) << 9;
+			if (good_bytes < 0 || good_bytes >= this_count)
+				good_bytes = 0;
 			/*
 			 * The SCSI specification allows for the value
 			 * returned by READ CAPACITY to be up to 75 2K
@@ -241,7 +243,7 @@
 			print_sense("sr", SCpnt);
 			SCpnt->result = 0;
 			SCpnt->sense_buffer[0] = 0x0;
-			good_sectors = this_count;
+			good_bytes = this_count;
 			break;
 
 		default:
@@ -254,7 +256,7 @@
 	 * how many actual sectors finished, and how many sectors we need
 	 * to say have failed.
 	 */
-	scsi_io_completion(SCpnt, good_sectors, block_sectors);
+	scsi_io_completion(SCpnt, good_bytes, block_sectors << 9);
 }
 
 static int sr_init_command(struct scsi_cmnd * SCpnt)
===== drivers/scsi/st.c 1.77 vs edited =====
--- 1.77/drivers/scsi/st.c	Fri Feb  6 09:21:37 2004
+++ edited/drivers/scsi/st.c	Mon Feb 23 14:23:46 2004
@@ -4011,7 +4011,7 @@
 
 static void st_intr(struct scsi_cmnd *SCpnt)
 {
-	scsi_io_completion(SCpnt, (SCpnt->result ? 0: SCpnt->bufflen >> 9), 1);
+	scsi_io_completion(SCpnt, (SCpnt->result ? 0: SCpnt->bufflen), 1);
 }
 
 /*
===== include/scsi/scsi_cmnd.h 1.3 vs edited =====
--- 1.3/include/scsi/scsi_cmnd.h	Sat Sep 20 11:36:20 2003
+++ edited/include/scsi/scsi_cmnd.h	Mon Feb 23 14:21:27 2004
@@ -158,6 +158,6 @@
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, int);
 extern void scsi_put_command(struct scsi_cmnd *);
-extern void scsi_io_completion(struct scsi_cmnd *, int, int);
+extern void scsi_io_completion(struct scsi_cmnd *, unsigned int, unsigned int);
 
 #endif /* _SCSI_SCSI_CMND_H */


-- 
Jens Axboe

