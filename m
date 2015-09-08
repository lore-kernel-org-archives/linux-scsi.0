From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: [Bugfix] PCI, x86: Correctly allocate IRQs for PCI devices managed
 by non-PCI drivers
Date: Tue, 08 Sep 2015 18:33:25 +0930
Message-ID: <55EEA45D.2070709@internode.on.net>
References: <55EE8106.6060100@internode.on.net> <1441697190-27993-1-git-send-email-jiang.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1441697190-27993-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-pci-owner@vger.kernel.org
To: Jiang Liu <jiang.liu@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Jiang Liu wrote on 08/09/15 16:56:
> Commit 991de2e59090 ("PCI, x86: Implement pcibios_alloc_irq() and
> pcibios_free_irq()") changes the way to allocate PCI legacy IRQ
> for PCI devices on x86 platforms. Instead of allocating PCI legacy
> IRQs when pcibios_enable_device() gets called, now pcibios_alloc_irq()
> will be called by pci_device_probe() to allocate PCI legacy IRQs
> when binding PCI drivers to PCI devices.
>
> But some device drivers, such as eata, directly access PCI devices
> without implementing corresponding PCI drivers, so pcibios_alloc_irq()
> won't be called for those PCI devices and wrong IRQ number may be
> used to manage the PCI device.
>
> So detect such a case in pcibios_enable_device() by checking
> pci_dev->driver is NULL and call pcibios_alloc_irq() to allocate PCI
> legacy IRQs.
>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>   arch/x86/pci/common.c |   10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 09d3afc0a181..60b237783582 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -685,6 +685,16 @@ void pcibios_free_irq(struct pci_dev *dev)
>
>   int pcibios_enable_device(struct pci_dev *dev, int mask)
>   {
> +	/*
> +	 * By design, pcibios_alloc_irq() will be called by pci_device_probe()
> +	 * when binding a PCI device to a PCI driver. But some device drivers,
> +	 * such as eata, directly make use of PCI devices without implementing
> +	 * PCI device drivers, so pcibios_alloc_irq() won't be called for those
> +	 * PCI devices.
> +	 */
> +	if (!dev->driver)
> +		pcibios_alloc_irq(dev);
> +
>   	return pci_enable_resources(dev, mask);
>   }
>
>

Thanks, I removed the test patch and applied the revised patch and built 
and rebooted the kernel and successfully mounted file systems on a disk 
attached to the DPT 2044W card using the eata driver:

[    0.000000] Linux version 4.2.0+ (root@victoria) (gcc version 5.2.1 
20150903
(Debian 5.2.1-16) ) #31 SMP PREEMPT Tue Sep 8 17:36:28 ACST 2015
...

[   80.691097] EATA0: IRQ 10 mapped to IO-APIC IRQ 17.
[   80.724519] EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.
[   80.752035] EATA config options -> tm:1, lc:y, mq:16, rs:y, et:n, 
ip:n, ep:n, pp:y.
[   80.777063] EATA0: 2.0C, PCI 0xd890, IRQ 17, BMST, SG 122, MB 64.
[   80.802391] EATA0: wide SCSI support enabled, max_id 16, max_lun 8.
[   80.827959] EATA0: SCSI channel 0 enabled, host target ID 7.
[   80.853413] scsi host3: EATA/DMA 2.0x rev. 8.10.00
[   82.445662] scsi 3:0:6:0: Direct-Access     IBM      DCAS-34330W 
  S65A PQ: 0 ANSI: 2
[   82.471584] scsi 3:0:6:0: cmds/lun 16, sorted, simple tags.
[   84.571451] sd 3:0:6:0: Attached scsi generic sg4 type 0
[   84.597572] sd 3:0:6:0: [sdd] 8466688 512-byte logical blocks: (4.33 
GB/4.03 GiB)
[   84.659874] sd 3:0:6:0: [sdd] Write Protect is off
[   84.688543] sd 3:0:6:0: [sdd] Mode Sense: b3 00 00 08
[   84.714021] sd 3:0:6:0: [sdd] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   84.817682]  sdd: sdd1 sdd2 < sdd5 >
[   84.919267] sd 3:0:6:0: [sdd] Attached SCSI disk

Arthur.
