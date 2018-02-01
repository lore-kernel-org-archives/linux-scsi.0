From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] irq affinity handling for high CPU count machines
Date: Thu, 1 Feb 2018 17:20:26 +0100
Message-ID: <0f650f4b-aa7f-bf52-2ecb-582761b4937f@suse.de>
References: <45dc032d-a0ce-816c-d2c5-74c69433bd29@suse.de>
 <20180201150532.GA31930@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56285 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752330AbeBAQU2 (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Thu, 1 Feb 2018 11:20:28 -0500
In-Reply-To: <20180201150532.GA31930@ming.t460p>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Kashyap Desai <kashyap.desai@broadcom.com>

On 02/01/2018 04:05 PM, Ming Lei wrote:
> Hello Hannes,
> 
> On Mon, Jan 29, 2018 at 10:08:43AM +0100, Hannes Reinecke wrote:
>> Hi all,
>>
>> here's a topic which came up on the SCSI ML (cf thread '[RFC 0/2]
>> mpt3sas/megaraid_sas: irq poll and load balancing of reply queue').
>>
>> When doing I/O tests on a machine with more CPUs than MSIx vectors
>> provided by the HBA we can easily setup a scenario where one CPU is
>> submitting I/O and the other one is completing I/O. Which will result in
>> the latter CPU being stuck in the interrupt completion routine for
>> basically ever, resulting in the lockup detector kicking in.
> 
> Today I am looking at one megaraid_sas related issue, and found
> pci_alloc_irq_vectors(PCI_IRQ_AFFINITY) is used in the driver, so looks
> each reply queue has been handled by more than one CPU if there are more
> CPUs than MSIx vectors in the system, which is done by generic irq affinity
> code, please see kernel/irq/affinity.c.
> 
> Also IMO each reply queue may be treated as blk-mq's hw queue, then
> megaraid may benefit from blk-mq's MQ framework, but one annoying thing is
> that both legacy and blk-mq path need to be handled inside driver.
> 
The megaraid driver is a really strange beast;, having layered two
different interfaces (the 'legacy' MFI interface and that from from
mpt3sas) on top of each other.
I had been thinking of converting it to scsi-mq, too (as my mpt3sas
patch finally went in), but I'm not sure if we can benefit from it as
we're still be bound by the HBA-wide tag pool.
It's on my todo list, albeit pretty far down :-)

>>
>> How should these situations be handled?
>> Should it be made the responsibility of the drivers, ensuring that the
>> interrupt completion routine is terminated after a certain time?
>> Should it be made the resposibility of the upper layers?
>> Should it be the responsibility of the interrupt mapping code?
>> Can/should interrupt polling be used in these situations?
> 
> Yeah, I guess interrupt polling may improve these situations, especially
> KPTI introduces some extra cost in interrupt handling.
> 
The question is not so much if one should be doing irq polling, but
rather if we can come up with some guidance or even infrastructure to
make this happen automatically.
Having to rely on individual drivers to get this right is probably not
the best option.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
