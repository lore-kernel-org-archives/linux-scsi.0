From: Christoph Hellwig <hch@infradead.org>
Subject: Re: use PCI layer IRQ affinity in lpfc
Date: Fri, 18 Nov 2016 05:22:11 -0800
Message-ID: <20161118132211.GA13756@infradead.org>
References: <1479395693-5781-1-git-send-email-hch@lst.de>
 <20161118131312.jeenjqwznfap4ced@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36462 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752936AbcKRNWP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2016 08:22:15 -0500
Content-Disposition: inline
In-Reply-To: <20161118131312.jeenjqwznfap4ced@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, james.smart@broadcom.com, hare@suse.de, linux-scsi@vger.kernel.org

On Fri, Nov 18, 2016 at 02:13:12PM +0100, Johannes Thumshirn wrote:
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
> ettrick:~ # for irq in 44 46 48 49 51 52; do echo -n "$irq: "; \
> >  cat /proc/irq/$irq/smp_affinity; done
> 44: 55555555
> 46: 55555555
> 48: 55555555
> 49: 55555555
> 51: 55555555
> 52: 55555555
> ettrick:~ # 
> 
> Anything else you want me to look at?

Looks like you have non SLI-4 devices, which doesn't support
multiple queues, so patch 2 shouldn't have made a difference anyway.

But even with an SLI-4 device we'd need some actual I/O from different
CPUs to it to see how the interrupts were spread.
