From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 0/11] Fix race conditions related to stopping block
 layer queues
Date: Thu, 20 Oct 2016 08:35:55 -0700
Message-ID: <91d7aade-bca8-8772-f1e0-94980b18f872@sandisk.com>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
 <20161019222454.GA1215@localhost.localdomain>
 <25418d7a-7e66-3b99-7532-669f7ebd58a6@sandisk.com>
 <20161020145224.GA2771@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161020145224.GA2771@localhost.localdomain>
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 10/20/2016 07:52 AM, Keith Busch wrote:
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index ccd9cc5..078530c 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -201,7 +201,7 @@ static struct nvme_ns *nvme_get_ns_from_disk(struct gendisk *disk)
>
>  void nvme_requeue_req(struct request *req)
>  {
> -	blk_mq_requeue_request(req, true);
> +	blk_mq_requeue_request(req, !blk_mq_queue_stopped(req->q));
>  }
>  EXPORT_SYMBOL_GPL(nvme_requeue_req);

Hello Keith,

What I had missed while I was preparing my patch series is that the NVMe 
driver, unlike the dm driver, can call blk_mq_requeue_request() on a 
stopped queue. So the above patch is needed to keep the current 
semantics of the NVMe code. I will merge this patch in my patch series.

Thanks,

Bart.
