From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCHv4 11/12] mpt3sas: simplify _wait_for_commands_to_complete()
Date: Fri, 3 Mar 2017 17:27:49 +0530
Message-ID: <CAK=zhgrMzWYNznHr+5aVTC_D+mrSRX-raBK=OpU0x+3O0B9otg@mail.gmail.com>
References: <1487759512-3873-1-git-send-email-hare@suse.de> <1487759512-3873-12-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:33779 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751706AbdCCL5v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2017 06:57:51 -0500
Received: by mail-qk0-f176.google.com with SMTP id n127so171353494qkf.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2017 03:57:50 -0800 (PST)
In-Reply-To: <1487759512-3873-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On Wed, Feb 22, 2017 at 4:01 PM, Hannes Reinecke <hare@suse.de> wrote:
> Use 'host_busy' instead of counting outstanding commands by hand.
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index e6aafa5..169d185 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2408,9 +2408,9 @@ struct scsiio_tracker *
>          * See _wait_for_commands_to_complete() call with regards to this code.
>          */
>         if (ioc->shost_recovery && ioc->pending_io_count) {
> -               if (ioc->pending_io_count == 1)
> +               ioc->pending_io_count = atomic_read(&ioc->shost->host_busy);

This won't consider the scsi IO issued from ioctl path. If that scsi
io is still outstanding then here we will return without waiting for
it to complete.

> +               if (ioc->pending_io_count == 0)
>                         wake_up(&ioc->reset_wq);
> -               ioc->pending_io_count--;
>         }
>  }
>
> @@ -5687,15 +5687,13 @@ struct scsiio_tracker *
>   * _wait_for_commands_to_complete - reset controller
>   * @ioc: Pointer to MPT_ADAPTER structure
>   *
> - * This function waiting(3s) for all pending commands to complete
> + * This function is waiting 10s for all pending commands to complete
>   * prior to putting controller in reset.
>   */
>  static void
>  _wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
>  {
>         u32 ioc_state;
> -       unsigned long flags;
> -       u16 i;
>
>         ioc->pending_io_count = 0;
>
> @@ -5704,11 +5702,7 @@ struct scsiio_tracker *
>                 return;
>
>         /* pending command count */
> -       spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
> -       for (i = 0; i < ioc->scsiio_depth; i++)
> -               if (ioc->scsi_lookup[i].cb_idx != 0xFF)
> -                       ioc->pending_io_count++;
> -       spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
> +       ioc->pending_io_count = atomic_read(&ioc->shost->host_busy);
>
>         if (!ioc->pending_io_count)
>                 return;
> --
> 1.8.5.6
>
