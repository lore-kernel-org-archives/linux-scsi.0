From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 7/9] block: Introduce BLKPREP_DONE
Date: Fri, 15 Apr 2016 10:49:31 -0700
Message-ID: <571129AB.8070509@sandisk.com>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0078.outbound.protection.outlook.com ([207.46.100.78]:13557
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750906AbcDORth (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 13:49:37 -0400
In-Reply-To: <1459764020-126038-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On 04/04/2016 03:00 AM, Hannes Reinecke wrote:
> @@ -2460,9 +2460,13 @@ struct request *blk_peek_request(struct request_queue *q)
>
>   			rq = NULL;
>   			break;
> -		} else if (ret == BLKPREP_KILL || ret == BLKPREP_INVALID) {
> +		} else if (ret == BLKPREP_KILL || ret == BLKPREP_INVALID ||
> +			   ret == BLKPREP_DONE) {
>   			int err = (ret == BLKPREP_INVALID) ? -EREMOTEIO : -EIO;
>
> +			if (ret == BLKPREP_DONE)
> +				err = 0;
> +
>   			rq->cmd_flags |= REQ_QUIET;
>   			/*
>   			 * Mark this request as started so we don't trigger

Hello Hannes,

How about using a switch/case statement to translate BLKPREP_* into an 
error code?

Bart.
