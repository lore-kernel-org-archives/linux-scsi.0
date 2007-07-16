From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 1/4] advansys: Create advansys_board_found()
Date: Mon, 16 Jul 2007 16:41:49 -0600
Message-ID: <1184625712490-git-send-email-matthew@wil.cx>
References: <20070716202815.GQ13826@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:35523 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762168AbXGPX1h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2007 19:27:37 -0400
In-Reply-To: <20070716202815.GQ13826@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Split advansys_board_found() out of advansys_detect() in preparation
for updating the driver to modern probing methods.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  577 +++++++++++++++++++++++------------------------
 1 files changed, 285 insertions(+), 292 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 2b66897..2b6cf30 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -771,6 +771,7 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
+#include <linux/pci.h>
 #include <linux/stat.h>
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
@@ -798,10 +799,6 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
-#ifdef CONFIG_PCI
-#include <linux/pci.h>
-#endif /* CONFIG_PCI */
-
 
 /*
  * --- Driver Options
@@ -4274,268 +4271,29 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 }
 #endif /* CONFIG_PROC_FS */
 
-/*
- * advansys_detect()
- *
- * Detect function for AdvanSys adapters.
- *
- * Argument is a pointer to the host driver's scsi_hosts entry.
- *
- * Return number of adapters found.
- *
- * Note: Because this function is called during system initialization
- * it must not call SCSI mid-level functions including scsi_malloc()
- * and scsi_free().
- */
-static int __init
-advansys_detect(struct scsi_host_template *tpnt)
+static int advansys_board_found(struct scsi_host_template *tpnt, int iop,
+				struct pci_dev *pdev, int bus_type)
 {
-    static int          detect_called = ASC_FALSE;
-    int                 iop;
-    int                 bus;
     struct Scsi_Host    *shp = NULL;
     asc_board_t         *boardp = NULL;
     ASC_DVC_VAR         *asc_dvc_varp = NULL;
     ADV_DVC_VAR         *adv_dvc_varp = NULL;
     adv_sgblk_t         *sgp = NULL;
-    int                 ioport = 0;
     int                 share_irq = FALSE;
     int                 iolen = 0;
-    struct device	*dev = NULL;
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
     ADV_PADDR           pci_memory_address;
-#endif /* CONFIG_PCI */
     int                 warn_code, err_code;
     int                 ret;
 
-    if (detect_called == ASC_FALSE) {
-        detect_called = ASC_TRUE;
-    } else {
-        printk("AdvanSys SCSI: advansys_detect() multiple calls ignored\n");
-        return 0;
-    }
-
-    ASC_DBG(1, "advansys_detect: begin\n");
-
-    asc_board_count = 0;
-
-    /*
-     * If I/O port probing has been modified, then verify and
-     * clean-up the 'asc_ioport' list.
-     */
-    if (asc_iopflag == ASC_TRUE) {
-        for (ioport = 0; ioport < ASC_NUM_IOPORT_PROBE; ioport++) {
-            ASC_DBG2(1, "advansys_detect: asc_ioport[%d] 0x%x\n",
-                ioport, asc_ioport[ioport]);
-            if (asc_ioport[ioport] != 0) {
-                for (iop = 0; iop < ASC_IOADR_TABLE_MAX_IX; iop++) {
-                    if (_asc_def_iop_base[iop] == asc_ioport[ioport]) {
-                        break;
-                    }
-                }
-                if (iop == ASC_IOADR_TABLE_MAX_IX) {
-                    printk(
-"AdvanSys SCSI: specified I/O Port 0x%X is invalid\n",
-                        asc_ioport[ioport]);
-                    asc_ioport[ioport] = 0;
-                }
-            }
-        }
-        ioport = 0;
-    }
-
-    for (bus = 0; bus < ASC_NUM_BUS; bus++) {
-
-        ASC_DBG2(1, "advansys_detect: bus search type %d (%s)\n",
-            bus, asc_bus_name[bus]);
-        iop = 0;
-
-        while (asc_board_count < ASC_NUM_BOARD_SUPPORTED) {
-
-            ASC_DBG1(2, "advansys_detect: asc_board_count %d\n",
-                asc_board_count);
-
-            switch (asc_bus[bus]) {
-            case ASC_IS_ISA:
-            case ASC_IS_VL:
-#ifdef CONFIG_ISA
-                if (asc_iopflag == ASC_FALSE) {
-                    iop = AscSearchIOPortAddr(iop, asc_bus[bus]);
-                } else {
-                    /*
-                     * ISA and VL I/O port scanning has either been
-                     * eliminated or limited to selected ports on
-                     * the LILO command line, /etc/lilo.conf, or
-                     * by setting variables when the module was loaded.
-                     */
-                    ASC_DBG(1, "advansys_detect: I/O port scanning modified\n");
-                ioport_try_again:
-                    iop = 0;
-                    for (; ioport < ASC_NUM_IOPORT_PROBE; ioport++) {
-                        if ((iop = asc_ioport[ioport]) != 0) {
-                            break;
-                        }
-                    }
-                    if (iop) {
-                        ASC_DBG1(1,
-                                "advansys_detect: probing I/O port 0x%x...\n",
-                            iop);
-			if (!request_region(iop, ASC_IOADR_GAP, "advansys")){
-                            printk(
-"AdvanSys SCSI: specified I/O Port 0x%X is busy\n", iop);
-                            /* Don't try this I/O port twice. */
-                            asc_ioport[ioport] = 0;
-                            goto ioport_try_again;
-                        } else if (AscFindSignature(iop) == ASC_FALSE) {
-                            printk(
-"AdvanSys SCSI: specified I/O Port 0x%X has no adapter\n", iop);
-                            /* Don't try this I/O port twice. */
-			    release_region(iop, ASC_IOADR_GAP);
-                            asc_ioport[ioport] = 0;
-                            goto ioport_try_again;
-                        } else {
-                            /*
-                             * If this isn't an ISA board, then it must be
-                             * a VL board. If currently looking an ISA
-                             * board is being looked for then try for
-                             * another ISA board in 'asc_ioport'.
-                             */
-                            if (asc_bus[bus] == ASC_IS_ISA &&
-                                (AscGetChipVersion(iop, ASC_IS_ISA) &
-                                 ASC_CHIP_VER_ISA_BIT) == 0) {
-                                 /*
-                                  * Don't clear 'asc_ioport[ioport]'. Try
-                                  * this board again for VL. Increment
-                                  * 'ioport' past this board.
-                                  */
-                                 ioport++;
-				 release_region(iop, ASC_IOADR_GAP);
-                                 goto ioport_try_again;
-                            }
-                        }
-                        /*
-                         * This board appears good, don't try the I/O port
-                         * again by clearing its value. Increment 'ioport'
-                         * for the next iteration.
-                         */
-                        asc_ioport[ioport++] = 0;
-                    }
-                }
-#endif /* CONFIG_ISA */
-                break;
-
-            case ASC_IS_EISA:
-#ifdef CONFIG_ISA
-                iop = AscSearchIOPortAddr(iop, asc_bus[bus]);
-#endif /* CONFIG_ISA */
-                break;
-
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
-		if(pci_devp)
-		    dev = &pci_devp->dev;
-
-#endif /* CONFIG_PCI */
-                break;
-
-            default:
-                ASC_PRINT1("advansys_detect: unknown bus type: %d\n",
-                    asc_bus[bus]);
-                break;
-            }
-            ASC_DBG1(1, "advansys_detect: iop 0x%x\n", iop);
-
             /*
-             * Adapter not found, try next bus type.
-             */
-            if (iop == 0) {
-                break;
-            }
-
-            /*
-             * Adapter found.
-             *
              * Register the adapter, get its configuration, and
              * initialize it.
              */
-            ASC_DBG(2, "advansys_detect: scsi_register()\n");
-            shp = scsi_register(tpnt, sizeof(asc_board_t));
+            ASC_DBG(2, "advansys_board_found: scsi_register()\n");
 
-            if (shp == NULL) {
-                continue;
-            }
+            shp = scsi_register(tpnt, sizeof(asc_board_t));
+            if (!shp)
+		return -ENOMEM;
 
             /* Save a pointer to the Scsi_Host of each board found. */
             asc_host[asc_board_count++] = shp;
@@ -4544,8 +4302,6 @@ advansys_detect(struct scsi_host_template *tpnt)
             boardp = ASC_BOARDP(shp);
             memset(boardp, 0, sizeof(asc_board_t));
             boardp->id = asc_board_count - 1;
-
-            /* Initialize spinlock. */
             spin_lock_init(&boardp->lock);
 
             /*
@@ -4556,19 +4312,18 @@ advansys_detect(struct scsi_host_template *tpnt)
              * the board type.
              */
 #ifdef CONFIG_PCI
-            if (asc_bus[bus] == ASC_IS_PCI &&
-                (pci_devp->device == PCI_DEVICE_ID_ASP_ABP940UW ||
-                 pci_devp->device == PCI_DEVICE_ID_38C0800_REV1 ||
-                 pci_devp->device == PCI_DEVICE_ID_38C1600_REV1))
-            {
-                boardp->flags |= ASC_IS_WIDE_BOARD;
-            }
+	if (bus_type == ASC_IS_PCI &&
+	    (pdev->device == PCI_DEVICE_ID_ASP_ABP940UW ||
+	     pdev->device == PCI_DEVICE_ID_38C0800_REV1 ||
+	     pdev->device == PCI_DEVICE_ID_38C1600_REV1)) {
+		boardp->flags |= ASC_IS_WIDE_BOARD;
+	}
 #endif /* CONFIG_PCI */
 
             if (ASC_NARROW_BOARD(boardp)) {
                 ASC_DBG(1, "advansys_detect: narrow board\n");
                 asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
-                asc_dvc_varp->bus_type = asc_bus[bus];
+                asc_dvc_varp->bus_type = bus_type;
                 asc_dvc_varp->drv_ptr = boardp;
                 asc_dvc_varp->cfg = &boardp->dvc_cfg.asc_dvc_cfg;
                 asc_dvc_varp->cfg->overrun_buf = &overrun_buf[0];
@@ -4582,19 +4337,16 @@ advansys_detect(struct scsi_host_template *tpnt)
                 adv_dvc_varp->isr_callback = adv_isr_callback;
                 adv_dvc_varp->async_callback = adv_async_callback;
 #ifdef CONFIG_PCI
-                if (pci_devp->device == PCI_DEVICE_ID_ASP_ABP940UW)
-                {
-                    ASC_DBG(1, "advansys_detect: ASC-3550\n");
-                    adv_dvc_varp->chip_type = ADV_CHIP_ASC3550;
-                } else if (pci_devp->device == PCI_DEVICE_ID_38C0800_REV1)
-                {
-                    ASC_DBG(1, "advansys_detect: ASC-38C0800\n");
-                    adv_dvc_varp->chip_type = ADV_CHIP_ASC38C0800;
-                } else
-                {
-                    ASC_DBG(1, "advansys_detect: ASC-38C1600\n");
-                    adv_dvc_varp->chip_type = ADV_CHIP_ASC38C1600;
-                }
+		if (pdev->device == PCI_DEVICE_ID_ASP_ABP940UW) {
+			ASC_DBG(1, "advansys_detect: ASC-3550\n");
+			adv_dvc_varp->chip_type = ADV_CHIP_ASC3550;
+                } else if (pdev->device == PCI_DEVICE_ID_38C0800_REV1) {
+			ASC_DBG(1, "advansys_detect: ASC-38C0800\n");
+			adv_dvc_varp->chip_type = ADV_CHIP_ASC38C0800;
+		} else {
+			ASC_DBG(1, "advansys_detect: ASC-38C1600\n");
+			adv_dvc_varp->chip_type = ADV_CHIP_ASC38C1600;
+		}
 #endif /* CONFIG_PCI */
 
                 /*
@@ -4619,7 +4371,7 @@ advansys_detect(struct scsi_host_template *tpnt)
                     iolen = ADV_38C1600_IOLEN;
                 }
 #ifdef CONFIG_PCI
-                pci_memory_address = pci_resource_start(pci_devp, 1);
+                pci_memory_address = pci_resource_start(pdev, 1);
                 ASC_DBG1(1, "advansys_detect: pci_memory_address: 0x%lx\n",
                     (ulong) pci_memory_address);
                 if ((boardp->ioremap_addr =
@@ -4630,7 +4382,7 @@ advansys_detect(struct scsi_host_template *tpnt)
                        boardp->id, pci_memory_address, iolen);
                    scsi_unregister(shp);
                    asc_board_count--;
-                   continue;
+                   return -ENOMEM;
                 }
                 ASC_DBG1(1, "advansys_detect: ioremap_addr: 0x%lx\n",
                     (ulong) boardp->ioremap_addr);
@@ -4665,12 +4417,12 @@ advansys_detect(struct scsi_host_template *tpnt)
                     boardp->id, ASC_PRTBUF_SIZE, GFP_ATOMIC);
                 scsi_unregister(shp);
                 asc_board_count--;
-                continue;
+                return -ENOMEM;
             }
 #endif /* CONFIG_PROC_FS */
 
             if (ASC_NARROW_BOARD(boardp)) {
-		asc_dvc_varp->cfg->dev = dev;
+		asc_dvc_varp->cfg->dev = NULL;
 		/*
                  * Set the board bus type and PCI IRQ before
                  * calling AscInitGetConfig().
@@ -4692,11 +4444,12 @@ advansys_detect(struct scsi_host_template *tpnt)
 #endif /* CONFIG_ISA */
 #ifdef CONFIG_PCI
                 case ASC_IS_PCI:
-                    shp->irq = asc_dvc_varp->irq_no = pci_devp->irq;
+                    shp->irq = asc_dvc_varp->irq_no = pdev->irq;
+        	    asc_dvc_varp->cfg->dev = &pdev->dev;
                     asc_dvc_varp->cfg->pci_slot_info =
-                        ASC_PCI_MKID(pci_devp->bus->number,
-                            PCI_SLOT(pci_devp->devfn),
-                            PCI_FUNC(pci_devp->devfn));
+                        ASC_PCI_MKID(pdev->bus->number,
+                            PCI_SLOT(pdev->devfn),
+                            PCI_FUNC(pdev->devfn));
                     shp->unchecked_isa_dma = FALSE;
                     share_irq = TRUE;
                     break;
@@ -4710,17 +4463,17 @@ advansys_detect(struct scsi_host_template *tpnt)
                     break;
                 }
             } else {
-                adv_dvc_varp->cfg->dev = dev;
                 /*
                  * For Wide boards set PCI information before calling
                  * AdvInitGetConfig().
                  */
 #ifdef CONFIG_PCI
-                shp->irq = adv_dvc_varp->irq_no = pci_devp->irq;
+                shp->irq = adv_dvc_varp->irq_no = pdev->irq;
+                adv_dvc_varp->cfg->dev = &pdev->dev;
                 adv_dvc_varp->cfg->pci_slot_info =
-                    ASC_PCI_MKID(pci_devp->bus->number,
-                        PCI_SLOT(pci_devp->devfn),
-                        PCI_FUNC(pci_devp->devfn));
+                    ASC_PCI_MKID(pdev->bus->number,
+                        PCI_SLOT(pdev->devfn),
+                        PCI_FUNC(pdev->devfn));
                 shp->unchecked_isa_dma = FALSE;
                 share_irq = TRUE;
 #endif /* CONFIG_PCI */
@@ -4796,7 +4549,7 @@ advansys_detect(struct scsi_host_template *tpnt)
 #endif /* CONFIG_PROC_FS */
                 scsi_unregister(shp);
                 asc_board_count--;
-                continue;
+                return err_code;
             }
 
             /*
@@ -4884,7 +4637,7 @@ advansys_detect(struct scsi_host_template *tpnt)
 #endif /* CONFIG_PROC_FS */
                     scsi_unregister(shp);
                     asc_board_count--;
-                    continue;
+                    return asc_dvc_varp->err_code;
                 }
 
                 /*
@@ -5153,7 +4906,7 @@ advansys_detect(struct scsi_host_template *tpnt)
 #endif /* CONFIG_PROC_FS */
                 scsi_unregister(shp);
                 asc_board_count--;
-                continue;
+                return -EBUSY;
             }
 
             /* Register DMA Channel for Narrow boards. */
@@ -5174,7 +4927,7 @@ advansys_detect(struct scsi_host_template *tpnt)
 #endif /* CONFIG_PROC_FS */
                         scsi_unregister(shp);
                         asc_board_count--;
-                        continue;
+                        return ret;
                     }
                     AscEnableIsaDma(shp->dma_channel);
                 }
@@ -5222,7 +4975,7 @@ advansys_detect(struct scsi_host_template *tpnt)
 #endif /* CONFIG_PROC_FS */
                 scsi_unregister(shp);
                 asc_board_count--;
-                continue;
+                return ret;
             }
 
             /*
@@ -5404,9 +5157,249 @@ advansys_detect(struct scsi_host_template *tpnt)
                 free_irq(shp->irq, boardp);
                 scsi_unregister(shp);
                 asc_board_count--;
-                continue;
+                return err_code;
+	}
+	ASC_DBG_PRT_SCSI_HOST(2, shp);
+
+	return 0;
+}
+
+/*
+ * advansys_detect()
+ *
+ * Detect function for AdvanSys adapters.
+ *
+ * Argument is a pointer to the host driver's scsi_hosts entry.
+ *
+ * Return number of adapters found.
+ *
+ * Note: Because this function is called during system initialization
+ * it must not call SCSI mid-level functions including scsi_malloc()
+ * and scsi_free().
+ */
+static int __init
+advansys_detect(struct scsi_host_template *tpnt)
+{
+    static int          detect_called = ASC_FALSE;
+    int                 iop;
+    int                 bus;
+    int                 ioport = 0;
+#ifdef CONFIG_PCI
+    int                 pci_init_search = 0;
+    struct pci_dev      *pci_devicep[ASC_NUM_BOARD_SUPPORTED];
+    int                 pci_card_cnt_max = 0;
+    int                 pci_card_cnt = 0;
+    struct pci_dev      *pci_devp = NULL;
+    int                 pci_device_id_cnt = 0;
+    unsigned int        pci_device_id[ASC_PCI_DEVICE_ID_CNT] = {
+                                    PCI_DEVICE_ID_ASP_1200A,
+                                    PCI_DEVICE_ID_ASP_ABP940,
+                                    PCI_DEVICE_ID_ASP_ABP940U,
+                                    PCI_DEVICE_ID_ASP_ABP940UW,
+                                    PCI_DEVICE_ID_38C0800_REV1,
+                                    PCI_DEVICE_ID_38C1600_REV1
+                        };
+#else
+#define pci_devp NULL
+#endif /* CONFIG_PCI */
+
+    if (detect_called == ASC_FALSE) {
+        detect_called = ASC_TRUE;
+    } else {
+        printk("AdvanSys SCSI: advansys_detect() multiple calls ignored\n");
+        return 0;
+    }
+
+    ASC_DBG(1, "advansys_detect: begin\n");
+
+    asc_board_count = 0;
+
+    /*
+     * If I/O port probing has been modified, then verify and
+     * clean-up the 'asc_ioport' list.
+     */
+    if (asc_iopflag == ASC_TRUE) {
+        for (ioport = 0; ioport < ASC_NUM_IOPORT_PROBE; ioport++) {
+            ASC_DBG2(1, "advansys_detect: asc_ioport[%d] 0x%x\n",
+                ioport, asc_ioport[ioport]);
+            if (asc_ioport[ioport] != 0) {
+                for (iop = 0; iop < ASC_IOADR_TABLE_MAX_IX; iop++) {
+                    if (_asc_def_iop_base[iop] == asc_ioport[ioport]) {
+                        break;
+                    }
+                }
+                if (iop == ASC_IOADR_TABLE_MAX_IX) {
+                    printk(
+"AdvanSys SCSI: specified I/O Port 0x%X is invalid\n",
+                        asc_ioport[ioport]);
+                    asc_ioport[ioport] = 0;
+                }
+            }
+        }
+        ioport = 0;
+    }
+
+    for (bus = 0; bus < ASC_NUM_BUS; bus++) {
+
+        ASC_DBG2(1, "advansys_detect: bus search type %d (%s)\n",
+            bus, asc_bus_name[bus]);
+        iop = 0;
+
+        while (asc_board_count < ASC_NUM_BOARD_SUPPORTED) {
+
+            ASC_DBG1(2, "advansys_detect: asc_board_count %d\n",
+                asc_board_count);
+
+            switch (asc_bus[bus]) {
+            case ASC_IS_ISA:
+            case ASC_IS_VL:
+#ifdef CONFIG_ISA
+                if (asc_iopflag == ASC_FALSE) {
+                    iop = AscSearchIOPortAddr(iop, asc_bus[bus]);
+                } else {
+                    /*
+                     * ISA and VL I/O port scanning has either been
+                     * eliminated or limited to selected ports on
+                     * the LILO command line, /etc/lilo.conf, or
+                     * by setting variables when the module was loaded.
+                     */
+                    ASC_DBG(1, "advansys_detect: I/O port scanning modified\n");
+                ioport_try_again:
+                    iop = 0;
+                    for (; ioport < ASC_NUM_IOPORT_PROBE; ioport++) {
+                        if ((iop = asc_ioport[ioport]) != 0) {
+                            break;
+                        }
+                    }
+                    if (iop) {
+                        ASC_DBG1(1,
+                                "advansys_detect: probing I/O port 0x%x...\n",
+                            iop);
+			if (!request_region(iop, ASC_IOADR_GAP, "advansys")){
+                            printk(
+"AdvanSys SCSI: specified I/O Port 0x%X is busy\n", iop);
+                            /* Don't try this I/O port twice. */
+                            asc_ioport[ioport] = 0;
+                            goto ioport_try_again;
+                        } else if (AscFindSignature(iop) == ASC_FALSE) {
+                            printk(
+"AdvanSys SCSI: specified I/O Port 0x%X has no adapter\n", iop);
+                            /* Don't try this I/O port twice. */
+			    release_region(iop, ASC_IOADR_GAP);
+                            asc_ioport[ioport] = 0;
+                            goto ioport_try_again;
+                        } else {
+                            /*
+                             * If this isn't an ISA board, then it must be
+                             * a VL board. If currently looking an ISA
+                             * board is being looked for then try for
+                             * another ISA board in 'asc_ioport'.
+                             */
+                            if (asc_bus[bus] == ASC_IS_ISA &&
+                                (AscGetChipVersion(iop, ASC_IS_ISA) &
+                                 ASC_CHIP_VER_ISA_BIT) == 0) {
+                                 /*
+                                  * Don't clear 'asc_ioport[ioport]'. Try
+                                  * this board again for VL. Increment
+                                  * 'ioport' past this board.
+                                  */
+                                 ioport++;
+				 release_region(iop, ASC_IOADR_GAP);
+                                 goto ioport_try_again;
+                            }
+                        }
+                        /*
+                         * This board appears good, don't try the I/O port
+                         * again by clearing its value. Increment 'ioport'
+                         * for the next iteration.
+                         */
+                        asc_ioport[ioport++] = 0;
+                    }
+                }
+#endif /* CONFIG_ISA */
+                break;
+
+            case ASC_IS_EISA:
+#ifdef CONFIG_ISA
+                iop = AscSearchIOPortAddr(iop, asc_bus[bus]);
+#endif /* CONFIG_ISA */
+                break;
+
+            case ASC_IS_PCI:
+#ifdef CONFIG_PCI
+                if (pci_init_search == 0) {
+                    int i, j;
+
+                    pci_init_search = 1;
+
+                    /* Find all PCI cards. */
+                    while (pci_device_id_cnt < ASC_PCI_DEVICE_ID_CNT) {
+                        if ((pci_devp = pci_find_device(PCI_VENDOR_ID_ASP,
+                            pci_device_id[pci_device_id_cnt], pci_devp)) ==
+                            NULL) {
+                            pci_device_id_cnt++;
+                        } else {
+                            if (pci_enable_device(pci_devp) == 0) {
+                                pci_devicep[pci_card_cnt_max++] = pci_devp;
+                            }
+                        }
+                    }
+
+                    /*
+                     * Sort PCI cards in ascending order by PCI Bus, Slot,
+                     * and Device Number.
+                     */
+                    for (i = 0; i < pci_card_cnt_max - 1; i++)
+                    {
+                        for (j = i + 1; j < pci_card_cnt_max; j++) {
+                            if ((pci_devicep[j]->bus->number <
+                                 pci_devicep[i]->bus->number) ||
+                                ((pci_devicep[j]->bus->number ==
+                                  pci_devicep[i]->bus->number) &&
+                                  (pci_devicep[j]->devfn <
+                                   pci_devicep[i]->devfn))) {
+                                pci_devp = pci_devicep[i];
+                                pci_devicep[i] = pci_devicep[j];
+                                pci_devicep[j] = pci_devp;
+                            }
+                        }
+                    }
+
+                    pci_card_cnt = 0;
+                } else {
+                    pci_card_cnt++;
+                }
+
+                if (pci_card_cnt == pci_card_cnt_max) {
+                    iop = 0;
+                } else {
+                    pci_devp = pci_devicep[pci_card_cnt];
+
+                    ASC_DBG2(2,
+                        "advansys_detect: devfn %d, bus number %d\n",
+                        pci_devp->devfn, pci_devp->bus->number);
+                    iop = pci_resource_start(pci_devp, 0);
+                    ASC_DBG2(1,
+                        "advansys_detect: vendorID %X, deviceID %X\n",
+                        pci_devp->vendor, pci_devp->device);
+                    ASC_DBG2(2, "advansys_detect: iop %X, irqLine %d\n",
+                        iop, pci_devp->irq);
+                }
+
+#endif /* CONFIG_PCI */
+                break;
+
+            default:
+                ASC_PRINT1("advansys_detect: unknown bus type: %d\n",
+                    asc_bus[bus]);
+                break;
             }
-            ASC_DBG_PRT_SCSI_HOST(2, shp);
+            ASC_DBG1(1, "advansys_detect: iop 0x%x\n", iop);
+
+            if (iop == 0)
+		break;
+
+	    advansys_board_found(tpnt, iop, pci_devp, asc_bus[bus]);
         }
     }
 
-- 
1.4.4.4

