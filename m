From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 0/3] Implement runtime power management for SCSI
Date: Wed, 16 Jun 2010 14:51:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006161146150.1587-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60319 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752409Ab0FPSvB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 14:51:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

The following series of three patches implements a runtime power
management interface for the SCSI subsystem.  This initial
implementation is very crude; only devices driven by sd are affected,
and then only when their device files aren't open.  There is no
connection with SCSI transport classes, although such connections could
easily be added at well-defined points in the new code.

Patch 1/3 prepares the way by converting the old-style PM callbacks 
used by the SCSI midlayer over to the new dev_pm_ops framework.  The 
callback pointers and routines are rearranged, but they continue to 
function as before.

Patch 2/3 provides the midlayer mechanism for runtime PM.  The existing 
driver callbacks are used for runtime suspend and resume, and there are 
provisions for making sure that devices are not suspended at important 
times (during probe, remove, or while the error handler is running).  
However this patch doesn't change the high-level drivers, which means 
nothing will use the new runtime PM machinery.

Patch 3/3 adds support for runtime PM to sd.

There is a fourth patch to follow, adding runtime PM support to 
usb-storage.  Because it affects a different subsystem, I will delay 
submitting it until this earlier material has been approved.

Alan Stern

