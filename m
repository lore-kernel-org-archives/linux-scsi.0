From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: bug 2400
Date: Fri, 2 Apr 2004 00:43:38 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040402084338.GA3547@us.ibm.com>
References: <20040401131502.41136788.akpm@osdl.org> <1080862354.2118.78.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 130-94-160-149-dsl.hevanet.com ([130.94.160.149]:23936 "EHLO
	hmsbounty.us.ibm.com") by vger.kernel.org with ESMTP
	id S263361AbUDBInq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Apr 2004 03:43:46 -0500
Content-Disposition: inline
In-Reply-To: <1080862354.2118.78.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, stern@rowland.harvard.edu

James Bottomley [James.Bottomley@steeleye.com] wrote:
> 
> Well, I know why this happens, but I'm not entirely clear how to fix it.
> 
> The problem comes because the cdrom open and close take and release
> references to the SCSI generic device (as they're supposed to).
> 
> However, Upper level Drivers like sr are implemented as generic device
> drivers in the driverfs model.
> 
> When a USB unplug comes along, it calls scsi_remove_device, which
> eventually calls device_del().  The problem is that device_del triggers
> the ->remove methods of all the attached drivers and the sr_remove
> method calls cdrom_unregister which throws away the cdrom device state,
> even though the actual device has active references.

Yes, we reordered some of this in sd. As your comment down below
indicates reordering will reduce the window but not eliminate it.

> 
> Some time later, the device is closed but there's now bogus state
> because the sr_remove method has kfreed the struct scsi_cd which
> contains the struct cdrom_device_info.
> 
> Now, the questions are, whose issue is this and how do we fix it?  I can
> see that a driver needs early notification of unplugs so it can deny all
> access to a gone device.  On the other hand, for a user land open where
> we still have to hold resources in the driver, we'd like the driver to
> have a notify when the device reference count drops to zero so we can
> clean up.
> 
> This problem, by the way, exists in a lesser form for sd: the sd remove
> method will free the device for reattachment even though it might have
> active references.
> 

I have looked at the sd issue off and on due to the previous open race
reported by Alan Stern. While the window can be narrowed inside SCSI you
need help for the calling subsystem to know when it is OK to cleanup and
your routine will not be called anymore. A similar problem also showed
up in the tear down the host directory entry in /proc/scsi but was only
fixed up so far due to its depreciated status.

http://marc.theaimsgroup.com/?t=105545175900001&r=1&w=2

I believe as indicated above that all cross subsystem registrations need
a release / put callback. This would allow the release chain to be
called from block -> ULD -> scsi core -> LLDD. 

Recently I have not been spending the proper time looking at this, but
last look it appeared that we needed to  add a release / put method call
to the gendisk disk_release routine. The release function or object to do
the put on would need to be set prior to the call to add_disk.

-andmike
--
Michael Anderson
andmike@us.ibm.com

