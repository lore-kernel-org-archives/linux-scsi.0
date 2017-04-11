From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 6/6] dm rq: Avoid that request processing stalls
 sporadically
Date: Tue, 11 Apr 2017 13:47:40 -0400
Message-ID: <20170411174739.GA19620@redhat.com>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
 <20170407181654.27836-7-bart.vanassche@sandisk.com>
 <20170411160958.GA19222@redhat.com>
 <1491928005.2654.6.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751620AbdDKRro (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Apr 2017 13:47:44 -0400
Content-Disposition: inline
In-Reply-To: <1491928005.2654.6.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>

On Tue, Apr 11 2017 at 12:26pm -0400,
Bart Van Assche <Bart.VanAssche@sandisk.com> wrote:

> On Tue, 2017-04-11 at 12:09 -0400, Mike Snitzer wrote:
> > This has no place in dm-mq (or any blk-mq
> > driver).  If it is needed it should be elevated to blk-mq core to
> > trigger blk_mq_delay_run_hw_queue() when BLK_MQ_RQ_QUEUE_BUSY is
> > returned from blk_mq_ops' .queue_rq.
> 
> Hello Mike,
> 
> If the blk-mq core would have to figure out whether or not a queue is no
> longer busy without any cooperation from the blk-mq driver all the blk-mq
> core could do is to attempt to rerun that queue from time to time. But at
> which intervals should the blk-mq core check whether or not a queue is still
> busy? Would it be possible to choose intervals at which to check the queue
> state that work well for all block drivers? Consider e.g. at the dm-mpath
> driver. multipath_busy() returns true as long as path initialization is in
> progress. Path initialization can take a long time. The (indirect) call to
> blk_mq_run_queue() from pg_init_done() resumes request processing immediately
> after path initialization has finished. Sorry but I don't think it is possible
> to invent an algorithm for the blk-mq core that guarantees not only that a
> queue is rerun as soon as it is no longer busy but also that avoids that
> plenty of CPU cycles are wasted by the blk-mq core for checking whether a
> queue is no longer busy.

Sorry but that isn't a very strong argument for what you've done.

I mean I do appreciate your point that the 2 BLK_MQ_RQ_QUEUE_BUSY
returns in dm_mq_queue_rq() are not equal but that could easily be
conveyed using a new return value.

Anyway, point is, no blk-mq driver should need to have concern about
whether their request will get resubmitted (and the associated hw queue
re-ran) if they return BLK_MQ_RQ_QUEUE_BUSY.

Your change is a means to an end but it just solves the problem in a
very hackish way.  Other drivers will very likely be caught about by
this blk-mq quirk in the future.
