From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: aha152x(_cs) oops
Date: Tue, 25 Apr 2006 14:03:27 -0700
Message-ID: <20060425140327.605f22ac.rdunlap@xenotime.net>
References: <20060413093615.661b7018.rdunlap@xenotime.net>
	<1144950036.3474.36.camel@mulgrave.il.steeleye.com>
	<20060425115709.0db4332f.rdunlap@xenotime.net>
	<Pine.LNX.4.60.0604252143550.3893@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:22145 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751483AbWDYVBB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Apr 2006 17:01:01 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2006 14:01:00 -0700
In-Reply-To: <Pine.LNX.4.60.0604252143550.3893@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Tue, 25 Apr 2006 22:41:28 +0200 (CEST) Guennadi Liakhovetski wrote:

> On Tue, 25 Apr 2006, Randy.Dunlap wrote:
> 
> > I've spent a lot of time using the sg-PIO patch with the aha152x
> > driver.  The sg-PIO part of it works for me, but the aha152x driver
> > sometimes does not complete a full DMA-out transfer (data-out phase).
> > The driver calls this the need to "resend" some data (in datao_end()).
> 
> Sorry, didn't quite understand it - you mean the "in" direction modified 
> to use sg-pio works, whereas the "out" doesn't? How exactly it doesn't 
> work?

It's not a problem with the (your) sg patch.  It's just that this
SCSI chip sometimes (apparently) stops a DMA-out transfer before
it should (e.g., half way thru an sg list).  The driver detects this
and decides that it needs to "resend" the remaining part of the sg
list, but first it must back up the sg list ptr (possibly), the data
transfer ptr (before this patch), this_residual, and possibly
buffers_residual.  I've made many attempts at doing that, but
they are not succeeding.

> > I can't get this resend logic to work correctly with the sg-PIO
> > changes and I can't keep spending time on it without some docs and/or
> > errata, so I'll just continue to use my lowmem patch for the
> > aha152x driver.
> 
> Could you send me / upload your current patch using k(un)map_atomic_pio?

Sure, it's here:
http://www.xenotime.net/linux/patches/aha152x-sg-pio.patch

---
~Randy
