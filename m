From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: bug 2400
Date: Fri, 2 Apr 2004 15:40:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040402234051.GB1472@us.ibm.com>
References: <20040401131502.41136788.akpm@osdl.org> <1080862354.2118.78.camel@mulgrave> <20040402084338.GA3547@us.ibm.com> <1080921450.1804.66.camel@mulgrave> <20040402164531.GB3880@us.ibm.com> <1080925518.1830.93.camel@mulgrave> <20040402174442.GE3880@us.ibm.com> <1080929583.1804.122.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:53392 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261389AbUDBXlS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2004 18:41:18 -0500
Content-Disposition: inline
In-Reply-To: <1080929583.1804.122.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, stern@rowland.harvard.edu

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> On Fri, 2004-04-02 at 12:44, Mike Anderson wrote:
> > Where does the last put come from? How do you close the open race or
> > know when the final put_disk has been called? SCSI cannot do this alone
> > as we have created and registered an object in another subsystem
> > (alloc_disk and add_disk) and we have no indication when that objects
> > ref count has reached zero. 
> > 
> > Or
> > 
> > As I previous stated in the thread below I have the gendisk /
> > block layer locking mis-understood and there is something that SCSI can
> > do.
> 
> well, sr has elected to merge these, so it takes a reference to
> sdev_gendev on first open and releases it on last close of the block
> device.  This is what ties the SCSI model into the final put_disk().

I think there is a little more to tie this together. see below.

> 
> We founder on calling driver ->remove before the final put of
> sdev_gendev.

I do not believe we founder by calling, but what we do in the remove
function. The way sd is split out seems to match what you think remove
should do, but I do not have externally callable a release as it is
handled inside sd.

> 
> Anything with objects in more than one refcounted subsystem is
> responsible for tying the refcounts together uniformly.
> 
> There should be no open race as long as we error out correctly if a
> reference to the underlying sdev_gendev cannot be obtained (because the
> object is being destroyed).  sr seems to do this correctly.  The
> indication when the non-scsi object's refcount reaches zero is given to
> us because at that point the sr code does a put of the sdev_gendev (and
> if this is the last put, that should trigger cleanup).

Greg stopped by and after talking this over I think I see why sd is
racing in its current form. The race happens when sd_remove and do_open
race. Even though I do not like adding a lock_kernel it would appear
adding on to sd_remove would serialize sd_remove and do_open. This would
ensure either do_open's get_gendisk returns a gendisk struct and sd
ref's are incremented or we will start cleaning up and sd_open will not
be called.

I would believe similar alignment in sr.c to what sd is doing plus
agreement on the lock_kernel should fix both drivers.

I think the "error out correctly" on trying to get a ref on sdev_gendev
may need some higher serialization as I think there is a race on a release
function starting and the reference count trying to be taken to 1 (i.e.
you need something subsystem wide as you cannot look at the item you
maybe deleting.

-andmike
--
Michael Anderson
andmike@us.ibm.com

