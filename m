From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: use PCI layer IRQ affinity in lpfc
Date: Fri, 18 Nov 2016 15:20:47 +0100
Message-ID: <20161118142047.iflzar3o6zg56ilm@linux-x5ow.site>
References: <1479395693-5781-1-git-send-email-hch@lst.de>
 <20161118131312.jeenjqwznfap4ced@linux-x5ow.site>
 <20161118132211.GA13756@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52378 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753493AbcKROUv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Nov 2016 09:20:51 -0500
Content-Disposition: inline
In-Reply-To: <20161118132211.GA13756@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, james.smart@broadcom.com, hare@suse.de, linux-scsi@vger.kernel.org

On Fri, Nov 18, 2016 at 05:22:11AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 18, 2016 at 02:13:12PM +0100, Johannes Thumshirn wrote:
> > This is what /proc/interrupts looks like after booting from the lpfc HBA,
> > with your patches:
> > 
> > ettrick:~ # grep lpfc /proc/interrupts 
> >   44: 2056 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 5242880-edge lpfc
> >   46: 2186 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 5244928-edge lpfc
> >   48:   69 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 6815744-edge lpfc:sp
> >   49: 2060 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 6815745-edge lpfc:fp
> >   51:   64 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 6817792-edge lpfc:sp
> >   52: 1074 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 PCI-MSI 6817793-edge lpfc:fp
> > ettrick:~ # for irq in 44 46 48 49 51 52; do echo -n "$irq: "; \
> > >  cat /proc/irq/$irq/smp_affinity; done
> > 44: 55555555
> > 46: 55555555
> > 48: 55555555
> > 49: 55555555
> > 51: 55555555
> > 52: 55555555
> > ettrick:~ # 
> > 
> > Anything else you want me to look at?
> 
> Looks like you have non SLI-4 devices, which doesn't support
> multiple queues, so patch 2 shouldn't have made a difference anyway.
> 
> But even with an SLI-4 device we'd need some actual I/O from different
> CPUs to it to see how the interrupts were spread.

Hmmm
c79:/suse/jthumshirn # fio --rw=randread --name=test --direct=1 \
> --size=1G --time_based --runtime=30s --filename=/dev/sdk \
> --group_reporting --max-jobs=24 --ioengine=libaio --numjobs=24 \
> --iodepth=128
[...]
c79:/suse/jthumshirn # grep lpfc /proc/interrupts 
  51:      2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 IR-PCI-MSI 3674112-edge lpfc:0
  52:      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 IR-PCI-MSI 3674113-edge lpfc:1
  53:      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 IR-PCI-MSI 3674114-edge lpfc:2
  54:      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 IR-PCI-MSI 3674115-edge lpfc:3
  56: 907298 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 IR-PCI-MSI 3676160-edge lpfc:0
  57:      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 IR-PCI-MSI 3676161-edge lpfc:1
  58:      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 IR-PCI-MSI 3676162-edge lpfc:2
  59:      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 IR-PCI-MSI 3676163-edge lpfc:3
c79:/suse/jthumshirn # for irq in 51 52 53 54 56 57 58 59; do echo -n "$irq: ";\
> cat /proc/irq/$irq/smp_affinity; done
51: 00000000,00007007
52: 00000000,00038038
53: 00000000,001c01c0
54: 00000000,00e00e00
56: 00000000,00007007
57: 00000000,00038038
58: 00000000,001c01c0
59: 00000000,00e00e00

c79:/suse/jthumshirn # lspci -s 07:00.2 -vvv | grep "Product Name"
	Product Name: Emulex OneConnect OCe14102-UM 10GbE 2-Port SFP+ PCIe 3.0 Universal CNA, FCoE PF
c79:/suse/jthumshirn # lspci -s 07:00.2 -vvv | grep "MSI-X"
	Capabilities: [48] MSI-X: Enable+ Count=8 Masked-
c79:/suse/jthumshirn # systemctl status irqbalance.service
● irqbalance.service - irqbalance daemon
   Loaded: loaded (/usr/lib/systemd/system/irqbalance.service; disabled; vendor preset: enabled)
   Active: inactive (dead)

Where did I mess up?
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
