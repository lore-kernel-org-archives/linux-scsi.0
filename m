From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Mon, 2 Nov 2015 08:31:20 -0500
Message-ID: <20151102133119.GA23234@redhat.com>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <20151029131810.GA26841@redhat.com>
 <5634DF67.7060302@redhat.com>
 <20151031181312.GA11587@redhat.com>
 <5635115B.7080805@redhat.com>
 <20151031224707.GA12805@redhat.com>
 <56371095.6020400@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbbKBNbV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 08:31:21 -0500
Content-Disposition: inline
In-Reply-To: <56371095.6020400@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, hch@lst.de, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Mon, Nov 02 2015 at  2:28am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 10/31/2015 11:47 PM, Mike Snitzer wrote:
> > 
> > For Hannes, and in my head, it didn't matter if a future bdev satisfies
> > the length condition.  I don't think Hannes was trying to guard against
> > dangerous partition ioctls being issued by udev... but now I _do_
> > question what exactly _is_ the point of his commit 21a2807bc3f.  Which
> > invalid ioctls, from udev, did Hannes' change actually disallow?
> > 

FYI, I meant s/21a2807bc3f/a1989b33/

> The reasoning is thus:
> 
> With the original code we would need to wait for path activation
> before we would be able to figure out if the ioctl is valid.
> However, the callback to verify the ioctl is sd_ioctl(), which as
> a first step calls scsi_verify_ioctl().
> So my reasoning was that we can as well call scsi_verify_ioctl()
> early, and allow it to filter out known invalid ioctls.
> Then we wouldn't need to wait for path activation and return
> immediately.

Right, I understood that to be your intent.  And it seemed reasonible.
Unfortuntely, as we now know, scsi_verify_blk_ioctl() only really cares
to filter out ioctls that are invalid for partitions.

I'm still curious: which ioctls were being issued by udev that your
commit a1989b33 "fixed" (so udev workers didn't hang)?  Is the right fix
to modify udev to not issue such ioctls?  What was invalid about the
udev issued ioctls?

> Incidentally, in the 'r == -ENOTCONN' case, we're waiting
> for path activation, but then just bail out with -ENOTCONN.
> As we're not resetting -ENOTCONN, where's the point in activate the
> paths here?
> Shouldn't we retry to figure out if -ENOTCONN is still true?

We do, in DM core, see _your_ commit that added this ;)
6c182cd88d ("dm mpath: fix ioctl deadlock when no paths")
