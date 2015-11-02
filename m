From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Mon, 2 Nov 2015 10:55:40 +0100
Message-ID: <5637331C.3060908@redhat.com>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <20151029131810.GA26841@redhat.com> <5634DF67.7060302@redhat.com>
 <20151031181312.GA11587@redhat.com> <5635115B.7080805@redhat.com>
 <20151031224707.GA12805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbbKBJzp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 04:55:45 -0500
In-Reply-To: <20151031224707.GA12805@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: hch@lst.de, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, hare@suse.de, linux-scsi@vger.kernel.org



On 31/10/2015 23:47, Mike Snitzer wrote:
> Yes, with your commit ec8013be ("dm: do not forward ioctls from logical
> volumes to the underlying device") you added protections to disallow
> issuing ioctls to a partition that could impact the rest of the device.
> 
> Given that I can see why you're seizing on the "ti->len !=
> i_size_read(bdev->bd_inode) >> SECTOR_SHIFT" negative checks that gate
> the call to scsi_verify_blk_ioctl().

Right.

> For Hannes, and in my head, it didn't matter if a future bdev satisfies
> the length condition.

I agree actually.  The only problem is that the returned errno value is
ENOTTY, and to userspace that "sounds like" a future bdev will not make
the ioctl valid.

> I could've sworn that unprivledged users (without CAP_SYS_RAWIO)
> wouldn't be allowed to issue ioctls.  Am I completely mistaken?

They are allowed to issue ioctls.

CAP_SYS_RAWIO changes that to also allow issuing of ioctls to
partitions.  That was required by Linus for backwards compatibility.

> Or is
> it still contentious and DM-mpath removing the ability to allow these
> unprivledged ioctls (as a side-effect of Hannes' commit ec8013be) makes
> your life, and other virt users' lives, harder?

Yes, it would.  virt runs as an unprivileged user (so does CD burning,
which was the original reason to let SG_IO run by unprivileged users;
there are probably other use cases).

Paolo
