From: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Subject: Re: [PATCH] scsi/mvsas/mv_init.c: Use dma_zalloc_coherent
Date: Sat, 1 Dec 2018 18:40:02 +0530
Message-ID: <CAJr6mf11gp9iV=NiFEFyo7kSZfCfMsEySdijem_PhMFEAwqucA@mail.gmail.com>
References: <5bf56248.1c69fb81.21a6e.5a72@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5bf56248.1c69fb81.21a6e.5a72@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jthumshirn@suse.de
Cc: Souptick Joarder <jrdr.linux@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Brajeswar Ghosh <brajeswar.linux@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 21, 2018 at 7:18 PM Sabyasachi Gupta
<sabyasachi.linux@gmail.com> wrote:
>
> Replace dma_alloc_coherent + memset with dma_zalloc_coherent
>
> Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>

Any comment on this patch?

> ---
>  drivers/scsi/mvsas/mv_init.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index 3ac3437..495bddb 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -253,33 +253,29 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
>         /*
>          * alloc and init our DMA areas
>          */
> -       mvi->tx = dma_alloc_coherent(mvi->dev,
> +       mvi->tx = dma_zalloc_coherent(mvi->dev,
>                                      sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ,
>                                      &mvi->tx_dma, GFP_KERNEL);
>         if (!mvi->tx)
>                 goto err_out;
> -       memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ);
> -       mvi->rx_fis = dma_alloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
> +       mvi->rx_fis = dma_zalloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
>                                          &mvi->rx_fis_dma, GFP_KERNEL);
>         if (!mvi->rx_fis)
>                 goto err_out;
> -       memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
>
> -       mvi->rx = dma_alloc_coherent(mvi->dev,
> +       mvi->rx = dma_zalloc_coherent(mvi->dev,
>                                      sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
>                                      &mvi->rx_dma, GFP_KERNEL);
>         if (!mvi->rx)
>                 goto err_out;
> -       memset(mvi->rx, 0, sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1));
>         mvi->rx[0] = cpu_to_le32(0xfff);
>         mvi->rx_cons = 0xfff;
>
> -       mvi->slot = dma_alloc_coherent(mvi->dev,
> +       mvi->slot = dma_zalloc_coherent(mvi->dev,
>                                        sizeof(*mvi->slot) * slot_nr,
>                                        &mvi->slot_dma, GFP_KERNEL);
>         if (!mvi->slot)
>                 goto err_out;
> -       memset(mvi->slot, 0, sizeof(*mvi->slot) * slot_nr);
>
>         mvi->bulk_buffer = dma_alloc_coherent(mvi->dev,
>                                        TRASH_BUCKET_SIZE,
> --
> 2.7.4
>
