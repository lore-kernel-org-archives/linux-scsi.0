From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt
Date: Wed, 10 Jun 2009 19:10:18 +0000
Message-ID: <1244661018.17432.21.camel@mulgrave.site>
References: <B8134F80-B547-4E04-890A-6B646D2BA3E8@qlogic.com>
	 <20080911201140.GM2772@parisc-linux.org>
	 <20090610183259.GI89096@n6013ncj7y1lh1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35126 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755056AbZFJTKT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 15:10:19 -0400
In-Reply-To: <20090610183259.GI89096@n6013ncj7y1lh1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, David Wagner <david.wagner@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, douglas.w.styner@intel.com, sharad.c.tripathi@intel.com, chinang.ma@intel.com, terry.o.prickett@intel.com

On Wed, 2009-06-10 at 11:32 -0700, Andrew Vasquez wrote:
> On Wed, Jun 10, 2009, wrote:
> 
> > On Wed, Jun 10, 2009 at 09:09:14AM -0700, Anirban Chakraborty wrote:
> > >
> > > On Jun 10, 2009, at 8:52 AM, Styner, Douglas W wrote:
> > >> Anirban Chakraborty [mailto:anirban.chakraborty@xxxxxxxxxx] write:
> > >>>
> > >>> You got it right. Basically we are doing:
> > >>> 1. baseline scsi-misc + earlier patch
> > >>> 2. baseline scsi-misc + this patch
> > >>> And then compare 1 and 2.
> > >>
> > >> Results are as follows:
> > >> Total interrupts are down slightly (-0.8%), QLA interrupts are flat  
> > >> (-0.1%) Cycles for qla2xxx_intr_handler up from .77% to .92%.
> > >
> > > So, it looks like using spin_lock_irqsave is doing a better job than  
> > > globally disabling the sharing of the interrupt via IRQF_DISABLED.
> > 
> > The margin of error for this setup is about 0.3% for the performance
> > as a whole.  I don't know what the margin of error is for the number
> > of cycles consumed by a given function, but I would suspect it's
> > significantly higher than the 0.15% difference seen.
> > 
> > >> ======oprofile CPU_CLK_UNHALTED for top 30 functions
> > >> Cycles% 2.6.30-rc6_scsi-misc_0001   Cycles% 2.6.30-rc6_scsi-misc_irqf-d
> > >> 68.1402 <database>                  66.1875 <database>
> > >> 0.9125 qla24xx_start_scsi            0.9552 qla24xx_start_scsi
> > >> 0.8729 __schedule                    0.9272 __schedule
> > >> 0.7739 qla24xx_intr_handler          0.9178 qla24xx_intr_handler
> > >> 0.7161 kmem_cache_alloc              0.7963 kmem_cache_alloc
> 
> That's a curious observation...  I'm just trying to understand the
> numbers here, but, are we sure that this spin_lock() ->
> spin_lock_irqsave() conversion is in fact the mitigating factor.

I think so ... the performance of both fixes is actually nearly
identical showing that the base reason (interrupt while holding hardware
spinlock adding to latency) is the correct one.

The curiosity I had is whether we can do even better by disabling
interrupts for the whole of the ISR rather than only over the sections
where we take the hw lock, and I don't think we have conclusive evidence
either way on that.

James


