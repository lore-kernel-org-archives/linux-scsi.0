From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 4/8] storvsc: set virt_boundary_mask in the scsi host
 template
Date: Mon, 17 Jun 2019 13:59:09 -0700
Message-ID: <e2ea87c6-a6ba-149b-f99e-d2980f5cd9a0@acm.org>
References: <20190617122000.22181-1-hch@lst.de>
 <20190617122000.22181-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617122000.22181-5-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/17/19 5:19 AM, Christoph Hellwig wrote:
> This ensures all proper DMA layer handling is taken care of by the
> SCSI midlayer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/storvsc_drv.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index b89269120a2d..7ed6f2fc1446 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1422,9 +1422,6 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
>   {
>   	blk_queue_rq_timeout(sdevice->request_queue, (storvsc_timeout * HZ));
>   
> -	/* Ensure there are no gaps in presented sgls */
> -	blk_queue_virt_boundary(sdevice->request_queue, PAGE_SIZE - 1);
> -
>   	sdevice->no_write_same = 1;
>   
>   	/*
> @@ -1697,6 +1694,8 @@ static struct scsi_host_template scsi_driver = {
>   	.this_id =		-1,
>   	/* Make sure we dont get a sg segment crosses a page boundary */
>   	.dma_boundary =		PAGE_SIZE-1,
> +	/* Ensure there are no gaps in presented sgls */
> +	.virt_boundary_mask =	PAGE_SIZE-1,
>   	.no_write_same =	1,
>   	.track_queue_depth =	1,
>   };

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
