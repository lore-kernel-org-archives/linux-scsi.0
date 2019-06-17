From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/8] scsi: take the DMA max mapping size into account
Date: Mon, 17 Jun 2019 13:56:32 -0700
Message-ID: <5d143a03-edd5-5878-780b-45d87313a813@acm.org>
References: <20190617122000.22181-1-hch@lst.de>
 <20190617122000.22181-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617122000.22181-3-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/17/19 5:19 AM, Christoph Hellwig wrote:
> We need to limit the devices max_sectors to what the DMA mapping
> implementation can support.  If not we risk running out of swiotlb
> buffers easily.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d333bb6b1c59..f233bfd84cd7 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1768,6 +1768,8 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
>   		blk_queue_max_integrity_segments(q, shost->sg_prot_tablesize);
>   	}
>   
> +	shost->max_sectors = min_t(unsigned int, shost->max_sectors,
> +			dma_max_mapping_size(dev) << SECTOR_SHIFT);
>   	blk_queue_max_hw_sectors(q, shost->max_sectors);
>   	if (shost->unchecked_isa_dma)
>   		blk_queue_bounce_limit(q, BLK_BOUNCE_ISA);

Does dma_max_mapping_size() return a value in bytes? Is 
shost->max_sectors a number of sectors? If so, are you sure that "<< 
SECTOR_SHIFT" is the proper conversion? Shouldn't that be ">> 
SECTOR_SHIFT" instead?

Additionally, how about adding a comment above dma_max_mapping_size() 
that documents the unit of the returned number?

Thanks,

Bart.
