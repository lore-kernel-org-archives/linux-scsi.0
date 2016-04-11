From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/2] scsi: add a max_segment_size limitation to struct
 Scsi_Host
Date: Mon, 11 Apr 2016 16:32:16 -0700
Message-ID: <570C3400.9080503@sandisk.com>
References: <1460414846-29540-1-git-send-email-hch@lst.de>
 <1460414846-29540-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0067.outbound.protection.outlook.com ([157.56.111.67]:26880
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755144AbcDKXcW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2016 19:32:22 -0400
In-Reply-To: <1460414846-29540-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org

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
