From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] scsi: sd: add a capacity_override attribute
Date: Fri, 20 Mar 2015 11:19:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1503201108560.1618-100000@iolanthe.rowland.org>
References: <1426862400.19806.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58822 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750852AbbCTPTS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2015 11:19:18 -0400
In-Reply-To: <1426862400.19806.40.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ewan Milne <emilne@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 20 Mar 2015, Ewan Milne wrote:

> On Tue, 2015-03-17 at 14:08 -0400, Alan Stern wrote:
> > This patch provides a sysfs interface allowing users to override the
> > capacity of a SCSI disk.  This will help in situations where a buggy
> > USB-SATA adapter fails to support READ CAPACITY(16) and reports only
> > the low 32 bits of the capacity in its READ CAPACITY(10) reply.  For
> > an example, see this thread:
> > 
> > 	http://marc.info/?l=linux-scsi&m=140908235510961&w=2
> > 
> > The interface is awkward because it requires the user to tell the
> > system to re-read the disk's partition table afterward, but at least
> > it provides a way to handle deficient hardware.
> 
> I think that it is confusing that writing into the capacity_override
> sysfs node does not get immediately reflected in the gendisk structure.
> Would it hurt to call sd_revalidate_disk() after the value is changed
> in capacity_override_store()?

It wouldn't hurt, but it wouldn't help much either.

sd_revalidate_disk() might cause the new size to show up in the
gendisk structure, but it would not cause the partition table to be
parsed again.  That's the real reason for doing this -- when a drive
seems to have fewer blocks than it really does, partitions that extend
beyond the "end" of the drive are rejected.

> The thing is, if someone overrides the capacity but does not do anything
> right away to revalidate the disk, it could change at some arbitrary
> time in the future when the revalidation happens for some other reason.

That's why the documentation says that users must force the system to 
re-read the partition table after writing the sysfs attribute.  In my 
tests, doing that caused a revalidation.

Are you saying that could have been a coincidence?  It's possible -- I 
don't understand the design of the block layer.

Alan Stern

