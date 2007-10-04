From: Alan Stern <stern@rowland.harvard.edu>
Subject: SCSI runtime power management
Date: Thu, 4 Oct 2007 11:03:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0710041026040.3990-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54412 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756591AbXJDPDG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Oct 2007 11:03:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

I'm trying to work out a simple framework for SCSI runtime management 
but am handicapped by lack of detailed knowledge of many of the nuances 
in the SCSI stack.  Here's an initial proposal, modelled after the USB 
implementation:

There are three reasons why a SCSI device might be suspended.  They
differ in how I/O requests get treated:

	System suspend: The device is suspended because the system
	as a whole is being suspended.  Incoming requests should be
	deferred until the system and device are resumed.

	Manual suspend: The user has told the kernel (via sysfs) that 
	the device should be suspended and should remain that way, 
	unusable until the user says otherwise.  Incoming requests 
	should fail immediately.

	Autosuspend: The device has been idle for an appropriate time
	and is automatically suspended by the SCSI midlayer.  Incoming
	requests should cause the device to be automatically resumed.

Each of these would fall under the SDEV_BLOCK state in the state model,
distinguished by a couple of bits in the scsi_device structure.  Or 
maybe there should be a separate SDEV_SUSPENDED state?

In general a device would count as "idle" when there are no requests in
flight, although there will be a way for drivers to declare that a
device is busy even when no I/O is going on.  The autosuspend idle-time
limit will be adjustable per-device by means of a sysfs attribute.  

Periodically, say every 10 seconds, a timer or workqueue routine will
walk through all the devices attached to each host, checking to see
which of them can be autosuspended.  Conversely, there will be a
workqueue used for autoresuming; it will be invoked by scsi_prep_fn()
whenever a request arrives for an autosuspended device.

Each host structure will maintain a count of the number of unsuspended
devices on its bus.  (It's not clear whether an offline device should
contribute to the count.)  When that count drops to 0, the midlayer
will call the lower-level driver through a new "autosuspend" method
pointer in the host template, and the LLD can then autosuspend the host
adapter.  When the count rises above 0, the midlayer will call the LLD
through a new "autoresume" method pointer and the LLD can then
autoresume the host adapter.  It might make sense to add an
SHOST_SUSPENDED state, or it might be unnecessary.


I don't know how any of this would interact with the link power 
management work Kristen has been doing.  Perhaps they would cooperate 
nicely.

Does this seem reasonable?  Too naive?  Not workable for some reason?  
Can anyone provide suggestions or helpful criticism?

Thanks,

Alan Stern

P.S.: James, why is it that some requests are allowed to go through
scsi_prep_fn() when the device is in the SDEV_BLOCK state, only to fail 
later in scsi_dispatch_cmd()?

