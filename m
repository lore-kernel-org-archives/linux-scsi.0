From: Tejun Heo <tj@kernel.org>
Subject: Re: Race condition between "read CFQ stats" and "block device
 shutdown"
Date: Thu, 26 Sep 2013 09:54:43 -0400
Message-ID: <20130926135443.GC2480@htj.dyndns.org>
References: <CAOMFOmXJ5ZTYdOvdUt-oxsouhPGRmMshCRhn6AFgmFAGZw5WZA@mail.gmail.com>
 <5226D661.7070301@suse.de>
 <CAOMFOmUCqXN1uaqBEWH3PStuZXvnvLw=YrARgv7DvqO6Y4bFPQ@mail.gmail.com>
 <20130904160723.GC26609@mtj.dyndns.org>
 <CAOMFOmWWfxCZ7ND_Vso4UkSEOqGm=o-xsqrfrj5MKdf9_jr1gA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:45424 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab3IZNyq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2013 09:54:46 -0400
Content-Disposition: inline
In-Reply-To: <CAOMFOmWWfxCZ7ND_Vso4UkSEOqGm=o-xsqrfrj5MKdf9_jr1gA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, Cgroups <cgroups@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

Hello, (cc'ing linux-scsi)

On Wed, Sep 25, 2013 at 01:37:51PM -0700, Anatol Pomozov wrote:
> Hi
> 
> On Wed, Sep 4, 2013 at 9:07 AM, Tejun Heo <tj@kernel.org> wrote:
> > Hello,
> >
> > On Wed, Sep 04, 2013 at 08:45:33AM -0700, Anatol Pomozov wrote:
> >> I am not an expect in block code, so I have a few questions here:
> >>
> >> - are we sure that this operation is atomic? What if blkg->q becomes
> >> dead right after we checked it, and blkg->q->queue_lock got invalid so
> >> we have the same crash as before?
> >
> > request_queue lock switching is something inherently broken in block
> > layer.  It's unsalvageable.
> 
> Fully agree. The problem that request_queue->queue_lock is a shared
> resource that concurrently modified/accessed. In this case (when one
> thread changes, another thread access it) we need synchronization to
> prevent race conditions. So we need a spin_lock to access queue_lock
> spin_lock, otherwise we have a crash like one above...
> 
> >  Maybe we can drop lock switching once blk-mq is fully merged.
> 
> Could you please provide more information about it? What is the timeline?

I have no idea.  Hopefully, not too far out.  Jens would have better
idea.

> If there is an easy way to fix the race condition I would like to
> help. Please give me some pointer what direction I should move.

The first step would be identifying who are actually making use of
lock switching, why and how much difference it would make for them to
not do that.

> PS Just a little bit of context why I care about this bug. We test a
> large farm that actively uses iscsi. We are going to have a lot of
> iscsi device startup/shutdown. I am testing whether this codepath has
> race conditions and I found one above.

Thanks.

-- 
tejun
