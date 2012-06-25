From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/4] scsi: Fix device removal NULL pointer dereference
Date: Mon, 25 Jun 2012 17:05:45 -0500
Message-ID: <4FE8E0B9.8050202@cs.wisc.edu>
References: <4FE8A9FC.6040805@acm.org> <4FE8AAB9.9060602@acm.org> <1340658889.2980.51.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54915 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370Ab2FYWF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jun 2012 18:05:28 -0400
In-Reply-To: <1340658889.2980.51.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On 06/25/2012 04:14 PM, James Bottomley wrote:
> On Mon, 2012-06-25 at 18:15 +0000, Bart Van Assche wrote:
>> Since scsi_prep_fn() may be invoked concurrently with
>> __scsi_remove_device(), keep the queuedata pointer in
>> __scsi_remove_device(). This patch fixes a kernel oops that
>> can be triggered by USB device removal. See also
>> http://www.spinics.net/lists/linux-scsi/msg56254.html.
> 
> This patch causes a subtle change of semantics: you're substituting our
> signal for dead queue as !sdev with a check of blk_queue_dead(). 
> 
>> Reported-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
>> Cc: James Bottomley <JBottomley@parallels.com>
>> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
>> Cc: <stable@kernel.org>
>> ---
>>  drivers/scsi/hosts.c      |    8 +++++++-
>>  drivers/scsi/scsi_lib.c   |   35 ++++++++---------------------------
>>  drivers/scsi/scsi_priv.h  |    1 -
>>  drivers/scsi/scsi_sysfs.c |    5 +----
>>  4 files changed, 16 insertions(+), 33 deletions(-)
>>
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index a3a056a..6b9d89a 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -299,9 +299,15 @@ static void scsi_host_dev_release(struct device *dev)
>>  		destroy_workqueue(shost->work_q);
>>  	q = shost->uspace_req_q;
>>  	if (q) {
>> +		/*
>> +		 * Note: freeing queuedata before invoking blk_cleanup_queue()
>> +		 * is safe here because no request function is associated with
>> +		 * uspace_req_q. See also the __scsi_alloc_queue() call in
>> +		 * drivers/scsi/scsi_tgt_lib.c.
>> +		 */
> 
> This comment doesn't really make a whole lot of sense.  What I think
> it's saying is that it's OK for the commands executed by the drain in
> blk_cleanup_queue to have a NULL queuedata and by the time we reach
> this, there can be no concurrent racing calls to queuecommand?  Is this
> true, and why?

Only the scsi_tgt_lib.c code uses the uses the uspace_req_q. That code
does not use it in a traditional way. It passes __scsi_alloc_queue NULL
for the request_fn function argument, so this request queue does not
have a function that pulls requests off a queue like is done for the
initiator path.

That target code mostly uses the queue struct so that it can use the
block/scsi functions that need a request queue to build scatterlists,
cmds, bios, etc. When that code was made originally we were going to use
the queue in a more tradition way or break out the queue limits into
another struct and pass them around. I think we have the latter now, but
the target code has not been converted.

But so that is why we cannot hit a race like you are thinking about in
the initiator path.

It is also a weird use of the queue so it is also why it does not make
sense :)

