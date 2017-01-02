From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH v2] scsi: qla4xxx: Use dma_pool_zalloc
Date: Mon, 2 Jan 2017 11:10:04 +0530
Message-ID: <CAFqt6zaGvYZ3ncdXtbrSphCMtyj+F=xtM5_dma3uEvDKODgdBw@mail.gmail.com>
References: <20161222121258.GA8278@gnr743-HP-ZBook-15>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36271 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753105AbdABFkM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jan 2017 00:40:12 -0500
Received: by mail-it0-f65.google.com with SMTP id n68so47053422itn.3
        for <linux-scsi@vger.kernel.org>; Sun, 01 Jan 2017 21:40:12 -0800 (PST)
In-Reply-To: <20161222121258.GA8278@gnr743-HP-ZBook-15>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Javali, Nilesh" <Nilesh.Javali@cavium.com>, QLogic-Storage-Upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org, Rameshwar Sahu <sahu.rameshwar73@gmail.com>

Hi Nilesh,

On Thu, Dec 22, 2016 at 5:42 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
> We should use dma_pool_zalloc instead of dma_pool_alloc/memset
>
> Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
> ---
> v2 changes:
>    - Address comment from Nilesh to make same change in
>      all applicable places inside qla4xxx source
>
>  drivers/scsi/qla4xxx/ql4_mbx.c | 6 ++----
>  drivers/scsi/qla4xxx/ql4_os.c  | 4 +---
>  2 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
> index c291fdf..8f97839 100644
> --- a/drivers/scsi/qla4xxx/ql4_mbx.c
> +++ b/drivers/scsi/qla4xxx/ql4_mbx.c
> @@ -1587,12 +1587,11 @@ int qla4xxx_get_chap(struct scsi_qla_host *ha, char *username, char *password,
>         struct ql4_chap_table *chap_table;
>         dma_addr_t chap_dma;
>
> -       chap_table = dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
> +       chap_table = dma_pool_zalloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
>         if (chap_table == NULL)
>                 return -ENOMEM;
>
>         chap_size = sizeof(struct ql4_chap_table);
> -       memset(chap_table, 0, chap_size);
>
>         if (is_qla40XX(ha))
>                 offset = FLASH_CHAP_OFFSET | (idx * chap_size);
> @@ -1651,13 +1650,12 @@ int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username, char *password,
>         uint32_t chap_size = 0;
>         dma_addr_t chap_dma;
>
> -       chap_table = dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
> +       chap_table = dma_pool_zalloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
>         if (chap_table == NULL) {
>                 ret =  -ENOMEM;
>                 goto exit_set_chap;
>         }
>
> -       memset(chap_table, 0, sizeof(struct ql4_chap_table));
>         if (bidi)
>                 chap_table->flags |= BIT_6; /* peer */
>         else
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 01c3610..0c91c89 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -825,12 +825,10 @@ static int qla4xxx_delete_chap(struct Scsi_Host *shost, uint16_t chap_tbl_idx)
>         uint32_t chap_size;
>         int ret = 0;
>
> -       chap_table = dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
> +       chap_table = dma_pool_zalloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
>         if (chap_table == NULL)
>                 return -ENOMEM;
>
> -       memset(chap_table, 0, sizeof(struct ql4_chap_table));
> -
>         if (is_qla80XX(ha))
>                 max_chap_entries = (ha->hw.flt_chap_size / 2) /
>                                    sizeof(struct ql4_chap_table);
> --
> 1.9.1
>

Any further comment on this patch ?

Regards
Souptick
