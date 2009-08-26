From: Theodore Tso <tytso@mit.edu>
Subject: Re: O_DIRECT and barriers
Date: Wed, 26 Aug 2009 14:47:00 -0400
Message-ID: <20090826184700.GD6997@mit.edu>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821220852.GM9529@mit.edu> <20090826063455.GA2417@discord.disaster> <20090826150102.GB22027@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38053 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbZHZSrP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2009 14:47:15 -0400
Content-Disposition: inline
In-Reply-To: <20090826150102.GB22027@shareable.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Aug 26, 2009 at 04:01:02PM +0100, Jamie Lokier wrote:
>   1. If the automatic O_SYNC fallback mentioned by Christopher is
>      currently implemented at all, even in a subset of filesystems,
>      then I think it should be removed.

Could you clarify what you meant by "it" above?  I'm not sure I
understood what you were referring to.

Also, it sounds like you and Dave are mostly agreeing with the what
I've written here; is that true?

http://ext4.wiki.kernel.org/index.php/Clarifying_Direct_IO's_Semantics

I'm trying to get consensus that this is both (a) an accurate
description of the state of affiars in Linux, and (b) that it is what
we think things should be, before I start circulating it around
application developers (especially database developers), to make sure
they have the same understanding of O_DIRECT semantics as we have.

> 
>   4. On drives which need it, fdatasync/fsync must trigger a drive
>      cache flush even when there is no dirty page cache to write,
>      because dirty pages may have been written in the background
>      already, and because O_DIRECT writes dirty the drive cache but
>      not the page cache.
> 

I agree we *should* do this, but we're going to take a pretty serious
performance hit when we do.  Mac OS chickened out and added an
F_FULLSYNC option:

http://developer.apple.com/documentation/Darwin/Reference/Manpages/man2/fcntl.2.html

The concern is that there are GUI programers that want to update state
files after every window resize or move, and after click on a web
browser.  These GUI programmers then get cranky when changes get lost
after proprietary video drivers cause the laptop to lock up.  If we
make fsync() too burdensome, then fewer and fewer applications will
use it.  Evidently the MacOS developers decided the few applications
who really cared about doing device cache flushes were much smaller
than the fast number of applications that need a lightweight file
flush.  Should we do the same?  

It seems like an awful cop-out, but having seen, up front and
personal, how "agressively stupid" some desktop programmers can be[1],
I can **certainly** understand why Apple chose the F_FULLSYNC route.

[1] http://josefsipek.net/blahg/?p=364

    		  	     	      - Ted
				      (who really needs to get himself
				       an O_PONIES t-shirt :-)
