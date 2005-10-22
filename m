From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally attached
 PHYs)
Date: Fri, 21 Oct 2005 23:53:51 -0400
Message-ID: <4359B7CF.5060509@pobox.com>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com> <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com> <20051020170330.GA16458@lst.de> <4357F7DE.7050004@adaptec.com> <1129852879.30258.137.camel@bluto.andrew> <43583A53.2090904@pobox.com> <435929FD.4070304@adaptec.com> <20051021180455.GA6834@lst.de> <43592FA1.8000206@adaptec.com> <20051021182009.GA3364@parisc-linux.org> <4359A44B.3090804@torque.net> <4359A9FE.4010503@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965206AbVJVDyM@vger.kernel.org>
In-Reply-To: <4359A9FE.4010503@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dougg@torque.net, Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: Matthew Wilcox <matthew@wil.cx>, andrew.patterson@hp.com, "Moore, Eric Dean" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Douglas Gilbert wrote:
>> However, the block layer is used in the context of a
>> block device (and in some cases a char device).
>> If SAS domain discovery is done from the user space, and
>> the root file system is the far side of a SAS expander,
>> there are no suitable devices, just the SAS initiator
>> (HBA) which currently we cannot address via the block layer.

> Invalid example.  All of the methods listed -- request_queue, netlink, 
> chrdev, sysfs, ioctl -- will work just fine when the root filesystem is 
> on the far side of a SAS expander.  These are just methods of 
> communication, nothing more.
> 
> In your example -- userspace discovery required before root filesystem 
> can be found -- a program running from initrd/initramfs would create an 
> SMP device node, open it, and then proceed with the discovery and 
> configuration process, which in turn creates the device nodes necessary 
> to mount the root filesystem.
> 
> A request_queue is just a queue.  You are in complete control of who are 
> the producer(s) of requests, and who are consumer(s).


Since people are having such a tough time grasping the use of 
request_queue without an associated block device, here is a concrete 
example:  drivers/block/sx8.c.

sx8 creates a queue (grep for 'oob_q') specifically for handling 
discovery and configuration requests.  The only requests sent to this 
queue are I2O-ish management commands, never reads or writes.  Since 
they are management commands, these requests are NEVER associated with a 
block device.  Further, when sx8 discovery begins, sx8 block devices 
(and associated request_queues) simply don't exist.

Although sx8 management is entirely in-kernel, one could easily imagine 
how a userland interface (chrdev?) submits userspace commands into this 
queue.  Further, one can see how a host adapter could register one or 
more queues specifically for the transit of SMP commands.

NOTE:  THIS IS NOT AN ENDORSEMENT OF REQUEST QUEUES FOR SMP.  I merely 
wish to clear up misunderstandings about the block layer found in this 
thread.

It remains an open question whether the _complexity_ of this approach is 
more than is warranted for SMP.  But we've departed from that question, 
in this sub-thread :)

I merely illustrate that the block layer is being used _today_ for 
management commands.

	Jeff
