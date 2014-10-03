From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 10/29] ncr5380: Fix SCSI_IRQ_NONE bugs
Date: Fri, 3 Oct 2014 20:42:57 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1410032021110.12643@nippy.intranet>
References: <20141002065628.256592712@telegraphics.com.au> <20141002065630.639025422@telegraphics.com.au> <CAMuHMdWHkGFamsnxJAi++WFqx8OAZ-qyuQDQN66Gi8JJunB0dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:42046 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJCKoK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2014 06:44:10 -0400
In-Reply-To: <CAMuHMdWHkGFamsnxJAi++WFqx8OAZ-qyuQDQN66Gi8JJunB0dw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>


On Fri, 3 Oct 2014, Geert Uytterhoeven wrote:

> On Thu, Oct 2, 2014 at 8:56 AM, Finn Thain <fthain@telegraphics.com.au> 
> wrote:
> > Oak scsi doesn't use any IRQ, but it sets irq = IRQ_NONE rather than
> > SCSI_IRQ_NONE. Problem is, the core NCR5380 driver expects SCSI_IRQ_NONE
> > if it is to issue IDENTIFY commands that prevent target disconnection.
> >
> > Other drivers, when they can't get an IRQ or can't use one, will set
> > host->irq = SCSI_IRQ_NONE (that is, 255). But when they exit they will
> > attempt to free IRQ 255 which was never requested.
> >
> > Fix these bugs by using IRQ_NONE in place of SCSI_IRQ_NONE. This means
> > IRQ 0 is no longer probed by ISA drivers but I don't think this matters.
> 
> IRQ_NONE is part of enum irqreturn. I guess you meant NO_IRQ?
> 
> But NO_IRQ is deprecated, and not available on all architectures.
> The recommended way is to just use 0, like in "if (instance->irq) ...".
> 
> Note that some drivers do
> 
> #ifndef NO_IRQ
> #define NO_IRQ  (-1)
> #endif
> 
> and others do
> 
> #ifndef NO_IRQ
> #define NO_IRQ  0
> #endif
> 

Well, the question becomes, is it better to replace SCSI_IRQ_NONE with 0 
or with NO_IRQ?

I guess drivers use #ifndef in case the architecture brings its own 
definition of NO_IRQ (presumably because it can't use 0).

Since NCR5380 drivers cover a variety of architectures (ARM, m68k, ISA, 
PCI...) it seems that the more prudent option is,

#ifndef NO_IRQ
#define NO_IRQ  0
#endif

-- 
