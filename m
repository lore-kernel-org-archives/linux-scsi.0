From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH] scsi/mpt3sas: Use dma_pool_zalloc
Date: Tue, 9 Oct 2018 11:32:45 +0530
Message-ID: <CA+RiK643GtCGGgivSZbS=DxU7DveqHjZFhZh9+PNoVUAyFmOLQ@mail.gmail.com>
References: <20181002054804.GA11315@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181002054804.GA11315@jordon-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
To: jrdr.linux@gmail.com
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, brajeswar.linux@gmail.com, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Looks good,
Please consider this patch as Acked-by: Suganath Prabu
<suganath-prabu.subramani@broadcom.com>

Thanks

On Tue, Oct 2, 2018 at 11:14 AM Souptick Joarder <jrdr.linux@gmail.com> wrote:
>
> Replaced dma_pool_alloc + memset with dma_pool_zalloc.
>
> Signed-off-by: Brajeswar Ghosh <brajeswar.linux@gmail.com>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 59d7844..d7ef671 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -4516,7 +4516,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
>         i = 0;
>         do {
>                 ioc->reply_post[i].reply_post_free =
> -                   dma_pool_alloc(ioc->reply_post_free_dma_pool,
> +                   dma_pool_zalloc(ioc->reply_post_free_dma_pool,
>                     GFP_KERNEL,
>                     &ioc->reply_post[i].reply_post_free_dma);
>                 if (!ioc->reply_post[i].reply_post_free) {
> @@ -4525,7 +4525,6 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
>                         ioc->name);
>                         goto out;
>                 }
> -               memset(ioc->reply_post[i].reply_post_free, 0, sz);
>                 dinitprintk(ioc, pr_info(MPT3SAS_FMT
>                     "reply post free pool (0x%p): depth(%d),"
>                     "element_size(%d), pool_size(%d kB)\n", ioc->name,
> @@ -4852,14 +4851,13 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
>                         ioc->name);
>                 goto out;
>         }
> -       ioc->reply_free = dma_pool_alloc(ioc->reply_free_dma_pool, GFP_KERNEL,
> +       ioc->reply_free = dma_pool_zalloc(ioc->reply_free_dma_pool, GFP_KERNEL,
>             &ioc->reply_free_dma);
>         if (!ioc->reply_free) {
>                 pr_err(MPT3SAS_FMT "reply_free pool: dma_pool_alloc failed\n",
>                         ioc->name);
>                 goto out;
>         }
> -       memset(ioc->reply_free, 0, sz);
>         dinitprintk(ioc, pr_info(MPT3SAS_FMT "reply_free pool(0x%p): " \
>             "depth(%d), element_size(%d), pool_size(%d kB)\n", ioc->name,
>             ioc->reply_free, ioc->reply_free_queue_depth, 4, sz/1024));
> --
> 1.9.1
>
