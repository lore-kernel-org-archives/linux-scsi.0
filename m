From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 05/10] mpt3sas: open-code _scsih_scsi_lookup_get()
Date: Thu, 16 Feb 2017 15:29:24 +0530
Message-ID: <CAK=zhgqrBZPUSvDKHEMZwHLWv00DCrnRzKAsUE+AbyH0M4XoTQ@mail.gmail.com>
References: <1485854760-122683-1-git-send-email-hare@suse.de> <1485854760-122683-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:34156 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751191AbdBPJ70 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2017 04:59:26 -0500
Received: by mail-qk0-f170.google.com with SMTP id s186so10675327qkb.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2017 01:59:25 -0800 (PST)
In-Reply-To: <1485854760-122683-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.com>

On Tue, Jan 31, 2017 at 2:55 PM, Hannes Reinecke <hare@suse.de> wrote:
> Just a wrapper around the scsi lookup array and only used
> in one place, so open-code it.

I think this whole series of patches created over 14.101.00.00 version
driver not on the latest 15.100.00.00 driver. So this patch will
conflict with 15.100.00.00 version driver i.e. with commit
459325c466d278d3c9f51ddc9bb544c014136fd1(mpt3sas: Fix for Crusader to
achieve product targets with SAS devices).

Thanks,
Sreekanth

>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index b5c966e..979f95a 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -1061,19 +1061,6 @@ struct _sas_node *
>  }
>
>  /**
> - * _scsih_scsi_lookup_get - returns scmd entry
> - * @ioc: per adapter object
> - * @smid: system request message index
> - *
> - * Returns the smid stored scmd pointer.
> - */
> -static struct scsi_cmnd *
> -_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
> -{
> -       return ioc->scsi_lookup[smid - 1].scmd;
> -}
> -
> -/**
>   * _scsih_scsi_lookup_get_clear - returns scmd entry
>   * @ioc: per adapter object
>   * @smid: system request message index
> @@ -6101,7 +6088,7 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
>         for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
>                 if (ioc->shost_recovery)
>                         goto out;
> -               scmd = _scsih_scsi_lookup_get(ioc, smid);
> +               scmd = ioc->scsi_lookup[smid - 1].scmd;
>                 if (!scmd)
>                         continue;
>                 sdev = scmd->device;
> --
> 1.8.5.6
>
