From: Alan Stern <stern@rowland.harvard.edu>
Subject: Requested changes for the SCSI error handler
Date: Tue, 1 Jun 2004 14:50:41 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406011439260.693-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [192.131.102.52] ([192.131.102.52]:5380 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264960AbUFASvI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2004 14:51:08 -0400
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Here are two things I'd like to see changed in the error handler, if 
possible.

	The recovery xxx_RESET_SETTLE_TIME delays in scsi_sleep() can not 
	be interrupted, even if the state changes to SDEV_CANCEL or 
	SHOST_CANCEL.  It would be nice if the delay could be cut short
	so that scsi_remove_host() doesn't have to wait.  Lengthy pauses
	during disconnect processing are bad for the USB hub driver.

	In scsi_eh_ready_devs(), it would be good if some of the resets
	could be skipped sometimes.  For example, if the low-level
	driver has just done its own bus-device reset (and called
	scsi_report_device_reset) then there's no point in doing 
	scsi_eh_bus_device_reset().  The same is true for bus resets.
	It just adds additional timeout delays to an already-lengthy
	recovery process.

Do these things seem feasible?

Alan Stern

