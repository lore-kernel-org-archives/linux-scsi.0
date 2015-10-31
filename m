From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Sat, 31 Oct 2015 20:07:07 +0100
Message-ID: <5635115B.7080805@redhat.com>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <20151029131810.GA26841@redhat.com> <5634DF67.7060302@redhat.com>
 <20151031181312.GA11587@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37404 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbbJaTHQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Oct 2015 15:07:16 -0400
Received: by wmff134 with SMTP id f134so33077070wmf.0
        for <linux-scsi@vger.kernel.org>; Sat, 31 Oct 2015 12:07:15 -0700 (PDT)
In-Reply-To: <20151031181312.GA11587@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, hch@lst.de
Cc: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, hare@suse.de, linux-scsi@vger.kernel.org



On 31/10/2015 19:13, Mike Snitzer wrote:
> > But that's wrong, I think.  It's a false positive in
> > scsi_verify_blk_ioctl().
> > 
> > If the ioctl is valid when bdev becomes non-NULL (and it will be if
> > ti->len becomes equal to i_size_read(bdev->bd_inode) >> SECTOR_SHIFT),
> > you should not return -ENOIOCTLCMD aka ENOTTY, because userspace doesn't
> > think the ioctls can go away and come back.  So Hannes's patch broke the
> > userspace ABI. :(
> 
> Huh?  All that Hannes' patch did was add early verification of the ioctl
> if there are no paths, since: there is no point queueing an ioctl that
> is invalid.
> 
> [snip discussion of Christoph's patches]
> 
> The point is scsi_verify_blk_ioctl() is saying the ioctl isn't valid.
> It has nothing to do with the existance of a bdev or not; but everything
> to do with the unprivledged user's request to issue an ioctl.

... but the call is skipped (and all ioctls are valid) if ti->len ==
i_size_read(bdev->bd_inode) >> SECTOR_SHIFT.  Therefore, until you have
the bdev you don't know which ioctls are valid, and you must assume all
of them are.  You can't do anything unsafe anyway until you have the
bdev.  This is the reasoning prior to Hannes's change.

Afterwards, you end up calling scsi_verify_blk_ioctl() when bdev ==
NULL.  If the future bdev satisfies the above condition on ti->len, this
means that ioctl(SG_IO) switches from ENOTTY to available.  Userspace is
clearly not expecting that.

> Paolo, AFAIK unprivledged ioctls is one of your pet-projects so your
> insight on what, if anything, needs changing to support them is the
> insight I think we need.

I hope the above provides some extra information.

Paolo
