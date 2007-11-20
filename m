From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SCSI dynamic power management
Date: Tue, 20 Nov 2007 09:38:09 -0500
Message-ID: <4742F151.9020602@torque.net>
References: <Pine.LNX.4.44L0.0711191028400.4806-100000@iolanthe.rowland.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39354 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbXKTOiw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Nov 2007 09:38:52 -0500
In-Reply-To: <Pine.LNX.4.44L0.0711191028400.4806-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> Oliver (or anybody else):
> 
> Adding dynamic (AKA runtime) power management to the SCSI core is
> looking a little difficult.  (Actually, since as far as I know the SCSI
> specification takes no heed of power management, perhaps this should be
> called "idle-device management".)
> 
> Imagine a SCSI disk has been idle long enough that we want to spin it
> down.  When I/O requests do start to arrive later on, we want to delay
> them in the request queue until the disk has a chance to spin back up.  
> Or even to fail them, if the user has done a "manual" suspend.
> 
> These are conflicting requirements.  How can we send the START-STOP 
> UNIT commands to spin the disk up/down through the request queue while 
> delaying or failing all others?  What happens if one of the 
> START-STOP UNIT commands encounters a problem and the error handler 
> needs to send some commands of its own?
> 
> Any suggestions or ideas are welcome.

There should have always been at least two types of "block":
   a) block media access commands
   b) block all commands because the transport has told us
      (or we know that we are about to remove some component)
      that commands cannot be delivered to the device (logical
      unit)

For case a) all SCSI commands apart from those that explicitly
access the media (e.g. READ, WRITE, VERIFY) should be sent to
the device. Some commands, such as MODE SENSE, may fail since
they might depend on data held on the media. Such failures
will be fast with appropriate sense_key/asc/ascq codes returned.


IMO if a transport tells us that a SCSI device (i.e. target
device and/or logical unit) is accessible and the SCSI subsystem
stops us sending an INQUIRY to that device then the SCSI
subsystem is broken.

Doug Gilbert

