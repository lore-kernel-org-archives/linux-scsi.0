From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2.6.32-stable] block: fail SCSI passthrough ioctls on
 partition devices
Date: Fri, 27 Jan 2012 15:23:35 -0800
Message-ID: <20120127232335.GA19109@kroah.com>
References: <20120126213307.GA28807@suse.de>
 <1327683414-31156-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1327683414-31156-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 27, 2012 at 05:56:54PM +0100, Paolo Bonzini wrote:
> commit 0bfc96cb77224736dfa35c3c555d37b3646ef35e upstream.
> 
> Linux allows executing the SG_IO ioctl on a partition or LVM volume, and
> will pass the command to the underlying block device.  This is
> well-known, but it is also a large security problem when (via Unix
> permissions, ACLs, SELinux or a combination thereof) a program or user
> needs to be granted access only to part of the disk.
> 
> This patch lets partitions forward a small set of harmless ioctls;
> others are logged with printk so that we can see which ioctls are
> actually sent.  In my tests only CDROM_GET_CAPABILITY actually occurred.
> Of course it was being sent to a (partition on a) hard disk, so it would
> have failed with ENOTTY and the patch isn't changing anything in
> practice.  Still, I'm treating it specially to avoid spamming the logs.
> 
> In principle, this restriction should include programs running with
> CAP_SYS_RAWIO.  If for example I let a program access /dev/sda2 and
> /dev/sdb, it still should not be able to read/write outside the
> boundaries of /dev/sda2 independent of the capabilities.  However, for
> now programs with CAP_SYS_RAWIO will still be allowed to send the
> ioctls.  Their actions will still be logged.
> 
> This patch does not affect the non-libata IDE driver.  That driver
> however already tests for bd != bd->bd_contains before issuing some
> ioctl; it could be restricted further to forbid these ioctls even for
> programs running with CAP_SYS_ADMIN/CAP_SYS_RAWIO.
> 
> Cc: linux-scsi@vger.kernel.org
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: James Bottomley <JBottomley@parallels.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [ Make it also print the command name when warning - Linus ]
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> [ Changes with respect to 3.3: return -ENOTTY from scsi_verify_blk_ioctl
>   and -ENOIOCTLCMD from sd_compat_ioctl. ]

Thanks, I've replaced the version in the 2.6.32-stable queue with this
one.

greg k-h
