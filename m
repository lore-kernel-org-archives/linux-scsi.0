From: randy_dunlap <rdunlap@xenotime.net>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Mon, 25 Jul 2005 20:31:33 -0700
Message-ID: <20050725203133.3cfa650d.rdunlap@xenotime.net>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>
	<42D07E94.8070409@drzeus.cx>
	<20050709210824.29a90c5b.rdunlap@xenotime.net>
	<42D12A39.80207@drzeus.cx>
	<20050710093907.3f3c36e4.rdunlap@xenotime.net>
	<42D15968.1080101@drzeus.cx>
	<20050710105635.6d1606e3.rdunlap@xenotime.net>
	<42D17D49.1000007@drzeus.cx>
	<Pine.LNX.4.60.0507132312050.8774@poirot.grange>
	<42E03506.7030707@drzeus.cx>
	<20050721235348.05eace11.rdunlap@xenotime.net>
	<20050722135055.6cb4597d.rdunlap@xenotime.net>
	<42E17451.6090706@drzeus.cx>
	<20050722153651.28d5db51.rdunlap@xenotime.net>
	<42E17772.3020903@drzeus.cx>
	<20050723100945.7d43d063.rdunlap@xenotime.net>
	<42E2933C.4050808@drzeus.cx>
	<20050723152714.4212ba52.rdunlap@xenotime.net>
	<42E2ECF1.8070501@drzeus.cx>
	<20050723184014.49629f9e.rdunlap@xenotime.net>
	<42E39462.3040007@drzeus.cx>
	<20050724100153.3e891484.rdunlap@xenotime.net>
	<42E565FE.40
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chretien.genwebhost.com ([209.59.175.22]:59975 "EHLO
	chretien.genwebhost.com") by vger.kernel.org with ESMTP
	id S261626AbVGZDbv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 23:31:51 -0400
In-Reply-To: <42E565FE.4070708@drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: g.liakhovetski@gmx.de, oliver@neukum.name, linux-scsi@vger.kernel.org

On Tue, 26 Jul 2005 00:21:50 +0200 Pierre Ossman wrote:

> randy_dunlap wrote:
> 
> >  
> >
> >That's a highmem bug.  IIRC, Guennadi said that highmem does not
> >(or may not) work correctly in this driver, so I should have
> >asked you to test with HIGHMEM disabled so that the other bug
> >can be addressed.
> >
> >  
> >
> 
> I have now tried 2.6.12{,.1,.2} and only 2.6.12.2 breaks (without
> HIGHMEM that is).
> 
> (Interested parties readded to cc)

The only 2 differences that I can see that would affect this
(diff patch-2.6.12.1 vs. patch-2.6.1.2) are:  (cut-n-paste, so
has whitespace munging)


1.  (not really likely IMO)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -435,6 +435,7 @@ acpi_pci_irq_enable (
 		/* Interrupt Line values above 0xF are forbidden */
 		if (dev->irq >= 0 && (dev->irq <= 0xF)) {
 			printk(" - using IRQ %d\n", dev->irq);
+			acpi_register_gsi(dev->irq, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW);
 			return_VALUE(0);
 		}
 		else {

2.  Can you back this one out of 2.6.12.2 and test it again?

 diff --git a/mm/memory.c b/mm/memory.c
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1164,7 +1164,7 @@ int remap_pfn_range(struct vm_area_struc
 {
 	pgd_t *pgd;
 	unsigned long next;
-	unsigned long end = addr + size;
+	unsigned long end = addr + PAGE_ALIGN(size);
 	struct mm_struct *mm = vma->vm_mm;
 	int err;
 

There are also a bunch of changes in include/asm-i386/string.h,
but I'll stay away from those for now.


---
~Randy
