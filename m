From: Rajat Jain <rajatxjain@gmail.com>
Subject: Re: [PATCH] scsi: Avoid potential infinite eh_timeout_handler() loop
Date: Thu, 4 Jun 2015 14:49:00 -0700
Message-ID: <CAA93t1r0DstOijKWJgiL-8BB573fo_vVwxuB_S-_76hBdTT5Eg@mail.gmail.com>
References: <1433443222-8260-1-git-send-email-rajatja@google.com>
	<1433449641.1571.50.camel@HansenPartnership.com>
Reply-To: rajatxjain@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433449641.1571.50.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Rajat Jain <rajatja@google.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello James,

On Thu, Jun 4, 2015 at 1:27 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2015-06-04 at 11:40 -0700, Rajat Jain wrote:
>> Each cmd timeout should result in scmd->retries++. Currently it happens
>> just only before a command is requeued back. However, if the LLD
>> eh_timed_out() handler asks to reset timer back again, then also it should
>> be incremented because effectively LLD will be given a full time period
>> (SD_TIMEOUT = 30 secs!) to attempt to complete the command.
>>
>> Why this is a problem:
>>
>>   => Currently the SCSI low level transport drivers can provide
>>      eh_timeout_handler() calls (for e.g. iscsi provides this) to deal
>>      with command timeouts.
>>
>>   => The eh_timeout_handler() can return BLK_EH_RESET_TIMER that causes the
>>      SCSI / block layer to reset the timer, thus giving more time to the
>>      LLD.
>>
>>   => Currently a LLD can potentially loop infinitely on a command if it
>>      always keeps on returning BLK_EH_RESET_TIMER.
>>
>> * => Other than choking its own devices, if the command that is stuck is a
>>      command issued during sd_probe_async() (e.g. a partition table scan),
>>      then it impacts all the disks because no other disks can be removed
>>      from the system until sd_probe_async() returns. (sd_remove waits on
>>      async_synchronize_full_domain(...))
>>
>>   => This problem actually resulted in the situation mentioned above,
>>      whereby no disks in the system (on other scsi hosts) could be removed,
>>      because of a stuck scsi command to read the partition tables of an
>>      unrelated problematic disk during probe. The threads were stuck at:
>>
>>        schedule+0x312/0x7a0
>>        async_synchronize_cookie_domain+0xb8/0x115
>>        ? __wake_up_bit+0x40/0x40
>>        async_synchronize_full_domain+0x15/0x17
>>        sd_remove+0x5f/0x135
>>        __device_release_driver+0x8a/0xe0
>>        device_release_driver+0x23/0x30
>>        bus_remove_device+0x10f/0x123
>>        device_del+0x132/0x18e
>>        __scsi_remove_device+0x56/0xb6
>>        scsi_remove_device+0x26/0x33
>>        scsi_remove_target+0x12d/0x1a0
>>        ...
>>
>> What this patch does:
>>   => Ensure that any quests to reset the timer are accounted for, so that
>>      there is a finite upper bound on the time that a command is tried.
>>      Once allowed number of retries is reached, we proceed to standard
>>      error handling procedure (abort etc.) by scheduling the command
>>      for EH.
>>
>> Signed-off-by: Rajat Jain <rajatja@google.com>
>
> This is actually wrong.  Originally the code you're suggesting did exist
> and it used to cause us to time out far too early on some conditions.
> Now scmd->retries is for specific things that shouldn't be retried too
> often.  Anything else appears to retry forever but in fact there's a
> specific check (in the softirq  and io_completion) to check that a
> retryable failure hasn't taken longer than  (cmd->allowed + 1) *
> req->timeout.
>
> This means effectively that nothing in SCSI is allowed to retry forever.

Thanks for the review. I'm not sure if I understood completely though.
I see the check you mention in softirq_done and in the
scsi_io_completion, however, I'm not sure if I see that in the
situation I mentioned above (eh_timed_out() always returning returning
BLK_EH_RESET_TIMER), how would the command ever end up in softirq_done
or io_completion (instead of going on infinitely)?

In my experiment, I actually instrumented the SCSI LLD to always ask
for more time (BLK_EH_RESET_TIMER) for 1 of the disks, and I actually
ended up with a system where I couldn't remove ANY of the disks in the
system (for the reasons mentioned in the commit log sd_remove()
waiting infinitely). I'm sure I'm missing something, but I'd
appreciate if you could please help me understand?

Thanks,

Rajat
