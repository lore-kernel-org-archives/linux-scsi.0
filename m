From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: mq queue stall during command requeue
Date: Fri, 20 Jan 2017 08:24:47 +0100
Message-ID: <ff8d6aad-db47-a4cf-806b-85dbeae88b54@suse.de>
References: <1484835465-66514-1-git-send-email-hare@suse.de>
 <1484842302.2634.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36964 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751324AbdATHns (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Jan 2017 02:43:48 -0500
In-Reply-To: <1484842302.2634.3.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jth@kernel.org" <jth@kernel.org>, "hare@suse.com" <hare@suse.com>

On 01/19/2017 05:11 PM, Bart Van Assche wrote:
> On Thu, 2017-01-19 at 15:17 +0100, Hannes Reinecke wrote:
>> When we're hitting a busy condition in queuecommand() we need to
>> stop the hardware queue before calling blk_mq_delay_queue(); if
>> we don't blk_mq_delay_queue() will not do anything and requeue
>> will never triggered.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/scsi_lib.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index e9e1e14..4b1cbc6 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1951,8 +1951,10 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>>  	switch (ret) {
>>  	case BLK_MQ_RQ_QUEUE_BUSY:
>>  		if (atomic_read(&sdev->device_busy) == 0 &&
>> -		    !scsi_device_blocked(sdev))
>> +		    !scsi_device_blocked(sdev)) {
>> +			blk_mq_stop_hw_queue(hctx);
>>  			blk_mq_delay_queue(hctx, SCSI_QUEUE_DELAY);
>> +		}
>>  		break;
>>  	case BLK_MQ_RQ_QUEUE_ERROR:
>>  		/*
> 
> You may want to add Fixes: 52d7f1b5c2f3 (blk-mq: Avoid that requeueing
> starts stopped queues). See also
> https://www.spinics.net/lists/linux-block/msg06144.html.
> 
Yes indeed.

But the powers that be still ponder if it should be fixed in
the SCSI stack or whether it's a generic fix for blk_mq_delay_queue().

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
