From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 16/30] drivers/scsi/aic7xxx_old: Convert to generic
 boolean-values
Date: Tue, 8 May 2007 12:14:11 -0700
Message-ID: <20070508121411.d187a648.akpm@linux-foundation.org>
References: <200704260735.l3Q7ZIj7024253@shell0.pdx.osdl.net>
	<1178567419.3729.44.camel@mulgrave.il.steeleye.com>
	<20070507140656.3debfb55.akpm@linux-foundation.org>
	<1178637060.3737.15.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031284AbXEHTOU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 15:14:20 -0400
In-Reply-To: <1178637060.3737.15.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, ricknu-0@student.ltu.se

On Tue, 08 May 2007 10:11:00 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> > That being said, the patch is moderately wrong (or at least incomplete)
> > because it does things like:
> > 
> > -            unsigned char done = FALSE;
> > +            unsigned char done = false;
> > 
> > whereas it should have done
> > 
> > -            unsigned char done = FALSE;
> > +            bool done = false;
> 
> And the value to the driver of this transformation?

Not having to define private versions of TRUE and FALSE.  That's
a great blinking "something is wrong here" sign.

Obviously something like TRUE/FALSE should be a kernel-wide thing, not a
driver-private thing.  After quite some discussion and consideration, we
decided to stick with standard unmodified C99 (not C++) and implemented
that in include/linux/types.h and in include/linux/stddef.h.

Now, driver authors can go off and ignore all this, but others will not.  That
driver-private TRUE/FALSE is a big fat target saying "krufty, clean me up".

