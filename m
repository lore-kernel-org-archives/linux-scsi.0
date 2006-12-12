From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Bugme-new] [Bug 7667] New: BUG at drivers/scsi/scsi_lib.c:1118 caused by "pktsetup dvd /dev/sr0"
Date: Tue, 12 Dec 2006 14:26:00 +0100
Message-ID: <20061212132600.GA19912@lst.de>
References: <200612112159.kBBLxmep005850@fire-2.osdl.org> <20061211141029.9a0b0376.akpm@osdl.org> <20061212103842.GA9619@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:45491 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbWLLN0R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Dec 2006 08:26:17 -0500
Content-Disposition: inline
In-Reply-To: <20061212103842.GA9619@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Christoph Hellwig <hch@lst.de>, Peter Osterlund <petero2@telia.com>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, laurent.riffard@free.fr, Adrian Bunk <bunk@stusta.de>

On Tue, Dec 12, 2006 at 11:38:42AM +0100, Christoph Hellwig wrote:
> This is because the packet driver tries to send down read/write
> BLOCK_PC commands that don't use a bio and do not use sg lists.
> As part of the patch you mentioned I added strict assertations for that
> case because the scsi layer doesn't handle those anymore.
> 
> The right fix is to replace all the packet_command stuff in the packet
> driver by scsi_execute() which needs to be lifted from scsi code to
> the block code for that.  I'll prepare a patch this weekend unless
> someone beets me in doing that work.

Please try the patch below to fix the bug for now.  It's not the
full way to a generic execute block pc infrastcuture but should fix
the bug for the time beeing:


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/pktcdvd.c
===================================================================
--- linux-2.6.orig/drivers/block/pktcdvd.c	2006-12-12 11:30:45.000000000 +0100
+++ linux-2.6/drivers/block/pktcdvd.c	2006-12-12 14:23:37.000000000 +0100
@@ -765,47 +765,34 @@
  */
 static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *cgc)
 {
-	char sense[SCSI_SENSE_BUFFERSIZE];
-	request_queue_t *q;
+	request_queue_t *q = bdev_get_queue(pd->bdev);
 	struct request *rq;
-	DECLARE_COMPLETION_ONSTACK(wait);
-	int err = 0;
+	int ret = 0;
 
-	q = bdev_get_queue(pd->bdev);
+	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
+			     WRITE : READ, __GFP_WAIT);
+
+	if (cgc->buflen) {
+		if (blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen, __GFP_WAIT))
+			goto out;
+	}
+
+	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
+	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
+	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
+		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PACKET_SIZE);
 
-	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ? WRITE : READ,
-			     __GFP_WAIT);
-	rq->errors = 0;
-	rq->rq_disk = pd->bdev->bd_disk;
-	rq->bio = NULL;
-	rq->buffer = NULL;
 	rq->timeout = 60*HZ;
-	rq->data = cgc->buffer;
-	rq->data_len = cgc->buflen;
-	rq->sense = sense;
-	memset(sense, 0, sizeof(sense));
-	rq->sense_len = 0;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->cmd_flags |= REQ_HARDBARRIER;
 	if (cgc->quiet)
 		rq->cmd_flags |= REQ_QUIET;
-	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
-	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
-		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PACKET_SIZE);
-	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
-
-	rq->ref_count++;
-	rq->end_io_data = &wait;
-	rq->end_io = blk_end_sync_rq;
-	elv_add_request(q, rq, ELEVATOR_INSERT_BACK, 1);
-	generic_unplug_device(q);
-	wait_for_completion(&wait);
-
-	if (rq->errors)
-		err = -EIO;
 
+	blk_execute_rq(rq->q, pd->bdev->bd_disk, rq, 0);
+	ret = rq->errors;
+out:
 	blk_put_request(rq);
-	return err;
+	return ret;
 }
 
 /*
