From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi_forget_host() and scsi_remove_device()
Date: Sun, 6 Jul 2003 17:11:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030706171129.B5690@infradead.org>
References: <20030627110259.A3751@infradead.org> <Pine.LNX.4.44L0.0307031650370.779-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:30468 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266688AbTGFP47 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Jul 2003 11:56:59 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0307031650370.779-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Thu, Jul 03, 2003 at 05:02:22PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Jul 03, 2003 at 05:02:22PM -0400, Alan Stern wrote:
> There's a real problem about the way scsi_forget_host() calls
> scsi_remove_device() for each device on the host's bus.  The problem is
> that scsi_remove_device() unregisters the device in sysfs, which unbinds
> the device's driver.  This happens immediately, without waiting for the
> reference count to be 0.  So if the device is open (mounted, for example)  
> when the host is unplugged, the filesystem will have a dangling reference
> to the unbound driver.  Of course this will most likely cause a segfault
> when the user attempts to unmount the device.

There's two issues in this area:

b) after scsi_remove_device the upper driver still holds a reference
   to the struct scsi_device but not the host, so references to
   sdev->host barf up.  This needs fixing by holding a reference
a)  struct device/scsi_device misses a proper state bits that sais
   "I'm gone now".  Mike is implementing this for scsi now but this
   really needs to be handled at the driver model level as other subsystems
   have the same problems.

I'm waiting for Mike to post his patches and will attack a) after that.
In fact it's quite easy and I could just do it now :)

