From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] scsi: mvsas: Replace pci_pool_alloc by pci_pool_zalloc
Date: Thu, 1 Dec 2016 11:34:26 +0530
Message-ID: <CAFqt6zbQn4YivsKG3X5Y2OWK92LaUk5nbe+oUheF111ZONULOw@mail.gmail.com>
References: <20161128112626.GA31859@gnr743-HP-ZBook-15>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33373 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755502AbcLAGE1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2016 01:04:27 -0500
Received: by mail-io0-f196.google.com with SMTP id j92so8325145ioi.0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2016 22:04:27 -0800 (PST)
In-Reply-To: <20161128112626.GA31859@gnr743-HP-ZBook-15>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Rameshwar Sahu <sahu.rameshwar73@gmail.com>, linux-scsi@vger.kernel.org

On Mon, Nov 28, 2016 at 4:56 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
> Inside mvs_task_prep(), pci_pool_alloc() followed by memset will be
> replaced by pci_pool_zalloc()
>
> Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
> ---
>  drivers/scsi/mvsas/mv_sas.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index 86eb199..681e5f7 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -790,10 +790,9 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
>         slot->n_elem = n_elem;
>         slot->slot_tag = tag;
>
> -       slot->buf = pci_pool_alloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
> +       slot->buf = pci_pool_zalloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
>         if (!slot->buf)
>                 goto err_out_tag;
> -       memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
>
>         tei.task = task;
>         tei.hdr = &mvi->slot[tag];
> --
> 1.9.1

Any Comment on this patch?
>
