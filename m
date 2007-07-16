From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 24/33] ide-scsi: sg chaining support
Date: Mon, 16 Jul 2007 11:47:38 +0200
Message-ID: <11845792681555-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9340 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759932AbXGPJsi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:38 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, bzolnier@gmail.com

Cc: bzolnier@gmail.com
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/ide-scsi.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index bb90df8..61bcc31 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -70,6 +70,7 @@ typedef struct idescsi_pc_s {
 	u8 *buffer;				/* Data buffer */
 	u8 *current_position;			/* Pointer into the above buffer */
 	struct scatterlist *sg;			/* Scatter gather table */
+	struct scatterlist *last_sg;		/* Last sg element */
 	int b_count;				/* Bytes transferred from current entry */
 	struct scsi_cmnd *scsi_cmd;		/* SCSI command */
 	void (*done)(struct scsi_cmnd *);	/* Scsi completion routine */
@@ -175,11 +176,6 @@ static void idescsi_input_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigne
 	char *buf;
 
 	while (bcount) {
-		if (pc->sg - (struct scatterlist *) pc->scsi_cmd->request_buffer > pc->scsi_cmd->use_sg) {
-			printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
-			idescsi_discard_data (drive, bcount);
-			return;
-		}
 		count = min(pc->sg->length - pc->b_count, bcount);
 		if (PageHighMem(pc->sg->page)) {
 			unsigned long flags;
@@ -198,10 +194,17 @@ static void idescsi_input_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigne
 		}
 		bcount -= count; pc->b_count += count;
 		if (pc->b_count == pc->sg->length) {
-			pc->sg++;
+			if (pc->sg == pc->last_sg)
+				break;
+			pc->sg = sg_next(pc->sg);
 			pc->b_count = 0;
 		}
 	}
+
+	if (bcount) {
+		printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
+		idescsi_discard_data (drive, bcount);
+	}
 }
 
 static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigned int bcount)
@@ -210,11 +213,6 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
 	char *buf;
 
 	while (bcount) {
-		if (pc->sg - (struct scatterlist *) pc->scsi_cmd->request_buffer > pc->scsi_cmd->use_sg) {
-			printk (KERN_ERR "ide-scsi: scatter gather table too small, padding with zeros\n");
-			idescsi_output_zeros (drive, bcount);
-			return;
-		}
 		count = min(pc->sg->length - pc->b_count, bcount);
 		if (PageHighMem(pc->sg->page)) {
 			unsigned long flags;
@@ -233,10 +231,17 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
 		}
 		bcount -= count; pc->b_count += count;
 		if (pc->b_count == pc->sg->length) {
-			pc->sg++;
+			if (pc->sg == pc->last_sg)
+				break;
+			pc->sg = sg_next(pc->sg);
 			pc->b_count = 0;
 		}
 	}
+
+	if (bcount) {
+		printk (KERN_ERR "ide-scsi: scatter gather table too small, padding with zeros\n");
+		idescsi_output_zeros (drive, bcount);
+	}
 }
 
 /*
@@ -910,9 +915,11 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	if (cmd->use_sg) {
 		pc->buffer = NULL;
 		pc->sg = cmd->request_buffer;
+		pc->last_sg = sg_last(pc->sg, cmd->use_sg);
 	} else {
 		pc->buffer = cmd->request_buffer;
 		pc->sg = NULL;
+		pc->last_sg = NULL;
 	}
 	pc->b_count = 0;
 	pc->request_transfer = pc->buffer_size = cmd->request_bufflen;
-- 
1.5.3.rc0.90.gbaa79

