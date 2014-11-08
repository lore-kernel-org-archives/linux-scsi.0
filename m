From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH v2 22/36] atari_scsi: Fix atari_scsi deadlocks on Falcon
Date: Sat, 08 Nov 2014 20:22:28 +1300
Message-ID: <545DC4B4.3010109@gmail.com>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052612.445434791@telegraphics.com.au> <545D0A95.3000105@gmail.com> <alpine.LNX.2.00.1411081112580.27924@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1411081112580.27924@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Finn,
>   
>>> Index: linux/drivers/scsi/atari_NCR5380.c
>>> ===================================================================
>>> --- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:36.000000000
>>> +1100
>>> +++ linux/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:45.000000000
>>> +1100
>>> @@ -879,10 +879,10 @@ static void NCR5380_exit(struct Scsi_Hos
>>>    *
>>>    */
>>>   -static int NCR5380_queue_command_lck(struct scsi_cmnd *cmd,
>>> -                                     void (*done)(struct scsi_cmnd *))
>>> +static int NCR5380_queue_command(struct Scsi_Host *instance,
>>> +                                 struct scsi_cmnd *cmd)
>>>   {
>>> -	SETUP_HOSTDATA(cmd->device->host);
>>> +	struct NCR5380_hostdata *hostdata = shost_priv(instance);
>>>    struct scsi_cmnd *tmp;
>>>    unsigned long flags;
>>>       
>> Nitpick - why did this change set go into this particular patch? Because you
>> are converting from NCR5380_queue_command_lck to NCR5380_queue_command?
>>     
>
> That's right.
>   

OK, I just wanted to understand why it's being combined with the stram.c 
patch (and the directly resulting changes in the SCSI driver).

The change to NCR5380_queue_command() can only now be done, as a result 
of the deadlock fixes in this patch, so it follows logically. Makes 
perfectly good sense to me now, thanks.


>>>   @@ -893,7 +893,7 @@ static int NCR5380_queue_command_lck(str
>>>     printk(KERN_NOTICE "scsi%d: WRITE attempted with NO_WRITE debugging flag
>>>     set\n",
>>>            H_NO(cmd));
>>>   		cmd->result = (DID_ERROR << 16);
>>> -		done(cmd);
>>> +		cmd->scsi_done(cmd);
>>>    	return 0;
>>>   	}
>>>   #endif /* (NDEBUG & NDEBUG_NO_WRITE) */
>>> @@ -904,8 +904,6 @@ static int NCR5380_queue_command_lck(str
>>>     */
>>>   
>>>   	SET_NEXT(cmd, NULL);
>>> -	cmd->scsi_done = done;
>>> -
>>>    cmd->result = 0;
>>>   
>>>    /*
>>>       
>> Ditto for these two.
>>     
>
> Again, it follows from the differences in the formal parameters between 
> NCR5380_queue_command_lck() and NCR5380_queue_command().
>   

Yep, I got that bit. Thanks for the explanation, and apologies for the 
noise.

>   
>>> @@ -915,7 +913,6 @@ static int NCR5380_queue_command_lck(str
>>>     * sense data is only guaranteed to be valid while the condition exists.
>>>     */
>>>   -	local_irq_save(flags);
>>>    /* ++guenther: now that the issue queue is being set up, we can lock
>>>    ST-DMA.
>>>     * Otherwise a running NCR5380_main may steal the lock.
>>>     * Lock before actually inserting due to fairness reasons explained in
>>> @@ -928,11 +925,13 @@ static int NCR5380_queue_command_lck(str
>>>     * because also a timer int can trigger an abort or reset, which would
>>>     * alter queues and touch the lock.
>>>     */
>>> -	if (!IS_A_TT()) {
>>> -		/* perhaps stop command timer here */
>>> -		falcon_get_lock();
>>> -		/* perhaps restart command timer here */
>>> -	}
>>> +	/* perhaps stop command timer here */
>>> +	if (!falcon_get_lock())
>>> +		return SCSI_MLQUEUE_HOST_BUSY;
>>> +	/* perhaps restart command timer here */
>>> +
>>>       
>> The comments about stopping and restarting the command timer can be 
>> removed. In 2.4 kernels, the driver would tweak the timers and wait on 
>> the lock unconditionally, Can't ne done anymore, for so many reasons.
>>     
>
> Well, you sent an acked-by for this patch, so I'm a bit confused. Do you 
> want me to re-spin it?
>   

Not at all - this was just something I wanted to raise for future 
patches, before it slips my mind, again. Sorry I did not make that clear 
at all.

I expect we will have an opportunity to address this when we embark on a 
wider cleanup of comments throughout the driver - most of these comments 
were for the 0.9 kernel series and might still be somewhat germane up to 
2.4. Might be totally  misleading now.

Not a priority at all - I know you have bigger fish to fry. I should not 
have brought it up in this context.

No problems at all with this patch (or indeed with the rest of the series).

Cheers,

    Michael
