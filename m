From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
 	Enable Online Controller Reset Bit in register related functions
Date: Fri, 18 Jun 2010 15:21:02 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D09274C4@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
 <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:44220 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752829Ab0FRVVQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2010 17:21:16 -0400
In-Reply-To: <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Yinghai,

You need to apply patches 1/12 to 8/12 for this online controller reset=
 (OCR) support.

Regards,

Bo Yang

-----Original Message-----
=46rom: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf =
Of Yinghai Lu
Sent: Friday, June 18, 2010 5:19 PM
To: Yang, Bo
Cc: James.Bottomley@HansenPartnership.com; James.Bottomley@suse.de; lin=
ux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset =
- I: Enable Online Controller Reset Bit in register related functions

On Wed, Jun 9, 2010 at 7:34 PM, Yang, Bo <Bo.Yang@lsi.com> wrote:
> Enable the Online Controller reset bit in the register related functi=
ons. =A0This is first part of the Online Controller Reset.
> The driver supports XScle and Gen2 chips. =A0Driver need to read the =
=46W state register to see if there is FW state change
> Happen.
>
> Signed-off-by Bo Yang<bo.yang@lsi.com>

This patch cause kernel hang just after
[  136.996297] megasas: FW now in Ready state

# lspci -vvxxx -s 01:00.0
01:00.0 RAID bus controller: LSI Logic / Symbios Logic LSI MegaSAS 9260=
 (rev 03)
	Subsystem: LSI Logic / Symbios Logic MegaRAID SAS 9262-8i
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 28
	Region 0: I/O ports at 1c00 [size=3D256]
	Region 1: Memory at aaefc000 (64-bit, non-prefetchable) [size=3D16K]
	Region 3: Memory at aae80000 (64-bit, non-prefetchable) [size=3D256K]
	Expansion ROM at aae40000 [disabled] [size=3D256K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D=
3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [68] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1u=
s
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x8, ASPM L0s, Latency L0 <64ns, L=
1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [d0] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Connection timed out
		Not readable
	Capabilities: [a8] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [c0] MSI-X: Enable- Count=3D15 Masked-
		Vector table: BAR=3D1 offset=3D00002000
		PBA: BAR=3D1 offset=3D00003800
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [138] Power Budgeting <?>
	Kernel driver in use: megaraid_sas
00: 00 10 79 00 47 01 10 00 03 00 04 01 40 00 00 00
10: 01 1c 00 00 04 c0 ef aa 00 00 00 00 04 00 e8 aa
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 10 62 92
30: 00 00 e4 aa 50 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 68 03 06 08 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 01 00 00 10 d0 02 00 25 80 00 10
70: 17 28 00 00 82 04 00 00 40 00 42 10 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 16 00 00 00
90: 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 05 c0 80 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 11 00 0e 00 01 20 00 00 01 38 00 00 00 00 00 00
d0: 03 a8 ff 1f 82 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00



YH
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
