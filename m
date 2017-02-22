From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCHv3 07/10] mpt3sas: check command status before attempting abort
Date: Wed, 22 Feb 2017 13:47:02 +0530
Message-ID: <CAK=zhgr5KKoRsmhUBXgVsTOyDj-EWYMg_DABBYkMCvG7GavzFg@mail.gmail.com>
References: <1487680029-3701-1-git-send-email-hare@suse.de> <1487680029-3701-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:33421 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754345AbdBVIRE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2017 03:17:04 -0500
Received: by mail-qk0-f173.google.com with SMTP id n127so3214042qkf.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2017 00:17:03 -0800 (PST)
In-Reply-To: <1487680029-3701-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On Tue, Feb 21, 2017 at 5:57 PM, Hannes Reinecke <hare@suse.de> wrote:
> When attempting a command abort we should check the command status
> prior to sending the abort; the command might've been completed
> already.

I think we are already taking care of this. Before calling
'mpt3sas_scsih_issue_tm()' function in 'scsih_abort()' we are already
verifying whether the scmd exists in the driver's scsi_lookup table or
not. if exits then we are issuing the task abort TM to Firmware
otherwise we will return success status from scsih_abort() without
issuing task abort TM to Firmware as shown below,

smid = _scsih_scsi_lookup_find_by_scmd(ioc, scmd);
        if (!smid) {
                scmd->result = DID_RESET << 16;
                r = SUCCESS;
                goto out;
        }

Thanks,
Sreekanth

>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 6bc9291..1c45fb3 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -2261,6 +2261,14 @@ struct _sas_node *
>                 return (!rc) ? SUCCESS : FAILED;
>         }
>
> +       if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
> +               scsi_lookup = mpt3sas_get_st_from_smid(ioc, smid_task);
> +               if (!scsi_lookup)
> +                       return FAILED;
> +               if (scsi_lookup->cb_idx == 0xFF)
> +                       return SUCCESS;
> +       }
> +
>         smid = mpt3sas_base_get_smid_hpr(ioc, ioc->tm_cb_idx);
>         if (!smid) {
>                 pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
> @@ -2268,9 +2276,6 @@ struct _sas_node *
>                 return FAILED;
>         }
>
> -       if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK)
> -               scsi_lookup = mpt3sas_get_st_from_smid(ioc, smid_task);
> -
>         dtmprintk(ioc, pr_info(MPT3SAS_FMT
>                 "sending tm: handle(0x%04x), task_type(0x%02x), smid(%d)\n",
>                 ioc->name, handle, type, smid_task));
> --
> 1.8.5.6
>
