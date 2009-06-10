From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt
Date: Wed, 10 Jun 2009 13:48:11 -0600
Message-ID: <20090610194810.GU3274@parisc-linux.org>
References: <B8134F80-B547-4E04-890A-6B646D2BA3E8@qlogic.com> <20080911201140.GM2772@parisc-linux.org> <20090610183259.GI89096@n6013ncj7y1lh1.qlogic.org> <1244661018.17432.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52885 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761316AbZFJTsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 15:48:10 -0400
Content-Disposition: inline
In-Reply-To: <1244661018.17432.21.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, David Wagner <david.wagner@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, douglas.w.styner@intel.com, sharad.c.tripathi@intel.com, chinang.ma@intel.com, terry.o.prickett@intel.com

On Wed, Jun 10, 2009 at 07:10:18PM +0000, James Bottomley wrote:
> > That's a curious observation...  I'm just trying to understand the
> > numbers here, but, are we sure that this spin_lock() ->
> > spin_lock_irqsave() conversion is in fact the mitigating factor.
> 
> I think so ... the performance of both fixes is actually nearly
> identical showing that the base reason (interrupt while holding hardware
> spinlock adding to latency) is the correct one.
> 
> The curiosity I had is whether we can do even better by disabling
> interrupts for the whole of the ISR rather than only over the sections
> where we take the hw lock, and I don't think we have conclusive evidence
> either way on that.

It probably doesn't matter much either way.  At some point, I think
Peter will be successful in forcing IRQF_DISABLED for all interrupts,
and this decision will go away.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
