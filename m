From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 03/12] scsi-mq: Add support for multiple hardware queues
Date: Sun, 19 Oct 2014 18:54:54 +0300
Message-ID: <5443DECE.5070500@dev.mellanox.co.il>
References: <5433E43D.3010107@acm.org> <5433E4AB.8030306@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5433E4AB.8030306-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/7/2014 4:03 PM, Bart Van Assche wrote:
> Allow a SCSI LLD to declare how many hardware queues it supports
> by setting Scsi_Host.nr_hw_queues before calling scsi_add_host().
>
> Note: it is assumed that each hardware queue has a queue depth of
> shost->can_queue. In other words, the total queue depth per host
> is (number of hardware queues) * (shost->can_queue).
>
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/scsi/scsi_lib.c  | 2 +-
>   include/scsi/scsi_host.h | 4 ++++
>   2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index db8c449..f829c42 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2072,7 +2072,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>
>   	memset(&shost->tag_set, 0, sizeof(shost->tag_set));
>   	shost->tag_set.ops = &scsi_mq_ops;
> -	shost->tag_set.nr_hw_queues = 1;
> +	shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
>   	shost->tag_set.queue_depth = shost->can_queue;
>   	shost->tag_set.cmd_size = cmd_size;
>   	shost->tag_set.numa_node = NUMA_NO_NODE;
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index cafb260..d38cab9 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -638,6 +638,10 @@ struct Scsi_Host {
>   	short unsigned int sg_prot_tablesize;
>   	unsigned int max_sectors;
>   	unsigned long dma_boundary;
> +	/*
> +	 * In scsi-mq mode, the number of hardware queues supported by the LLD.
> +	 */
> +	unsigned nr_hw_queues;
>   	/*
>   	 * Used to assign serial numbers to the cmds.
>   	 * Protected by the host lock.
>


Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
