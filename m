From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: Avoid potential infinite eh_timeout_handler() loop
Date: Thu, 04 Jun 2015 13:27:21 -0700
Message-ID: <1433449641.1571.50.camel@HansenPartnership.com>
References: <1433443222-8260-1-git-send-email-rajatja@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33099 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932139AbbFDU1Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2015 16:27:24 -0400
In-Reply-To: <1433443222-8260-1-git-send-email-rajatja@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rajat Jain <rajatja@google.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, rajatxjain@gmail.com

On Thu, 2015-06-04 at 11:40 -0700, Rajat Jain wrote:
> Each cmd timeout should result in scmd->retries++. Currently it happens
> just only before a command is requeued back. However, if the LLD
> eh_timed_out() handler asks to reset timer back again, then also it should
> be incremented because effectively LLD will be given a full time period
> (SD_TIMEOUT = 30 secs!) to attempt to complete the command.
> 
> Why this is a problem:
> 
>   => Currently the SCSI low level transport drivers can provide
>      eh_timeout_handler() calls (for e.g. iscsi provides this) to deal
>      with command timeouts.
> 
>   => The eh_timeout_handler() can return BLK_EH_RESET_TIMER that causes the
>      SCSI / block layer to reset the timer, thus giving more time to the
>      LLD.
> 
>   => Currently a LLD can potentially loop infinitely on a command if it
>      always keeps on returning BLK_EH_RESET_TIMER.
> 
> * => Other than choking its own devices, if the command that is stuck is a
>      command issued during sd_probe_async() (e.g. a partition table scan),
>      then it impacts all the disks because no other disks can be removed
>      from the system until sd_probe_async() returns. (sd_remove waits on
>      async_synchronize_full_domain(...))
> 
>   => This problem actually resulted in the situation mentioned above,
>      whereby no disks in the system (on other scsi hosts) could be removed,
>      because of a stuck scsi command to read the partition tables of an
>      unrelated problematic disk during probe. The threads were stuck at:
> 
> 	 schedule+0x312/0x7a0
> 	 async_synchronize_cookie_domain+0xb8/0x115
> 	 ? __wake_up_bit+0x40/0x40
> 	 async_synchronize_full_domain+0x15/0x17
> 	 sd_remove+0x5f/0x135
> 	 __device_release_driver+0x8a/0xe0
> 	 device_release_driver+0x23/0x30
> 	 bus_remove_device+0x10f/0x123
> 	 device_del+0x132/0x18e
> 	 __scsi_remove_device+0x56/0xb6
> 	 scsi_remove_device+0x26/0x33
> 	 scsi_remove_target+0x12d/0x1a0
> 	 ...
> 
> What this patch does:
>   => Ensure that any quests to reset the timer are accounted for, so that
>      there is a finite upper bound on the time that a command is tried.
>      Once allowed number of retries is reached, we proceed to standard
>      error handling procedure (abort etc.) by scheduling the command
>      for EH.
> 
> Signed-off-by: Rajat Jain <rajatja@google.com>

This is actually wrong.  Originally the code you're suggesting did exist
and it used to cause us to time out far too early on some conditions.
Now scmd->retries is for specific things that shouldn't be retried too
often.  Anything else appears to retry forever but in fact there's a
specific check (in the softirq  and io_completion) to check that a
retryable failure hasn't taken longer than  (cmd->allowed + 1) *
req->timeout.

This means effectively that nothing in SCSI is allowed to retry forever.

James


