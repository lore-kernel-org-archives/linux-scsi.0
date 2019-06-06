From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/13] megaraid_sas: set virt_boundary_mask in the scsi
 host
Date: Thu, 6 Jun 2019 08:02:07 +0200
Message-ID: <345c3931-0940-7d59-ebc6-fa1ea56c60ac@suse.de>
References: <20190605190836.32354-1-hch@lst.de>
 <20190605190836.32354-11-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190605190836.32354-11-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Sebastian Ott <sebott@linux.ibm.com>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, Ulf Hansson <ulf.hansson@linaro.org>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.com>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/5/19 9:08 PM, Christoph Hellwig wrote:
> This ensures all proper DMA layer handling is taken care of by the
> SCSI midlayer.  Note that the effect is global, as the IOMMU merging
> is based off a paramters in struct device.  We could still turn if off
> if no PCIe devices are present, but I don't know how to find that out.
> 
> Also remove the bogus nomerges flag, merges do take the virt_boundary
> into account.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 46 +++++----------------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |  7 ++++
>  2 files changed, 18 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 3dd1df472dc6..20b3b3f8bc16 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1870,39 +1870,6 @@ void megasas_set_dynamic_target_properties(struct scsi_device *sdev,
>  	}
>  }
>  
> -/*
> - * megasas_set_nvme_device_properties -
> - * set nomerges=2
> - * set virtual page boundary = 4K (current mr_nvme_pg_size is 4K).
> - * set maximum io transfer = MDTS of NVME device provided by MR firmware.
> - *
> - * MR firmware provides value in KB. Caller of this function converts
> - * kb into bytes.
> - *
> - * e.a MDTS=5 means 2^5 * nvme page size. (In case of 4K page size,
> - * MR firmware provides value 128 as (32 * 4K) = 128K.
> - *
> - * @sdev:				scsi device
> - * @max_io_size:				maximum io transfer size
> - *
> - */
> -static inline void
> -megasas_set_nvme_device_properties(struct scsi_device *sdev, u32 max_io_size)
> -{
> -	struct megasas_instance *instance;
> -	u32 mr_nvme_pg_size;
> -
> -	instance = (struct megasas_instance *)sdev->host->hostdata;
> -	mr_nvme_pg_size = max_t(u32, instance->nvme_page_size,
> -				MR_DEFAULT_NVME_PAGE_SIZE);
> -
> -	blk_queue_max_hw_sectors(sdev->request_queue, (max_io_size / 512));
> -
> -	blk_queue_flag_set(QUEUE_FLAG_NOMERGES, sdev->request_queue);
> -	blk_queue_virt_boundary(sdev->request_queue, mr_nvme_pg_size - 1);
> -}
> -
> -
>  /*
>   * megasas_set_static_target_properties -
>   * Device property set by driver are static and it is not required to be
> @@ -1961,8 +1928,10 @@ static void megasas_set_static_target_properties(struct scsi_device *sdev,
>  		max_io_size_kb = le32_to_cpu(instance->tgt_prop->max_io_size_kb);
>  	}
>  
> -	if (instance->nvme_page_size && max_io_size_kb)
> -		megasas_set_nvme_device_properties(sdev, (max_io_size_kb << 10));
> +	if (instance->nvme_page_size && max_io_size_kb) {
> +		blk_queue_max_hw_sectors(sdev->request_queue,
> +				(max_io_size_kb << 10) / 512);
> +	}
>  
>  	scsi_change_queue_depth(sdev, device_qd);
>  
What happened to the NOMERGES queue flag?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
