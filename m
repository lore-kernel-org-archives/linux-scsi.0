From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 17:52:58 -0400
Message-ID: <446B9B3A.2070403@torque.net>
References: <4468B596.9090508@garzik.org>  <1147789098.3505.19.camel@mulgrave.il.steeleye.com>  <4469F2B2.703@garzik.org>  <1147794708.3505.30.camel@mulgrave.il.steeleye.com>  <4469F9FB.7020807@garzik.org>  <1147797507.3505.52.camel@mulgrave.il.steeleye.com>  <446A048B.6040703@garzik.org> <20060517073701.GE4197@suse.de>  <446B3BE0.8040806@garzik.org> <1147881002.3463.23.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0605171036140.10823@g5.osdl.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0605171036140.10823@g5.osdl.org>
Sender: linux-ide-owner@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jeff@garzik.org>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 17 May 2006, James Bottomley wrote:
> 
>>This is one of the questions.  Currently block has no concept of "host".
> 
> 
> That's good. 
> 
> I don't understand why you'd ever _want_ a concept of "host". The whole 
> concept is broken and unnecessary. At no point should you even need to map 
> from request to host, but if you do, you don't need to introduce any 
> generic "host" notion, you can do it easily per-queue.
> 
> 
>>All it knows about are queues (which may be per host or per device
>>depending on the implementation).  Do we need to introduce the concept
>>of something like queue grouping (a sort of lightweight infrastructure
>>that could be used by the underlying transport to implement a host
>>concept without introducing hosts at the block layer)?
> 
> 
> We already have it. Each queue has its lock pointer. If you want to have a 
> "host" notion, you do it by just setting the queue lock to point to the 
> host lock (since if they are dependent, you'd _better_ share the lock 
> between the queues anyway), and then you do
> 
>   struct myhost_struct *queue_host(struct request_queue *queue)
>   {
> 	return container_of(queue->queue_lock, myhost_struct, host_lock);
>   }
> 
> and there are no changes necessary to the queue layer.
> 
> You can do it other ways too: the "struct kobject" in the queue obviously 
> contains a pointer to the parent of the queue, and that might well be your 
> "host" object. Again, exact same deal, except now you'd use
> 
> 	container_of(queue->kobj.parent, myhost_struct, host_kobject);
> 
> instead. Entirely up to you.
> 
> The whole fixation with "host" in the SCSI layer is a bug, I think. What 
> does it matter, really? And when do you actually have a "request_queue" 
> entry without already knowing which controller it is connected to (ie why 
> do you even need that mapping)?

I'll bite.

>From the perspective of a pass through, any pass
through, the host is all I want. I'm happy to
completely forget about devices as they are
loosely defined at the moment. I view a
host (port) and a network interface as (almost)
the same thing. Carrying on with the analogy,
I view a device as an IP address.

Currently linux has a storage device for each
unique instance of this tuple:
   <host_port, target_port, lu_name>
So if a dual ported disk is fully connected to three
HBAs (hosts) on the same machine then the OS should
show six different devices for the same disk.
Just knowing the wwn of a device (i.e. lu_name)
is not sufficient for error processing, hot plug
processing, etc.

There is also a natural hierarchy of errors (seen
from the OS). Fatal errors associated with the host
(e.g. it is hot unplugged) make starting or ongoing
error recovery at a lower level (i.e. target or lu)
futile.

The linux block layer still shares the quaint
Unix idea of foreseeing errors so it can
disallow requests. This is in the hope that error
processing associated with responses (or lack of
them) will be simplified.

Doug Gilbert



