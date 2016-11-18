From: Hannes Reinecke <hare@suse.de>
Subject: Re: use PCI layer IRQ affinity in lpfc
Date: Fri, 18 Nov 2016 14:22:08 +0100
Message-ID: <eb69503a-69b3-50b8-0734-a248a119d58e@suse.de>
References: <1479395693-5781-1-git-send-email-hch@lst.de>
 <20161118131312.jeenjqwznfap4ced@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45834 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752929AbcKRNWK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Nov 2016 08:22:10 -0500
In-Reply-To: <20161118131312.jeenjqwznfap4ced@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: james.smart@broadcom.com, linux-scsi@vger.kernel.org

On 11/18/2016 02:13 PM, Johannes Thumshirn wrote:
> Hi Christoph,
> 
> On Thu, Nov 17, 2016 at 04:14:51PM +0100, Christoph Hellwig wrote:
>> This series has two patches: the first is a simple conversion of
>> lpfc to use pci_alloc_irq_vectors.  The second is more interesting,
>> and makes use of the PCI_IRQ_AFFINITY option to use the core interrupt
>> affinity assignment that takes nodes into account and can be easily
>> queried.  It also ensures we propagate this information to blk-mq
>> to make sure the block layer queues are properly aligned to the
>> interrupt vectors.
>>
>> Note that these patches require core IRQ changes from a stable
>> branch in the tip tree to be pulled in first:
>>
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/for-block
>>
>> Also be aware that I don't have any lpfc hardware to actually test these.
> 
> This is what /proc/interrupts looks like after booting from the lpfc HBA,
> with your patches:
> 
> ettrick:~ # grep lpfc /proc/interrupts 
>   44: 2056 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 5242880-edge lpfc
>   46: 2186 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 5244928-edge lpfc
>   48:   69 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 6815744-edge lpfc:sp
>   49: 2060 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 6815745-edge lpfc:fp
>   51:   64 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 6817792-edge lpfc:sp
>   52: 1074 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 6817793-edge lpfc:fp

To clarify: this machine has 4 lpfc HBAs, two Zephyr-X (having just one
MSI interrupt each) and two Saturn-X (having one fastpath and one
slowpath each).

So it's not surprising all ending up on the same CPU.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
