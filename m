From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi: mq queue stall during command requeue
Date: Thu, 19 Jan 2017 06:58:09 -0800
Message-ID: <31a4a94c-5cd7-ef45-7103-c61a0d60ab46@kernel.dk>
References: <1484835465-66514-1-git-send-email-hare@suse.de>
 <20170119144651.GA31548@lst.de>
 <0a922801-a30b-7d3e-f871-e5401ad1b9b1@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:34975 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753244AbdASO6L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2017 09:58:11 -0500
Received: by mail-pg0-f43.google.com with SMTP id 194so14860475pgd.2
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2017 06:58:11 -0800 (PST)
In-Reply-To: <0a922801-a30b-7d3e-f871-e5401ad1b9b1@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, James Smart <james.smart@broadcom.com>

On 01/19/2017 06:52 AM, Hannes Reinecke wrote:
> On 01/19/2017 03:46 PM, Christoph Hellwig wrote:
>> On Thu, Jan 19, 2017 at 03:17:45PM +0100, Hannes Reinecke wrote:
>>> When we're hitting a busy condition in queuecommand() we need to
>>> stop the hardware queue before calling blk_mq_delay_queue(); if
>>> we don't blk_mq_delay_queue() will not do anything and requeue
>>> will never triggered.
>>
>> I suspect the stop needs to move into blk_mq_delay_queue to make
>> it more useful.
>>
> Which is what I've suggested to Jens, too.
> And he even agreed to it :-)

Yeah, I made that patch and grepped the tree. The usage in the fc
code in nvme looks weird. It's stopping all potential hardware queues,
yet only delaying one.

if (op->rq) {                                                   
        blk_mq_stop_hw_queues(op->rq->q);                       
        blk_mq_delay_queue(queue->hctx, NVMEFC_QUEUE_DELAY);    
}                                                               
return BLK_MQ_RQ_QUEUE_BUSY;

James/Christoph, what's going on there? I'm going to leave that one
as-is for now, but add the stop to the delay. If the above stop-all is
indeed buggy, then it can later just be removed.

-- 
Jens Axboe

