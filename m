From: Alan Stern <stern@rowland.harvard.edu>
Subject: scsi_wait_scan and scsi_complete_async_scans
Date: Thu, 16 Feb 2012 09:29:16 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202160916160.1268-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43234 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751377Ab2BPO3S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2012 09:29:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James or anyone else:

The purpose of the scsi_wait_scan module is to provide a method for
initramfs images to wait until all the SCSI drives available at boot-up
have been discovered and probed, so that the drive containing the root
filesystem will be available when the time comes to mount it.

Now, in include/scsi/scsi_scan.h, the declaration of 
scsi_complete_async_scans() depends on CONFIG_SCSI.  If the SCSI core 
is built as a module, scsi_complete_async_scans() is defined as an 
empty inline routine.

This doesn't seem to make any sense.  The drive containing the root 
filesystem needs to be available for mounting regardless of whether 
scsi_mod is built into the kernel or is loaded as a module within an 
initramfs image.

In short, is there any reason not to remove the "#ifdef CONFIG_SCSI"  
from include/scsi/scsi_scan.h?

My reason for asking is because I need to fix a bug in scsi_pm.c, and 
the fix involves calling scsi_complete_async_scans().  This has to 
happen even when CONFIG_SCSI isn't defined, so I'd like to change the 
header file.  If necessary, I can put the call in scsi_wait_scan.c 
inside a "#ifdef CONFIG_SCSI" block.

Alan Stern

