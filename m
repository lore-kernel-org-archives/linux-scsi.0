From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Race in removal of host class device attribute file
Date: Fri, 17 Oct 2003 08:18:52 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310170807130.15852-100000@netrider.rowland.org>
References: <20031016224740.GE903@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:60166 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S263420AbTJQMSw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2003 08:18:52 -0400
In-Reply-To: <20031016224740.GE903@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 16 Oct 2003, Mike Anderson wrote:

> Alan Stern [stern@rowland.harvard.edu] wrote:
> > I've created a class device attribute file for the hosts supported by the
> > usb-storage driver, using the shost_attrs member of the host template.  
> > It seems to contain an intractable race condition when unregistering the
> > host.  There's no way for the driver to know when the scsi host's class
> > device is released, so there's no way to know when it's safe to deallocate
> > the host's driver-specific data structure.  Waiting until
> > scsi_remove_host() returns isn't good enough, because a user process might
> > keep the attribute file open and thus prevent release of the class device
> > indefinitely.
> > 
> > What's the right way to solve this problem?  It seems to me that it must 
> > involve creating a kobject in the driver-specific host data structure, on 
> > which the class device's release() routine could do a kobject_put().  That 
> > way the driver would be able to tell when it should free the data 
> > structure.  But code to handle this would have to be added to the scsi 
> > core.
> > 
> > Alan Stern
> > 
> 
> The free of this data has to happen on some release function. How are
> you allocating the data / class_device_attribute structure? If the
> allocation came from the scsi_host_alloc extra bytes the data will not
> be free'd until scsi_host_dev_release().

The data structure is allocated at the time the USB connection is 
established, and it must be done _before_ registering the scsi host.  
Likewise, it is freed when the USB cable is unplugged, _after_ removing 
the scsi host.  Hence it cannot be stored in the extra bytes.

However, I figured out an answer.  This is the sort of problem faced by
practically all drivers that use the sysfs filesystem: opening an
attribute file races with disconnecting the device.  The solution is to
have a driver-wide semaphore that protects the hostdata[] bytes in the
host structure.  The attribute file's read routine must hold the semaphore
while accessing the driver-specific host data structure.  The driver must
hold the semaphore when it erases the pointer to the data structure (which
is stored in the hostdata[] area) at the time a disconnect occurs.

That way, when a user process attempts to read the attribute file after
the data structure has been freed, it's guaranteed that the pointer to the
data structure will be NULL.  The attribute read routine can then avoid
trying to access deallocated memory.  Without that semaphore, it would be
possible for the driver to free the data structure _while_ the read
routine was using it.

Alan Stern

