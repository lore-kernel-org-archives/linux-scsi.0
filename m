From: Jens Axboe <axboe@suse.de>
Subject: Re: [OOPS] 2.6.11 - NMI lockup with CFQ scheduler
Date: Wed, 6 Apr 2005 19:58:39 +0200
Message-ID: <20050406175838.GC15165@suse.de>
References: <20050329115405.97559.qmail@web52909.mail.yahoo.com> <20050329120311.GO16636@suse.de> <1112804840.5476.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:3743 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262269AbVDFR65 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2005 13:58:57 -0400
Content-Disposition: inline
In-Reply-To: <1112804840.5476.16.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Chris Rankin <rankincj@yahoo.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Apr 06 2005, James Bottomley wrote:
> On Tue, 2005-03-29 at 14:03 +0200, Jens Axboe wrote:
> > It is quite a serious problem, not just for CFQ. SCSI referencing is
> > badly broken there.
> 
> OK ... I accept that with regard to the queue lock.

It is much deeper than that. The recent hack to kill requests is yet
another example of that. At least this work-around makes it a little
better, but the mid layer assumption that sdev going to zero implies the
queue going away at the same time is inherently broken.

> However, rather than trying to work out a way to tie all the refcounted
> objects together, what about the simpler solution of making the lock
> bound to the lifetime of the queue?

That's essentially what the work-around does.

> As far as SCSI is concerned, we could simply move the lock into the
> request_queue structure and everything would work since the device holds
> a reference to the queue.  The way it would work is that we'd simply
> have a lock in the request_queue structure, but it would be up to the
> device to pass it in in blk_init_queue.  Then we'd alter the scsi_device
> sdev_lock to be a pointer to the queue lock?  This scheme would also
> work for the current users who have a global lock (they simply wouldn't
> use the lock int the request_queue).
> 
> The only could on the horizon with this scheme is that there may
> genuinely be places where we want multiple queues to share a non-global
> lock:  situations where we have shared issue queues (like IDE), or
> shared tag resources are a possibility.  To cope with those, we'd
> probably have to have a separately allocated, reference counted lock.
> 
> However, I'm happy to implement the simpler solution (lock in
> requuest_queue) if you agree.

I rather like the queue lock being a pointer, so you can share at
whatever level you want. Lets not grow the request_queue a full lock
just to work around a bug elsewhere.

-- 
Jens Axboe

