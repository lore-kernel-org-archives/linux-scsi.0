From: Joe Perches <joe@perches.com>
Subject: [PATCH 2/3] BusLogic: Coalesce formats with multiple string fragments
Date: Thu, 16 May 2013 21:58:31 -0700
Message-ID: <1fe580d1ae95bff774f2561837a22ea772733863.1368765873.git.joe@perches.com>
References: <cover.1368754556.git.khalid.aziz@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1368754556.git.khalid.aziz@oracle.com>
In-Reply-To: <cover.1368765873.git.joe@perches.com>
References: <cover.1368765873.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Strings fragments coalesced by the compiler are
difficult to grep.  Coalesce them instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/BusLogic.c | 66 ++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 28c2051..bd588cf 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -141,7 +141,7 @@ static char *blogic_cmd_failure_reason;
 static void blogic_announce_drvr(struct blogic_adapter *adapter)
 {
 	blogic_announce("***** BusLogic SCSI Driver Version " blogic_drvr_version " of " blogic_drvr_date " *****\n", adapter);
-	blogic_announce("Copyright 1995-1998 by Leonard N. Zubkoff " "<lnz@dandelion.com>\n", adapter);
+	blogic_announce("Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>\n", adapter);
 }
 
 
@@ -444,7 +444,7 @@ static int blogic_cmd(struct blogic_adapter *adapter, enum blogic_opcode opcode,
 			goto done;
 		}
 		if (blogic_global_options.trace_config)
-			blogic_notice("blogic_cmd(%02X) Status = %02X: " "(Modify I/O Address)\n", adapter, opcode, statusreg.all);
+			blogic_notice("blogic_cmd(%02X) Status = %02X: (Modify I/O Address)\n", adapter, opcode, statusreg.all);
 		result = 0;
 		goto done;
 	}
@@ -720,22 +720,22 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
 		pci_addr = base_addr1 = pci_resource_start(pci_device, 1);
 
 		if (pci_resource_flags(pci_device, 0) & IORESOURCE_MEM) {
-			blogic_err("BusLogic: Base Address0 0x%lX not I/O for " "MultiMaster Host Adapter\n", NULL, base_addr0);
+			blogic_err("BusLogic: Base Address0 0x%lX not I/O for MultiMaster Host Adapter\n", NULL, base_addr0);
 			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
 			continue;
 		}
 		if (pci_resource_flags(pci_device, 1) & IORESOURCE_IO) {
-			blogic_err("BusLogic: Base Address1 0x%lX not Memory for " "MultiMaster Host Adapter\n", NULL, base_addr1);
+			blogic_err("BusLogic: Base Address1 0x%lX not Memory for MultiMaster Host Adapter\n", NULL, base_addr1);
 			blogic_err("at PCI Bus %d Device %d PCI Address 0x%lX\n", NULL, bus, device, pci_addr);
 			continue;
 		}
 		if (irq_ch == 0) {
-			blogic_err("BusLogic: IRQ Channel %d invalid for " "MultiMaster Host Adapter\n", NULL, irq_ch);
+			blogic_err("BusLogic: IRQ Channel %d invalid for MultiMaster Host Adapter\n", NULL, irq_ch);
 			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
 			continue;
 		}
 		if (blogic_global_options.trace_probe) {
-			blogic_notice("BusLogic: PCI MultiMaster Host Adapter " "detected at\n", NULL);
+			blogic_notice("BusLogic: PCI MultiMaster Host Adapter detected at\n", NULL);
 			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX\n", NULL, bus, device, io_addr, pci_addr);
 		}
 		/*
@@ -822,7 +822,7 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
 			nonpr_mmcount++;
 			mmcount++;
 		} else
-			blogic_warn("BusLogic: Too many Host Adapters " "detected\n", NULL);
+			blogic_warn("BusLogic: Too many Host Adapters detected\n", NULL);
 	}
 	/*
 	   If the AutoSCSI "Use Bus And Device # For PCI Scanning Seq."
@@ -960,22 +960,22 @@ static int __init blogic_init_fp_probeinfo(struct blogic_adapter *adapter)
 		pci_addr = base_addr1 = pci_resource_start(pci_device, 1);
 #ifdef CONFIG_SCSI_FLASHPOINT
 		if (pci_resource_flags(pci_device, 0) & IORESOURCE_MEM) {
-			blogic_err("BusLogic: Base Address0 0x%lX not I/O for " "FlashPoint Host Adapter\n", NULL, base_addr0);
+			blogic_err("BusLogic: Base Address0 0x%lX not I/O for FlashPoint Host Adapter\n", NULL, base_addr0);
 			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
 			continue;
 		}
 		if (pci_resource_flags(pci_device, 1) & IORESOURCE_IO) {
-			blogic_err("BusLogic: Base Address1 0x%lX not Memory for " "FlashPoint Host Adapter\n", NULL, base_addr1);
+			blogic_err("BusLogic: Base Address1 0x%lX not Memory for FlashPoint Host Adapter\n", NULL, base_addr1);
 			blogic_err("at PCI Bus %d Device %d PCI Address 0x%lX\n", NULL, bus, device, pci_addr);
 			continue;
 		}
 		if (irq_ch == 0) {
-			blogic_err("BusLogic: IRQ Channel %d invalid for " "FlashPoint Host Adapter\n", NULL, irq_ch);
+			blogic_err("BusLogic: IRQ Channel %d invalid for FlashPoint Host Adapter\n", NULL, irq_ch);
 			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
 			continue;
 		}
 		if (blogic_global_options.trace_probe) {
-			blogic_notice("BusLogic: FlashPoint Host Adapter " "detected at\n", NULL);
+			blogic_notice("BusLogic: FlashPoint Host Adapter detected at\n", NULL);
 			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX\n", NULL, bus, device, io_addr, pci_addr);
 		}
 		if (blogic_probeinfo_count < BLOGIC_MAX_ADAPTERS) {
@@ -991,11 +991,11 @@ static int __init blogic_init_fp_probeinfo(struct blogic_adapter *adapter)
 			probeinfo->pci_device = pci_dev_get(pci_device);
 			fpcount++;
 		} else
-			blogic_warn("BusLogic: Too many Host Adapters " "detected\n", NULL);
+			blogic_warn("BusLogic: Too many Host Adapters detected\n", NULL);
 #else
-		blogic_err("BusLogic: FlashPoint Host Adapter detected at " "PCI Bus %d Device %d\n", NULL, bus, device);
-		blogic_err("BusLogic: I/O Address 0x%X PCI Address 0x%X, irq %d, " "but FlashPoint\n", NULL, io_addr, pci_addr, irq_ch);
-		blogic_err("BusLogic: support was omitted in this kernel " "configuration.\n", NULL);
+		blogic_err("BusLogic: FlashPoint Host Adapter detected at PCI Bus %d Device %d\n", NULL, bus, device);
+		blogic_err("BusLogic: I/O Address 0x%X PCI Address 0x%X, irq %d, but FlashPoint\n", NULL, io_addr, pci_addr, irq_ch);
+		blogic_err("BusLogic: support was omitted in this kernel configuration.\n", NULL);
 #endif
 	}
 	/*
@@ -1936,10 +1936,10 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 	blogic_info("  Disconnect/Reconnect: %s, Tagged Queuing: %s\n", adapter,
 			discon_msg, tagq_msg);
 	if (blogic_multimaster_type(adapter)) {
-		blogic_info("  Scatter/Gather Limit: %d of %d segments, " "Mailboxes: %d\n", adapter, adapter->drvr_sglimit, adapter->adapter_sglimit, adapter->mbox_count);
-		blogic_info("  Driver Queue Depth: %d, " "Host Adapter Queue Depth: %d\n", adapter, adapter->drvr_qdepth, adapter->adapter_qdepth);
+		blogic_info("  Scatter/Gather Limit: %d of %d segments, Mailboxes: %d\n", adapter, adapter->drvr_sglimit, adapter->adapter_sglimit, adapter->mbox_count);
+		blogic_info("  Driver Queue Depth: %d, Host Adapter Queue Depth: %d\n", adapter, adapter->drvr_qdepth, adapter->adapter_qdepth);
 	} else
-		blogic_info("  Driver Queue Depth: %d, " "Scatter/Gather Limit: %d segments\n", adapter, adapter->drvr_qdepth, adapter->drvr_sglimit);
+		blogic_info("  Driver Queue Depth: %d, Scatter/Gather Limit: %d segments\n", adapter, adapter->drvr_qdepth, adapter->drvr_sglimit);
 	blogic_info("  Tagged Queue Depth: ", adapter);
 	common_tagq_depth = true;
 	for (tgt_id = 1; tgt_id < adapter->maxdev; tgt_id++)
@@ -2719,7 +2719,7 @@ static void blogic_scan_inbox(struct blogic_adapter *adapter)
 				   then there is most likely a bug in
 				   the Host Adapter firmware.
 				 */
-				blogic_warn("Illegal CCB #%ld status %d in " "Incoming Mailbox\n", adapter, ccb->serial, ccb->status);
+				blogic_warn("Illegal CCB #%ld status %d in Incoming Mailbox\n", adapter, ccb->serial, ccb->status);
 			}
 		}
 		next_inbox->comp_code = BLOGIC_INBOX_FREE;
@@ -2754,7 +2754,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 		if (ccb->opcode == BLOGIC_BDR) {
 			int tgt_id = ccb->tgt_id;
 
-			blogic_warn("Bus Device Reset CCB #%ld to Target " "%d Completed\n", adapter, ccb->serial, tgt_id);
+			blogic_warn("Bus Device Reset CCB #%ld to Target %d Completed\n", adapter, ccb->serial, tgt_id);
 			blogic_inc_count(&adapter->tgt_stats[tgt_id].bdr_done);
 			adapter->tgt_flags[tgt_id].tagq_active = false;
 			adapter->cmds_since_rst[tgt_id] = 0;
@@ -2831,7 +2831,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 					if (blogic_global_options.trace_err) {
 						int i;
 						blogic_notice("CCB #%ld Target %d: Result %X Host "
-								"Adapter Status %02X " "Target Status %02X\n", adapter, ccb->serial, ccb->tgt_id, command->result, ccb->adapter_status, ccb->tgt_status);
+								"Adapter Status %02X Target Status %02X\n", adapter, ccb->serial, ccb->tgt_id, command->result, ccb->adapter_status, ccb->tgt_status);
 						blogic_notice("CDB   ", adapter);
 						for (i = 0; i < ccb->cdblen; i++)
 							blogic_notice(" %02X", adapter, ccb->cdb[i]);
@@ -3197,12 +3197,12 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 		 */
 		if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START, ccb)) {
 			spin_unlock_irq(adapter->scsi_host->host_lock);
-			blogic_warn("Unable to write Outgoing Mailbox - " "Pausing for 1 second\n", adapter);
+			blogic_warn("Unable to write Outgoing Mailbox - Pausing for 1 second\n", adapter);
 			blogic_delay(1);
 			spin_lock_irq(adapter->scsi_host->host_lock);
 			if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START,
 						ccb)) {
-				blogic_warn("Still unable to write Outgoing Mailbox - " "Host Adapter Dead?\n", adapter);
+				blogic_warn("Still unable to write Outgoing Mailbox - Host Adapter Dead?\n", adapter);
 				blogic_dealloc_ccb(ccb);
 				command->result = DID_ERROR << 16;
 				command->scsi_done(command);
@@ -3437,8 +3437,8 @@ static int blogic_diskparam(struct scsi_device *sdev, struct block_device *dev,
 			if (diskparam->cylinders != saved_cyl)
 				blogic_warn("Adopting Geometry %d/%d from Partition Table\n", adapter, diskparam->heads, diskparam->sectors);
 		} else if (part_end_head > 0 || part_end_sector > 0) {
-			blogic_warn("Warning: Partition Table appears to " "have Geometry %d/%d which is\n", adapter, part_end_head + 1, part_end_sector);
-			blogic_warn("not compatible with current BusLogic " "Host Adapter Geometry %d/%d\n", adapter, diskparam->heads, diskparam->sectors);
+			blogic_warn("Warning: Partition Table appears to have Geometry %d/%d which is\n", adapter, part_end_head + 1, part_end_sector);
+			blogic_warn("not compatible with current BusLogic Host Adapter Geometry %d/%d\n", adapter, diskparam->heads, diskparam->sectors);
 		}
 	}
 	kfree(buf);
@@ -3696,7 +3696,7 @@ static int __init blogic_parseopts(char *options)
 				for (tgt_id = 0; tgt_id < BLOGIC_MAXDEV; tgt_id++) {
 					unsigned short qdepth = simple_strtoul(options, &options, 0);
 					if (qdepth > BLOGIC_MAX_TAG_DEPTH) {
-						blogic_err("BusLogic: Invalid Driver Options " "(invalid Queue Depth %d)\n", NULL, qdepth);
+						blogic_err("BusLogic: Invalid Driver Options (invalid Queue Depth %d)\n", NULL, qdepth);
 						return 0;
 					}
 					drvr_opts->qdepth[tgt_id] = qdepth;
@@ -3705,12 +3705,12 @@ static int __init blogic_parseopts(char *options)
 					else if (*options == ']')
 						break;
 					else {
-						blogic_err("BusLogic: Invalid Driver Options " "(',' or ']' expected at '%s')\n", NULL, options);
+						blogic_err("BusLogic: Invalid Driver Options (',' or ']' expected at '%s')\n", NULL, options);
 						return 0;
 					}
 				}
 				if (*options != ']') {
-					blogic_err("BusLogic: Invalid Driver Options " "(']' expected at '%s')\n", NULL, options);
+					blogic_err("BusLogic: Invalid Driver Options (']' expected at '%s')\n", NULL, options);
 					return 0;
 				} else
 					options++;
@@ -3718,7 +3718,7 @@ static int __init blogic_parseopts(char *options)
 				unsigned short qdepth = simple_strtoul(options, &options, 0);
 				if (qdepth == 0 ||
 						qdepth > BLOGIC_MAX_TAG_DEPTH) {
-					blogic_err("BusLogic: Invalid Driver Options " "(invalid Queue Depth %d)\n", NULL, qdepth);
+					blogic_err("BusLogic: Invalid Driver Options (invalid Queue Depth %d)\n", NULL, qdepth);
 					return 0;
 				}
 				drvr_opts->common_qdepth = qdepth;
@@ -3764,7 +3764,7 @@ static int __init blogic_parseopts(char *options)
 				unsigned short bus_settle_time =
 					simple_strtoul(options, &options, 0);
 				if (bus_settle_time > 5 * 60) {
-					blogic_err("BusLogic: Invalid Driver Options " "(invalid Bus Settle Time %d)\n", NULL, bus_settle_time);
+					blogic_err("BusLogic: Invalid Driver Options (invalid Bus Settle Time %d)\n", NULL, bus_settle_time);
 					return 0;
 				}
 				drvr_opts->bus_settle_time = bus_settle_time;
@@ -3789,14 +3789,14 @@ static int __init blogic_parseopts(char *options)
 			if (*options == ',')
 				options++;
 			else if (*options != ';' && *options != '\0') {
-				blogic_err("BusLogic: Unexpected Driver Option '%s' " "ignored\n", NULL, options);
+				blogic_err("BusLogic: Unexpected Driver Option '%s' ignored\n", NULL, options);
 				*options = '\0';
 			}
 		}
 		if (!(blogic_drvr_options_count == 0 ||
 			blogic_probeinfo_count == 0 ||
 			blogic_drvr_options_count == blogic_probeinfo_count)) {
-			blogic_err("BusLogic: Invalid Driver Options " "(all or no I/O Addresses must be specified)\n", NULL);
+			blogic_err("BusLogic: Invalid Driver Options (all or no I/O Addresses must be specified)\n", NULL);
 			return 0;
 		}
 		/*
@@ -3851,7 +3851,7 @@ static int __init blogic_setup(char *str)
 	(void) get_options(str, ARRAY_SIZE(ints), ints);
 
 	if (ints[0] != 0) {
-		blogic_err("BusLogic: Obsolete Command Line Entry " "Format Ignored\n", NULL);
+		blogic_err("BusLogic: Obsolete Command Line Entry Format Ignored\n", NULL);
 		return 0;
 	}
 	if (str == NULL || *str == '\0')
-- 
1.8.1.2.459.gbcd45b4.dirty
