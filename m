From: domen@coderock.org
Subject: [patch 1/7] remove old ifdefs aic7xxx
Date: Wed, 12 Jan 2005 00:22:47 +0100
Message-ID: <20050111232247.EFC991F225@trashy.coderock.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:26309 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S262932AbVAKXW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 18:22:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, janitor@sternwelten.at



 Patches to remove some old ifdefs.
 remove most of the #include <linux/version.h>
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |   86 ------------------------
 1 files changed, 86 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~remove-old-ifdefs-aic7xxx_osm_pci drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- kj/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~remove-old-ifdefs-aic7xxx_osm_pci	2005-01-10 17:59:41.000000000 +0100
+++ kj-domen/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-01-10 17:59:41.000000000 +0100
@@ -42,12 +42,6 @@
 #include "aic7xxx_osm.h"
 #include "aic7xxx_pci.h"
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0)
-struct pci_device_id
-{
-};
-#endif
-
 static int	ahc_linux_pci_dev_probe(struct pci_dev *pdev,
 					const struct pci_device_id *ent);
 static int	ahc_linux_pci_reserve_io_region(struct ahc_softc *ahc,
@@ -55,7 +49,6 @@ static int	ahc_linux_pci_reserve_io_regi
 static int	ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
 						 u_long *bus_addr,
 						 uint8_t __iomem **maddr);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 static void	ahc_linux_pci_dev_remove(struct pci_dev *pdev);
 
 /* Define the macro locally since it's different for different class of chips.
@@ -169,7 +162,6 @@ ahc_linux_pci_dev_remove(struct pci_dev 
 	} else
 		ahc_list_unlock(&l);
 }
-#endif /* !LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0) */
 
 static int
 ahc_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
@@ -219,7 +211,6 @@ ahc_linux_pci_dev_probe(struct pci_dev *
 	ahc = ahc_alloc(NULL, name);
 	if (ahc == NULL)
 		return (-ENOMEM);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 	if (pci_enable_device(pdev)) {
 		ahc_free(ahc);
 		return (-ENODEV);
@@ -238,14 +229,12 @@ ahc_linux_pci_dev_probe(struct pci_dev *
 		}
 		ahc->platform_data->hw_dma_mask = DMA_32BIT_MASK;
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
@@ -256,39 +245,14 @@ ahc_linux_pci_dev_probe(struct pci_dev *
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
 	/* Translate error or zero return into zero or one */
 	return pci_module_init(&aic7xxx_pci_driver) ? 0 : 1;
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
@@ -303,22 +267,11 @@ ahc_linux_pci_reserve_io_region(struct a
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
 
@@ -334,17 +287,13 @@ ahc_linux_pci_reserve_mem_region(struct 
 	start = pci_resource_start(ahc->dev_softc, 1);
 	if (start != 0) {
 		*bus_addr = start;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 		if (request_mem_region(start, 0x1000, "aic7xxx") == 0)
 			error = ENOMEM;
-#endif
 		if (error == 0) {
 			*maddr = ioremap_nocache(start, 256);
 			if (*maddr == NULL) {
 				error = ENOMEM;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 				release_mem_region(start, 0x1000);
-#endif
 			}
 		}
 	} else
@@ -387,10 +336,8 @@ ahc_pci_map_registers(struct ahc_softc *
 			       ahc_get_pci_slot(ahc->dev_softc),
 			       ahc_get_pci_function(ahc->dev_softc));
 			iounmap(maddr);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 			release_mem_region(ahc->platform_data->mem_busaddr,
 					   0x1000);
-#endif
 			ahc->bsh.maddr = NULL;
 			maddr = NULL;
 		} else
@@ -443,38 +390,5 @@ ahc_pci_map_int(struct ahc_softc *ahc)
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
