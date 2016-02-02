From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [LSF/MM TOPIC] multiqueue and interrupt assignment
Date: Tue, 2 Feb 2016 10:23:23 -0800
Message-ID: <56B0F41B.8010706@sandisk.com>
References: <56B0D9CF.1080001@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0064.outbound.protection.outlook.com ([207.46.100.64]:61520
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755802AbcBBSX1 convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Tue, 2 Feb 2016 13:23:27 -0500
In-Reply-To: <56B0D9CF.1080001@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On 02/02/2016 08:31 AM, Hannes Reinecke wrote:
> here's another topic which I've hit during my performance tests:
> How should interrupt affinity be handled with blk-multiqueue?
>
> The problem is that the blk-multiqueue assumes a certain
> CPU-to-queue mapping, _and_ the 'queue' in blk-mq syntax is actually
> a submission/completion queue pair.
>
> To achieve optimal performance one should set the interrupt affinity
> for a given (hardware) queue to the matchine (blk-mq) queue.
> But typically the interrupt affinity has to be set during HBA setup
> ie way before any queues are allocated.
> Which means we have three choices:
> - outguess the blk-mq algorithm in the driver and set the
>    interrupt affinity during HBA setup
> - Add some callbacks to coordinate interrupt affinity between
>    driver and blk-mq
> - Defer it to manual assignment, but inferring the risk of
>    a suboptimal performance.
>
> At LSF/MM  I would like to have a discussion on how the interrupt
> affinity should be handled for blk-mq, and whether a generic method
> is possible or desirable.
> Also there is the issue of certain drivers (eg lpfc) which normally
> do interrupt affinity themselves, but disable it for multiqueue.
> Which results in abysmal performance when comparing single queue
> against multiqueue :-(
>
> As a side note, what does blk-mq do if the interrupt affinity is
> _deliberately_ set wrong? IE if the completions for one command
> arrive on completely the wrong queue? Discard the completion? Move
> it to the correct queue?

Hello Hannes,

This topic indeed needs further attention. I also encountered this
challenge while adding scsi-mq support to the SRP initiator driver. What
I learned while working on the SRP driver is the following:
- Although I agree that requests and interrupts should be processed on
   the same processor (same physical chip) if the request has been
   submitted from the CPU closest to the HBA, I'm not convinced that
   processing request completions and interrupts on the same CPU core
   yields the best performance. I would appreciate it if there would
   remain some freedom in how to assign interrupts to CPU cores.
- In several older NUMA systems (Nehalem) the distance from processor
   to PCI adapter is the same for all processors. However, in current
   NUMA systems (Sandy Bridge and later) typically only from one
   processor access latency to a given PCI adapter is optimal. The
   question then becomes which code should hit the QPI latency penalty:
   the interrupt handler or the blk-mq request completion processing
   code ?
- All HBAs I know of support reassignment of an interrupt to another
   CPU core through /proc/irq/<n>/smp_affinity so I was surprised to
   read that you encountered a HBA for which CPU affinity has to be
   set at driver load time ?
- For HBAs that support multiple MSI-X vectors we need an approach for
   associating blk-mq hw-queues with MSI-X vectors. The approach
   implemented in the ib_srp driver is that that driver assumes that
   MSI-X vectors have been spread evenly over physical processors. The
   ib_srp driver then selects an MSI-X vector per hwqueue based on that
   assumption. Since neither the kernel nor irqbalance currently support
   this approach I wrote a script to implement this (see also
http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/21312/focus=98409).
- We need support in irqbalance for HBAs that support multiple MSI-X
   vectors. Last time I checked irqbalance did not support this concept
   which means that it even could happen that irqbalance assigned
   multiple of these interrupt vectors to the same CPU core, something
   that doesn't make sense to me.

A previous discussion about this topic is available in the following
e-mail thread: Christoph Hellwig, [TECH TOPIC] IRQ affinity, linux-rdma
and linux-kernel mailing lists, July 2015
(http://thread.gmane.org/gmane.linux.drivers.rdma/27418). I would
appreciate it if Matthew Wilcox' proposal could be discussed further
during the LSF/MM (http://thread.gmane.org/gmane.linux.drivers.rdma/27418).

Thanks,

Bart.
PLEASE NOTE: The information contained in this electronic mail message is intended only for the use of the designated recipient(s) named above. If the reader of this message is not the intended recipient, you are hereby notified that you have received this message in error and that any review, dissemination, distribution, or copying of this message is strictly prohibited. If you have received this communication in error, please notify the sender by telephone or e-mail (as shown above) immediately and destroy any and all copies of this message in your possession (whether hard copies or electronically stored copies).
