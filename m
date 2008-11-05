From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 04/18] libosd: OSDv1 preliminary implementation
Date: Wed, 05 Nov 2008 15:44:36 +0200
Message-ID: <4911A344.7090803@panasas.com>
References: <491073BB.4000900@panasas.com>	<1225817069-5969-1-git-send-email-bharrosh@panasas.com> <20081104111631.5eb9aaf6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755976AbYKENoy@vger.kernel.org>
In-Reply-To: <20081104111631.5eb9aaf6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sami.Iren@seagate.com, pw@padd.com
List-Id: linux-scsi@vger.kernel.org

Andrew Morton wrote:
> On Tue,  4 Nov 2008 18:44:29 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> Implementation of the most basic OSD functionality and
>> infrastructure. Mainly Format, Create/Remove Partition,
>> Create/Remove Object, and read/write.
>>
>>
>> ...
>>
>> +struct osd_request *_osd_request_alloc(gfp_t gfp)
>> +{
>> +	struct osd_request *or;
>> +
>> +	/* TODO: Use mempool with one saved request */
>> +	or = kzalloc(sizeof(*or), gfp);
>> +	return or;
>> +}
>> +
>> +void _osd_request_free(struct osd_request *or)
>> +{
>> +	kfree(or);
>> +}
> 
> These two functions can/should be made static.  Please generally check
> for this.
> 

Thanks, I usually do, but these are from the last iteration and were
rushed in. Will fix.

> Also it'd probably make sense to declare both these inline.  The
> compiler _shoudl_ get it right, but stranger things have happened...
> 

I do not inline them, because one - I will use mem_pools very soon they
are just place holders for now. two - I let the compiler
do that, I made sure the only user is below the definition and I let
the compiler decide. I like to leave these things controlled from outside,
so when I compile a UML kernel and finally need to fire up a debugger,
I can un-inline them very easily.

(This is why I hate forward declarations. If they are not used
 it is a proof that inlineing of single callers will always happen.)

>> ...
>>
>> +/*
>> + * If osd_finalize_request() was called but the request was not executed through
>> + * the block layer, then we must release BIOs.
>> + */
>> +static void _abort_unexecuted_bios(struct request *rq)
>> +{
>> +	struct bio *bio;
>> +
>> +	while ((bio = rq->bio) != NULL) {
>> +		rq->bio = bio->bi_next;
>> +		bio_endio(bio, 0);
>> +	}
>> +}
> 
> Boy, that's a scary function.  bye-bye data.
> 

Thank's for mentioning that. I use it at the very end just before
the de-allocation of the block request. What happens today is: that
if for some reason the driver failed to call blk_end_request, 
or in this case the driver was never called, the last blk_put_request()
will leak BIOs. There are currently corner cases and bugs in the Kernel
that cause exactly that.

That loop above should be moved from here to inside blk_put_request().
if some one needs to hold the BIOs longer then the life span of the request they
should simply inc-ref them.

Note that here it is totally safe since It's only called just before
blk_put_request().

This code is actually a bug fix, for the error cases when a request is allocated
but is never executed do to other error returns.

Thanks
Boaz
