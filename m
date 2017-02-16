From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 04/10] mpt3sas: separate out _base_recovery_check()
Date: Thu, 16 Feb 2017 15:23:33 +0530
Message-ID: <CAK=zhgpvR7KoReCHzN7uqd1KgBK0wHoeBc2yiZgniF5aQJwmwA@mail.gmail.com>
References: <1485854760-122683-1-git-send-email-hare@suse.de> <1485854760-122683-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:32840 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752902AbdBPJxf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2017 04:53:35 -0500
Received: by mail-qk0-f177.google.com with SMTP id p22so10626045qka.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2017 01:53:34 -0800 (PST)
In-Reply-To: <1485854760-122683-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.com>

On Tue, Jan 31, 2017 at 2:55 PM, Hannes Reinecke <hare@suse.de> wrote:
> No functional change.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 120b317..dd14596 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2366,6 +2366,19 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
>  }
>
>  static void
> +_base_recovery_check(struct MPT3SAS_ADAPTER *ioc)
> +{
> +       /*
> +        * See _wait_for_commands_to_complete() call with regards to this code.
> +        */
> +       if (ioc->shost_recovery && ioc->pending_io_count) {
> +               if (ioc->pending_io_count == 1)
> +                       wake_up(&ioc->reset_wq);
> +               ioc->pending_io_count = 0;

I think here we should reduce the pending_io_count by one instead of
assigning it to zero in-order to have same behavior as before.

Thanks,
Sreekanth

> +       }
> +}
> +
> +static void
>  _dechain_st(struct MPT3SAS_ADAPTER *ioc, struct scsiio_tracker *st)
>  {
>         struct chain_tracker *chain_req;
> @@ -2402,15 +2415,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
>                 list_add(&ioc->scsi_lookup[i].tracker_list, &ioc->free_list);
>                 spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
>
> -               /*
> -                * See _wait_for_commands_to_complete() call with regards
> -                * to this code.
> -                */
> -               if (ioc->shost_recovery && ioc->pending_io_count) {
> -                       if (ioc->pending_io_count == 1)
> -                               wake_up(&ioc->reset_wq);
> -                       ioc->pending_io_count--;
> -               }
> +               _base_recovery_check(ioc);
>                 return;
>         } else if (smid < ioc->internal_smid) {
>                 /* hi-priority */
> --
> 1.8.5.6
>
