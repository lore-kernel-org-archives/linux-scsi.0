From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ide-scsi: remove kmalloced struct request
Date: Wed, 23 Apr 2008 11:44:39 +0900
Message-ID: <20080423114425E.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This converts ide-scsi to use blk_get/put_request instead of
kmalloc/kfree as discussed in the large command support thread:

http://marc.info/?l=linux-scsi&m=120817161219068&w=2

This patch is a sequel to my patchset to remove struct request on the
stack:

http://marc.info/?l=linux-ide&m=120882410712466&w=2

===
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ide-scsi: remove kmalloced struct request

This converts ide-scsi to use blk_get/put_request instead of
kmalloc/kfree.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/ide-scsi.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 93c3fc2..45bfe0f 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -222,15 +222,15 @@ static int idescsi_check_condition(ide_drive_t *drive,
 
 	/* stuff a sense request in front of our current request */
 	pc = kzalloc(sizeof(struct ide_atapi_pc), GFP_ATOMIC);
-	rq = kmalloc(sizeof(struct request), GFP_ATOMIC);
+	rq = blk_get_request(drive->queue, READ, GFP_ATOMIC);
 	buf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_ATOMIC);
 	if (!pc || !rq || !buf) {
 		kfree(buf);
-		kfree(rq);
+		if (rq)
+			blk_put_request(rq);
 		kfree(pc);
 		return -ENOMEM;
 	}
-	ide_init_drive_cmd(rq);
 	rq->special = (char *) pc;
 	pc->rq = rq;
 	pc->buf = buf;
@@ -246,6 +246,7 @@ static int idescsi_check_condition(ide_drive_t *drive,
 		ide_scsi_hex_dump(pc->c, 6);
 	}
 	rq->rq_disk = scsi->disk;
+	rq->ref_count++;
 	return ide_do_drive_cmd(drive, rq, ide_preempt);
 }
 
@@ -307,7 +308,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 			SCSI_SENSE_BUFFERSIZE);
 		kfree(pc->buf);
 		kfree(pc);
-		kfree(rq);
+		blk_put_request(rq);
 		pc = opc;
 		rq = pc->rq;
 		pc->scsi_cmd->result = (CHECK_CONDITION << 1) |
@@ -338,7 +339,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 	pc->done(pc->scsi_cmd);
 	spin_unlock_irqrestore(host->host_lock, flags);
 	kfree(pc);
-	kfree(rq);
+	blk_put_request(rq);
 	scsi->pc = NULL;
 	return 0;
 }
@@ -751,6 +752,7 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	ide_drive_t *drive = scsi->drive;
 	struct request *rq = NULL;
 	struct ide_atapi_pc *pc = NULL;
+	int write = cmd->sc_data_direction == DMA_TO_DEVICE;
 
 	if (!drive) {
 		scmd_printk (KERN_ERR, cmd, "drive not present\n");
@@ -758,7 +760,7 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	}
 	scsi = drive_to_idescsi(drive);
 	pc = kmalloc(sizeof(struct ide_atapi_pc), GFP_ATOMIC);
-	rq = kmalloc(sizeof(struct request), GFP_ATOMIC);
+	rq = blk_get_request(drive->queue, write, GFP_ATOMIC);
 	if (rq == NULL || pc == NULL) {
 		printk (KERN_ERR "ide-scsi: %s: out of memory\n", drive->name);
 		goto abort;
@@ -786,17 +788,18 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 		}
 	}
 
-	ide_init_drive_cmd (rq);
 	rq->special = (char *) pc;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	spin_unlock_irq(host->host_lock);
 	rq->rq_disk = scsi->disk;
+	rq->ref_count++;
 	(void) ide_do_drive_cmd (drive, rq, ide_end);
 	spin_lock_irq(host->host_lock);
 	return 0;
 abort:
 	kfree (pc);
-	kfree (rq);
+	if (rq)
+		blk_put_request(rq);
 	cmd->result = DID_ERROR << 16;
 	done(cmd);
 	return 0;
@@ -844,7 +847,9 @@ static int idescsi_eh_abort (struct scsi_cmnd *cmd)
 
 		if (blk_sense_request(scsi->pc->rq))
 			kfree(scsi->pc->buf);
-		kfree(scsi->pc->rq);
+		/* we need to call blk_put_request twice. */
+		blk_put_request(scsi->pc->rq);
+		blk_put_request(scsi->pc->rq);
 		kfree(scsi->pc);
 		scsi->pc = NULL;
 
@@ -896,7 +901,7 @@ static int idescsi_eh_reset (struct scsi_cmnd *cmd)
 		kfree(scsi->pc->buf);
 	kfree(scsi->pc);
 	scsi->pc = NULL;
-	kfree(req);
+	blk_put_request(req);
 
 	/* now nuke the drive queue */
 	while ((req = elv_next_request(drive->queue))) {
-- 
1.5.4.2

