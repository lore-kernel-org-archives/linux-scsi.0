From: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to
 partition
Date: Fri, 15 Jun 2012 10:31:06 -0400
Message-ID: <20120615143106.GA16540@elliptictech.com>
References: <1339757457-15646-1-git-send-email-jack@suse.cz>
 <4FDB13B1.8040100@kernel.dk>
 <20120615135825.GA12847@elliptictech.com>
 <20120615142303.GB19045@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.scalarmail.ca ([98.158.95.75]:26584 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757025Ab2FOObL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2012 10:31:11 -0400
Content-Disposition: inline
In-Reply-To: <20120615142303.GB19045@quack.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <JBottomley@parallels.com>

On 2012-06-15 16:23 +0200, Jan Kara wrote:
> On Fri 15-06-12 09:58:25, Nick Bowler wrote:
> > On 2012-06-15 12:51 +0200, Jens Axboe wrote:
> > > On 06/15/2012 12:50 PM, Jan Kara wrote:
> > > > Sometimes, warnings about ioctls to partition happen often enough that they
> > > > form majority of the warnings in the kernel log and users complain. In some
> > > > cases warnings are about ioctls such as SG_IO so it's not good to get rid of
> > > > the warnings completely as they can ease debugging of userspace problems
> > > > when ioctl is refused.
> > > > 
> > > > Since I have seen warnings from lots of commands, including some proprietary
> > > > userspace applications, I don't think disallowing the ioctls for processes
> > > > with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
> > > > stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.
> > > 
> > > Agree, merged, finally.
> > 
> > Hurray!
> > 
> > This should be -stable material as well, as >=3.2.y kernel versions are
> > affected (I think 3.0.y is OK?).
>   3.0 also spits those warnings. But I'm not convinced this is really a
> -stable material. I don't see anybody loosing sleep over this...

These messages are quite annoying on my raid boxes (currently running
3.2.y) where mdadm spews a whole pile of these whenever you do anything.

Even with the rate limiting, they make up a substantial proportion of
the total log messages.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

