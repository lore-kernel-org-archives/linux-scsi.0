From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: support scsi-mq, queues and locks
Date: Thu, 03 Jul 2014 01:35:07 -0400
Message-ID: <53B4EB8B.4070009@interlog.com>
References: <53B0F0C0.40907@interlog.com> <20140702101521.GA3275@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:37822 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbaGCFfd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2014 01:35:33 -0400
In-Reply-To: <20140702101521.GA3275@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, "Elliott, Robert (Server Storage)" <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@ORACLE.COM>, Christoph Hellwig <hch@lst.de>

On 14-07-02 06:15 AM, Christoph Hellwig wrote:
> Hi doug,
>
>> ChangeLog:
>>    - add host_lock option whose default value is 0 which
>>      removes the host_lock around all queued commands
>
> Any reason why we'd want to keep this?  You suggest below that the PI
> parts might need locking, but in that case we should keept it there
> undconditionally until Martin had a chance to verify it.

When something blows up, cmd_size for instance, the tester
has no idea whether it is a bug in scsi_debug's "less locks"
implementation, or somewhere else. Setting host_lock=1 and
re-testing rules out one source of problems.

>>    - accept delay=-1 (_hi_) or -2 which use a tasklet to invoke
>>      the scsi_done callback into the mid-layer. The default
>>      is still delay=1 which uses a timer to delay 1 jiffy
>
> It might be worth to take a look at the null_blk driver for a few
> more completion variants.

For some time I have been looking in vane for deferred
execution that is less than 1 jiffy. This looks like it.

>> IMO the scsi-mq queue_depth handling doesn't break but does
>> not converge promptly (and in some cases seems to be steady
>> state unstable) in the face of TASK_SET_FULL statuses.
>> This can be seen with this sequence:
>>    # cd /sys/bus/pseudo/drivers/scsi_debug
>>    # echo 0x600 > opts
>> < then in another window 'tail -f /var/log/syslog'>
>> < then in yet another window run a fio test against scsi_debug>
>>    # echo 200 > max_queue
>> < if the tail shows nothing, try writing a lower value into max_queue>
>>
>> max_queue starts at 576. Depending on the fio test, the new
>> value written into max_queue needed to prompt the TSF trip
>> point will vary. You will now it when you see it :-)
>
> There's really nothing specific to blk-mq in the queue-full handling,
> so I'd be surprised if if it works that different.  What sort of
> behavior do you see with scsi_debug when not using blk-mq?

Getting the right amount of debug is an art, I'm still
at the 50 MB level, Rob is doing better.

> What happens if you don't use blk-mq but the old host-wide tag
> implementation (e.g. add a call to scsi_init_shared_tag_map in the probe
> function)?
>
>
>>   struct sdebug_queued_cmd {
>> -	int in_use;
>> -	struct timer_list cmnd_timer;
>> -	done_funct_t done_funct;
>> +	/* in_use flagged by a bit in queued_in_use_bm[] */
>> +	struct timer_list *cmnd_timerp;
>> +	struct tasklet_struct *tletp;
>
> Why not keep these allocated as part of the structure and use an union?

The code doesn't allocate and initialize them if it doesn't
need them. The queued_array was over 50 KB when each element
contained an instance of struct timer_list and struct tasklet_struct.
Making queued_array a fixed size reflects the limited
resources of a real HBA (e.g. DMA engines).

>>   static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
>> +static unsigned long queued_in_use_bm[SCSI_DEBUG_CANQUEUE_WORDS];
>
> Any chance you could move to use the cmd_size field in the host template
> instead of the statically allocated commands as suggested earlier?

The virtio_scsi driver is the only one I can see using
the technique and it seems to have mempools for lots of
its scsi structures. Just setting .cmd_size to a non
zero value, loading and unloading the scsi_debug
module, causes a crash.

So IMO, it either needs those mempools (which I can not
find documented) or the mechanism is broken.

The .cmd_size exercise (addition then removal) has led to
a further reduction is scsi_debug locking. That needs more
testing to determine if it is safe.

> That would allow for lockless I/O completions, and probably submissions
> as well at least for the common case.

Even if .cmd_size worked I still can't see that it buys
you much that can't be done other ways.


BTW the virtio_scsi driver as it stands is certainly
not lockless but it does use the term.


Doug Gilbert


