From: maximilian attems <janitor@sternwelten.at>
Subject: [patch-kj] remove old ifdef'd code from aic79xx_osm_pci.c
Date: Mon, 21 Jun 2004 20:10:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621181059.GP1545@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:65246 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S266365AbUFUSK6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:10:58 -0400
Received: from localhost (localhost [127.0.0.1])
	by baikonur.stro.at (Postfix) with ESMTP id D6BC55C0A4
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:10:57 +0200 (CEST)
Received: from baikonur.stro.at ([127.0.0.1])
	by localhost (baikonur [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 19600-10 for <linux-scsi@vger.kernel.org>;
	Mon, 21 Jun 2004 20:10:57 +0200 (CEST)
Received: from sputnik (unknown [62.47.144.54])
	by baikonur.stro.at (Postfix) with ESMTP id 749375C002
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:10:56 +0200 (CEST)
Received: from max by sputnik with local (Exim 4.32)
	id 1BcTG0-0004IX-1F
	for linux-scsi@vger.kernel.org; Mon, 21 Jun 2004 20:11:00 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


 From: Domen Puncer <domen@coderock.org>
 Patches to remove some old ifdefs.
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.7-max/drivers/scsi/aic7xxx/aic79xx_osm_pci.c |  113 +----------------
 1 files changed, 8 insertions(+), 105 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_osm_pci.c~remove-old-ifdefs-aic79xx_osm_pci drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- linux-2.6.7/drivers/scsi/aic7xxx/aic79xx_osm_pci.c~remove-old-ifdefs-aic79xx_osm_pci	2004-06-18 09:14:00.000000000 +0200
+++ linux-2.6.7-max/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2004-06-18 09:14:00.000000000 +0200
@@ -42,12 +42,6 @@
 #include "aic79xx_osm.h"
 #include "aic79xx_inline.h"
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0)
-struct pci_device_id
-{
-};
-#endif
-
 static int	ahd_linux_pci_dev_probe(struct pci_dev *pdev,
 					const struct pci_device_id *ent);
 static int	ahd_linux_pci_reserve_io_regions(struct ahd_softc *ahd,
@@ -55,7 +49,6 @@ static int	ahd_linux_pci_reserve_io_regi
 static int	ahd_linux_pci_reserve_mem_region(struct ahd_softc *ahd,
 						 u_long *bus_addr,
 						 uint8_t **maddr);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 static void	ahd_linux_pci_dev_remove(struct pci_dev *pdev);
 
 /* We do our own ID filtering.  So, grab all SCSI storage class devices. */
@@ -99,7 +92,6 @@ ahd_linux_pci_dev_remove(struct pci_dev 
 	}
 	ahd_list_unlock(&l);
 }
-#endif /* !LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0) */
 
 static int
 ahd_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
@@ -148,42 +140,39 @@ ahd_linux_pci_dev_probe(struct pci_dev *
 	ahd = ahd_alloc(NULL, name);
 	if (ahd == NULL)
 		return (-ENOMEM);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	if (pci_enable_device(pdev)) {
 		ahd_free(ahd);
 		return (-ENODEV);
 	}
 	pci_set_master(pdev);
 
-	if (sizeof(bus_addr_t) > 4) {
+	if (sizeof(dma_addr_t) > 4) {
 		uint64_t   memsize;
-		bus_addr_t mask_64bit;
-		bus_addr_t mask_39bit;
+		dma_addr_t mask_64bit;
+		dma_addr_t mask_39bit;
 
 		memsize = ahd_linux_get_memsize();
-		mask_64bit = (bus_addr_t)0xFFFFFFFFFFFFFFFFULL;
-		mask_39bit = (bus_addr_t)0x7FFFFFFFFFULL;
+		mask_64bit = (dma_addr_t)0xFFFFFFFFFFFFFFFFULL;
+		mask_39bit = (dma_addr_t)0x7FFFFFFFFFULL;
 		if (memsize >= 0x8000000000ULL
-	 	 && ahd_pci_set_dma_mask(pdev, mask_64bit) == 0) {
+	 	 && pci_set_dma_mask(pdev, mask_64bit) == 0) {
 			ahd->flags |= AHD_64BIT_ADDRESSING;
 			ahd->platform_data->hw_dma_mask = mask_64bit;
 		} else if (memsize > 0x80000000
-			&& ahd_pci_set_dma_mask(pdev, mask_39bit) == 0) {
+			&& pci_set_dma_mask(pdev, mask_39bit) == 0) {
 			ahd->flags |= AHD_39BIT_ADDRESSING;
 			ahd->platform_data->hw_dma_mask = mask_39bit;
 		}
 	} else {
-		ahd_pci_set_dma_mask(pdev, 0xFFFFFFFF);
+		pci_set_dma_mask(pdev, 0xFFFFFFFF);
 		ahd->platform_data->hw_dma_mask = 0xFFFFFFFF;
 	}
-#endif
 	ahd->dev_softc = pci;
 	error = ahd_pci_config(ahd, entry);
 	if (error != 0) {
 		ahd_free(ahd);
 		return (-error);
 	}
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	pci_set_drvdata(pdev, ahd);
 	if (aic79xx_detect_complete) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
@@ -194,38 +183,13 @@ ahd_linux_pci_dev_probe(struct pci_dev *
 		return (-ENODEV);
 #endif
 	}
-#endif
 	return (0);
 }
 
 int
 ahd_linux_pci_init(void)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	return (pci_module_init(&aic79xx_pci_driver));
-#else
-	struct pci_dev *pdev;
-	u_int class;
-	int found;
-
-	/* If we don't have a PCI bus, we can't find any adapters. */
-	if (pci_present() == 0)
-		return (0);
-
-	found = 0;
-	pdev = NULL;
-	class = PCI_CLASS_STORAGE_SCSI << 8;
-	while ((pdev = pci_find_class(class, pdev)) != NULL) {
-		ahd_dev_softc_t pci;
-		int error;
-
-		pci = pdev;
-		error = ahd_linux_pci_dev_probe(pdev, /*pci_devid*/NULL);
-		if (error == 0)
-			found++;
-	}
-	return (found);
-#endif
 }
 
 void
@@ -238,7 +202,6 @@ static int
 ahd_linux_pci_reserve_io_regions(struct ahd_softc *ahd, u_long *base,
 				 u_long *base2)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 	*base = pci_resource_start(ahd->dev_softc, 0);
 	/*
 	 * This is really the 3rd bar and should be at index 2,
@@ -246,28 +209,14 @@ ahd_linux_pci_reserve_io_regions(struct 
 	 * bars.
 	 */
 	*base2 = pci_resource_start(ahd->dev_softc, 3);
-#else
-	*base = ahd_pci_read_config(ahd->dev_softc, AHD_PCI_IOADDR0, 4);
-	*base2 = ahd_pci_read_config(ahd->dev_softc, AHD_PCI_IOADDR1, 4);
-	*base &= PCI_BASE_ADDRESS_IO_MASK;
-	*base2 &= PCI_BASE_ADDRESS_IO_MASK;
-#endif
 	if (*base == 0 || *base2 == 0)
 		return (ENOMEM);
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0)
-	if (check_region(*base, 256) != 0
-	 || check_region(*base2, 256) != 0)
-		return (ENOMEM);
-	request_region(*base, 256, "aic79xx");
-	request_region(*base2, 256, "aic79xx");
-#else
 	if (request_region(*base, 256, "aic79xx") == 0)
 		return (ENOMEM);
 	if (request_region(*base2, 256, "aic79xx") == 0) {
 		release_region(*base2, 256);
 		return (ENOMEM);
 	}
-#endif
 	return (0);
 }
 
@@ -288,29 +237,18 @@ ahd_linux_pci_reserve_mem_region(struct 
 		return (ENOMEM);
 
 	error = 0;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 	start = pci_resource_start(ahd->dev_softc, 1);
 	base_page = start & PAGE_MASK;
 	base_offset = start - base_page;
-#else
-	start = ahd_pci_read_config(ahd->dev_softc, PCIR_MAPS+4, 4);
-	base_offset = start & PCI_BASE_ADDRESS_MEM_MASK;
-	base_page = base_offset & PAGE_MASK;
-	base_offset -= base_page;
-#endif
 	if (start != 0) {
 		*bus_addr = start;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 		if (request_mem_region(start, 0x1000, "aic79xx") == 0)
 			error = ENOMEM;
-#endif
 		if (error == 0) {
 			*maddr = ioremap_nocache(base_page, base_offset + 256);
 			if (*maddr == NULL) {
 				error = ENOMEM;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 				release_mem_region(start, 0x1000);
-#endif
 			} else
 				*maddr += base_offset;
 		}
@@ -352,10 +290,8 @@ ahd_pci_map_registers(struct ahd_softc *
 			       ahd_get_pci_slot(ahd->dev_softc),
 			       ahd_get_pci_function(ahd->dev_softc));
 			iounmap((void *)((u_long)maddr & PAGE_MASK));
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 			release_mem_region(ahd->platform_data->mem_busaddr,
 					   0x1000);
-#endif
 			ahd->bshs[0].maddr = NULL;
 			maddr = NULL;
 		} else
@@ -408,38 +344,5 @@ ahd_pci_map_int(struct ahd_softc *ahd)
 void
 ahd_power_state_change(struct ahd_softc *ahd, ahd_power_state new_state)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	pci_set_power_state(ahd->dev_softc, new_state);
-#else
-	uint32_t cap;
-	u_int cap_offset;
-
-	/*
-	 * Traverse the capability list looking for
-	 * the power management capability.
-	 */
-	cap = 0;
-	cap_offset = ahd_pci_read_config(ahd->dev_softc,
-					 PCIR_CAP_PTR, /*bytes*/1);
-	while (cap_offset != 0) {
-
-		cap = ahd_pci_read_config(ahd->dev_softc,
-					  cap_offset, /*bytes*/4);
-		if ((cap & 0xFF) == 1
-		 && ((cap >> 16) & 0x3) > 0) {
-			uint32_t pm_control;
-
-			pm_control = ahd_pci_read_config(ahd->dev_softc,
-							 cap_offset + 4,
-							 /*bytes*/4);
-			pm_control &= ~0x3;
-			pm_control |= new_state;
-			ahd_pci_write_config(ahd->dev_softc,
-					     cap_offset + 4,
-					     pm_control, /*bytes*/2);
-			break;
-		}
-		cap_offset = (cap >> 8) & 0xFF;
-	}
-#endif 
 }

_
