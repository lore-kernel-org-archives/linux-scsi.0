From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 2/5] scsi: improved eh timeout handler
Date: Thu, 07 Nov 2013 13:33:31 -0500
Message-ID: <527BDCFB.8080709@interlog.com>
References: <1383635145-112651-1-git-send-email-hare@suse.de> <1383635145-112651-3-git-send-email-hare@suse.de> <527944BF.9000507@cs.wisc.edu> <5279E64E.8040005@suse.de> <527A7AF7.10809@cs.wisc.edu> <527B3707.9060202@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38403 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab3KGSdq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Nov 2013 13:33:46 -0500
In-Reply-To: <527B3707.9060202@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On 13-11-07 01:45 AM, Hannes Reinecke wrote:
> On 11/06/2013 06:23 PM, Mike Christie wrote:
>> On 11/05/2013 10:48 PM, Hannes Reinecke wrote:
>>> On 11/05/2013 08:19 PM, Mike Christie wrote:
>>>> On 11/04/2013 11:05 PM, Hannes Reinecke wrote:
>>>>> +
>>>>> +	scmd->eh_eflags |= SCSI_EH_ABORT_SCHEDULED;
>>>>> +	SCSI_LOG_ERROR_RECOVERY(3,
>>>>> +		scmd_printk(KERN_INFO, scmd,
>>>>> +			    "scmd %p abort scheduled\n", scmd));
>>>>> +	schedule_delayed_work(&scmd->abort_work, HZ / 100);
>>>>> +	return SUCCESS;
>>>>> +}
>>>>
>>>> Do we want to use our own workqueue_struct with WQ_MEM_RECLAIM set?
>>>>
>>> Errm. Yes, why?
>>>
>>> I must admit I'm not _that_ familiar with workqueues ...
>>> Care to explain?
>>>
>>
>> We all share the above workqueue_structs pool of threads, so if we get
>> stuck behind code doing GFP_KERNEL allocs that end up needing to write
>> data to the disk we are now trying to aborts on, then we could get
>> stuck. With WQ_MEM_RECLAIM, we have our own backup thread that gets
>> created at workqueue_struct create time which can get used in cases like
>> that so we can always make forward progress.
>>
> Ah. Right. Yes, that makes sense.
>
> I guess I'll have to redo the patches _yet again_.

I wonder if it might be useful to flag a LU (disk)
with "try really hard to recover me, perhaps at the
expense of other LUs". Seems like a LU containing the
rootfs or swap might qualify for setting such a flag.
And LUs that have this flag cleared could be assumed
to not get wedged in the fashion that Mike pointed out.

Doug Gilbert


