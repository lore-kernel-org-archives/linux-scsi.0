From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Fri, 9 Sep 2005 11:16:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509091052300.5557-100000@iolanthe.rowland.org>
References: <1126277097.4799.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:17621 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S964911AbVIIPQ4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 11:16:56 -0400
In-Reply-To: <1126277097.4799.12.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 9 Sep 2005, James Bottomley wrote:

> So which way do you want to go?  Either we wait in recovery for the
> error handler to finish and transition the host state to RUNNING or we
> introduce the parallel states for the error handler.

For usb-storage it won't make any difference on the whole, as far as I can
see.  The important thing is that scsi_remove_host needs to synchronize
somehow with the error handler.  Waiting for the host state to go back to
RUNNING would be valid.  Introducing the parallel states would mean 
waiting for the host to go from CANCEL_RECOVERY to CANCEL, right?

Either way should work.  Would there be more of a difference for drivers
that allow non-forced removal?  And without the parallel states, would you
worry about the possibility of starving scsi_remove_host (every time it
tries to go from RUNNING to CANCEL, the error handler gets there first and
changes the state to RECOVERY)?

In the absence of other considerations, my vote goes for adding the least 
amount of additional code.

Alan Stern


