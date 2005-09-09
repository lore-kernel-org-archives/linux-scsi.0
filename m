From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Fri, 9 Sep 2005 10:16:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509091000480.4945-100000@iolanthe.rowland.org>
References: <1126210542.4845.66.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:13281 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S964902AbVIIOQl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 10:16:41 -0400
In-Reply-To: <1126210542.4845.66.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 8 Sep 2005, James Bottomley wrote:

> Yes, a state machine like I've shown can only be in one state at any
> given time.  The problem is what happens if the error handler is running
> when you try to remove the device.  We can reach in and try to stop it,
> but under a state model we'd have to wait until the error handler put
> the device back to running unless we allow a set of state transitions
> that the error handler can go through in parallel with the removal
> (which is the model I've shown above).
> 
> The idea of allowing the error handler to start up in cancel is that not
> every device removal is a forced removal, so you want to permit the
> shutdown commands (like sync cache) and consequent error handling on
> those commands.

I see.  You must be making an unstated assumption, something along the
lines of "If the error handler is running then the host is in a *RECOVERY
state."  Given that, there definitely is a need for a separate 
CANCEL_RECOVERY and DEL_RECOVERY.

> > As for 2), what do you mean?  In 2.6.13, scsi_device_set_state does not 
> > change the state if the transition is illegal.
> 
> Yes, but we never act on the return value.  if the state is illegal, we
> shouldn't be taking actions believing we're in that state, so we should
> always be checking the returns.

Hmmm, well looking through the patch you posted yesterday, there are a few 
problems.  If the ->CANCEL transition fails, scsi_remove_host then tries 
->CANCEL_RECOVERY.  But the failed transition still writes a error message 
to the log, even though it's not really an error.

Also, you've got a race between scsi_remove_host doing ->CANCEL_RECOVERY
and the error handler doing ->RUNNING.  If both happen at the same time,
you can end up in the wrong state.  To make this work, the state
transitions should only be made under protection of the host's spinlock.  
And to avoid the error messages, the choice of next state should be made 
depending on the current state (like, if the current state is RECOVERY 
then go to CANCEL_RECOVERY, otherwise go to CANCEL).

Alan Stern

