From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 32-bit bug in iovec iterator changes
Date: Sun, 22 Jun 2014 02:00:32 +0100
Message-ID: <20140622010032.GT18016@ZenIV.linux.org.uk>
References: <20140619162144.GC4907@thunk.org>
 <20140619223820.GN4453@dastard>
 <20140621035144.GA8526@thunk.org>
 <20140621055306.GP18016@ZenIV.linux.org.uk>
 <20140621230922.GA13188@thunk.org>
 <20140621234913.GQ18016@ZenIV.linux.org.uk>
 <1403395400.2592.4.camel@jarvis.lan>
 <20140622002618.GR18016@ZenIV.linux.org.uk>
 <1403397164.2177.40.camel@dabdike.int.hansenpartnership.com>
 <20140622005352.GS18016@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:53341 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaFVBAh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Jun 2014 21:00:37 -0400
Content-Disposition: inline
In-Reply-To: <20140622005352.GS18016@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Jun 22, 2014 at 01:53:52AM +0100, Al Viro wrote:
> On Sat, Jun 21, 2014 at 05:32:44PM -0700, James Bottomley wrote:
> > > No, we are not.  Look:
> > > 	* comparison promotes both operands to u64 here, so its result is
> > > accurate, no matter how large count is.  They are compared as natural
> > > numbers.
> > 
> > True ... figured this out 10 seconds after sending the email.
> > 
> > > 	* assignment converts count to size_t, which *would* truncate for
> > > values that are greater than the maximal value representable by size_t.
> > > But in that case it's by definition greater than i->count, so we do not
> > > reach that assignment at all.
> > 
> > OK, so what I still don't get is why isn't the compiler warning when we
> > truncate a u64 to a u32?  We should get that warning in your new code,
> > and we should have got that warning in fs/block_dev.c where it would
> > have pinpointed the actual problem.
> 
> In which universe?
> 
> extern void f(unsigned int);
> 
> void g(unsigned long x)
> {
> 	f(x);
> }
> 
> is perfectly valid C, with no warnings in sight.  f(1UL << 32) might
> give one, but not this...

PS: I agree that it's worth careful commenting, obviously, but before sending
it to Linus (*with* comments) I want to get a confirmation that this one-liner
actually fixes what Ted is seeing.  I have reproduced it here, and that change
makes the breakage go away in my testing, but I'd like to make sure that we are
seeing the same thing.  Ted?
