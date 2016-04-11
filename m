From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] scsi: add a max_segment_size limitation to struct
 Scsi_Host
Date: Mon, 11 Apr 2016 19:44:24 -0400 (EDT)
Message-ID: <1317640777.28365032.1460418264272.JavaMail.zimbra@redhat.com>
References: <1460414846-29540-1-git-send-email-hch@lst.de> <1460414846-29540-2-git-send-email-hch@lst.de> <570C3400.9080503@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <570C3400.9080503-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Thanks Bart
Good catch, I completely missed it.

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
To: "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Monday, April 11, 2016 7:32:16 PM
Subject: Re: [PATCH 1/2] scsi: add a max_segment_size limitation to struct Scsi_Host

On 04/11/2016 03:47 PM, Christoph Hellwig wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 8106515..04c660d 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2120,7 +2120,8 @@ static void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
>   	blk_queue_segment_boundary(q, shost->dma_boundary);
>   	dma_set_seg_boundary(dev, shost->dma_boundary);
>
> -	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
> +	blk_queue_max_segment_size(q,
> +		min(shost->max_segment_size, dma_get_max_seg_size(dev)));
>
>   	if (!shost->use_clustering)
>   		q->limits.cluster = 0;

Hello Christoph,

Since Scsi_Host.max_segment_size is initialized to zero, shouldn't min() 
be changed into min_not_zero()?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
