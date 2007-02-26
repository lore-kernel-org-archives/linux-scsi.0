From: Theodore Tso <tytso@mit.edu>
Subject: Re: end to end error recovery musings
Date: Mon, 26 Feb 2007 08:25:11 -0500
Message-ID: <20070226132511.GB8154@thunk.org>
References: <45DEF6EF.3020509@emc.com> <45DF80C9.5080606@zytor.com> <20070224003723.GS10715@schatzie.adilger.int> <20070224023229.GB4380@thunk.org> <17890.28977.989203.938339@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49521 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030232AbXBZN02 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Feb 2007 08:26:28 -0500
Content-Disposition: inline
In-Reply-To: <17890.28977.989203.938339@notabene.brown>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ric Wheeler <ric@emc.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>

On Mon, Feb 26, 2007 at 04:33:37PM +1100, Neil Brown wrote:
> Do we want a path in the other direction to handle write errors?  The
> file system could say "Don't worry to much if this block cannot be
> written, just return an error and I will write it somewhere else"?
> This might allow md not to fail a whole drive if there is a single
> write error.

Can someone with knowledge of current disk drive behavior confirm that
for all drives that support bad block sparing, if an attempt to write
to a particular spot on disk results in an error due to bad media at
that spot, the disk drive will automatically rewrite the sector to a
sector in its spare pool, and automatically redirect that sector to
the new location.  I believe this should be always true, so presumably
with all modern disk drives a write error should mean something very
serious has happend.  

(Or that someone was in the middle of reconfiguring a FC network and
they're running a kernel that doesn't understand why short-duration FC
timeouts should be retried.  :-)

> Or is that completely un-necessary as all modern devices do bad-block
> relocation for us?
> Is there any need for a bad-block-relocating layer in md or dm?

That's the question.  It wouldn't be that hard for filesystems to be
able to remap a data block, but (a) it would be much more difficult
for fundamental metadata (for example, the inode table), and (b) it's
unnecessary complexity if the lower levels in the storage stack should
always be doing this for us in the case of media errors anyway.

> What about corrected-error counts?  Drives provide them with SMART.
> The SCSI layer could provide some as well.  Md can do a similar thing
> to some extent.  Where these are actually useful predictors of pending
> failure is unclear, but there could be some value.
> e.g. after a certain number of recovered errors raid5 could trigger a
> background consistency check, or a filesystem could trigger a
> background fsck should it support that.

Somewhat off-topic, but my one big regret with how the dm vs. evms
competition settled out was that evms had the ability to perform block
device snapshots using a non-LVM volume as the base --- and that EVMS
allowed a single drive to be partially managed by the LVM layer, and
partially managed by evms.  

What this allowed is the ability to do device snapshots and therefore
background fsck's without needing to convert the entire laptop disk to
using a LVM solution (since to this day I still don't trust initrd's
to always do the right thing when I am constantly replacing the kernel
for kernel development).

I know, I'm weird, distro users have initrd that seem to mostly work,
and it's only wierd developers that try to use bleeding edge kernels
with a RHEL4 userspace that suffer, but it's one of the reasons why
I've avoided initrd's like the plague --- I've wasted entire days
trying to debug problems with the userspace-provided initrd being too
old to support newer 2.6 development kernels.

In any case, the reason why I bring this up is that it would be really
nice if there was a way with a single laptop drive to be able to do
snapshots and background fsck's without having to use initrd's with
device mapper.

						- Ted
