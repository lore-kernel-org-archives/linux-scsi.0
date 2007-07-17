From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 12:19:29 +0200
Message-ID: <20070717101928.GK5195@kernel.dk>
References: <20070717065940.GZ5195@kernel.dk> <20070717160816K.fujita.tomonori@lab.ntt.co.jp> <20070717071045.GD5195@kernel.dk> <20070717190705T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:18380 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549AbXGQKUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 06:20:04 -0400
Content-Disposition: inline
In-Reply-To: <20070717190705T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jul 17 2007, FUJITA Tomonori wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: Re: block/bsg.c
> Date: Tue, 17 Jul 2007 09:10:45 +0200
> 
> > On Tue, Jul 17 2007, FUJITA Tomonori wrote:
> > > From: Jens Axboe <jens.axboe@oracle.com>
> > > Subject: Re: block/bsg.c
> > > Date: Tue, 17 Jul 2007 08:59:40 +0200
> > > 
> > > > On Tue, Jul 17 2007, FUJITA Tomonori wrote:
> > > > > From: Jens Axboe <jens.axboe@oracle.com>
> > > > > Subject: Re: block/bsg.c
> > > > > Date: Tue, 17 Jul 2007 08:38:11 +0200
> > > > > 
> > > > > > On Mon, Jul 16 2007, Andrew Morton wrote:
> > > > > > > 
> > > > > > > A belated review (I've never seen this before and there it is in mainline)
> > > > > > > 
> > > > > > > > static char bsg_version[] = "block layer sg (bsg) 0.4";
> > > > > > > 
> > > > > > > `const' would be better.  That moves it into a write-protected memory section.
> > > > > > 
> > > > > > Agree
> > > > > > 
> > > > > > > > #define list_entry_bc(entry)	list_entry((entry), struct bsg_command, list)
> > > > > > > 
> > > > > > > This makes the code easier to write but harder to read.  We should optimise
> > > > > > > for readers.  Please open-code this at callsites.
> > > > > > > 
> > > > > > > Or at least convert it into a (commented) (possibly inlined) C function.
> > > > > > 
> > > > > > list_entry_to_bc(), then? The main objective is to save on typing, and
> > > > > > (just as important) make sure we don't bump over the 80 chars per line.
> > > > > > 
> > > > > > > > /*
> > > > > > > >  * just for testing
> > > > > > > >  */
> > > > > > > > #define BSG_MAJOR	(240)
> > > > > > > 
> > > > > > > What's this doing in mainline?  240 is a "reserved for local use" major. 
> > > > > > > This will cause collisions.  This code should be using dynamic major
> > > > > > > assignment.
> > > > > > 
> > > > > > Yeah, that's a big error on my part. Will get that fixed up right away.
> > > > > 
> > > > > I've been testing the patchset to fix the issues that Andrew pointed
> > > > > out. I can send it soon.
> > > > > 
> > > > > Jens, have you already fixed some?
> > > > 
> > > > I already pushed some of the changes locally, just the idr change is
> > > > missing. See the #bsg branch:
> > > > 
> > > > http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=bsg
> > > 
> > > I see.
> > 
> > Since Linus is happily snoring by now, could you test and see if the
> > tree works for you?
> 
> It works for me. I'll submit some minor patches against your bsg
> branch to scsi-ml. Can you push them together?

Certainly, I'll pull them into the bsg branch.

-- 
Jens Axboe

