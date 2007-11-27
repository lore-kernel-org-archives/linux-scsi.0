From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: Re: [PATCH] SGIWD93: use cached memory access to make driver work on IP28
Date: Tue, 27 Nov 2007 10:01:39 +0100
Message-ID: <20071127090139.GA6933@alpha.franken.de>
References: <20071126223921.A566CC2B26@solo.franken.de> <Pine.LNX.4.64.0711270927370.22167@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:41953 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbXK0JNN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Nov 2007 04:13:13 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711270927370.22167@anakin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, ralf@linux-mips.org, James.Bottomley@HansenPartnership.com

On Tue, Nov 27, 2007 at 09:28:14AM +0100, Geert Uytterhoeven wrote:
> >  struct hpc_chunk {
> >  	struct hpc_dma_desc desc;
> > -	u32 _padding;	/* align to quadword boundary */
> > +	u32 _padding[128/4 - 3];	/* align to biggest cache line size */
>                      ^^^^^^^^^
> (128 - sizeof(struct hpc_dma_desc))/4?

yes, that's safer. Thank you.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
