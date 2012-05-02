From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to
 partition
Date: Wed, 2 May 2012 21:49:45 +0200
Message-ID: <20120502194945.GB18339@quack.suse.cz>
References: <1335953452-10460-1-git-send-email-jack@suse.cz>
 <4FA1092E.9090603@redhat.com>
 <20120502135123.GF16976@quack.suse.cz>
 <4FA13DDF.9010006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FA13DDF.9010006@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed 02-05-12 15:59:59, Paolo Bonzini wrote:
> Il 02/05/2012 15:51, Jan Kara ha scritto:
> >> > NACK.  I would bet that all the warnings you've seen are for ioctl that
> >> > would have failed anyway with ENOTTY.
> >   Actually, you would loose the bet ;)
> 
> Doh. :)
> 
> > The customer was complaining about
> > warning about SG_IO ioctl. Apparently some Veritas filesystem thread generates
> > a *lot* of these (I don't know if they happen to do all the filesystem IO
> > with SG_IO and I'm not sure I want to know ;).
> 
> Can you at least ask the customer for help finding which command was
> sent?  And perhaps have them try a kernel that blocks SG_IO to see what
> breaks if anything?
  I'm not sure they would be willing to try a different kernel because it's
a production system. But maybe I can find out what SG_IO command is sent
via strace?

> > Also I tend to side with Alan that I don't quite see
> > the point in trying to restrict CAP_SYS_RAWIO threads and thus breaking the
> > compatibility
> 
> For example, we have a customer that wants this:
> 
> * a VM should be able to send vendor-specific commands to a disk via
> SG_IO (vendor-specific commands require CAP_SYS_RAWIO).
> 
> * they want to assign logical volumes or partitions to the same VM
> without letting it read or write outside the logical volume or partition.
  But then it seems like they really want to be able to forbid sending
SG_IO commands to some devices while allowing them for other devices and
the distinction by partition / non-partition is a bit arbitrary?
 
> Of course a better solution for this would be customizable filters for
> SG_IO commands, where a privileged application would open the block
> device with CAP_SYS_RAWIO, set the filter and hand the file descriptor
> to QEMU.  Or alternatively some extension of the device cgroup.  But
> either solution would require a large amount of work.
  I'm not sure whether you need to filter individual SG_IO commands or not.
For your use case it seems that being able to forbid SG_IO completely for
some fd (which would be passed to qemu) would be enough? But maybe filters
are simpler to implement because they already exist, I don't really know...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
