From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Fri, 27 May 2005 00:56:19 +0200
Message-ID: <58cb370e0505261556788967a7@mail.gmail.com>
References: <20050523201535.GA24298@havoc.gtf.org>
	 <20050523204516.GA28058@havoc.gtf.org>
	 <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de>
	 <4292CF5D.90809@pobox.com> <20050524075953.GY9855@suse.de>
	 <4292E3EE.10006@pobox.com> <20050524085133.GZ9855@suse.de>
	 <42935852.2020300@pobox.com> <20050525092952.GA7005@suse.de>
Reply-To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.207]:60064 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261709AbVEZW4U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 18:56:20 -0400
Received: by wproxy.gmail.com with SMTP id 68so1529635wra
        for <linux-scsi@vger.kernel.org>; Thu, 26 May 2005 15:56:20 -0700 (PDT)
In-Reply-To: <20050525092952.GA7005@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

Nice work Jens, some feedback below:

On 5/25/05, Jens Axboe <axboe@suse.de> wrote:

> Index: drivers/ide/ide-floppy.c
> ===================================================================
> --- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/ide/ide-floppy.c  (mode:100644)
> +++ uncommitted/drivers/ide/ide-floppy.c  (mode:100644)

> @@ -1311,9 +1311,9 @@
>                 }
>                 pc = idefloppy_next_pc_storage(drive);
>                 idefloppy_create_rw_cmd(floppy, pc, rq, block);
> -       } else if (rq->flags & REQ_SPECIAL) {
> +       } else if (blk_special_request(rq))
>                 pc = (idefloppy_pc_t *) rq->buffer;
> -       } else if (rq->flags & REQ_BLOCK_PC) {
> +       } else if (blk_fs_request(rq)) {
>                 pc = idefloppy_next_pc_storage(drive);
>                 if (idefloppy_blockpc_cmd(floppy, pc, rq)) {
>                         idefloppy_do_end_request(drive, 0, 0);

blk_pc_request(rq)

> Index: drivers/ide/ide-io.c
> ===================================================================
> --- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/ide/ide-io.c  (mode:100644)
> +++ uncommitted/drivers/ide/ide-io.c  (mode:100644)

> @@ -948,9 +948,10 @@
>         if (!drive->special.all) {
>                 ide_driver_t *drv;
> 
> -               if (rq->flags & (REQ_DRIVE_CMD | REQ_DRIVE_TASK))
> +               if (rq->cmd_type == REQ_TYPE_ATA_CMD ||
> +                   rq->cmd_type == REQ_TYPE_ATA_TASK)
>                         return execute_drive_cmd(drive, rq);
> -               else if (rq->flags & REQ_DRIVE_TASKFILE)
> +               else if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
>                         return execute_drive_cmd(drive, rq);
>                 else if (blk_pm_request(rq)) {
>  #ifdef DEBUG_PM

|| rq->cmd_type == REQ_TYPE_ATA_TASKFILE while at it

> Index: drivers/scsi/ide-scsi.c
> ===================================================================
> --- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/scsi/ide-scsi.c  (mode:100644)
> +++ uncommitted/drivers/scsi/ide-scsi.c  (mode:100644)

> @@ -370,12 +370,12 @@
>         u8 *scsi_buf;
>         unsigned long flags;
> 
> -       if (!(rq->flags & (REQ_SPECIAL|REQ_SENSE))) {
> +       if (!blk_special_request(rq) || !blk_sense_request(rq)) {
>                 ide_end_request(drive, uptodate, nrsecs);
>                 return 0;
>         }

!blk_special_request(rq) && !blk_sense_request(rq)

> Index: drivers/scsi/scsi_lib.c
> ===================================================================
> --- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/scsi/scsi_lib.c  (mode:100644)
> +++ uncommitted/drivers/scsi/scsi_lib.c  (mode:100644)

> @@ -922,7 +922,7 @@
>         /*
>          * if this is a rq->data based REQ_BLOCK_PC, setup for a non-sg xfer
>          */
> -       if ((req->flags & REQ_BLOCK_PC) && !req->bio) {
> +       if (blk_pc_request(req) && req->bio) {
>                 cmd->request_bufflen = req->data_len;
>                 cmd->request_buffer = req->data;
>                 req->buffer = req->data;

!req->bio


I assume they you've verified that there are no odd cases possible like
rq->flags = REQ_DRIVE_TASKFILE | REQ_BAR_FLUSH or rq->flags = REQ_PC
(without REQ_BLOCK_PC) which would be obviously broken by this patch?

Bartlomiej
