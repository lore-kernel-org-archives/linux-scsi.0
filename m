From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Sat, 31 Oct 2015 16:33:59 +0100
Message-ID: <5634DF67.7060302@redhat.com>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <20151029131810.GA26841@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38299 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbbJaPeG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Oct 2015 11:34:06 -0400
Received: by wmeg8 with SMTP id g8so31085367wme.1
        for <linux-scsi@vger.kernel.org>; Sat, 31 Oct 2015 08:34:04 -0700 (PDT)
In-Reply-To: <20151029131810.GA26841@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com, hare@suse.de, linux-scsi@vger.kernel.org



On 29/10/2015 14:18, Mike Snitzer wrote:
> > 4) dmesg shows that scsi_verify_blk_ioctl() failed for SG_IO (0x2285);
> >    it returns -ENOIOCTLCMD, later replaced with -ENOTTY in vfs_ioctl().
> > 
> >     $ dmesg
> >     <...>
> >     [] device-mapper: multipath: Failing path 65:144.
> >     [] device-mapper: multipath: Failing path 67:144.
> >     [] device-mapper: multipath: Failing path 65:224.
> >     [] device-mapper: multipath: Failing path 68:32.
> >     [] sgio_inquiry: sending ioctl 2285 to a partition!
> 
> So scsi_verify_blk_ioctl() considers the ioctl invalid.

But that's wrong, I think.  It's a false positive in
scsi_verify_blk_ioctl().

If the ioctl is valid when bdev becomes non-NULL (and it will be if
ti->len becomes equal to i_size_read(bdev->bd_inode) >> SECTOR_SHIFT),
you should not return -ENOIOCTLCMD aka ENOTTY, because userspace doesn't
think the ioctls can go away and come back.  So Hannes's patch broke the
userspace ABI. :(

Paolo
