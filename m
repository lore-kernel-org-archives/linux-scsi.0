From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic7xxx: move to dma_get_required_mask() and correct
	39 bit assumptions
Date: Tue, 13 Sep 2005 14:20:48 -0500
Message-ID: <1126639248.4809.50.camel@mulgrave>
References: <20050830221316.98368.qmail@web51608.mail.yahoo.com>
	 <1125440652.5037.71.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:33237 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965155AbVIMTVG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 15:21:06 -0400
In-Reply-To: <1125440652.5037.71.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Dave Jones <davej@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, luben_tuikov@adaptec.com

On Tue, 2005-08-30 at 17:24 -0500, James Bottomley wrote:
> On Tue, 2005-08-30 at 15:13 -0700, Luben Tuikov wrote:
> > AHC_LARGE_SCBS means that the card can take 64 byte hardware SCBs.
> > Normally HSCBs are 32 bytes for older controllers.  Latter aic78xx and
> > all aic79xx chips support 64 byte HSCBs.  So this isn't related.
> 
> So all aic chips, regardless of age can do 39 bit addressing mode in the
> scb?  It also means they must be DAC capable, which I thought was pretty
> much a universally missing feature in early cards.  From the bug report,
> the card in question is a 7880, which is pretty early, I think: only
> ultra, not even U2 or LVD.
> 
> > To fix this bug, you should only have to substitute
> >            ahc_linux_get_memsize() > 0x80000000
> > with
> >            dma_get_required_mask(dev) > DMA_32BIT_MASK,
> > to fix this issue (unless of course the kernel is confused too ;-) ).
> 
> But all that does is correct a thinko in the original code where it
> would try to turn on 39 bit addressing mode if the machine has >2GB of
> memory.  The practical effect of which is pretty much nil.
> 
> The symptoms reported look very much like DMA to the wrong region.

OK, I just had confirmation that the patch does indeed fix the bug on
x86_64 validating the guess that the 7880 isn't working correctly with
39 bit addresses.

Luben, could you look in the manual and see if it says what chip
versions do work with the 39 bit mask.  For the time being I'm going to
commit the fix that assumes only the versions with AHC_LARGE_SCB's
defined work.  That's probably going to penalise a few chipsets that
have 39 bit but not 64 bit, but without the information, it's the best I
can do.

James


