From: Brad Boyer <flar@allandria.com>
Subject: Re: [PATCH] m68k link error and NCR5380_exit()
Date: Mon, 7 Mar 2005 09:53:22 -0800
Message-ID: <20050307175322.GA12907@pants.nu>
References: <Pine.LNX.4.61.0502122135230.21876@loopy.telegraphics.com.au> <20050213040948.GA10198@orchestra.cs.caltech.edu> <Pine.LNX.4.61.0502131618470.25204@loopy.telegraphics.com.au> <20050213063225.GA17415@orchestra.cs.caltech.edu> <Pine.LNX.4.61.0502131736300.25553@loopy.telegraphics.com.au> <20050213075506.GA18622@orchestra.cs.caltech.edu> <Pine.LNX.4.61.0502212233290.15372@loopy.telegraphics.com.au> <Pine.LNX.4.61.0503071612290.27126@loopy.telegraphics.com.au> <20050307063719.GA12478@infradead.org> <Pine.LNX.4.61.0503072333310.27126@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from adsl-216-102-214-42.dsl.snfc21.pacbell.net ([216.102.214.42]:21253
	"EHLO cynthia.pants.nu") by vger.kernel.org with ESMTP
	id S261198AbVCGRxZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2005 12:53:25 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0503072333310.27126@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, James.Bottomley@SteelEye.com, linux scsi <linux-scsi@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Noah Misch <noah@cs.caltech.edu>, linux m68k <linux-m68k@vger.kernel.org>

On Tue, Mar 08, 2005 at 12:45:28AM +1100, Finn Thain wrote:
> Having qla1280.c as a guide will help, thanks. My next question is, what 
> does a NuBus architecture do in place of pci_(un)register_driver?

Eventually, you should use macio_(un)register_driver. However, I
don't have the support quite finished for mac68k. If I get some
time to work on it, I have most of the code written. It's close
enough that it should work on nubus-pmac, and I passed some
preliminary versions of the code off to them.

> My main reservation about embarking on this is that I don't think mac_scsi 
> ever actually worked under 2.6 (or 2.5?) kernels. I'm not competent enough 
> to submit a good, untested patch for a broken driver. Maybe the best thing 
> is to make it work before worrying about style. At least then I can test 
> my work.

I certainly never got it to work, but I only tried on my IIfx which
doesn't have exactly the same version of the chip anyway.

> To that end, I've included a boot log below. Maybe someone familiar with 
> the NCR5380 driver can make some sense of the failure?

Looks to me like the interrupt came in after the driver already
decided to give up for some reason. I had a big problem with that
while I was trying to fix the driver to use DMA on the IIfx. I
never did get it to give me the interrupt for dma completion
before the scsi mid layer timed out.

	Brad Boyer
	flar@allandria.com

