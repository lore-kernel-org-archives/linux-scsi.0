From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Requested changes for the SCSI error handler
Date: 01 Jun 2004 14:58:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086119915.1795.73.camel@mulgrave>
References: <Pine.LNX.4.44L0.0406011439260.693-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:46765 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265187AbUFAT7t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2004 15:59:49 -0400
In-Reply-To: <Pine.LNX.4.44L0.0406011439260.693-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2004-06-01 at 13:50, Alan Stern wrote:
> Here are two things I'd like to see changed in the error handler, if 
> possible.
> 
> 	The recovery xxx_RESET_SETTLE_TIME delays in scsi_sleep() can not 
> 	be interrupted, even if the state changes to SDEV_CANCEL or 
> 	SHOST_CANCEL.  It would be nice if the delay could be cut short
> 	so that scsi_remove_host() doesn't have to wait.  Lengthy pauses
> 	during disconnect processing are bad for the USB hub driver.

Really, no.  The settle time is not transport independent, so it would
be very difficult to implement stomething like this in the mid-layer.

What about simply doing the settle in the eh_.. routines (you block the
host, schedule_timeout() for your settle time then unblock the host and
return to the eh thread)?

> 	In scsi_eh_ready_devs(), it would be good if some of the resets
> 	could be skipped sometimes.  For example, if the low-level
> 	driver has just done its own bus-device reset (and called
> 	scsi_report_device_reset) then there's no point in doing 
> 	scsi_eh_bus_device_reset().  The same is true for bus resets.
> 	It just adds additional timeout delays to an already-lengthy
> 	recovery process.

Well, tidying up the reports could be done.  Really we should treat them
as error conditions: mark all the in-progress commands for the devices
and probe with a TUR before resuming.

James


