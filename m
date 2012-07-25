From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
Date: Wed, 25 Jul 2012 15:34:26 +0300
Message-ID: <500FE7D2.7070101@panasas.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <500FBF37.50603@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/25/2012 12:41 PM, Paolo Bonzini wrote:

> Il 25/07/2012 11:22, Boaz Harrosh ha scritto:
>>>>>>  	for_each_sg(table->sgl, sg_elem, table->nents, i)
>>>>>> -		sg_set_buf(&sg[idx++], sg_virt(sg_elem), sg_elem->length);
>>>>>> +		sg_set_page(&sg[idx++], sg_page(sg_elem), sg_elem->length,
>>>>>> +			sg_elem->offset);
>>>>
>>>> This can simply be
>>>>
>>>>    sg[idx++] = *sg_elem;
>>>>
>>>> Can you repost it with this change, and also add stable@vger.kernel.org
>>>> to the Cc?  Thanks very much!
>>>>
>>
>> No! Please use sg_set_page()! Look at sg_set_page(), which calls sg_assign_page().
>> It has all these jump over chained arrays. When you'll start using long
>> sg_lists (which you should) then jumping from chain to chain must go through
>> sg_page(sg_elem) && sg_assign_page(), As in the original patch.
> 
> Hi Boaz,
> 
> actually it seems to me that using sg_set_page is wrong, because it will
> not copy the end marker from table->sgl to sg[].  If something chained
> the sg[] scatterlist onto something else, sg_next's test for sg_is_last
> would go beyond the table->nents-th item and access invalid memory.
> 


Yes, you did not understand this structure. And Yes I am right, when
using chained lists you *must* use sg_set_page().

You see the chaining belongs to the allocation not the value of the
sg-elements. One must not copy the chaining marker to the destination
array which might have it's own. And one must not crap all over the
destination chaining markers, set at allocation time.

The sizes and mostly the pointers of source and destination are not
the same.

> Using chained sglists is on my to-do list, I expect that it would make a
> nice performance improvement.  However, I was a bit confused as to
> what's the plan there; there is hardly any user, and many arches still
> do not define ARCH_HAS_SG_CHAIN.  Do you have any pointer to discussions
> or LWN articles?
> 


Only the source code I'm afraid.

In SCSI land most LLDs should support chaining just by virtu of using the
for_each_sg macro. That all it takes. Your code above does support it.
(In Wang version).

Though more code need probably be added at sg allocation to actually
allocate and prepare a chain.

> I would need to add support for the long sglists to virtio; this is not
> a problem, but in the past Rusty complained that long sg-lists are not
> well suited to virtio (which would like to add elements not just at the
> beginning of a given sglist, but also at the end).  


Well that can be done as well, (If done carefully) It should be easy to add
chained fragments to both the end of a given chain just as at beginning.

It only means that the last element of the appended-to chain moves to
the next fragment and it's place is replaced by a link.

If you have ready made two long segments A and C which you would like not
to reallocate and copy, you insert a two-elements segment in the middle, say
call it B.

The first element of B is the last element of A which is now used as the pointer
to B, and the 2nd element of B is a pointer to C.

> It seems to me that
> virtio would prefer to work with a struct scatterlist ** rather than a
> long sglist.
> 


That's just going backwards, and lazy. As you said if you want to enjoy
the better performance cake you better break some eggs ;-)

> Paolo


Cheers
Boaz
