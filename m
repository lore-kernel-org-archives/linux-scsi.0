From: Ewan Milne <emilne@redhat.com>
Subject: Re: [patch] block: fix race between request completion and timeout
 handling
Date: Tue, 10 Sep 2013 13:35:39 -0400
Message-ID: <1378834539.3872.6443.camel@localhost.localdomain>
References: <x49k3j4s41j.fsf@segfault.boston.devel.redhat.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab3IJRfs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Sep 2013 13:35:48 -0400
In-Reply-To: <x49k3j4s41j.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On Thu, 2013-08-29 at 15:14 -0400, Jeff Moyer wrote:
...
> RIP: 0010:[<ffffffff8124e424>]  [<ffffffff8124e424>] blk_requeue_request+0x94/0xa0
...
> Call Trace:
>  [<ffffffff81362323>] __scsi_queue_insert+0xa3/0x150
>  [<ffffffff8135f393>] ? scsi_eh_ready_devs+0x5e3/0x850
>  [<ffffffff81362a23>] scsi_queue_insert+0x13/0x20
>  [<ffffffff8135e4d4>] scsi_eh_flush_done_q+0x104/0x160
>  [<ffffffff8135fb6b>] scsi_error_handler+0x35b/0x660
>  [<ffffffff8135f810>] ? scsi_error_handler+0x0/0x660
>  [<ffffffff810908c6>] kthread+0x96/0xa0
>  [<ffffffff8100c14a>] child_rip+0xa/0x20
>  [<ffffffff81090830>] ? kthread+0x0/0xa0
>  [<ffffffff8100c140>] ? child_rip+0x0/0x20
...
> The RIP is this line:
>         BUG_ON(blk_queued_rq(rq));
> 
> After digging through the code, I think there may be a race between the
> request completion and the timer handler running.
> 

So, it does seem that if a request completes within a certain window in
blk_rq_timed_out() (and part of its call to blk_add_timer()...)

---- in blk_rq_timed_out():

        ret = q->rq_timed_out_fn(req);
        switch (ret) {
        case BLK_EH_HANDLED:
                __blk_complete_request(req);
                break;
        case BLK_EH_RESET_TIMER:
                blk_clear_rq_complete(req);          <<---- AFTER HERE
                blk_add_timer(req);
                break;

---- in blk_add_timer():
      
	BUG_ON(!list_empty(&req->timeout_list));
        BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));

        /*                                                                                                                                                                                                         
         * Some LLDs, like scsi, peek at the timeout to prevent
a                                                                                                                                                  
         * command from being retried
forever.                                                                                                                                                                     
         */
        if (!req->timeout)
                req->timeout = q->rq_timeout;

        req->deadline = jiffies + req->timeout;
        list_add_tail(&req->timeout_list, &q->timeout_list);
						    <<---- BEFORE HERE

...then there are problems.  If the request completes before the
BUG_ON(test_bit(REQ_ATOM_COMPLETE).. then there will be a crash.
If the request completes before the list_add_tail(&req->timeout_list...
then a completed request will eventually get a timeout, or we might
crash in blk_add_timer when the timer is being restarted for the next
usage of the request.

Jeff's proposed patch, which swaps the order of clearing the
REQ_ATOM_COMPLETE flag and the call to blk_add_timer in blk_rq_timed_out
along with moving the BUG_ON to a different place in the req lifecycle,
avoids these problems, but opens up another potential issue.  Consider:

---- in blk_rq_timed_out_timer():

                        if (blk_mark_rq_complete(rq))
                                continue;
                        blk_rq_timed_out(rq);

---- in new blk_rq_timed_out():

        ret = q->rq_timed_out_fn(req);
        switch (ret) {
        case BLK_EH_HANDLED:
                __blk_complete_request(req);
                break;
        case BLK_EH_RESET_TIMER:
                blk_add_timer(req);
		blk_clear_req_complete(req);
                break;

If the request completes after blk_mark_rq_complete() is called but
before blk_clear_req_complete() is called, the completion will not be
processed, and we will have to wait for the request to timeout again.
Maybe this is not so bad, as it should be extremely rare, but if the
timeout were a large value for some reason, that could be a problem.

It seems to me that the issue is really that there are 2 state variables
(the REQ_ATOM_COMPLETE flag and the req->timeout_list) for the same
state, and so manipulating both of these without a lock will always have
a window.

Clearly it would be better to avoid a panic, so Jeff's fix would help.

I'm not sure I follow how the issue Jeff is fixing caused this
particular crash, though.  How did the request get back on the queue?
The crash occurred when the SCSI EH was flushing the done_q requests.

-Ewan



