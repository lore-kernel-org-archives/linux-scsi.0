From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/5] scsi: introduce force_blk_mq
Date: Mon, 5 Feb 2018 07:57:02 +0100
Message-ID: <8f663312-80e2-c534-62cb-50660607395a@suse.de>
References: <20180203042112.15239-1-ming.lei@redhat.com>
 <20180203042112.15239-5-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180203042112.15239-5-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 02/03/2018 05:21 AM, Ming Lei wrote:
> From scsi driver view, it is a bit troublesome to support both blk-mq
> and non-blk-mq at the same time, especially when drivers need to support
> multi hw-queue.
> 
> This patch introduces 'force_blk_mq' to scsi_host_template so that drivers
> can provide blk-mq only support, so driver code can avoid the trouble
> for supporting both.
> 
> This patch may clean up driver a lot by providing blk-mq only support, espeically
> it is easier to convert multiple reply queues into blk_mq's MQ for the following
> purposes:
> 
> 1) use blk_mq multiple hw queue to deal with allocated irq vectors of all offline
> CPU affinity[1]:
> 
> 	[1] https://marc.info/?l=linux-kernel&m=151748144730409&w=2
> 
> Now 84676c1f21e8ff5(genirq/affinity: assign vectors to all possible CPUs)
> has been merged to V4.16-rc, and it is easy to allocate all offline CPUs
> for some irq vectors, this can't be avoided even though the allocation
> is improved.
> 
> So all these drivers have to avoid to ask HBA to complete request in
> reply queue which hasn't online CPUs assigned.
> 
> This issue can be solved generically and easily via blk_mq(scsi_mq) multiple
> hw queue by mapping each reply queue into hctx.
> 
> 2) some drivers[1] require to complete request in the submission CPU for
> avoiding hard/soft lockup, which is easily done with blk_mq, so not necessary
> to reinvent wheels for solving the problem.
> 
> 	[2] https://marc.info/?t=151601851400001&r=1&w=2
> 
> Sovling the above issues for non-MQ path may not be easy, or introduce
> unnecessary work, especially we plan to enable SCSI_MQ soon as discussed
> recently[3]:
> 
> 	[3] https://marc.info/?l=linux-scsi&m=151727684915589&w=2
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Arun Easi <arun.easi@cavium.com>
> Cc: Omar Sandoval <osandov@fb.com>,
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
> Cc: Christoph Hellwig <hch@lst.de>,
> Cc: Don Brace <don.brace@microsemi.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Peter Rivera <peter.rivera@broadcom.com>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/hosts.c     | 1 +
>  include/scsi/scsi_host.h | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index fe3a0da3ec97..c75cebd7911d 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -471,6 +471,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  		shost->dma_boundary = 0xffffffff;
>  
>  	shost->use_blk_mq = scsi_use_blk_mq;
> +	shost->use_blk_mq = scsi_use_blk_mq || !!shost->hostt->force_blk_mq;
>  
>  	device_initialize(&shost->shost_gendev);
>  	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index a8b7bf879ced..4118760e5c32 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -452,6 +452,9 @@ struct scsi_host_template {
>  	/* True if the controller does not support WRITE SAME */
>  	unsigned no_write_same:1;
>  
> +	/* tell scsi core we support blk-mq only */
> +	unsigned force_blk_mq:1;
> +
>  	/*
>  	 * Countdown for host blocking with no commands outstanding.
>  	 */
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
