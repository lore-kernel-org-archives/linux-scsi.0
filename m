From: Alan Stern <stern@rowland.harvard.edu>
Subject: SCSI, usb-storage, and autosuspend
Date: Mon, 12 Feb 2007 16:02:11 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0702121548040.4416-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51108 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965403AbXBLVCO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2007 16:02:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>
Cc: Oliver Neukum <oneukum@suse.de>

There has been a recent proposal to add autosuspend support to the
usb-storage driver.  (I.e., after a certain user-definable period of
inactivity, usb-storage would automatically suspend the USB link to the
device.  Receipt of a request from the SCSI core would cause an
automatic resume.)

This has been discussed on linux-scsi in the past, and reactions were
mixed.  We are now at the point where the infrastructure is in place to
actually implement the proposal.  The question is, should we?

For many USB mass-storage devices, the overhead of suspend and resume is 
pretty small, just the time required to carry out the operations (a few 
tens of milliseconds for resume, less than 10 ms for suspend).  On the 
other hand, a SCSI device might interpret a USB suspend as a signal to 
start its own power-saving measures.  It might even cause a drive to spin 
down, although I don't think the common USB-IDE bridges work that way.

It can be argued that autosuspend requests should originate at lower
points in the device tree and bubble up to the parent.  With a disk-type
device, for instance, we might want to have sd decide when it's okay to
suspend.  It would inform the SCSI core, which would then decide when the
entire SCSI bus can be suspended.  The core would then inform the host
adapter driver (usb-storage in this case), which would suspend the
transport.

Has there been any discussion about doing things this way?  Does anybody 
think that usb-storage should _not_ do autosuspend on its own initiative?

Alan Stern

