From: Prakash Punnoor <prakash@punnoor.de>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Sun, 22 Feb 2009 13:08:54 +0100
Message-ID: <200902221308.55053.prakash@punnoor.de>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <499FD623.1010105@kernel.org> <49A04F1E.7020006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:51602 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbZBVMGq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Feb 2009 07:06:46 -0500
In-Reply-To: <49A04F1E.7020006@gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org

On Samstag 21 Februar 2009 19:59:42 Robert Hancock wrote:
 > Yinghai Lu wrote:
 > > Eric W. Biederman wrote:
 > >> Yinghai Lu <yinghai@kernel.org> writes:
 > >>> On Fri, Feb 20, 2009 at 11:50 PM, Eric W. Biederman
 > >>>
 > >>> <ebiederm@xmission.com> wrote:
 > >>>> Robert Hancock <hancockrwd@gmail.com> writes:
 > >>>>> Is there a reason why we can't just enable the HT MSI mapping for any
 > >>>>> bridge device that has that PCI capability and is underneath an HT
 > >>>>> bridge?
 
[try 2]
Hi,
 

I just could hunt down one MSI related problem on my nvidia MCP51 board. It 
seems the nvida msi quirk enables MSI cap for one device too much. Because 
afterwards the intel_snd_hda driver will hang the kernel when trying to enable 
msi (and even mess up my text console). I saw this behaviour on every kernel 
since this quirk was introduced. (At least the intel hda driver doesn't try to 
enable msi by default). This hack works for me (on 2.6.29-rc5):
 

--- drivers/pci/quirks.c 2009-02-22 12:44:37.156617230 +0100
 +++ /usr/src/linux/drivers/pci/quirks.c 2009-02-22 12:45:05.752616467 +0100
 @@ -2018,7 +2018,7 @@
 u8 flags;
 

 if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
 - &flags) == 0) {
 + &flags) == 0 && dev->device != 0x270) {
 dev_info(&dev->dev, "Enabling HT MSI Mapping\n");
 

 pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
 


Then the intel hda driver works in MSI mode without problems. Would it be 
possible to include this as a proper quirk?
 

The offending device is this:
 00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
 

Cheers,
 

Prakash
 

A full lspci listing:
 00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Latency: 0 
 Capabilities: [44] HyperTransport: Slave or Primary Interface 
 Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL- 
 Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- 
LSEn- ExtCTL- 64b-
 Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- 
LWO=16bit DwFcOutEn-
 Link Control 1: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- 
LSEn+ ExtCTL- 64b- 
 Link Config 1: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=8bit DwFcInEn- 
LWO=8bit DwFcOutEn- 
 Revision ID: 1.03 
 Link Frequency 0: 1.0GHz 
 Link Error 0: <Prot- <Ovfl- <EOC- CTLTm- 
 Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 
1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
 Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- 
 Link Frequency 1: 800MHz 
 Link Error 1: <Prot- <Ovfl- <EOC- CTLTm- 
 Link Frequency Capability 1: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 
1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
 Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- 
PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
 Prefetchable memory behind bridge Upper: 00-00 
 Bus Number: 00 
 Capabilities: [e0] HyperTransport: MSI Mapping Enable+ Fixed- 
 Mapping Address Base: 00000000fee00000 
 00: de 10 f0 02 06 00 b0 00 a2 00 00 05 00 00 80 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 00 00 00 
 40: 43 10 c0 81 08 e0 e0 01 22 00 11 11 22 20 11 00 
 50: 23 06 7f 80 03 05 7f 80 00 00 03 00 00 00 00 00 
 60: 00 00 00 00 00 00 00 00 00 00 00 00 06 15 05 00 
 70: 44 44 41 00 d0 09 00 00 11 00 00 00 11 11 88 00 
 80: 23 99 88 00 1f 00 64 0c 03 00 00 00 7f 00 00 00 
 90: 70 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 00 00 00 00 01 01 01 01 00 00 00 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 61 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 08 00 01 a8 00 00 e0 fe 00 00 00 00 00 00 00 10 
 f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 

00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR+ FastB2B- DisINTx-
 Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR+ <PERR- INTx- 
 00: de 10 fa 02 00 01 20 40 a2 00 00 05 00 00 80 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 50: 00 00 10 00 21 21 14 00 11 11 00 00 03 00 00 00 
 60: 21 88 13 02 de 8f e1 1f 08 72 4e 10 02 3f 00 20 
 70: 10 32 54 0a 10 00 00 00 a0 00 00 00 34 00 31 01 
 80: 00 00 00 00 00 00 00 00 00 00 50 3f 90 3f 00 00 
 90: 00 28 00 fe fd 00 00 00 fc ff ff ff ff 03 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 28 00 fe fd 01 01 a0 01 4f 00 00 80 f9 fd 00 
 e0: 00 00 c9 fe 00 00 00 00 00 fc ff ff 00 00 00 00 
 f0: 00 00 00 00 c7 02 32 00 00 00 00 00 00 00 00 00 
 

00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 00: de 10 fe 02 00 00 20 00 a2 00 00 05 00 00 80 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 40: 43 10 c0 81 1f 20 1c 20 1f 20 c0 21 00 00 00 00 
 50: 36 00 38 c9 01 00 00 00 3b 00 3d c9 02 1f 1c 80 
 60: 02 1f 1c 00 00 00 00 00 02 10 1c a0 02 0c 1c 90 
 70: 02 10 1c 90 02 14 1c 90 02 0c 1c 80 02 10 1c 80 
 80: 02 14 1c 80 02 18 1c 80 02 1c 1c 80 01 10 1c 80 
 90: 02 14 1c 80 11 00 11 00 32 01 00 00 00 00 00 00 
 a0: c2 00 40 01 10 00 00 00 00 00 00 00 00 00 00 00 
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 41 23 05 08 
 c0: fd ff ff ff ff ff ff ff 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 

00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 00: de 10 f8 02 00 00 a0 00 a2 00 00 05 00 00 80 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 00 00 
 40: 43 10 c0 81 00 00 00 00 02 10 1c 80 02 10 1c a0 
 50: 02 0c 1c 90 02 10 1c 90 02 14 1c 90 02 0c 1c 80 
 60: 02 10 1c 80 02 14 1c 80 02 18 1c 80 02 1c 1c 80 
 70: 01 10 1c 80 1f 20 c0 81 00 00 00 00 3e 30 40 c9 
 80: 01 00 00 00 44 30 46 c9 02 1f 1c 80 70 20 00 40 
 90: 89 da 01 09 00 00 00 00 11 00 10 00 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 08 00 00 00 18 1a 00 00 10 00 02 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 0f 01 00 05 00 00 00 00 
 d0: 00 00 f0 03 00 04 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 60 ea 10 10 18 00 00 20 00 00 00 00 00 00 00 00 
 

00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Latency: 0 
 00: de 10 f9 02 06 00 a0 00 a2 00 00 05 00 00 00 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 00 00 
 40: ef dd 7b 2f f7 de 7b 2f f7 de 7b 2f f7 02 00 00 
 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 60: 00 00 00 00 00 00 00 00 03 00 00 00 00 00 00 00 
 70: 0a 00 00 00 03 00 00 00 25 00 00 00 00 00 00 00 
 80: 00 00 00 00 00 00 00 00 05 00 00 00 04 00 00 00 
 90: 03 04 00 00 01 00 00 00 00 00 00 00 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: ff 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 

00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Latency: 0 
 Capabilities: [44] #00 [00fe] 
 Capabilities: [fc] #00 [0000] 
 00: de 10 ff 02 06 00 b0 00 a2 00 00 05 00 00 80 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 00 00 00 
 40: 17 00 00 00 00 fe fe 00 00 fe fe 00 00 fe fe 00 
 50: 00 fe fe 00 00 fe fe 00 00 fe fe 00 00 00 00 00 
 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 

00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR+ FastB2B- DisINTx-
 Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 00: de 10 7f 02 02 01 20 00 a2 00 00 05 00 00 80 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 40: 08 00 00 00 00 00 00 00 00 80 cb fe 00 00 00 00 
 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 

00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 00: de 10 7e 02 00 00 20 00 a2 00 00 05 00 00 80 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 40: 43 10 c0 81 11 00 00 00 75 07 00 00 11 00 00 00 
 50: 75 06 00 00 40 00 60 00 40 00 00 00 00 00 00 00 
 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 80: 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 04 
 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 04 
 b0: ff ff 03 00 10 11 00 00 ac 10 20 00 30 00 00 00 
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 

00:05.0 VGA compatible controller: nVidia Corporation C51PV [GeForce 6150] 
(rev a2) (prog-if 00 [VGA controller])
 Subsystem: ASUSTeK Computer Inc. A8N-VM CSM 
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx- 
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Latency: 0 
 Interrupt: pin A routed to IRQ 16 
 Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=16M] 
 Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M] 
 Region 3: Memory at fb000000 (64-bit, non-prefetchable) [size=16M] 
 [virtual] Expansion ROM at f0000000 [disabled] [size=128K] 
 Capabilities: [48] Power Management version 2 
 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-) 
 Status: D0 PME-Enable- DSel=0 DScale=0 PME- 
 Capabilities: [50] MSI: Mask- 64bit+ Count=1/1 Enable- 
 Address: 0000000000000000 Data: 0000 
 Kernel driver in use: nvidia 
 Kernel modules: nvidia 
 00: de 10 40 02 07 00 b0 00 a2 00 00 03 00 00 00 00 
 10: 00 00 00 fc 0c 00 00 d0 00 00 00 00 04 00 00 fb 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 cd 81 
 30: 00 00 00 00 48 00 00 00 00 00 00 00 05 01 00 00 
 40: 43 10 cd 81 00 00 00 00 01 50 02 00 00 00 00 00 
 50: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00 
 60: 01 00 00 00 04 00 00 00 00 00 00 00 01 00 00 00 
 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
 a0: 00 00 90 01 00 00 00 08 00 00 00 00 ff ff ff ff 
 b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
 c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
 d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
 e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
 f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
 

00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Latency: 0 
 Capabilities: [44] HyperTransport: Slave or Primary Interface 
 Command: BaseUnitID=9 UnitCnt=15 MastHost- DefDir- DUL- 
 Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- 
LSEn+ ExtCTL- 64b-
 Link Config 0: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- 
LWO=8bit DwFcOutEn- 
 Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- 
LSEn- ExtCTL- 64b-
 Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- 
LWO=8bit DwFcOutEn- 
 Revision ID: 1.03 
 Link Frequency 0: 800MHz 
 Link Error 0: <Prot- <Ovfl- <EOC- CTLTm- 
 Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 
1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
 Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- 
 Link Frequency 1: 200MHz 
 Link Error 1: <Prot- <Ovfl- <EOC- CTLTm- 
 Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 
1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
 Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- 
PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
 Prefetchable memory behind bridge Upper: 00-00 
 Bus Number: 00 
 Capabilities: [e0] HyperTransport: MSI Mapping Enable- Fixed- 
 Mapping Address Base: 00000000fee00000 
 00: de 10 70 02 06 00 b0 00 a2 00 00 05 00 00 00 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 00 00 00 
 40: 43 10 c0 81 08 e0 e9 01 22 20 00 00 d0 00 00 00 
 50: 23 05 7f 80 03 00 00 00 00 00 03 00 00 00 00 00 
 60: 00 00 00 00 00 00 00 00 00 00 00 00 06 15 05 00 
 70: 44 44 44 00 d0 09 00 00 11 00 00 00 11 11 55 00 
 80: 23 55 55 00 fa 00 64 0c 03 00 00 00 7f 00 00 00 
 90: 70 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 00 00 00 00 01 01 01 01 00 00 00 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 80 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 08 00 00 a8 00 00 e0 fe 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 

00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a3)
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Latency: 0 
 00: de 10 60 02 0f 00 a0 00 a3 00 01 06 00 00 80 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 00 00 
 40: 43 10 c0 81 00 f0 ff fe fa 3e ff 00 fa 3e ff 00 
 50: fa 3e ff 00 00 5a 62 02 00 00 00 01 00 00 ff ff 
 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f9 ff 
 70: 10 00 ff ff c5 00 00 00 00 00 05 19 00 00 00 03 
 80: 09 80 00 2d 01 21 00 00 c0 00 00 01 00 00 00 00 
 90: 00 00 00 00 00 00 00 00 21 47 65 b7 ef cd 00 00 
 a0: 03 00 10 c1 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 90 02 ef 02 00 08 5f 08 00 00 00 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00 
 

00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a3)
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Interrupt: pin A routed to IRQ 255 
 Region 4: I/O ports at 4c00 [size=64] 
 Region 5: I/O ports at 4c40 [size=64] 
 Capabilities: [44] Power Management version 2 
 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+) 
 Status: D0 PME-Enable- DSel=0 DScale=0 PME- 
 00: de 10 64 02 01 00 b0 00 a3 00 05 0c 00 00 80 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 01 4c 00 00 41 4c 00 00 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 01 00 00 
 40: 43 10 c0 81 01 00 02 c0 00 00 00 00 00 00 00 00 
 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 60: 01 40 00 00 01 44 00 00 01 48 00 00 00 00 00 00 
 70: 01 00 00 00 00 00 c8 fe 00 00 fe fe 01 20 00 00 
 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 c0: d4 30 80 01 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 10 10 04 00 00 a0 00 00 80 30 00 00 41 44 44 11 
 f0: 5a ff 5f bf 00 00 00 c0 10 00 00 00 00 00 00 00 
 

00:0a.2 RAM memory: nVidia Corporation MCP51 Memory Controller 0 (rev a3)
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx+
 Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 00: de 10 72 02 00 04 a0 00 a3 00 00 05 00 00 80 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 40: 00 00 00 00 00 00 00 00 10 00 00 10 00 00 10 10 
 50: 10 10 10 10 00 00 00 00 00 00 00 00 00 00 00 00 
 60: 02 03 00 00 12 00 00 00 02 00 00 00 10 01 12 00 
 70: 32 33 00 00 03 00 00 00 00 00 00 00 12 01 00 00 
 80: 10 00 00 00 00 00 00 00 00 00 00 00 30 02 00 00 
 90: 00 00 00 00 01 20 00 00 01 00 00 00 00 09 00 00 
 a0: 01 02 00 00 00 10 00 00 05 00 00 00 01 00 00 00 
 b0: 00 10 00 80 01 00 00 80 00 00 00 00 02 00 00 00 
 c0: 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 

00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3) 
(prog-if 10 [OHCI])
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Latency: 0 (750ns min, 250ns max) 
 Interrupt: pin A routed to IRQ 23 
 Region 0: Memory at fe02f000 (32-bit, non-prefetchable) [size=4K] 
 Capabilities: [44] Power Management version 2 
 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+) 
 Status: D0 PME-Enable- DSel=0 DScale=0 PME- 
 Kernel driver in use: ohci_hcd 
 00: de 10 6d 02 07 00 b0 00 a3 10 03 0c 00 00 80 00 
 10: 00 f0 02 fe 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 01 03 01 
 40: 43 10 c0 81 01 00 02 fe 00 00 00 00 00 00 00 00 
 50: 00 00 00 00 1d 47 40 00 10 00 00 00 00 00 00 00 
 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 

00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3) 
(prog-if 20 [EHCI])
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Latency: 0 (750ns min, 250ns max) 
 Interrupt: pin B routed to IRQ 20 
 Region 0: Memory at fe02e000 (32-bit, non-prefetchable) [size=256] 
 Capabilities: [44] Debug port: BAR=1 offset=0098 
 Capabilities: [80] Power Management version 2 
 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+) 
 Status: D0 PME-Enable- DSel=0 DScale=0 PME- 
 Kernel driver in use: ehci_hcd 
 00: de 10 6e 02 06 00 b0 00 a3 20 03 0c 00 00 80 00 
 10: 00 e0 02 fe 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 02 03 01 
 40: 43 10 c0 81 0a 80 98 20 00 00 00 00 00 00 00 00 
 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 60: 20 20 01 00 00 60 18 85 03 3c 0a 01 00 00 00 00 
 70: 00 00 08 05 00 10 20 80 89 3d b6 22 77 25 64 00 
 80: 01 00 02 fe 00 00 00 00 00 00 00 00 15 16 00 00 
 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 a0: 01 00 00 00 00 00 08 c0 00 00 00 00 00 00 00 00 
 b0: 00 11 22 33 00 00 00 00 ff 00 00 00 00 00 00 00 
 c0: 10 10 2d 0d 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00 
 

00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1) (prog-if 8a 
[Master SecP PriP])
 Subsystem: Device f043:81c0 
 Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Latency: 0 (750ns min, 250ns max) 
 Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8] 
 Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1] 
 Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8] 
 Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1] 
 Region 4: I/O ports at f400 [size=16] 
 Capabilities: [44] Power Management version 2 
 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-) 
 Status: D0 PME-Enable- DSel=0 DScale=0 PME- 
 Kernel driver in use: pata_amd 
 00: de 10 65 02 05 00 b0 00 a1 8a 01 01 00 00 00 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 01 f4 00 00 00 00 00 00 00 00 00 00 43 f0 c0 81 
 30: 00 00 00 00 44 00 00 00 00 00 00 00 00 00 03 01 
 40: 43 f0 c0 81 01 00 02 00 00 00 00 00 00 00 00 00 
 50: 03 f0 01 00 00 00 00 00 99 99 99 20 2a 00 a8 20 
 60: 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00 00 
 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 80: 00 00 00 00 00 90 20 21 00 00 02 10 00 00 00 00 
 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00 
 

00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev a1) 
(prog-if 85 [Master SecO PriO])
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx- 
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Latency: 0 (750ns min, 250ns max) 
 Interrupt: pin A routed to IRQ 22 
 Region 0: I/O ports at 09f0 [size=8] 
 Region 1: I/O ports at 0bf0 [size=4] 
 Region 2: I/O ports at 0970 [size=8] 
 Region 3: I/O ports at 0b70 [size=4] 
 Region 4: I/O ports at e000 [size=16] 
 Region 5: Memory at fe02d000 (32-bit, non-prefetchable) [size=4K] 
 Capabilities: [44] Power Management version 2 
 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-) 
 Status: D0 PME-Enable- DSel=0 DScale=0 PME- 
 Capabilities: [b0] MSI: Mask- 64bit+ Count=1/4 Enable- 
 Address: 0000000000000000 Data: 0000 
 Capabilities: [cc] HyperTransport: MSI Mapping Enable+ Fixed+ 
 Kernel driver in use: sata_nv 
 00: de 10 66 02 07 00 b0 00 a1 85 01 01 00 00 00 00 
 10: f1 09 00 00 f1 0b 00 00 71 09 00 00 71 0b 00 00 
 20: 01 e0 00 00 00 d0 02 fe 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 44 00 00 00 00 00 00 00 05 01 03 01 
 40: 43 10 c0 81 01 b0 02 00 00 00 00 00 00 00 00 00 
 50: 07 00 00 00 00 00 00 00 a8 a8 a8 20 6a 00 99 20 
 60: 00 00 00 c0 51 0c 00 00 00 0f 06 42 00 00 00 00 
 70: 2c 78 c4 40 01 10 00 00 01 10 00 00 20 00 20 00 
 80: 00 00 00 c0 00 50 36 22 00 00 08 80 9e f7 2d 3b 
 90: 00 00 58 1b 00 00 00 00 06 00 06 10 00 00 01 01 
 a0: 14 10 00 2a 00 00 00 00 00 00 00 00 33 33 00 02 
 b0: 05 cc 84 00 00 00 00 00 00 00 00 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 0a 00 0a 00 08 00 03 a8 
 d0: 01 00 02 6b 42 00 00 00 00 00 00 00 00 00 00 e0 
 e0: 01 00 02 6b 42 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 00 00 00 0c 00 00 00 00 00 
 

00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev a1) 
(prog-if 85 [Master SecO PriO])
 Subsystem: ASUSTeK Computer Inc. Device 81c0 
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx- 
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Latency: 0 (750ns min, 250ns max) 
 Interrupt: pin A routed to IRQ 21 
 Region 0: I/O ports at 09e0 [size=8] 
 Region 1: I/O ports at 0be0 [size=4] 
 Region 2: I/O ports at 0960 [size=8] 
 Region 3: I/O ports at 0b60 [size=4] 
 Region 4: I/O ports at cc00 [size=16] 
 Region 5: Memory at fe02c000 (32-bit, non-prefetchable) [size=4K] 
 Capabilities: [44] Power Management version 2 
 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-) 
 Status: D0 PME-Enable- DSel=0 DScale=0 PME- 
 Capabilities: [b0] MSI: Mask- 64bit+ Count=1/4 Enable- 
 Address: 0000000000000000 Data: 0000 
 Capabilities: [cc] HyperTransport: MSI Mapping Enable+ Fixed+ 
 Kernel driver in use: sata_nv 
 00: de 10 67 02 07 00 b0 00 a1 85 01 01 00 00 00 00 
 10: e1 09 00 00 e1 0b 00 00 61 09 00 00 61 0b 00 00 
 20: 01 cc 00 00 00 c0 02 fe 00 00 00 00 43 10 c0 81 
 30: 00 00 00 00 44 00 00 00 00 00 00 00 05 01 03 01 
 40: 43 10 c0 81 01 b0 02 00 00 00 00 00 00 00 00 00 
 50: 07 00 00 00 00 00 00 00 a8 a8 a8 20 6a 00 99 20 
 60: 00 00 00 c0 51 0c 00 00 00 0f 06 42 00 00 00 00 
 70: 2c 78 c4 40 01 10 00 00 01 10 00 00 20 00 20 00 
 80: 00 00 00 c0 db 46 60 f0 00 00 c6 2c ad 4c f4 fa 
 90: 00 00 15 20 00 00 00 00 06 00 06 10 00 00 01 01 
 a0: 14 10 00 00 00 00 00 00 00 00 00 00 33 33 00 02 
 b0: 05 cc 84 00 00 00 00 00 00 00 00 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 0a 00 0a 00 08 00 03 a8 
 d0: 01 00 02 6b 42 00 00 00 00 00 00 00 90 00 00 00 
 e0: 01 00 02 6b 42 00 00 00 00 00 00 00 0e 00 f0 07 
 f0: 00 00 00 00 00 00 00 00 00 00 0c 00 00 00 00 00 
 

00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2) (prog-if 01 
[Subtractive decode])
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Latency: 0 
 Bus: primary=00, secondary=01, subordinate=01, sec-latency=128 
 I/O behind bridge: 0000b000-0000bfff 
 Memory behind bridge: fdd00000-fddfffff 
 Prefetchable memory behind bridge: fde00000-fdefffff 
 Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- <SERR- <PERR- 
 BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B- 
 PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn- 
 Capabilities: [b8] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000 
 Capabilities: [8c] HyperTransport: MSI Mapping Enable+ Fixed- 
 Mapping Address Base: 00000000fee00000 
 00: de 10 6f 02 07 00 b0 00 a2 01 04 06 00 00 81 00 
 10: 00 00 00 00 00 00 00 00 00 01 01 80 b0 b0 80 02 
 20: d0 fd d0 fd e0 fd e0 fd 00 00 00 00 00 00 00 00 
 30: 00 00 00 00 b8 00 00 00 00 00 00 00 ff 00 04 02 
 40: 00 00 03 00 01 00 02 00 07 00 00 00 00 00 44 00 
 50: 00 00 fe cf 00 00 00 00 ff 1f ff 1f 00 00 00 00 
 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 80: 00 00 00 00 00 00 00 00 00 00 00 00 08 00 01 a8 
 90: 00 00 e0 fe 00 00 00 00 00 00 00 00 00 00 00 00 
 a0: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 00 00 00 00 ff ff 00 00 0d 8c 00 00 00 00 00 00 
 c0: 00 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 

00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a2)
 Subsystem: ASUSTeK Computer Inc. Device 81cb 
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Latency: 0 (500ns min, 1250ns max) 
 Interrupt: pin B routed to IRQ 24 
 Region 0: Memory at fe024000 (32-bit, non-prefetchable) [size=16K] 
 Capabilities: [44] Power Management version 2 
 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+) 
 Status: D0 PME-Enable- DSel=0 DScale=0 PME- 
 Capabilities: [50] MSI: Mask+ 64bit+ Count=1/1 Enable+ 
 Address: 00000000fee0300c Data: 4169 
 Masking: 00000000 Pending: 00000000 
 Capabilities: [6c] HyperTransport: MSI Mapping Enable+ Fixed+ 
 Kernel driver in use: HDA Intel 
 00: de 10 6c 02 06 04 b0 00 a2 00 03 04 00 00 80 00 
 10: 00 40 02 fe 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 cb 81 
 30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 02 02 05 
 40: 43 10 cb 81 01 50 02 c0 00 00 00 00 01 01 0f 00 
 50: 05 6c 81 01 0c 30 e0 fe 00 00 00 00 69 41 00 00 
 60: 00 00 00 00 00 00 00 00 0f 00 00 00 08 00 03 a8 
 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 46 00 29 00 00 00 00 00 00 
 

00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)
 Subsystem: ASUSTeK Computer Inc. Device 816a 
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Latency: 0 (250ns min, 5000ns max) 
 Interrupt: pin A routed to IRQ 23 
 Region 0: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K] 
 Region 1: I/O ports at c800 [size=8] 
 Capabilities: [44] Power Management version 2 
 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+) 
 Status: D0 PME-Enable+ DSel=0 DScale=0 PME- 
 Kernel driver in use: forcedeth 
 00: de 10 69 02 07 00 b0 00 a3 00 80 06 00 00 00 00 
 10: 00 b0 02 fe 01 c8 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 6a 81 
 30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 01 01 14 
 40: 43 10 6a 81 01 00 02 fe 00 01 00 00 0b 00 00 10 
 50: 05 6c 84 01 00 00 00 00 00 00 00 00 00 00 00 00 
 60: 00 00 00 00 00 00 00 00 0f 00 00 00 08 00 02 a8 
 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 11 00 00 00 42 01 00 00 00 00 00 00 
 

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
 Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx- 
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Capabilities: [80] HyperTransport: Host or Secondary Interface 
 Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL- 
 Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- 
LSEn- ExtCTL- 64b- 
 Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- 
LWO=16bit DwFcOutEn- 
 Revision ID: 1.02 
 Link Frequency: 1.0GHz 
 Link Error: <Prot- <Ovfl- <EOC- CTLTm- 
 Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 
1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
 Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- ExtRS- UCnfE- 
 00: 22 10 00 11 00 00 10 00 00 00 00 06 00 00 80 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00 
 40: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00 
 50: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00 
 60: 00 00 01 00 e4 00 00 00 20 c8 20 0f 0c 00 00 00 
 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 80: 08 00 01 21 20 00 11 11 22 06 75 80 02 00 00 00 
 90: 69 01 61 01 00 00 01 00 07 00 00 00 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
 Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 00: 22 10 01 11 00 00 00 00 00 00 00 06 00 00 80 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 40: 03 00 00 00 00 00 2f 01 00 00 00 00 01 00 00 00 
 50: 00 00 00 00 02 00 00 00 00 00 00 00 03 00 00 00 
 60: 00 00 00 00 04 00 00 00 00 00 00 00 05 00 00 00 
 70: 00 00 00 00 06 00 00 00 00 00 00 00 07 00 00 00 
 80: 03 0a 00 00 00 0b 00 00 00 00 00 00 00 00 00 00 
 90: 03 00 d0 00 00 ff df 00 00 00 00 00 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 03 00 f0 00 00 02 fe 00 
 b0: 03 00 e0 00 80 1f e0 00 00 00 00 00 00 00 00 00 
 c0: 13 b0 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 e0: 03 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 
 f0: 01 30 00 d0 00 00 00 00 00 00 00 00 00 00 00 00 
 

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM 
Controller
 Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 00: 22 10 02 11 00 00 00 00 00 00 00 06 00 00 80 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 40: 01 00 00 00 01 02 00 00 00 00 00 00 00 00 00 00 
 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 60: e0 3d f8 00 00 00 00 00 00 00 00 00 00 00 00 00 
 70: 00 00 00 00 00 00 00 00 46 00 00 00 00 00 00 00 
 80: 05 00 00 00 00 00 00 00 24 f2 7d 0c 20 13 22 00 
 90: 10 0c 01 00 5b 80 10 77 24 00 00 80 20 25 2b 00 
 a0: ef 02 00 0c 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: a4 1e 87 29 88 00 00 00 b4 35 61 00 ea bf 0f 1f 
 c0: 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 61 90 8c 27 00 14 48 00 48 ac 1a 0b 94 fe 81 99 
 e0: 7d 99 f5 b3 d9 3e 80 04 03 f2 93 16 fa b7 fb a5 
 f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
 Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx- 
 Capabilities: [f0] Secure device <?> 
 00: 22 10 03 11 00 00 10 00 00 00 00 06 00 00 80 00 
 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 30: 00 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00 
 40: 00 01 00 00 40 00 10 0a 00 00 00 00 00 00 00 00 
 50: 80 e4 a8 85 19 00 00 00 00 00 00 00 00 00 26 08 
 60: 4a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 70: 11 01 32 51 21 40 70 50 00 2a 00 08 17 21 00 00 
 80: 00 00 07 23 13 21 13 21 00 00 00 00 00 00 00 00 
 90: 03 00 00 00 10 00 00 00 00 ac 2f 01 00 00 00 00 
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 30 35 22 
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 d0: 00 00 00 00 01 a7 0d 00 00 00 c0 08 26 26 26 00 
 e0: 00 00 00 00 20 1a 52 00 19 17 00 00 00 00 00 00 
 f0: 0f 00 10 00 00 00 00 00 00 00 00 00 b2 0f 04 00 
 

01:05.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 
Controller (PHY/Link) (prog-if 10 [OHCI])
 Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard 
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx- 
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
 Latency: 32 (500ns min, 1000ns max), Cache Line Size: 32 bytes
 Interrupt: pin A routed to IRQ 255
 Region 0: Memory at fddff000 (32-bit, non-prefetchable) [size=2K]
 Region 1: Memory at fddf8000 (32-bit, non-prefetchable) [size=16K]
 Capabilities: [44] Power Management version 2
 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 00: 4c 10 23 80 06 00 10 02 00 10 00 0c 08 20 00 00
 10: 00 f0 df fd 00 80 df fd 00 00 00 00 00 00 00 00
 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 8b 80
 30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 01 02 04
 40: 00 00 00 00 01 00 02 7e 00 00 00 00 00 00 00 00
 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 88 00 00 00
 f0: 10 00 00 00 82 10 00 00 43 10 8b 80 00 00 01 01


