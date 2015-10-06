From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH] 3w-9xxx: don't unmap bounce buffered commands
Date: Mon, 5 Oct 2015 17:52:30 -0700
Message-ID: <CAHtARFF3h+LnxMXTXg1pit2aRN1ucB-ztOQQahDB3=_i2Cpgdw@mail.gmail.com>
References: <1443892567-9562-1-git-send-email-hch@lst.de>
	<1443892567-9562-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:36528 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbbJFAwa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2015 20:52:30 -0400
Received: by ykdt18 with SMTP id t18so188709230ykd.3
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2015 17:52:30 -0700 (PDT)
In-Reply-To: <1443892567-9562-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, =?UTF-8?B?QXR0aWxhIFTDs3Ro?= <atoth@atoth.sote.hu>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Oct 3, 2015 at 10:16 AM, Christoph Hellwig <hch@lst.de> wrote:
> 3w controller don't dma map small single SGL entry commands but instead
> bounce buffer them.  Add a helper to identify these commands and don't
> call scsi_dma_unmap for them.
>
> Based on an earlier patch from James Bottomley.
>
> Fixes: 118c85 ("3w-9xxx: fix command completion race")
> Reported-by: T??th Attila <atoth@atoth.sote.hu>
> Tested-by: T??th Attila <atoth@atoth.sote.hu>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/3w-9xxx.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index add419d..a56a7b2 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -212,6 +212,17 @@ static const struct file_operations twa_fops = {
>         .llseek         = noop_llseek,
>  };
>
> +/*
> + * The controllers use an inline buffer instead of a mapped SGL for small,
> + * single entry buffers.  Note that we treat a zero-length transfer like
> + * a mapped SGL.
> + */
> +static bool twa_command_mapped(struct scsi_cmnd *cmd)
> +{
> +       return scsi_sg_count(cmd) != 1 ||
> +               scsi_bufflen(cmd) >= TW_MIN_SGL_LENGTH;
> +}
> +
>  /* This function will complete an aen request from the isr */
>  static int twa_aen_complete(TW_Device_Extension *tw_dev, int request_id)
>  {
> @@ -1339,7 +1350,8 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
>                                 }
>
>                                 /* Now complete the io */
> -                               scsi_dma_unmap(cmd);
> +                               if (twa_command_mapped(cmd))
> +                                       scsi_dma_unmap(cmd);
>                                 cmd->scsi_done(cmd);
>                                 tw_dev->state[request_id] = TW_S_COMPLETED;
>                                 twa_free_request_id(tw_dev, request_id);
> @@ -1582,7 +1594,8 @@ static int twa_reset_device_extension(TW_Device_Extension *tw_dev)
>                                 struct scsi_cmnd *cmd = tw_dev->srb[i];
>
>                                 cmd->result = (DID_RESET << 16);
> -                               scsi_dma_unmap(cmd);
> +                               if (twa_command_mapped(cmd))
> +                                       scsi_dma_unmap(cmd);
>                                 cmd->scsi_done(cmd);
>                         }
>                 }
> @@ -1765,12 +1778,14 @@ static int twa_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
>         retval = twa_scsiop_execute_scsi(tw_dev, request_id, NULL, 0, NULL);
>         switch (retval) {
>         case SCSI_MLQUEUE_HOST_BUSY:
> -               scsi_dma_unmap(SCpnt);
> +               if (twa_command_mapped(SCpnt))
> +                       scsi_dma_unmap(SCpnt);
>                 twa_free_request_id(tw_dev, request_id);
>                 break;
>         case 1:
>                 SCpnt->result = (DID_ERROR << 16);
> -               scsi_dma_unmap(SCpnt);
> +               if (twa_command_mapped(SCpnt))
> +                       scsi_dma_unmap(SCpnt);
>                 done(SCpnt);
>                 tw_dev->state[request_id] = TW_S_COMPLETED;
>                 twa_free_request_id(tw_dev, request_id);
> @@ -1831,8 +1846,7 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
>                 /* Map sglist from scsi layer to cmd packet */
>
>                 if (scsi_sg_count(srb)) {
> -                       if ((scsi_sg_count(srb) == 1) &&
> -                           (scsi_bufflen(srb) < TW_MIN_SGL_LENGTH)) {
> +                       if (!twa_command_mapped(srb)) {
>                                 if (srb->sc_data_direction == DMA_TO_DEVICE ||
>                                     srb->sc_data_direction == DMA_BIDIRECTIONAL)
>                                         scsi_sg_copy_to_buffer(srb,
> @@ -1905,7 +1919,7 @@ static void twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int re
>  {
>         struct scsi_cmnd *cmd = tw_dev->srb[request_id];
>
> -       if (scsi_bufflen(cmd) < TW_MIN_SGL_LENGTH &&
> +       if (!twa_command_mapped(cmd) &&
>             (cmd->sc_data_direction == DMA_FROM_DEVICE ||
>              cmd->sc_data_direction == DMA_BIDIRECTIONAL)) {
>                 if (scsi_sg_count(cmd) == 1) {
> --
> 1.9.1
>

Christoph/James,

Thanks for fixing this.  The patch looks good to me.

Acked-by: Adam Radford <aradford@gmail.com>

-Adam
