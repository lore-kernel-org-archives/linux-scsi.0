From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Thu, 8 Sep 2005 11:59:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509081148350.4607-100000@iolanthe.rowland.org>
References: <1126123089.4823.48.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45027 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S964869AbVIHP70
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 11:59:26 -0400
In-Reply-To: <1126123089.4823.48.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 7 Sep 2005, James Bottomley wrote:

> I agree (about the deadlocks).  However, as things stand RECOVERY is a
> state in the model and the model can only be in a single state.  If you
> permit the transition, and recovery is going on in parallel with
> removal, they'll race to set the final state (removal wants DEL and the
> eh thread will set it to RUNNING).
> 
> Either we go back to having an in_recovery flag (i.e. lift recovery out
> of the state model) or we make the model more complex to cope with this.
> Since really the only thing we test is in_recovery, we could do a more
> complex model; something like:
> 
> created
>    |
>    v    <--------- 
>  running ---------> recovery
>    |                   |
>    v   <----------     v
>  cancel ----------> recover/cancel
>    |                   |
>    v   ----------->    v
>   del <------------ recover/del
> 
> I also think I'd like not to go from del -> recover/del, but unless del
> actually means that all devices have completed their I/O for deletion
> that can't be avoided.

I don't understand your reasoning.  With your new system, you end up with 
two threads doing this:

	Removal thread			Error handler thread
	-------------------------	---------------------------
					Go from RUNNING to RECOVERY
	Try to go to CANCEL, fail
	Go to CANCEL_RECOVERY
race:	Go to DEL_RECOVERY		Try to go to RUNNING, fail


Whereas the old system has the two threads doing this:

	Removal thread			Error handler thread
	-------------------------	---------------------------
					Go from RUNNING to RECOVERY
	Go to CANCEL
race:	Go to DEL			Try to go to RUNNING, fail


At least, that's how it would work if you allow the RECOVERY -> CANCEL
transition.  Either way you end up in the correct state.  So what's wrong
with the old (current) system?

Alan Stern

