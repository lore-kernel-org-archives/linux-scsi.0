From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Thu, 8 Sep 2005 14:58:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509081441190.5768-100000@iolanthe.rowland.org>
References: <1126196125.4845.40.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47758 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S964933AbVIHS67
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 14:58:59 -0400
In-Reply-To: <1126196125.4845.40.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 8 Sep 2005, James Bottomley wrote:

> Actually, no, that's why we have the parallel EH states ... let me put
> in the events that trigger state transitions so you can see what
> happens:
> 
> 
>         EH thread finishes
> 	<---------------
> 
>         EH thread begins
>         ---------------->
> 
> 
>          <--------- 
>   running ---------> recovery
>     |                   |
>     |                   | scsi_remove_host() called
>     v   <----------     v
>   cancel ----------> recover/cancel
>     |                   |
>     |                   | scsi_remove_host finishes visibility removal
>     v                   v
>    del <------------ recover/del
> 
> So the EH is allowed to activate in either running or cancel states, but
> goes through its own state transition eventually coming back to del when
> it finishes.  Once the EH gets into recover/cancel it can never
> transition back to running.

Why allow cancel -> recover/cancel?  Once the device is in the cancel 
state, there isn't anything useful the error handler can accomplish, is 
there?  Failed or timed-out commands should simply return an error.

And if you accept that, then what point is there in distinguishing between 
cancel and recover/cancel?  As far as I can see, the only significant 
difference is that in recover/cancel the error handler is running (but not 
accomplishing anything).  Is this related to 1) below?

> > At least, that's how it would work if you allow the RECOVERY -> CANCEL
> > transition.  Either way you end up in the correct state.  So what's wrong
> > with the old (current) system?
> 
> It's just nasty on two counts:
> 
> 1) we have an incorrect bifurcation in the state model and
> 2) we never actually enforce any of the state transitions.

Can you explain 1) more fully?  I don't really understand what you're 
getting at.

As for 2), what do you mean?  In 2.6.13, scsi_device_set_state does not 
change the state if the transition is illegal.

Alan Stern

