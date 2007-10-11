From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Scsi on sparc build break in 2.6.23.
Date: Thu, 11 Oct 2007 08:30:38 -0500
Message-ID: <1192109439.3352.11.camel@localhost.localdomain>
References: <200710110552.49129.rob@landley.net>
	 <20071011110555.GV16424@stusta.de>  <200710110817.22344.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34199 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759376AbXJKNap (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Oct 2007 09:30:45 -0400
In-Reply-To: <200710110817.22344.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Adrian Bunk <bunk@kernel.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>

On Thu, 2007-10-11 at 08:17 -0500, Rob Landley wrote:
> On Thursday 11 October 2007 6:05:55 am Adrian Bunk wrote:
> > On Thu, Oct 11, 2007 at 05:52:48AM -0500, Rob Landley wrote:
> > > CONFIG_SCSI_SUNESP=y breaks the build in 2.6.23:
> > >
> > >   LD      vmlinux
> > > `scsi_esp_unregister' referenced in section `__ksymtab' of
> > > drivers/built-in.o: defined in discarded section `.exit.text' of
> > > drivers/built-in.o
> > > make: *** [vmlinux] Error 1
> > >
> > > Do you need my full .config to reproduce this?
> >
> > Please always attach the .config when reporting errors.
> > The few bytes don't matter and it often saves some time.
> >
> > I have an idea regarding what might be going wrong in this case,
> > but it would cost me additional time to look at it because you didn't
> > send your .config.
> 
> *shrug*  That's why I asked.
> 
> The reason I hesitated is I use miniconfig files rather than big .config 
> files, and some people get confused by that.  Drop the attached 
> miniconfig-linux in the kernel source directory and go:
>   make ARCH=sparc allnoconfig KCONFIG_ALLCONFIG=miniconfig-linux
> 
> That expands it to a big .config file, and from there "make ARCH=sparc 
> CROSS_COMPILE=sparc-" to reproduce the problem.  Assuming you have a sparc 
> cross-compiler lying around.
> 
> Disable CONFIG_SCSI_SUNESP and it builds to the end, (and the result boots but 
> won't mount the root filesystem, which is sort of expected).

This is a very subtle error.  You're building without hotplug, which
causes __devexit to become __exit, so scsi_esp_unregister is placed in
the discard section of vmlinux.  Unfortunately, the EXPORT_SYMBOL causes
it to be referenced from the symbol export table.

The fix is probably just to remove the __devexit tag from the function
rather than trying to work out how to make the export symbol conditional
on the symbol not being discarded.

James


