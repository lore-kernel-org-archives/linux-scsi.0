From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt
 handler
Date: Wed, 10 Jun 2009 11:17:57 -0500
Message-ID: <1244650677.17432.0.camel@mulgrave.site>
References: <alpine.OSX.1.00.0906091107470.3891@ac-mac.local>
	 <1244575944.12321.58.camel@mulgrave.site>
	 <19C9538E-B7B2-4924-859F-37E56660D95E@qlogic.com>
	 <1244580029.12321.138.camel@mulgrave.site>
	 <alpine.OSX.1.00.0906091436120.4405@ac-mac.local>
	 <D7C42C27E6CB1E4D8CBDF2F81EA92A26035402EBA0@azsmsx501.amr.corp.intel.com>
	 <2796FDDF-31EA-44E2-8856-84A22F31A01F@qlogic.com>
	 <D7C42C27E6CB1E4D8CBDF2F81EA92A26035402F1C0@azsmsx501.amr.corp.intel.com>
	 <38D5FA1B-4CCC-46FB-8793-4131AF6AAD05@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47498 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbZFJQR7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 12:17:59 -0400
In-Reply-To: <38D5FA1B-4CCC-46FB-8793-4131AF6AAD05@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: "Styner, Douglas W" <douglas.w.styner@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "Ma, Chinang" <chinang.ma@intel.com>, "Prickett, Terry O" <terry.o.prickett@intel.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>

On Wed, 2009-06-10 at 09:09 -0700, Anirban Chakraborty wrote:
> On Jun 10, 2009, at 8:52 AM, Styner, Douglas W wrote:
> 
> >
> > Anirban Chakraborty [mailto:anirban.chakraborty@qlogic.com] write:
> >>
> >> You got it right. Basically we are doing:
> >> 1. baseline scsi-misc + earlier patch
> >> 2. baseline scsi-misc + this patch
> >> And then compare 1 and 2.
> >
> > Results are as follows:
> > Total interrupts are down slightly (-0.8%), QLA interrupts are flat  
> > (-0.1%) Cycles for qla2xxx_intr_handler up from .77% to .92%.
> 
> So, it looks like using spin_lock_irqsave is doing a better job than  
> globally disabling the sharing of the interrupt via IRQF_DISABLED.

OK, so just drop the msix changes and resubmit ... it'll have to go in
SCSI misc, but once the merge window is over, you can request a backport
to stable.

James


