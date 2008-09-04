From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [PATCH 5/6] Added flush_disk to factor out common buffer cache
	flushing code.
Date: Thu, 04 Sep 2008 04:16:20 +0000
Message-ID: <1220501780.6601.14.camel@grinch>
References: <20080829231254.25065.66052.stgit@bluto.andrew>
	 <20080829231320.25065.44013.stgit@bluto.andrew>
	 <x4963pd9jnk.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:12093 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYIDEQZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2008 00:16:25 -0400
In-Reply-To: <x4963pd9jnk.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com

On Wed, 2008-09-03 at 14:19 -0400, Jeff Moyer wrote:
> Andrew Patterson <andrew.patterson@hp.com> writes:
> 
> > Added flush_disk to factor out common buffer cache flushing code.
> >
> > We need to be able to flush the buffer cache for for more than
> > just when a disk is changed, so we factor out common cache flush code
> > in check_disk_change() to an internal flush_disk() routine.  This
> > routine will then be used for both disk changes and disk resizes (in a
> > later patch).
> >
> > Include the disk name in the text indicating that there are busy
> > inodes on the device and increase the KERN severity of the message.
> >
> > Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> 
> > +static void flush_disk(struct block_device *bdev)
> > +{
> > +	if (__invalidate_device(bdev)) {
> > +		char name[BDEVNAME_SIZE] = "";
> > +
> > +		if (bdev->bd_disk)
> > +			disk_name(bdev->bd_disk, 0, name);
> > +		printk(KERN_WARNING "VFS: busy inodes on changed media %s\n",
> > +		       name);
> > +	}
> 
> This message will scare folks growing their devices online.  Can you
> think of some better verbiage for this?

This message is shared with the check_disk_change() routine. Yes, it is
scary, but perhaps that is to the good. We have no guarantee how the
user changed the underlying storage.  For example, they might have
shrunk the volume below the size of an underlying file-system and then
grew it again before kicking off the resize detection (admittedly a
degenerate case), in which case the warning is appropriate.  Any
suggestions on better wording?

Andrew

