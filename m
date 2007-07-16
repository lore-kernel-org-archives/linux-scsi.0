From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 3/4] advansys: Convert to pci_register_driver interface
Date: Mon, 16 Jul 2007 16:41:51 -0600
Message-ID: <1184625713127-git-send-email-matthew@wil.cx>
References: <1184625712490-git-send-email-matthew@wil.cx> <11846257131961-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:52243 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758621AbXGQAYy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2007 20:24:54 -0400
In-Reply-To: <11846257131961-git-send-email-matthew@wil.cx>
In-Reply-To: <20070716202815.GQ13826@parisc-linux.org>
References: <20070716202815.GQ13826@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Add a pci_driver interface for the PCI advansys devices.  For
ISA/EISA/VLB devices, we still call advansys_detect and advansys_release.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  170 +++++++++++++++++++++--------------------------
 1 files changed, 75 insertions(+), 95 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 83fd9c7..35c4a1d 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4261,12 +4261,12 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 static int advansys_board_found(struct scsi_host_template *tpnt, int iop,
 				struct pci_dev *pdev, int bus_type)
 {
-    struct Scsi_Host    *shp = NULL;
-    asc_board_t         *boardp = NULL;
+    struct Scsi_Host    *shp;
+    asc_board_t         *boardp;
     ASC_DVC_VAR         *asc_dvc_varp = NULL;
     ADV_DVC_VAR         *adv_dvc_varp = NULL;
-    adv_sgblk_t         *sgp = NULL;
-    int                 share_irq = FALSE;
+    adv_sgblk_t         *sgp;
+    int                 share_irq;
     int                 iolen = 0;
     ADV_PADDR           pci_memory_address;
     int                 warn_code, err_code;
@@ -4284,6 +4284,8 @@ static int advansys_board_found(struct scsi_host_template *tpnt, int iop,
 
             /* Save a pointer to the Scsi_Host of each board found. */
             asc_host[asc_board_count++] = shp;
+	    if (pdev)
+		pci_set_drvdata(pdev, shp);
 
             /* Initialize private per board data */
             boardp = ASC_BOARDP(shp);
@@ -5033,9 +5035,8 @@ static int advansys_board_found(struct scsi_host_template *tpnt, int iop,
                     sgp = (adv_sgblk_t *)
                         kmalloc(sizeof(adv_sgblk_t), GFP_ATOMIC);
 
-                    if (sgp == NULL) {
+                    if (sgp == NULL)
                         break;
-                    }
 
                     sgp->next_sgblkp = boardp->adv_sgblkp;
                     boardp->adv_sgblkp = sgp;
@@ -5171,24 +5172,6 @@ advansys_detect(struct scsi_host_template *tpnt)
     int                 iop;
     int                 bus;
     int                 ioport = 0;
-#ifdef CONFIG_PCI
-    int                 pci_init_search = 0;
-    struct pci_dev      *pci_devicep[ASC_NUM_BOARD_SUPPORTED];
-    int                 pci_card_cnt_max = 0;
-    int                 pci_card_cnt = 0;
-    struct pci_dev      *pci_devp = NULL;
-    int                 pci_device_id_cnt = 0;
-    unsigned int        pci_device_id[ASC_PCI_DEVICE_ID_CNT] = {
-                                    PCI_DEVICE_ID_ASP_1200A,
-                                    PCI_DEVICE_ID_ASP_ABP940,
-                                    PCI_DEVICE_ID_ASP_ABP940U,
-                                    PCI_DEVICE_ID_ASP_ABP940UW,
-                                    PCI_DEVICE_ID_38C0800_REV1,
-                                    PCI_DEVICE_ID_38C1600_REV1
-                        };
-#else
-#define pci_devp NULL
-#endif /* CONFIG_PCI */
 
     if (detect_called == ASC_FALSE) {
         detect_called = ASC_TRUE;
@@ -5312,70 +5295,6 @@ advansys_detect(struct scsi_host_template *tpnt)
 #endif /* CONFIG_ISA */
                 break;
 
-            case ASC_IS_PCI:
-#ifdef CONFIG_PCI
-                if (pci_init_search == 0) {
-                    int i, j;
-
-                    pci_init_search = 1;
-
-                    /* Find all PCI cards. */
-                    while (pci_device_id_cnt < ASC_PCI_DEVICE_ID_CNT) {
-                        if ((pci_devp = pci_find_device(PCI_VENDOR_ID_ASP,
-                            pci_device_id[pci_device_id_cnt], pci_devp)) ==
-                            NULL) {
-                            pci_device_id_cnt++;
-                        } else {
-                            if (pci_enable_device(pci_devp) == 0) {
-                                pci_devicep[pci_card_cnt_max++] = pci_devp;
-                            }
-                        }
-                    }
-
-                    /*
-                     * Sort PCI cards in ascending order by PCI Bus, Slot,
-                     * and Device Number.
-                     */
-                    for (i = 0; i < pci_card_cnt_max - 1; i++)
-                    {
-                        for (j = i + 1; j < pci_card_cnt_max; j++) {
-                            if ((pci_devicep[j]->bus->number <
-                                 pci_devicep[i]->bus->number) ||
-                                ((pci_devicep[j]->bus->number ==
-                                  pci_devicep[i]->bus->number) &&
-                                  (pci_devicep[j]->devfn <
-                                   pci_devicep[i]->devfn))) {
-                                pci_devp = pci_devicep[i];
-                                pci_devicep[i] = pci_devicep[j];
-                                pci_devicep[j] = pci_devp;
-                            }
-                        }
-                    }
-
-                    pci_card_cnt = 0;
-                } else {
-                    pci_card_cnt++;
-                }
-
-                if (pci_card_cnt == pci_card_cnt_max) {
-                    iop = 0;
-                } else {
-                    pci_devp = pci_devicep[pci_card_cnt];
-
-                    ASC_DBG2(2,
-                        "advansys_detect: devfn %d, bus number %d\n",
-                        pci_devp->devfn, pci_devp->bus->number);
-                    iop = pci_resource_start(pci_devp, 0);
-                    ASC_DBG2(1,
-                        "advansys_detect: vendorID %X, deviceID %X\n",
-                        pci_devp->vendor, pci_devp->device);
-                    ASC_DBG2(2, "advansys_detect: iop %X, irqLine %d\n",
-                        iop, pci_devp->irq);
-                }
-
-#endif /* CONFIG_PCI */
-                break;
-
             default:
                 ASC_PRINT1("advansys_detect: unknown bus type: %d\n",
                     asc_bus[bus]);
@@ -5386,7 +5305,7 @@ advansys_detect(struct scsi_host_template *tpnt)
             if (iop == 0)
 		break;
 
-	    advansys_board_found(tpnt, iop, pci_devp, asc_bus[bus]);
+	    advansys_board_found(tpnt, iop, NULL, asc_bus[bus]);
         }
     }
 
@@ -5855,8 +5774,6 @@ static struct scsi_host_template driver_template = {
     .proc_info                  = advansys_proc_info,
 #endif
     .name                       = "advansys",
-    .detect                     = advansys_detect, 
-    .release                    = advansys_release,
     .info                       = advansys_info,
     .queuecommand               = advansys_queuecommand,
     .eh_bus_reset_handler	= advansys_reset,
@@ -5877,8 +5794,6 @@ static struct scsi_host_template driver_template = {
      */
     .use_clustering             = ENABLE_CLUSTERING,
 };
-#include "scsi_module.c"
-
 
 /*
  * --- Miscellaneous Driver Functions
@@ -5911,6 +5826,8 @@ advansys_interrupt(int irq, void *dev_id)
      */
     for (i = 0; i < asc_board_count; i++) {
 	shp = asc_host[i];
+	if (!shp)
+	    continue;
         boardp = ASC_BOARDP(shp);
         ASC_DBG2(2, "advansys_interrupt: i %d, boardp 0x%lx\n",
             i, (ulong) boardp);
@@ -18113,7 +18030,6 @@ AdvInquiryHandling(
 }
 MODULE_LICENSE("Dual BSD/GPL");
 
-#ifdef CONFIG_PCI
 /* PCI Devices supported by this driver */
 static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_1200A,
@@ -18131,4 +18047,68 @@ static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, advansys_pci_tbl);
-#endif /* CONFIG_PCI */
+
+static int __devinit advansys_pci_probe(struct pci_dev *pdev,
+					const struct pci_device_id *ent)
+{
+	int err, ioport;
+
+	ioport = pci_resource_start(pdev, 0);
+	err = advansys_board_found(&driver_template, ioport, pdev, ASC_IS_PCI);
+
+	return err;
+}
+
+static void advansys_pci_remove(struct pci_dev *pdev)
+{
+	int i;
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	scsi_remove_host(host);
+	advansys_release(host);
+
+	for (i = 0; i < asc_board_count; i++) {
+		if (asc_host[i] == host) {
+			asc_host[i] = NULL;
+			break;
+		}
+	}
+}
+
+static void advansys_remove(void)
+{
+	int i;
+
+	for (i = 0; i < asc_board_count; i++) {
+		struct Scsi_Host *host = asc_host[i];
+		if (!host)
+			continue;
+		scsi_remove_host(host);
+		advansys_release(host);
+		asc_host[i] = NULL;
+	}
+}
+
+static struct pci_driver advansys_pci_driver = {
+	.name = "advansys",
+	.id_table = advansys_pci_tbl,
+	.probe = advansys_pci_probe,
+	.remove = __devexit_p(advansys_pci_remove),
+};
+
+static int __init advansys_init(void)
+{
+	int error;
+	error = pci_register_driver(&advansys_pci_driver);
+	if (!error)
+		advansys_detect(&driver_template);
+	return error;
+}
+
+static void __exit advansys_exit(void)
+{
+	pci_unregister_driver(&advansys_pci_driver);
+	advansys_remove();
+}
+
+module_init(advansys_init);
+module_exit(advansys_exit);
-- 
1.4.4.4

