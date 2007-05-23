From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 07/25] scsi: cover up bugs^W^W^WFix up
	compiler	warnings in megaraid driver
Date: Wed, 23 May 2007 17:59:49 -0500
Message-ID: <1179961189.5569.52.camel@mulgrave.il.steeleye.com>
References: <200705232141.l4NLfd1N001178@shell0.pdx.osdl.net>
	 <1179960760.5569.45.camel@mulgrave.il.steeleye.com>
	 <4654C611.9070302@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34075 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755981AbXEWW7v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 18:59:51 -0400
In-Reply-To: <4654C611.9070302@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Bligh <mbligh@google.com>
Cc: akpm@linux-foundation.org, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org

On Wed, 2007-05-23 at 15:54 -0700, Martin Bligh wrote:
> James Bottomley wrote:
> > On Wed, 2007-05-23 at 14:41 -0700, akpm@linux-foundation.org wrote:
> >> From: Martin Bligh <mbligh@google.com>
> >>
> >> Fix up compiler warnings in megaraid driver
> >>
> >> [akpm@osdl.org: build fix]
> >> Signed-off-by: Martin J. Bligh <mbligh@google.com>
> >> Cc: James Bottomley <James.Bottomley@steeleye.com>
> >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >> ---
> >>
> >>  drivers/scsi/megaraid.c |   22 +++++++++++++---------
> >>  1 files changed, 13 insertions(+), 9 deletions(-)
> >>
> >> diff -puN drivers/scsi/megaraid.c~scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver drivers/scsi/megaraid.c
> >> --- a/drivers/scsi/megaraid.c~scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver
> >> +++ a/drivers/scsi/megaraid.c
> >> @@ -73,10 +73,14 @@ static unsigned short int max_mbox_busy_
> >>  module_param(max_mbox_busy_wait, ushort, 0);
> >>  MODULE_PARM_DESC(max_mbox_busy_wait, "Maximum wait for mailbox in microseconds if busy (default=MBOX_BUSY_WAIT=10)");
> >>  
> >> -#define RDINDOOR(adapter)	readl((adapter)->mmio_base + 0x20)
> >> -#define RDOUTDOOR(adapter)	readl((adapter)->mmio_base + 0x2C)
> >> -#define WRINDOOR(adapter,value)	 writel(value, (adapter)->mmio_base + 0x20)
> >> -#define WROUTDOOR(adapter,value) writel(value, (adapter)->mmio_base + 0x2C)
> >> +#define RDINDOOR(adapter)		readl((volatile void __iomem *) \
> >> +							(adapter)->base + 0x20)
> >> +#define RDOUTDOOR(adapter)		readl((volatile void __iomem *) \
> >> +							(adapter)->base + 0x2C)
> >> +#define WRINDOOR(adapter,value)		writel(value, (volatile void __iomem *)\
> >> +							(adapter)->base + 0x20)
> >> +#define WROUTDOOR(adapter,value)	writel(value, (volatile void __iomem *)\
> >> +							(adapter)->base + 0x2C)
> > 
> > This is both unnecessary and wrong ... it coerces the iomem value and
> > would squelch the useful warnings gcc would issue if base ever lost its
> > iomem annotation.
> 
> Is there another, better, way to stop it spewing compile warnings like
> something out of a horror movie?

It only spews pointer to int conversion warnings on 64 bit for the four
cases you identified below this.  I suspect the above is a remnant from
before the driver was converted to the __iomem annotations ... it should
now be unnecessary because the (adapter)->base has an __iomem
annotation).

James


