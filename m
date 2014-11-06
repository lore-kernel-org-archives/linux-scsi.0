From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 08/11] scsi: always assign block layer tags if enabled
Date: Thu, 06 Nov 2014 17:28:32 +0100
Message-ID: <545BA1B0.8030604@acm.org>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-9-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:56205 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaKFQ2i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 11:28:38 -0500
In-Reply-To: <1415087656-9491-9-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On 11/04/14 08:54, Christoph Hellwig wrote:
> -/**
> - * scsi_activate_tcq - turn on tag command queueing
> - * @SDpnt:	device to turn on TCQ for
> - * @depth:	queue depth
> - *
> - * Notes:
> - *	Eventually, I hope depth would be the maximum depth
> - *	the device could cope with and the real queue depth
> - *	would be adjustable from 0 to depth.
> - **/
> -static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
> -{
> -	if (!sdev->tagged_supported)
> -		return;
> -
> -	if (shost_use_blk_mq(sdev->host))
> -		queue_flag_set_unlocked(QUEUE_FLAG_QUEUED, sdev->request_queue);
> -	else if (!blk_queue_tagged(sdev->request_queue))
> -		blk_queue_init_tags(sdev->request_queue, depth,
> -				    sdev->host->bqt);
> -
> -	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
> -}

Apparently this patch removes the 
queue_flag_set_unlocked(QUEUE_FLAG_QUEUED, sdev->request_queue) call for 
the multiqueue case. I think it should be explained in the commit 
message why that has been done.

> -/**
> - * scsi_deactivate_tcq - turn off tag command queueing
> - * @SDpnt:	device to turn off TCQ for
> - **/
> -static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
> -{
> -	if (blk_queue_tagged(sdev->request_queue))
> -		blk_queue_free_tags(sdev->request_queue);
> -	scsi_adjust_queue_depth(sdev, 0, depth);
> -}

Hmm ... where has the blk_queue_free_tags() call been moved to ?

Bart.

