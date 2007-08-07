From: Alan Stern <stern@rowland.harvard.edu>
Subject: BUG in SCSI async scanning
Date: Tue, 7 Aug 2007 12:54:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0708071242140.2834-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54654 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752160AbXHGQyH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 12:54:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Can somebody explain the reason for calling a separate 
scsi_sysfs_add_devices() routine in the async scanning code instead of 
just calling scsi_sysfs_add_sdev() normally from within scsi_add_lun()?

This peculiar delayed approach has introduced a bug.  It evades the
protection provided by shost->scan_mutex and as a result, if a host is
hot-unplugged in the middle of an async scan, the SCSI core will
attempt to unregister the host's devices before they have been
registered!  Obviously this is not good.

There are at least two reports filed in the kernel.org bugilla showing 
this bug: #8840 and #8846.

Alan Stern

