From: Alan Stern <stern@rowland.harvard.edu>
Subject: Proposal for fixing READ_CAPACITY
Date: Thu, 26 Aug 2004 13:20:27 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0408261304300.1089-100000@ida.rowland.org>
References: <1093536566.2326.61.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:35332 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S269262AbUHZRVI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 13:21:08 -0400
In-Reply-To: <1093536566.2326.61.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

A number of USB mass storage devices return the wrong value for READ 
CAPACITY -- that is, they report the total number of blocks rather than 
the highest available block number.  As a result the kernel thinks they 
have one more block than they really do.

This didn't cause too much trouble under 2.4, but now distributions are
shipping kernels with support for partitioning schemes or filesystem
layouts that store important information in the last block.  Obviously
this is a recipe for trouble.

For some time there has been a routine in the usb-storage driver to reduce 
by one the value returned by READ CAPACITY (if the device has a
corresponding blacklist flag set).  That's not a good place for a couple 
of reasons:

	Doing it in the low-level driver prevents any program from
	seeing what the device actually does report.

	It's not a transport issue in the first place, so it shouldn't
	be handled by the transport driver.

On the whole, it would be much better (and simpler!) to correct these
mistakes in sd.c's sd_read_capacity() routine.  (I haven't encountered any 
CD-type devices that make this mistake.)  One obvious approach is to
use another SCSI blacklist flag for devices needing this fixup.  A
trickier but possibly better approach is to automatically try reading the
last block when the device is probed, and reduce the capacity by 1 if the 
read fails.

The advantage is that nobody has to maintain any blacklist entries.  The 
disadvantage is that this involves deliberately asking the device to do 
something which may cause a nasty error.  Some USB devices go into a very 
confused state when asked to read past the end of the medium.  A bus reset 
might set them straight again -- or it might not; I haven't ever tried it.

Anyway, what's your reaction to all this?  Should the workaround be moved 
from usb-storage to sd?  If yes, which approach should be used?

Alan Stern

