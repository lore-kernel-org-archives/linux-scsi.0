From: Jens Axboe <axboe@suse.de>
Subject: Re: [2.5.69-bk8] block SCSI_IOCTL_SEND_COMMAND+SG_IO borken
Date: Wed, 14 May 2003 15:26:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030514132619.GM15261@suse.de>
References: <3EC22B56.9080800@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:6570 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262174AbTENNNb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 09:13:31 -0400
Content-Disposition: inline
In-Reply-To: <3EC22B56.9080800@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Wed, May 14 2003, Douglas Gilbert wrote:
> lk 2.5.68-bk8 seems a bit flaky with slab corruption
> (hopefully James and Mike have addressed that).
> 
> One thing that fails all the time is trying to send
> SCSI_IOCTL_SEND_COMMAND or SG_IO ioctls through the
> block layer (i.e. code in drivers/block/scsi_ioctl.c).
> The only change in that file in bk8 is from me to
> fix sense buffer handling which is not being exercised
> in the failure case (e.g. simple commands like INQUIRY).
> 
> The sym53c8xx driver seems to interpret commands from
> block layer as bus reset requests:
> 
>  sym0:1: ERROR (0:48) (c-2d-61) (3e/18/80) @ (scripta b00:14000000).
>  sym0: script cmd = 88080000
>  sym0: regdump: da 10 c0 18 47 3e 01 0e 00 0c 81 2d
> 80 01 0d 08 00 d4 48 1e 0a 00 00 00.
>  sym0: SCSI BUS reset detected.
>  sym0: SCSI BUS has been reset.
> 
> Sending those two ioctls through the scsi mid-level
> works (e.g. 'sg_inq /dev/sda' fails while 'sg_inq /dev/sg0'
> works).

Known problem, fix attached.

===== drivers/block/scsi_ioctl.c 1.25 vs edited =====
--- 1.25/drivers/block/scsi_ioctl.c	Tue Apr 29 13:41:31 2003
+++ edited/drivers/block/scsi_ioctl.c	Wed May 14 10:22:25 2003
@@ -212,7 +212,7 @@
 		}
 	}
 
-	rq = blk_get_request(q, WRITE, __GFP_WAIT);
+	rq = blk_get_request(q, writing ? WRITE : READ, __GFP_WAIT);
 
 	/*
 	 * fill in request structure
@@ -227,8 +227,6 @@
 	rq->sense_len = 0;
 
 	rq->flags |= REQ_BLOCK_PC;
-	if (writing)
-		rq->flags |= REQ_RW;
 
 	rq->hard_nr_sectors = rq->nr_sectors = nr_sectors;
 	rq->hard_cur_sectors = rq->current_nr_sectors = nr_sectors;
@@ -329,7 +327,7 @@
 		memset(buffer, 0, bytes);
 	}
 
-	rq = blk_get_request(q, WRITE, __GFP_WAIT);
+	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
 
 	cmdlen = COMMAND_SIZE(opcode);
 
@@ -373,8 +371,6 @@
 	rq->data = buffer;
 	rq->data_len = bytes;
 	rq->flags |= REQ_BLOCK_PC;
-	if (in_len)
-		rq->flags |= REQ_RW;
 
 	blk_do_rq(q, bdev, rq);
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */


-- 
Jens Axboe

