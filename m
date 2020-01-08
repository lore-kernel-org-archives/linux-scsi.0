Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5522BC33CA1
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 19:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2338D2073A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 19:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgAHTiH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 14:38:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42692 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbgAHTiH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 14:38:07 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1ipH9U-0007lx-SM; Wed, 08 Jan 2020 19:38:00 +0000
From:   Colin King <colin.king@canonical.com>
To:     Khalid Aziz <khalid@gonehiking.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: BusLogic: use %lX for unsigned long rather than %X
Date:   Wed,  8 Jan 2020 19:38:00 +0000
Message-Id: <20200108193800.96706-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the incorrect %X print format specifier is being used
for several unsigned longs.  Fix these by using %lX instead. Also
join up some literal strings that are split.

Addresses-Coverity: ("Invalid type in argument to printf format specifier")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/BusLogic.c | 110 ++++++++++++++++++++--------------------
 1 file changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index c25e8a54e869..3170b295a5da 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -134,7 +134,7 @@ static char *blogic_cmd_failure_reason;
 static void blogic_announce_drvr(struct blogic_adapter *adapter)
 {
 	blogic_announce("***** BusLogic SCSI Driver Version " blogic_drvr_version " of " blogic_drvr_date " *****\n", adapter);
-	blogic_announce("Copyright 1995-1998 by Leonard N. Zubkoff " "<lnz@dandelion.com>\n", adapter);
+	blogic_announce("Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>\n", adapter);
 }
 
 
@@ -440,7 +440,7 @@ static int blogic_cmd(struct blogic_adapter *adapter, enum blogic_opcode opcode,
 			goto done;
 		}
 		if (blogic_global_options.trace_config)
-			blogic_notice("blogic_cmd(%02X) Status = %02X: " "(Modify I/O Address)\n", adapter, opcode, statusreg.all);
+			blogic_notice("blogic_cmd(%02X) Status = %02X: (Modify I/O Address)\n", adapter, opcode, statusreg.all);
 		result = 0;
 		goto done;
 	}
@@ -716,23 +716,23 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
 		pci_addr = base_addr1 = pci_resource_start(pci_device, 1);
 
 		if (pci_resource_flags(pci_device, 0) & IORESOURCE_MEM) {
-			blogic_err("BusLogic: Base Address0 0x%X not I/O for " "MultiMaster Host Adapter\n", NULL, base_addr0);
-			blogic_err("at PCI Bus %d Device %d I/O Address 0x%X\n", NULL, bus, device, io_addr);
+			blogic_err("BusLogic: Base Address0 0x%lX not I/O for MultiMaster Host Adapter\n", NULL, base_addr0);
+			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
 			continue;
 		}
 		if (pci_resource_flags(pci_device, 1) & IORESOURCE_IO) {
-			blogic_err("BusLogic: Base Address1 0x%X not Memory for " "MultiMaster Host Adapter\n", NULL, base_addr1);
-			blogic_err("at PCI Bus %d Device %d PCI Address 0x%X\n", NULL, bus, device, pci_addr);
+			blogic_err("BusLogic: Base Address1 0x%lX not Memory for MultiMaster Host Adapter\n", NULL, base_addr1);
+			blogic_err("at PCI Bus %d Device %d PCI Address 0x%lX\n", NULL, bus, device, pci_addr);
 			continue;
 		}
 		if (irq_ch == 0) {
-			blogic_err("BusLogic: IRQ Channel %d invalid for " "MultiMaster Host Adapter\n", NULL, irq_ch);
-			blogic_err("at PCI Bus %d Device %d I/O Address 0x%X\n", NULL, bus, device, io_addr);
+			blogic_err("BusLogic: IRQ Channel %d invalid for MultiMaster Host Adapter\n", NULL, irq_ch);
+			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
 			continue;
 		}
 		if (blogic_global_options.trace_probe) {
-			blogic_notice("BusLogic: PCI MultiMaster Host Adapter " "detected at\n", NULL);
-			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address " "0x%X PCI Address 0x%X\n", NULL, bus, device, io_addr, pci_addr);
+			blogic_notice("BusLogic: PCI MultiMaster Host Adapter detected at\n", NULL);
+			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX\n", NULL, bus, device, io_addr, pci_addr);
 		}
 		/*
 		   Issue the Inquire PCI Host Adapter Information command to determine
@@ -818,7 +818,7 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
 			nonpr_mmcount++;
 			mmcount++;
 		} else
-			blogic_warn("BusLogic: Too many Host Adapters " "detected\n", NULL);
+			blogic_warn("BusLogic: Too many Host Adapters detected\n", NULL);
 	}
 	/*
 	   If the AutoSCSI "Use Bus And Device # For PCI Scanning Seq."
@@ -956,23 +956,23 @@ static int __init blogic_init_fp_probeinfo(struct blogic_adapter *adapter)
 		pci_addr = base_addr1 = pci_resource_start(pci_device, 1);
 #ifdef CONFIG_SCSI_FLASHPOINT
 		if (pci_resource_flags(pci_device, 0) & IORESOURCE_MEM) {
-			blogic_err("BusLogic: Base Address0 0x%X not I/O for " "FlashPoint Host Adapter\n", NULL, base_addr0);
-			blogic_err("at PCI Bus %d Device %d I/O Address 0x%X\n", NULL, bus, device, io_addr);
+			blogic_err("BusLogic: Base Address0 0x%lX not I/O for FlashPoint Host Adapter\n", NULL, base_addr0);
+			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
 			continue;
 		}
 		if (pci_resource_flags(pci_device, 1) & IORESOURCE_IO) {
-			blogic_err("BusLogic: Base Address1 0x%X not Memory for " "FlashPoint Host Adapter\n", NULL, base_addr1);
-			blogic_err("at PCI Bus %d Device %d PCI Address 0x%X\n", NULL, bus, device, pci_addr);
+			blogic_err("BusLogic: Base Address1 0x%lX not Memory for FlashPoint Host Adapter\n", NULL, base_addr1);
+			blogic_err("at PCI Bus %d Device %d PCI Address 0x%lX\n", NULL, bus, device, pci_addr);
 			continue;
 		}
 		if (irq_ch == 0) {
-			blogic_err("BusLogic: IRQ Channel %d invalid for " "FlashPoint Host Adapter\n", NULL, irq_ch);
-			blogic_err("at PCI Bus %d Device %d I/O Address 0x%X\n", NULL, bus, device, io_addr);
+			blogic_err("BusLogic: IRQ Channel %d invalid for FlashPoint Host Adapter\n", NULL, irq_ch);
+			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
 			continue;
 		}
 		if (blogic_global_options.trace_probe) {
-			blogic_notice("BusLogic: FlashPoint Host Adapter " "detected at\n", NULL);
-			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address " "0x%X PCI Address 0x%X\n", NULL, bus, device, io_addr, pci_addr);
+			blogic_notice("BusLogic: FlashPoint Host Adapter detected at\n", NULL);
+			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX\n", NULL, bus, device, io_addr, pci_addr);
 		}
 		if (blogic_probeinfo_count < BLOGIC_MAX_ADAPTERS) {
 			struct blogic_probeinfo *probeinfo =
@@ -987,11 +987,11 @@ static int __init blogic_init_fp_probeinfo(struct blogic_adapter *adapter)
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
+		blogic_err("BusLogic: I/O Address 0x%lX PCI Address 0x%lX, irq %d, but FlashPoint\n", NULL, io_addr, pci_addr, irq_ch);
+		blogic_err("BusLogic: support was omitted in this kernel configuration.\n", NULL);
 #endif
 	}
 	/*
@@ -1099,9 +1099,9 @@ static bool blogic_failure(struct blogic_adapter *adapter, char *msg)
 	if (adapter->adapter_bus_type == BLOGIC_PCI_BUS) {
 		blogic_err("While configuring BusLogic PCI Host Adapter at\n",
 				adapter);
-		blogic_err("Bus %d Device %d I/O Address 0x%X PCI Address 0x%X:\n", adapter, adapter->bus, adapter->dev, adapter->io_addr, adapter->pci_addr);
+		blogic_err("Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX:\n", adapter, adapter->bus, adapter->dev, adapter->io_addr, adapter->pci_addr);
 	} else
-		blogic_err("While configuring BusLogic Host Adapter at " "I/O Address 0x%X:\n", adapter, adapter->io_addr);
+		blogic_err("While configuring BusLogic Host Adapter at I/O Address 0x%lX:\n", adapter, adapter->io_addr);
 	blogic_err("%s FAILED - DETACHING\n", adapter, msg);
 	if (blogic_cmd_failure_reason != NULL)
 		blogic_err("ADDITIONAL FAILURE INFO - %s\n", adapter,
@@ -1129,13 +1129,13 @@ static bool __init blogic_probe(struct blogic_adapter *adapter)
 		fpinfo->present = false;
 		if (!(FlashPoint_ProbeHostAdapter(fpinfo) == 0 &&
 					fpinfo->present)) {
-			blogic_err("BusLogic: FlashPoint Host Adapter detected at " "PCI Bus %d Device %d\n", adapter, adapter->bus, adapter->dev);
-			blogic_err("BusLogic: I/O Address 0x%X PCI Address 0x%X, " "but FlashPoint\n", adapter, adapter->io_addr, adapter->pci_addr);
+			blogic_err("BusLogic: FlashPoint Host Adapter detected at PCI Bus %d Device %d\n", adapter, adapter->bus, adapter->dev);
+			blogic_err("BusLogic: I/O Address 0x%lX PCI Address 0x%lX, but FlashPoint\n", adapter, adapter->io_addr, adapter->pci_addr);
 			blogic_err("BusLogic: Probe Function failed to validate it.\n", adapter);
 			return false;
 		}
 		if (blogic_global_options.trace_probe)
-			blogic_notice("BusLogic_Probe(0x%X): FlashPoint Found\n", adapter, adapter->io_addr);
+			blogic_notice("BusLogic_Probe(0x%lX): FlashPoint Found\n", adapter, adapter->io_addr);
 		/*
 		   Indicate the Host Adapter Probe completed successfully.
 		 */
@@ -1152,7 +1152,7 @@ static bool __init blogic_probe(struct blogic_adapter *adapter)
 	intreg.all = blogic_rdint(adapter);
 	georeg.all = blogic_rdgeom(adapter);
 	if (blogic_global_options.trace_probe)
-		blogic_notice("BusLogic_Probe(0x%X): Status 0x%02X, Interrupt 0x%02X, " "Geometry 0x%02X\n", adapter, adapter->io_addr, statusreg.all, intreg.all, georeg.all);
+		blogic_notice("BusLogic_Probe(0x%lX): Status 0x%02X, Interrupt 0x%02X, Geometry 0x%02X\n", adapter, adapter->io_addr, statusreg.all, intreg.all, georeg.all);
 	if (statusreg.all == 0 || statusreg.sr.diag_active ||
 			statusreg.sr.cmd_param_busy || statusreg.sr.rsvd ||
 			statusreg.sr.cmd_invalid || intreg.ir.rsvd != 0)
@@ -1231,7 +1231,7 @@ static bool blogic_hwreset(struct blogic_adapter *adapter, bool hard_reset)
 		udelay(100);
 	}
 	if (blogic_global_options.trace_hw_reset)
-		blogic_notice("BusLogic_HardwareReset(0x%X): Diagnostic Active, " "Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
+		blogic_notice("BusLogic_HardwareReset(0x%lX): Diagnostic Active, Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
 	if (timeout < 0)
 		return false;
 	/*
@@ -1251,7 +1251,7 @@ static bool blogic_hwreset(struct blogic_adapter *adapter, bool hard_reset)
 		udelay(100);
 	}
 	if (blogic_global_options.trace_hw_reset)
-		blogic_notice("BusLogic_HardwareReset(0x%X): Diagnostic Completed, " "Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
+		blogic_notice("BusLogic_HardwareReset(0x%lX): Diagnostic Completed, Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
 	if (timeout < 0)
 		return false;
 	/*
@@ -1267,7 +1267,7 @@ static bool blogic_hwreset(struct blogic_adapter *adapter, bool hard_reset)
 		udelay(100);
 	}
 	if (blogic_global_options.trace_hw_reset)
-		blogic_notice("BusLogic_HardwareReset(0x%X): Host Adapter Ready, " "Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
+		blogic_notice("BusLogic_HardwareReset(0x%lX): Host Adapter Ready, Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
 	if (timeout < 0)
 		return false;
 	/*
@@ -1323,7 +1323,7 @@ static bool __init blogic_checkadapter(struct blogic_adapter *adapter)
 	   Provide tracing information if requested and return.
 	 */
 	if (blogic_global_options.trace_probe)
-		blogic_notice("BusLogic_Check(0x%X): MultiMaster %s\n", adapter,
+		blogic_notice("BusLogic_Check(0x%lX): MultiMaster %s\n", adapter,
 				adapter->io_addr,
 				(result ? "Found" : "Not Found"));
 	return result;
@@ -1836,7 +1836,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 	int tgt_id;
 
 	blogic_info("Configuring BusLogic Model %s %s%s%s%s SCSI Host Adapter\n", adapter, adapter->model, blogic_adapter_busnames[adapter->adapter_bus_type], (adapter->wide ? " Wide" : ""), (adapter->differential ? " Differential" : ""), (adapter->ultra ? " Ultra" : ""));
-	blogic_info("  Firmware Version: %s, I/O Address: 0x%X, " "IRQ Channel: %d/%s\n", adapter, adapter->fw_ver, adapter->io_addr, adapter->irq_ch, (adapter->level_int ? "Level" : "Edge"));
+	blogic_info("  Firmware Version: %s, I/O Address: 0x%lX, IRQ Channel: %d/%s\n", adapter, adapter->fw_ver, adapter->io_addr, adapter->irq_ch, (adapter->level_int ? "Level" : "Edge"));
 	if (adapter->adapter_bus_type != BLOGIC_PCI_BUS) {
 		blogic_info("  DMA Channel: ", adapter);
 		if (adapter->dma_ch > 0)
@@ -1844,7 +1844,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 		else
 			blogic_info("None, ", adapter);
 		if (adapter->bios_addr > 0)
-			blogic_info("BIOS Address: 0x%X, ", adapter,
+			blogic_info("BIOS Address: 0x%lX, ", adapter,
 					adapter->bios_addr);
 		else
 			blogic_info("BIOS Address: None, ", adapter);
@@ -1852,7 +1852,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 		blogic_info("  PCI Bus: %d, Device: %d, Address: ", adapter,
 				adapter->bus, adapter->dev);
 		if (adapter->pci_addr > 0)
-			blogic_info("0x%X, ", adapter, adapter->pci_addr);
+			blogic_info("0x%lX, ", adapter, adapter->pci_addr);
 		else
 			blogic_info("Unassigned, ", adapter);
 	}
@@ -1932,10 +1932,10 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
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
@@ -2717,7 +2717,7 @@ static void blogic_scan_inbox(struct blogic_adapter *adapter)
 				   then there is most likely a bug in
 				   the Host Adapter firmware.
 				 */
-				blogic_warn("Illegal CCB #%ld status %d in " "Incoming Mailbox\n", adapter, ccb->serial, ccb->status);
+				blogic_warn("Illegal CCB #%ld status %d in Incoming Mailbox\n", adapter, ccb->serial, ccb->status);
 			}
 		}
 		next_inbox->comp_code = BLOGIC_INBOX_FREE;
@@ -2752,7 +2752,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 		if (ccb->opcode == BLOGIC_BDR) {
 			int tgt_id = ccb->tgt_id;
 
-			blogic_warn("Bus Device Reset CCB #%ld to Target " "%d Completed\n", adapter, ccb->serial, tgt_id);
+			blogic_warn("Bus Device Reset CCB #%ld to Target %d Completed\n", adapter, ccb->serial, tgt_id);
 			blogic_inc_count(&adapter->tgt_stats[tgt_id].bdr_done);
 			adapter->tgt_flags[tgt_id].tagq_active = false;
 			adapter->cmds_since_rst[tgt_id] = 0;
@@ -2829,7 +2829,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 					if (blogic_global_options.trace_err) {
 						int i;
 						blogic_notice("CCB #%ld Target %d: Result %X Host "
-								"Adapter Status %02X " "Target Status %02X\n", adapter, ccb->serial, ccb->tgt_id, command->result, ccb->adapter_status, ccb->tgt_status);
+								"Adapter Status %02X Target Status %02X\n", adapter, ccb->serial, ccb->tgt_id, command->result, ccb->adapter_status, ccb->tgt_status);
 						blogic_notice("CDB   ", adapter);
 						for (i = 0; i < ccb->cdblen; i++)
 							blogic_notice(" %02X", adapter, ccb->cdb[i]);
@@ -3203,12 +3203,12 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
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
 				blogic_dealloc_ccb(ccb, 1);
 				command->result = DID_ERROR << 16;
 				command->scsi_done(command);
@@ -3443,8 +3443,8 @@ static int blogic_diskparam(struct scsi_device *sdev, struct block_device *dev,
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
@@ -3689,7 +3689,7 @@ static int __init blogic_parseopts(char *options)
 					blogic_probe_options.probe134 = true;
 					break;
 				default:
-					blogic_err("BusLogic: Invalid Driver Options " "(invalid I/O Address 0x%X)\n", NULL, io_addr);
+					blogic_err("BusLogic: Invalid Driver Options (invalid I/O Address 0x%lX)\n", NULL, io_addr);
 					return 0;
 				}
 			} else if (blogic_parse(&options, "NoProbeISA"))
@@ -3710,7 +3710,7 @@ static int __init blogic_parseopts(char *options)
 				for (tgt_id = 0; tgt_id < BLOGIC_MAXDEV; tgt_id++) {
 					unsigned short qdepth = simple_strtoul(options, &options, 0);
 					if (qdepth > BLOGIC_MAX_TAG_DEPTH) {
-						blogic_err("BusLogic: Invalid Driver Options " "(invalid Queue Depth %d)\n", NULL, qdepth);
+						blogic_err("BusLogic: Invalid Driver Options (invalid Queue Depth %d)\n", NULL, qdepth);
 						return 0;
 					}
 					drvr_opts->qdepth[tgt_id] = qdepth;
@@ -3719,12 +3719,12 @@ static int __init blogic_parseopts(char *options)
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
@@ -3732,7 +3732,7 @@ static int __init blogic_parseopts(char *options)
 				unsigned short qdepth = simple_strtoul(options, &options, 0);
 				if (qdepth == 0 ||
 						qdepth > BLOGIC_MAX_TAG_DEPTH) {
-					blogic_err("BusLogic: Invalid Driver Options " "(invalid Queue Depth %d)\n", NULL, qdepth);
+					blogic_err("BusLogic: Invalid Driver Options (invalid Queue Depth %d)\n", NULL, qdepth);
 					return 0;
 				}
 				drvr_opts->common_qdepth = qdepth;
@@ -3778,7 +3778,7 @@ static int __init blogic_parseopts(char *options)
 				unsigned short bus_settle_time =
 					simple_strtoul(options, &options, 0);
 				if (bus_settle_time > 5 * 60) {
-					blogic_err("BusLogic: Invalid Driver Options " "(invalid Bus Settle Time %d)\n", NULL, bus_settle_time);
+					blogic_err("BusLogic: Invalid Driver Options (invalid Bus Settle Time %d)\n", NULL, bus_settle_time);
 					return 0;
 				}
 				drvr_opts->bus_settle_time = bus_settle_time;
@@ -3803,14 +3803,14 @@ static int __init blogic_parseopts(char *options)
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
@@ -3864,7 +3864,7 @@ static int __init blogic_setup(char *str)
 	(void) get_options(str, ARRAY_SIZE(ints), ints);
 
 	if (ints[0] != 0) {
-		blogic_err("BusLogic: Obsolete Command Line Entry " "Format Ignored\n", NULL);
+		blogic_err("BusLogic: Obsolete Command Line Entry Format Ignored\n", NULL);
 		return 0;
 	}
 	if (str == NULL || *str == '\0')
-- 
2.24.0

