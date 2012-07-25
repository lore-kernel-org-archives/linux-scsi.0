From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
Date: Wed, 25 Jul 2012 14:49:39 +0200
Message-ID: <500FEB63.3000709@redhat.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <500FE7D2.7070101@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 25/07/2012 14:34, Boaz Harrosh ha scritto:
>>>>>>>  	for_each_sg(table->sgl, sg_elem, table->nents, i)
>>>>>>> -		sg_set_buf(&sg[idx++], sg_virt(sg_elem), sg_elem->length);
>>>>>>> +		sg_set_page(&sg[idx++], sg_page(sg_elem), sg_elem->length,
>>>>>>> +			sg_elem->offset);
>>>>>
>>>>> This can simply be
>>>>>
>>>>>    sg[idx++] = *sg_elem;
>>>>>
>>>
>>> No! Please use sg_set_page()! Look at sg_set_page(), which calls sg_assign_page().
>>> It has all these jump over chained arrays. When you'll start using long
>>> sg_lists (which you should) then jumping from chain to chain must go through
>>> sg_page(sg_elem) && sg_assign_page(), As in the original patch.
>>
>> actually it seems to me that using sg_set_page is wrong, because it will
>> not copy the end marker from table->sgl to sg[].  If something chained
>> the sg[] scatterlist onto something else, sg_next's test for sg_is_last
>> would go beyond the table->nents-th item and access invalid memory.
> 
> 
> Yes, you did not understand this structure. And Yes I am right, when
> using chained lists you *must* use sg_set_page().
> 
> You see the chaining belongs to the allocation not the value of the
> sg-elements. One must not copy the chaining marker to the destination
> array which might have it's own.

Except here the destination array has to be given to virtio, which
doesn't (yet) understand chaining.  I'm using for_each_sg rather than a
simple memcpy exactly because I want to flatten the input scatterlist
onto consecutive scatterlist entries, which is what virtio expects (and
what I'll change when I get to it).

for_each_sg guarantees that I get non-chain scatterlists only, so it is
okay to value-assign them to sg[].

(Replying to your other message,

> No this code is correct, though you will need to make sure to properly
> terminate the destination sg_list.
> 
> But since old code was using sg_set_buf(), than it means it was properly
> terminated before, and there for this code is good as is please don't
> touch it.

It was _not_ properly terminated, and didn't matter because virtio
doesn't care about termination.  Changing all the virtio devices to
properly terminate chains (and to use for_each_sg) is a prerequisite for
properly supporting long sglists).

> In SCSI land most LLDs should support chaining just by virtu of using the
> for_each_sg macro. That all it takes. Your code above does support it.

Yes, it supports it but still has to undo them before passing to virtio.

What my LLD does is add a request descriptor in front of the scatterlist
that the LLD receives.  I would like to do this with a 2-item
scatterlist: one for the request descriptor, and one which is a chain to
the original scatterlist.  Except that if I call sg_chain and my
architecture does not define ARCH_HAS_SG_CHAIN, it will BUG out.  So I
need to keep all the scatterlist allocation and copying crap that I have
now within #ifdef, and it will bitrot.

>> I would need to add support for the long sglists to virtio; this is not
>> a problem, but in the past Rusty complained that long sg-lists are not
>> well suited to virtio (which would like to add elements not just at the
>> beginning of a given sglist, but also at the end).  
> 
> Well that can be done as well, (If done carefully) It should be easy to add
> chained fragments to both the end of a given chain just as at beginning.
> It only means that the last element of the appended-to chain moves to
> the next fragment and it's place is replaced by a link.

But you cannot do that in constant time, can you?  And that means you do
not enjoy any benefit in terms of cache misses etc.

Also, this assumes that I can modify the appended-to chain.  I'm not
sure I can do this?

>> It seems to me that virtio would prefer to work with a struct
>> scatterlist ** rather than a long sglist.
> 
> That's just going backwards, and lazy. As you said if you want to enjoy
> the better performance cake you better break some eggs ;-)

:)

Paolo
