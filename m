From: Arthur Marsh <arthur.marsh-CkBdp7X+a1oIQCUVoCVjmQ@public.gmane.org>
Subject: Re: CPU lock-ups with 4.12.0+ kernels related to usb_storage
Date: Tue, 18 Jul 2017 05:45:39 +0930
Message-ID: <d289b9b5-7fb9-f61f-67fb-e4de656a5092@internode.on.net>
References: <Pine.LNX.4.44L0.1707131258190.1571-100000@iolanthe.rowland.org>
 <02c6c52e-d520-6d84-81e7-0b49dfae0ec9@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <02c6c52e-d520-6d84-81e7-0b49dfae0ec9-CkBdp7X+a1oIQCUVoCVjmQ@public.gmane.org>
Content-Language: en-AU
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Arthur Marsh wrote on 14/07/17 04:18:
> 
> 
> Alan Stern wrote on 14/07/17 02:30:
> 
>> All right.  In the meantime, changing usb-storage won't hurt.
>> Arthur, can you test the patch below?
>>
>> Alan Stern
>>
>>
>>
>> Index: usb-4.x/drivers/usb/storage/usb.c
>> ===================================================================
>> --- usb-4.x.orig/drivers/usb/storage/usb.c
>> +++ usb-4.x/drivers/usb/storage/usb.c
>> @@ -315,6 +315,7 @@ static int usb_stor_control_thread(void
>>   {
>>       struct us_data *us = (struct us_data *)__us;
>>       struct Scsi_Host *host = us_to_host(us);
>> +    struct scsi_cmnd *srb;
>>       for (;;) {
>>           usb_stor_dbg(us, "*** thread sleeping\n");
>> @@ -330,6 +331,7 @@ static int usb_stor_control_thread(void
>>           scsi_lock(host);
>>           /* When we are called with no command pending, we're done */
>> +        srb = us->srb;
>>           if (us->srb == NULL) {
>>               scsi_unlock(host);
>>               mutex_unlock(&us->dev_mutex);
>> @@ -398,14 +400,11 @@ static int usb_stor_control_thread(void
>>           /* lock access to the state */
>>           scsi_lock(host);
>> -        /* indicate that the command is done */
>> -        if (us->srb->result != DID_ABORT << 16) {
>> -            usb_stor_dbg(us, "scsi cmd done, result=0x%x\n",
>> -                     us->srb->result);
>> -            us->srb->scsi_done(us->srb);
>> -        } else {
>> +        /* was the command aborted? */
>> +        if (us->srb->result == DID_ABORT << 16) {
>>   SkipForAbort:
>>               usb_stor_dbg(us, "scsi command aborted\n");
>> +            srb = NULL;    /* Don't call srb->scsi_done() */
>>           }
>>           /*
>> @@ -429,6 +428,13 @@ SkipForAbort:
>>           /* unlock the device pointers */
>>           mutex_unlock(&us->dev_mutex);
>> +
>> +        /* now that the locks are released, notify the SCSI core */
>> +        if (srb) {
>> +            usb_stor_dbg(us, "scsi cmd done, result=0x%x\n",
>> +                    srb->result);
>> +            srb->scsi_done(srb);
>> +        }
>>       } /* for (;;) */
>>       /* Wait until we are told to stop */

Hi, just to confirm no further lock-ups occurred in the last 4 days with 
this patch applied.

Arthur.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
