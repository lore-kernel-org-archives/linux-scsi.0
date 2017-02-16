From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 07/10] mpt3sas: use hi-priority queue for TMFs
Date: Thu, 16 Feb 2017 15:39:55 +0530
Message-ID: <CAK=zhgpVhm06-r_CYOmpLrU+uEf9QwM+WpS74OmmmHkJ0Up3Hg@mail.gmail.com>
References: <1485854760-122683-1-git-send-email-hare@suse.de> <1485854760-122683-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:36701 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753096AbdBPKJ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2017 05:09:56 -0500
Received: by mail-qk0-f181.google.com with SMTP id 11so10728249qkl.3
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2017 02:09:56 -0800 (PST)
In-Reply-To: <1485854760-122683-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.com>

On Tue, Jan 31, 2017 at 2:55 PM, Hannes Reinecke <hare@suse.de> wrote:
> When sending a TMF via the ioctl interface we should be using
> the hi-priority queue instead of the scsi queue to be consistent
> with overall TMF usage.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> index 95f0f24..e952175 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -720,7 +720,7 @@ enum block_state {
>                 }
>         } else {
>
> -               smid = mpt3sas_base_get_smid_scsiio(ioc, ioc->ctl_cb_idx, NULL);
> +               smid = mpt3sas_base_get_smid_hpr(ioc, ioc->ctl_cb_idx);

This else part is not for TM path, It is for IO path. For the TM
request we are already using smid from hpr queue, as shown below

if (mpi_request->Function == MPI2_FUNCTION_SCSI_TASK_MGMT) {
                smid = mpt3sas_base_get_smid_hpr(ioc, ioc->ctl_cb_idx);
                if (!smid) {
                        pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
                            ioc->name, __func__);
                        ret = -EAGAIN;
                        goto out;
                }
        } else {

                smid = mpt3sas_base_get_smid_scsiio(ioc, ioc->ctl_cb_idx, NULL);

Thanks,
Sreekanth

>                 if (!smid) {
>                         pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
>                             ioc->name, __func__);
> --
> 1.8.5.6
>
