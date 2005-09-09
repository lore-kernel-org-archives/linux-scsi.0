From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Fri, 09 Sep 2005 10:37:28 -0500
Message-ID: <1126280249.4799.21.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509091052300.5557-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:15784 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964960AbVIIPhb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 11:37:31 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509091052300.5557-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2005-09-09 at 11:16 -0400, Alan Stern wrote:
> > So which way do you want to go?  Either we wait in recovery for the
> > error handler to finish and transition the host state to RUNNING or we
> > introduce the parallel states for the error handler.
> 
> For usb-storage it won't make any difference on the whole, as far as I can
> see.  The important thing is that scsi_remove_host needs to synchronize
> somehow with the error handler.  Waiting for the host state to go back to
> RUNNING would be valid.  Introducing the parallel states would mean 
> waiting for the host to go from CANCEL_RECOVERY to CANCEL, right?

Actually, no, there would be no waiting.  Once the host gets to DEL or
CANCEL_DEL, then all the devices should be in DEL and the mid-layer will
begin rejecting any commands the error handler makes.  So it can
continue until it's exhausted.  It keeps a reference to the devices it
needs to operate, so they'll be finally freed when it stops.

Since the eh has references, module removal would have to wait until it
had finished, but everything else can proceed without it.

> Either way should work.  Would there be more of a difference for drivers
> that allow non-forced removal?  And without the parallel states, would you
> worry about the possibility of starving scsi_remove_host (every time it
> tries to go from RUNNING to CANCEL, the error handler gets there first and
> changes the state to RECOVERY)?

Not really.  Starting the eh is quite a long and involved process, so
the chances of it restarting before scsi_remove_host gets scheduled is
small (not impossible, but small).

> In the absence of other considerations, my vote goes for adding the least 
> amount of additional code.

Actually, they're both about the same amount of code.

James


