From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Wed, 07 Sep 2005 14:58:09 -0500
Message-ID: <1126123089.4823.48.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509071413070.4988-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:56207 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750781AbVIGT6N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 15:58:13 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509071413070.4988-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2005-09-07 at 14:27 -0400, Alan Stern wrote:
> > The second (allow RECOVERY->CANCEL) isn't really an answer.  The correct
> > thing, I suppose, is to have scsi_remove_host() wait for the error
> > handler to finish if the state transition cannot be accomodated
> > (otherwise the error handler will try to transition ->RUNNING part way
> > through the removal).
> 
> I'm going to argue strongly about this.  scsi_remove_host should _not_
> wait for error recovery to complete -- to do so will invite deadlocks.  
> (Suppose the error handler is waiting for a bus reset, but the bus reset
> routine requires a semaphore held by the LLD during the call to
> scsi_remove_host?)  Furthermore, error recovery can potentially take quite
> a long time -- much longer than we want to wait during a removal event.  
> Instead, the error handler should not be allowed to make the transition to
> RUNNING once the removal has started.

I agree (about the deadlocks).  However, as things stand RECOVERY is a
state in the model and the model can only be in a single state.  If you
permit the transition, and recovery is going on in parallel with
removal, they'll race to set the final state (removal wants DEL and the
eh thread will set it to RUNNING).

Either we go back to having an in_recovery flag (i.e. lift recovery out
of the state model) or we make the model more complex to cope with this.
Since really the only thing we test is in_recovery, we could do a more
complex model; something like:

created
   |
   v    <--------- 
 running ---------> recovery
   |                   |
   v   <----------     v
 cancel ----------> recover/cancel
   |                   |
   v   ----------->    v
  del <------------ recover/del

I also think I'd like not to go from del -> recover/del, but unless del
actually means that all devices have completed their I/O for deletion
that can't be avoided.


> Changing the API is fine with me, but the existing code is still shaky
> because it calls scsi_alloc_target before checking scsi_host_scan_allowed.  
> Maybe that's not an out-and-out mistake, but better to avoid it.

Actually, alloc_target is properly guarded so it doesn't need the scan
mutex.  It might be nice to update the SDEV_ state model to include a
"scanning" state, that way we could properly guard the sdev_alloc as
well and dump the scan mutex ... that's probably more than a slight
change, though.

> Would you like me to submit an updated patch?

Yes, please.  It's been suggested that we should have a scsi_add_target
that returns zero on success or error on failure (with no ref to the
sdev) and keep the old behaviour of __scsi_add_target().

James


