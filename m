From: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
Subject: Re: Re: [PATCH v2] scsi: Add 'retry_timeout' to avoid infinite
 command retry
Date: Tue, 11 Feb 2014 10:33:44 +0900
Message-ID: <52F97DF8.2040602@hitachi.com>
References: <52F30B5E.8020202@hitachi.com>	 <20140207002241.11465.87367.stgit@ltc223.sdl.hitachi.co.jp> <1391752003.22335.67.camel@dabdike> <52F47A03.2010805@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38723 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaBKBds (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Feb 2014 20:33:48 -0500
In-Reply-To: <52F47A03.2010805@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Libo Chen <clbchenlibo.chen@huawei.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com


(2014/02/07 15:15), Libo Chen wrote:
> On 2014/2/7 13:46, James Bottomley wrote:
>> On Fri, 2014-02-07 at 09:22 +0900, Eiichi Tsukata wrote:
>>> Currently, scsi error handling in scsi_io_completion() tries to
>>> unconditionally requeue scsi command when device keeps some error state.
>>> For example, UNIT_ATTENTION causes infinite retry with
>>> action == ACTION_RETRY.
>>> This is because retryable errors are thought to be temporary and the scsi
>>> device will soon recover from those errors. Normally, such retry policy is
>>> appropriate because the device will soon recover from temporary error state.
>>
>>
>>> But there is no guarantee that device is able to recover from error state
>>> immediately. Actually, we've experienced an infinite retry on some hardware.
>>> Therefore hardware error can results in infinite command retry loop.
>> Could you please add an analysis of the actual failure; which devices
>> and what conditions.
>>
>
> same question, can you explain?


I'm afraid to say that I can't expose the device name because I've not 
confirmed yet that
the device is responsible for the problem with the device manufacturer. 
However, with the
limited evidence, It seems that SCSI command retried with UNIT_ATTENTION.

In the previous thread, Ewan reported that a storage array returned a 
CHECK_CONDITION
with invalid sense data, which caused the command to be retried 
indefinitely:
https://lkml.org/lkml/2013/8/20/498

So, we should try to avoid infinite retry in SCSI middle layer, not in 
each SCSI LLDD.

>>> This patch adds 'retry_timeout' sysfs attribute which limits the retry time
>>> of each scsi command. This attribute is located in scsi sysfs directory
>>> for example "/sys/bus/scsi/devices/X:X:X:X/" and value is in seconds.
>>> Once scsi command retry time is longer than this timeout,
>>> the command is treated as failure. 'retry_timeout' is set to '0' by default
>>> which means no timeout set.
>> Don't do this ... you're mixing a feature (which you'd need to justify)
>> with an apparent bug fix.
>>
>> Once you dump all the complexity, I think the patch boils down to a
>> simple check before the action switch in scsi_io_completion():
>>
>> 	if (action !=  ACTION_FAIL &&
>> 	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
>> 		action = ACTION_FAIL;
>> 		description = "command timed out";
>> 	}
>>

Sounds good!
Thanks for much simpler code. It's enough to fix the bug.
I'll resend the patch soon with the above code.

Eiichi.

>> James
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
>
> .
>

