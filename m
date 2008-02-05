From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
 padding in favour of that provided by the block layer
Date: Tue, 05 Feb 2008 14:22:21 +0900
Message-ID: <47A7F28D.1030903@gmail.com>
References: <1199138168.3110.12.camel@localhost.localdomain>	 <1200698057.3111.68.camel@localhost.localdomain>	 <1201894847.3134.59.camel@localhost.localdomain>	 <47A37AF3.3030503@garzik.org>	 <1201900175.3134.67.camel@localhost.localdomain> <47A52F23.70506@gmail.com>	 <1202013174.3187.69.camel@localhost.localdomain>	 <47A56F2B.4040904@gmail.com>	 <1202049511.3318.13.camel@localhost.localdomain>	 <47A5DA5F.3070209@gmail.com>	 <1202055156.3318.58.camel@localhost.localdomain>	 <47A66A39.7090800@gmail.com> <47A6D9F2.5060102@gmail.com>	 <47A72475.5040106@gmail.com>	 <1202142222.3096.26.camel@localhost.localdomain>	 <47A7A887.2040307@gmail.com>	 <1202171564.3096.147.camel@localhost.localdomain>	 <47A7B11C.10607@gmail.com>	 <1202172826.3096.163.camel@localhost.localdomain>	 <47A7B6B6.2050801@gma
 il.com> <1202187791.3096.192.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:48606 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYBEFW3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 00:22:29 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3312960wah.23
        for <linux-scsi@vger.kernel.org>; Mon, 04 Feb 2008 21:22:29 -0800 (PST)
In-Reply-To: <1202187791.3096.192.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

James Bottomley wrote:
>> Oops, I was talking about padding.  Sorry about that.
> 
> Oh, OK ... the I thought the changelog was pretty explicit.  However, it
> works because the dma_aligment parameter of the block layer ensures that
> all elements of the sg list begin and end on an address that conforms to
> the dma_alignment.  It does this basically by forcing a copy of user
> incoming commands if they don't conform.  It does nothing with kernel
> based commands, but you can always assume for direct DMA that they begin
> and end on the cache line boundary ... and if they don't, there's always
> a spare allocation to expand them.

Yeah, the area is expanded but the bio list isn't updated accordingly.
In turn the sg list won't be.  I found where you worked around this.
The following chunk is added to ata_sg_setup().

+	/* needs padding? */
+	if (pad) {
+		struct scatterlist *sg = sg_last(qc->sg, n_elem);
+		qc->nbytes += ATA_DMA_PAD_SZ - pad;
+		sg->length +=  ATA_DMA_PAD_SZ - pad;
+	}

So, you add the area way up in the stack and adjust sg way down the
stack.  This is too fragile.  Actually, it's already broken and
demonstrates very well why block layer shouldn't do half of the job and
defer the rest to lower layer.

With draining, the above code ends up extending the sg entry for drain
page by pad bytes and there's no extra byte allocated after the drain
page.  The controller will end up contaminating pad bytes of the next
page and it will be extremely difficult to reproduce and track down.

>> Not all controllers have a place to set 'default length'.  They just run
>> till sg list terminates.
> 
> True ... but the traversal of the sg list terminates when the data
> transfer finishes ... this is the basis of your drain patch (and mine).
> Basically we don't require that anything transfer into the drain, but
> it's there just in case the transfer overruns and it needs to be used.

The thing is there is no way to detect data overrun if sg list doesn't
terminate.  For data transfer commands, sg list must terminate precisely
at the request boundary.  If 4k drain page is automatically appended,
the controller will happily overflow into that 4k without notifying
anyone.  Or worse, the device can suck in few extra blocks without
triggering error.  sgl should never contain extra entries for any
command which can affect data integrity.

>> libata definitely isn't ready for that and I don't think expanding the
>> behavior to whole block layer is a wise thing to do when the best
>> practice can be bought at the cost of 4 bytes per request.  No?
> 
> but the whole basis of both patches is inconsistent lengths: we're
> expecting a transfer of X, but we program the element lists for Y (>X)
> and see if the transfer actually needs >X (but hopefully <Y).

Yes, it's dual-sizing.  There's the size upper layer requested and
there's slightly different size lower layer wants to see (most of the
time).  Block layer sits inbetween and matches the impedance by
extending the request necessary but from either side the picture is
still consistent.  Lower layer (mostly) just sees ->data_len and
matching sgl.  Upper layer sends and receives the data length it requested.

The difference is that with your approach what lower layer sees becomes
inconsistent in itself and half of the impedance matching is left to
lower layer and it will cause nasty problems down the road.

Thanks.

-- 
tejun
