From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: Is there a grand plan for FC failover?
Date: Thu, 29 Jan 2004 15:25:11 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40199657.2070106@us.ibm.com>
References: <401521A7.5030808@thekelleys.org.uk>	<1075131446.2290.29.camel@mulgrave>	<20040128100236.D11527@vienna.EGENERA.COM>	<1075309052.2254.6.camel@mulgrave>	<20040128130040.E11527@vienna.EGENERA.COM> <401839A8.307@us.ibm.com> 	<20040129102430.G11527@vienna.EGENERA.COM> <1075392058.2381.44.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:3582 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S266515AbUA2XZV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 18:25:21 -0500
In-Reply-To: <1075392058.2381.44.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Philip R. Auld" <pauld@egenera.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

James Bottomley wrote:
> On Thu, 2004-01-29 at 10:24, Philip R. Auld wrote:
> 
>>I think the place to do load balancing would be below the block queue so that
>>the IOs are coalesced. IMO, until you've merged the individual block requests 
>>you can't make a good decision about how to balance the load. 
> 
> 
> Yes, that's what I think too, so the elevator should go above dm, with a
> vestigial elevator between dm and sd simply for SCSI to use in queuing.


I do not think there is anyone that will disagree that there should be 
one elevator that does the sorting, merging, aging etc and that it 
should be at a different layer than it is today for DM multipath.

The modifications to DM to allow a multipath device to have a queue and 
to use it are minial. The problem is it's request_fn_proc. In the DM 
request_fn_proc we could just dequeue a request from the DM device's 
queue, clone it so the IO sched state does not get overwritten, map it 
to the correct lower level device queue, then insert it in the lower 
level device queue. Bad design right? We could do something similar 
where the request_fn_proc recieves a request instead of a queue like 
Jen's is planning for 2.7 
(http://www.kernel.org/pub/linux/kernel/people/axboe/experimental/), and 
then build a framework similar to bio remapping where we just clone and 
remap requests to the correct driver. But still a bad design right?

It doesn't seem like there are a lot of options for 2.6 with the current 
framework. We can add hints so we can try to make a decent decsion, but 
it isn't going to be perfect. But as James said the elevator problem is 
not a requirement for dm to actually work. I guess people will continue 
rolling their own solution if they feel the performance is that bad.

I cc'd Jens as he is best qualified to describe why there are problems 
with queueing requests between different queue's. I apoligize for 
bugging him about this again.


Mike

