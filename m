From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 1/1 linux-next] hpsa: remove set but unused variable rc
Date: Thu, 30 Oct 2014 06:28:13 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295934CA1C@G9W0745.americas.hpqcorp.net>
References: <1414595704-3119-1-git-send-email-fabf@skynet.be>
 <20141030055517.GC3519@sudip-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141030055517.GC3519@sudip-PC>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Fabian Frederick <fabf@skynet.be>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Sudip Mukherjee
> Sent: Thursday, October 30, 2014 12:55 AM
> To: Fabian Frederick
> Cc: linux-kernel@vger.kernel.org; Stephen M. Cameron; James E.J.
> Bottomley; iss_storagedev@hp.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1 linux-next] hpsa: remove set but unused variable
> rc
> 
> On Wed, Oct 29, 2014 at 04:15:04PM +0100, Fabian Frederick wrote:
> > Fix -Wunused-but-set-variable warning
> 
> you should also mention why you have left the call to
> irq_set_affinity_hint().
> i am not sure , but it looks like irq_set_affinity_hint() is only
> checking if
> the lock is available or not. It is just locking ,then if lock is
> successfull then
> returning 0 or if lock fails then return -EINVAL, and unlocks before
> returnig.
> not doing anything else.
> 
> thanks
> sudip

No, that function sets a mask value that shows up in 
	/proc/irq/nnn/affinity_hint
that a program like irqbalance may use to set the CPU affinity mask
for each irq via 
	/proc/irq/nnn/smp_affinity   (bitmap format)
	/proc/irq/nnn/smp_affinity_list   (range format)

The reason is that in many cases, it is best when all these occur 
on the same CPU that submitted the IO:
* LLD submission queues (if multiple are supported)
* LDD completion queues
* MSI-X interrupt indicating completion
* LLD completion interrupt handler
* block layer completion handler

Benefits include:
* cache efficiency - the data structures for the IO aren't
pulled from CPU to CPU.

* avoid IPI overhead in the block layer to get the completion 
processed on the submitting CPU (which is done if using 
rq_affinity=2 and the interrupt is routed to on another CPU).

* self-throttle the CPUs - avoid swamping one CPU with 
completion processing for IOs submitted by many other CPUs
(which leads to stalls on the victim and timeouts on the
aggressors).

You must run irqbalance with an option to honor the hints;
some versions default to that, others don't.  Or, disable
the irqbalance service and set them up the affinities
manually.
