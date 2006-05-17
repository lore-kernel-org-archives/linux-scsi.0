From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 10:47:39 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605171036140.10823@g5.osdl.org>
References: <4468B596.9090508@garzik.org>  <1147789098.3505.19.camel@mulgrave.il.steeleye.com>
  <4469F2B2.703@garzik.org>  <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
  <4469F9FB.7020807@garzik.org>  <1147797507.3505.52.camel@mulgrave.il.steeleye.com>
  <446A048B.6040703@garzik.org> <20060517073701.GE4197@suse.de>
 <446B3BE0.8040806@garzik.org> <1147881002.3463.23.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:17370 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750820AbWEQRsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 13:48:09 -0400
In-Reply-To: <1147881002.3463.23.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>



On Wed, 17 May 2006, James Bottomley wrote:
> 
> This is one of the questions.  Currently block has no concept of "host".

That's good. 

I don't understand why you'd ever _want_ a concept of "host". The whole 
concept is broken and unnecessary. At no point should you even need to map 
from request to host, but if you do, you don't need to introduce any 
generic "host" notion, you can do it easily per-queue.

> All it knows about are queues (which may be per host or per device
> depending on the implementation).  Do we need to introduce the concept
> of something like queue grouping (a sort of lightweight infrastructure
> that could be used by the underlying transport to implement a host
> concept without introducing hosts at the block layer)?

We already have it. Each queue has its lock pointer. If you want to have a 
"host" notion, you do it by just setting the queue lock to point to the 
host lock (since if they are dependent, you'd _better_ share the lock 
between the queues anyway), and then you do

  struct myhost_struct *queue_host(struct request_queue *queue)
  {
	return container_of(queue->queue_lock, myhost_struct, host_lock);
  }

and there are no changes necessary to the queue layer.

You can do it other ways too: the "struct kobject" in the queue obviously 
contains a pointer to the parent of the queue, and that might well be your 
"host" object. Again, exact same deal, except now you'd use

	container_of(queue->kobj.parent, myhost_struct, host_kobject);

instead. Entirely up to you.

The whole fixation with "host" in the SCSI layer is a bug, I think. What 
does it matter, really? And when do you actually have a "request_queue" 
entry without already knowing which controller it is connected to (ie why 
do you even need that mapping)?

			Linus
