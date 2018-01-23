From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 1/5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 23 Jan 2018 08:17:02 -0800
Message-ID: <54f0c19c-38aa-e788-f476-492e5a5734c9@wdc.com>
References: <20180122033550.27855-1-ming.lei@redhat.com>
 <20180122033550.27855-2-ming.lei@redhat.com>
 <1516639793.2545.14.camel@sandisk.com> <20180123005728.GB4411@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:13711 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbeAWQRD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2018 11:17:03 -0500
In-Reply-To: <20180123005728.GB4411@ming.t460p>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "loberman@redhat.com" <loberman@redhat.com>



On 01/22/18 16:57, Ming Lei wrote:
> Even though RCU lock is held during dispatch, preemption or interrupt
> can happen too, so it is simply wrong to depend on the timing to make
> sure __blk_mq_run_hw_queue() can see the request in this situation.

It is very unlikely that this race will ever be hit because that race 
exists for less than one microsecond and the smallest timeout that can 
be specified for delayed queue rerunning is one millisecond. Let's 
address this race if anyone ever finds a way to hit it.

>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index d9ca1dfab154..55be2550c555 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -2030,9 +2030,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>>>   	case BLK_STS_OK:
>>>   		break;
>>>   	case BLK_STS_RESOURCE:
>>> -		if (atomic_read(&sdev->device_busy) == 0 &&
>>> -		    !scsi_device_blocked(sdev))
>>> -			blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
>>> +		if (atomic_read(&sdev->device_busy) ||
>>> +		    scsi_device_blocked(sdev))
>>> +			ret = BLK_STS_DEV_RESOURCE;
>>>   		break;
>>>   	default:
>>>   		/*
>>
>> The above introduces two changes that have not been mentioned in the
>> description of this patch:
>> - The queue rerunning delay is changed from 3 ms into 10 ms. Where is the
>>    explanation of this change? Does this change have a positive or negative
>>    performance impact?
> 
> How can that be a issue for SCSI? The rerunning delay is only triggered
> when there isn't any in-flight requests in SCSI queue.

That change will result in more scsi_queue_rq() calls and hence in 
higher CPU usage. By how much the CPU usage is increased will depend on 
the CPU time required by the LLD .queuecommand() callback if that 
function gets invoked.

Bart.
