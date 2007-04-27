From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [2.6 patch] drivers/scsi/nsp32.c: remove kernel 2.4 code
Date: Thu, 26 Apr 2007 20:30:54 -0400
Message-ID: <1177633855.5532.8.camel@mulgrave.il.steeleye.com>
References: <20070426234742.GH3468@stusta.de>
	 <Pine.LNX.4.64.0704261955450.14047@localhost.localdomain>
	 <20070427001324.GP3468@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:51108 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755256AbXD0AcG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Apr 2007 20:32:06 -0400
In-Reply-To: <20070427001324.GP3468@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Yokota Hiroshi <yokota@netlab.cs.tsukuba.ac.jp>, GOTO Masanori <gotom@sanori.org>

On Fri, 2007-04-27 at 02:13 +0200, Adrian Bunk wrote:
> On Thu, Apr 26, 2007 at 07:59:57PM -0400, Robert P. J. Day wrote:
> > On Fri, 27 Apr 2007, Adrian Bunk wrote:
> > 
> > > This patch removes kernel 2.4 code.
> > >
> > > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > >
> > > ---
> > >
> > > This patch has been sent on:
> > > - 26 Mar 2007
> > >
> > >  drivers/scsi/nsp32.c |  109 +++++--------------------------------------
> > >  1 file changed, 13 insertions(+), 96 deletions(-)
> > >
> > > --- linux-2.6.21-rc4-mm1/drivers/scsi/nsp32.c.old	2007-03-25 20:27:34.000000000 +0200
> > > +++ linux-2.6.21-rc4-mm1/drivers/scsi/nsp32.c	2007-03-25 20:31:59.000000000 +0200
> > > @@ -49,10 +49,6 @@
> > >  #include <scsi/scsi_host.h>
> > >  #include <scsi/scsi_ioctl.h>
> > >
> > > -#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
> > > -# include <linux/blk.h>
> > > -#endif
> > > -
> > 
> > i'm curious about the rules for removing code like this.  in the case
> > of drivers, isn't it possible that some driver source could be
> > relevant for both the 2.4 and 2.6 kernel source tree, and simply uses
> > that kind of preprocessor check to make sure it's being compiled
> > appropriately?
> 
> That's what it was for.
> 
> > or are you doing something more sophisticated than simply checking the
> > kernel version being tested?
> 
> No.
> 
> The point is:
> 
> It seems this driver was once maintained for both 2.4 and 2.6 in one 
> file.
> 
> As long as this is done, such version checks are OK.

Personally, I don't like to see 2.4 and 2.6 in a new driver, and will
tend to try to force it to be 2.6  only.  For an existing driver, I tend
to be much more tolerant: removing the huge gobs of code to achieve 2.6
only is usually a bit disruptive on both the driver and the maintainer

> But if a driver is no longer actually maintained for both kernels these 
> checks become useless (and there quickly arised unconditional 2.6-only 
> code in such a driver) and can be removed.

This driver is maintained by 

Yokota Hiroshi <yokota@netlab.cs.tsukuba.ac.jp>
GOTO Masanori <gotom@sanori.org>

As it says in the header.  It was last modified in May 2006, so it is
maintained under the somewhat elastic standards of SCSI.  I've cc'd them
to see what they think.

James


