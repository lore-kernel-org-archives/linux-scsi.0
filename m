From: Jamie Lokier <jamie@shareable.org>
Subject: Re: O_DIRECT and barriers
Date: Thu, 27 Aug 2009 15:50:51 +0100
Message-ID: <20090827145051.GC31453@shareable.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821220852.GM9529@mit.edu> <20090826063455.GA2417@discord.disaster> <20090826150102.GB22027@shareable.org> <20090826184700.GD6997@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:50889 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZH0OvC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2009 10:51:02 -0400
Content-Disposition: inline
In-Reply-To: <20090826184700.GD6997@mit.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@

Theodore Tso wrote:
> On Wed, Aug 26, 2009 at 04:01:02PM +0100, Jamie Lokier wrote:
> >   1. If the automatic O_SYNC fallback mentioned by Christopher is
> >      currently implemented at all, even in a subset of filesystems,
> >      then I think it should be removed.
> 
> Could you clarify what you meant by "it" above?  I'm not sure I
> understood what you were referring to.

I meant the automatic O_SYNC fallback, in other words, if O_DIRECT
falls back to buffered writing, Chris said it automatically did
O_SYNC, and you followed up by saying it doesn't :-)

All I'm saying is if there's _some_ code doing O_SYNC writing when
O_DIRECT falls back to buffered, it should be ripped out.  Leave the
syncing to explicit fsync calls from userspace.

> >   4. On drives which need it, fdatasync/fsync must trigger a drive
> >      cache flush even when there is no dirty page cache to write,
> >      because dirty pages may have been written in the background
> >      already, and because O_DIRECT writes dirty the drive cache but
> >      not the page cache.
> > 
> 
> I agree we *should* do this, but we're going to take a pretty serious
> performance hit when we do.  Mac OS chickened out and added an
> F_FULLSYNC option:

I know about that one.  (I've done quite a lot of research on O_DIRECT
and fsync behaviours).  It's really unfortunate that they didn't
provide F_FULLDATASYNC, which is what a database or VM would ideally
use.

I think Vxfs provides a whole suite of mount options to adjust what
O_SYNC and fdatasync actually do.

> The concern is that there are GUI programers that want to update state
> files after every window resize or move, and after click on a web
> browser.  These GUI programmers then get cranky when changes get lost
> after proprietary video drivers cause the laptop to lock up.  If we
> make fsync() too burdensome, then fewer and fewer applications will
> use it.  Evidently the MacOS developers decided the few applications
> who really cared about doing device cache flushes were much smaller
> than the fast number of applications that need a lightweight file
> flush.  Should we do the same?  

If fsync is cheap but doesn't commit changes properly - what's the
point in encouraging applications to use it?  Without drive cache
flushes, they will still lose changes occasionally.

(Btw, don't blame proprietary video drivers.  I see too many lockups
with open source video drivers too.)

> It seems like an awful cop-out, but having seen, up front and
> personal, how "agressively stupid" some desktop programmers can be[1],
> I can **certainly** understand why Apple chose the F_FULLSYNC route.

I did see a few of those threads, and I think your solution was genius.
Genius at keeping people quiet that is :-)

But it's also a good default.  fsync() isn't practical in shell
scripts or Makefiles, although that's really because "mv" lacks the
fsync option...

Personally I side with "want some kind of full-system asynchronous
transactionality please".  (Possibly aka. O_PONIES :-)

-- Jamie
