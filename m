From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Fri, 09 Sep 2005 09:44:57 -0500
Message-ID: <1126277097.4799.12.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509091000480.4945-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:50343 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751396AbVIIOpA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 10:45:00 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509091000480.4945-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2005-09-09 at 10:16 -0400, Alan Stern wrote:
> I see.  You must be making an unstated assumption, something along the
> lines of "If the error handler is running then the host is in a *RECOVERY
> state."  Given that, there definitely is a need for a separate 
> CANCEL_RECOVERY and DEL_RECOVERY.

Sorry, yes ... it wasn't stated because I thought it was apparent in the
diagram.

> Hmmm, well looking through the patch you posted yesterday, there are a few 
> problems.  If the ->CANCEL transition fails, scsi_remove_host then tries 
> ->CANCEL_RECOVERY.  But the failed transition still writes a error message 
> to the log, even though it's not really an error.

Well ... the log is just that, a log.  It's not active unless someone
asks to see it and all its entries don't necessarily represent errors.
However, we can probably tone down the logging to KERN_NOTICE.

> Also, you've got a race between scsi_remove_host doing ->CANCEL_RECOVERY
> and the error handler doing ->RUNNING.  If both happen at the same time,
> you can end up in the wrong state.  To make this work, the state
> transitions should only be made under protection of the host's spinlock.  
> And to avoid the error messages, the choice of next state should be made 
> depending on the current state (like, if the current state is RECOVERY 
> then go to CANCEL_RECOVERY, otherwise go to CANCEL).

Yes ... we definitely use the lock for device transitions.  Since all of
this is done with user context, a semaphore would be the most
appropriate, but since we already have a host lock, it's probably better
to use it.

So which way do you want to go?  Either we wait in recovery for the
error handler to finish and transition the host state to RUNNING or we
introduce the parallel states for the error handler.

James


