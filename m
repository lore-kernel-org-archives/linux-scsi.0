From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: mpt fusion broken sometime since 2.6.24
Date: Tue, 17 Feb 2009 18:28:26 -0800
Message-ID: <499B724A.2040408@kernel.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>  <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>  <20090217230050.GG16841@parisc-linux.org>  <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm> <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com> <alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm> <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:47251 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbZBRC3H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 21:29:07 -0500
In-Reply-To: <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@lang.hm
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

david@lang.hm wrote:
> On Tue, 17 Feb 2009, Yinghai Lu wrote:
> 
>> david@lang.hm wrote:
>>> On Tue, 17 Feb 2009, Yinghai Lu wrote:
>>>
>>>> david@lang.hm wrote:
>>>>> On Tue, 17 Feb 2009, Yinghai Lu wrote:
>>>>>
>>>>>> Subject: Re: mpt fusion broken sometime since 2.6.24
>>>>>>
>>>>>> On Tue, Feb 17, 2009 at 3:07 PM,  <david@lang.hm> wrote:
>>>>>>> On Tue, 17 Feb 2009, Matthew Wilcox wrote:
>>>>>>>
>>>>>>>> On Tue, Feb 17, 2009 at 01:44:55PM -0800, david@lang.hm wrote:
>>>>>>>>>
>>>>>>>>> I got a picture of the failed boot at
>>>>>>>>> http://linux.lang.hm/linux/IMG00052.jpg
>>>>>>>>
>>>>>>>> The PCI-MSI line is probably indicative.  Can you try booting with:
>>>>>>>>
>>>>>>>> mptbase.mpt_msi_enable_sas=0
>>>>>>>>
>>>>>>>> and also send us an lspci -v so we can update the blacklist?
>>>>>>>
>>>>>>> is that disabling SAS for this system? if so, that's the wrong thing
>>>>>>> to do
>>>>>>> (the drives are SAS)
>>>>>>>
>>>>>> it only disable MSI with that mptsas.
>>>>>> and mptsas will use ioapic routing.
>>>>>>
>>>>>> can you post whole bootlog?
>>>>>
>>>>> unfortunantly it's booting from CD and the only drives in the
>>>>> system are
>>>>> the ones that are not being accessed.
>>>>
>>>> i mean with kernel before 2.6.24..
>>>
>>> Ok, attached.
>>>
>>
>> so your lsi 1068 is under 8132... need to double check if that chip
>> really support MSI.
> 

just check 
[   24.921006] calling  mptsas_init+0x0/0x119 @ 1
[   24.925443] Fusion MPT SAS Host driver 3.04.07
[   24.929928] mptsas 0000:0c:04.0: PCI INT A -> GSI 56 (level, low) -> IRQ 56
[   24.936888] mptsas 0000:0c:04.0: using 64bit DMA mask
[   24.941931] mptsas 0000:0c:04.0: using 64bit consistent DMA mask
[   24.948099] mptbase: ioc0: Initiating bringup
[   25.660009] ioc0: LSISAS1064 A3: Capabilities={Initiator}
[   25.665461]   alloc irq_desc for 83 on cpu 0 node 0
[   25.668374]   alloc kstat_irqs on cpu 0 node 0
[   25.674778] mptsas 0000:0c:04.0: irq 83 for MSI/MSI-X
[   25.679826] mptbase: ioc0: PCI-MSI enabled
[   46.540010] mptbase: ioc0: Initiating recovery
[   59.330211] scsi2 : ioc0: LSISAS1064 A3, FwRev=01175a00h, Ports=1, MaxQ=286, IRQ=83
[   59.357423] scsi 2:0:0:0: Direct-Access     SEAGATE  ST973401LSUN72G  0556 PQ: 0 ANSI: 3
[   59.367116] sd 2:0:0:0: [sda] 143374738 512-byte hardware sectors: (73.4 GB/68.3 GiB)
[   59.376061] sd 2:0:0:0: [sda] Write Protect is off
[   59.380849] sd 2:0:0:0: [sda] Mode Sense: e3 00 10 08
[   59.387169] sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   59.396296] sd 2:0:0:0: [sda] 143374738 512-byte hardware sectors: (73.4 GB/68.3 GiB)
[   59.405237] sd 2:0:0:0: [sda] Write Protect is off
[   59.410025] sd 2:0:0:0: [sda] Mode Sense: e3 00 10 08
[   59.416349] sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA


that MSI does work on one system lsi sas...under PCI-X
             +-10.0-[0000:0b]--+-01.0  Intel Corporation 82546EB Gigabit Ethernet Controller (Copper)
             |                 +-01.1  Intel Corporation 82546EB Gigabit Ethernet Controller (Copper)
             |                 +-02.0  Intel Corporation 82546EB Gigabit Ethernet Controller (Copper)
             |                 \-02.1  Intel Corporation 82546EB Gigabit Ethernet Controller (Copper)
             +-10.1  Advanced Micro Devices [AMD] AMD-8132 PCI-X IOAPIC
             +-11.0-[0000:0c]--+-01.0  Intel Corporation 82546GB Gigabit Ethernet Controller
             |                 +-01.1  Intel Corporation 82546GB Gigabit Ethernet Controller
             |                 +-02.0  Intel Corporation 82546GB Gigabit Ethernet Controller
             |                 +-02.1  Intel Corporation 82546GB Gigabit Ethernet Controller
             |                 \-04.0  LSI Logic / Symbios Logic SAS1064 PCI-X Fusion-MPT SAS


0c:04.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064 PCI-X Fusion-MPT SAS (rev 02)
        Subsystem: LSI Logic / Symbios Logic Device 3060
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 72 (16000ns min, 2500ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 83
        Region 0: I/O ports at b800 [disabled] [size=256]
        Region 1: Memory at fe57c000 (64-bit, non-prefetchable) [size=16K]
        Region 3: Memory at fe560000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at fe200000 [disabled] [size=2M]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+ Count=1/1 Enable+
                Address: 00000000fee04000  Data: 40aa
        Capabilities: [68] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=1024 OST=4
                Status: Dev=0c:04.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=16 DMCRS=128 RSCEM- 266MHz- 533MHz-
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
                Vector table: BAR=1 offset=00002000
                PBA: BAR=1 offset=00003000
        Kernel driver in use: mptsas
00: 00 10 50 00 56 05 30 02 02 00 00 01 10 48 00 00
10: 01 b8 00 00 04 c0 57 fe 00 00 00 00 04 00 56 fe
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 10 60 30
30: 00 00 20 fe 50 00 00 00 00 00 00 00 0a 01 40 0a
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 98 02 06 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 07 b0 34 10 20 0c 43 13
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 05 68 81 00 00 40 e0 fe
a0: 00 00 00 00 aa 40 00 00 00 00 00 00 00 00 00 00
b0: 11 00 00 00 01 20 00 00 01 30 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


do you have chance to try current tip/master 
http://people.redhat.com/mingo/tip.git/readme.txt
or 2.6.29-rcX
plus following patch?

or can you check if there is update fw for your LSI card?

[PATCH] mpt: fix enable lsi sas to use msi as default

Impact: fix bug

the third param in module_param(,,) is perm instead of default value.
we still need to assign default at first.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/message/fusion/mptbase.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/message/fusion/mptbase.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptbase.c
+++ linux-2.6/drivers/message/fusion/mptbase.c
@@ -90,8 +90,8 @@ module_param(mpt_msi_enable_fc, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
 		controllers (default=0)");
 
-static int mpt_msi_enable_sas;
-module_param(mpt_msi_enable_sas, int, 1);
+static int mpt_msi_enable_sas = 1;
+module_param(mpt_msi_enable_sas, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
 		controllers (default=1)");
 
