From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Windows and non-lockable devices (fwd)
Date: Tue, 22 Jun 2004 17:05:14 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406221643180.5898-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:16132 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S266027AbUFVVFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 17:05:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Mike Anderson <andmike@us.ibm.com>
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

James and Mike:

At Matt Dharm's request I'm adding you into this thread.  Maybe you can 
help solve our problem.  Here's the quick overview:

The Panasonic DMC-LC40 USB camera causes difficulties, because whenever it
receives an ALLOW MEDIUM REMOVAL command the next few TEST UNIT READY
commands encounter "Medium not present" failures.  So after sd.c initially
probes the device and reads the partition sector, when the user tries to
open the device for mounting sd_spinup_disk() returns an error because it 
believes that the medium has been removed.

A similar problem exists with the iRiver MP3 USB player.  In this case the 
medium is not removable but the device sets RMB anyway.  And then it 
obligingly crashes when it receives PREVENT-ALLOW MEDIUM REMOVAL.

We've discussed a few possible workarounds:

	The usb-storage driver could turn off the RMB flag in the INQUIRY 
	data.  But that's more invasive than we like, and anyway the
	camera's medium really _is_ removable.

	usb-storage could set sdev->lockable to 0.  That's easy to do and
	solves the problem; the question then becomes: For which devices
	should we do this?  One answer is to have a blacklist of non-
	lockable devices.  Another answer is always to do it for devices
	that aren't CDs, maybe with a whitelist for the relatively small
	number of known good USB disk devices that can lock their medium.

Out of curiosity I asked Matthew Wheeler (who has a DMC digital camera) to 
capture a USB trace showing how Windows 2000 deals with the problem.  The 
summary of the result is below.

What do you advise?

Alan Stern


---------- Forwarded message ----------

On Tue, Jun 22, 2004 at 03:25:09PM -0400, Alan Stern wrote:
> 
> Okay, this log has lots of good information.  It's mixed in with tons of 
> sickening information, though... the Windows implementation of the 
> SCSI-over-USB protocols is not pretty.  So for the sake of readers with 
> weak stomachs I won't give a detailed listing of all the commands and 
> responses.
> 
> The log does show the write starting, and about 15 seconds later the 
> filesystem buffers are flushed and then there's an ALLOW MEDIUM REMOVAL.  
> When the next write begins, the first command is TEST UNIT READY which 
> does indeed encounter a "Medium not present" failure.
> 
> As near as I can tell, Windows then revalidates the disk.  It does a bunch 
> of READ CAPACITY, TEST UNIT READY, MODE SENSE, and READ(10) commands (for 
> things like the partition sector, the boot sector, the FAT, and the root 
> directory).  By the time that's all finished up whatever error condition 
> existed inside the camera has been cleared, so the write can proceed 
> normally.
> 
> The question is, how should we use this information?  Adopting a similar 
> approach would mean making some non-trivial changes to sd.c, and I'm not 
> sure that it's such a good approach to take in the first place.

I'm not sure where else you would put the fix.....

> Maybe some sort of compromise is in order.  If sd_spinup_disk() would
> try issuing both TEST UNIT READY and READ CAPACITY commands, that might
> be sufficient.

That might work.  We definatly want to bring someone from the SCSI side of
the equasion into this discussion.  Perhaps James Bottomley or Mike
Anderson?

Matt


