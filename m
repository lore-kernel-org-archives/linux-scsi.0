From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] drivers/scsi/nsp32.c: remove kernel 2.4 code
Date: Fri, 27 Apr 2007 02:13:24 +0200
Message-ID: <20070427001324.GP3468@stusta.de>
References: <20070426234742.GH3468@stusta.de> <Pine.LNX.4.64.0704261955450.14047@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35887 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755200AbXD0ANO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Apr 2007 20:13:14 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704261955450.14047@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 07:59:57PM -0400, Robert P. J. Day wrote:
> On Fri, 27 Apr 2007, Adrian Bunk wrote:
> 
> > This patch removes kernel 2.4 code.
> >
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> >
> > ---
> >
> > This patch has been sent on:
> > - 26 Mar 2007
> >
> >  drivers/scsi/nsp32.c |  109 +++++--------------------------------------
> >  1 file changed, 13 insertions(+), 96 deletions(-)
> >
> > --- linux-2.6.21-rc4-mm1/drivers/scsi/nsp32.c.old	2007-03-25 20:27:34.000000000 +0200
> > +++ linux-2.6.21-rc4-mm1/drivers/scsi/nsp32.c	2007-03-25 20:31:59.000000000 +0200
> > @@ -49,10 +49,6 @@
> >  #include <scsi/scsi_host.h>
> >  #include <scsi/scsi_ioctl.h>
> >
> > -#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
> > -# include <linux/blk.h>
> > -#endif
> > -
> 
> i'm curious about the rules for removing code like this.  in the case
> of drivers, isn't it possible that some driver source could be
> relevant for both the 2.4 and 2.6 kernel source tree, and simply uses
> that kind of preprocessor check to make sure it's being compiled
> appropriately?

That's what it was for.

> or are you doing something more sophisticated than simply checking the
> kernel version being tested?

No.

The point is:

It seems this driver was once maintained for both 2.4 and 2.6 in one 
file.

As long as this is done, such version checks are OK.

But if a driver is no longer actually maintained for both kernels these 
checks become useless (and there quickly arised unconditional 2.6-only 
code in such a driver) and can be removed.

> rday

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

