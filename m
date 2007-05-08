From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 16/30] drivers/scsi/aic7xxx_old: Convert to generic
	boolean-values
Date: Tue, 08 May 2007 14:24:32 -0500
Message-ID: <1178652273.3737.67.camel@mulgrave.il.steeleye.com>
References: <200704260735.l3Q7ZIj7024253@shell0.pdx.osdl.net>
	 <1178567419.3729.44.camel@mulgrave.il.steeleye.com>
	 <20070507140656.3debfb55.akpm@linux-foundation.org>
	 <1178637060.3737.15.camel@mulgrave.il.steeleye.com>
	 <20070508121411.d187a648.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55396 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967287AbXEHTYj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 15:24:39 -0400
In-Reply-To: <20070508121411.d187a648.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, ricknu-0@student.ltu.se

On Tue, 2007-05-08 at 12:14 -0700, Andrew Morton wrote:
> On Tue, 08 May 2007 10:11:00 -0500
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > > That being said, the patch is moderately wrong (or at least incomplete)
> > > because it does things like:
> > > 
> > > -            unsigned char done = FALSE;
> > > +            unsigned char done = false;
> > > 
> > > whereas it should have done
> > > 
> > > -            unsigned char done = FALSE;
> > > +            bool done = false;
> > 
> > And the value to the driver of this transformation?
> 
> Not having to define private versions of TRUE and FALSE.  That's
> a great blinking "something is wrong here" sign.

Agree.  I would like to get rid of private versions of these.

> Obviously something like TRUE/FALSE should be a kernel-wide thing, not a
> driver-private thing.  After quite some discussion and consideration, we
> decided to stick with standard unmodified C99 (not C++) and implemented
> that in include/linux/types.h and in include/linux/stddef.h.
> 
> Now, driver authors can go off and ignore all this, but others will not.  That
> driver-private TRUE/FALSE is a big fat target saying "krufty, clean me up".

Agree ... my complaint is the use of bool in the above example and the
fact that true/false are defined in stddef.h whereas almost every driver
uses TRUE/FALSE.  I really prefer the upcased latter version which is
well understood in C circles (and the private definitions can be excised
with a lot less churn than downcasing every instance of TRUE/FALSE).
However, could we compromise and just add TRUE = true, FALSE = false to
the enum?

James


