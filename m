From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic7xxx: move to dma_get_required_mask() and correct
	39 bit assumptions
Date: Tue, 30 Aug 2005 17:24:11 -0500
Message-ID: <1125440652.5037.71.camel@mulgrave>
References: <20050830221316.98368.qmail@web51608.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:8869 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751301AbVH3WYb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 18:24:31 -0400
In-Reply-To: <20050830221316.98368.qmail@web51608.mail.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Dave Jones <davej@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, luben_tuikov@adaptec.com

On Tue, 2005-08-30 at 15:13 -0700, Luben Tuikov wrote:
> AHC_LARGE_SCBS means that the card can take 64 byte hardware SCBs.
> Normally HSCBs are 32 bytes for older controllers.  Latter aic78xx and
> all aic79xx chips support 64 byte HSCBs.  So this isn't related.

So all aic chips, regardless of age can do 39 bit addressing mode in the
scb?  It also means they must be DAC capable, which I thought was pretty
much a universally missing feature in early cards.  From the bug report,
the card in question is a 7880, which is pretty early, I think: only
ultra, not even U2 or LVD.

> To fix this bug, you should only have to substitute
>            ahc_linux_get_memsize() > 0x80000000
> with
>            dma_get_required_mask(dev) > DMA_32BIT_MASK,
> to fix this issue (unless of course the kernel is confused too ;-) ).

But all that does is correct a thinko in the original code where it
would try to turn on 39 bit addressing mode if the machine has >2GB of
memory.  The practical effect of which is pretty much nil.

The symptoms reported look very much like DMA to the wrong region.

James


