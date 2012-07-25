From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
Date: Wed, 25 Jul 2012 16:26:42 +0300
Message-ID: <500FF412.3090600@panasas.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <500FEB63.3000709@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/25/2012 03:49 PM, Paolo Bonzini wrote:

> 
> Except here the destination array has to be given to virtio, which
> doesn't (yet) understand chaining.  I'm using for_each_sg rather than a
> simple memcpy exactly because I want to flatten the input scatterlist
> onto consecutive scatterlist entries, which is what virtio expects (and
> what I'll change when I get to it).
> 
> for_each_sg guarantees that I get non-chain scatterlists only, so it is
> okay to value-assign them to sg[].
> 


So if the virtio does not understand chaining at all then surly it will
not understand the 2-bit end marker and will get a wrong page pointer
with the 1st bit set.

As I said!! Since the last code did sg_set_buff() and worked then you must
change it with sg_set_page().

If there are *any* chaining-or-no-chaining markers errors these should
be fixed as a separate patch!

Please lets concentrate at the problem at hand.

<snip>

> 
> It was _not_ properly terminated, and didn't matter because virtio
> doesn't care about termination.  Changing all the virtio devices to
> properly terminate chains (and to use for_each_sg) is a prerequisite for
> properly supporting long sglists).
> 


Fine then your code is now a crash because the terminating bit was just
copied over, which it was not before.

------------
Now Back to the how to support chaining:

Lets separate the two topics from now on. Send me one mail concerning
the proper above patch, And a different mail for how to support chaining.

>> In SCSI land most LLDs should support chaining just by virtu of using the
>> for_each_sg macro. That all it takes. Your code above does support it.
> 
> Yes, it supports it but still has to undo them before passing to virtio.
> 
> What my LLD does is add a request descriptor in front of the scatterlist
> that the LLD receives.  I would like to do this with a 2-item
> scatterlist: one for the request descriptor, and one which is a chain to
> the original scatterlist.  


I hate that plan. Why yet override the scatter element yet again with a third
union of a "request descriptor"

The reason it was overloaded as a link-pointer in the first place was because
of historical compatibility reasons and not because of a good design.

You should have a proper "request descriptor" structure defined, pointing to
(or followed by), an sglist-chain. And all of the above is mute.
 

> Except that if I call sg_chain and my
> architecture does not define ARCH_HAS_SG_CHAIN, it will BUG out.  So I
> need to keep all the scatterlist allocation and copying crap that I have
> now within #ifdef, and it will bitrot.
> 


except that with the correct design you don't call sg_chain you just do:
	request_descriptor->sg_list = sg;

>>> I would need to add support for the long sglists to virtio; this is not
>>> a problem, but in the past Rusty complained that long sg-lists are not
>>> well suited to virtio (which would like to add elements not just at the
>>> beginning of a given sglist, but also at the end).  
>>
>> Well that can be done as well, (If done carefully) It should be easy to add
>> chained fragments to both the end of a given chain just as at beginning.
>> It only means that the last element of the appended-to chain moves to
>> the next fragment and it's place is replaced by a link.
> 
> But you cannot do that in constant time, can you?  And that means you do
> not enjoy any benefit in terms of cache misses etc.
> 


I did not understand "constant time" it is O(0) if that what you meant.

(And surly today's code of copy the full list "cache misses")

> Also, this assumes that I can modify the appended-to chain.  I'm not
> sure I can do this?
> 


Each case it's own. If the appended-to chain is const, yes you'll have
to reallocate it and copy. Is that your case?

Cheers
Boaz

>>> It seems to me that virtio would prefer to work with a struct
>>> scatterlist ** rather than a long sglist.
>>
>> That's just going backwards, and lazy. As you said if you want to enjoy
>> the better performance cake you better break some eggs ;-)
> 
> :)
> 
> Paolo
