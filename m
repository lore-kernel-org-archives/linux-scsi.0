From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: deadlock between completions and surprise
 module removal
Date: Fri, 05 Sep 2014 09:56:38 -0400
Message-ID: <5409C116.5060702@interlog.com>
References: <5403AB47.3040706@interlog.com> <20140905052402.GA27094@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40457 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169AbaIEN4t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Sep 2014 09:56:49 -0400
In-Reply-To: <20140905052402.GA27094@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Milan Broz <gmazyland@gmail.com>

With scsi-mq I think many LLDs probably have a new
race possibility between a surprise rmmod of the LLD
and another thread presenting a new command at about
the same time (or another thread's command completing
around that time). Does anything above the LLD stop
this happening?

Looking at mpt3sas and hpsa module exit calls, they don't
seem to guard against this possibility.

The test is pretty easy: build the LLD as a module, load
it and fire up a multi-thread, libaio fio test on one or
more devices (SSDs would probably be good) on that LLD.
While the test is running, do 'rmmod LLD'.

Doug Gilbert


On 14-09-05 01:24 AM, Christoph Hellwig wrote:
> Can I get another review for this one?
>
> On Sun, Aug 31, 2014 at 07:09:59PM -0400, Douglas Gilbert wrote:
>> A deadlock has been reported when the completion
>> of SCSI commands (simulated by a timer) was surprised
>> by a module removal. This patch removes one half of
>> the offending locks around timer deletions. This fix
>> is applied both to stop_all_queued() which is were
>> the deadlock was discovered and stop_queued_cmnd()
>> which has very similar logic.
>>
>> This patch should be applied both to the lk 3.17 tree
>> and Christoph's drivers-for-3.18 tree.
>>
>> Tested-and-reported-by: Milan Broz <gmazyland@gmail.com>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>
>> --- a/drivers/scsi/scsi_debug.c	2014-08-26 13:24:51.646948507 -0400
>> +++ b/drivers/scsi/scsi_debug.c	2014-08-30 18:04:54.589226679 -0400
>> @@ -2743,6 +2743,13 @@ static int stop_queued_cmnd(struct scsi_
>>   		if (test_bit(k, queued_in_use_bm)) {
>>   			sqcp = &queued_arr[k];
>>   			if (cmnd == sqcp->a_cmnd) {
>> +				devip = (struct sdebug_dev_info *)
>> +					cmnd->device->hostdata;
>> +				if (devip)
>> +					atomic_dec(&devip->num_in_q);
>> +				sqcp->a_cmnd = NULL;
>> +				spin_unlock_irqrestore(&queued_arr_lock,
>> +						       iflags);
>>   				if (scsi_debug_ndelay > 0) {
>>   					if (sqcp->sd_hrtp)
>>   						hrtimer_cancel(
>> @@ -2755,18 +2762,13 @@ static int stop_queued_cmnd(struct scsi_
>>   					if (sqcp->tletp)
>>   						tasklet_kill(sqcp->tletp);
>>   				}
>> -				__clear_bit(k, queued_in_use_bm);
>> -				devip = (struct sdebug_dev_info *)
>> -					cmnd->device->hostdata;
>> -				if (devip)
>> -					atomic_dec(&devip->num_in_q);
>> -				sqcp->a_cmnd = NULL;
>> -				break;
>> +				clear_bit(k, queued_in_use_bm);
>> +				return 1;
>>   			}
>>   		}
>>   	}
>>   	spin_unlock_irqrestore(&queued_arr_lock, iflags);
>> -	return (k < qmax) ? 1 : 0;
>> +	return 0;
>>   }
>>
>>   /* Deletes (stops) timers or tasklets of all queued commands */
>> @@ -2782,6 +2784,13 @@ static void stop_all_queued(void)
>>   		if (test_bit(k, queued_in_use_bm)) {
>>   			sqcp = &queued_arr[k];
>>   			if (sqcp->a_cmnd) {
>> +				devip = (struct sdebug_dev_info *)
>> +					sqcp->a_cmnd->device->hostdata;
>> +				if (devip)
>> +					atomic_dec(&devip->num_in_q);
>> +				sqcp->a_cmnd = NULL;
>> +				spin_unlock_irqrestore(&queued_arr_lock,
>> +						       iflags);
>>   				if (scsi_debug_ndelay > 0) {
>>   					if (sqcp->sd_hrtp)
>>   						hrtimer_cancel(
>> @@ -2794,12 +2803,8 @@ static void stop_all_queued(void)
>>   					if (sqcp->tletp)
>>   						tasklet_kill(sqcp->tletp);
>>   				}
>> -				__clear_bit(k, queued_in_use_bm);
>> -				devip = (struct sdebug_dev_info *)
>> -					sqcp->a_cmnd->device->hostdata;
>> -				if (devip)
>> -					atomic_dec(&devip->num_in_q);
>> -				sqcp->a_cmnd = NULL;
>> +				clear_bit(k, queued_in_use_bm);
>> +				spin_lock_irqsave(&queued_arr_lock, iflags);
>>   			}
>>   		}
>>   	}
>
> ---end quoted text---
>

