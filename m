From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bug 8942] dac960 driver stopped working with 2.6.22 kernel series
Date: Fri, 31 Aug 2007 10:17:33 -0600
Message-ID: <20070831161733.GC14130@parisc-linux.org>
References: <bug-8942-27@http.bugzilla.kernel.org/> <20070831151748.37C39108012@picon.linux-foundation.org> <20070831084259.fc2fd903.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51965 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbXHaQRf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Aug 2007 12:17:35 -0400
Content-Disposition: inline
In-Reply-To: <20070831084259.fc2fd903.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, Greg KH <greg@kroah.com>, alex@nibbles.it, dac@conglom-o.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, linux-scsi@vger.kernel.org

On Fri, Aug 31, 2007 at 08:42:59AM -0700, Andrew Morton wrote:
> On Fri, 31 Aug 2007 08:17:48 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=8942
> 
> Seems that DAC960 broke in 2.6.22 - three people are reporting this.

Interesting.  Because nobody touched DAC960 since 2.6.20 ...

git-log v2.6.21.. drivers/block/DAC960.[ch]
(no output)
The patches which touched it in 2.6.20 seem mechanical enough.

> - BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
> - BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
> + BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
> + BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
>   BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>   BIOS-e820: 0000000000100000 - 000000007fee0000 (usable)
>   BIOS-e820: 000000007fee0000 - 000000007fee3000 (ACPI NVS)

A little bit more memory has been reserved here.  Surely not enough to
affect things.

> -Memory: 2072952k/2096000k available (3291k kernel code, 21964k reserved, 952k data, 192k init, 1178496k highmem)
> +Memory: 2068056k/2096000k available (2176k kernel code, 26764k reserved, 784k data, 356k init, 1178496k highmem)
>  virtual kernel memory layout:
> -    fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
> +    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
>      pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>      vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
>      lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
> -      .init : 0xc0528000 - 0xc0558000   ( 192 kB)
> -      .data : 0xc0436cf1 - 0xc0524f7c   ( 952 kB)
> -      .text : 0xc0100000 - 0xc0436cf1   (3291 kB)
> +      .init : 0xc03eb000 - 0xc0444000   ( 356 kB)
> +      .data : 0xc03202e1 - 0xc03e46c4   ( 784 kB)
> +      .text : 0xc0100000 - 0xc03202e1   (2176 kB)

Seems like quite the different configuration.  Maybe it'd be helpful if
the bug reporter could try very similar configurations?

> +SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1

Could SLUB be causing this?  Seems unlikely, but you never know.

> +EISA: Probing bus 0 at eisa.0
> +Cannot allocate resource for EISA slot 4
> +Cannot allocate resource for EISA slot 5
> +EISA: Detected 0 cards.

Might want to look into that too.

> -ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 16
> +ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 18
>  DAC960: ***** DAC960 RAID Driver Version 2.5.48 of 14 May 2006 *****
>  DAC960: Copyright 1998-2001 by Leonard N. Zubkoff <lnz@dandelion.com>
> -DAC960#0: Configuring Mylex AcceleRAID 170 PCI RAID Controller
> -DAC960#0:   Firmware Version: 7.02-00, Channels: 1, Memory Size: 64MB
> -DAC960#0:   PCI Bus: 0, Device: 11, Function: 0, I/O Address: Unassigned
> -DAC960#0:   PCI Address: 0xD8000000 mapped at 0xF8CB4000, IRQ Channel: 16
> -DAC960#0:   Controller Queue Depth: 512, Maximum Blocks per Command: 2048
> -DAC960#0:   Driver Queue Depth: 511, Scatter/Gather Limit: 128 of 257 Segments
> -DAC960#0:   Physical Devices:
> +DAC960#0: While configuring DAC960 PCI RAID Controller at
> +DAC960#0: PCI Bus 0 Device 11 Function 0 I/O Address N/A PCI Address 0xD8000000
> +DAC960#0: DMA mask out of range FAILED - DETACHING
> +DAC960#0: Unable to Enable Memory Mailbox Interface for Controller at
> +DAC960#0: PCI Bus 0 Device 11 Function 0 I/O Address N/A PCI Address 0xD8000000

So anyway, what's actually failing is one of these:

  if (pci_set_dma_mask(Controller->PCIDevice, DAC690_V1_PciDmaMask))
          return DAC960_Failure(Controller, "DMA mask out of range");
  if (pci_set_dma_mask(Controller->PCIDevice, DAC690_V2_PciDmaMask))
          return DAC960_Failure(Controller, "DMA mask out of range");

These are both defined in DAC960.h:

#define DAC690_V1_PciDmaMask    0xffffffff
#define DAC690_V2_PciDmaMask    0xffffffffffffffffULL

Now, the only way for pci_set_dma_mask() to fail is if
pci_dma_supported() fails.  On i386, pci_dma_supported just returns
dma_supported.  i386's dma_supported fails in one of two ways:

        if(mask < 0x00ffffff)
		return 0;

	/* Work around chipset bugs */
	if (forbid_dac > 0 && mask > 0xffffffffULL)
		return 0;

The first can't fail for either adapter, but the second one can fail for
the V2 adapters.

Proceeding on that premise, how can forbid_dac be set?

static __devinit void via_no_dac(struct pci_dev *dev)
{
        if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
                printk(KERN_INFO "PCI: VIA PCI bridge detected. Disabling DAC.\n
");
                forbid_dac = 1;
        }
}
DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);

And here's the offender in the diff:

+PCI: VIA PCI bridge detected. Disabling DAC.

Now, DAC960 is at fault here; DMA-mapping.txt recommends the following
sequence:

        int using_dac;

        if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
                using_dac = 1;
        } else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
                using_dac = 0;
        } else {
                printk(KERN_WARNING
                       "mydev: No suitable DMA available.\n");
                goto ignore_this_device;
        }

So I'll whip up a patch for DAC960, but in the meantime, these users
can pass "iommu=usedac" as a kernel parameter.

It seems a bit mean to write off *all* VIA bridges as data-corruptors.
Maybe the people who haven't had problems before can help us start a
white-list of VIA PCI bridges that don't have a problem with DAC.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
