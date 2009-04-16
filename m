From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with	blk_rq_map_kern_sgl()
Date: Thu, 16 Apr 2009 12:06:29 +0900
Message-ID: <49E6A0B5.2090704@kernel.org>
References: <20090415084431H.fujita.tomonori@lab.ntt.co.jp> <49E561A0.7040607@kernel.org> <20090415072655.GA11054@liondog.tnic> <20090415164725S.fujita.tomonori@lab.ntt.co.jp> <20090415081259.GB11054@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:34057 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbZDPDGp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Apr 2009 23:06:45 -0400
In-Reply-To: <20090415081259.GB11054@liondog.tnic>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: petkovbb@gmail.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tj@kernel.org, bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, axboe@kern

I updated the patch a bit and folded it into the series after patch
10.  I hope I didn't butcher the patch too bad.  Can I add your
Signed-off-by: on the modified patch?  Also, I just started working on
the atapi version.  Do you already have something?

Thanks.

From: Borislav Petkov <petkovbb@gmail.com>
Date: Tue, 14 Apr 2009 13:24:43 +0200
Subject: [PATCH] ide-cd: preallocate rq sense out of the irq path

Preallocate a sense request in the ->do_request method and reinitialize
it only on demand, in case it's been consumed in the IRQ handler path.
The reason for this is that we don't want to be mapping rq to bio in
the IRQ path and introduce all kinds of unnecessary hacks to the block
layer.

tj: * After this patch, ide_cd_do_request() might sleep.  This should
      be okay as ide request_fn - do_ide_request() - is invoked only
      from make_request and plug work.  Make sure this is the case by
      adding might_sleep() to do_ide_request().

    * Adapted to apply to the tree without blk_rq_map_prealloc()
      changes.

    * Use of blk_rq_map() and possible failure handling from it are
      moved to later separate patch.  ide_cd_prep_sense() now handles
      everything regarding sense rq preparation.

    * Move ide_drive->rq_sense to cdrom_info->sense_rq and put the
      request when releasing cdrom_info.

    * Both user and kernel PC requests expect sense data to be stored
      in separate storage other than info->sense_data.  Copy sense
      data to rq->sense on completion if rq->sense is not NULL.  This
      fixes bogus sense data on PC requests.

CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ide/ide-cd.c |   69 +++++++++++++++++++++++++++++++--------------------
 drivers/ide/ide-cd.h |    3 ++
 drivers/ide/ide-io.c |    3 ++
 3 files changed, 49 insertions(+), 26 deletions(-)

Index: block/drivers/ide/ide-cd.c
===================================================================
--- block.orig/drivers/ide/ide-cd.c
+++ block/drivers/ide/ide-cd.c
@@ -206,42 +206,44 @@ static void cdrom_analyze_sense_data(ide
 	ide_cd_log_error(drive->name, failed_command, sense);
 }
 
-static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
-				      struct request *failed_command)
+static void ide_cd_prep_sense(ide_drive_t *drive, struct request *rq)
 {
 	struct cdrom_info *info		= drive->driver_data;
-	struct request *rq		= &drive->request_sense_rq;
+	void *sense			= &info->sense_data;
 
 	ide_debug_log(IDE_DBG_SENSE, "enter");
 
-	if (sense == NULL)
-		sense = &info->sense_data;
+	if (blk_sense_request(rq))
+		return;
 
-	memset(sense, 0, 18);
+	if (!info->sense_rq) {
+		struct request *sense_rq;
 
-	/* stuff the sense request in front of our current request */
-	blk_rq_init(NULL, rq);
-	rq->cmd_type = REQ_TYPE_ATA_PC;
-	rq->rq_disk = info->disk;
+		memset(sense, 0, 18);
 
-	rq->data = sense;
-	rq->cmd[0] = GPCMD_REQUEST_SENSE;
-	rq->cmd[4] = 18;
-	rq->data_len = 18;
+		sense_rq = blk_get_request(drive->queue, 0, __GFP_WAIT);
+		sense_rq->rq_disk = info->disk;
 
-	rq->cmd_type = REQ_TYPE_SENSE;
-	rq->cmd_flags |= REQ_PREEMPT;
+		sense_rq->data = sense;
+		sense_rq->cmd[0] = GPCMD_REQUEST_SENSE;
+		sense_rq->cmd[4] = 18;
+		sense_rq->data_len = 18;
 
-	/* NOTE! Save the failed command in "rq->special" */
-	rq->special = (void *)failed_command;
+		sense_rq->cmd_type = REQ_TYPE_SENSE;
+		sense_rq->cmd_flags |= REQ_PREEMPT;
 
-	if (failed_command)
-		ide_debug_log(IDE_DBG_SENSE, "failed_cmd: 0x%x",
-					     failed_command->cmd[0]);
+		info->sense_rq = sense_rq;
+	}
+
+	info->sense_rq->special = rq;
+}
 
-	drive->hwif->rq = NULL;
+static void ide_cd_queue_sense_rq(ide_drive_t *drive)
+{
+	struct cdrom_info *info = drive->driver_data;
 
-	elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 0);
+	BUG_ON(!info->sense_rq);
+	elv_add_request(drive->queue, info->sense_rq, ELEVATOR_INSERT_FRONT, 0);
 }
 
 static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
@@ -252,10 +254,16 @@ static void ide_cd_complete_failed_rq(id
 	 */
 	struct request *failed = (struct request *)rq->special;
 	struct cdrom_info *info = drive->driver_data;
-	void *sense = &info->sense_data;
+	struct request_sense *sense = &info->sense_data;
 
 	if (failed) {
 		if (failed->sense) {
+			/*
+			 * Sense is always read into info->sense_data.
+			 * Copy back if the failed request has its
+			 * sense pointer set.
+			 */
+			memcpy(failed->sense, sense, sizeof(*sense));
 			sense = failed->sense;
 			failed->sense_len = rq->sense_len;
 		}
@@ -431,7 +439,7 @@ static int cdrom_decode_status(ide_drive
 
 	/* if we got a CHECK_CONDITION status, queue a request sense command */
 	if (stat & ATA_ERR)
-		cdrom_queue_request_sense(drive, NULL, NULL);
+		ide_cd_queue_sense_rq(drive);
 	return 1;
 
 end_request:
@@ -445,7 +453,7 @@ end_request:
 
 		hwif->rq = NULL;
 
-		cdrom_queue_request_sense(drive, rq->sense, rq);
+		ide_cd_queue_sense_rq(drive);
 		return 1;
 	} else
 		return 2;
@@ -600,6 +608,7 @@ static void ide_cd_error_cmd(ide_drive_t
 
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
+	struct cdrom_info *info = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_cmd *cmd = &hwif->cmd;
 	struct request *rq = hwif->rq;
@@ -775,6 +784,10 @@ out_end:
 
 		ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
 
+		/* our sense buffer got used, reset it for the next round */
+		if (sense)
+			info->sense_rq = NULL;
+
 		if (sense && rc == 2)
 			ide_error(drive, "request sense failure", stat);
 	}
@@ -893,6 +906,9 @@ static ide_startstop_t ide_cd_do_request
 		goto out_end;
 	}
 
+	/* prepare sense request */
+	ide_cd_prep_sense(drive, rq);
+
 	memset(&cmd, 0, sizeof(cmd));
 
 	if (rq_data_dir(rq))
@@ -1634,6 +1650,7 @@ static void ide_cd_release(struct device
 	ide_debug_log(IDE_DBG_FUNC, "enter");
 
 	kfree(info->toc);
+	blk_put_request(info->sense_rq);
 	if (devinfo->handle == drive)
 		unregister_cdrom(devinfo);
 	drive->driver_data = NULL;
Index: block/drivers/ide/ide-io.c
===================================================================
--- block.orig/drivers/ide/ide-io.c
+++ block/drivers/ide/ide-io.c
@@ -478,6 +478,9 @@ void do_ide_request(struct request_queue
 
 	spin_unlock_irq(q->queue_lock);
 
+	/* HLD do_request() callback might sleep, make sure it's okay */
+	might_sleep();
+
 	if (ide_lock_host(host, hwif))
 		goto plug_device_2;
 
Index: block/drivers/ide/ide-cd.h
===================================================================
--- block.orig/drivers/ide/ide-cd.h
+++ block/drivers/ide/ide-cd.h
@@ -98,6 +98,9 @@ struct cdrom_info {
         struct cdrom_device_info devinfo;
 
 	unsigned long write_timeout;
+
+	/* current sense rq */
+	struct request *sense_rq;
 };
 
 /* ide-cd_verbose.c */
