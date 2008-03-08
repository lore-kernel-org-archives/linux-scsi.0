From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] blk: missing add of padded bytes to io completion byte
   count
Date: Sat, 08 Mar 2008 10:06:30 +0900
Message-ID: <47D1E696.5060308@gmail.com>
References: <20080306134146A.fujita.tomonori@lab.ntt.co.jp>	<20080306134138.GF17940@kernel.dk>	<47D0873B.6090705@gmail.com> <20080308000718H.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080308000718H.tomof@acm.org>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Fri, 07 Mar 2008 09:07:23 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Jens Axboe wrote:
>>>>> If we want the use paradigm shared between block and driver, then I
>>>>> think the best approach is to keep all the bios the same (so not adjust
>>>>> for padding), but do adjust in the blk_rq_map_sg().  That way we have
>>>>> the padding and draining unwind information by comparing with the bio.
>>>> Adjusting only sg in blk_rq_map_sg (like drain) looks much
>>>> better. This works with libata for me.
>>> Looks like a much better solution to me. Anyone have any valid
>>> objections against moving the padding to the sg map time?
>> Not necessarily objections but some concerns.
>>
>> * As completion is done in bio terms, it makes completion from LLDs a
>> bit cumbersome, but this is unavoidable if we break sum(bio) == sum(sg).
> 
> What do you mean? How does sub(bio) affect LLDs?

LLDs which loop over sg's trying to complete rq incrementally will see
rq going away sooner than it expected.

>> * I've been wondering why we are not using sg chain / table or whatever
>> directly in bios and maybe rq_map_sg can go away in future.
> 
> You mean that LLDs use bios directly? For me, sg and bio have very
> different objectives and it's a clean layer separation.

Actually the other way, block layer use sg instead of bio_vec in bio.
Layer separation doesn't necessarily require copying about the same
information to differently formatted data structure.  I'm not sure it
will be a clean win tho.  Requests hang longer in scheduler queue and
and bio_vec is smaller and scatterlist.

The thing is that, to me, blk_rq_map_sg() doesn't really look necessary,
it can be done just as well when the request is fetched from the queue
by block driver. (continued below...)

>> How about separating out the padding / draining adjustment into a
>> separate interface?  Say, blk_rq_apply_extra() and blk_rq_undo_extra()
>> and make it the responsibility of the LLD which requested
>> padding/draining to apply and undo the adjustments?  It can undo the
>> adjustments when it returns the the request to its upper layer.  If rq
>> completion is handled by upper layer, it will do the right thing.  If rq
>> completion is handled by LLD, it can see the bio it wants to see.
> 
> If possible, I'd like to avoid creating APIs for them. I think that
> the current approach is much better than such APIs.

And, so, I'm not too sure whether putting more mechanisms into it is a
good idea.

Thanks.

-- 
tejun
