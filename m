From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
 padding in favour of that provided by the block layer
Date: Tue, 05 Feb 2008 10:07:02 +0900
Message-ID: <47A7B6B6.2050801@gmail.com>
References: <1199138168.3110.12.camel@localhost.localdomain>	 <1200698057.3111.68.camel@localhost.localdomain>	 <1201894847.3134.59.camel@localhost.localdomain>	 <47A37AF3.3030503@garzik.org>	 <1201900175.3134.67.camel@localhost.localdomain> <47A52F23.70506@gmail.com>	 <1202013174.3187.69.camel@localhost.localdomain>	 <47A56F2B.4040904@gmail.com>	 <1202049511.3318.13.camel@localhost.localdomain>	 <47A5DA5F.3070209@gmail.com>	 <1202055156.3318.58.camel@localhost.localdomain>	 <47A66A39.7090800@gmail.com> <47A6D9F2.5060102@gmail.com>	 <47A72475.5040106@gmail.com>	 <1202142222.3096.26.camel@localhost.localdomain>	 <47A7A887.2040307@gmail.com>	 <1202171564.3096.147.camel@localhost.localdomain>	 <47A7B11C.10607@gmail.com> <1202172826.3096.163.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:31102 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbYBEBHL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 20:07:11 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1583349rvb.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Feb 2008 17:07:10 -0800 (PST)
In-Reply-To: <1202172826.3096.163.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

James Bottomley wrote:
>>>> No, it doesn't.  Drain needs to extend the sg table too 
>>> The patches do extend the sg table.
>> Hmm... Where?
> 
> It's the block component; it's already in git head with this patch:
> 
> commit fa0ccd837e3dddb44c7db2f128a8bb7e4eabc21a
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Thu Jan 10 11:30:36 2008 -0600
> 
>     block: implement drain buffers
> 
> The description is pretty reasonable.  The way it works is by making
> block add the drain buffer to the sg table as the last element.
> 
> The way it works is if you simply use the length block gives you, you
> find yourself doing DMA to every element in the sg table except the last
> one.  If you expand the length to anything up to blk_rq_drain_size() you
> then use the last element for the drain.

Oops, I was talking about padding.  Sorry about that.

>> Adjusting qc->nbytes isn't enough.  libata will have to trim at the end
>> of sglist.  With both draining and padding, it means libata will have to
>> trim one sg entry and a few more bytes.  Block layer is behaving
>> differently and in a very noticeable way, it's sending inconsistent
>> values in data_len and sg list.
> 
> No, that's the point.  With all the space available, you don't need to
> trim at all ... you simply don't use it.  The rationale is the way the
> sg element stuff works.  If you program a DMA table (PRD table in IDE
> speak) into a controller, it doesn't care if you don't use the last few
> pieces.  With the default length set, the DMA controller won't use the
> last programmed element, but it's their if you expand the length or tell
> it to for an overrun.

Not all controllers have a place to set 'default length'.  They just run
till sg list terminates.

>> Okay, I see your point.  The biggest problem is that by doing that blk
>> layer breaks a pretty important rule - keeping data len consistent with
>> sg list and the bugs it's gonna cause will be very subtle and dangerous.
>>  This is definitely where we can spend four extra bytes.
> 
> The lengths don't have to be consistent (otherwise we wouldn't need to
> calculate them separately) the request reported length just has to be
> less than the sg table actual length.  We even make use of this property
> in SCSI when we can't fit a request into a single command ... we are
> allowed to chunk up the request as we complete it.  I'm not saying it's
> best practice, but it is acceptable behaviour.

libata definitely isn't ready for that and I don't think expanding the
behavior to whole block layer is a wise thing to do when the best
practice can be bought at the cost of 4 bytes per request.  No?

-- 
tejun
