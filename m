From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Fri, 06 Apr 2012 15:13:33 +0200
Message-ID: <4F7EEBFD.8000809@redhat.com>
References: <4F7DA4F8.90104@redhat.com> <4F7EB9E4.4050205@acm.org> <4F7EC1F8.9030706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756810Ab2DFNNn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Apr 2012 09:13:43 -0400
In-Reply-To: <4F7EC1F8.9030706@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>

On 04/06/2012 12:14 PM, Tomas Henzl wrote:
> On 04/06/2012 11:39 AM, Bart Van Assche wrote:
>> On 04/05/12 13:58, Tomas Henzl wrote:
>>
>>> When the async scan is protected this way a further protection via ref. count is no more needed
>>> so remove it
>>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>>> index 29c4c04..be9e6fe 100644
>>> --- a/drivers/scsi/scsi_scan.c
>>> +++ b/drivers/scsi/scsi_scan.c
>>> @@ -1743,10 +1743,9 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>>>  
>>>  	data = kmalloc(sizeof(*data), GFP_KERNEL);
>>>  	if (!data)
>>> -		goto err;
>>> -	data->shost = scsi_host_get(shost);
>>> -	if (!data->shost)
>>> -		goto err;
>>> +		return NULL;
>>> +
>>> +	data->shost = shost;
>>>  	init_completion(&data->prev_finished);
>>>  
>>>  	mutex_lock(&shost->scan_mutex);
>> Maybe it's better to leave the scsi_host_get() / scsi_host_put() pair in
>> scsi_prep_async_scan() and scsi_finish_async_scan(). Let's have a look
>> at the following code in scsi_finish_async_scan():
>>
>> 	spin_lock_irqsave(shost->host_lock, flags);
>> 	shost->async_scan = 0;
>> 	spin_unlock_irqrestore(shost->host_lock, flags);
>>
>> If the context that is waiting for shost->async_scan wouldn't lock
>> shost->host_lock after having observed that shost->async_scan became
>> zero then shost->host_lock could already have been freed before
>> scsi_finish_async_scan() has unlocked that spin lock. Personally I
>> prefer to avoid having such subtle dependencies between the async
>> scanning code and the context waiting for it to finish.
Actually that would be worse than to depend on the shost->host_lock       
  while (shost->async_scan)
                msleep(10);
  spin_lock_irqsave(shost->host_lock, flags); /* hi this spinlock is needed for async scan test above */
We can add this comment ^ ,or add locking to the while loop.

Otherwise we will have this in scsi_finish_async_scan
+	spin_lock_irqsave(shost->host_lock, flags);
+	shost->async_scan = 0;
+	spin_unlock_irqrestore(shost->host_lock, flags);

	scsi_host_put(shost);	
...}
This means that after  scsi_remove_host is left and the driver rmmoded we call
scsi_host_put which in the end calls scsi_host_dev_release and this function tries to use
the now invalid host_template functions again. 



> It's also my preference It's not built in for purpose, I only haven't
> noticed it :)
> Thanks for the advice.
>
> Tomas
>
>
>> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

