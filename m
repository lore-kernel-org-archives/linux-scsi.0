From: Hannes Reinecke <hare@suse.de>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Wed, 25 Nov 2015 20:01:47 +0100
Message-ID: <5656059B.9010102@suse.de>
References: <1447838334.1564.2.camel@ellerman.id.au>
 <1447855399.3974.24.camel@redhat.com>
 <1447894964.15206.0.camel@ellerman.id.au>
 <20151119082325.GA11419@infradead.org> <564DEC41.5010600@suse.de>
 <1448030316.4067.18.camel@localhost.localdomain> <564F3453.9040603@suse.de>
 <1448033323.4067.24.camel@localhost.localdomain> <565579A2.4000005@suse.de>
 <20151125180133.GA18839@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbbKYTBy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Nov 2015 14:01:54 -0500
In-Reply-To: <20151125180133.GA18839@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: emilne@redhat.com, Christoph Hellwig <hch@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Mark Salter <msalter@redhat.com>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Jens Axboe <axboe@fb.com>

On 11/25/2015 07:01 PM, Mike Snitzer wrote:
> On Wed, Nov 25 2015 at  4:04am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
>
>> On 11/20/2015 04:28 PM, Ewan Milne wrote:
>>> On Fri, 2015-11-20 at 15:55 +0100, Hannes Reinecke wrote:
>>>> Can't we have a joint effort here?
>>>> I've been spending a _LOT_ of time trying to debug things here, bu=
t
>>>> none of the ideas I've come up with have been able to fix anything=
=2E
>>>
>>> Yes.  I'm not the one primarily looking at it, and we don't have a
>>> reproducer in-house.  We just have the one dump right now.
>>>
>>>>
>>>> I'm almost tempted to increase the count from scsi_alloc_sgtable()
>>>> by one and be done with ...
>>>>
>>>
>>> That might not fix it if it is a problem with the merge code, thoug=
h.
>>>
>> And indeed, it doesn't.
>
> How did you arrive at that?  Do you have a reproducer now?
>
Not a reproducer, but several dumps for analysis.

>> Seems I finally found the culprit.
>>
>> What happens is this:
>> We have two paths, with these seg_boundary_masks:
>>
>> path-1:    seg_boundary_mask =3D 65535,
>> path-2:    seg_boundary_mask =3D 4294967295,
>>
>> consequently the DM request queue has this:
>>
>> md-1:    seg_boundary_mask =3D 65535,
>>
>> What happens now is that a request is being formatted, and sent
>> to path 2. During submission req->nr_phys_segments is formatted
>> with the limits of path 2, arriving at a count of 3.
>> Now the request gets retried on path 1, but as the NOMERGE request
>> flag is set req->nr_phys_segments is never updated.
>> But blk_rq_map_sg() ignores all counters, and just uses the
>> bi_vec directly, resulting in a count of 4 -> boom.
>>
>> So the culprit here is the NOMERGE flag,
>
> NOMERGE is always set in __blk_rq_prep_clone() for cloned requests.
>
Yes.

>> which is evaluated via
>> ->dm_dispatch_request()
>>    ->blk_insert_cloned_request()
>>      ->blk_rq_check_limits()
>
> blk_insert_cloned_request() is the only caller of blk_rq_check_limits=
();
> anyway after reading your mail I'm still left wondering if your propo=
sed
> patch is correct.
>
>> If the above assessment is correct, the following patch should
>> fix it:
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 801ced7..12cccd6 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1928,7 +1928,7 @@ EXPORT_SYMBOL(submit_bio);
>>    */
>>   int blk_rq_check_limits(struct request_queue *q, struct request *r=
q)
>>   {
>> -       if (!rq_mergeable(rq))
>> +       if (rq->cmd_type !=3D REQ_TYPE_FS)
>>                  return 0;
>>
>>          if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q,
>> rq->cmd_flags)) {
>>
>>
>> Mike? Jens?
>> Can you comment on it?
>
> You're not explaining the actual change in the patch very well; I thi=
nk
> you're correct but you're leaving the justification as an exercise to
> the reviewer:
>
> blk_rq_check_limits() will call blk_recalc_rq_segments() after the
> !rq_mergeable() check but you're saying for this case in question we
> never get there -- due to the cloned request having NOMERGE set.
>
> So in blk_rq_check_limits() you've unrolled rq_mergeable() and
> open-coded the lone remaining check (rq->cmd_type !=3D REQ_TYPE_FS)
>
> I agree that the (rq->cmd_flags & REQ_NOMERGE_FLAGS) check in
> the blk_insert_cloned_request() call-chain (via rq_mergeable()) makes=
 no
> sense for cloned requests that always have NOMERGE set.
>
> So you're saying that by having blk_rq_check_limits() go on to call
> blk_recalc_rq_segments() this bug will be fixed?
>
That is the idea.

I've already established that in all instances I have seen so far
req->nr_phys_segments is _less_ than req->bio->bi_phys_segments.

As it turns out, req->nr_phys_segemnts _would_ have been updated in
blk_rq_check_limits(), but isn't due to the NOMERGE flag being set
for the cloned request.
So each cloned request inherits the values from the original request,
despite the fact that req->nr_phys_segments _has_ to be evaluated in
the final request_queue context, as the queue limits _might_ be=20
different from the original (merged) queue limits of the multipath
request queue.

> BTW, I think blk_rq_check_limits()'s export should be removed and the
> function made static and renamed to blk_clone_rq_check_limits(), agai=
n:
> blk_insert_cloned_request() is the only caller of blk_rq_check_limits=
()
>
Actually, seeing Jens' last comment the check for REQ_TYPE_FS is=20
pointless, too, so we might as well remove the entire if-clause.

> Seems prudent to make that change now to be clear that this code is o=
nly
> used by cloned requests.
>
Yeah, that would make sense. I'll be preparing a patch.
With a more detailed description :-)

Cheers,

Hannes

--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
