From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Sat, 31 Oct 2015 18:47:10 -0400
Message-ID: <20151031224707.GA12805@redhat.com>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <20151029131810.GA26841@redhat.com>
 <5634DF67.7060302@redhat.com>
 <20151031181312.GA11587@redhat.com>
 <5635115B.7080805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbbJaWrL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Oct 2015 18:47:11 -0400
Content-Disposition: inline
In-Reply-To: <5635115B.7080805@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: hch@lst.de, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, hare@suse.de, linux-scsi@vger.kernel.org

On Sat, Oct 31 2015 at  3:07pm -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> 
> 
> On 31/10/2015 19:13, Mike Snitzer wrote:
> > > But that's wrong, I think.  It's a false positive in
> > > scsi_verify_blk_ioctl().
> > > 
> > > If the ioctl is valid when bdev becomes non-NULL (and it will be if
> > > ti->len becomes equal to i_size_read(bdev->bd_inode) >> SECTOR_SHIFT),
> > > you should not return -ENOIOCTLCMD aka ENOTTY, because userspace doesn't
> > > think the ioctls can go away and come back.  So Hannes's patch broke the
> > > userspace ABI. :(
> > 
> > Huh?  All that Hannes' patch did was add early verification of the ioctl
> > if there are no paths, since: there is no point queueing an ioctl that
> > is invalid.
> > 
> > [snip discussion of Christoph's patches]
> > 
> > The point is scsi_verify_blk_ioctl() is saying the ioctl isn't valid.
> > It has nothing to do with the existance of a bdev or not; but everything
> > to do with the unprivledged user's request to issue an ioctl.
> 
> ... but the call is skipped (and all ioctls are valid) if ti->len ==
> i_size_read(bdev->bd_inode) >> SECTOR_SHIFT.  Therefore, until you have
> the bdev you don't know which ioctls are valid, and you must assume all
> of them are.  You can't do anything unsafe anyway until you have the
> bdev.  This is the reasoning prior to Hannes's change.

Yes, with your commit ec8013be ("dm: do not forward ioctls from logical
volumes to the underlying device") you added protections to disallow
issuing ioctls to a partition that could impact the rest of the device.

Given that I can see why you're seizing on the "ti->len !=
i_size_read(bdev->bd_inode) >> SECTOR_SHIFT" negative checks that gate
the call to scsi_verify_blk_ioctl().

> Afterwards, you end up calling scsi_verify_blk_ioctl() when bdev ==
> NULL.  If the future bdev satisfies the above condition on ti->len, this
> means that ioctl(SG_IO) switches from ENOTTY to available.  Userspace is
> clearly not expecting that.

For Hannes, and in my head, it didn't matter if a future bdev satisfies
the length condition.  I don't think Hannes was trying to guard against
dangerous partition ioctls being issues by udev... but now I _do_
question what exactly _is_ the point of his commit 21a2807bc3f.  Which
invalid ioctls, from udev, did Hannes' change actually disallow?

I obviously should've asked more questions before now!

At the time, I thought scsi_verify_blk_ioctl() was generally useful.
But it clearly only makes sense in the narrow context of guarding
against partition ioctls expanding their target to the parent block
device.

(scsi_verify_blk_ioctl should be renamed to something like
'scsi_verify_blk_ioctl_partition_safe' but I digress)
 
> > Paolo, AFAIK unprivledged ioctls is one of your pet-projects so your
> > insight on what, if anything, needs changing to support them is the
> > insight I think we need.
> 
> I hope the above provides some extra information.

It did, but you made me work for it ;)

I could've sworn that unprivledged users (without CAP_SYS_RAWIO)
wouldn't be allowed to issue ioctls.  Am I completely mistaken?  Or is
it still contentious and DM-mpath removing the ability to allow these
unprivledged ioctls (as a side-effect of Hannes' commit ec8013be) makes
your life, and other virt users' lives, harder?

Apologies for being out of touch on what the latest is on this
unprivledged ioctl issue.

Given Hannes' commit ec8013be was marked for stable and went in some
time ago we really need to get to resolve this ASAP.

To that end, I'm going to prep a tree that first applies Mauricio's
patch: https://patchwork.kernel.org/patch/7518601/

And I'll then rebase Christoph's DM ioctl changes ontop of it.

Hannes will need to revalidate his desire to verify ioctls in the
context of a dm-multipath device without paths. (sorry Hannes)
