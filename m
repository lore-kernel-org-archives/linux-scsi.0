From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] [PATCH v5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 30 Jan 2018 13:38:44 -0500
Message-ID: <1517337524.15224.0.camel@redhat.com>
References: <20180130142459.52668-1-snitzer@redhat.com>
         <43ac2314-c98d-bb76-0dfb-171d15cc5fd8@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <43ac2314-c98d-bb76-0dfb-171d15cc5fd8@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2018-01-30 at 09:52 -0800, Bart Van Assche wrote:
> On 01/30/18 06:24, Mike Snitzer wrote:
> > +		 *
> > +		 * If driver returns BLK_STS_RESOURCE and
> > SCHED_RESTART
> > +		 * bit is set, run queue after a delay to avoid IO
> > stalls
> > +		 * that could otherwise occur if the queue is
> > idle.
> >   		 */
> > -		if (!blk_mq_sched_needs_restart(hctx) ||
> > +		needs_restart = blk_mq_sched_needs_restart(hctx);
> > +		if (!needs_restart ||
> >   		    (no_tag && list_empty_careful(&hctx-
> > >dispatch_wait.entry)))
> >   			blk_mq_run_hw_queue(hctx, true);
> > +		else if (needs_restart && (ret ==
> > BLK_STS_RESOURCE))
> > +			blk_mq_delay_run_hw_queue(hctx,
> > BLK_MQ_QUEUE_DELAY);
> >   	}
> 
> If a request completes concurrently with execution of the above code 
> then the request completion will trigger a call of 
> blk_mq_sched_restart_hctx() and that call will clear the 
> BLK_MQ_S_SCHED_RESTART bit. If that bit is cleared before the above
> code 
> tests it then the above code will schedule an asynchronous call of 
> __blk_mq_run_hw_queue(). If the .queue_rq() call triggered by the
> new 
> queue run returns again BLK_STS_RESOURCE then the above code will be 
> executed again. In other words, a loop occurs. That loop will repeat
> as 
> long as the described race occurs. The current (kernel v4.15) block 
> layer behavior is simpler: only block drivers call 
> blk_mq_delay_run_hw_queue() and the block layer core never calls
> that 
> function. Hence that loop cannot occur with the v4.15 block layer
> core 
> and block drivers. A motivation of why that loop is preferred
> compared 
> to the current behavior (no loop) is missing. Does this mean that
> that 
> loop is a needless complication of the block layer core?
> 
> Sorry but I still prefer the v4.15 block layer approach because this 
> patch has in my view the following disadvantages:
> - It involves a blk-mq API change. API changes are always risky and
> need
>    some time to stabilize.
> - The delay after which to rerun the queue is moved from block layer
>    drivers into the block layer core. I think that's wrong because
> only
>    the block driver authors can make a good choice for this constant.
> - This patch makes block drivers harder to understand. Anyone who
> sees
>    return BLK_STS_RESOURCE / return BLK_STS_DEV_RESOURCE for the
> first
>    time will have to look up the meaning of these constants. An
> explicit
>    blk_mq_delay_run_hw_queue() call is easier to understand.
> - This patch makes the blk-mq core harder to understand because of
> the
>    loop mentioned above.
> - This patch does not fix any bugs nor makes block drivers easier to
>    read or to implement. So why is this patch considered useful?
> 
> Thanks,
> 
> Bart.

Hello Bart

What is the performance implication of your method versus this patch
above.
Is there more of a delay in your approach or in Ming's approach from
your own testing.
I guess it seems we will never get consensus on this so is it time to
take a vote. 

I respect and trust your inputs, you know that, but are you perhaps
prepared to accept the approach above and agree to it and if it turns
out to expose more issues it can be addressed later.

Is that not a better way to progress this because to me it looks like
you and Ming will continue to disagree on which is the better approach.

With much respect
Laurence
