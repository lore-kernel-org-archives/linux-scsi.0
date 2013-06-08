From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/3] lib/scatterlist: introduce sg_pcopy_from_buffer() and sg_pcopy_to_buffer()
Date: Sat, 8 Jun 2013 23:28:04 +0900
Message-ID: <CAC5umyi0By0hd5RSvhODjdx=1ExAdigDaiGDu-tYD7t4s2FYGw@mail.gmail.com>
References: <1370523178-5437-1-git-send-email-akinobu.mita@gmail.com>
	<1370523178-5437-2-git-send-email-akinobu.mita@gmail.com>
	<20130606210041.GD5045@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:41721 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3FHO2E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Jun 2013 10:28:04 -0400
In-Reply-To: <20130606210041.GD5045@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Imre Deak <imre.deak@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

2013/6/7 Tejun Heo <tj@kernel.org>:
> Hello,
>
> On Thu, Jun 06, 2013 at 09:52:56PM +0900, Akinobu Mita wrote:
>> +static bool sg_miter_get_next_page(struct sg_mapping_iter *miter)
>> +{
>> +     if (!miter->__remaining) {
>> +             struct scatterlist *sg;
>> +             unsigned long pgoffset;
>> +
>> +             if (!__sg_page_iter_next(&miter->piter))
>> +                     return false;
>> +
>> +             sg = miter->piter.sg;
>> +             pgoffset = miter->piter.sg_pgoffset;
>> +
>> +             miter->__offset = pgoffset ? 0 : sg->offset;
>> +             miter->__remaining = sg->offset + sg->length -
>> +                             (pgoffset << PAGE_SHIFT) - miter->__offset;
>> +             miter->__remaining = min_t(unsigned long, miter->__remaining,
>> +                                        PAGE_SIZE - miter->__offset);
>> +     }
>> +
>> +     return true;
>> +}
>
> It'd be better if separating out this function is a separate patch.
> Mixing factoring out something and adding new stuff makes the patch a
> bit harder to read.

OK, sounds good. I'll do so in next version.

But I feel sg_miter_get_next_page() is not very appropriate name, because
it gets the next page only if necessary.  If I can find more appropriate name,
I'll rename it.

>> +static bool sg_miter_seek(struct sg_mapping_iter *miter, off_t offset)
>> +{
>> +     WARN_ON(miter->addr);
>> +
>> +     while (offset) {
>> +             off_t consumed;
>> +
>> +             if (!sg_miter_get_next_page(miter))
>> +                     return false;
>> +
>> +             consumed = min_t(off_t, offset, miter->__remaining);
>> +             miter->__offset += consumed;
>> +             miter->__remaining -= consumed;
>> +             offset -= consumed;
>> +     }
>> +
>> +     return true;
>> +}
>
> While I think the above should work at the beginning, what if @miter
> is in the middle of iteration and __remaining isn't zero?

sg_miter_seek() should work as far as it is called just after sg_miter_start(),
or just after sg_miter_stop() in the middle of iteration (Although I only
tested the former case).  I omitted a function comment in excuse of the static
function, but I should write something I said above.
