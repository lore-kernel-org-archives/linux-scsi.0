From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH 1/2] scsi: add a max_segment_size limitation to struct
 Scsi_Host
Date: Tue, 12 Apr 2016 11:37:54 -0400 (EDT)
Message-ID: <7048403.28486778.1460475474872.JavaMail.zimbra@redhat.com>
References: <1460470405-11673-1-git-send-email-hch@lst.de> <1460470405-11673-2-git-send-email-hch@lst.de> <570D11F8.1080707@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:39728 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965107AbcDLPh7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2016 11:37:59 -0400
In-Reply-To: <570D11F8.1080707@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org

Other than adding the patch and rebuilding the kernel and testing regular stuff, which I had to do anyway, that was the extent of testing.
I did not see where it was used to be honest other than adding the structure member.
I wanted to test the simple change because it was in scsi_lib.c which has many dependencies of course.

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Bart Van Assche" <bart.vanassche@sandisk.com>
To: "Christoph Hellwig" <hch@lst.de>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org
Sent: Tuesday, April 12, 2016 11:19:20 AM
Subject: Re: [PATCH 1/2] scsi: add a max_segment_size limitation to struct Scsi_Host

On 04/12/2016 07:13 AM, Christoph Hellwig wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 8106515..ad79372 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2120,7 +2120,8 @@ static void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
>   	blk_queue_segment_boundary(q, shost->dma_boundary);
>   	dma_set_seg_boundary(dev, shost->dma_boundary);
>
> -	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
> +	blk_queue_max_segment_size(q, min_not_zero(shost->max_segment_size,
> +						   dma_get_max_seg_size(dev)));
>
>   	if (!shost->use_clustering)
>   		q->limits.cluster = 0;
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index fcfa3d7..f11d3fe 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -621,6 +621,7 @@ struct Scsi_Host {
>   	short unsigned int sg_tablesize;
>   	short unsigned int sg_prot_tablesize;
>   	unsigned int max_sectors;
> +	unsigned int max_segment_size;
>   	unsigned long dma_boundary;
>   	/*
>   	 * In scsi-mq mode, the number of hardware queues supported by the LLD.

Hello Christoph,

The value zero has another meaning for Scsi_Host.max_segment_size than 
for queue_limits.max_segment_size. Shouldn't that be documented somewhere?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
