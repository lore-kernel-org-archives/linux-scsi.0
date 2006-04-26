From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: aha152x(_cs) oops
Date: Wed, 26 Apr 2006 22:05:40 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0604262202200.6890@poirot.grange>
References: <20060413093615.661b7018.rdunlap@xenotime.net>
 <1144950036.3474.36.camel@mulgrave.il.steeleye.com>
 <20060425115709.0db4332f.rdunlap@xenotime.net> <Pine.LNX.4.60.0604252143550.3893@poirot.grange>
 <20060425140327.605f22ac.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:19863 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932388AbWDZUFn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Apr 2006 16:05:43 -0400
In-Reply-To: <20060425140327.605f22ac.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Hi

On Tue, 25 Apr 2006, Randy.Dunlap wrote:

> On Tue, 25 Apr 2006 22:41:28 +0200 (CEST) Guennadi Liakhovetski wrote:
> 
> > On Tue, 25 Apr 2006, Randy.Dunlap wrote:
> > 
> > > I've spent a lot of time using the sg-PIO patch with the aha152x
> > > driver.  The sg-PIO part of it works for me, but the aha152x driver
> > > sometimes does not complete a full DMA-out transfer (data-out phase).
> > > The driver calls this the need to "resend" some data (in datao_end()).
> > 
> > Sorry, didn't quite understand it - you mean the "in" direction modified 
> > to use sg-pio works, whereas the "out" doesn't? How exactly it doesn't 
> > work?
> 
> It's not a problem with the (your) sg patch.  It's just that this
> SCSI chip sometimes (apparently) stops a DMA-out transfer before
> it should (e.g., half way thru an sg list).  The driver detects this
> and decides that it needs to "resend" the remaining part of the sg
> list, but first it must back up the sg list ptr (possibly), the data
> transfer ptr (before this patch), this_residual, and possibly
> buffers_residual.  I've made many attempts at doing that, but
> they are not succeeding.

What kind of device is it and what are you doing to reproduce the error? 
Do you know if the stock kernel / aha152x driver work if you boot without 
highmem?

Transferring "residual" bytes left after an incomplete DMA is exactly the 
same situation as in dc395x and tmscsim...

> > Could you send me / upload your current patch using k(un)map_atomic_pio?
> 
> Sure, it's here:
> http://www.xenotime.net/linux/patches/aha152x-sg-pio.patch

Thanks, looking at it. I have an old ISA SCSI card, that runs under 
aha152x...

Guennadi
---
Guennadi Liakhovetski
