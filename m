From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
Date: Wed, 8 Jul 2009 18:57:28 +0200
Message-ID: <20090708165728.GU23611@kernel.dk>
References: <4A4CB4B4.5010307@turknet.net.tr> <20090702130728.22af524c.akpm@linux-foundation.org> <8db1092f0907080609w60e37ac0id49a44bd4796b425@mail.gmail.com> <1247063244.4159.40.camel@mulgrave.site> <1247069178.5973.6.camel@desktop> <1247071445.4159.214.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:37916 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbZGHQ5a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2009 12:57:30 -0400
Content-Disposition: inline
In-Reply-To: <1247071445.4159.214.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Maciej Rutecki <maciej.rutecki@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jul 08 2009, James Bottomley wrote:
> On Wed, 2009-07-08 at 09:06 -0700, Daniel Walker wrote:
> > On Wed, 2009-07-08 at 09:27 -0500, James Bottomley wrote:
> > > 
> > > You might also try this patch from martin petersen:  it will print out
> > > the actual command that's causing the problems ... that might give a
> > > clue.
> > > 
> > > James
> > 
> > On the bugzilla entry ,
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=13727
> > 
> > Thomas Meyer indicated it was (possibly) the following commit,
> > 
> > 018e0446890661504783f92388ecce7138c1566d
> > 
> > I added Jens to the CC ..
> 
> So thats:
> 
> commit 018e0446890661504783f92388ecce7138c1566d
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Fri Jun 26 16:27:10 2009 +0200
> 
>     block: get rid of queue-private command filter
> 
> What this tends to suggest is that the command filter was blocking some
> type of command sent from user space which is causing the problem, and
> now we're letting it through.  Restoring the command filter will work
> around the problem, but the root cause should be finding and fixing
> whatever is issuing the commands in the first place.

There should be no functional change, since the filters were all the
same. Perhaps blk_scsi_ioctl_init() isn't being run, a good start would
be to stick a printk() in there and verify that it's actually being
executed. I've been tricked by __init before.

-- 
Jens Axboe

