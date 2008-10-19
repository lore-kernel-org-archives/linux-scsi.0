From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Infinite retries
Date: Sun, 19 Oct 2008 19:07:21 +0200
Message-ID: <48FB6949.9020608@panasas.com>
References: <Pine.LNX.4.44L0.0810191119190.17760-300000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:12746 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750704AbYJSRHb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Oct 2008 13:07:31 -0400
In-Reply-To: <Pine.LNX.4.44L0.0810191119190.17760-300000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

Alan Stern wrote:
> On Sun, 19 Oct 2008, Boaz Harrosh wrote:
> 
>> Alan Stern wrote:
>>> We do have a problem with infinite retry loops.  I'm not sure which 
>>> kernels are affected, but there's a good chance 2.6.27 is and an 
>>> excellent chance that 2.6.28-rc1 will be.
> ...
> 
>> Do you have the scsi_io_completion patchset on a public git somewhere?
>> I would like to re-test them and review them again.
> 
> They aren't in any git repositories, so I am including the two patches
> as attachments to this message.  The first patch changes the failure
> analysis logic in scsi_io_completion() along the lines suggested by
> James, and the second gets rid of scsi_end_request().  They are based
> roughly on 2.6.27, so they might not apply cleanly after the merge
> window.
> 

Thanks. I will apply them in my trees and run with them for a while.
Once the merge window is over, if you resend them (Please do) I will
send my Review-by: (I hope I will review them by then)

> Neither patch addresses the infinite-retry problem; I wanted to keep 
> the issues separate.
> 
>> Did you try them with above problem and do they solve the issue?
> 
> At this point I can't remember exactly which combinations I tried!  :-)  
> However I don't think these patches will have any effect on the retry 
> loop.
> 
>> Also have you looked farther into the retries/timeout issues from
>> block layer?
> 
> Not yet.  I'm waiting for 2.6.28-rc1 to appear.
> 

I would just want to make a comment, for your consideration at this stage.
Once you get to re-examine all this.

Users of SCSI devices like file systems, /dev/sg, or any other source, do
not directly see scsi-devices per-Ce. Even scsi_execute() will just
issue blk_execute_req commands. At this level, of block-request users, there
are two user-parameters: @retries and @timeout. What ever the semantics are
of:
  a.	MAX_TOTAL_TIME=(@retries * @timeout)
or
  b.    MAX_TOTAL_TIME=(@timeout or @retries which ever is shorter)

The SCSI-ml should implement that policy. So at the end of the day
if an fs sends a request it should take at most MAX_TOTAL_TIME. Even if a
brain-dead device short-circuits the scsi logic, the time-frame/retries at the 
block level should be kept, no matter the reason. Which for me means - At no 
condition should a transport/target see more then @retries of the same command,
and the MAX_TOTAL_TIME until a user gets a return code, success/failure, is
some constant.

It seems to me that current scsi-block-device breaks both assumptions. What
does it do with @retries and @timeout is beyond me.

> Alan Stern

Again thanks for looking into this.

Boaz
