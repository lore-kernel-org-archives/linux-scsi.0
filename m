From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Thu, 08 Sep 2005 11:15:25 -0500
Message-ID: <1126196125.4845.40.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509081148350.4607-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:32668 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964897AbVIHQP2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 12:15:28 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509081148350.4607-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2005-09-08 at 11:59 -0400, Alan Stern wrote:
> I don't understand your reasoning.  With your new system, you end up with 
> two threads doing this:
> 
> 	Removal thread			Error handler thread
> 	-------------------------	---------------------------
> 					Go from RUNNING to RECOVERY
> 	Try to go to CANCEL, fail
> 	Go to CANCEL_RECOVERY
> race:	Go to DEL_RECOVERY		Try to go to RUNNING, fail

Actually, no, that's why we have the parallel EH states ... let me put
in the events that trigger state transitions so you can see what
happens:


        EH thread finishes
	<---------------

        EH thread begins
        ---------------->


         <--------- 
  running ---------> recovery
    |                   |
    |                   | scsi_remove_host() called
    v   <----------     v
  cancel ----------> recover/cancel
    |                   |
    |                   | scsi_remove_host finishes visibility removal
    v                   v
   del <------------ recover/del

So the EH is allowed to activate in either running or cancel states, but
goes through its own state transition eventually coming back to del when
it finishes.  Once the EH gets into recover/cancel it can never
transition back to running.

> At least, that's how it would work if you allow the RECOVERY -> CANCEL
> transition.  Either way you end up in the correct state.  So what's wrong
> with the old (current) system?

It's just nasty on two counts:

1) we have an incorrect bifurcation in the state model and
2) we never actually enforce any of the state transitions.

James


