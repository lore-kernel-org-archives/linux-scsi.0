From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Fri, 5 Jun 2009 22:25:01 +0200
Message-ID: <64bb37e0906051325t5eab883excf9e58aaf7cef3b@mail.gmail.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
	 <20090605104132.GE24836@amd.com>
	 <64bb37e0906050852g2be64c7elb2872a6129d13f56@mail.gmail.com>
	 <20090605182015.GA10342@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:35091 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZFEUZA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2009 16:25:00 -0400
In-Reply-To: <20090605182015.GA10342@8bytes.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu, lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jun 5, 2009 at 8:20 PM, Joerg Roedel <joro@8bytes.org> wrote:
> On Fri, Jun 05, 2009 at 05:52:27PM +0200, Torsten Kaiser wrote:
>>
>> This doesn't look right to me.
>> The comment above says "returns the entry from the hash which fits
>> best", but this will always return NULL, if there are are multiple
>> entrys, but no perfect match.
>
> This is intentional. If there is no perfect-fit there is no way to tell
> which entry was meant. So we potentially report wrong errors with a
> wrong mapping backtrace which confuses even more than the wrong
> "DMA-API: device driver tries to free DMA memory it has not allocated".

Ah, OK.
I thought that reporting a (maybe) wrong difference in map/unmap would
be better that a definitely wrong message "freed not allocated
memory". And if the fuzzy matcher would warn about the fuzzy match, a
developer would know that this difference might be wrong.

>> Should there be a warning if more then one possible match were found?
>
> True. That would be better. But I tried to keep the code change as small
> as possible without disabling the feature completly.

OK, it just looked like the code did something else the comment said.

>> * driver maps address 'a' with size 1
>> * driver maps same address 'a' with size 2
>> * driver wrongly unmaps the second allocation with size 1
>>   -> no warning, because the first allocation is returned
>
> Hmm, I am not sure if we can handle this situation correctly in the
> dma-debug code. There is no unique key to identify a mapping request
> which allows to assign an unmap request to it. Currently dma-debug uses
> device and dma-address. But that seems not to be sufficient. The
> best-fit algorithm is also a but fuzzy of course.

Yes, I just read pci-gart_64.c to see if there is a better key.
The API always seems to include size and direction too.

Would it work to to use all device, address, size and direction as
key, as the proposes exact matcher does?
This would obvious not work with the current diagnostics in
check_unmap, as not even single near matches would be returned.
But if you would move the diagnostics from check_unmap into
hash_bucket_find it could work:
If hash_bucket_find does not find a perfect match, it could output:
* no match -> tries to free DMA memory it has not allocated
* 1 match -> warn about any differences (size, type, cpu-address, sg
list count, direction)
* 2+ matches, with perfect match -> no warning; set flag in other matches.
* 2+ matches, without perfect match -> list differences from all
matches; set flag in other matches after returning the best

If differences from a flagged match are output, add a note, that this
warning is unreliable because of these possible map/unmap mismatches.

>> * driver wants to correctly unmap the first allocation
>>   -> wrong warning about this unmap because size mismatch
>
> Ok, at least we get a warning about a bug. Not very useful because it
> reports the wrong bug. Is this the situation which triggered the
> original bug report?

No, the original report was with a correctly working driver that just
confused the dma-debugging code into issuing wrong warnings:
http://marc.info/?l=linux-kernel&m=124336530609750&w=2

This constructed case was just me trying to find more evil cases that
are currently not covered.

Your patch would blame the correctly programmed second unmap for
"freeing unallocated memory",
my proposal would blame it for the size difference, but with a note
that there was a concurrent second map at the same address.

And in a case where the code maps the same address twice but wants to
unmap it wrong, it would correctly output both possible, but
mismatching maps, instead of the wrong "unallocated memory" warning.

>> Also what about sg_call_ents and sg_mapped_ents?
>> Could it be possible to get the same address/size with different sg-counts.
>
> It looks not forbidden in the API. So I guess this can happen too.

Should it then be added to the fuzzy matcher?
Otherwise I would except the warnings like "DMA-API: device driver
frees DMA sg list with different entry count [map count=2] [unmap
count=1]" to still trigger. (I didn't have the time to test your patch
yet)

Torsten
