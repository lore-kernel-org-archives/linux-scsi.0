From: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with
	blk_rq_map_kern_sgl()
Date: Tue, 14 Apr 2009 12:01:31 +0200
Message-ID: <20090414100131.GA14646@liondog.tnic>
References: <49E3080F.7080206@kernel.org> <20090413190747V.fujita.tomonori@lab.ntt.co.jp> <20090413125912.GA16337@liondog.tnic> <20090414093401V.fujita.tomonori@lab.ntt.co.jp>
Reply-To: petkovbb@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53877 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbZDNKBh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 06:01:37 -0400
Content-Disposition: inline
In-Reply-To: <20090414093401V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tj@kernel.org, bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk, bzolnier@gmail.com, linux-kernel@vger.kernel.org

(adding Bart to CC)

On Tue, Apr 14, 2009 at 09:44:31AM +0900, FUJITA Tomonori wrote:
> On Mon, 13 Apr 2009 14:59:12 +0200
> Borislav Petkov <petkovbb@googlemail.com> wrote:
> 
> > Hi,
> > 
> > On Mon, Apr 13, 2009 at 07:07:58PM +0900, FUJITA Tomonori wrote:
> > > On Mon, 13 Apr 2009 18:38:23 +0900
> > > Tejun Heo <tj@kernel.org> wrote:
> > > 
> > > > FUJITA Tomonori wrote:
> > > > >> I thought that was agreed and done? What is left to do for that to go
> > > > >> in.
> > > > > 
> > > > > I've converted all the users (sg, st, osst). Nothing is left. So we
> > > > > don't need this.
> > > > 
> > > > Yeah, pulled it.  Okay, so we can postpone diddling with request
> > > > mapping for now.  I'll re-post fixes only from this and the previous
> > > > patchset and proceed with other patchsets.
> > > 
> > > To be honest, I don't think that we can clean up the block
> > > mapping. For example, blk_rq_map_kern_prealloc() in your patchset
> > > doesn't look cleanup to me. It's just moving a hack from ide to the
> > > block (well, I have to admit that I did the same thing when I
> > > converted sg/st/osst...).
> > 
> > Well, since blk_rq_map_kern_prealloc() is going to be used only in
> > ide-cd (driver needs it to queue a sense request from within the irq
> > handler) and since it is considered a hack I could try to move it out of
> > the irq handler
> 
> It's quite nice if you could do that.
> 
> But I think that ide-atapi also needs blk_rq_map_kern_prealloc().

I'll look into that too.

> > and do away only with blk_rq_map_kern() if that is more
> > of an agreeable solution?
> 
> Yeah, blk_rq_map_kern() is much proper.

How's that for starters? I know, it is rough but it seems to work
according to my initial testing.

Basically, I opted for preallocating a sense request in the ->do_request
routine and do that only on demand, i.e. I reinitialize it only if it
got used in the irq handler. So in case you want to shove a rq sense in
front of the queue, you simply use the already prepared one. Then in the
irq handler it is being finished the usual ways (blk_end_request). Next
time around you ->do_request, you reallocate it again since it got eaten
in the last round.

The good thing is that now I don't need all those static block layer
structs in the driver (bio, bio_vec, etc) and do the preferred dynamic
allocation instead.

The patch is ontop of Tejun's series at
http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=ide-phase1
with some small modifications in commit 15783b1443f810ae72cb5ccb3a3a3ccc3aeb8729
wrt proper sense buffer length.

I'm sure there's enough room for improvement so please let me know if
any objections/comments.

---
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 35d0973..e689494 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -206,32 +206,21 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 	ide_cd_log_error(drive->name, failed_command, sense);
 }
 
-static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
-				      struct request *failed_command)
+static struct request *ide_cd_prep_sense(ide_drive_t *drive)
 {
 	struct cdrom_info *info	= drive->driver_data;
+	void *sense		= &info->sense_data;
 	struct request *rq	= &drive->request_sense_rq;
-	struct bio *bio		= &drive->request_sense_bio;
-	struct bio_vec *bvec	= drive->request_sense_bvec;
-	unsigned int bvec_len	= ARRAY_SIZE(drive->request_sense_bvec);
-	unsigned sense_len	= 18;
-	int error;
+	unsigned sense_len	= sizeof(struct request_sense);
 
 	ide_debug_log(IDE_DBG_SENSE, "enter");
 
-	if (sense == NULL) {
-		sense = &info->sense_data;
-		sense_len = sizeof(struct request_sense);
-	}
-
 	memset(sense, 0, sense_len);
 
-	/* stuff the sense request in front of our current request */
 	blk_rq_init(NULL, rq);
 
-	error = blk_rq_map_kern_prealloc(drive->queue, rq, bio, bvec, bvec_len,
-					 sense, sense_len, true);
-	BUG_ON(error);
+	if (blk_rq_map_kern(drive->queue, rq, sense, sense_len, __GFP_WAIT))
+		return NULL;
 
 	rq->rq_disk = info->disk;
 
@@ -241,18 +230,17 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 	rq->cmd_type = REQ_TYPE_SENSE;
 	rq->cmd_flags |= REQ_PREEMPT;
 
-	/* NOTE! Save the failed command in "rq->special" */
-	rq->special = (void *)failed_command;
-
-	if (failed_command)
-		ide_debug_log(IDE_DBG_SENSE, "failed_cmd: 0x%x",
-					     failed_command->cmd[0]);
+	return rq;
+}
 
-	drive->hwif->rq = NULL;
+static void ide_cd_queue_rq_sense(ide_drive_t *drive)
+{
+	BUG_ON(!drive->rq_sense);
 
-	elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 0);
+	elv_add_request(drive->queue, drive->rq_sense, ELEVATOR_INSERT_FRONT, 0);
 }
 
+
 static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
 {
 	/*
@@ -440,7 +428,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 
 	/* if we got a CHECK_CONDITION status, queue a request sense command */
 	if (stat & ATA_ERR)
-		cdrom_queue_request_sense(drive, NULL, NULL);
+		ide_cd_queue_rq_sense(drive);
 	return 1;
 
 end_request:
@@ -454,7 +442,7 @@ end_request:
 
 		hwif->rq = NULL;
 
-		cdrom_queue_request_sense(drive, rq->sense, rq);
+		ide_cd_queue_rq_sense(drive);
 		return 1;
 	} else
 		return 2;
@@ -788,6 +776,10 @@ out_end:
 
 		ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
 
+		/* our sense buffer got used, reset it the next time around. */
+		if (sense)
+			drive->rq_sense = NULL;
+
 		if (sense && rc == 2)
 			ide_error(drive, "request sense failure", stat);
 	}
@@ -901,6 +893,25 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		goto out_end;
 	}
 
+	/*
+	 * prepare request sense if it got used with the last rq
+	 */
+	if (!drive->rq_sense) {
+		drive->rq_sense = ide_cd_prep_sense(drive);
+		if (!drive->rq_sense) {
+			printk(KERN_ERR "%s: error prepping sense request!\n",
+					drive->name);
+			return ide_stopped;
+		}
+	}
+
+	/*
+	 * save the current request in case we'll be queueing a sense rq
+	 * afterwards due to its potential failure.
+	 */
+	if (!blk_sense_request(rq))
+		drive->rq_sense->special = (void *)rq;
+
 	memset(&cmd, 0, sizeof(cmd));
 
 	if (rq_data_dir(rq))
diff --git a/include/linux/ide.h b/include/linux/ide.h
index c942533..4c2d310 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -605,6 +605,9 @@ struct ide_drive_s {
 	struct request request_sense_rq;
 	struct bio request_sense_bio;
 	struct bio_vec request_sense_bvec[2];
+
+	/* current sense rq */
+	struct request *rq_sense;
 };
 
 typedef struct ide_drive_s ide_drive_t;
-- 
Regards/Gruss,
    Boris.
