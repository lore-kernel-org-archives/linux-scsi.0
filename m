From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 15:20:48 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605171505330.10823@g5.osdl.org>
References: <4468B596.9090508@garzik.org>  <1147789098.3505.19.camel@mulgrave.il.steeleye.com>
  <4469F2B2.703@garzik.org>  <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
  <4469F9FB.7020807@garzik.org>  <1147797507.3505.52.camel@mulgrave.il.steeleye.com>
  <446A048B.6040703@garzik.org> <20060517073701.GE4197@suse.de>
 <446B3BE0.8040806@garzik.org> <1147881002.3463.23.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0605171036140.10823@g5.osdl.org> <446B9B3A.2070403@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <446B9B3A.2070403@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jeff@garzik.org>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org



On Wed, 17 May 2006, Douglas Gilbert wrote:
> 
> From the perspective of a pass through, any pass
> through, the host is all I want.

Hell no it isn't.

Trying to make network interfaces and block device queues sound like they 
are the same thing is bogus. They are NOT the same thing.

> Currently linux has a storage device for each
> unique instance of this tuple:
>    <host_port, target_port, lu_name>

No it doesn't.

That's some SCSI internal brain-damage.

Linux has a set of queues, and a way to map from device nodes to queues.

That's all. There's no "host port". There's no "target port". There's a 
queue. You can certainly combine one queue into multiple queues, or you 
can take multiple queues and combine them into one. But don't at _any_ 
point think that it's anything but just a queue.

The queue has a lot of data associated with it (rules for how requests can 
be combined, what the DMA alignment is, etc etc). But it has not, and 
should not have, any idiotic association like a "host" or "target". It's a 
queue, dammit, nothing more.

The thing that associates it with an actual device is a combination of 
queue mappers and the queue lookup logic. 

> So if a dual ported disk is fully connected to three
> HBAs (hosts) on the same machine then the OS should
> show six different devices for the same disk.

It should have six queues, any of which can access the same physical disk. 
And you can decide how to route the requests between those queues with the 
mapping layer or queue lookup. At no point has this got anything to do 
with a "host".

The moment you confuse the issue with a "host", you lose sight of the fact 
that you often don't have a host at all. A queue might be a totally 
virtual thing, that just feeds to other queues (mirroring). It _has_ no 
host. Thinking it has a host is setting yourself up for just doing totally 
idiotic and wrong things.

And even if you can point to a physical chip and say "that is the host", 
that's a totally irrelevant thing. That physical chip migth be an ethernet 
chip, but why the hell would you care, if the _real_ issue is that you 
created a queue that gets transported over TCP on port 666. Another queue 
that gets transported on UDP with some random other protocol on port 1234 
over the same ethernet chip doesn't make those "connected" in any way. The 
"host chip" simply has nothing to do with the block layer.

Similarly, you might have a SCSI chip that implements several "hosts" and 
it's all driven by DMA engines and a nice in-memory mailbox setup, but 
then it shares some of the control registers across all of them, so you 
might have to have a single driver lock. They are really totally 
independent, but they share one point of control - they don't really in 
any way share any "hostness", even if there's one physical connection at 
one point and there migth be soem shared locking to access the setup 
registers.

So the whole "host" notion is broken. It's a totally made-up abstraction, 
that SCSI people seem to have a damn hard time to just _let_go_ of.

There are _real_ points of connection. But "host" doesn't define them.

		Linus
