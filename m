From: Kenn Humborg <kenn@linux.ie>
Subject: Re: [PATCH] m68k link error and NCR5380_exit()
Date: Mon, 7 Mar 2005 23:42:33 +0000
Message-ID: <20050307234233.GA6240@excalibur.research.wombat.ie>
References: <20050213040948.GA10198@orchestra.cs.caltech.edu> <Pine.LNX.4.61.0502131618470.25204@loopy.telegraphics.com.au> <20050213063225.GA17415@orchestra.cs.caltech.edu> <Pine.LNX.4.61.0502131736300.25553@loopy.telegraphics.com.au> <20050213075506.GA18622@orchestra.cs.caltech.edu> <Pine.LNX.4.61.0502212233290.15372@loopy.telegraphics.com.au> <Pine.LNX.4.61.0503071612290.27126@loopy.telegraphics.com.au> <20050307063719.GA12478@infradead.org> <Pine.LNX.4.61.0503072333310.27126@loopy.telegraphics.com.au> <20050307175322.GA12907@pants.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mail2.mail.iol.ie ([193.95.141.54]:37847 "EHLO
	mail2.mail.iol.ie") by vger.kernel.org with ESMTP id S261804AbVCGXlw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2005 18:41:52 -0500
Content-Disposition: inline
In-Reply-To: <20050307175322.GA12907@pants.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brad Boyer <flar@allandria.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, Christoph Hellwig <hch@infradead.org>, James.Bottomley@SteelEye.com, linux scsi <linux-scsi@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Noah Misch <noah@cs.caltech.edu>, linux m68k <linux-m68k@vger.kernel.org>

On Mon, Mar 07, 2005 at 09:53:22AM -0800, Brad Boyer wrote:
> On Tue, Mar 08, 2005 at 12:45:28AM +1100, Finn Thain wrote:
> > My main reservation about embarking on this is that I don't think mac_scsi 
> > ever actually worked under 2.6 (or 2.5?) kernels. I'm not competent enough 
> > to submit a good, untested patch for a broken driver. Maybe the best thing 
> > is to make it work before worrying about style. At least then I can test 
> > my work.
> 
> I certainly never got it to work, but I only tried on my IIfx which
> doesn't have exactly the same version of the chip anyway.
> 
> > To that end, I've included a boot log below. Maybe someone familiar with 
> > the NCR5380 driver can make some sense of the failure?
> 
> Looks to me like the interrupt came in after the driver already
> decided to give up for some reason. I had a big problem with that
> while I was trying to fix the driver to use DMA on the IIfx. I
> never did get it to give me the interrupt for dma completion
> before the scsi mid layer timed out.

It broke in 2.6.9 for us Linux/VAX guys.

Try the NCR5380_set_timer() change from this patch:

   http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg01499.html

Later,
Kenn
 
