From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v2 4/5] scsi: rename SCSI_MAX_{SG, SG_CHAIN}_SEGMENTS
Date: Mon, 4 Apr 2016 13:24:52 -0700
Message-ID: <CAF1ivSYt4-1UC0YkPFHqwmKWMrX=aD1VQFvH2PCbRjJ1XbL=Gg@mail.gmail.com>
References: <1458684196-15923-1-git-send-email-mlin@kernel.org>
	<1458684196-15923-5-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458684196-15923-5-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 22, 2016 at 3:03 PM, Ming Lin <mlin@kernel.org> wrote:
> From: Ming Lin <ming.l@ssi.samsung.com>
>
> Rename SCSI_MAX_SG_SEGMENTS to SG_CHUNK_SIZE, which means the amount
> we fit into a single scatterlist chunk.
>
> Rename SCSI_MAX_SG_CHAIN_SEGMENTS to SG_MAX_SEGMENTS.
>
> Will move these 2 generic definitions to scatterlist.h later.
>
> Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
> ---
>  drivers/ata/pata_icside.c           |  2 +-
>  drivers/infiniband/ulp/srp/ib_srp.c |  4 ++--
>  drivers/scsi/arm/cumana_2.c         |  2 +-
>  drivers/scsi/arm/eesox.c            |  2 +-
>  drivers/scsi/arm/powertec.c         |  2 +-
>  drivers/scsi/esas2r/esas2r_main.c   |  4 ++--
>  drivers/scsi/hisi_sas/hisi_sas.h    |  2 +-
>  drivers/scsi/mpt3sas/mpt3sas_base.c |  4 ++--
>  drivers/scsi/mpt3sas/mpt3sas_base.h |  2 +-
>  drivers/scsi/scsi_debug.c           |  2 +-
>  drivers/scsi/scsi_lib.c             | 34 +++++++++++++++++-----------------
>  drivers/usb/storage/scsiglue.c      |  2 +-
>  include/scsi/scsi.h                 |  8 ++++----
>  include/scsi/scsi_host.h            |  2 +-
>  14 files changed, 36 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
> index d7c7320..188f2f2 100644
> --- a/drivers/ata/pata_icside.c
> +++ b/drivers/ata/pata_icside.c
> @@ -294,7 +294,7 @@ static int icside_dma_init(struct pata_icside_info *info)
>
>  static struct scsi_host_template pata_icside_sht = {
>         ATA_BASE_SHT(DRV_NAME),
> -       .sg_tablesize           = SCSI_MAX_SG_CHAIN_SEGMENTS,
> +       .sg_tablesize           = SG_MAX_SEGMENTS,
>         .dma_boundary           = IOMD_DMA_BOUNDARY,
>  };

Hi Tejun,

Could you help to review/ack this ATA part?
Thanks.

> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index e0a3398..74dafa7 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -24,16 +24,16 @@ enum scsi_timeouts {
>   * to SG_MAX_SINGLE_ALLOC to pack correctly at the highest order.  The
>   * minimum value is 32
>   */
> -#define SCSI_MAX_SG_SEGMENTS   128
> +#define SG_CHUNK_SIZE  128
>
>  /*
> - * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. This limit
> + * Like SG_CHUNK_SIZE, but for archs that have sg chaining. This limit
>   * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
>   */
>  #ifdef CONFIG_ARCH_HAS_SG_CHAIN
> -#define SCSI_MAX_SG_CHAIN_SEGMENTS     2048
> +#define SG_MAX_SEGMENTS        2048
>  #else
> -#define SCSI_MAX_SG_CHAIN_SEGMENTS     SCSI_MAX_SG_SEGMENTS
> +#define SG_MAX_SEGMENTS        SG_CHUNK_SIZE
>  #endif
>
>  /*
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index fcfa3d7..76e9d27 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -37,7 +37,7 @@ struct blk_queue_tags;
>   *      used in one scatter-gather request.
>   */
>  #define SG_NONE 0
> -#define SG_ALL SCSI_MAX_SG_SEGMENTS
> +#define SG_ALL SG_CHUNK_SIZE
>
>  #define MODE_UNKNOWN 0x00
>  #define MODE_INITIATOR 0x01
> --
> 1.9.1
