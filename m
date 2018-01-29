From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC 0/2] mpt3sas/megaraid_sas : irq poll and load balancing of
 reply queue
Date: Mon, 29 Jan 2018 09:59:29 +0100
Message-ID: <0d39a305-854e-32cf-806f-f4c7301c7838@suse.de>
References: <92d894a263bf37152fdae9699ccaccff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52065 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751573AbeA2KX2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 05:23:28 -0500
In-Reply-To: <92d894a263bf37152fdae9699ccaccff@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, linux-scsi@vger.kernel.org, Peter Rivera <peter.rivera@broadcom.com>

On 01/15/2018 01:12 PM, Kashyap Desai wrote:
> Hi All -
> 
> We have seen cpu lock up issue from fields if system has greater (more
> than 96) logical cpu count.
> SAS3.0 controller (Invader series) supports at max 96 msix vector and
> SAS3.5 product (Ventura) supports at max 128 msix vectors.
> 
> This may be a generic issue (if PCI device support  completion on multiple
> reply queues). Let me explain it w.r.t to mpt3sas supported h/w just to
> simplify the problem and possible changes to handle such issues. IT HBA
> (mpt3sas) supports multiple reply queues in completion path. Driver
> creates MSI-x vectors for controller as "min of ( FW supported Reply
> queue, Logical CPUs)". If submitter is not interrupted via completion on
> same CPU, there is a loop in the IO path. This behavior can cause
> hard/soft CPU lockups, IO timeout, system sluggish etc.
> 
> Example - one CPU (e.g. CPU A) is busy submitting the IOs and another CPU
> (e.g. CPU B) is busy with processing the corresponding IO's reply
> descriptors from reply descriptor queue upon receiving the interrupts from
> HBA. If the CPU A is continuously pumping the IOs then always CPU B (which
> is executing the ISR) will see the valid reply descriptors in the reply
> descriptor queue and it will be continuously processing those reply
> descriptor in a loop without quitting the ISR handler.  Mpt3sas driver
> will exit ISR handler if it finds unused reply descriptor in the reply
> descriptor queue. Since CPU A will be continuously sending the IOs, CPU B
> may always see a valid reply descriptor (posted by HBA Firmware after
> processing the IO) in the reply descriptor queue. In worst case, driver
> will not quit from this loop in the ISR handler. Eventually, CPU lockup
> will be detected by watchdog.
> 
> Above mentioned behavior is not common if "rq_affinity" set to 2 or
> affinity_hint is honored by irqbalance as "exact".
> If rq_affinity is set to 2, submitter will be always interrupted via
> completion on same CPU.
> If irqbalance is using "exact" policy, interrupt will be delivered to
> submitter CPU.
> 
> Problem statement -
> If CPU counts to MSI-X vectors (reply descriptor Queues) count ratio is
> not 1:1, we still have  exposure of issue explained above and for that we
> don't have any solution.
> 
> Exposure of soft/hard lockup if CPU count is more than MSI-x supported by
> device.
> 
> If CPUs count to MSI-x vectors count ratio is not 1:1, (Other way, if CPU
> counts to MSI-x vector count ratio is something like X:1, where X > 1)
> then 'exact' irqbalance policy OR rq_affinity = 2 won't help to avoid CPU
> hard/soft lockups. There won't be any one to one mapping between CPU to
> MSI-x vector instead one MSI-x interrupt (or reply descriptor queue) is
> shared with group/set of CPUs and there is a possibility of having a loop
> in the IO path within that CPU group and may observe lockups.
> 
> For example: Consider a system having two NUMA nodes and each node having
> four logical CPUs and also consider that number of MSI-x vectors enabled
> on the HBA is two, then CPUs count to MSI-x vector count ratio as 4:1.
> e.g.
> MSIx vector 0 is affinity to  CPU 0, CPU 1, CPU 2 & CPU 3 of NUMA node 0
> and MSI-x vector 1 is affinity to CPU 4, CPU 5, CPU 6 & CPU 7 of NUMA node
> 1.
> 
> numactl --hardware
> available: 2 nodes (0-1)
> node 0 cpus: 0 1 2 3                                                -->
> MSI-x 0
> node 0 size: 65536 MB
> node 0 free: 63176 MB
> node 1 cpus: 4 5 6 7
> -->MSI-x 1
> node 1 size: 65536 MB
> node 1 free: 63176 MB
> 
> Assume that user started an application which uses all the CPUs of NUMA
> node 0 for issuing the IOs.
> Only one CPU from affinity list (it can be any cpu since this behavior
> depends upon irqbalance) CPU0 will receive the interrupts from MSIx vector
> 0 for all the IOs. Eventually, CPU 0 IO submission percentage will be
> decreasing and ISR processing percentage will be increasing as it is more
> busy with processing the interrupts. Gradually IO submission percentage on
> CPU 0 will be zero and it's ISR processing percentage will be 100
> percentage as IO loop has already formed within the NUMA node 0, i.e. CPU
> 1, CPU 2 & CPU 3 will be continuously busy with submitting the heavy IOs
> and only CPU 0 is busy in the ISR path as it always find the valid reply
> descriptor in the reply descriptor queue. Eventually, we will observe the
> hard lockup here.
> 
> Chances of occurring of hard/soft lockups are directly proportional to
> value of X. If value of X is high, then chances of observing CPU lockups
> is high.
> 
> Solution -
> Fix - 1 Use IRQ poll interface defined in " irq_poll.c". mpt3sas driver
> will execute ISR routine in Softirq context and it will always quit the
> loop based on budget provided in IRQ poll interface.
> 
> In these scenarios( i.e. where CPUs count to MSI-X vectors count ratio is
> X:1 (where X >  1)),  IRQ poll interface will avoid CPU hard lockups due
> to voluntary exit from the reply queue processing based on budget.  Note -
> Only one MSI-x vector is busy doing processing. Irqstat ouput -
> 
> IRQs / 1 second(s)
> IRQ#  TOTAL  NODE0   NODE1   NODE2   NODE3  NAME
>   44    122871   122871   0       0       0  IR-PCI-MSI-edge
> mpt3sas0-msix0
>   45        0              0           0       0       0  IR-PCI-MSI-edge
> mpt3sas0-msix1
> 
> Fix-2 - Above fix will avoid lockups, but there can be some performance
> issue if very few reply queue is busy. Driver should round robin the reply
> queue, so that each reply queue is load balanced.  Irqstat ouput after
> driver does reply queue load balance-
> 
> IRQs / 1 second(s)
> IRQ#  TOTAL  NODE0   NODE1   NODE2   NODE3  NAME
>   44  62871  62871       0       0       0  IR-PCI-MSI-edge mpt3sas0-msix0
>   45  62718  62718       0       0       0  IR-PCI-MSI-edge mpt3sas0-msix1
> 
> In Summary,
> CPU completing IO which is not contributing to IO submission, may cause
> cpu lockup.
> If CPUs count to MSI-X vector count ratio is X:1 (where X > 1) then using
> irq poll interface, we can avoid the CPU lockups and by equally
> distributing the interrupts among the enabled MSI-x interrupts we can
> avoid performance issues.
> 
> We are planning to use both the fixes only if cpu count is more than FW
> supported MSI-x vector.
> Please review and provide your feedback. I have appended both the patches.
> 
Actually, I think we should be discussing this issue at LSF; you are not
alone here with this problem, as this could (potentially) hit other
drivers, too.

I think I'll be submitting a topic for this.

In general I'm all for enabling irq polling in individual drivers, but
this should be in addition to the existing code (ie enabled via a module
option or somesuch). Enabling it in general has a high risk of
performance degradation on slower hardware.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
