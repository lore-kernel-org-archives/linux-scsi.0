From: Steven Dake <sdake@mvista.com>
Subject: Re: bug 2400
Date: Thu, 01 Apr 2004 17:29:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080865751.9534.121.camel@persist.az.mvista.com>
References: <20040401131502.41136788.akpm@osdl.org>
	 <1080862354.2118.78.camel@mulgrave>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rav-az.mvista.com ([65.200.49.157]:58406 "EHLO
	zipcode.az.mvista.com") by vger.kernel.org with ESMTP
	id S263090AbUDBA3V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 19:29:21 -0500
In-Reply-To: <1080862354.2118.78.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-04-01 at 16:32, James Bottomley wrote:
> On Thu, 2004-04-01 at 16:15, Andrew Morton wrote:
> > Apparently there is some controversy over whether this:
> > http://bugme.osdl.org/show_bug.cgi?id=2400 is a usb-storage problem or a
> > SCSI problem.
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

One option to fix all this is to add a mechanism to blow away active
references to any block devices.  These references can be files,
filesystems, raid devices, lvm devices, etc.  This way, the remove can
be called because no active references are left.  The user gets a slew
of errors in the user application that has the open file on the
filesystem or block device, but atleast these can be managed (vs an
oopsed kernel).

Of course, adding forced unmount (required to blow away the references)
may not be desireable for 2.6 since it is invasive..  Perhaps something
to be considered for 2.7?

Thanks
-steve

> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

