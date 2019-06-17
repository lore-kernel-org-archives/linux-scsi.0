From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/8] scsi: add a host / host template field for the virt
 boundary
Date: Mon, 17 Jun 2019 13:51:02 -0700
Message-ID: <ea0f90cd-6263-6a9e-9c88-ed8a8017317e@acm.org>
References: <20190617122000.22181-1-hch@lst.de>
 <20190617122000.22181-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617122000.22181-2-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/17/19 5:19 AM, Christoph Hellwig wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 65d0a10c76ad..d333bb6b1c59 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1775,7 +1775,8 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
>   	dma_set_seg_boundary(dev, shost->dma_boundary);
>   
>   	blk_queue_max_segment_size(q, shost->max_segment_size);
> -	dma_set_max_seg_size(dev, shost->max_segment_size);
> +	blk_queue_virt_boundary(q, shost->virt_boundary_mask);
> +	dma_set_max_seg_size(dev, queue_max_segment_size(q));

Although this looks fine to me for LLDs that own a PCIe device, I doubt 
this is correct for SCSI LLDs that share a PCIe device with other ULP 
drivers. From the RDMA core:

	/* Setup default max segment size for all IB devices */
	dma_set_max_seg_size(device->dma_device, SZ_2G);

Will instantiating a SCSI host (iSER or SRP) for an RDMA adapter cause 
the maximum segment size to be modified for all ULP drivers associated 
with that HCA?

Thanks,

Bart.
