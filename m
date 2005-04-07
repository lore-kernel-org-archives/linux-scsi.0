From: Jens Axboe <axboe@suse.de>
Subject: Re: [OOPS] 2.6.11 - NMI lockup with CFQ scheduler
Date: Thu, 7 Apr 2005 15:24:18 +0200
Message-ID: <20050407132416.GH1847@suse.de>
References: <20050329115405.97559.qmail@web52909.mail.yahoo.com> <20050329120311.GO16636@suse.de> <1112804840.5476.16.camel@mulgrave> <20050406175838.GC15165@suse.de> <1112811607.5555.15.camel@mulgrave> <20050406190838.GE15165@suse.de> <1112821799.5850.19.camel@mulgrave> <20050407064934.GJ15165@suse.de> <1112879919.5842.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:15816 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262467AbVDGN3W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2005 09:29:22 -0400
Content-Disposition: inline
In-Reply-To: <1112879919.5842.3.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Chris Rankin <rankincj@yahoo.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Apr 07 2005, James Bottomley wrote:
> On Thu, 2005-04-07 at 08:49 +0200, Jens Axboe wrote:
> > On Wed, Apr 06 2005, James Bottomley wrote:
> > > My proposal is to correct this by moving the data back to the correct
> > > object, and make any object using it hold a reference, so this would
> > > make the provider of the block request_fn hold a reference to the queue
> > > and initialise the queue lock pointer with the lock currently in the
> > > queue.  Drivers that still use a global lock would be unaffected.  This
> > 
> > But this is the current requirement, as long as you use the queue you
> > must hold a reference to it.
> 
> Exactly! that's why I think this solution must work independently of
> subsystem.
> 
> > What do you think of the attached, then? Allow NULL lock to be passed
> > in, in which case we use the queue private lock (that no one should ever
> > ever touch). It looks a little confusing that
> > sdev->request_queue->queue_lock now protects some sdev structures, if
> > you want we can retain ->sdev_lock but as a pointer to the queue lock
> > instead.
> 
> Looks good.  How about the attached modification?  It makes sdev_lock a
> pointer that uses the queue lock which we null out when we release it
> (not that I don't trust SCSI or anything ;-)

That's fine with me, up to you. As I mentioned, it does look less
confusing to have the lock associated with sdev still.

-- 
Jens Axboe

