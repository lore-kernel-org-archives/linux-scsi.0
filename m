From: Jens Axboe <axboe@suse.de>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: Wed, 9 Jun 2004 10:20:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040609082045.GT13836@suse.de>
References: <1086710016.3647.4.camel@patibmrh9> <20040609080013.GS13836@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:1466 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265689AbUFIIVT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2004 04:21:19 -0400
Content-Disposition: inline
In-Reply-To: <20040609080013.GS13836@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Wed, Jun 09 2004, Jens Axboe wrote:
> For data transfer, it's more tricky. Well actually, if you restrict
> yourself to non-bio backed request, then it becomes pretty trivial!
> ide-floppy expects a contig buffer, a bio is scattered by nature.

Since it handles REQ_CMD just fine (*), this should actually just work.
Pat, can you test if it does?

* Scattered handling if dma fails looks very fishy, should be audited.

===== drivers/ide/ide.c 1.149 vs edited =====
--- 1.149/drivers/ide/ide.c	2004-06-04 21:14:59 +02:00
+++ edited/drivers/ide/ide.c	2004-06-09 10:07:46 +02:00
@@ -153,6 +153,7 @@
 #include <linux/cdrom.h>
 #include <linux/seq_file.h>
 #include <linux/device.h>
+#include <scsi/sg.h>
 
 #include <asm/byteorder.h>
 #include <asm/irq.h>
@@ -1605,6 +1606,7 @@
 
 		case CDROMEJECT:
 		case CDROMCLOSETRAY:
+		case SG_IO:
 			return scsi_cmd_ioctl(bdev->bd_disk, cmd, p);
 
 		case HDIO_GET_BUSSTATE:
===== drivers/ide/ide-floppy.c 1.39 vs edited =====
--- 1.39/drivers/ide/ide-floppy.c	2004-06-04 06:12:07 +02:00
+++ edited/drivers/ide/ide-floppy.c	2004-06-09 10:19:48 +02:00
@@ -1210,19 +1210,23 @@
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
@@ -1267,10 +1271,7 @@
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

