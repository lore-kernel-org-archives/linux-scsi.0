From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 4/6] blk-mq: Introduce blk_mq_delay_run_hw_queue()
Date: Mon, 10 Apr 2017 09:12:19 +0200
Message-ID: <20170410071219.GD5559@lst.de>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com> <20170407181654.27836-5-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49085 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751246AbdDJHMV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Apr 2017 03:12:21 -0400
Content-Disposition: inline
In-Reply-To: <20170407181654.27836-5-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Long Li <longli@microsoft.com>, "K . Y . Srinivasan" <kys@microsoft.com>

> +	if (msecs == 0)
> +		kblockd_schedule_work_on(blk_mq_hctx_next_cpu(hctx),
> +					 &hctx->run_work);
> +	else
> +		kblockd_schedule_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
> +						 &hctx->delayed_run_work,
> +						 msecs_to_jiffies(msecs));
> +}

I'd rather make run_work a delayed_work (again) and use
kblockd_schedule_delayed_work_on with a timeout of zero for the immediate
run case instead of having two competing work structs.
