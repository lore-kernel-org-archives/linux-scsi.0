From: Joe Perches <joe@perches.com>
Subject: [PATCH 3/3] BusLogic: Use more conventional argument order for logging
Date: Thu, 16 May 2013 21:58:32 -0700
Message-ID: <5fdcd2200869713c58b52d550281da9aa9195efb.1368765873.git.joe@perches.com>
References: <cover.1368754556.git.khalid.aziz@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1368754556.git.khalid.aziz@oracle.com>
In-Reply-To: <cover.1368765873.git.joe@perches.com>
References: <cover.1368765873.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Subsystem specific logging messages generally use
	subsystem_<level>(struct subsystem *, fmt, ...)
not
	subsystem_<level>(fmt, struct subsystem *, ...)

Convert to use the more generally used kernel style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/BusLogic.c | 304 ++++++++++++++++++++++++------------------------
 drivers/scsi/BusLogic.h |  24 ++--
 2 files changed, 161 insertions(+), 167 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index bd588cf..d5a5d97 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -140,8 +140,8 @@ static char *blogic_cmd_failure_reason;
 
 static void blogic_announce_drvr(struct blogic_adapter *adapter)
 {
-	blogic_announce("***** BusLogic SCSI Driver Version " blogic_drvr_version " of " blogic_drvr_date " *****\n", adapter);
-	blogic_announce("Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>\n", adapter);
+	blogic_announce(adapter, "***** BusLogic SCSI Driver Version " blogic_drvr_version " of " blogic_drvr_date " *****\n");
+	blogic_announce(adapter, "Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>\n");
 }
 
 
@@ -204,8 +204,7 @@ static bool __init blogic_create_initccbs(struct blogic_adapter *adapter)
 		blk_pointer = pci_alloc_consistent(adapter->pci_device,
 							blk_size, &blkp);
 		if (blk_pointer == NULL) {
-			blogic_err("UNABLE TO ALLOCATE CCB GROUP - DETACHING\n",
-					adapter);
+			blogic_err(adapter, "UNABLE TO ALLOCATE CCB GROUP - DETACHING\n");
 			return false;
 		}
 		blogic_init_ccbs(adapter, blk_pointer, blk_size, blkp);
@@ -264,10 +263,10 @@ static void blogic_create_addlccbs(struct blogic_adapter *adapter,
 	}
 	if (adapter->alloc_ccbs > prev_alloc) {
 		if (print_success)
-			blogic_notice("Allocated %d additional CCBs (total now %d)\n", adapter, adapter->alloc_ccbs - prev_alloc, adapter->alloc_ccbs);
+			blogic_notice(adapter, "Allocated %d additional CCBs (total now %d)\n", adapter->alloc_ccbs - prev_alloc, adapter->alloc_ccbs);
 		return;
 	}
-	blogic_notice("Failed to allocate additional CCBs\n", adapter);
+	blogic_notice(adapter, "Failed to allocate additional CCBs\n");
 	if (adapter->drvr_qdepth > adapter->alloc_ccbs - adapter->tgt_count) {
 		adapter->drvr_qdepth = adapter->alloc_ccbs - adapter->tgt_count;
 		adapter->scsi_host->can_queue = adapter->drvr_qdepth;
@@ -444,7 +443,7 @@ static int blogic_cmd(struct blogic_adapter *adapter, enum blogic_opcode opcode,
 			goto done;
 		}
 		if (blogic_global_options.trace_config)
-			blogic_notice("blogic_cmd(%02X) Status = %02X: (Modify I/O Address)\n", adapter, opcode, statusreg.all);
+			blogic_notice(adapter, "blogic_cmd(%02X) Status = %02X: (Modify I/O Address)\n", opcode, statusreg.all);
 		result = 0;
 		goto done;
 	}
@@ -502,15 +501,15 @@ static int blogic_cmd(struct blogic_adapter *adapter, enum blogic_opcode opcode,
 	 */
 	if (blogic_global_options.trace_config) {
 		int i;
-		blogic_notice("blogic_cmd(%02X) Status = %02X: %2d ==> %2d:",
-				adapter, opcode, statusreg.all, replylen,
-				reply_b);
+		blogic_notice(adapter, "blogic_cmd(%02X) Status = %02X: %2d ==> %2d:",
+			      opcode, statusreg.all, replylen,
+			      reply_b);
 		if (replylen > reply_b)
 			replylen = reply_b;
 		for (i = 0; i < replylen; i++)
-			blogic_notice(" %02X", adapter,
-					((unsigned char *) reply)[i]);
-		blogic_notice("\n", adapter);
+			blogic_notice(adapter, " %02X",
+				      ((unsigned char *) reply)[i]);
+		blogic_notice(adapter, "\n");
 	}
 	/*
 	   Process Command Invalid conditions.
@@ -720,23 +719,23 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
 		pci_addr = base_addr1 = pci_resource_start(pci_device, 1);
 
 		if (pci_resource_flags(pci_device, 0) & IORESOURCE_MEM) {
-			blogic_err("BusLogic: Base Address0 0x%lX not I/O for MultiMaster Host Adapter\n", NULL, base_addr0);
-			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
+			blogic_err(NULL, "BusLogic: Base Address0 0x%lX not I/O for MultiMaster Host Adapter\n", base_addr0);
+			blogic_err(NULL, "at PCI Bus %d Device %d I/O Address 0x%lX\n", bus, device, io_addr);
 			continue;
 		}
 		if (pci_resource_flags(pci_device, 1) & IORESOURCE_IO) {
-			blogic_err("BusLogic: Base Address1 0x%lX not Memory for MultiMaster Host Adapter\n", NULL, base_addr1);
-			blogic_err("at PCI Bus %d Device %d PCI Address 0x%lX\n", NULL, bus, device, pci_addr);
+			blogic_err(NULL, "BusLogic: Base Address1 0x%lX not Memory for MultiMaster Host Adapter\n", base_addr1);
+			blogic_err(NULL, "at PCI Bus %d Device %d PCI Address 0x%lX\n", bus, device, pci_addr);
 			continue;
 		}
 		if (irq_ch == 0) {
-			blogic_err("BusLogic: IRQ Channel %d invalid for MultiMaster Host Adapter\n", NULL, irq_ch);
-			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
+			blogic_err(NULL, "BusLogic: IRQ Channel %d invalid for MultiMaster Host Adapter\n", irq_ch);
+			blogic_err(NULL, "at PCI Bus %d Device %d I/O Address 0x%lX\n", bus, device, io_addr);
 			continue;
 		}
 		if (blogic_global_options.trace_probe) {
-			blogic_notice("BusLogic: PCI MultiMaster Host Adapter detected at\n", NULL);
-			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX\n", NULL, bus, device, io_addr, pci_addr);
+			blogic_notice(NULL, "BusLogic: PCI MultiMaster Host Adapter detected at\n");
+			blogic_notice(NULL, "BusLogic: PCI Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX\n", bus, device, io_addr, pci_addr);
 		}
 		/*
 		   Issue the Inquire PCI Host Adapter Information command to determine
@@ -822,7 +821,7 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
 			nonpr_mmcount++;
 			mmcount++;
 		} else
-			blogic_warn("BusLogic: Too many Host Adapters detected\n", NULL);
+			blogic_warn(NULL, "BusLogic: Too many Host Adapters detected\n");
 	}
 	/*
 	   If the AutoSCSI "Use Bus And Device # For PCI Scanning Seq."
@@ -960,23 +959,23 @@ static int __init blogic_init_fp_probeinfo(struct blogic_adapter *adapter)
 		pci_addr = base_addr1 = pci_resource_start(pci_device, 1);
 #ifdef CONFIG_SCSI_FLASHPOINT
 		if (pci_resource_flags(pci_device, 0) & IORESOURCE_MEM) {
-			blogic_err("BusLogic: Base Address0 0x%lX not I/O for FlashPoint Host Adapter\n", NULL, base_addr0);
-			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
+			blogic_err(NULL, "BusLogic: Base Address0 0x%lX not I/O for FlashPoint Host Adapter\n", base_addr0);
+			blogic_err(NULL, "at PCI Bus %d Device %d I/O Address 0x%lX\n", bus, device, io_addr);
 			continue;
 		}
 		if (pci_resource_flags(pci_device, 1) & IORESOURCE_IO) {
-			blogic_err("BusLogic: Base Address1 0x%lX not Memory for FlashPoint Host Adapter\n", NULL, base_addr1);
-			blogic_err("at PCI Bus %d Device %d PCI Address 0x%lX\n", NULL, bus, device, pci_addr);
+			blogic_err(NULL, "BusLogic: Base Address1 0x%lX not Memory for FlashPoint Host Adapter\n", base_addr1);
+			blogic_err(NULL, "at PCI Bus %d Device %d PCI Address 0x%lX\n", bus, device, pci_addr);
 			continue;
 		}
 		if (irq_ch == 0) {
-			blogic_err("BusLogic: IRQ Channel %d invalid for FlashPoint Host Adapter\n", NULL, irq_ch);
-			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
+			blogic_err(NULL, "BusLogic: IRQ Channel %d invalid for FlashPoint Host Adapter\n", irq_ch);
+			blogic_err(NULL, "at PCI Bus %d Device %d I/O Address 0x%lX\n", bus, device, io_addr);
 			continue;
 		}
 		if (blogic_global_options.trace_probe) {
-			blogic_notice("BusLogic: FlashPoint Host Adapter detected at\n", NULL);
-			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX\n", NULL, bus, device, io_addr, pci_addr);
+			blogic_notice(NULL, "BusLogic: FlashPoint Host Adapter detected at\n");
+			blogic_notice(NULL, "BusLogic: PCI Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX\n", bus, device, io_addr, pci_addr);
 		}
 		if (blogic_probeinfo_count < BLOGIC_MAX_ADAPTERS) {
 			struct blogic_probeinfo *probeinfo =
@@ -991,11 +990,11 @@ static int __init blogic_init_fp_probeinfo(struct blogic_adapter *adapter)
 			probeinfo->pci_device = pci_dev_get(pci_device);
 			fpcount++;
 		} else
-			blogic_warn("BusLogic: Too many Host Adapters detected\n", NULL);
+			blogic_warn(NULL, "BusLogic: Too many Host Adapters detected\n");
 #else
-		blogic_err("BusLogic: FlashPoint Host Adapter detected at PCI Bus %d Device %d\n", NULL, bus, device);
-		blogic_err("BusLogic: I/O Address 0x%X PCI Address 0x%X, irq %d, but FlashPoint\n", NULL, io_addr, pci_addr, irq_ch);
-		blogic_err("BusLogic: support was omitted in this kernel configuration.\n", NULL);
+		blogic_err(NULL, "BusLogic: FlashPoint Host Adapter detected at PCI Bus %d Device %d\n", bus, device);
+		blogic_err(NULL, "BusLogic: I/O Address 0x%X PCI Address 0x%X, irq %d, but FlashPoint\n", io_addr, pci_addr, irq_ch);
+		blogic_err(NULL, "BusLogic: support was omitted in this kernel configuration.\n");
 #endif
 	}
 	/*
@@ -1101,15 +1100,14 @@ static bool blogic_failure(struct blogic_adapter *adapter, char *msg)
 {
 	blogic_announce_drvr(adapter);
 	if (adapter->adapter_bus_type == BLOGIC_PCI_BUS) {
-		blogic_err("While configuring BusLogic PCI Host Adapter at\n",
-				adapter);
-		blogic_err("Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX:\n", adapter, adapter->bus, adapter->dev, adapter->io_addr, adapter->pci_addr);
+		blogic_err(adapter, "While configuring BusLogic PCI Host Adapter at\n");
+		blogic_err(adapter, "Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX:\n", adapter->bus, adapter->dev, adapter->io_addr, adapter->pci_addr);
 	} else
-		blogic_err("While configuring BusLogic Host Adapter at I/O Address 0x%lX:\n", adapter, adapter->io_addr);
-	blogic_err("%s FAILED - DETACHING\n", adapter, msg);
+		blogic_err(adapter, "While configuring BusLogic Host Adapter at I/O Address 0x%lX:\n", adapter->io_addr);
+	blogic_err(adapter, "%s FAILED - DETACHING\n", msg);
 	if (blogic_cmd_failure_reason != NULL)
-		blogic_err("ADDITIONAL FAILURE INFO - %s\n", adapter,
-				blogic_cmd_failure_reason);
+		blogic_err(adapter, "ADDITIONAL FAILURE INFO - %s\n",
+			   blogic_cmd_failure_reason);
 	return false;
 }
 
@@ -1133,13 +1131,13 @@ static bool __init blogic_probe(struct blogic_adapter *adapter)
 		fpinfo->present = false;
 		if (!(FlashPoint_ProbeHostAdapter(fpinfo) == 0 &&
 					fpinfo->present)) {
-			blogic_err("BusLogic: FlashPoint Host Adapter detected at PCI Bus %d Device %d\n", adapter, adapter->bus, adapter->dev);
-			blogic_err("BusLogic: I/O Address 0x%lX PCI Address 0x%lX, but FlashPoint\n", adapter, adapter->io_addr, adapter->pci_addr);
-			blogic_err("BusLogic: Probe Function failed to validate it.\n", adapter);
+			blogic_err(adapter, "BusLogic: FlashPoint Host Adapter detected at PCI Bus %d Device %d\n", adapter->bus, adapter->dev);
+			blogic_err(adapter, "BusLogic: I/O Address 0x%lX PCI Address 0x%lX, but FlashPoint\n", adapter->io_addr, adapter->pci_addr);
+			blogic_err(adapter, "BusLogic: Probe Function failed to validate it.\n");
 			return false;
 		}
 		if (blogic_global_options.trace_probe)
-			blogic_notice("BusLogic_Probe(0x%lX): FlashPoint Found\n", adapter, adapter->io_addr);
+			blogic_notice(adapter, "BusLogic_Probe(0x%lX): FlashPoint Found\n", adapter->io_addr);
 		/*
 		   Indicate the Host Adapter Probe completed successfully.
 		 */
@@ -1156,7 +1154,7 @@ static bool __init blogic_probe(struct blogic_adapter *adapter)
 	intreg.all = blogic_rdint(adapter);
 	georeg.all = blogic_rdgeom(adapter);
 	if (blogic_global_options.trace_probe)
-		blogic_notice("BusLogic_Probe(0x%lX): Status 0x%02X, Interrupt 0x%02X, Geometry 0x%02X\n", adapter, adapter->io_addr, statusreg.all, intreg.all, georeg.all);
+		blogic_notice(adapter, "BusLogic_Probe(0x%lX): Status 0x%02X, Interrupt 0x%02X, Geometry 0x%02X\n", adapter->io_addr, statusreg.all, intreg.all, georeg.all);
 	if (statusreg.all == 0 || statusreg.sr.diag_active ||
 			statusreg.sr.cmd_param_busy || statusreg.sr.rsvd ||
 			statusreg.sr.cmd_invalid || intreg.ir.rsvd != 0)
@@ -1235,7 +1233,7 @@ static bool blogic_hwreset(struct blogic_adapter *adapter, bool hard_reset)
 		udelay(100);
 	}
 	if (blogic_global_options.trace_hw_reset)
-		blogic_notice("BusLogic_HardwareReset(0x%lX): Diagnostic Active, Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
+		blogic_notice(adapter, "BusLogic_HardwareReset(0x%lX): Diagnostic Active, Status 0x%02X\n", adapter->io_addr, statusreg.all);
 	if (timeout < 0)
 		return false;
 	/*
@@ -1255,7 +1253,7 @@ static bool blogic_hwreset(struct blogic_adapter *adapter, bool hard_reset)
 		udelay(100);
 	}
 	if (blogic_global_options.trace_hw_reset)
-		blogic_notice("BusLogic_HardwareReset(0x%lX): Diagnostic Completed, Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
+		blogic_notice(adapter, "BusLogic_HardwareReset(0x%lX): Diagnostic Completed, Status 0x%02X\n", adapter->io_addr, statusreg.all);
 	if (timeout < 0)
 		return false;
 	/*
@@ -1271,7 +1269,7 @@ static bool blogic_hwreset(struct blogic_adapter *adapter, bool hard_reset)
 		udelay(100);
 	}
 	if (blogic_global_options.trace_hw_reset)
-		blogic_notice("BusLogic_HardwareReset(0x%lX): Host Adapter Ready, Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
+		blogic_notice(adapter, "BusLogic_HardwareReset(0x%lX): Host Adapter Ready, Status 0x%02X\n", adapter->io_addr, statusreg.all);
 	if (timeout < 0)
 		return false;
 	/*
@@ -1283,11 +1281,11 @@ static bool blogic_hwreset(struct blogic_adapter *adapter, bool hard_reset)
 	if (statusreg.sr.diag_failed || !statusreg.sr.adapter_ready) {
 		blogic_cmd_failure_reason = NULL;
 		blogic_failure(adapter, "HARD RESET DIAGNOSTICS");
-		blogic_err("HOST ADAPTER STATUS REGISTER = %02X\n", adapter,
-				statusreg.all);
+		blogic_err(adapter, "HOST ADAPTER STATUS REGISTER = %02X\n",
+			   statusreg.all);
 		if (statusreg.sr.datain_ready)
-			blogic_err("HOST ADAPTER ERROR CODE = %d\n", adapter,
-					blogic_rddatain(adapter));
+			blogic_err(adapter, "HOST ADAPTER ERROR CODE = %d\n",
+				   blogic_rddatain(adapter));
 		return false;
 	}
 	/*
@@ -1327,9 +1325,9 @@ static bool __init blogic_checkadapter(struct blogic_adapter *adapter)
 	   Provide tracing information if requested and return.
 	 */
 	if (blogic_global_options.trace_probe)
-		blogic_notice("BusLogic_Check(0x%lX): MultiMaster %s\n", adapter,
-				adapter->io_addr,
-				(result ? "Found" : "Not Found"));
+		blogic_notice(adapter, "BusLogic_Check(0x%lX): MultiMaster %s\n",
+			      adapter->io_addr,
+			      (result ? "Found" : "Not Found"));
 	return result;
 }
 
@@ -1839,31 +1837,31 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 	char *tagq_msg = tagq_str;
 	int tgt_id;
 
-	blogic_info("Configuring BusLogic Model %s %s%s%s%s SCSI Host Adapter\n", adapter, adapter->model, blogic_adapter_busnames[adapter->adapter_bus_type], (adapter->wide ? " Wide" : ""), (adapter->differential ? " Differential" : ""), (adapter->ultra ? " Ultra" : ""));
-	blogic_info("  Firmware Version: %s, I/O Address: 0x%lX, IRQ Channel: %d/%s\n", adapter, adapter->fw_ver, adapter->io_addr, adapter->irq_ch, (adapter->level_int ? "Level" : "Edge"));
+	blogic_info(adapter, "Configuring BusLogic Model %s %s%s%s%s SCSI Host Adapter\n", adapter->model, blogic_adapter_busnames[adapter->adapter_bus_type], (adapter->wide ? " Wide" : ""), (adapter->differential ? " Differential" : ""), (adapter->ultra ? " Ultra" : ""));
+	blogic_info(adapter, "  Firmware Version: %s, I/O Address: 0x%lX, IRQ Channel: %d/%s\n", adapter->fw_ver, adapter->io_addr, adapter->irq_ch, (adapter->level_int ? "Level" : "Edge"));
 	if (adapter->adapter_bus_type != BLOGIC_PCI_BUS) {
-		blogic_info("  DMA Channel: ", adapter);
+		blogic_info(adapter, "  DMA Channel: ");
 		if (adapter->dma_ch > 0)
-			blogic_info("%d, ", adapter, adapter->dma_ch);
+			blogic_info(adapter, "%d, ", adapter->dma_ch);
 		else
-			blogic_info("None, ", adapter);
+			blogic_info(adapter, "None, ");
 		if (adapter->bios_addr > 0)
-			blogic_info("BIOS Address: 0x%X, ", adapter,
-					adapter->bios_addr);
+			blogic_info(adapter, "BIOS Address: 0x%X, ",
+				    adapter->bios_addr);
 		else
-			blogic_info("BIOS Address: None, ", adapter);
+			blogic_info(adapter, "BIOS Address: None, ");
 	} else {
-		blogic_info("  PCI Bus: %d, Device: %d, Address: ", adapter,
-				adapter->bus, adapter->dev);
+		blogic_info(adapter, "  PCI Bus: %d, Device: %d, Address: ",
+			    adapter->bus, adapter->dev);
 		if (adapter->pci_addr > 0)
-			blogic_info("0x%lX, ", adapter, adapter->pci_addr);
+			blogic_info(adapter, "0x%lX, ", adapter->pci_addr);
 		else
-			blogic_info("Unassigned, ", adapter);
+			blogic_info(adapter, "Unassigned, ");
 	}
-	blogic_info("Host Adapter SCSI ID: %d\n", adapter, adapter->scsi_id);
-	blogic_info("  Parity Checking: %s, Extended Translation: %s\n",
-			adapter, (adapter->parity ? "Enabled" : "Disabled"),
-			(adapter->ext_trans_enable ? "Enabled" : "Disabled"));
+	blogic_info(adapter, "Host Adapter SCSI ID: %d\n", adapter->scsi_id);
+	blogic_info(adapter, "  Parity Checking: %s, Extended Translation: %s\n",
+		    (adapter->parity ? "Enabled" : "Disabled"),
+		    (adapter->ext_trans_enable ? "Enabled" : "Disabled"));
 	alltgt_mask &= ~(1 << adapter->scsi_id);
 	sync_ok = adapter->sync_ok & alltgt_mask;
 	fast_ok = adapter->fast_ok & alltgt_mask;
@@ -1931,16 +1929,16 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 		tagq_str[adapter->scsi_id] = '#';
 		tagq_str[adapter->maxdev] = '\0';
 	}
-	blogic_info("  Synchronous Negotiation: %s, Wide Negotiation: %s\n",
-			adapter, syncmsg, widemsg);
-	blogic_info("  Disconnect/Reconnect: %s, Tagged Queuing: %s\n", adapter,
-			discon_msg, tagq_msg);
+	blogic_info(adapter, "  Synchronous Negotiation: %s, Wide Negotiation: %s\n",
+		    syncmsg, widemsg);
+	blogic_info(adapter, "  Disconnect/Reconnect: %s, Tagged Queuing: %s\n",
+		    discon_msg, tagq_msg);
 	if (blogic_multimaster_type(adapter)) {
-		blogic_info("  Scatter/Gather Limit: %d of %d segments, Mailboxes: %d\n", adapter, adapter->drvr_sglimit, adapter->adapter_sglimit, adapter->mbox_count);
-		blogic_info("  Driver Queue Depth: %d, Host Adapter Queue Depth: %d\n", adapter, adapter->drvr_qdepth, adapter->adapter_qdepth);
+		blogic_info(adapter, "  Scatter/Gather Limit: %d of %d segments, Mailboxes: %d\n", adapter->drvr_sglimit, adapter->adapter_sglimit, adapter->mbox_count);
+		blogic_info(adapter, "  Driver Queue Depth: %d, Host Adapter Queue Depth: %d\n", adapter->drvr_qdepth, adapter->adapter_qdepth);
 	} else
-		blogic_info("  Driver Queue Depth: %d, Scatter/Gather Limit: %d segments\n", adapter, adapter->drvr_qdepth, adapter->drvr_sglimit);
-	blogic_info("  Tagged Queue Depth: ", adapter);
+		blogic_info(adapter, "  Driver Queue Depth: %d, Scatter/Gather Limit: %d segments\n", adapter->drvr_qdepth, adapter->drvr_sglimit);
+	blogic_info(adapter, "  Tagged Queue Depth: ");
 	common_tagq_depth = true;
 	for (tgt_id = 1; tgt_id < adapter->maxdev; tgt_id++)
 		if (adapter->qdepth[tgt_id] != adapter->qdepth[0]) {
@@ -1949,24 +1947,24 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 		}
 	if (common_tagq_depth) {
 		if (adapter->qdepth[0] > 0)
-			blogic_info("%d", adapter, adapter->qdepth[0]);
+			blogic_info(adapter, "%d", adapter->qdepth[0]);
 		else
-			blogic_info("Automatic", adapter);
+			blogic_info(adapter, "Automatic");
 	} else
-		blogic_info("Individual", adapter);
-	blogic_info(", Untagged Queue Depth: %d\n", adapter,
-			adapter->untag_qdepth);
+		blogic_info(adapter, "Individual");
+	blogic_info(adapter, ", Untagged Queue Depth: %d\n",
+		    adapter->untag_qdepth);
 	if (adapter->terminfo_valid) {
 		if (adapter->wide)
-			blogic_info("  SCSI Bus Termination: %s", adapter,
-				(adapter->low_term ? (adapter->high_term ? "Both Enabled" : "Low Enabled") : (adapter->high_term ? "High Enabled" : "Both Disabled")));
+			blogic_info(adapter, "  SCSI Bus Termination: %s",
+				    (adapter->low_term ? (adapter->high_term ? "Both Enabled" : "Low Enabled") : (adapter->high_term ? "High Enabled" : "Both Disabled")));
 		else
-			blogic_info("  SCSI Bus Termination: %s", adapter,
-				(adapter->low_term ? "Enabled" : "Disabled"));
+			blogic_info(adapter, "  SCSI Bus Termination: %s",
+				    (adapter->low_term ? "Enabled" : "Disabled"));
 		if (adapter->scam)
-			blogic_info(", SCAM: %s", adapter,
-				(adapter->scam_enabled ? (adapter->scam_lev2 ? "Enabled, Level 2" : "Enabled, Level 1") : "Disabled"));
-		blogic_info("\n", adapter);
+			blogic_info(adapter, ", SCAM: %s",
+				    (adapter->scam_enabled ? (adapter->scam_lev2 ? "Enabled, Level 2" : "Enabled, Level 1") : "Disabled"));
+		blogic_info(adapter, "\n");
 	}
 	/*
 	   Indicate reporting the Host Adapter configuration completed
@@ -1984,8 +1982,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 static bool __init blogic_getres(struct blogic_adapter *adapter)
 {
 	if (adapter->irq_ch == 0) {
-		blogic_err("NO LEGAL INTERRUPT CHANNEL ASSIGNED - DETACHING\n",
-				adapter);
+		blogic_err(adapter, "NO LEGAL INTERRUPT CHANNEL ASSIGNED - DETACHING\n");
 		return false;
 	}
 	/*
@@ -1993,8 +1990,8 @@ static bool __init blogic_getres(struct blogic_adapter *adapter)
 	 */
 	if (request_irq(adapter->irq_ch, blogic_inthandler, IRQF_SHARED,
 				adapter->full_model, adapter) < 0) {
-		blogic_err("UNABLE TO ACQUIRE IRQ CHANNEL %d - DETACHING\n",
-				adapter, adapter->irq_ch);
+		blogic_err(adapter, "UNABLE TO ACQUIRE IRQ CHANNEL %d - DETACHING\n",
+			   adapter->irq_ch);
 		return false;
 	}
 	adapter->irq_acquired = true;
@@ -2003,7 +2000,7 @@ static bool __init blogic_getres(struct blogic_adapter *adapter)
 	 */
 	if (adapter->dma_ch > 0) {
 		if (request_dma(adapter->dma_ch, adapter->full_model) < 0) {
-			blogic_err("UNABLE TO ACQUIRE DMA CHANNEL %d - DETACHING\n", adapter, adapter->dma_ch);
+			blogic_err(adapter, "UNABLE TO ACQUIRE DMA CHANNEL %d - DETACHING\n", adapter->dma_ch);
 			return false;
 		}
 		set_dma_mode(adapter->dma_ch, DMA_MODE_CASCADE);
@@ -2150,12 +2147,12 @@ static bool blogic_initadapter(struct blogic_adapter *adapter)
 	 */
 done:
 	if (!adapter->adapter_initd) {
-		blogic_info("*** %s Initialized Successfully ***\n", adapter,
-				adapter->full_model);
-		blogic_info("\n", adapter);
+		blogic_info(adapter, "*** %s Initialized Successfully ***\n",
+			    adapter->full_model);
+		blogic_info(adapter, "\n");
 	} else
-		blogic_warn("*** %s Initialized Successfully ***\n", adapter,
-				adapter->full_model);
+		blogic_warn(adapter, "*** %s Initialized Successfully ***\n",
+			    adapter->full_model);
 	adapter->adapter_initd = true;
 
 	/*
@@ -2367,15 +2364,14 @@ static int __init blogic_init(void)
 	    kzalloc(BLOGIC_MAX_ADAPTERS * sizeof(struct blogic_probeinfo),
 			    GFP_KERNEL);
 	if (blogic_probeinfo_list == NULL) {
-		blogic_err("BusLogic: Unable to allocate Probe Info List\n",
-				NULL);
+		blogic_err(NULL, "BusLogic: Unable to allocate Probe Info List\n");
 		return -ENOMEM;
 	}
 
 	adapter = kzalloc(sizeof(struct blogic_adapter), GFP_KERNEL);
 	if (adapter == NULL) {
 		kfree(blogic_probeinfo_list);
-		blogic_err("BusLogic: Unable to allocate Prototype Host Adapter\n", NULL);
+		blogic_err(NULL, "BusLogic: Unable to allocate Prototype Host Adapter\n");
 		return -ENOMEM;
 	}
 
@@ -2635,8 +2631,8 @@ static int blogic_resultcode(struct blogic_adapter *adapter,
 	case BLOGIC_INVALID_OUTBOX_CODE:
 	case BLOGIC_INVALID_CMD_CODE:
 	case BLOGIC_BAD_CMD_PARAM:
-		blogic_warn("BusLogic Driver Protocol Error 0x%02X\n",
-				adapter, adapter_status);
+		blogic_warn(adapter, "BusLogic Driver Protocol Error 0x%02X\n",
+			    adapter_status);
 	case BLOGIC_DATA_UNDERRUN:
 	case BLOGIC_DATA_OVERRUN:
 	case BLOGIC_NOEXPECT_BUSFREE:
@@ -2660,8 +2656,8 @@ static int blogic_resultcode(struct blogic_adapter *adapter,
 		hoststatus = DID_RESET;
 		break;
 	default:
-		blogic_warn("Unknown Host Adapter Status 0x%02X\n", adapter,
-				adapter_status);
+		blogic_warn(adapter, "Unknown Host Adapter Status 0x%02X\n",
+			    adapter_status);
 		hoststatus = DID_ERROR;
 		break;
 	}
@@ -2719,7 +2715,7 @@ static void blogic_scan_inbox(struct blogic_adapter *adapter)
 				   then there is most likely a bug in
 				   the Host Adapter firmware.
 				 */
-				blogic_warn("Illegal CCB #%ld status %d in Incoming Mailbox\n", adapter, ccb->serial, ccb->status);
+				blogic_warn(adapter, "Illegal CCB #%ld status %d in Incoming Mailbox\n", ccb->serial, ccb->status);
 			}
 		}
 		next_inbox->comp_code = BLOGIC_INBOX_FREE;
@@ -2754,7 +2750,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 		if (ccb->opcode == BLOGIC_BDR) {
 			int tgt_id = ccb->tgt_id;
 
-			blogic_warn("Bus Device Reset CCB #%ld to Target %d Completed\n", adapter, ccb->serial, tgt_id);
+			blogic_warn(adapter, "Bus Device Reset CCB #%ld to Target %d Completed\n", ccb->serial, tgt_id);
 			blogic_inc_count(&adapter->tgt_stats[tgt_id].bdr_done);
 			adapter->tgt_flags[tgt_id].tagq_active = false;
 			adapter->cmds_since_rst[tgt_id] = 0;
@@ -2807,7 +2803,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 			case BLOGIC_INBOX_FREE:
 			case BLOGIC_CMD_NOTFOUND:
 			case BLOGIC_INVALID_CCB:
-				blogic_warn("CCB #%ld to Target %d Impossible State\n", adapter, ccb->serial, ccb->tgt_id);
+				blogic_warn(adapter, "CCB #%ld to Target %d Impossible State\n", ccb->serial, ccb->tgt_id);
 				break;
 			case BLOGIC_CMD_COMPLETE_GOOD:
 				adapter->tgt_stats[ccb->tgt_id]
@@ -2817,8 +2813,8 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 				command->result = DID_OK << 16;
 				break;
 			case BLOGIC_CMD_ABORT_BY_HOST:
-				blogic_warn("CCB #%ld to Target %d Aborted\n",
-					adapter, ccb->serial, ccb->tgt_id);
+				blogic_warn(adapter, "CCB #%ld to Target %d Aborted\n",
+					    ccb->serial, ccb->tgt_id);
 				blogic_inc_count(&adapter->tgt_stats[ccb->tgt_id].aborts_done);
 				command->result = DID_ABORT << 16;
 				break;
@@ -2830,16 +2826,15 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 					    .cmds_complete++;
 					if (blogic_global_options.trace_err) {
 						int i;
-						blogic_notice("CCB #%ld Target %d: Result %X Host "
-								"Adapter Status %02X Target Status %02X\n", adapter, ccb->serial, ccb->tgt_id, command->result, ccb->adapter_status, ccb->tgt_status);
-						blogic_notice("CDB   ", adapter);
+						blogic_notice(adapter, "CCB #%ld Target %d: Result %X Host Adapter Status %02X Target Status %02X\n", ccb->serial, ccb->tgt_id, command->result, ccb->adapter_status, ccb->tgt_status);
+						blogic_notice(adapter, "CDB   ");
 						for (i = 0; i < ccb->cdblen; i++)
-							blogic_notice(" %02X", adapter, ccb->cdb[i]);
-						blogic_notice("\n", adapter);
-						blogic_notice("Sense ", adapter);
+							blogic_notice(adapter, " %02X", ccb->cdb[i]);
+						blogic_notice(adapter, "\n");
+						blogic_notice(adapter, "Sense ");
 						for (i = 0; i < ccb->sense_datalen; i++)
-							blogic_notice(" %02X", adapter, command->sense_buffer[i]);
-						blogic_notice("\n", adapter);
+							blogic_notice(adapter, " %02X", command->sense_buffer[i]);
+						blogic_notice(adapter, "\n");
 					}
 				}
 				break;
@@ -2926,7 +2921,7 @@ static irqreturn_t blogic_inthandler(int irq_ch, void *devid)
 				adapter->adapter_extreset = true;
 				break;
 			case FPOINT_INTERN_ERR:
-				blogic_warn("Internal FlashPoint Error detected - Resetting Host Adapter\n", adapter);
+				blogic_warn(adapter, "Internal FlashPoint Error detected - Resetting Host Adapter\n");
 				adapter->adapter_intern_err = true;
 				break;
 			}
@@ -2940,12 +2935,12 @@ static irqreturn_t blogic_inthandler(int irq_ch, void *devid)
 	   Reset the Host Adapter if requested.
 	 */
 	if (adapter->adapter_extreset) {
-		blogic_warn("Resetting %s due to External SCSI Bus Reset\n", adapter, adapter->full_model);
+		blogic_warn(adapter, "Resetting %s due to External SCSI Bus Reset\n", adapter->full_model);
 		blogic_inc_count(&adapter->ext_resets);
 		blogic_resetadapter(adapter, false);
 		adapter->adapter_extreset = false;
 	} else if (adapter->adapter_intern_err) {
-		blogic_warn("Resetting %s due to Host Adapter Internal Error\n", adapter, adapter->full_model);
+		blogic_warn(adapter, "Resetting %s due to Host Adapter Internal Error\n", adapter->full_model);
 		blogic_inc_count(&adapter->adapter_intern_errors);
 		blogic_resetadapter(adapter, true);
 		adapter->adapter_intern_err = false;
@@ -3142,8 +3137,8 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 			&& tgt_flags->tagq_ok &&
 			(adapter->tagq_ok & (1 << tgt_id))) {
 		tgt_flags->tagq_active = true;
-		blogic_notice("Tagged Queuing now active for Target %d\n",
-					adapter, tgt_id);
+		blogic_notice(adapter, "Tagged Queuing now active for Target %d\n",
+			      tgt_id);
 	}
 	if (tgt_flags->tagq_active) {
 		enum blogic_queuetag queuetag = BLOGIC_SIMPLETAG;
@@ -3197,12 +3192,12 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 		 */
 		if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START, ccb)) {
 			spin_unlock_irq(adapter->scsi_host->host_lock);
-			blogic_warn("Unable to write Outgoing Mailbox - Pausing for 1 second\n", adapter);
+			blogic_warn(adapter, "Unable to write Outgoing Mailbox - Pausing for 1 second\n");
 			blogic_delay(1);
 			spin_lock_irq(adapter->scsi_host->host_lock);
 			if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START,
 						ccb)) {
-				blogic_warn("Still unable to write Outgoing Mailbox - Host Adapter Dead?\n", adapter);
+				blogic_warn(adapter, "Still unable to write Outgoing Mailbox - Host Adapter Dead?\n");
 				blogic_dealloc_ccb(ccb);
 				command->result = DID_ERROR << 16;
 				command->scsi_done(command);
@@ -3252,13 +3247,13 @@ static int blogic_abort(struct scsi_cmnd *command)
 		if (ccb->command == command)
 			break;
 	if (ccb == NULL) {
-		blogic_warn("Unable to Abort Command to Target %d - No CCB Found\n", adapter, tgt_id);
+		blogic_warn(adapter, "Unable to Abort Command to Target %d - No CCB Found\n", tgt_id);
 		return SUCCESS;
 	} else if (ccb->status == BLOGIC_CCB_COMPLETE) {
-		blogic_warn("Unable to Abort Command to Target %d - CCB Completed\n", adapter, tgt_id);
+		blogic_warn(adapter, "Unable to Abort Command to Target %d - CCB Completed\n", tgt_id);
 		return SUCCESS;
 	} else if (ccb->status == BLOGIC_CCB_RESET) {
-		blogic_warn("Unable to Abort Command to Target %d - CCB Reset\n", adapter, tgt_id);
+		blogic_warn(adapter, "Unable to Abort Command to Target %d - CCB Reset\n", tgt_id);
 		return SUCCESS;
 	}
 	if (blogic_multimaster_type(adapter)) {
@@ -3276,16 +3271,16 @@ static int blogic_abort(struct scsi_cmnd *command)
 		 */
 		if (adapter->tgt_flags[tgt_id].tagq_active &&
 				adapter->fw_ver[0] < '5') {
-			blogic_warn("Unable to Abort CCB #%ld to Target %d - Abort Tag Not Supported\n", adapter, ccb->serial, tgt_id);
+			blogic_warn(adapter, "Unable to Abort CCB #%ld to Target %d - Abort Tag Not Supported\n", ccb->serial, tgt_id);
 			return FAILURE;
 		} else if (blogic_write_outbox(adapter, BLOGIC_MBOX_ABORT,
 					ccb)) {
-			blogic_warn("Aborting CCB #%ld to Target %d\n",
-					adapter, ccb->serial, tgt_id);
+			blogic_warn(adapter, "Aborting CCB #%ld to Target %d\n",
+				    ccb->serial, tgt_id);
 			blogic_inc_count(&adapter->tgt_stats[tgt_id].aborts_tried);
 			return SUCCESS;
 		} else {
-			blogic_warn("Unable to Abort CCB #%ld to Target %d - No Outgoing Mailboxes\n", adapter, ccb->serial, tgt_id);
+			blogic_warn(adapter, "Unable to Abort CCB #%ld to Target %d - No Outgoing Mailboxes\n", ccb->serial, tgt_id);
 			return FAILURE;
 		}
 	} else {
@@ -3293,8 +3288,8 @@ static int blogic_abort(struct scsi_cmnd *command)
 		   Call the FlashPoint SCCB Manager to abort execution of
 		   the CCB.
 		 */
-		blogic_warn("Aborting CCB #%ld to Target %d\n", adapter,
-				ccb->serial, tgt_id);
+		blogic_warn(adapter, "Aborting CCB #%ld to Target %d\n",
+			    ccb->serial, tgt_id);
 		blogic_inc_count(&adapter->tgt_stats[tgt_id].aborts_tried);
 		FlashPoint_AbortCCB(adapter->cardhandle, ccb);
 		/*
@@ -3326,8 +3321,8 @@ static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard_reset)
 
 	if (!(blogic_hwreset(adapter, hard_reset) &&
 				blogic_initadapter(adapter))) {
-		blogic_err("Resetting %s Failed\n", adapter,
-						adapter->full_model);
+		blogic_err(adapter, "Resetting %s Failed\n",
+			   adapter->full_model);
 		return FAILURE;
 	}
 
@@ -3435,10 +3430,10 @@ static int blogic_diskparam(struct scsi_device *sdev, struct block_device *dev,
 		diskparam->cylinders = (unsigned long) capacity / (diskparam->heads * diskparam->sectors);
 		if (part_no < 4 && part_end_sector == diskparam->sectors) {
 			if (diskparam->cylinders != saved_cyl)
-				blogic_warn("Adopting Geometry %d/%d from Partition Table\n", adapter, diskparam->heads, diskparam->sectors);
+				blogic_warn(adapter, "Adopting Geometry %d/%d from Partition Table\n", diskparam->heads, diskparam->sectors);
 		} else if (part_end_head > 0 || part_end_sector > 0) {
-			blogic_warn("Warning: Partition Table appears to have Geometry %d/%d which is\n", adapter, part_end_head + 1, part_end_sector);
-			blogic_warn("not compatible with current BusLogic Host Adapter Geometry %d/%d\n", adapter, diskparam->heads, diskparam->sectors);
+			blogic_warn(adapter, "Warning: Partition Table appears to have Geometry %d/%d which is\n", part_end_head + 1, part_end_sector);
+			blogic_warn(adapter, "not compatible with current BusLogic Host Adapter Geometry %d/%d\n", diskparam->heads, diskparam->sectors);
 		}
 	}
 	kfree(buf);
@@ -3563,15 +3558,14 @@ Target	Requested Completed  Requested Completed  Requested Completed\n\
   blogic_msg prints Driver Messages.
 */
 
-static void blogic_msg(enum blogic_msglevel msglevel, char *fmt,
-			struct blogic_adapter *adapter, ...)
+static void blogic_msg(struct blogic_adapter *adapter, enum blogic_msglevel msglevel, char *fmt, ...)
 {
 	static char buf[BLOGIC_LINEBUF_SIZE];
 	static bool begin = true;
 	va_list args;
 	int len = 0;
 
-	va_start(args, adapter);
+	va_start(args, fmt);
 	len = vsprintf(buf, fmt, args);
 	va_end(args);
 	if (msglevel == BLOGIC_ANNOUNCE_LEVEL) {
@@ -3675,7 +3669,7 @@ static int __init blogic_parseopts(char *options)
 					blogic_probe_options.probe134 = true;
 					break;
 				default:
-					blogic_err("BusLogic: Invalid Driver Options (invalid I/O Address 0x%lX)\n", NULL, io_addr);
+					blogic_err(NULL, "BusLogic: Invalid Driver Options (invalid I/O Address 0x%lX)\n", io_addr);
 					return 0;
 				}
 			} else if (blogic_parse(&options, "NoProbeISA"))
@@ -3696,7 +3690,7 @@ static int __init blogic_parseopts(char *options)
 				for (tgt_id = 0; tgt_id < BLOGIC_MAXDEV; tgt_id++) {
 					unsigned short qdepth = simple_strtoul(options, &options, 0);
 					if (qdepth > BLOGIC_MAX_TAG_DEPTH) {
-						blogic_err("BusLogic: Invalid Driver Options (invalid Queue Depth %d)\n", NULL, qdepth);
+						blogic_err(NULL, "BusLogic: Invalid Driver Options (invalid Queue Depth %d)\n", qdepth);
 						return 0;
 					}
 					drvr_opts->qdepth[tgt_id] = qdepth;
@@ -3705,12 +3699,12 @@ static int __init blogic_parseopts(char *options)
 					else if (*options == ']')
 						break;
 					else {
-						blogic_err("BusLogic: Invalid Driver Options (',' or ']' expected at '%s')\n", NULL, options);
+						blogic_err(NULL, "BusLogic: Invalid Driver Options (',' or ']' expected at '%s')\n", options);
 						return 0;
 					}
 				}
 				if (*options != ']') {
-					blogic_err("BusLogic: Invalid Driver Options (']' expected at '%s')\n", NULL, options);
+					blogic_err(NULL, "BusLogic: Invalid Driver Options (']' expected at '%s')\n", options);
 					return 0;
 				} else
 					options++;
@@ -3718,7 +3712,7 @@ static int __init blogic_parseopts(char *options)
 				unsigned short qdepth = simple_strtoul(options, &options, 0);
 				if (qdepth == 0 ||
 						qdepth > BLOGIC_MAX_TAG_DEPTH) {
-					blogic_err("BusLogic: Invalid Driver Options (invalid Queue Depth %d)\n", NULL, qdepth);
+					blogic_err(NULL, "BusLogic: Invalid Driver Options (invalid Queue Depth %d)\n", qdepth);
 					return 0;
 				}
 				drvr_opts->common_qdepth = qdepth;
@@ -3764,7 +3758,7 @@ static int __init blogic_parseopts(char *options)
 				unsigned short bus_settle_time =
 					simple_strtoul(options, &options, 0);
 				if (bus_settle_time > 5 * 60) {
-					blogic_err("BusLogic: Invalid Driver Options (invalid Bus Settle Time %d)\n", NULL, bus_settle_time);
+					blogic_err(NULL, "BusLogic: Invalid Driver Options (invalid Bus Settle Time %d)\n", bus_settle_time);
 					return 0;
 				}
 				drvr_opts->bus_settle_time = bus_settle_time;
@@ -3789,14 +3783,14 @@ static int __init blogic_parseopts(char *options)
 			if (*options == ',')
 				options++;
 			else if (*options != ';' && *options != '\0') {
-				blogic_err("BusLogic: Unexpected Driver Option '%s' ignored\n", NULL, options);
+				blogic_err(NULL, "BusLogic: Unexpected Driver Option '%s' ignored\n", options);
 				*options = '\0';
 			}
 		}
 		if (!(blogic_drvr_options_count == 0 ||
 			blogic_probeinfo_count == 0 ||
 			blogic_drvr_options_count == blogic_probeinfo_count)) {
-			blogic_err("BusLogic: Invalid Driver Options (all or no I/O Addresses must be specified)\n", NULL);
+			blogic_err(NULL, "BusLogic: Invalid Driver Options (all or no I/O Addresses must be specified)\n");
 			return 0;
 		}
 		/*
@@ -3851,7 +3845,7 @@ static int __init blogic_setup(char *str)
 	(void) get_options(str, ARRAY_SIZE(ints), ints);
 
 	if (ints[0] != 0) {
-		blogic_err("BusLogic: Obsolete Command Line Entry Format Ignored\n", NULL);
+		blogic_err(NULL, "BusLogic: Obsolete Command Line Entry Format Ignored\n");
 		return 0;
 	}
 	if (str == NULL || *str == '\0')
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index d06e902..a992c86 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -125,20 +125,20 @@ static char *blogic_msglevelmap[] = { KERN_NOTICE, KERN_NOTICE, KERN_NOTICE, KER
   Define Driver Message macros.
 */
 
-#define blogic_announce(format, args...) \
-	blogic_msg(BLOGIC_ANNOUNCE_LEVEL, format, ##args)
+#define blogic_announce(adapter, fmt, ...)				\
+	blogic_msg(adapter, BLOGIC_ANNOUNCE_LEVEL, fmt, ##__VA_ARGS__)
 
-#define blogic_info(format, args...) \
-	blogic_msg(BLOGIC_INFO_LEVEL, format, ##args)
+#define blogic_info(adapter, fmt, ...)					\
+	blogic_msg(adapter, BLOGIC_INFO_LEVEL, fmt, ##__VA_ARGS__)
 
-#define blogic_notice(format, args...) \
-	blogic_msg(BLOGIC_NOTICE_LEVEL, format, ##args)
+#define blogic_notice(adapter, fmt, ...)				\
+	blogic_msg(adapter, BLOGIC_NOTICE_LEVEL, fmt, ##__VA_ARGS__)
 
-#define blogic_warn(format, args...) \
-	blogic_msg(BLOGIC_WARN_LEVEL, format, ##args)
+#define blogic_warn(adapter, fmt, ...)					\
+	blogic_msg(adapter, BLOGIC_WARN_LEVEL, fmt, ##__VA_ARGS__)
 
-#define blogic_err(format, args...) \
-	blogic_msg(BLOGIC_ERR_LEVEL, format, ##args)
+#define blogic_err(adapter, fmt, ...)					\
+	blogic_msg(adapter, BLOGIC_ERR_LEVEL, fmt, ##__VA_ARGS__)
 
 
 /*
@@ -1296,8 +1296,8 @@ static int blogic_slaveconfig(struct scsi_device *);
 static void blogic_qcompleted_ccb(struct blogic_ccb *);
 static irqreturn_t blogic_inthandler(int, void *);
 static int blogic_resetadapter(struct blogic_adapter *, bool hard_reset);
-__printf(2, 4)
-static void blogic_msg(enum blogic_msglevel, char *, struct blogic_adapter *, ...);
+__printf(3, 4)
+static void blogic_msg(struct blogic_adapter *, enum blogic_msglevel, char *, ...);
 static int __init blogic_setup(char *);
 
 #endif				/* _BUSLOGIC_H */
-- 
1.8.1.2.459.gbcd45b4.dirty
