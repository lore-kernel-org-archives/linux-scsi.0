From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Fri, 06 Apr 2012 12:14:16 +0200
Message-ID: <4F7EC1F8.9030706@redhat.com>
References: <4F7DA4F8.90104@redhat.com> <4F7EB9E4.4050205@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab2DFKO2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Apr 2012 06:14:28 -0400
In-Reply-To: <4F7EB9E4.4050205@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>

On 04/06/2012 11:39 AM, Bart Van Assche wrote:
> On 04/05/12 13:58, Tomas Henzl wrote:
>
>> When the async scan is protected this way a further protection via ref. count is no more needed
>> so remove it
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 29c4c04..be9e6fe 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -1743,10 +1743,9 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>>  
>>  	data = kmalloc(sizeof(*data), GFP_KERNEL);
>>  	if (!data)
>> -		goto err;
>> -	data->shost = scsi_host_get(shost);
>> -	if (!data->shost)
>> -		goto err;
>> +		return NULL;
>> +
>> +	data->shost = shost;
>>  	init_completion(&data->prev_finished);
>>  
>>  	mutex_lock(&shost->scan_mutex);
>
> Maybe it's better to leave the scsi_host_get() / scsi_host_put() pair in
> scsi_prep_async_scan() and scsi_finish_async_scan(). Let's have a look
> at the following code in scsi_finish_async_scan():
>
> 	spin_lock_irqsave(shost->host_lock, flags);
> 	shost->async_scan = 0;
> 	spin_unlock_irqrestore(shost->host_lock, flags);
>
> If the context that is waiting for shost->async_scan wouldn't lock
> shost->host_lock after having observed that shost->async_scan became
> zero then shost->host_lock could already have been freed before
> scsi_finish_async_scan() has unlocked that spin lock. Personally I
> prefer to avoid having such subtle dependencies between the async
> scanning code and the context waiting for it to finish.
It's also my preference It's not built in for purpose, I only haven't
noticed it :)
Thanks for the advice.

Tomas


>
> Bart.

