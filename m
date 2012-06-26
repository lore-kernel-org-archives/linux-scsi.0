From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/4] scsi: Fix device removal NULL pointer dereference
Date: Tue, 26 Jun 2012 07:26:28 +0000
Message-ID: <4FE96424.2060405@acm.org>
References: <4FE8A9FC.6040805@acm.org> <4FE8AAB9.9060602@acm.org>  <1340658889.2980.51.camel@dabdike.int.hansenpartnership.com>  <4FE8E0B9.8050202@cs.wisc.edu> <1340695192.3058.1.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03ant.iops.be ([212.53.5.218]:47739 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509Ab2FZH0f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jun 2012 03:26:35 -0400
In-Reply-To: <1340695192.3058.1.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On 06/26/12 07:19, James Bottomley wrote:

> On Mon, 2012-06-25 at 17:05 -0500, Mike Christie wrote:
>> Only the scsi_tgt_lib.c code uses the uses the uspace_req_q. That code
>> does not use it in a traditional way. It passes __scsi_alloc_queue NULL
>> for the request_fn function argument, so this request queue does not
>> have a function that pulls requests off a queue like is done for the
>> initiator path.
>>
>> That target code mostly uses the queue struct so that it can use the
>> block/scsi functions that need a request queue to build scatterlists,
>> cmds, bios, etc. When that code was made originally we were going to use
>> the queue in a more tradition way or break out the queue limits into
>> another struct and pass them around. I think we have the latter now, but
>> the target code has not been converted.
>>
>> But so that is why we cannot hit a race like you are thinking about in
>> the initiator path.
>>
>> It is also a weird use of the queue so it is also why it does not make
>> sense :)
> 
> OK, could we encapsulate all that in the comment so I don't have to ask
> again in a year's time ... ?


Maybe it's easier to implement Tejun's suggestion (swapping the
blk_cleanup_queue() call and freeing the queuedata) ? That should be
readable for everyone and shouldn't need a comment.

Bart.
