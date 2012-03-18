From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] block: Make blk_drain_queue() work for stopped queues
Date: Sun, 18 Mar 2012 19:47:47 +0000
Message-ID: <4F663BE3.4000503@acm.org>
References: <4F65E09D.6010600@acm.org> <20120318155703.GB8045@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:41721 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab2CRTrw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Mar 2012 15:47:52 -0400
In-Reply-To: <20120318155703.GB8045@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Stanislaw Gruszka <sgruszka@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 03/18/12 15:57, Tejun Heo wrote:
> On Sun, Mar 18, 2012 at 01:18:21PM +0000, Bart Van Assche wrote:
>> All queued requests must be processed eventually. Hence make sure
>> that blk_drain_queue() drains the queue even if the queue is in the
>> stopped state. This patch makes it safe to invoke blk_cleanup_queue()
>> on a stopped queue.
> ...
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 3a78b00..bdcec86 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -300,10 +300,8 @@ EXPORT_SYMBOL(blk_sync_queue);
>>   */
>>  void __blk_run_queue(struct request_queue *q)
>>  {
>> -	if (unlikely(blk_queue_stopped(q)))
>> -		return;
>> -
>> -	q->request_fn(q);
>> +	if (!blk_queue_stopped(q) || blk_queue_dead(q))
>> +		q->request_fn(q);
> So, this allows calling request_fn for dead && stopped queue.  Have
> you seen something which requires this?

Not servicing queued SCSI requests can e.g. cause user space processes
to hang. See also http://lkml.org/lkml/2011/8/27/6 for an example. Hence
commit 3308511c93e6ad0d3c58984ecd6e5e57f96b12c8 which causes pending
SCSI commands to be killed just before blk_cleanup_queue() is invoked.
However, there is still a tiny race window left by that patch - new
requests can get queued after the SCSI request function has been invoked
by scsi_free_queue() and before blk_cleanup_queue() gets invoked. Hence
the proposal to change the block layer to make sure that all queued
requests get processed eventually.

Bart.
