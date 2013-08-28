From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch|rfc] block: fix race between request completion and timeout handling
Date: Wed, 28 Aug 2013 08:58:41 -0400
Message-ID: <x49sixuynsu.fsf@segfault.boston.devel.redhat.com>
References: <x49ppszqkbg.fsf@segfault.boston.devel.redhat.com>
	<521DA0F0.7060501@suse.de> <521DA913.1010505@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <521DA913.1010505@suse.de> (Hannes Reinecke's message of "Wed, 28
	Aug 2013 09:38:59 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: axboe@kernel.dk, JBottomley@parallels.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke <hare@suse.de> writes:

>> So, looked into things a bit more.
>> It looks as if you're on the right track, although I doubt your
>> patch will fix the issue for me :-(
>> 
>> Thing is, you're right there is a race window between requeuing
>> and softirq triggering, which could well be fixed by your patch.
>> So for that reason alone I would like to take it.
>> 
>> However, including your patch will end up opening another can of
>> worms: the softirq might now be triggering _while the request is
>> queued on the request queue_.
>> blk_requeue_request will be putting the request back on the request
>> queue, where it'll be stuck until being pulled off from
>> scsi_request_fn().
>> So if the softirq triggers during that condition we'll end up
>> calling the BUG_ON((!list_empty(&req->queuelist)) in
>> __blk_put_request().
>> 
>> Guess we'd need to fix that one, too ...
>> 
> Ah. Now I see it.
>
> We're requeuing from the softirq context, ie after the completion
> has triggered. So the above scenario can't actually happen and the
> patch is valid.

Do you still think it won't solve the issue you're seeing?  What issue
is that, btw?

>
> So:
>
> Acked-by: Hannes Reinecke <hare@suse.de>

Thanks, I guess I'll have to send a properly signed-off patch, now.  ;-)

Cheers,
Jeff
