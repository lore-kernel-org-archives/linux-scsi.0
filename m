Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B72C33CA9
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 16:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0AA8207FD
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 16:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgAMQ1Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 11:27:24 -0500
Received: from mailout.easymail.ca ([64.68.200.34]:33354 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMQ1X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jan 2020 11:27:23 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2020 11:27:19 EST
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id A23AD21731;
        Mon, 13 Jan 2020 16:21:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo06-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo06-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ser-jv7ri52l; Mon, 13 Jan 2020 16:21:27 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 2A25620E93;
        Mon, 13 Jan 2020 16:21:19 +0000 (UTC)
Received: from [192.168.1.4] (rhapsody.internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 2C4F43EFD9;
        Mon, 13 Jan 2020 09:21:19 -0700 (MST)
Subject: Re: [PATCH] scsi: BusLogic: use %lX for unsigned long rather than %X
To:     Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200108193800.96706-1-colin.king@canonical.com>
From:   Khalid Aziz <khalid@gonehiking.org>
Autocrypt: addr=khalid@gonehiking.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <e67b391d-3fdf-92e0-fbb4-da4a8fac564c@gonehiking.org>
Date:   Mon, 13 Jan 2020 09:21:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200108193800.96706-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/8/20 12:38 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the incorrect %X print format specifier is being used
> for several unsigned longs.  Fix these by using %lX instead. Also
> join up some literal strings that are split.
> 
> Addresses-Coverity: ("Invalid type in argument to printf format specifier")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/BusLogic.c | 110 ++++++++++++++++++++--------------------
>  1 file changed, 55 insertions(+), 55 deletions(-)


Looks good to me.

Acked-by: Khalid Aziz <khalid@gonehiking.org>

> 
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index c25e8a54e869..3170b295a5da 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -134,7 +134,7 @@ static char *blogic_cmd_failure_reason;
>  static void blogic_announce_drvr(struct blogic_adapter *adapter)
>  {
>  	blogic_announce("***** BusLogic SCSI Driver Version " blogic_drvr_version " of " blogic_drvr_date " *****\n", adapter);
> -	blogic_announce("Copyright 1995-1998 by Leonard N. Zubkoff " "<lnz@dandelion.com>\n", adapter);
> +	blogic_announce("Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>\n", adapter);
>  }
>  
>  
> @@ -440,7 +440,7 @@ static int blogic_cmd(struct blogic_adapter *adapter, enum blogic_opcode opcode,
>  			goto done;
>  		}
>  		if (blogic_global_options.trace_config)
> -			blogic_notice("blogic_cmd(%02X) Status = %02X: " "(Modify I/O Address)\n", adapter, opcode, statusreg.all);
> +			blogic_notice("blogic_cmd(%02X) Status = %02X: (Modify I/O Address)\n", adapter, opcode, statusreg.all);
>  		result = 0;
>  		goto done;
>  	}
> @@ -716,23 +716,23 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
>  		pci_addr = base_addr1 = pci_resource_start(pci_device, 1);
>  
>  		if (pci_resource_flags(pci_device, 0) & IORESOURCE_MEM) {
> -			blogic_err("BusLogic: Base Address0 0x%X not I/O for " "MultiMaster Host Adapter\n", NULL, base_addr0);
> -			blogic_err("at PCI Bus %d Device %d I/O Address 0x%X\n", NULL, bus, device, io_addr);
> +			blogic_err("BusLogic: Base Address0 0x%lX not I/O for MultiMaster Host Adapter\n", NULL, base_addr0);
> +			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
>  			continue;
>  		}
>  		if (pci_resource_flags(pci_device, 1) & IORESOURCE_IO) {
> -			blogic_err("BusLogic: Base Address1 0x%X not Memory for " "MultiMaster Host Adapter\n", NULL, base_addr1);
> -			blogic_err("at PCI Bus %d Device %d PCI Address 0x%X\n", NULL, bus, device, pci_addr);
> +			blogic_err("BusLogic: Base Address1 0x%lX not Memory for MultiMaster Host Adapter\n", NULL, base_addr1);
> +			blogic_err("at PCI Bus %d Device %d PCI Address 0x%lX\n", NULL, bus, device, pci_addr);
>  			continue;
>  		}
>  		if (irq_ch == 0) {
> -			blogic_err("BusLogic: IRQ Channel %d invalid for " "MultiMaster Host Adapter\n", NULL, irq_ch);
> -			blogic_err("at PCI Bus %d Device %d I/O Address 0x%X\n", NULL, bus, device, io_addr);
> +			blogic_err("BusLogic: IRQ Channel %d invalid for MultiMaster Host Adapter\n", NULL, irq_ch);
> +			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
>  			continue;
>  		}
>  		if (blogic_global_options.trace_probe) {
> -			blogic_notice("BusLogic: PCI MultiMaster Host Adapter " "detected at\n", NULL);
> -			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address " "0x%X PCI Address 0x%X\n", NULL, bus, device, io_addr, pci_addr);
> +			blogic_notice("BusLogic: PCI MultiMaster Host Adapter detected at\n", NULL);
> +			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX\n", NULL, bus, device, io_addr, pci_addr);
>  		}
>  		/*
>  		   Issue the Inquire PCI Host Adapter Information command to determine
> @@ -818,7 +818,7 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
>  			nonpr_mmcount++;
>  			mmcount++;
>  		} else
> -			blogic_warn("BusLogic: Too many Host Adapters " "detected\n", NULL);
> +			blogic_warn("BusLogic: Too many Host Adapters detected\n", NULL);
>  	}
>  	/*
>  	   If the AutoSCSI "Use Bus And Device # For PCI Scanning Seq."
> @@ -956,23 +956,23 @@ static int __init blogic_init_fp_probeinfo(struct blogic_adapter *adapter)
>  		pci_addr = base_addr1 = pci_resource_start(pci_device, 1);
>  #ifdef CONFIG_SCSI_FLASHPOINT
>  		if (pci_resource_flags(pci_device, 0) & IORESOURCE_MEM) {
> -			blogic_err("BusLogic: Base Address0 0x%X not I/O for " "Flashbef1d88263ff769f15aa0e1515cdcede84e61d15Point Host Adapter\n", NULL, base_addr0);
> -			blogic_err("at PCI Bus %d Device %d I/O Address 0x%X\n", NULL, bus, device, io_addr);
> +			blogic_err("BusLogic: Base Address0 0x%lX not I/O for FlashPoint Host Adapter\n", NULL, base_addr0);
> +			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
>  			continue;
>  		}
>  		if (pci_resource_flags(pci_device, 1) & IORESOURCE_IO) {
> -			blogic_err("BusLogic: Base Address1 0x%X not Memory for " "FlashPoint Host Adapter\n", NULL, base_addr1);
> -			blogic_err("at PCI Bus %d Device %d PCI Address 0x%X\n", NULL, bus, device, pci_addr);
> +			blogic_err("BusLogic: Base Address1 0x%lX not Memory for FlashPoint Host Adapter\n", NULL, base_addr1);
> +			blogic_err("at PCI Bus %d Device %d PCI Address 0x%lX\n", NULL, bus, device, pci_addr);
>  			continue;
>  		}
>  		if (irq_ch == 0) {
> -			blogic_err("BusLogic: IRQ Channel %d invalid for " "FlashPoint Host Adapter\n", NULL, irq_ch);
> -			blogic_err("at PCI Bus %d Device %d I/O Address 0x%X\n", NULL, bus, device, io_addr);
> +			blogic_err("BusLogic: IRQ Channel %d invalid for FlashPoint Host Adapter\n", NULL, irq_ch);
> +			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
>  			continue;
>  		}
>  		if (blogic_global_options.trace_probe) {
> -			blogic_notice("BusLogic: FlashPoint Host Adapter " "detected at\n", NULL);
> -			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address " "0x%X PCI Address 0x%X\n", NULL, bus, device, io_addr, pci_addr);
> +			blogic_notice("BusLogic: FlashPoint Host Adapter detected at\n", NULL);
> +			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX\n", NULL, bus, device, io_addr, pci_addr);
>  		}
>  		if (blogic_probeinfo_count < BLOGIC_MAX_ADAPTERS) {
>  			struct blogic_probeinfo *probeinfo =
> @@ -987,11 +987,11 @@ static int __init blogic_init_fp_probeinfo(struct blogic_adapter *adapter)
>  			probeinfo->pci_device = pci_dev_get(pci_device);
>  			fpcount++;
>  		} else
> -			blogic_warn("BusLogic: Too many Host Adapters " "detected\n", NULL);
> +			blogic_warn("BusLogic: Too many Host Adapters detected\n", NULL);
>  #else
> -		blogic_err("BusLogic: FlashPoint Host Adapter detected at " "PCI Bus %d Device %d\n", NULL, bus, device);
> -		blogic_err("BusLogic: I/O Address 0x%X PCI Address 0x%X, irq %d, " "but FlashPoint\n", NULL, io_addr, pci_addr, irq_ch);
> -		blogic_err("BusLogic: support was omitted in this kernel " "configuration.\n", NULL);
> +		blogic_err("BusLogic: FlashPoint Host Adapter detected at PCI Bus %d Device %d\n", NULL, bus, device);
> +		blogic_err("BusLogic: I/O Address 0x%lX PCI Address 0x%lX, irq %d, but FlashPoint\n", NULL, io_addr, pci_addr, irq_ch);
> +		blogic_err("BusLogic: support was omitted in this kernel configuration.\n", NULL);
>  #endif
>  	}
>  	/*
> @@ -1099,9 +1099,9 @@ static bool blogic_failure(struct blogic_adapter *adapter, char *msg)
>  	if (adapter->adapter_bus_type == BLOGIC_PCI_BUS) {
>  		blogic_err("While configuring BusLogic PCI Host Adapter at\n",
>  				adapter);
> -		blogic_err("Bus %d Device %d I/O Address 0x%X PCI Address 0x%X:\n", adapter, adapter->bus, adapter->dev, adapter->io_addr, adapter->pci_addr);
> +		blogic_err("Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX:\n", adapter, adapter->bus, adapter->dev, adapter->io_addr, adapter->pci_addr);
>  	} else
> -		blogic_err("While configuring BusLogic Host Adapter at " "I/O Address 0x%X:\n", adapter, adapter->io_addr);
> +		blogic_err("While configuring BusLogic Host Adapter at I/O Address 0x%lX:\n", adapter, adapter->io_addr);
>  	blogic_err("%s FAILED - DETACHING\n", adapter, msg);
>  	if (blogic_cmd_failure_reason != NULL)
>  		blogic_err("ADDITIONAL FAILURE INFO - %s\n", adapter,
> @@ -1129,13 +1129,13 @@ static bool __init blogic_probe(struct blogic_adapter *adapter)
>  		fpinfo->present = false;
>  		if (!(FlashPoint_ProbeHostAdapter(fpinfo) == 0 &&
>  					fpinfo->present)) {
> -			blogic_err("BusLogic: FlashPoint Host Adapter detected at " "PCI Bus %d Device %d\n", adapter, adapter->bus, adapter->dev);
> -			blogic_err("BusLogic: I/O Address 0x%X PCI Address 0x%X, " "but FlashPoint\n", adapter, adapter->io_addr, adapter->pci_addr);
> +			blogic_err("BusLogic: FlashPoint Host Adapter detected at PCI Bus %d Device %d\n", adapter, adapter->bus, adapter->dev);
> +			blogic_err("BusLogic: I/O Address 0x%lX PCI Address 0x%lX, but FlashPoint\n", adapter, adapter->io_addr, adapter->pci_addr);
>  			blogic_err("BusLogic: Probe Function failed to validate it.\n", adapter);
>  			return false;
>  		}
>  		if (blogic_global_options.trace_probe)
> -			blogic_notice("BusLogic_Probe(0x%X): FlashPoint Found\n", adapter, adapter->io_addr);
> +			blogic_notice("BusLogic_Probe(0x%lX): FlashPoint Found\n", adapter, adapter->io_addr);
>  		/*
>  		   Indicate the Host Adapter Probe completed successfully.
>  		 */
> @@ -1152,7 +1152,7 @@ static bool __init blogic_probe(struct blogic_adapter *adapter)
>  	intreg.all = blogic_rdint(adapter);
>  	georeg.all = blogic_rdgeom(adapter);
>  	if (blogic_global_options.trace_probe)
> -		blogic_notice("BusLogic_Probe(0x%X): Status 0x%02X, Interrupt 0x%02X, " "Geometry 0x%02X\n", adapter, adapter->io_addr, statusreg.all, intreg.all, georeg.all);
> +		blogic_notice("BusLogic_Probe(0x%lX): Status 0x%02X, Interrupt 0x%02X, Geometry 0x%02X\n", adapter, adapter->io_addr, statusreg.all, intreg.all, georeg.all);
>  	if (statusreg.all == 0 || statusreg.sr.diag_active ||
>  			statusreg.sr.cmd_param_busy || statusreg.sr.rsvd ||
>  			statusreg.sr.cmd_invalid || intreg.ir.rsvd != 0)
> @@ -1231,7 +1231,7 @@ static bool blogic_hwreset(struct blogic_adapter *adapter, bool hard_reset)
>  		udelay(100);
>  	}
>  	if (blogic_global_options.trace_hw_reset)
> -		blogic_notice("BusLogic_HardwareReset(0x%X): Diagnostic Active, " "Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
> +		blogic_notice("BusLogic_HardwareReset(0x%lX): Diagnostic Active, Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
>  	if (timeout < 0)
>  		return false;
>  	/*
> @@ -1251,7 +1251,7 @@ static bool blogic_hwreset(struct blogic_adapter *adapter, bool hard_reset)
>  		udelay(100);
>  	}
>  	if (blogic_global_options.trace_hw_reset)
> -		blogic_notice("BusLogic_HardwareReset(0x%X): Diagnostic Completed, " "Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
> +		blogic_notice("BusLogic_HardwareReset(0x%lX): Diagnostic Completed, Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
>  	if (timeout < 0)
>  		return false;
>  	/*
> @@ -1267,7 +1267,7 @@ static bool blogic_hwreset(struct blogic_adapter *adapter, bool hard_reset)
>  		udelay(100);
>  	}
>  	if (blogic_global_options.trace_hw_reset)
> -		blogic_notice("BusLogic_HardwareReset(0x%X): Host Adapter Ready, " "Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
> +		blogic_notice("BusLogic_HardwareReset(0x%lX): Host Adapter Ready, Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
>  	if (timeout < 0)
>  		return false;
>  	/*
> @@ -1323,7 +1323,7 @@ static bool __init blogic_checkadapter(struct blogic_adapter *adapter)
>  	   Provide tracing information if requested and return.
>  	 */
>  	if (blogic_global_options.trace_probe)
> -		blogic_notice("BusLogic_Check(0x%X): MultiMaster %s\n", adapter,
> +		blogic_notice("BusLogic_Check(0x%lX): MultiMaster %s\n", adapter,
>  				adapter->io_addr,
>  				(result ? "Found" : "Not Found"));
>  	return result;
> @@ -1836,7 +1836,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
>  	int tgt_id;
>  
>  	blogic_info("Configuring BusLogic Model %s %s%s%s%s SCSI Host Adapter\n", adapter, adapter->model, blogic_adapter_busnames[adapter->adapter_bus_type], (adapter->wide ? " Wide" : ""), (adapter->differential ? " Differential" : ""), (adapter->ultra ? " Ultra" : ""));
> -	blogic_info("  Firmware Version: %s, I/O Address: 0x%X, " "IRQ Channel: %d/%s\n", adapter, adapter->fw_ver, adapter->io_addr, adapter->irq_ch, (adapter->level_int ? "Level" : "Edge"));
> +	blogic_info("  Firmware Version: %s, I/O Address: 0x%lX, IRQ Channel: %d/%s\n", adapter, adapter->fw_ver, adapter->io_addr, adapter->irq_ch, (adapter->level_int ? "Level" : "Edge"));
>  	if (adapter->adapter_bus_type != BLOGIC_PCI_BUS) {
>  		blogic_info("  DMA Channel: ", adapter);
>  		if (adapter->dma_ch > 0)
> @@ -1844,7 +1844,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
>  		else
>  			blogic_info("None, ", adapter);
>  		if (adapter->bios_addr > 0)
> -			blogic_info("BIOS Address: 0x%X, ", adapter,
> +			blogic_info("BIOS Address: 0x%lX, ", adapter,
>  					adapter->bios_addr);
>  		else
>  			blogic_info("BIOS Address: None, ", adapter);
> @@ -1852,7 +1852,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
>  		blogic_info("  PCI Bus: %d, Device: %d, Address: ", adapter,
>  				adapter->bus, adapter->dev);
>  		if (adapter->pci_addr > 0)
> -			blogic_info("0x%X, ", adapter, adapter->pci_addr);
> +			blogic_info("0x%lX, ", adapter, adapter->pci_addr);
>  		else
>  			blogic_info("Unassigned, ", adapter);
>  	}
> @@ -1932,10 +1932,10 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
>  	blogic_info("  Disconnect/Reconnect: %s, Tagged Queuing: %s\n", adapter,
>  			discon_msg, tagq_msg);
>  	if (blogic_multimaster_type(adapter)) {
> -		blogic_info("  Scatter/Gather Limit: %d of %d segments, " "Mailboxes: %d\n", adapter, adapter->drvr_sglimit, adapter->adapter_sglimit, adapter->mbox_count);
> -		blogic_info("  Driver Queue Depth: %d, " "Host Adapter Queue Depth: %d\n", adapter, adapter->drvr_qdepth, adapter->adapter_qdepth);
> +		blogic_info("  Scatter/Gather Limit: %d of %d segments, Mailboxes: %d\n", adapter, adapter->drvr_sglimit, adapter->adapter_sglimit, adapter->mbox_count);
> +		blogic_info("  Driver Queue Depth: %d, Host Adapter Queue Depth: %d\n", adapter, adapter->drvr_qdepth, adapter->adapter_qdepth);
>  	} else
> -		blogic_info("  Driver Queue Depth: %d, " "Scatter/Gather Limit: %d segments\n", adapter, adapter->drvr_qdepth, adapter->drvr_sglimit);
> +		blogic_info("  Driver Queue Depth: %d, Scatter/Gather Limit: %d segments\n", adapter, adapter->drvr_qdepth, adapter->drvr_sglimit);
>  	blogic_info("  Tagged Queue Depth: ", adapter);
>  	common_tagq_depth = true;
>  	for (tgt_id = 1; tgt_id < adapter->maxdev; tgt_id++)
> @@ -2717,7 +2717,7 @@ static void blogic_scan_inbox(struct blogic_adapter *adapter)
>  				   then there is most likely a bug in
>  				   the Host Adapter firmware.
>  				 */
> -				blogic_warn("Illegal CCB #%ld status %d in " "Incoming Mailbox\n", adapter, ccb->serial, ccb->status);
> +				blogic_warn("Illegal CCB #%ld status %d in Incoming Mailbox\n", adapter, ccb->serial, ccb->status);
>  			}
>  		}
>  		next_inbox->comp_code = BLOGIC_INBOX_FREE;
> @@ -2752,7 +2752,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
>  		if (ccb->opcode == BLOGIC_BDR) {
>  			int tgt_id = ccb->tgt_id;
>  
> -			blogic_warn("Bus Device Reset CCB #%ld to Target " "%d Completed\n", adapter, ccb->serial, tgt_id);
> +			blogic_warn("Bus Device Reset CCB #%ld to Target %d Completed\n", adapter, ccb->serial, tgt_id);
>  			blogic_inc_count(&adapter->tgt_stats[tgt_id].bdr_done);
>  			adapter->tgt_flags[tgt_id].tagq_active = false;
>  			adapter->cmds_since_rst[tgt_id] = 0;
> @@ -2829,7 +2829,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
>  					if (blogic_global_options.trace_err) {
>  						int i;
>  						blogic_notice("CCB #%ld Target %d: Result %X Host "
> -								"Adapter Status %02X " "Target Status %02X\n", adapter, ccb->serial, ccb->tgt_id, command->result, ccb->adapter_status, ccb->tgt_status);
> +								"Adapter Status %02X Target Status %02X\n", adapter, ccb->serial, ccb->tgt_id, command->result, ccb->adapter_status, ccb->tgt_status);
>  						blogic_notice("CDB   ", adapter);
>  						for (i = 0; i < ccb->cdblen; i++)
>  							blogic_notice(" %02X", adapter, ccb->cdb[i]);
> @@ -3203,12 +3203,12 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
>  		 */
>  		if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START, ccb)) {
>  			spin_unlock_irq(adapter->scsi_host->host_lock);
> -			blogic_warn("Unable to write Outgoing Mailbox - " "Pausing for 1 second\n", adapter);
> +			blogic_warn("Unable to write Outgoing Mailbox - Pausing for 1 second\n", adapter);
>  			blogic_delay(1);
>  			spin_lock_irq(adapter->scsi_host->host_lock);
>  			if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START,
>  						ccb)) {
> -				blogic_warn("Still unable to write Outgoing Mailbox - " "Host Adapter Dead?\n", adapter);
> +				blogic_warn("Still unable to write Outgoing Mailbox - Host Adapter Dead?\n", adapter);
>  				blogic_dealloc_ccb(ccb, 1);
>  				command->result = DID_ERROR << 16;
>  				command->scsi_done(command);
> @@ -3443,8 +3443,8 @@ static int blogic_diskparam(struct scsi_device *sdev, struct block_device *dev,
>  			if (diskparam->cylinders != saved_cyl)
>  				blogic_warn("Adopting Geometry %d/%d from Partition Table\n", adapter, diskparam->heads, diskparam->sectors);
>  		} else if (part_end_head > 0 || part_end_sector > 0) {
> -			blogic_warn("Warning: Partition Table appears to " "have Geometry %d/%d which is\n", adapter, part_end_head + 1, part_end_sector);
> -			blogic_warn("not compatible with current BusLogic " "Host Adapter Geometry %d/%d\n", adapter, diskparam->heads, diskparam->sectors);
> +			blogic_warn("Warning: Partition Table appears to have Geometry %d/%d which is\n", adapter, part_end_head + 1, part_end_sector);
> +			blogic_warn("not compatible with current BusLogic Host Adapter Geometry %d/%d\n", adapter, diskparam->heads, diskparam->sectors);
>  		}
>  	}
>  	kfree(buf);
> @@ -3689,7 +3689,7 @@ static int __init blogic_parseopts(char *options)
>  					blogic_probe_options.probe134 = true;
>  					break;
>  				default:
> -					blogic_err("BusLogic: Invalid Driver Options " "(invalid I/O Address 0x%X)\n", NULL, io_addr);
> +					blogic_err("BusLogic: Invalid Driver Options (invalid I/O Address 0x%lX)\n", NULL, io_addr);
>  					return 0;
>  				}
>  			} else if (blogic_parse(&options, "NoProbeISA"))
> @@ -3710,7 +3710,7 @@ static int __init blogic_parseopts(char *options)
>  				for (tgt_id = 0; tgt_id < BLOGIC_MAXDEV; tgt_id++) {
>  					unsigned short qdepth = simple_strtoul(options, &options, 0);
>  					if (qdepth > BLOGIC_MAX_TAG_DEPTH) {
> -						blogic_err("BusLogic: Invalid Driver Options " "(invalid Queue Depth %d)\n", NULL, qdepth);
> +						blogic_err("BusLogic: Invalid Driver Options (invalid Queue Depth %d)\n", NULL, qdepth);
>  						return 0;
>  					}
>  					drvr_opts->qdepth[tgt_id] = qdepth;
> @@ -3719,12 +3719,12 @@ static int __init blogic_parseopts(char *options)
>  					else if (*options == ']')
>  						break;
>  					else {
> -						blogic_err("BusLogic: Invalid Driver Options " "(',' or ']' expected at '%s')\n", NULL, options);
> +						blogic_err("BusLogic: Invalid Driver Options (',' or ']' expected at '%s')\n", NULL, options);
>  						return 0;
>  					}
>  				}
>  				if (*options != ']') {
> -					blogic_err("BusLogic: Invalid Driver Options " "(']' expected at '%s')\n", NULL, options);
> +					blogic_err("BusLogic: Invalid Driver Options (']' expected at '%s')\n", NULL, options);
>  					return 0;
>  				} else
>  					options++;
> @@ -3732,7 +3732,7 @@ static int __init blogic_parseopts(char *options)
>  				unsigned short qdepth = simple_strtoul(options, &options, 0);
>  				if (qdepth == 0 ||
>  						qdepth > BLOGIC_MAX_TAG_DEPTH) {
> -					blogic_err("BusLogic: Invalid Driver Options " "(invalid Queue Depth %d)\n", NULL, qdepth);
> +					blogic_err("BusLogic: Invalid Driver Options (invalid Queue Depth %d)\n", NULL, qdepth);
>  					return 0;
>  				}
>  				drvr_opts->common_qdepth = qdepth;
> @@ -3778,7 +3778,7 @@ static int __init blogic_parseopts(char *options)
>  				unsigned short bus_settle_time =
>  					simple_strtoul(options, &options, 0);
>  				if (bus_settle_time > 5 * 60) {
> -					blogic_err("BusLogic: Invalid Driver Options " "(invalid Bus Settle Time %d)\n", NULL, bus_settle_time);
> +					blogic_err("BusLogic: Invalid Driver Options (invalid Bus Settle Time %d)\n", NULL, bus_settle_time);
>  					return 0;
>  				}
>  				drvr_opts->bus_settle_time = bus_settle_time;
> @@ -3803,14 +3803,14 @@ static int __init blogic_parseopts(char *options)
>  			if (*options == ',')
>  				options++;
>  			else if (*options != ';' && *options != '\0') {
> -				blogic_err("BusLogic: Unexpected Driver Option '%s' " "ignored\n", NULL, options);
> +				blogic_err("BusLogic: Unexpected Driver Option '%s' ignored\n", NULL, options);
>  				*options = '\0';
>  			}
>  		}
>  		if (!(blogic_drvr_options_count == 0 ||
>  			blogic_probeinfo_count == 0 ||
>  			blogic_drvr_options_count == blogic_probeinfo_count)) {
> -			blogic_err("BusLogic: Invalid Driver Options " "(all or no I/O Addresses must be specified)\n", NULL);
> +			blogic_err("BusLogic: Invalid Driver Options (all or no I/O Addresses must be specified)\n", NULL);
>  			return 0;
>  		}
>  		/*
> @@ -3864,7 +3864,7 @@ static int __init blogic_setup(char *str)
>  	(void) get_options(str, ARRAY_SIZE(ints), ints);
>  
>  	if (ints[0] != 0) {
> -		blogic_err("BusLogic: Obsolete Command Line Entry " "Format Ignored\n", NULL);
> +		blogic_err("BusLogic: Obsolete Command Line Entry Format Ignored\n", NULL);
>  		return 0;
>  	}
>  	if (str == NULL || *str == '\0')
> 

