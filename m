From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: CONFIG_INTR_REMAP and CONFIG_DMAR dependencies?
Date: Tue, 12 Jul 2011 09:47:47 -0700
Message-ID: <20110712164747.GH95752@plapp.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-pci-owner@vger.kernel.org
To: linux scsi dev <linux-scsi@vger.kernel.org>, linux pci <linux-pci@vger.kernel.org>
Cc: Avik Shau <avik.shau@qlogic.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

All,

We've seen a few reports logged with upstream kernels where qla2xxx is
unable to initialize HW due to what appears to be a lack of
interrupt routing:

	[ 1137.271156] qla2xxx 0000:18:00.0: Found an ISP2532, irq 52, iobase 0xffffc90000028000
	[ 1137.271438] qla2xxx 0000:18:00.0: irq 96 for MSI/MSI-X
	[ 1137.271447] qla2xxx 0000:18:00.0: irq 97 for MSI/MSI-X
	[ 1137.271706] qla2xxx 0000:18:00.0: Configuring PCI space...
	[ 1137.271725] qla2xxx 0000:18:00.0: setting latency timer to 64
	[ 1137.271732] qla2xxx 0000:18:00.0: enabling Mem-Wr-Inval
	[ 1137.278705] DRHD: handling fault status reg 2
	[ 1137.278715] INTR-REMAP: Request device [[18:00.0] fault index 20
	[ 1137.278717] INTR-REMAP:[fault reason 34] Present field in the IRTE entry is clear
	[ 1159.389099] qla2xxx 0000:0c:07.0: Cable is unplugged...
	[ 1167.218478] qla2xxx 0000:18:00.0: Mailbox command timeout occurred. Scheduling ISP abort. eeh_busy: 0x0
	[ 1167.218490] qla2xxx 0000:18:00.0: Unable to burst-read optrom segment (100/7ff50400/18389b000).
	[ 1167.218496] qla2xxx 0000:18:00.0: Reverting to slow-read.
	[ 1197.174623] qla2xxx 0000:18:00.0: Unable to burst-read optrom segment (100/7ff50000/18389b000).
	[ 1197.174632] qla2xxx 0000:18:00.0: Reverting to slow-read.
	[ 1197.190613] qla2xxx 0000:18:00.0: Configure NVRAM parameters...
	[ 1197.198582] qla2xxx 0000:18:00.0: Verifying loaded RISC code...
	[ 1227.142951] qla2xxx 0000:18:00.0: Failed mailbox send register test
	[ 1227.142959] qla2xxx 0000:18:00.0: Failed to initialize adapter

It turns out that this is seen only when the kernel is configured with
CONFIG_INTR_REMAP=y and CONFIG_DMAR=n.  When the kernel is recompiled
with CONFIG_DMAR=y, interrupts are being routed and the driver
operates as normal:

	[   63.271529] qla2xxx 0000:18:00.0: PCI INT A -> GSI 52 (level, low) -> IRQ 52
	[   63.271560] qla2xxx 0000:18:00.0: Found an ISP2532, irq 52, iobase 0xffffc90000028000
	[   63.271864] qla2xxx 0000:18:00.0: irq 96 for MSI/MSI-X
	[   63.271876] qla2xxx 0000:18:00.0: irq 97 for MSI/MSI-X
	[   63.272095] qla2xxx 0000:18:00.0: Configuring PCI space...
	[   63.272103] qla2xxx 0000:18:00.0: setting latency timer to 64
	[   63.272111] qla2xxx 0000:18:00.0: enabling Mem-Wr-Inval
	[   63.285525] qla2xxx 0000:18:00.0: Configure NVRAM parameters...
	[   63.293880] qla2xxx 0000:18:00.0: Verifying loaded RISC code...
	[   63.310956] qla2xxx 0000:18:00.0: FW: Loading via request-firmware...
	[   63.342746] qla2xxx 0000:18:00.0: Allocated (64 KB) for FCE...
	[   63.342823] qla2xxx 0000:18:00.0: Allocated (64 KB) for EFT...
	[   63.343130] qla2xxx 0000:18:00.0: Allocated (1350 KB) for firmware dump...
	[   63.348153] scsi2 : qla2xxx
	[   63.348722] qla2xxx 0000:18:00.0: 
	[   63.348723]  QLogic Fibre Channel HBA Driver: 8.03.07.03-k
	[   63.348724]   QLogic QLE2562 - PCI-Express Dual Channel 8Gb Fibre Channel HBA
	[   63.348726]   ISP2532: PCIe (5.0GT/s x4) @ 0000:18:00.0 hdma+, host#=2, fw=5.03.15 (d5)

My questions are:

1) What does the following mean in the CONFIG_INTR_REMAP=y and
   CONFIG_DMAR=n case?

	[ 1137.278705] DRHD: handling fault status reg 2
	[ 1137.278715] INTR-REMAP: Request device [[18:00.0] fault index 20
	[ 1137.278717] INTR-REMAP:[fault reason 34] Present field in the IRTE entry is clear

2) Should CONFIG_DMAR be automatically enabled when
   CONFIG_INTR_REMAP is set?

3) If the answer to (2) is no, then what should drivers do differently
   to avoid this 'no interrupts being routed case' scenario?

Thanks, av
