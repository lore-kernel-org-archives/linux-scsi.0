From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: sd: add a capacity_override attribute
Date: Fri, 20 Mar 2015 12:32:07 -0400
Message-ID: <1426869127.19806.83.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.1503201201180.1618-100000@iolanthe.rowland.org>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbbCTQcM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Mar 2015 12:32:12 -0400
In-Reply-To: <Pine.LNX.4.44L0.1503201201180.1618-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2015-03-20 at 12:03 -0400, Alan Stern wrote:
> On Fri, 20 Mar 2015, Ewan Milne wrote:
> 
> > On Fri, 2015-03-20 at 11:19 -0400, Alan Stern wrote:
> > > On Fri, 20 Mar 2015, Ewan Milne wrote:
> > > 
> > > > On Tue, 2015-03-17 at 14:08 -0400, Alan Stern wrote:
> > > > > This patch provides a sysfs interface allowing users to override the
> > > > > capacity of a SCSI disk.  This will help in situations where a buggy
> > > > > USB-SATA adapter fails to support READ CAPACITY(16) and reports only
> > > > > the low 32 bits of the capacity in its READ CAPACITY(10) reply.  For
> > > > > an example, see this thread:
> > > > > 
> > > > > 	http://marc.info/?l=linux-scsi&m=140908235510961&w=2
> > > > > 
> > > > > The interface is awkward because it requires the user to tell the
> > > > > system to re-read the disk's partition table afterward, but at least
> > > > > it provides a way to handle deficient hardware.
> > > > 
> > > > I think that it is confusing that writing into the capacity_override
> > > > sysfs node does not get immediately reflected in the gendisk structure.
> > > > Would it hurt to call sd_revalidate_disk() after the value is changed
> > > > in capacity_override_store()?
> > > 
> > > It wouldn't hurt, but it wouldn't help much either.
> > > 
> > > sd_revalidate_disk() might cause the new size to show up in the
> > > gendisk structure, but it would not cause the partition table to be
> > > parsed again.  That's the real reason for doing this -- when a drive
> > > seems to have fewer blocks than it really does, partitions that extend
> > > beyond the "end" of the drive are rejected.
> > 
> > OK, I see.
> > 
> > > 
> > > > The thing is, if someone overrides the capacity but does not do anything
> > > > right away to revalidate the disk, it could change at some arbitrary
> > > > time in the future when the revalidation happens for some other reason.
> > > 
> > > That's why the documentation says that users must force the system to 
> > > re-read the partition table after writing the sysfs attribute.  In my 
> > > tests, doing that caused a revalidation.
> > > 
> > > Are you saying that could have been a coincidence?  It's possible -- I 
> > > don't understand the design of the block layer.
> > 
> > No, I think that re-reading the partition table will revalidate.  What I
> > was concerned about is some unsuspecting user writing to the
> > capacity_override sysfs node, observing that it didn't seem to do
> > anything, and being surprised when it changed later.  (I've seen some
> > issues with multipath, for example, which will stop using a path if the
> > capacity changes.)  I guess it's a "principle of least surprise" thing.
> > 
> > Having said that, if this is what is needed to make the devices work...
> > 
> > Reviewed-by: Ewan D. Milne <emilne@redhat.com>
> 
> Thanks.  I don't _mind_ adding an sd_revalidate_disk() call if you 
> think it will improve the patch.  What's your suggestion?
> 

If that does not cause the partition table to be updated, then it
doesn't solve your problem, so I'd leave it the way it is, for now.

-Ewan

> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


