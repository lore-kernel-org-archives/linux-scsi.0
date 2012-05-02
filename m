From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to
 partition
Date: Wed, 2 May 2012 15:51:23 +0200
Message-ID: <20120502135123.GF16976@quack.suse.cz>
References: <1335953452-10460-1-git-send-email-jack@suse.cz>
 <4FA1092E.9090603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FA1092E.9090603@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed 02-05-12 12:15:10, Paolo Bonzini wrote:
> Il 02/05/2012 12:10, Jan Kara ha scritto:
> > Sometimes, warnings about ioctls to partition happen often enough that they
> > form majority of the warnings in the kernel log and users complain. In some
> > cases warnings are about ioctls such as SG_IO so it's not good to get rid of
> > the warnings completely as they can ease debugging of userspace problems
> > when ioctl is refused.
> > 
> > Since I have seen warnings from lots of commands, including some proprietary
> > userspace applications, I don't think disallowing the ioctls for processes
> > with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
> > stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.
> 
> NACK.  I would bet that all the warnings you've seen are for ioctl that
> would have failed anyway with ENOTTY.
  Actually, you would loose the bet ;) The customer was complaining about
warning about SG_IO ioctl. Apparently some Veritas filesystem thread generates
a *lot* of these (I don't know if they happen to do all the filesystem IO
with SG_IO and I'm not sure I want to know ;). Given this I don't think we
want to block SG_IO for CAP_SYS_RAWIO threads in the near future if ever...

> The right fix has already been posted, we've been carrying it in RHEL
> for over six months and not a single bug has been seen.
  Your patch won't work for our customer because you still generate
messages for SG_IO. Also I tend to side with Alan that I don't quite see
the point in trying to restrict CAP_SYS_RAWIO threads and thus breaking the
compatibility (if ioctls would be restricted for partitions from the
beginning, then sure it seems like a cleaner choice). But I don't feel that
strongly about it.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
