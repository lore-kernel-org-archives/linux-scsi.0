From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: bug 2400
Date: Fri, 2 Apr 2004 09:44:42 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040402174442.GE3880@us.ibm.com>
References: <20040401131502.41136788.akpm@osdl.org> <1080862354.2118.78.camel@mulgrave> <20040402084338.GA3547@us.ibm.com> <1080921450.1804.66.camel@mulgrave> <20040402164531.GB3880@us.ibm.com> <1080925518.1830.93.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 130-94-160-149-dsl.hevanet.com ([130.94.160.149]:28032 "EHLO
	hmsbounty.us.ibm.com") by vger.kernel.org with ESMTP
	id S264134AbUDBRot (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Apr 2004 12:44:49 -0500
Content-Disposition: inline
In-Reply-To: <1080925518.1830.93.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, stern@rowland.harvard.edu

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> On Fri, 2004-04-02 at 11:45, Mike Anderson wrote:
> > Maybe some clarification here as I am unsure if we both think there
> > needs to be a notification (a put call) from outside SCSI. We have
> > release functions available on most objects in SCSI now. The issue is
> > that when we register (add_disk, dev_set_drvdata, etc.) or pass a handle
> > to another subsystem we need a reference count agreement to know when
> > the other subsystem is done with the the object. Something like the
> > put_device(parent) used in scsi_host_dev_release.
> 
> Actually, no, that's not the issue here, if I understand you.  The
> reference counting model on the sdev->sdev_gendev seems to be working
> correctly because sr.c takes a reference to the sdev_gendev on open and
> drops it on close.
> 
> The problem is that ULDs are implemented as struct device_drivers and as
> such, their ->remove method gets called *not* on last put of sdev_gendev
> but on device_del (when there are still active references).

The remove can do as much or as little as the implementor wishes, but I
believe there is still a under lying issue here (see comment below).
> 
> sr.c frees the cdinfo structure on ->remove, but still has its own
> reference to sdev_gendev (because the device is still open). On final
> close, the generic cdrom code tries to use cdinfo to close the device
> and references a kfree'd structure.  Really what sr.c wants to be doing
> is freeing the cdinfo structure on last put, not on device_del.
> 

Where does the last put come from? How do you close the open race or
know when the final put_disk has been called? SCSI cannot do this alone
as we have created and registered an object in another subsystem
(alloc_disk and add_disk) and we have no indication when that objects
ref count has reached zero. 

Or

As I previous stated in the thread below I have the gendisk /
block layer locking mis-understood and there is something that SCSI can
do.

For reference you can look at this thread sent by Alan about a sd race.
http://marc.theaimsgroup.com/?t=107591185800003&r=1&w=2

While freeing in sr could be rearranged more like what sd does there is
still the issue of a cross subsystem put to know that the ULDs open
function will not be called again.

-andmike
--
Michael Anderson
andmike@us.ibm.com

