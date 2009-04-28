From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/3 v3] osdblk: a Linux block device for OSD objects
Date: Tue, 28 Apr 2009 12:40:05 +0300
Message-ID: <49F6CEF5.5090203@panasas.com>
References: <20090402015455.GA14087@havoc.gtf.org> <20090407225302.GA14248@havoc.gtf.org> <20090410114821.GA10602@havoc.gtf.org> <20090410114908.GB10602@havoc.gtf.org> <20090410115045.GC10602@havoc.gtf.org> <49F5D66E.2040506@panasas.com> <20090427182434.GD4593@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090427182434.GD4593@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@HansenPartnership.com, osd-dev@open-osd.org, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 04/27/2009 09:24 PM, Jens Axboe wrote:
> On Mon, Apr 27 2009, Boaz Harrosh wrote:

Jens Hi, Thanks for your reply. Please I need some help with
this.

>>> +static struct bio *bio_chain_clone(struct bio *old_chain, gfp_t gfpmask)
>>> +{
>>> +	struct bio *tmp, *new_chain = NULL, *tail = NULL;
>>> +
>>> +	while (old_chain) {
>>> +		tmp = bio_clone(old_chain, gfpmask);
>>> +		if (!tmp)
>>> +			goto err_out;
>>> +
>>> +		tmp->bi_next = NULL;
>>> +		if (!new_chain)
>>> +			new_chain = tail = tmp;
>>> +		else {
>>> +			tail->bi_next = tmp;
>>> +			tail = tmp;
>>> +		}
>>> +
>>> +		old_chain = old_chain->bi_next;
>>> +	}
>>> +
>>> +	return new_chain;
>>> +
>>> +err_out:
>>> +	bio_chain_put(new_chain);
>>> +	return NULL;
>>> +}
>>> +
>> NOTE-TO-ME:
>>   blk_bio_clone()
> 
> Note to Boaz - this is illegal, unless gfp_mask is GFP_ATOMIC (in which
> case you should not pass it in). 

OK it is only used with GFP_ATOMIC.
Theoretically, what if I use a thread and am aloud to sleep,
(and executing requests in serial). Can I then wait on the first bio_clone.

> The only way to make this work is to:
> 

Are you saying that, in the case I'm a swap device? or do you mean that if I
use the above code I can break it for other devices that are swap-devices
and cause a live lock for them.

Currently the OSD library is not swap safe. And even if it was, iSCSI is not.
So there is no option of this ever been swap.

> 1) Have a private bio pool, and

Do I need to manage such a pool internally and use __bio_clone() or is there
an easy way to associate a private bio-pool to a request_queue?

> 2) Make sure it has enough reserved entries to populate the chain

Is there a system limit to that, that I can be sure of? Or just choose
a magic number and if it is exceeded just split the io up in parts?

> 3) Ensure only a single caller at the time, or entries enough for the N
>    users that are allowed. It has to be controlled either way, whether N
>    is 1 or larger.

osdblk_rq_fn (the queue fn) is it serialized to one thread? If not
could I use the queue lock for the duration of the clone?

> 

Thanks for your help
Boaz
