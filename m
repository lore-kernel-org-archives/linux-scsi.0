From: <Shyam_Iyer@Dell.com>
Subject: RE: CONFIG_INTR_REMAP and CONFIG_DMAR dependencies?
Date: Tue, 19 Jul 2011 04:23:34 +0530
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D15706377995BF@BLRX7MCDC203.AMER.DELL.COM>
References: <20110718211620.GD4770@plapp.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausxippc101.us.dell.com ([143.166.85.207]:50053 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab1GRXFt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2011 19:05:49 -0400
In-Reply-To: <20110718211620.GD4770@plapp.qlogic.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, suresh.b.siddha@intel.com, hpa@linux.intel.com
Cc: avik.shau@qlogic.com, giridhar.malavali@qlogic.com

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Andrew Vasquez
> Sent: Monday, July 18, 2011 5:16 PM
> To: linux scsi dev; linux pci; suresh.b.siddha@intel.com;
> hpa@linux.intel.com
> Cc: Avik Shau; Giridhar Malavali
> Subject: CONFIG_INTR_REMAP and CONFIG_DMAR dependencies?
> 
> Suresh,
> 
> Any thoughts/ideas on this?  Could you help with the INTR-REMAP
> messages?
> 
> Thanks,
> Andrew Vasquez
> 
> ----
> 
> All,
> 
> We've seen a few reports logged with upstream kernels where qla2xxx is
> unable to initialize HW due to what appears to be a lack of
> interrupt routing:
> 
> 	[ 1137.271156] qla2xxx 0000:18:00.0: Found an ISP2532, irq 52,
> iobase 0xffffc90000028000
> 	[ 1137.271438] qla2xxx 0000:18:00.0: irq 96 for MSI/MSI-X
> 	[ 1137.271447] qla2xxx 0000:18:00.0: irq 97 for MSI/MSI-X
> 	[ 1137.271706] qla2xxx 0000:18:00.0: Configuring PCI space...
> 	[ 1137.271725] qla2xxx 0000:18:00.0: setting latency timer to 64
> 	[ 1137.271732] qla2xxx 0000:18:00.0: enabling Mem-Wr-Inval
> 	[ 1137.278705] DRHD: handling fault status reg 2
> 	[ 1137.278715] INTR-REMAP: Request device [[18:00.0] fault index
> 20
> 	[ 1137.278717] INTR-REMAP:[fault reason 34] Present field in the
> IRTE entry is clear
> 	[ 1159.389099] qla2xxx 0000:0c:07.0: Cable is unplugged...
> 	[ 1167.218478] qla2xxx 0000:18:00.0: Mailbox command timeout
> occurred. Scheduling ISP abort. eeh_busy: 0x0
> 	[ 1167.218490] qla2xxx 0000:18:00.0: Unable to burst-read optrom
> segment (100/7ff50400/18389b000).
> 	[ 1167.218496] qla2xxx 0000:18:00.0: Reverting to slow-read.
> 	[ 1197.174623] qla2xxx 0000:18:00.0: Unable to burst-read optrom
> segment (100/7ff50000/18389b000).
> 	[ 1197.174632] qla2xxx 0000:18:00.0: Reverting to slow-read.
> 	[ 1197.190613] qla2xxx 0000:18:00.0: Configure NVRAM
> parameters...
> 	[ 1197.198582] qla2xxx 0000:18:00.0: Verifying loaded RISC
> code...
> 	[ 1227.142951] qla2xxx 0000:18:00.0: Failed mailbox send register
> test
> 	[ 1227.142959] qla2xxx 0000:18:00.0: Failed to initialize adapter
> 
> It turns out that this is seen only when the kernel is configured with
> CONFIG_INTR_REMAP=y and CONFIG_DMAR=n.  When the kernel is recompiled
> with CONFIG_DMAR=y, interrupts are being routed and the driver
> operates as normal:

Interesting you mention this. In my case I have both CONFIG_INT_REMAP and CONFIG_DMAR set to "y".

My messages are slightly different but revolve around the DMAR/DRHD faulting.. Something has broken in the DMAR code path..

[   13.707535] qlge 0000:05:00.0: PCI INT A -> GSI 35 (level, low) -> IRQ 35
[   13.707547] qlge 0000:05:00.0: setting latency timer to 64
[   13.721701] qlge 0000:05:00.0: QLogic 10 Gigabit PCI-E Ethernet Driver
[   13.721703] qlge 0000:05:00.0: Driver name: qlge, Version: v1.00.00.29.00.00-01.
[   13.721930] qlge 0000:05:00.0: eth0: Link is down.
[   13.721937] qlge 0000:05:00.0: eth0: Clearing MAC address
[   13.721940] qlge 0000:05:00.0: eth0: Adding UNICAST address 00:00:00:00:00:00 at index 0 in the CAM.
[   13.721947] qlge 0000:05:00.0: eth0: Function #0, Port 0, NIC Roll 0, NIC Rev = 1, XG Roll = 0, XG Rev = 1.
[   13.721950] qlge 0000:05:00.0: eth0: MAC address 00:c0:dd:1b:40:18
[   13.721989] qlge 0000:05:00.1: PCI INT B -> GSI 46 (level, low) -> IRQ 46
[   13.721996] qlge 0000:05:00.1: setting latency timer to 64
[   13.732097] Brocade 10G Ethernet driver
[   13.732119] bnad_pci_probe : (0xffff88031d721000, 0xffffffffa01de3d0) PCI Func : (2)
[   13.735790] qlge 0000:05:00.1: eth1: Link is down.
[   13.735793] qlge 0000:05:00.1: eth1: Clearing MAC address
[   13.735797] qlge 0000:05:00.1: eth1: Adding UNICAST address 00:00:00:00:00:00 at index 128 in the CAM.
[   13.735804] qlge 0000:05:00.1: eth1: Function #1, Port 1, NIC Roll 0, NIC Rev = 1, XG Roll = 0, XG Rev = 1.
[   13.735807] qlge 0000:05:00.1: eth1: MAC address 00:c0:dd:1b:40:1a
[   13.802954] DRHD: handling fault status reg 302
[   13.802959] DMAR:[DMA Read] Request device [03:00.0] fault addr ffe86000
[   13.802961] DMAR:[fault reason 06] PTE Read access is not set
 
> 
> 	[   63.271529] qla2xxx 0000:18:00.0: PCI INT A -> GSI 52 (level,
> low) -> IRQ 52
> 	[   63.271560] qla2xxx 0000:18:00.0: Found an ISP2532, irq 52,
> iobase 0xffffc90000028000
> 	[   63.271864] qla2xxx 0000:18:00.0: irq 96 for MSI/MSI-X
> 	[   63.271876] qla2xxx 0000:18:00.0: irq 97 for MSI/MSI-X
> 	[   63.272095] qla2xxx 0000:18:00.0: Configuring PCI space...
> 	[   63.272103] qla2xxx 0000:18:00.0: setting latency timer to 64
> 	[   63.272111] qla2xxx 0000:18:00.0: enabling Mem-Wr-Inval
> 	[   63.285525] qla2xxx 0000:18:00.0: Configure NVRAM
> parameters...
> 	[   63.293880] qla2xxx 0000:18:00.0: Verifying loaded RISC
> code...
> 	[   63.310956] qla2xxx 0000:18:00.0: FW: Loading via request-
> firmware...
> 	[   63.342746] qla2xxx 0000:18:00.0: Allocated (64 KB) for FCE...
> 	[   63.342823] qla2xxx 0000:18:00.0: Allocated (64 KB) for EFT...
> 	[   63.343130] qla2xxx 0000:18:00.0: Allocated (1350 KB) for
> firmware dump...
> 	[   63.348153] scsi2 : qla2xxx
> 	[   63.348722] qla2xxx 0000:18:00.0:
> 	[   63.348723]  QLogic Fibre Channel HBA Driver: 8.03.07.03-k
> 	[   63.348724]   QLogic QLE2562 - PCI-Express Dual Channel 8Gb
> Fibre Channel HBA
> 	[   63.348726]   ISP2532: PCIe (5.0GT/s x4) @ 0000:18:00.0 hdma+,
> host#=2, fw=5.03.15 (d5)
> 
> My questions are:
> 
> 1) What does the following mean in the CONFIG_INTR_REMAP=y and
>    CONFIG_DMAR=n case?
> 
> 	[ 1137.278705] DRHD: handling fault status reg 2
> 	[ 1137.278715] INTR-REMAP: Request device [[18:00.0] fault index
> 20
> 	[ 1137.278717] INTR-REMAP:[fault reason 34] Present field in the
> IRTE entry is clear
> 
> 2) Should CONFIG_DMAR be automatically enabled when
>    CONFIG_INTR_REMAP is set?
> 
> 3) If the answer to (2) is no, then what should drivers do differently
>    to avoid this 'no interrupts being routed case' scenario?
> 
