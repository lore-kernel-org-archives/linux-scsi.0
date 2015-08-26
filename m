From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] megaraid_sas: init tasklet earlier
Date: Wed, 26 Aug 2015 16:14:32 +0200
Message-ID: <55DDC9C8.8070507@redhat.com>
References: <1440509507-3337-1-git-send-email-thenzl@redhat.com>
 <a237279f3ee2f546dfc71ae3fe6beaef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbbHZOOe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2015 10:14:34 -0400
In-Reply-To: <a237279f3ee2f546dfc71ae3fe6beaef@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Kiran Kumar Kasturi <kiran-kumar.kasturi@avagotech.com>

On 26.8.2015 15:15, Sumit Saxena wrote:
>> -----Original Message-----
>> From: Tomas Henzl [mailto:thenzl@redhat.com]
>> Sent: Tuesday, August 25, 2015 7:02 PM
>> To: linux-scsi@vger.kernel.org
>> Cc: kashyap.desai@avagotech.com; kiran-kumar.kasturi@avagotech.com;
>> Sumit.Saxena@avagotech.com
>> Subject: [PATCH] megaraid_sas: init tasklet earlier
>>
>> It may happen (kdump), that an interrupt is invoked just after the
> setup_irqs
>> function was called but before the tasklet was initialised.
>> At this phase the hw ints should have been disabled, but for unknown
> reason this
>> mechanism seems to not work properly.
>>
>> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas_base.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>> index 71b884dae2..c8e0c6de80 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>> @@ -4627,6 +4627,9 @@ static int megasas_init_fw(struct megasas_instance
>> *instance)
>>  		"current msix/online cpus\t: (%d/%d)\n",
>>  		instance->msix_vectors, (unsigned int)num_online_cpus());
>>
>> +	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
>> +		(unsigned long)instance);
>> +
>>  	if (instance->msix_vectors ?
>>  		megasas_setup_irqs_msix(instance, 1) :
>>  		megasas_setup_irqs_ioapic(instance))
>> @@ -4647,9 +4650,6 @@ static int megasas_init_fw(struct megasas_instance
>> *instance)
>>  	if (instance->instancet->init_adapter(instance))
>>  		goto fail_init_adapter;
>>
>> -	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
>> -		(unsigned long)instance);
>> -
>>  	instance->instancet->enable_intr(instance);
>>
>>  	printk(KERN_ERR "megasas: INIT adapter done\n");
>
> Patch looks harmless and it fixes your problem then it's fine. But we need
> to know the reason why interrupts are coming even if they are not enabled
> by that time. Can you provide controller's FW version ? I would like to
> try this locally.

It is a "PERC 6/i Integrated" with
FW Version         : 1.22.02-0612
BIOS Version       : 2.04.00
------------------

Even when you'll be able to fix it by another means, we can take
my patch too, just because it calls the init functions in proper order and so it
is safe(r). 

>
>> --
>> 2.4.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

