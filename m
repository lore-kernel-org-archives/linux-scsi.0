From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Sun, 22 Feb 2009 14:07:11 -0800
Message-ID: <49A1CC8F.4040202@kernel.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200902221308.55053.prakash@punnoor.de> <m1iqn2ein5.fsf@fess.ebiederm.org> <200902221617.21621.prakash@punnoor.de> <49A1C790.1030303@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <49A1C790.1030303@kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: Prakash Punnoor <prakash@punnoor.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Robert Hancock <hancockrwd@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Yinghai Lu wrote:
> your system have one HT chain c51->mcp51
> 
> BIOS enabled HT-MSI on c51, and hda ...
> it seems pci quirks should not be used enable HT MSI on mcp51 again...
> 
another explanation:

00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
Subsystem: ASUSTeK Computer Inc. Device 81c0
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Capabilities: [44] HyperTransport: Slave or Primary Interface
Command: BaseUnitID=9 UnitCnt=15 MastHost- DefDir- DUL-
Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
Link Config 0: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
Revision ID: 1.03
Link Frequency 0: 800MHz
Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
Link Frequency 1: 200MHz
Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
Prefetchable memory behind bridge Upper: 00-00
Bus Number: 00
Capabilities: [e0] HyperTransport: MSI Mapping Enable- Fixed-
Mapping Address Base: 00000000fee00000

00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a2)
Subsystem: ASUSTeK Computer Inc. Device 81cb
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
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


nv_msi_ht_cap_quirk need some rework

static void __devinit nv_msi_ht_cap_quirk(struct pci_dev *dev)
{
        struct pci_dev *host_bridge;
        int pos, ttl = 48;

        /*
         * HT MSI mapping should be disabled on devices that are below
         * a non-Hypertransport host bridge. Locate the host bridge...
         */
        host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
        if (host_bridge == NULL) {
                dev_warn(&dev->dev,
                         "nv_msi_ht_cap_quirk didn't locate host bridge\n");
                return;
        }

        pos = pci_find_ht_capability(host_bridge, HT_CAPTYPE_SLAVE);
        if (pos != 0) {
                /* Host bridge is to HT */
                ht_enable_msi_mapping(dev);
                return;
        }


in c51-mcp51 case, for 00:10.1, host bridge should be 00:09.0 (mcp51) instead of 00:00.0 (c51)
and ht msi for 00:10.1 is already enabled, dev 00:09.0 should not be enabled HT msi again.

YH
