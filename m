From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Windows and non-lockable devices (fwd)
Date: Wed, 23 Jun 2004 12:14:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040623191400.GC1387@us.ibm.com>
References: <Pine.LNX.4.44L0.0406221643180.5898-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:23459 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266608AbUFWTOO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 15:14:14 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0406221643180.5898-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> The Panasonic DMC-LC40 USB camera causes difficulties, because whenever it
> receives an ALLOW MEDIUM REMOVAL command the next few TEST UNIT READY
> commands encounter "Medium not present" failures.  So after sd.c initially
> probes the device and reads the partition sector, when the user tries to
> open the device for mounting sd_spinup_disk() returns an error because it 
> believes that the medium has been removed.
> 
> A similar problem exists with the iRiver MP3 USB player.  In this case the 
> medium is not removable but the device sets RMB anyway.  And then it 
> obligingly crashes when it receives PREVENT-ALLOW MEDIUM REMOVAL.
> 
> We've discussed a few possible workarounds:
> 
> 	The usb-storage driver could turn off the RMB flag in the INQUIRY 
> 	data.  But that's more invasive than we like, and anyway the
> 	camera's medium really _is_ removable.

I would agree that this does not sound like the best idea.

> 
> 	usb-storage could set sdev->lockable to 0.  That's easy to do and
> 	solves the problem; the question then becomes: For which devices
> 	should we do this?  One answer is to have a blacklist of non-
> 	lockable devices.  Another answer is always to do it for devices
> 	that aren't CDs, maybe with a whitelist for the relatively small
> 	number of known good USB disk devices that can lock their medium.

Since SCSI already has the device list it would seem like we would
possibly add a new flag like was done for mode sense. As this is not a
transport issue I would assume we would not want to add flags in
usb/storage, but handle it in the mid-layer as a SCSI protocol
non-compliance.

James does this sound ok to you?

> > Maybe some sort of compromise is in order.  If sd_spinup_disk() would
> > try issuing both TEST UNIT READY and READ CAPACITY commands, that might
> > be sufficient.

This sounds like we would try to the dial in the timing of sd's commands
sequences to cover one devices internal timing issues and hope it solves
the problem. This sounds like a fragile solution and it would not solve
the issue for the "iRiver" unless I read the error case wrong.

-andmike
--
Michael Anderson
andmike@us.ibm.com

