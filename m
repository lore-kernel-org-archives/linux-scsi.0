From: Anton Blanchard <anton@samba.org>
Subject: Re: bogus barriers in sym53c8xx_2?
Date: Wed, 20 Aug 2003 13:43:18 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030820034318.GC25341@krispykreme>
References: <200308192349.h7JNnrEK017626@napali.hpl.hp.com> <20030820032611.GI19630@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:39341 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S261598AbTHTDry (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2003 23:47:54 -0400
Content-Disposition: inline
In-Reply-To: <20030820032611.GI19630@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: davidm@hpl.hp.com, linux-ia64@vger.kernel.org, linux-scsi@vger.kernel.org


> I'm sure Gerard must have written it originally.  It's there
> in the earliest version of the sym2 driver I can find --
> sym-2.1.16a-for-linux-2.4.13.patch.gz.  A similar barrier is there in
> the sym1 driver (drivers/scsi/sym53c8xx_defs.h).  It seems to have been
> introduced around 2.4.3 (symbios driver version 1.6b -> 1.7.3a-20010304)
> 
> So you're looking for a patch which looks something like this:
> 
> - #define __READ_BARRIER()	__asm__ volatile("mf.a; mf" : : : "memory")
> - #define __WRITE_BARRIER()	__asm__ volatile("mf.a; mf" : : : "memory")
> + #define __READ_BARRIER()	__asm__ volatile("mf" : : : "memory")
> + #define __WRITE_BARRIER()	__asm__ volatile("mf" : : : "memory")
> 
> Or really, might be better to just define them to rmb() and wmb()?

I suspect so, the powerpc ones are overkill too:

#define __READ_BARRIER()        __asm__ volatile("eieio; sync" : : : "memory")
#define __WRITE_BARRIER()       __asm__ volatile("eieio; sync" : : : "memory")

Anton
