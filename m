From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v4 6/6] dm rq: Avoid that request processing stalls
 sporadically
Date: Fri, 14 Apr 2017 09:13:29 +0800
Message-ID: <20170414011324.GA29916@ming.t460p>
References: <20170411160958.GA19222@redhat.com>
 <1491928005.2654.6.camel@sandisk.com>
 <20170411174739.GA19620@redhat.com>
 <1491933092.2654.10.camel@sandisk.com>
 <20170411180358.GA19660@redhat.com>
 <1491934715.2654.14.camel@sandisk.com>
 <20170412034229.GA8835@ming.t460p>
 <1492022286.2764.15.camel@sandisk.com>
 <20170413022030.GD8835@ming.t460p>
 <25ebc19f-f6e0-2f71-f590-8416359d2fd1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750764AbdDNBNo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Apr 2017 21:13:44 -0400
Content-Disposition: inline
In-Reply-To: <25ebc19f-f6e0-2f71-f590-8416359d2fd1@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>

On Thu, Apr 13, 2017 at 09:59:57AM -0700, Bart Van Assche wrote:
> On 04/12/17 19:20, Ming Lei wrote:
> > On Wed, Apr 12, 2017 at 06:38:07PM +0000, Bart Van Assche wrote:
> >> If the blk-mq core would always rerun a hardware queue if a block driver
> >> returns BLK_MQ_RQ_QUEUE_BUSY then that would cause 100% of a single CPU core
> > 
> > It won't casue 100% CPU utilization since we restart queue in completion
> > path and at that time at least one tag is available, then progress can be
> > made.
> 
> Hello Ming,
> 
> Sorry but you are wrong. If .queue_rq() returns BLK_MQ_RQ_QUEUE_BUSY
> then it's likely that calling .queue_rq() again after only a few
> microseconds will cause it to return BLK_MQ_RQ_QUEUE_BUSY again. If you
> don't believe me, change "if (!blk_mq_sched_needs_restart(hctx) &&
> !test_bit(BLK_MQ_S_TAG_WAITING, &hctx->state)) blk_mq_run_hw_queue(hctx,
> true);" into "blk_mq_run_hw_queue(hctx, true);", trigger a busy

Yes, that can be true, but I mean it is still OK to run the queue again
with

	if (!blk_mq_sched_needs_restart(hctx) &&
	    !test_bit(BLK_MQ_S_TAG_WAITING, &hctx->state))
			blk_mq_run_hw_queue(hctx, true);

and restarting queue in __blk_mq_finish_request() when
BLK_MQ_RQ_QUEUE_BUSY is returned from .queue_rq(). And both are in current
blk-mq implementation.

Then why do we need blk_mq_delay_run_hw_queue(hctx, 100/*ms*/) in dm?

Thanks,
Ming
