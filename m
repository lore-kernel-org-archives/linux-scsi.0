From: maximilian attems <janitor@sternwelten.at>
Subject: [patch-kj] remove old ifdef'd code from aic7xxx_osm_pci.c
Date: Mon, 21 Jun 2004 20:19:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621181933.GV1545@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:32676 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S264422AbUFUSTd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:19:33 -0400
Received: from localhost (localhost [127.0.0.1])
	by baikonur.stro.at (Postfix) with ESMTP id 537E65C0A4
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:19:32 +0200 (CEST)
Received: from baikonur.stro.at ([127.0.0.1])
	by localhost (baikonur [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 30589-04 for <linux-scsi@vger.kernel.org>;
	Mon, 21 Jun 2004 20:19:30 +0200 (CEST)
Received: from sputnik (unknown [62.47.144.54])
	by baikonur.stro.at (Postfix) with ESMTP id EF9E35C002
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:19:29 +0200 (CEST)
Received: from max by sputnik with local (Exim 4.32)
	id 1BcTOH-0004fx-GT
	for linux-scsi@vger.kernel.org; Mon, 21 Jun 2004 20:19:33 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 From: Domen Puncer <domen@coderock.org>
 Patches to remove some old ifdefs.
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.7-max/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |  103 -----------------
 1 files changed, 5 insertions(+), 98 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~remove-old-ifdefs-aic7xxx_osm_pci drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- linux-2.6.7/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~remove-old-ifdefs-aic7xxx_osm_pci	2004-06-18 09:14:37.000000000 +0200
+++ linux-2.6.7-max/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2004-06-18 09:14:37.000000000 +0200
@@ -41,12 +41,6 @@
 
 #include "aic7xxx_osm.h"
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0)
-struct pci_device_id
-{
-};
-#endif
-
 static int	ahc_linux_pci_dev_probe(struct pci_dev *pdev,
 					const struct pci_device_id *ent);
 static int	ahc_linux_pci_reserve_io_region(struct ahc_softc *ahc,
@@ -54,7 +48,6 @@ static int	ahc_linux_pci_reserve_io_regi
 static int	ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
 						 u_long *bus_addr,
 						 uint8_t **maddr);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 static void	ahc_linux_pci_dev_remove(struct pci_dev *pdev);
 
 /* We do our own ID filtering.  So, grab all SCSI storage class devices. */
@@ -102,13 +95,12 @@ ahc_linux_pci_dev_remove(struct pci_dev 
 	}
 	ahc_list_unlock(&l);
 }
-#endif /* !LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0) */
 
 static int
 ahc_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	char		 buf[80];
-	bus_addr_t	 mask_39bit;
+	dma_addr_t	 mask_39bit;
 	struct		 ahc_softc *ahc;
 	ahc_dev_softc_t	 pci;
 	struct		 ahc_pci_identity *entry;
@@ -152,34 +144,31 @@ ahc_linux_pci_dev_probe(struct pci_dev *
 	ahc = ahc_alloc(NULL, name);
 	if (ahc == NULL)
 		return (-ENOMEM);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	if (pci_enable_device(pdev)) {
 		ahc_free(ahc);
 		return (-ENODEV);
 	}
 	pci_set_master(pdev);
 
-	mask_39bit = (bus_addr_t)0x7FFFFFFFFFULL;
-	if (sizeof(bus_addr_t) > 4
+	mask_39bit = (dma_addr_t)0x7FFFFFFFFFULL;
+	if (sizeof(dma_addr_t) > 4
 	 && ahc_linux_get_memsize() > 0x80000000
-	 && ahc_pci_set_dma_mask(pdev, mask_39bit) == 0) {
+	 && pci_set_dma_mask(pdev, mask_39bit) == 0) {
 		ahc->flags |= AHC_39BIT_ADDRESSING;
 		ahc->platform_data->hw_dma_mask = mask_39bit;
 	} else {
-		if (ahc_pci_set_dma_mask(pdev, 0xFFFFFFFF)) {
+		if (pci_set_dma_mask(pdev, 0xFFFFFFFF)) {
 			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
                 	return (-ENODEV);
 		}
 		ahc->platform_data->hw_dma_mask = 0xFFFFFFFF;
 	}
-#endif
 	ahc->dev_softc = pci;
 	error = ahc_pci_config(ahc, entry);
 	if (error != 0) {
 		ahc_free(ahc);
 		return (-error);
 	}
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	pci_set_drvdata(pdev, ahc);
 	if (aic7xxx_detect_complete) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
@@ -190,38 +179,13 @@ ahc_linux_pci_dev_probe(struct pci_dev *
 		return (-ENODEV);
 #endif
 	}
-#endif
 	return (0);
 }
 
 int
 ahc_linux_pci_init(void)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	return (pci_module_init(&aic7xxx_pci_driver));
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
-		ahc_dev_softc_t pci;
-		int error;
-
-		pci = pdev;
-		error = ahc_linux_pci_dev_probe(pdev, /*pci_devid*/NULL);
-		if (error == 0)
-			found++;
-	}
-	return (found);
-#endif
 }
 
 void
@@ -236,22 +200,11 @@ ahc_linux_pci_reserve_io_region(struct a
 	if (aic7xxx_allow_memio == 0)
 		return (ENOMEM);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 	*base = pci_resource_start(ahc->dev_softc, 0);
-#else
-	*base = ahc_pci_read_config(ahc->dev_softc, PCIR_MAPS, 4);
-	*base &= PCI_BASE_ADDRESS_IO_MASK;
-#endif
 	if (*base == 0)
 		return (ENOMEM);
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0)
-	if (check_region(*base, 256) != 0)
-		return (ENOMEM);
-	request_region(*base, 256, "aic7xxx");
-#else
 	if (request_region(*base, 256, "aic7xxx") == 0)
 		return (ENOMEM);
-#endif
 	return (0);
 }
 
@@ -266,29 +219,18 @@ ahc_linux_pci_reserve_mem_region(struct 
 	int	error;
 
 	error = 0;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 	start = pci_resource_start(ahc->dev_softc, 1);
 	base_page = start & PAGE_MASK;
 	base_offset = start - base_page;
-#else
-	start = ahc_pci_read_config(ahc->dev_softc, PCIR_MAPS+4, 4);
-	base_offset = start & PCI_BASE_ADDRESS_MEM_MASK;
-	base_page = base_offset & PAGE_MASK;
-	base_offset -= base_page;
-#endif
 	if (start != 0) {
 		*bus_addr = start;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 		if (request_mem_region(start, 0x1000, "aic7xxx") == 0)
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
@@ -332,10 +274,8 @@ ahc_pci_map_registers(struct ahc_softc *
 			       ahc_get_pci_slot(ahc->dev_softc),
 			       ahc_get_pci_function(ahc->dev_softc));
 			iounmap((void *)((u_long)maddr & PAGE_MASK));
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 			release_mem_region(ahc->platform_data->mem_busaddr,
 					   0x1000);
-#endif
 			ahc->bsh.maddr = NULL;
 			maddr = NULL;
 		} else
@@ -388,38 +328,5 @@ ahc_pci_map_int(struct ahc_softc *ahc)
 void
 ahc_power_state_change(struct ahc_softc *ahc, ahc_power_state new_state)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	pci_set_power_state(ahc->dev_softc, new_state);
-#else
-	uint32_t cap;
-	u_int cap_offset;
-
-	/*
-	 * Traverse the capability list looking for
-	 * the power management capability.
-	 */
-	cap = 0;
-	cap_offset = ahc_pci_read_config(ahc->dev_softc,
-					 PCIR_CAP_PTR, /*bytes*/1);
-	while (cap_offset != 0) {
-
-		cap = ahc_pci_read_config(ahc->dev_softc,
-					  cap_offset, /*bytes*/4);
-		if ((cap & 0xFF) == 1
-		 && ((cap >> 16) & 0x3) > 0) {
-			uint32_t pm_control;
-
-			pm_control = ahc_pci_read_config(ahc->dev_softc,
-							 cap_offset + 4,
-							 /*bytes*/4);
-			pm_control &= ~0x3;
-			pm_control |= new_state;
-			ahc_pci_write_config(ahc->dev_softc,
-					     cap_offset + 4,
-					     pm_control, /*bytes*/2);
-			break;
-		}
-		cap_offset = (cap >> 8) & 0xFF;
-	}
-#endif 
 }

_
