From: John Adams <johna@onevista.com>
Subject: Patch for drivers/scsi/advansus.c Linux 2.6.5
Date: Sat, 10 Apr 2004 12:51:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404101751.NAA16499@onevista.com>
Reply-To: johna@onevista.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from onevista.com ([66.93.49.232]:15242 "EHLO onevista.com")
	by vger.kernel.org with ESMTP id S262088AbUDJRvo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2004 13:51:44 -0400
Received: from 204.89.250.5 (localhost [127.0.0.1]) by onevista.com (8.9.3/10.25.03) with SMTP id NAA16499 for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2004 13:51:38 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I had trouble getting my 2.6.5.kernel to load the advansys module.
I have an ISA card.  Here's a patch to allow it to be recognized.
johna

--- drivers/scsi/advansys.c	Sat Apr  3 22:36:54 2004
+++ /tmp/advansys.c	Sat Apr 10 13:42:40 2004
@@ -1576,7 +1576,9 @@
     uchar               sdtr_period_offset[ASC_MAX_TID + 1];
     ushort              pci_slot_info;
     uchar               adapter_info[6];
+#ifdef CONFIG_PCI
     struct pci_dev	*pci_dev;
+#endif
 } ASC_DVC_CFG;
 
 #define ASC_DEF_DVC_CNTL       0xFFFF
@@ -4201,6 +4203,7 @@
 /* Declaration for Asc Library internal data referenced by driver. */
 STATIC PortAddr     _asc_def_iop_base[];
 
+int have_isa_board = 0;
 
 /*
  * --- Driver Function Prototypes
@@ -4585,6 +4588,7 @@
 
     for (bus = 0; bus < ASC_NUM_BUS; bus++) {
 
+	have_isa_board = 0;
         ASC_DBG2(1, "advansys_detect: bus search type %d (%s)\n",
             bus, asc_bus_name[bus]);
         iop = 0;
@@ -4619,18 +4623,21 @@
                         ASC_DBG1(1,
                                 "advansys_detect: probing I/O port 
0x%x...\n",
                             iop);
-                        if (check_region(iop, ASC_IOADR_GAP) != 0) {
+//                      if (check_region(iop, ASC_IOADR_GAP) != 0) {
+                        if (!request_region(iop, ASC_IOADR_GAP, 
"advansys")) {
                             printk(
 "AdvanSys SCSI: specified I/O Port 0x%X is busy\n", iop);
                             /* Don't try this I/O port twice. */
                             asc_ioport[ioport] = 0;
                             goto ioport_try_again;
-                        } else if (AscFindSignature(iop) == ASC_FALSE) {
-                            printk(
+			}
+			release_region(iop, ASC_IOADR_GAP);
+			if (AscFindSignature(iop) == ASC_FALSE) {
+                              printk(
 "AdvanSys SCSI: specified I/O Port 0x%X has no adapter\n", iop);
-                            /* Don't try this I/O port twice. */
-                            asc_ioport[ioport] = 0;
-                            goto ioport_try_again;
+                                /* Don't try this I/O port twice. */
+                                asc_ioport[ioport] = 0;
+                                goto ioport_try_again;
                         } else {
                             /*
                              * If this isn't an ISA board, then it must be
@@ -4658,6 +4665,7 @@
                         asc_ioport[ioport++] = 0;
                     }
                 }
+		have_isa_board = 1;
 #endif /* CONFIG_ISA */
                 break;
 
@@ -4764,8 +4772,13 @@
             if (shp == NULL) {
                 continue;
             }
-
-	    scsi_set_device(shp, &pci_devp->dev);
+#ifdef CONFIG_PCI
+	if (!have_isa_board && pci_devp)			// johna
+	    scsi_set_device(shp, &pci_devp->dev);		// johna
+	else							// johna
+#else
+	    scsi_set_device(shp, NULL);				// johna
+#endif
 
             /* Save a pointer to the Scsi_Host of each board found. */
             asc_host[asc_board_count++] = shp;
@@ -9149,7 +9162,7 @@
 #ifdef CONFIG_PCI
     pci_write_config_byte(asc_dvc->cfg->pci_dev, offset, byte_data);
 #else /* CONFIG_PCI */
-    return 0;
+    return;
 #endif /* CONFIG_PCI */
 }
 
@@ -9425,8 +9438,8 @@
 
 #if ASC_LINUX_KERNEL24
     printk(
-" internal_timeout %u, flags %u\n",
-        s->internal_timeout, s->flags);
+" internal_timeout %u, state %u\n",
+        s->internal_timeout, s->state);
 #elif ASC_LINUX_KERNEL22
     printk(
 " internal_timeout %u, flags %u, this_count %d\n",
@@ -9504,10 +9517,14 @@
 " chip_scsi_id %d, isa_dma_speed %d, isa_dma_channel %d, chip_version 
%d,\n",
              h->chip_scsi_id, h->isa_dma_speed, h->isa_dma_channel,
              h->chip_version);
-
     printk(
 " pci_device_id %d, lib_serial_no %u, lib_version %u, mcode_date 0x%x,\n",
-          h->pci_dev->device, h->lib_serial_no, h->lib_version, 
h->mcode_date);
+#ifdef CONFIG_PCI
+          ((have_isa_board) ? 0 : h->pci_dev->device), 
+			h->lib_serial_no, h->lib_version, h->mcode_date);
+#else
+          0, h->lib_serial_no, h->lib_version, h->mcode_date);
+#endif
 
     printk(
 " mcode_version %d, overrun_buf 0x%lx\n",
@@ -9632,7 +9649,12 @@
 
     printk(
 "  mcode_version 0x%x, pci_device_id 0x%x, lib_version %u\n",
-       h->mcode_version, h->pci_dev->device, h->lib_version);
+#ifdef CONFIG_PCI
+       h->mcode_version, ((have_isa_board) ? 0 : h->pci_dev->device), 
+							h->lib_version);
+#else
+       h->mcode_version, 0, h->lib_version);
+#endif
 
     printk(
 "  control_flag 0x%x, pci_slot_info 0x%x\n",
@@ -10003,12 +10025,14 @@
     }
     for (; i < ASC_IOADR_TABLE_MAX_IX; i++) {
         iop_base = _asc_def_iop_base[i];
-        if (check_region(iop_base, ASC_IOADR_GAP) != 0) {
+//      if (check_region(iop_base, ASC_IOADR_GAP) != 0) {
+        if (!request_region(iop_base, ASC_IOADR_GAP, "advansys")) {
             ASC_DBG1(1,
-               "AscSearchIOPortAddr11: check_region() failed I/O port 
0x%x\n",
+               "AscSearchIOPortAddr11: request_region() failed I/O port 
0x%x\n",
                      iop_base);
             continue;
         }
+	release_region(iop_base, ASC_IOADR_GAP);
         ASC_DBG1(1, "AscSearchIOPortAddr11: probing I/O port 0x%x\n", 
iop_base);
         if (AscFindSignature(iop_base)) {
             return (iop_base);
@@ -12301,7 +12325,14 @@
     ushort              pci_device_id;
 
     iop_base = asc_dvc->iop_base;
-    pci_device_id = asc_dvc->cfg->pci_dev->device;
+#ifdef CONFIG_PCI
+    if (have_isa_board)
+	pci_device_id = 0;
+    else
+	pci_device_id = asc_dvc->cfg->pci_dev->device;
+#else
+    pci_device_id = 0;
+#endif
     warn_code = 0;
     cfg_msw = AscGetChipCfgMsw(iop_base);
     if ((cfg_msw & ASC_CFG_MSW_CLR_MASK) != 0) {
