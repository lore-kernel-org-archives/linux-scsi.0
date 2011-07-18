From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: CONFIG_INTR_REMAP and CONFIG_DMAR dependencies?
Date: Mon, 18 Jul 2011 14:32:54 -0700
Message-ID: <CAE9FiQUgbvC6TiSXK-5K9bOsxYeCePoRoU-NBvtitweVBegyEA@mail.gmail.com>
References: <20110718211620.GD4770@plapp.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60876 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1GRVcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2011 17:32:55 -0400
In-Reply-To: <20110718211620.GD4770@plapp.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux scsi dev <linux-scsi@vger.kernel.org>, linux pci <linux-pci@vger.kernel.org>, suresh.b.siddha@intel.com, hpa@linux.intel.com, Avik Shau <avik.shau@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>

On Mon, Jul 18, 2011 at 2:16 PM, Andrew Vasquez
<andrew.vasquez@qlogic.com> wrote:
> Suresh,
>
> Any thoughts/ideas on this? =A0Could you help with the INTR-REMAP
> messages?
>
> Thanks,
> Andrew Vasquez
>
> ----
>
> All,
>
> We've seen a few reports logged with upstream kernels where qla2xxx i=
s
> unable to initialize HW due to what appears to be a lack of
> interrupt routing:
>
> =A0 =A0 =A0 =A0[ 1137.271156] qla2xxx 0000:18:00.0: Found an ISP2532,=
 irq 52, iobase 0xffffc90000028000
> =A0 =A0 =A0 =A0[ 1137.271438] qla2xxx 0000:18:00.0: irq 96 for MSI/MS=
I-X
> =A0 =A0 =A0 =A0[ 1137.271447] qla2xxx 0000:18:00.0: irq 97 for MSI/MS=
I-X
> =A0 =A0 =A0 =A0[ 1137.271706] qla2xxx 0000:18:00.0: Configuring PCI s=
pace...
> =A0 =A0 =A0 =A0[ 1137.271725] qla2xxx 0000:18:00.0: setting latency t=
imer to 64
> =A0 =A0 =A0 =A0[ 1137.271732] qla2xxx 0000:18:00.0: enabling Mem-Wr-I=
nval
> =A0 =A0 =A0 =A0[ 1137.278705] DRHD: handling fault status reg 2
> =A0 =A0 =A0 =A0[ 1137.278715] INTR-REMAP: Request device [[18:00.0] f=
ault index 20
> =A0 =A0 =A0 =A0[ 1137.278717] INTR-REMAP:[fault reason 34] Present fi=
eld in the IRTE entry is clear
> =A0 =A0 =A0 =A0[ 1159.389099] qla2xxx 0000:0c:07.0: Cable is unplugge=
d...
> =A0 =A0 =A0 =A0[ 1167.218478] qla2xxx 0000:18:00.0: Mailbox command t=
imeout occurred. Scheduling ISP abort. eeh_busy: 0x0
> =A0 =A0 =A0 =A0[ 1167.218490] qla2xxx 0000:18:00.0: Unable to burst-r=
ead optrom segment (100/7ff50400/18389b000).
> =A0 =A0 =A0 =A0[ 1167.218496] qla2xxx 0000:18:00.0: Reverting to slow=
-read.
> =A0 =A0 =A0 =A0[ 1197.174623] qla2xxx 0000:18:00.0: Unable to burst-r=
ead optrom segment (100/7ff50000/18389b000).
> =A0 =A0 =A0 =A0[ 1197.174632] qla2xxx 0000:18:00.0: Reverting to slow=
-read.
> =A0 =A0 =A0 =A0[ 1197.190613] qla2xxx 0000:18:00.0: Configure NVRAM p=
arameters...
> =A0 =A0 =A0 =A0[ 1197.198582] qla2xxx 0000:18:00.0: Verifying loaded =
RISC code...
> =A0 =A0 =A0 =A0[ 1227.142951] qla2xxx 0000:18:00.0: Failed mailbox se=
nd register test
> =A0 =A0 =A0 =A0[ 1227.142959] qla2xxx 0000:18:00.0: Failed to initial=
ize adapter
>
> It turns out that this is seen only when the kernel is configured wit=
h
> CONFIG_INTR_REMAP=3Dy and CONFIG_DMAR=3Dn. =A0When the kernel is reco=
mpiled
> with CONFIG_DMAR=3Dy, interrupts are being routed and the driver
> operates as normal:
>
> =A0 =A0 =A0 =A0[ =A0 63.271529] qla2xxx 0000:18:00.0: PCI INT A -> GS=
I 52 (level, low) -> IRQ 52
> =A0 =A0 =A0 =A0[ =A0 63.271560] qla2xxx 0000:18:00.0: Found an ISP253=
2, irq 52, iobase 0xffffc90000028000
> =A0 =A0 =A0 =A0[ =A0 63.271864] qla2xxx 0000:18:00.0: irq 96 for MSI/=
MSI-X
> =A0 =A0 =A0 =A0[ =A0 63.271876] qla2xxx 0000:18:00.0: irq 97 for MSI/=
MSI-X
> =A0 =A0 =A0 =A0[ =A0 63.272095] qla2xxx 0000:18:00.0: Configuring PCI=
 space...
> =A0 =A0 =A0 =A0[ =A0 63.272103] qla2xxx 0000:18:00.0: setting latency=
 timer to 64
> =A0 =A0 =A0 =A0[ =A0 63.272111] qla2xxx 0000:18:00.0: enabling Mem-Wr=
-Inval
> =A0 =A0 =A0 =A0[ =A0 63.285525] qla2xxx 0000:18:00.0: Configure NVRAM=
 parameters...
> =A0 =A0 =A0 =A0[ =A0 63.293880] qla2xxx 0000:18:00.0: Verifying loade=
d RISC code...
> =A0 =A0 =A0 =A0[ =A0 63.310956] qla2xxx 0000:18:00.0: FW: Loading via=
 request-firmware...
> =A0 =A0 =A0 =A0[ =A0 63.342746] qla2xxx 0000:18:00.0: Allocated (64 K=
B) for FCE...
> =A0 =A0 =A0 =A0[ =A0 63.342823] qla2xxx 0000:18:00.0: Allocated (64 K=
B) for EFT...
> =A0 =A0 =A0 =A0[ =A0 63.343130] qla2xxx 0000:18:00.0: Allocated (1350=
 KB) for firmware dump...
> =A0 =A0 =A0 =A0[ =A0 63.348153] scsi2 : qla2xxx
> =A0 =A0 =A0 =A0[ =A0 63.348722] qla2xxx 0000:18:00.0:
> =A0 =A0 =A0 =A0[ =A0 63.348723] =A0QLogic Fibre Channel HBA Driver: 8=
=2E03.07.03-k
> =A0 =A0 =A0 =A0[ =A0 63.348724] =A0 QLogic QLE2562 - PCI-Express Dual=
 Channel 8Gb Fibre Channel HBA
> =A0 =A0 =A0 =A0[ =A0 63.348726] =A0 ISP2532: PCIe (5.0GT/s x4) @ 0000=
:18:00.0 hdma+, host#=3D2, fw=3D5.03.15 (d5)
>
> My questions are:
>
> 1) What does the following mean in the CONFIG_INTR_REMAP=3Dy and
> =A0 CONFIG_DMAR=3Dn case?
>
> =A0 =A0 =A0 =A0[ 1137.278705] DRHD: handling fault status reg 2
> =A0 =A0 =A0 =A0[ 1137.278715] INTR-REMAP: Request device [[18:00.0] f=
ault index 20
> =A0 =A0 =A0 =A0[ 1137.278717] INTR-REMAP:[fault reason 34] Present fi=
eld in the IRTE entry is clear
>
> 2) Should CONFIG_DMAR be automatically enabled when
> =A0 CONFIG_INTR_REMAP is set?

those are separated option.

one for dmar remapping, one for interrupt.

how about when you have CONFIG_INTR_REMAP=3Dy and CONFIG_DMAR=3Dy
and boot with intel_iommu=3Doff

>
> 3) If the answer to (2) is no, then what should drivers do differentl=
y
> =A0 to avoid this 'no interrupts being routed case' scenario?
>

can you post whole boot log?

Yinghai
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
