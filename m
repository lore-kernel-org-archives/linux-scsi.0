From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v9 09/10] block, scsi: Make SCSI quiesce and resume work
 reliably
Date: Wed, 18 Oct 2017 07:58:44 +0200
Message-ID: <5d307b6d-a4dd-1681-5149-86e88849d835@suse.de>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
 <20171016232905.5047-10-bart.vanassche@wdc.com>
 <df8b960d-e65d-3e5e-9de7-4423aa65ad92@suse.de>
 <1508271483.3457.15.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1508271483.3457.15.camel@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 10/17/2017 10:18 PM, Bart Van Assche wrote:
> On Tue, 2017-10-17 at 08:33 +0200, Hannes Reinecke wrote:
>> How do you ensure that PREEMPT requests are not stuck in the queue
>> _behind_ non-PREEMPT requests?
>> Once they are in the queue the request are already allocated, so your
>> deferred allocation won't work.
>> _And_ deferred requests will be re-inserted at the head of the queue.
>> Consequently the PREEMPT request will never ever scheduled during quiesce.
>> How do you avoid such a scenario?
> 
> Hello Hannes,
> 
> The blk_mq_freeze_queue() / blk_mq_unfreeze_queue() calls that have been
> added through patch 9/10 to scsi_device_quiesce() will only succeed after all
> outstanding requests have finished. That includes non-preempt requests and
> requests that are about to be requeued. The changes in scsi_device_quiesce()
> are such that blk_queue_enter() will fail for non-preempt requests after the
> queue has been unfrozen. In other words, if a scsi_device_quiesce() call
> succeeds, it is guaranteed that there are no non-preempt requests in the queue
> and also that no new non-preempt requests will enter the queue until
> scsi_device_resume() is called.
> 
Ah. Right.

That was the explanation I was after.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
