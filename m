From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Sun, 13 May 2007 12:20:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705131216440.27468@localhost.localdomain>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
 <20070513160608.GA29024@redhat.com> <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nic.NetDirect.CA ([216.16.235.2]:47491 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759423AbXEMQVQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 May 2007 12:21:16 -0400
In-Reply-To: <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Sun, 13 May 2007, James Bottomley wrote:

> On Sun, 2007-05-13 at 12:06 -0400, Dave Jones wrote:
> > On Sun, May 13, 2007 at 11:22:55AM -0400, Robert P. J. Day wrote:
> >  >
> >  >   not a big deal, but is there a reason that a "make defconfig" on my
> >  > x86 system ends up selecting and building a single module?
> >  >
> >  >   Building modules, stage 2.
> >  >   MODPOST 1 modules
> >  >   CC      drivers/scsi/scsi_wait_scan.mod.o
> >  >   LD [M]  drivers/scsi/scsi_wait_scan.ko
> >  >
> >  > is there something special about that module?  just curious.
> >
> > My guess is that someone was paranoid and wanted not to have
> > to answer a zillion "my machine won't boot any more" questions
> > when async scsi scanning was added.
> > This might further clarify..
> >
> > ---
> >
> > The scsi_wait_scan module is only really useful if async scanning
> > is enabled.
> >
> > Signed-off-by: Dave Jones <davej@redhat.com>
> >
> > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > index e62d23f..0f6c370 100644
> > --- a/drivers/scsi/Kconfig
> > +++ b/drivers/scsi/Kconfig
> > @@ -244,7 +244,7 @@ config SCSI_SCAN_ASYNC
> >  config SCSI_WAIT_SCAN
> >  	tristate
> >  	default m
> > -	depends on SCSI
> > +	depends on SCSI_SCAN_ASYNC
>
> No.  SCSI_SCAN_ASYNC is a bool ... if you depend on it, you'll force
> the wait scan to be built in, which isn't the idea at all.

since this thread looks like it's going to get away from me in a
hurry :-), my only point in asking was to point out that that lone
module was the only thing preventing the build from being module-free.

i'm not saying that that's *necessarily* a good thing, but it just
strikes me as odd that, out of all of the possible modules that might
be selected in a default config for x86, this was the *only* one that
was picked.

i just think it's a bit weird, that's all.

rday

p.s.  it's mostly a case of -- whenever i notice something being done
only *once* in the entire source tree, i'm always a bit leery.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
