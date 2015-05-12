From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: hosts resets in SRP and the rest of the world, was: Re: [PATCH
 01/12] scsi_transport_srp: Introduce srp_wait_for_queuecommand()
Date: Tue, 12 May 2015 10:49:47 +0200
Message-ID: <5551BEAB.5080803@sandisk.com>
References: <20150430093719.GA23486@infradead.org>
 <5542034D.5010300@sandisk.com> <554204D7.9050204@dev.mellanox.co.il>
 <55420AEA.10108@sandisk.com> <20150430172516.GA19200@infradead.org>
 <5549E600.9050208@sandisk.com> <20150511075058.GA18483@infradead.org>
 <55506E46.2060103@sandisk.com> <20150511093130.GA30217@infradead.org>
 <55508B3B.9080806@sandisk.com> <20150511115029.GB32341@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0084.outbound.protection.outlook.com ([157.56.110.84]:54048
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932318AbbELIt4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2015 04:49:56 -0400
In-Reply-To: <20150511115029.GB32341@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Jens Axboe <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On 05/11/15 13:50, Christoph Hellwig wrote:
> On Mon, May 11, 2015 at 12:58:03PM +0200, Bart Van Assche wrote:
>> What I'm wondering about is whether it will be possible with the above
>> approach to trigger path failover before (2 * SCSI timeout) has expired ?
>> Starting SCSI error handling immediately after the block layer has reported
>> the first SCSI timeout is only safe if all ongoing SCSI commands are
>> canceled in some way. Is this what the function blk_abort_request() is
>> intended for ? As far as I can see invoking that function or any function
>> with a similar purpose is only safe after the queuecommand() callback
>> function has finished. However, blk_mq_run_hw_queue() invokes
>> mq_ops->queue_rq() without holding any lock. So it's not clear to me how to
>> safely cancel ongoing blk-mq requests without waiting until these have timed
>> out. I hope that this means that overlooked something ?
>
> For the blk-mq case invoking it earlier should be fine - the
> REQ_ATOM_STARTED and REQ_ATOM_COMPLETE bit ops are specifily designed
> so that calling the timeout handler on any request is fine.  I'm not
> sure about the !blk-mq case, though.

Hello Christoph,

Thanks for the feedback. However, I'm still wondering what will happen 
if blk_abort_request() causes e.g. blk_rq_unmap_user() or 
blk_update_request() to be called while mq_ops->queue_rq() or 
q->request_fn() is still in progress ? More in general, I'm not sure it 
is possible to avoid that blk_abort_request() races with a request 
queuing function by only letting the block layer set an additional 
request flag. Setting an additional flag just before queue_rq() or 
request_fn() is called would not allow to detect when these callback 
functions have finished. Setting a flag just after queue_rq() or 
request_fn() have returned without introducing additional locking or 
atomic operations would make it possible that blk_mark_rq_complete() is 
called from the I/O completion path before that new flag is set. This 
means that with this last approach may make it necessary to increase / 
decrease a request reference count around the queue_rq() or request_fn() 
call + flag set operation. Another possible approach would be to replace 
the REQ_ATOM_STARTED and REQ_ATOM_COMPLETE flags with a request state 
variable that is modified atomically. Further feedback is welcome.

Bart.

