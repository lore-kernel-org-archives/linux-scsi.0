From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: scsi: mvsas: replace kfree with scsi_host_put
Date: Tue, 8 Aug 2017 16:41:33 +0200
Message-ID: <CAMGffE=owcOPZ4AXah1C5LFQ3YG2F_D4jPWHovi3QXY+AymxGQ@mail.gmail.com>
References: <1502193771-20271-1-git-send-email-bianpan2016@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36807 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752190AbdHHOly (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 10:41:54 -0400
Received: by mail-qk0-f178.google.com with SMTP id d136so20677284qkg.3
        for <linux-scsi@vger.kernel.org>; Tue, 08 Aug 2017 07:41:54 -0700 (PDT)
In-Reply-To: <1502193771-20271-1-git-send-email-bianpan2016@163.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pan Bian <bianpan2016@163.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, Aug 8, 2017 at 2:02 PM, Pan Bian <bianpan2016@163.com> wrote:
> The return value of scsi_host_alloc() should be released by
> scsi_host_put(). However, in function mvs_pci_init(), kfree()
> is used. This patch replaces kfree() with scsi_host_put() to avoid
> possible memory leaks.
>
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  drivers/scsi/mvsas/mv_init.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index 4e047b5..75bdb38 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -557,14 +557,14 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
>         SHOST_TO_SAS_HA(shost) =
>                 kcalloc(1, sizeof(struct sas_ha_struct), GFP_KERNEL);
>         if (!SHOST_TO_SAS_HA(shost)) {
> -               kfree(shost);
> +               scsi_host_put(shost);
>                 rc = -ENOMEM;
>                 goto err_out_regions;
>         }
>
>         rc = mvs_prep_sas_ha_init(shost, chip);
>         if (rc) {
> -               kfree(shost);
> +               scsi_host_put(shost);
>                 rc = -ENOMEM;
>                 goto err_out_regions;
>         }
> --
> 1.9.1
>
>

Looks good to me! Thanks Pan!

Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

-- 
Jack Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
