From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: use PCI layer IRQ affinity in lpfc
Date: Fri, 18 Nov 2016 14:13:12 +0100
Message-ID: <20161118131312.jeenjqwznfap4ced@linux-x5ow.site>
References: <1479395693-5781-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751527AbcKRNNR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Nov 2016 08:13:17 -0500
Content-Disposition: inline
In-Reply-To: <1479395693-5781-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: james.smart@broadcom.com, hare@suse.de, linux-scsi@vger.kernel.org

Hi Christoph,

On Thu, Nov 17, 2016 at 04:14:51PM +0100, Christoph Hellwig wrote:
> This series has two patches: the first is a simple conversion of
> lpfc to use pci_alloc_irq_vectors.  The second is more interesting,
> and makes use of the PCI_IRQ_AFFINITY option to use the core interrupt
> affinity assignment that takes nodes into account and can be easily
> queried.  It also ensures we propagate this information to blk-mq
> to make sure the block layer queues are properly aligned to the
> interrupt vectors.
> 
> Note that these patches require core IRQ changes from a stable
> branch in the tip tree to be pulled in first:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/for-block
> 
> Also be aware that I don't have any lpfc hardware to actually test these.

This is what /proc/interrupts looks like after booting from the lpfc HBA,
with your patches:

ettrick:~ # grep lpfc /proc/interrupts 
  44: 2056 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 5242880-edge lpfc
  46: 2186 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 5244928-edge lpfc
  48:   69 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 6815744-edge lpfc:sp
  49: 2060 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 6815745-edge lpfc:fp
  51:   64 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 6817792-edge lpfc:sp
  52: 1074 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 6817793-edge lpfc:fp
ettrick:~ # for irq in 44 46 48 49 51 52; do echo -n "$irq: "; \
>  cat /proc/irq/$irq/smp_affinity; done
44: 55555555
46: 55555555
48: 55555555
49: 55555555
51: 55555555
52: 55555555
ettrick:~ # 

Anything else you want me to look at?

Apart from that, for the whole series:
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
