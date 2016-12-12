From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] scsi: qla4xxx: Use dma_pool_zalloc
Date: Mon, 12 Dec 2016 10:16:21 +0530
Message-ID: <CAFqt6zZ6uAEt4yxbbQKSGnCrOKmAtToKZvBRYwHWVp8=b6aifQ@mail.gmail.com>
References: <20161206202304.GA6884@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36081 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbcLLEqW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Dec 2016 23:46:22 -0500
Received: by mail-io0-f194.google.com with SMTP id b194so19266823ioa.3
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2016 20:46:21 -0800 (PST)
In-Reply-To: <20161206202304.GA6884@jordon-HP-15-Notebook-PC>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 7, 2016 at 1:53 AM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
> We should use dma_pool_zalloc instead of dma_pool_alloc/memset
>
> Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
> ---
>  drivers/scsi/qla4xxx/ql4_mbx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
> index c291fdf..f2edfd7 100644
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
> --
> 1.9.1
>

Any comment on this patch?
