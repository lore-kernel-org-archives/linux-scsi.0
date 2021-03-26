Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11F3C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 05:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C72BE61A50
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 05:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhCZF7T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 01:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhCZF6x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2021 01:58:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98246C0613B0;
        Thu, 25 Mar 2021 22:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+iNA/jUBtD9ad7fvpdzwdl5FTP9+Ef6OiLqm4hZqb9s=; b=a88Mq07y7JU9IPwIB2TIrnDIUK
        wV/S3SzZsjI9VRFSUvd8VLzusIux60t6AjA6AWn2fEgb7OE+PPFiZ1C9DMQgDaX7wSC9BTjqrzHH4
        mnz7oL0b7ioK5xxMkDlaDWhGX1Zkz2svcgUqcI/9rYNYNUypoYv9UqAupkrM/xzHXKHWwABY5i2gZ
        ArND46kT43wPt5IdkK6lUtIUsueM893lh1qX4E48dZjN0gsV3lh4IJTMRScokfWmsLx5OTIQh/iYx
        A7uKHxfzYRawSmWtS/XEjfWZAe4TU/B29EMk8ElMIZP5KCcieFP00gD/PItkhNvU0EeR0e+GF+puG
        8SdOoyxw==;
Received: from [2001:4bb8:191:f692:97ff:1e47:aee2:c7e5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lPfUL-005AOL-En; Fri, 26 Mar 2021 05:58:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 2/8] Buslogic: remove ISA support
Date:   Fri, 26 Mar 2021 06:58:16 +0100
Message-Id: <20210326055822.1437471-3-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210326055822.1437471-1-hch@lst.de>
References: <20210326055822.1437471-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ISA support in Buslogic has been broken for a long time, as all
the I/O path expects a struct device for DMA mapping that is derived from
the PCI device, which would simply crash for ISA adapters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/BusLogic.c | 156 ++--------------------------------------
 drivers/scsi/BusLogic.h |   3 -
 drivers/scsi/Kconfig    |   2 +-
 3 files changed, 6 insertions(+), 155 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index ccb061ab0a0ad2..c3ed03c4b3f5cb 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -561,60 +561,6 @@ static int blogic_cmd(struct blogic_adapter *adapter, enum blogic_opcode opcode,
 }
 
 
-/*
-  blogic_add_probeaddr_isa appends a single ISA I/O Address to the list
-  of I/O Address and Bus Probe Information to be checked for potential BusLogic
-  Host Adapters.
-*/
-
-static void __init blogic_add_probeaddr_isa(unsigned long io_addr)
-{
-	struct blogic_probeinfo *probeinfo;
-	if (blogic_probeinfo_count >= BLOGIC_MAX_ADAPTERS)
-		return;
-	probeinfo = &blogic_probeinfo_list[blogic_probeinfo_count++];
-	probeinfo->adapter_type = BLOGIC_MULTIMASTER;
-	probeinfo->adapter_bus_type = BLOGIC_ISA_BUS;
-	probeinfo->io_addr = io_addr;
-	probeinfo->pci_device = NULL;
-}
-
-
-/*
-  blogic_init_probeinfo_isa initializes the list of I/O Address and
-  Bus Probe Information to be checked for potential BusLogic SCSI Host Adapters
-  only from the list of standard BusLogic MultiMaster ISA I/O Addresses.
-*/
-
-static void __init blogic_init_probeinfo_isa(struct blogic_adapter *adapter)
-{
-	/*
-	   If BusLogic Driver Options specifications requested that ISA
-	   Bus Probes be inhibited, do not proceed further.
-	 */
-	if (blogic_probe_options.noprobe_isa)
-		return;
-	/*
-	   Append the list of standard BusLogic MultiMaster ISA I/O Addresses.
-	 */
-	if (!blogic_probe_options.limited_isa || blogic_probe_options.probe330)
-		blogic_add_probeaddr_isa(0x330);
-	if (!blogic_probe_options.limited_isa || blogic_probe_options.probe334)
-		blogic_add_probeaddr_isa(0x334);
-	if (!blogic_probe_options.limited_isa || blogic_probe_options.probe230)
-		blogic_add_probeaddr_isa(0x230);
-	if (!blogic_probe_options.limited_isa || blogic_probe_options.probe234)
-		blogic_add_probeaddr_isa(0x234);
-	if (!blogic_probe_options.limited_isa || blogic_probe_options.probe130)
-		blogic_add_probeaddr_isa(0x130);
-	if (!blogic_probe_options.limited_isa || blogic_probe_options.probe134)
-		blogic_add_probeaddr_isa(0x134);
-}
-
-
-#ifdef CONFIG_PCI
-
-
 /*
   blogic_sort_probeinfo sorts a section of blogic_probeinfo_list in order
   of increasing PCI Bus and Device Number.
@@ -667,14 +613,11 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
 	int nonpr_mmcount = 0, mmcount = 0;
 	bool force_scan_order = false;
 	bool force_scan_order_checked = false;
-	bool addr_seen[6];
 	struct pci_dev *pci_device = NULL;
 	int i;
 	if (blogic_probeinfo_count >= BLOGIC_MAX_ADAPTERS)
 		return 0;
 	blogic_probeinfo_count++;
-	for (i = 0; i < 6; i++)
-		addr_seen[i] = false;
 	/*
 	   Iterate over the MultiMaster PCI Host Adapters.  For each
 	   enumerated host adapter, determine whether its ISA Compatible
@@ -744,11 +687,8 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
 		host_adapter->io_addr = io_addr;
 		blogic_intreset(host_adapter);
 		if (blogic_cmd(host_adapter, BLOGIC_INQ_PCI_INFO, NULL, 0,
-				&adapter_info, sizeof(adapter_info)) ==
-				sizeof(adapter_info)) {
-			if (adapter_info.isa_port < 6)
-				addr_seen[adapter_info.isa_port] = true;
-		} else
+				&adapter_info, sizeof(adapter_info)) !=
+				sizeof(adapter_info))
 			adapter_info.isa_port = BLOGIC_IO_DISABLE;
 		/*
 		   Issue the Modify I/O Address command to disable the
@@ -835,45 +775,6 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
 	if (force_scan_order)
 		blogic_sort_probeinfo(&blogic_probeinfo_list[nonpr_mmindex],
 					nonpr_mmcount);
-	/*
-	   If no PCI MultiMaster Host Adapter is assigned the Primary
-	   I/O Address, then the Primary I/O Address must be probed
-	   explicitly before any PCI host adapters are probed.
-	 */
-	if (!blogic_probe_options.noprobe_isa)
-		if (pr_probeinfo->io_addr == 0 &&
-				(!blogic_probe_options.limited_isa ||
-				 blogic_probe_options.probe330)) {
-			pr_probeinfo->adapter_type = BLOGIC_MULTIMASTER;
-			pr_probeinfo->adapter_bus_type = BLOGIC_ISA_BUS;
-			pr_probeinfo->io_addr = 0x330;
-		}
-	/*
-	   Append the list of standard BusLogic MultiMaster ISA I/O Addresses,
-	   omitting the Primary I/O Address which has already been handled.
-	 */
-	if (!blogic_probe_options.noprobe_isa) {
-		if (!addr_seen[1] &&
-				(!blogic_probe_options.limited_isa ||
-				 blogic_probe_options.probe334))
-			blogic_add_probeaddr_isa(0x334);
-		if (!addr_seen[2] &&
-				(!blogic_probe_options.limited_isa ||
-				 blogic_probe_options.probe230))
-			blogic_add_probeaddr_isa(0x230);
-		if (!addr_seen[3] &&
-				(!blogic_probe_options.limited_isa ||
-				 blogic_probe_options.probe234))
-			blogic_add_probeaddr_isa(0x234);
-		if (!addr_seen[4] &&
-				(!blogic_probe_options.limited_isa ||
-				 blogic_probe_options.probe130))
-			blogic_add_probeaddr_isa(0x130);
-		if (!addr_seen[5] &&
-				(!blogic_probe_options.limited_isa ||
-				 blogic_probe_options.probe134))
-			blogic_add_probeaddr_isa(0x134);
-	}
 	/*
 	   Iterate over the older non-compliant MultiMaster PCI Host Adapters,
 	   noting the PCI bus location and assigned IRQ Channel.
@@ -1078,18 +979,10 @@ static void __init blogic_init_probeinfo_list(struct blogic_adapter *adapter)
 				}
 			}
 		}
-	} else {
-		blogic_init_probeinfo_isa(adapter);
 	}
 }
 
 
-#else
-#define blogic_init_probeinfo_list(adapter) \
-		blogic_init_probeinfo_isa(adapter)
-#endif				/* CONFIG_PCI */
-
-
 /*
   blogic_failure prints a standardized error message, and then returns false.
 */
@@ -1539,14 +1432,6 @@ static bool __init blogic_rdconfig(struct blogic_adapter *adapter)
 		else if (config.irq_ch15)
 			adapter->irq_ch = 15;
 	}
-	if (adapter->adapter_bus_type == BLOGIC_ISA_BUS) {
-		if (config.dma_ch5)
-			adapter->dma_ch = 5;
-		else if (config.dma_ch6)
-			adapter->dma_ch = 6;
-		else if (config.dma_ch7)
-			adapter->dma_ch = 7;
-	}
 	/*
 	   Determine whether Extended Translation is enabled and save it in
 	   the Host Adapter structure.
@@ -1686,8 +1571,7 @@ static bool __init blogic_rdconfig(struct blogic_adapter *adapter)
 	if (adapter->fw_ver[0] == '5')
 		adapter->adapter_qdepth = 192;
 	else if (adapter->fw_ver[0] == '4')
-		adapter->adapter_qdepth = (adapter->adapter_bus_type !=
-						BLOGIC_ISA_BUS ? 100 : 50);
+		adapter->adapter_qdepth = 100;
 	else
 		adapter->adapter_qdepth = 30;
 	if (strcmp(adapter->fw_ver, "3.31") >= 0) {
@@ -1727,13 +1611,6 @@ static bool __init blogic_rdconfig(struct blogic_adapter *adapter)
 	   bios_addr is 0.
 	 */
 	adapter->bios_addr = ext_setupinfo.bios_addr << 12;
-	/*
-	   ISA Host Adapters require Bounce Buffers if there is more than
-	   16MB memory.
-	 */
-	if (adapter->adapter_bus_type == BLOGIC_ISA_BUS &&
-			(void *) high_memory > (void *) MAX_DMA_ADDRESS)
-		adapter->need_bouncebuf = true;
 	/*
 	   BusLogic BT-445S Host Adapters prior to board revision E have a
 	   hardware bug whereby when the BIOS is enabled, transfers to/from
@@ -1839,11 +1716,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 	blogic_info("Configuring BusLogic Model %s %s%s%s%s SCSI Host Adapter\n", adapter, adapter->model, blogic_adapter_busnames[adapter->adapter_bus_type], (adapter->wide ? " Wide" : ""), (adapter->differential ? " Differential" : ""), (adapter->ultra ? " Ultra" : ""));
 	blogic_info("  Firmware Version: %s, I/O Address: 0x%lX, IRQ Channel: %d/%s\n", adapter, adapter->fw_ver, adapter->io_addr, adapter->irq_ch, (adapter->level_int ? "Level" : "Edge"));
 	if (adapter->adapter_bus_type != BLOGIC_PCI_BUS) {
-		blogic_info("  DMA Channel: ", adapter);
-		if (adapter->dma_ch > 0)
-			blogic_info("%d, ", adapter, adapter->dma_ch);
-		else
-			blogic_info("None, ", adapter);
+		blogic_info("  DMA Channel: None, ", adapter);
 		if (adapter->bios_addr > 0)
 			blogic_info("BIOS Address: 0x%lX, ", adapter,
 					adapter->bios_addr);
@@ -1995,18 +1868,6 @@ static bool __init blogic_getres(struct blogic_adapter *adapter)
 		return false;
 	}
 	adapter->irq_acquired = true;
-	/*
-	   Acquire exclusive access to the DMA Channel.
-	 */
-	if (adapter->dma_ch > 0) {
-		if (request_dma(adapter->dma_ch, adapter->full_model) < 0) {
-			blogic_err("UNABLE TO ACQUIRE DMA CHANNEL %d - DETACHING\n", adapter, adapter->dma_ch);
-			return false;
-		}
-		set_dma_mode(adapter->dma_ch, DMA_MODE_CASCADE);
-		enable_dma(adapter->dma_ch);
-		adapter->dma_chan_acquired = true;
-	}
 	/*
 	   Indicate the System Resource Acquisition completed successfully,
 	 */
@@ -2026,11 +1887,6 @@ static void blogic_relres(struct blogic_adapter *adapter)
 	 */
 	if (adapter->irq_acquired)
 		free_irq(adapter->irq_ch, adapter);
-	/*
-	   Release exclusive access to the DMA Channel.
-	 */
-	if (adapter->dma_chan_acquired)
-		free_dma(adapter->dma_ch);
 	/*
 	   Release any allocated memory structs not released elsewhere
 	 */
@@ -3694,9 +3550,7 @@ static int __init blogic_parseopts(char *options)
 					blogic_err("BusLogic: Invalid Driver Options (invalid I/O Address 0x%lX)\n", NULL, io_addr);
 					return 0;
 				}
-			} else if (blogic_parse(&options, "NoProbeISA"))
-				blogic_probe_options.noprobe_isa = true;
-			else if (blogic_parse(&options, "NoProbePCI"))
+			} else if (blogic_parse(&options, "NoProbePCI"))
 				blogic_probe_options.noprobe_pci = true;
 			else if (blogic_parse(&options, "NoProbe"))
 				blogic_probe_options.noprobe = true;
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 6182cc8a0344a8..6eaddc009b5c55 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -237,7 +237,6 @@ struct blogic_probeinfo {
 
 struct blogic_probe_options {
 	bool noprobe:1;			/* Bit 0 */
-	bool noprobe_isa:1;		/* Bit 1 */
 	bool noprobe_pci:1;		/* Bit 2 */
 	bool nosort_pci:1;		/* Bit 3 */
 	bool multimaster_first:1;	/* Bit 4 */
@@ -997,10 +996,8 @@ struct blogic_adapter {
 	unsigned char bus;
 	unsigned char dev;
 	unsigned char irq_ch;
-	unsigned char dma_ch;
 	unsigned char scsi_id;
 	bool irq_acquired:1;
-	bool dma_chan_acquired:1;
 	bool ext_trans_enable:1;
 	bool parity:1;
 	bool reset_enabled:1;
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 06b87c7f6babd3..3d114be5b662df 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -497,7 +497,7 @@ config SCSI_HPTIOP
 
 config SCSI_BUSLOGIC
 	tristate "BusLogic SCSI support"
-	depends on (PCI || ISA) && SCSI && ISA_DMA_API && VIRT_TO_BUS
+	depends on PCI && SCSI && VIRT_TO_BUS
 	help
 	  This is support for BusLogic MultiMaster and FlashPoint SCSI Host
 	  Adapters. Consult the SCSI-HOWTO, available from
-- 
2.30.1

