From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: bidi bsg is non-blocking
Date: Tue, 08 May 2007 21:56:20 +0900
Message-ID: <20070508215620M.fujita.tomonori@lab.ntt.co.jp>
References: <20070508162326Q.fujita.tomonori@lab.ntt.co.jp>
	<20070508163138G.fujita.tomonori@lab.ntt.co.jp>
	<20070508122134.GI4163@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:48179 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966805AbXEHM5K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 08:57:10 -0400
In-Reply-To: <20070508122134.GI4163@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, Daniel.E.Messinger@seagate.com, tomof@acm.org, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: bidi bsg is non-blocking
Date: Tue, 8 May 2007 14:21:34 +0200

> On Tue, May 08 2007, FUJITA Tomonori wrote:
> > > From: Daniel.E.Messinger@seagate.com
> > > Subject: bidi bsg is non-blocking
> > > Date: Mon, 7 May 2007 10:21:18 -0500
> > > 
> > > > I'm attempting to use the bidi variant of bsg to talk to an OSD target
> > > > device. I've run into an undesirable situation.
> > > > 
> > > > My application has a free-running receive loop (doing a read() on the bsg
> > > > device) waiting for responses to commands sent to bsg by another thread.
> > > > The problem is that the receive thread is getting ENODATA from the read()
> > > > when there are no commands pending.  I have NOT set non-blocking.
> > > > 
> > > > Note that the old sg driver was quite willing to block until there was a
> > > > response available. I find this scenario greatly preferable.
> > > > 
> > > > Could bsg be fixed so that read() blocks when there is nothing to return?
> > > 
> > > I think that this is a bug.
> > > 
> > > This patch is against the bsg branch in the Jens' git tree.
> > > 
> > > I guess that it would be nice to do more cleanups on these parts.
> > > 
> > > 
> > > From 52a9fcf0af72f212ddd93918b7f9f0f0e706c215 Mon Sep 17 00:00:00 2001
> > > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > Date: Tue, 8 May 2007 15:57:43 +0900
> > > Subject: [PATCH] fix read ENODATA bug
> > > 
> > > This patch fixes a bug that read() gives ENODATA even with a blocking
> > > file descriptor when there are no commands pending.
> > > 
> > > This also includes some cleanups.
> > > 
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > 
> > Oops, I sent a wrong patch. This is a right one.
> 
> Patch looks good, I agree this is the way that bsg should act for a
> blocking read on an "empty" queue.
> 
> > +		ret = wait_event_interruptible(bd->wq_done, bd->done_cmds);
> > +		if (ret) {
> > +			bc = ERR_PTR(-ERESTARTSYS);
> > +			break;
> > +		} else
> > +			continue;
> >  	} while (1);
> 
> The else clause is pointless.

Oops.

> Apart from that, it looks sounds. Can you resend?

Sure, I'll resend an updated version shortly.


BTW, any comments on the bidi patch for the block layer?
