From: Ingo Molnar <mingo@elte.hu>
Subject: Re: next Feb 13 drivers/scsi/aha1542.ko build break
Date: Fri, 13 Feb 2009 21:03:47 +0100
Message-ID: <20090213200347.GA27367@elte.hu>
References: <20090213175526.d0590862.sfr@canb.auug.org.au> <49955D00.2020707@in.ibm.com> <4995BA4B.9050209@oracle.com> <1234551164.3252.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:58469 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbZBMUEO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2009 15:04:14 -0500
Content-Disposition: inline
In-Reply-To: <1234551164.3252.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Sachin P. Sant" <sachinp@in.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Fri, 2009-02-13 at 10:22 -0800, Randy Dunlap wrote:
> > Sachin P. Sant wrote:
> > > Feb 13 next x86 allmodconfig build breaks with
> > > 
> > > ERROR: "__udivdi3" [drivers/scsi/aha1542.ko] undefined!
> > > 
> > > .config attached.
> > 
> > 
> > I'm seeing that also.  I think that it's this line in aha1542.c:
> > 
> > 495:		mbo = (scsi2int(mb[mbi].ccbptr) - (SCSI_BUF_PA(&ccb[0]))) / sizeof(struct ccb);
> > 
> > since I can comment out the "/ sizeof(struct ccb)" and the driver builds successfully.
> > 
> > This may need a patch to use one of the div() macros (?).
> 
> It shouldn't ... the two inputs should be longs and the sizeof should be
> dividing by a constant size_t.  __udivdi3 is used for 64 bit division on
> a 32 bit platform, so where's it getting the idea that something in the
> division is 64 bit?
> 
> The culprit looks to be
> 
> commit 976e8f677e42757e5586ea04a9ac8bb8ddaa037e
> Author: Jeremy Fitzhardinge <jeremy@goop.org>
> Date:   Fri Feb 6 13:29:44 2009 -0800
> 
>     x86: asm/io.h: unify virt_to_phys/phys_to_virt
> 
> Because it changed the return of virt_to_phys from long to phys_addr_t
> which is unsigned long long on a PAE platform, which this is.
> 
> So, I could suggest a fix below since isa addresses may never be above
> 32 bits, but I think this issue has more ramifications for the other
> legacy users of virt_to_phys.

Applied your fix to tip:x86/headers, thanks!

If something non-deep-legacy uses an ugly construct like this:

> > 495:		mbo = (scsi2int(mb[mbi].ccbptr) - (SCSI_BUF_PA(&ccb[0]))) / sizeof(struct ccb);

The right fix will be to remove that division from that code ...

I wouldnt dare to touch the aha1542 driver though. OTOH, build testing
only came up with the aha1542 case so we should be good.

	Ingo
