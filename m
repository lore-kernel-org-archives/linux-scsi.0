From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [linux-usb-devel] USB Storage oops in 2.5.69-bk8
Date: Sat, 17 May 2003 11:38:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030517113848.A26713@beaverton.ibm.com>
References: <20030516222900.GA3236@beaverton.ibm.com> <Pine.LNX.4.44L0.0305171108050.26146-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:14555 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261754AbTEQSaV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 14:30:21 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0305171108050.26146-100000@netrider.rowland.org>; from stern@rowland.harvard.edu on Sat, May 17, 2003 at 11:29:30AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Florin Iucha <florin@iucha.net>, David Brownell <david-b@pacbell.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

On Sat, May 17, 2003 at 11:29:30AM -0400, Alan Stern wrote:
> On Fri, 16 May 2003, Mike Anderson wrote:

> What happens is that the device crashes because of the 3-byte 
> MODE-SENSE(6) request.  The scsi error handler tries various levels of 
> fault recovery, all the way up to a bus reset.  Usb-storage implements the 
> bus reset as a USB port reset, which requires usbcore to re-enumerate 
> the device.  The line
> 
>    drivers/usb/core/message.c: usb_control/bulk_msg: timeout
> 
> refers to a failure during the re-enumeration.  Apparently even the port
> reset was not enough to revive the device.  I don't know the reason for
> the line
> 
>    Error handler scsi_eh_1 waking up

The above is the first thing output when the eh wakes up, so the
re-enumeration could not have started yet (at least it could not have been
initiated via scsi eh calling the bus reset or other abort/reset related
functions), and the USB timeout message could not be part of the scsi eh,
though we did not see the scsi_times_out log message (since it's wrapped
in SCSI_LOG_TIMEOUT, not SCSI_LOG_ERROR_RECOVERY).

Turning on timeout (or even all) logging might give a bit more data:

	echo "scsi log timeout 4" > /proc/scsi/scsi

Or (warning - logs the logging messages if logging to a scsi disk):

	echo "scsi log all" > /proc/scsi/scsi

-- Patrick Mansfield
