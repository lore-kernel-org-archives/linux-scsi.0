From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Fri, 28 Mar 2014 15:29:54 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1403281438250.862-100000@iolanthe.rowland.org>
References: <1396028874.15365.30.camel@dabdike>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42511 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751902AbaC1T34 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Mar 2014 15:29:56 -0400
In-Reply-To: <1396028874.15365.30.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Fri, 28 Mar 2014, James Bottomley wrote:

> This is a set of three patches we agreed to a while ago to eliminate a
> USB deadlock.  I did rewrite the first patch, if it could be reviewed
> and tested.

I tested all three patches under the same conditions as before, and 
they all worked correctly.

In the revised patch 1, the meaning of SCSI_EH_ABORT_SCHEDULED isn't
entirely clear.  This boils down to two questions, which I don't 
know the answers to:

	What should happen in scmd_eh_abort_handler() if
	scsi_host_eh_past_deadline() returns true and thereby
	prevents scsi_try_to_abort_cmd() from being called?
	The flag wouldn't get cleared then.

	What should happen if some other pathway manages to call
	scsi_try_to_abort_cmd() while scmd->abort_work is still
	sitting on the work queue?  The command would be aborted
	and the flag would be cleared, but the queued work would
	remain.  Can this ever happen?

Maybe scmd_eh_abort_handler() should check the flag before doing
anything.  Is there any sort of sychronization to prevent the same
incarnation of a command from being aborted twice (or by two different
threads at the same time)?  If there is, it isn't obvious.

(Also, what's going on at the start of scsi_abort_command()?  Contrary
to what one might expect, the first part of the function _cancels_ a
scheduled abort.  And it does so without clearing the
SCSI_EH_ABORT_SCHEDULED flag.)

Maybe in all these scenarios, the command is doomed to fail anyway so 
these questions don't make any real difference.  I don't know...

Alan Stern

