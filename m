From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 13:16:01 +0200
Message-ID: <20071017111600.GY5043@kernel.dk>
References: <20071017091629.GK5043@kernel.dk> <20071017182401X.fujita.tomonori@lab.ntt.co.jp> <20071017.024547.74747794.davem@davemloft.net> <20071017200843O.fujita.tomonori@lab.ntt.co.jp> <20071017111348.GX5043@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:22729 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128AbXJQLQ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 07:16:29 -0400
Content-Disposition: inline
In-Reply-To: <20071017111348.GX5043@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Oct 17 2007, Jens Axboe wrote:
> On Wed, Oct 17 2007, FUJITA Tomonori wrote:
> > On Wed, 17 Oct 2007 02:45:47 -0700 (PDT)
> > David Miller <davem@davemloft.net> wrote:
> > 
> > > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > Date: Wed, 17 Oct 2007 18:24:01 +0900
> > > 
> > > > On Wed, 17 Oct 2007 11:16:29 +0200
> > > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > 
> > > > > On Wed, Oct 17 2007, David Miller wrote:
> > > > > > I would suggest that other sg_last() uses be audited for the same bug.
> > > > > 
> > > > > Agree.
> > > > 
> > > > Only libata, I think.
> > > 
> > > There are a few other spots, like ide-scsi
> > 
> > Oops, I missed that. But seems that we have only three, ide-scsi,
> > libata, sparc64 iommu.
> 
> And now only ide-scsi and libata, Dave killed sg_last() in sparc64
> already. So less than I remember, I'd say kill it NOW...

libata remains.

diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index bd74f6c..fa7ba64 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -70,7 +70,7 @@ typedef struct idescsi_pc_s {
 	u8 *buffer;				/* Data buffer */
 	u8 *current_position;			/* Pointer into the above buffer */
 	struct scatterlist *sg;			/* Scatter gather table */
-	struct scatterlist *last_sg;		/* Last sg element */
+	unsigned int sg_cnt;			/* Number of entries in sg */
 	int b_count;				/* Bytes transferred from current entry */
 	struct scsi_cmnd *scsi_cmd;		/* SCSI command */
 	void (*done)(struct scsi_cmnd *);	/* Scsi completion routine */
@@ -192,7 +192,7 @@ static void idescsi_input_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigne
 		}
 		bcount -= count; pc->b_count += count;
 		if (pc->b_count == pc->sg->length) {
-			if (pc->sg == pc->last_sg)
+			if (!--pc->sg_cnt)
 				break;
 			pc->sg = sg_next(pc->sg);
 			pc->b_count = 0;
@@ -229,7 +229,7 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
 		}
 		bcount -= count; pc->b_count += count;
 		if (pc->b_count == pc->sg->length) {
-			if (pc->sg == pc->last_sg)
+			if (!--pc->sg_cnt)
 				break;
 			pc->sg = sg_next(pc->sg);
 			pc->b_count = 0;
@@ -807,7 +807,7 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	memcpy (pc->c, cmd->cmnd, cmd->cmd_len);
 	pc->buffer = NULL;
 	pc->sg = scsi_sglist(cmd);
-	pc->last_sg = sg_last(pc->sg, scsi_sg_count(cmd));
+	pc->sg_cnt = scsi_sg_count(cmd);
 	pc->b_count = 0;
 	pc->request_transfer = pc->buffer_size = scsi_bufflen(cmd);
 	pc->scsi_cmd = cmd;

-- 
Jens Axboe

