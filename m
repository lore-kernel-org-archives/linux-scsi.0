From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: scsi_forget_host() and scsi_remove_device()
Date: Thu, 3 Jul 2003 15:19:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030703221940.GA5983@beaverton.ibm.com>
References: <20030627110259.A3751@infradead.org> <Pine.LNX.4.44L0.0307031650370.779-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:26258 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S265439AbTGCWDO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2003 18:03:14 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0307031650370.779-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> There's a real problem about the way scsi_forget_host() calls
> scsi_remove_device() for each device on the host's bus.  The problem is
> that scsi_remove_device() unregisters the device in sysfs, which unbinds
> the device's driver.  This happens immediately, without waiting for the
> reference count to be 0.  So if the device is open (mounted, for example)  
> when the host is unplugged, the filesystem will have a dangling reference
> to the unbound driver.  Of course this will most likely cause a segfault
> when the user attempts to unmount the device.
> 
> I don't know what the right way is to attack this problem, or what you're
> planning to do about it.  One approach would be somehow to prevent any new
> references to the device from being created while waiting for all the
> existing references to go away.  But that doesn't seem feasible.
> 
> How are you going to address this problem?
> 
> Alan Stern
> 

Yes, this is an issue. I became more of issue one we started using the
LDM driver probe / remove functions.

I am still cleaning up a patch set for hosts and devices so it is not
quite ready for review yet (I got pulled off on to some other issues for
a few days).

For scsi devices here is a quick snap shot of what I trying to test.
	scsi_device_register:
		calls device_initialize on sdev_driverfs_dev
		calls class_device_initialize on sdev_classdev
		calls device_add on sdev_driverfs_dev
		calls class_device_add on sdev_classdev
		calls get_device on sdev_driverfs_dev

	scsi_device_unregister:
		sets a state the scsi_device indicating "delete"
		calls class_device_unregister on sdev_classdev

	scsi_device_cls_release:
		calls put_device on sdev_driverfs_dev

	scsi_device_dev_release:
		calls device_del sdev_driverfs_dev (I have a hack in here to ensure
		device_add was previously called).	
		calls scsi_free_sdev

	scsi_device_get:
		if device state says get ok
			calls get_device on sdev_driverfs_dev
	(I still have access_count on try_module_get in the function).

	scsi_device_put:
		calls put_device on sdev_driverfs_dev
	(I still have access_count on try_module_put in the function).

The gets are only stopped for callers of scsi_device_get. If a
get_device is called from outside the subsystem I cannot stop this
though it would not cause bad things to happen just a longer time to
cleanup. A core flag would most likely be needed to stop this from
happening.

-andmike
--
Michael Anderson
andmike@us.ibm.com

