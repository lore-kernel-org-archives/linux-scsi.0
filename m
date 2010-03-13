From: Alan Stern <stern@rowland.harvard.edu>
Subject: Runtime power management for SCSI
Date: Sat, 13 Mar 2010 16:21:55 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1003131550001.19476-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:49606 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935788Ab0CMVV4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Mar 2010 16:21:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

I have been working to add runtime power management to the SCSI core,
using the new runtime framework in the PM core.  In its current form
the implementation is very conservative: Only devices bound to sd are
affected, and they get runtime-suspended only when the device file is
closed (hence not mounted or being used as swap), the corresponding sg
device file is also closed, and there are no dirty buffers outstanding.

(This may not seem very helpful in general, but it will suffice to
handle some very common cases such as USB card readers with no card
inserted.  According to Greg KH, users have been clamoring about the
need for just a thing.)

I use the existing sd_suspend() routine, which doesn't do a whole lot:  
just a SYNCHRONIZE CACHE followed by a STOP UNIT (if the
manage_start_stop flag is set).  The new code does nothing at all when
suspending or resuming targets and hosts, although there are places to
insert the necessary hooks.  However the information is propagated up
the device tree, so if the host's lower-level driver implements runtime
PM as well, it can power-manage the host adapter hardware at the
appropriate times.

First question: Is this a reasonable approach for an initial 
implementation, and are there any immediately-evident problems?

Currently the new code treats each LUN independently; that is, each LUN
will be spun up or down when its own device file is opened or closed,
regardless of what other LUNs on the same target are doing.

Second question: Is this the best way to handle it, or should all the 
LUNs on a target be power-managed together at the same time?

I have noticed that in normal use for drives with removable media (and
during initial detection for all drives) the disk device files tend
quite often to be closed and then almost immediately re-opened --
probably by programs in hal or device-kit.  To avoid unnecessary PM
activity, I put in a 100-ms delay between the file close and the
subsequent suspend.  This was an arbitrary choice, good enough for
testing the new code but maybe not right for general use.

Third question: Should that 10-ms value be changed or made adjustable 
somehow (and if so, then how)?

More testing is needed before the patch will be ready for public 
review.  For now, if anyone has comments I'd be glad to hear them.

Alan Stern

