From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 17:41:36 -0400
Message-ID: <446B9890.7030200@garzik.org>
References: <4468B596.9090508@garzik.org>  <1147789098.3505.19.camel@mulgrave.il.steeleye.com>  <4469F2B2.703@garzik.org>  <1147794708.3505.30.camel@mulgrave.il.steeleye.com>  <4469F9FB.7020807@garzik.org>  <1147797507.3505.52.camel@mulgrave.il.steeleye.com>  <446A048B.6040703@garzik.org> <20060517073701.GE4197@suse.de>  <446B3BE0.8040806@garzik.org> <1147881002.3463.23.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0605171036140.10823@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40649 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751153AbWEQVlr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 17:41:47 -0400
In-Reply-To: <Pine.LNX.4.64.0605171036140.10823@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>

Linus Torvalds wrote:
> 
> On Wed, 17 May 2006, James Bottomley wrote:
>> This is one of the questions.  Currently block has no concept of "host".
> 
> That's good. 
> 
> I don't understand why you'd ever _want_ a concept of "host". The whole 
> concept is broken and unnecessary. At no point should you even need to map 
> from request to host, but if you do, you don't need to introduce any 
> generic "host" notion, you can do it easily per-queue.

"host" is ultimately the wrong word, sure.

It's more about (a) grouping queues into a topology that the user 
expects, as exported by sysfs, and (b) grouping queues for the purposes 
of useful and/or necessary hardware operations like "stop <these> 
queues, so that we can bitbang the hardware".

That grouping of queues, along with the lib-ification of highly common 
request management code[1], is part of the non-SCSI utility that libata 
derives from drivers/scsi.

"group-wide operations" are highly common, and generic code inevitably 
results from that.  But IMO that's helper code, living on top of the 
perfectly-fine existing code.


> The whole fixation with "host" in the SCSI layer is a bug, I think. What 
> does it matter, really? And when do you actually have a "request_queue" 
> entry without already knowing which controller it is connected to (ie why 
> do you even need that mapping)?

True, the mapping is obtained from request_queue not request.

The entry point into a block driver is via q->request_fn(), which only 
has a request_queue for an argument.  So in practice, one usually 
obtains the private controller-info and bus-info data via the 
request_queue's ->queuedata.

Deep into sub-APIs, I've seen that sometimes you'll see only the request 
passed as an argument, because it's easier to walk 
request->queue->controller_info than to pass additional arguments to 
every function.

	Jeff


[1] "resource management":  refers to drivers/scsi's handling of 'device 
busy', 'group-of-queues busy' style transient errors, well integrated 
with block layer's command queueing and well synchronized with the EH 
thread.
