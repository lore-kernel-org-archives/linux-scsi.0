From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Illustration of warning explosion silliness
Date: Wed, 27 Sep 2006 20:34:17 -0700
Message-ID: <20060927203417.f07674de.akpm@osdl.org>
References: <20060928005830.GA25694@havoc.gtf.org>
	<20060927183507.5ef244f3.akpm@osdl.org>
	<451B29FA.7020502@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:6056 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750707AbWI1DeY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 23:34:24 -0400
In-Reply-To: <451B29FA.7020502@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>

On Wed, 27 Sep 2006 21:48:42 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> The usage model should not be _forced_ upon the caller, since it might 
> not be needed.

IMO: tough titty.

This isn't some random crappy perl script.  Nor is it even some random
crappy sound card driver.  This is our scsi stack.  The heart of our
MissionCriticalEnterpriseReadyCoreOfAThirtyBillionDollarIndustry operating
system.  Picture yourself telling a Fortune 100 CTO why his kernel is
cheerily discarding errors (and hence his reliability and possibly data)
all over the place.  Take a peek at spi_dv_device() and its callees...	

I was astonished at the number of ignored errors all over the
sysfs/driver-model code.  And that's only there to detect programming
errors.  That's nothing compared to these bugs.

Discarding already-detected hardware or software errors in the storage
stack is toe-curlingly lame, and completely trumps the inconvenience of
developers seeing a few warnings, or having to put artificial warning
shutter-uppers in a few places.


Now I'm sure I'm about to be flooded with long-winded explanations about
why all of this can never happen.  But y'know what?  I don't care. 
Hardware errors can sometimes happen.  As can programming errors, as can
memory-corruption and dropped-bit errors and all the other things we
regularly see.  The kernel should be robust in the presence of unexpected
events.  *Particularly* those parts which are handling storage.  Any
void-returning function in a driver or a mid-layer is a huge red flag.

And it's not sufficient to say "gee, I can't think of any reason why this
handler would return an error, so I'll design its callers to assume that". 
It is _much_ better to design the callers to assume that callees _can_
fail, and to stick the `return 0;' into the terminal callee.  Because
things can change.


There, I feel better now.  If you want to see the other warnings, set
CONFIG_ENABLE_MUST_CHECK=n.

