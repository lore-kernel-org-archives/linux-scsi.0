From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/3] Make scsi_free_queue() abort pending requests
Date: Mon, 14 May 2012 18:43:06 +0000
Message-ID: <4FB1523A.5010003@acm.org>
References: <4FA3EF10.3040104@acm.org> <4FA3F0B1.9040207@acm.org> <4FA43B21.2060906@cs.wisc.edu> <4FA43CC3.6040507@cs.wisc.edu> <4FA4C3BE.1080505@acm.org> <4FA71AE6.4060305@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:43202 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2ENSna (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2012 14:43:30 -0400
In-Reply-To: <4FA71AE6.4060305@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tomas Henzl <thenzl@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>

On 05/07/12 00:44, Mike Christie wrote:

> On 05/05/2012 01:07 AM, Bart Van Assche wrote:
>> On 05/04/12 20:32, Mike Christie wrote:
>>> Oh not wait. I do not get the patch. After blk_cleanup_queue runs then
>>> no IO should be running and no new IO can be queued can it?
>>>
>>>>>  	 */
>>>>>  	blk_cleanup_queue(q);
>>>>> +	blk_abort_queue(q);
>>>>>  
>>>>>  	if (sdev->is_visible) {
>>>>>  		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
>>
>> After blk_cleanup_queue() finished no new requests will be queued to a
>> SCSI LLD. However, that function doesn't wait for already queued
>> requests to finish. I have verified with ib_srp LLD that the\
> 
> It does for me. It is supposed to isn't it? For BLOCK FS requests
> blk_drain_queue will wait for the q->in_flight counters to go to zero.
> They get incremented at scsi_request_fn-> blk_start_request ->
> blk_dequeue_request time and decremented in scsi_end_request ->
> blk_end_request ->  blk_end_bidi_request -> blk_finish_request ->
> blk_put_request -> elv_completed_request. For BLOCK PC and other
> requests there is the rq.count tracking.

I've had a closer look at this and noticed that the q->in_flight[]
decrement in elv_completed_request() is non-atomic and also that that
function is called from one context with the queue lock held
(__blk_put_request()) but from another context without the queue lock
held (blk_execute_rq_nowait() -> flush_end_io() ->
elv_completed_request()). I'd appreciate it if someone who is more
familiar with the block layer than myself could comment on this.

Bart.
