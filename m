From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 5/6] Added flush_disk to factor out common buffer cache flushing code.
Date: Thu, 04 Sep 2008 09:13:16 -0400
Message-ID: <x49d4jkm4ur.fsf@segfault.boston.devel.redhat.com>
References: <20080829231254.25065.66052.stgit@bluto.andrew>
	<20080829231320.25065.44013.stgit@bluto.andrew>
	<x4963pd9jnk.fsf@segfault.boston.devel.redhat.com>
	<1220501780.6601.14.camel@grinch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33654 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbYIDNuS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Sep 2008 09:50:18 -0400
In-Reply-To: <1220501780.6601.14.camel@grinch> (Andrew Patterson's message of
	"Thu, 04 Sep 2008 04:16:20 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com

Andrew Patterson <andrew.patterson@hp.com> writes:

> On Wed, 2008-09-03 at 14:19 -0400, Jeff Moyer wrote:
>> Andrew Patterson <andrew.patterson@hp.com> writes:
>> 
>> > Added flush_disk to factor out common buffer cache flushing code.
>> >
>> > We need to be able to flush the buffer cache for for more than
>> > just when a disk is changed, so we factor out common cache flush code
>> > in check_disk_change() to an internal flush_disk() routine.  This
>> > routine will then be used for both disk changes and disk resizes (in a
>> > later patch).
>> >
>> > Include the disk name in the text indicating that there are busy
>> > inodes on the device and increase the KERN severity of the message.
>> >
>> > Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
>> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
>> 
>> > +static void flush_disk(struct block_device *bdev)
>> > +{
>> > +	if (__invalidate_device(bdev)) {
>> > +		char name[BDEVNAME_SIZE] = "";
>> > +
>> > +		if (bdev->bd_disk)
>> > +			disk_name(bdev->bd_disk, 0, name);
>> > +		printk(KERN_WARNING "VFS: busy inodes on changed media %s\n",
>> > +		       name);
>> > +	}
>> 
>> This message will scare folks growing their devices online.  Can you
>> think of some better verbiage for this?
>
> This message is shared with the check_disk_change() routine. Yes, it is
> scary, but perhaps that is to the good. We have no guarantee how the
> user changed the underlying storage.  For example, they might have
> shrunk the volume below the size of an underlying file-system and then
> grew it again before kicking off the resize detection (admittedly a
> degenerate case), in which case the warning is appropriate.  Any
> suggestions on better wording?

I'm not sure how verbose we want to be with printk's;  it's a dilemma.
Any verbiage suggesting that strictly growing the partition is safe
would be welcome, but I agree, that's tough to convey at this point.

I guess I'm okay with things as they stand, but I do think this will
generate customer calls.  ;)

-Jeff
