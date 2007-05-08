From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: bidi bsg is non-blocking
Date: Tue, 8 May 2007 14:21:34 +0200
Message-ID: <20070508122134.GI4163@kernel.dk>
References: <OF8468A26D.D2DDFDA3-ON862572D4.004E5BE6-862572D4.005458FE@seagate.com> <20070508162326Q.fujita.tomonori@lab.ntt.co.jp> <20070508163138G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:22561 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933865AbXEHMXt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 08:23:49 -0400
Content-Disposition: inline
In-Reply-To: <20070508163138G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Daniel.E.Messinger@seagate.com, tomof@acm.org, linux-scsi@vger.kernel.org

On Tue, May 08 2007, FUJITA Tomonori wrote:
> > From: Daniel.E.Messinger@seagate.com
> > Subject: bidi bsg is non-blocking
> > Date: Mon, 7 May 2007 10:21:18 -0500
> > 
> > > I'm attempting to use the bidi variant of bsg to talk to an OSD target
> > > device. I've run into an undesirable situation.
> > > 
> > > My application has a free-running receive loop (doing a read() on the bsg
> > > device) waiting for responses to commands sent to bsg by another thread.
> > > The problem is that the receive thread is getting ENODATA from the read()
> > > when there are no commands pending.  I have NOT set non-blocking.
> > > 
> > > Note that the old sg driver was quite willing to block until there was a
> > > response available. I find this scenario greatly preferable.
> > > 
> > > Could bsg be fixed so that read() blocks when there is nothing to return?
> > 
> > I think that this is a bug.
> > 
> > This patch is against the bsg branch in the Jens' git tree.
> > 
> > I guess that it would be nice to do more cleanups on these parts.
> > 
> > 
> > From 52a9fcf0af72f212ddd93918b7f9f0f0e706c215 Mon Sep 17 00:00:00 2001
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Date: Tue, 8 May 2007 15:57:43 +0900
> > Subject: [PATCH] fix read ENODATA bug
> > 
> > This patch fixes a bug that read() gives ENODATA even with a blocking
> > file descriptor when there are no commands pending.
> > 
> > This also includes some cleanups.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Oops, I sent a wrong patch. This is a right one.

Patch looks good, I agree this is the way that bsg should act for a
blocking read on an "empty" queue.

> +		ret = wait_event_interruptible(bd->wq_done, bd->done_cmds);
> +		if (ret) {
> +			bc = ERR_PTR(-ERESTARTSYS);
> +			break;
> +		} else
> +			continue;
>  	} while (1);

The else clause is pointless.

Apart from that, it looks sounds. Can you resend?

-- 
Jens Axboe

