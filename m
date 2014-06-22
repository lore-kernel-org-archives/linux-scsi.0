From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 32-bit bug in iovec iterator changes
Date: Sun, 22 Jun 2014 01:53:52 +0100
Message-ID: <20140622005352.GS18016@ZenIV.linux.org.uk>
References: <20140619160801.GB4907@thunk.org>
 <20140619162144.GC4907@thunk.org>
 <20140619223820.GN4453@dastard>
 <20140621035144.GA8526@thunk.org>
 <20140621055306.GP18016@ZenIV.linux.org.uk>
 <20140621230922.GA13188@thunk.org>
 <20140621234913.GQ18016@ZenIV.linux.org.uk>
 <1403395400.2592.4.camel@jarvis.lan>
 <20140622002618.GR18016@ZenIV.linux.org.uk>
 <1403397164.2177.40.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1403397164.2177.40.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jun 21, 2014 at 05:32:44PM -0700, James Bottomley wrote:
> > No, we are not.  Look:
> > 	* comparison promotes both operands to u64 here, so its result is
> > accurate, no matter how large count is.  They are compared as natural
> > numbers.
> 
> True ... figured this out 10 seconds after sending the email.
> 
> > 	* assignment converts count to size_t, which *would* truncate for
> > values that are greater than the maximal value representable by size_t.
> > But in that case it's by definition greater than i->count, so we do not
> > reach that assignment at all.
> 
> OK, so what I still don't get is why isn't the compiler warning when we
> truncate a u64 to a u32?  We should get that warning in your new code,
> and we should have got that warning in fs/block_dev.c where it would
> have pinpointed the actual problem.

In which universe?

extern void f(unsigned int);

void g(unsigned long x)
{
	f(x);
}

is perfectly valid C, with no warnings in sight.  f(1UL << 32) might
give one, but not this...
