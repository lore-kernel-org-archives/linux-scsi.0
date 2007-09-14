From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix race with shared tag queue maps
Date: Fri, 14 Sep 2007 09:47:31 +0200
Message-ID: <20070914074731.GV25592@kernel.dk>
References: <20070913122652.GK25592@kernel.dk> <alpine.LFD.0.999.0709130813220.16478@woody.linux-foundation.org> <20070913152222.GS25592@kernel.dk> <alpine.LFD.0.999.0709130840450.16478@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:24572 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbXINHrk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2007 03:47:40 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709130840450.16478@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, orgis@agnld.uni-potsdam.de, arekm@maven.pl, ed.lin@promise.com, Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com

On Thu, Sep 13 2007, Linus Torvalds wrote:
> 
> 
> On Thu, 13 Sep 2007, Jens Axboe wrote:
> > 
> > My bad, I think I added the smp_mb__before_clear_bit() when it was
> > __test_and_set_bit() like in the first hunk.
> 
> Ahh, that wouldn't work at all. The "__test_and_set_bit()" thing isn't 
> atomic at all, and no amount of memory barriers around it would help 
> (you'd need to use real locking, but at that point the memory barriers are 
> pointless anyway).

Hence the change, it looks like an oversight from when we didn't allow
sharing of tag maps (then the queue lock provided adequate protection).

> > +	/*
> > +	 * Ensure ordering between ->tag_index[tag] clear and tag clear
> > +	 */
> > +	smp_mb__after_clear_bit();
> 
> You still left this one. But never mind - I already edited your original 
> patch and it's in my tree with both of those things removed.

I took at look at the committed patch and it looks fine, thanks Linus.

-- 
Jens Axboe

