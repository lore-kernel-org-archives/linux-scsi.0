From: dann frazier <dannf@hp.com>
Subject: Re: [PATCH} x86/pci: insert ioapic resource before assign
 unassigned resource for pci
Date: Thu, 9 Jul 2009 16:01:00 -0600
Message-ID: <20090709220100.GN2613@ldl.fc.hp.com>
References: <20090630180300.GA9971@ldl.fc.hp.com>
 <4A4A5B01.9040200@kernel.org>
 <20090703225708.GA30664@ldl.fc.hp.com>
 <4A4FADDC.30606@kernel.org>
 <20090709185945.GG2613@ldl.fc.hp.com>
 <4A564263.5010305@kernel.org>
 <4A564634.1020708@kernel.org>
 <4A564990.3060202@kernel.org>
 <1247172044.3898.147.camel@mulgrave.site>
 <4A56641B.9050204@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:28358 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbZGIWBE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2009 18:01:04 -0400
Content-Disposition: inline
In-Reply-To: <4A56641B.9050204@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org

Thanks Yinghai!

Tested-by: dann frazier <dannf@hp.com>

On Thu, Jul 09, 2009 at 02:41:47PM -0700, Yinghai Lu wrote:
> 
> Stephen reported that his DL585 G2 need noapic after 2.6.22 (?)
> 
> Bann bisected

s/Bann/Dann/ :)

>   --------------------------------------------------------------------
>   commit 30a18d6c3f1e774de656ebd8ff219d53e2ba4029
>   Date:   Tue Feb 19 03:21:20 2008 -0800
> 
>       x86: multi pci root bus with different io resource range, on
>       64-bit
>   --------------------------------------------------------------------
> cause the problem.
> 
> it turns out that
> 1. that system have two HT chains.
> 2. BIOS doesn't allocate resource for BAR 6 under 8132 etc
> 3. that patches will try to split root resource to peer root resources
>    according to pci conf of NB
> 4. pci assign unassign path, assign some range to pci-x  bridge, but it
>    is overlapping with ioapic addr of io4 and 8132.
> 
> the reason is at that point ioapic address and BAR is not inserted yet.
> the BAR for io4 ioapic is not in regular position.
> the BAR for 8132 is sitting to func1, and pci-x bridge is func0.
> 
> aka that patch is not the cause, and it just uncover other problems.
> 
> solution is trying to insert ioapic_resource early a little bit.
> 
> Reported-by: Stephen Frost <sfrost@snowman.net>
> Reported-by: dann frazier <dannf@hp.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/io_apic.h |    2 ++
>  arch/x86/kernel/apic/io_apic.c |   14 +++-----------
>  arch/x86/pci/i386.c            |    7 +++++++
>  3 files changed, 12 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/io_apic.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/io_apic.h
> +++ linux-2.6/arch/x86/include/asm/io_apic.h
> @@ -161,6 +161,7 @@ extern int io_apic_set_pci_routing(struc
>  		 struct io_apic_irq_attr *irq_attr);
>  extern int (*ioapic_renumber_irq)(int ioapic, int irq);
>  extern void ioapic_init_mappings(void);
> +extern void ioapic_insert_resources(void);
>  
>  extern struct IO_APIC_route_entry **alloc_ioapic_entries(void);
>  extern void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries);
> @@ -180,6 +181,7 @@ extern void ioapic_write_entry(int apic,
>  #define io_apic_assign_pci_irqs 0
>  static const int timer_through_8259 = 0;
>  static inline void ioapic_init_mappings(void)	{ }
> +static inline void ioapic_insert_resources(void) { }
>  
>  static inline void probe_nr_irqs_gsi(void)	{ }
>  #endif
> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
> @@ -4182,28 +4182,20 @@ fake_ioapic_page:
>  	}
>  }
>  
> -static int __init ioapic_insert_resources(void)
> +void __init ioapic_insert_resources(void)
>  {
>  	int i;
>  	struct resource *r = ioapic_resources;
>  
>  	if (!r) {
> -		if (nr_ioapics > 0) {
> +		if (nr_ioapics > 0)
>  			printk(KERN_ERR
>  				"IO APIC resources couldn't be allocated.\n");
> -			return -1;
> -		}
> -		return 0;
> +		return;
>  	}
>  
>  	for (i = 0; i < nr_ioapics; i++) {
>  		insert_resource(&iomem_resource, r);
>  		r++;
>  	}
> -
> -	return 0;
>  }
> -
> -/* Insert the IO APIC resources after PCI initialization has occured to handle
> - * IO APICS that are mapped in on a BAR in PCI space. */
> -late_initcall(ioapic_insert_resources);
> Index: linux-2.6/arch/x86/pci/i386.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/i386.c
> +++ linux-2.6/arch/x86/pci/i386.c
> @@ -35,6 +35,7 @@
>  #include <asm/pat.h>
>  #include <asm/e820.h>
>  #include <asm/pci_x86.h>
> +#include <asm/io_apic.h>
>  
>  
>  static int
> @@ -227,6 +228,12 @@ void __init pcibios_resource_survey(void
>  	pcibios_allocate_resources(1);
>  
>  	e820_reserve_resources_late();
> +	/*
> +	 * Insert the IO APIC resources after PCI initialization has
> +	 * occured to handle IO APICS that are mapped in on a BAR in
> +	 * PCI space, but before we trying to assign unassigned pci res.
> +	 */
> +	ioapic_insert_resources();
>  }
>  
>  /**
> 

-- 
dann frazier

