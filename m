From: Marco =?iso-8859-1?Q?Gru=DF?= <kork.test@gmail.com>
Subject: Adaptec 1405 and mvsas
Date: Fri, 4 Sep 2009 16:14:13 +0200
Message-ID: <20090904141413.GA29006@hydra2.LF.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hydra2.LF.net ([212.9.190.51]:45550 "EHLO hydra2.LF.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894AbZIDOeH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Sep 2009 10:34:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I recently acquired an Adaptec 1405 SAS/SATA HBA.

While there is a closed-source driver by Adaptec, called adpinv, I'd of
course like to get it to work with open drivers.

A lspci -v reveals that the controller is actually using a Marvell chip:

02:00.0 Serial Attached SCSI controller: Adaptec Device 0450 (rev 02)
         Subsystem: Marvell Technology Group Ltd. Device 6440

02:00.0 0107: 9005:0450 (rev 02)
         Subsystem: 11ab:6440

(The output of lspci -vv is attached below)

So I simply added an entry for this PCI id to mvsas.c:

static struct pci_device_id __devinitdata mvs_pci_table[] = {
         { PCI_VDEVICE(MARVELL, 0x6320), chip_6320 },
         { PCI_VDEVICE(MARVELL, 0x6340), chip_6440 },
         {
                 .vendor         = PCI_VENDOR_ID_MARVELL,
                 .device         = 0x6440,
                 .subvendor      = PCI_ANY_ID,
                 .subdevice      = 0x6480,
                 .class          = 0,
                 .class_mask     = 0,
                 .driver_data    = chip_6480,
         },
         { PCI_VDEVICE(MARVELL, 0x6440), chip_6440 },
         { PCI_VDEVICE(MARVELL, 0x6480), chip_6480 },
+        { PCI_VDEVICE(ADAPTEC2, 0x0450), chip_6440 },

         { }     /* terminate list */
};

...with limited success:

Aug 29 17:22:54 athlon kernel: mvsas 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Aug 29 17:22:54 athlon kernel: mvsas 0000:02:00.0: setting latency timer to 64
Aug 29 17:22:56 athlon kernel: mvsas 0000:02:00.0: phy[2] Get Attached Address 0x2 , SAS Address 0x5005043011AB0000
Aug 29 17:22:56 athlon kernel: mvsas 0000:02:00.0: Rate = 9 , type = 1
Aug 29 17:22:56 athlon kernel: mvsas 0000:02:00.0: phy[3] Get Attached Address 0x3 , SAS Address 0x5005043011AB0000
Aug 29 17:22:56 athlon kernel: mvsas 0000:02:00.0: Rate = 8 , type = 1
Aug 29 17:22:56 athlon kernel: scsi4 : mvsas
Aug 29 17:22:56 athlon kernel: mvsas 0000:02:00.0: version 0.5.2
Aug 29 17:22:56 athlon kernel: mvsas 0000:02:00.0: 4 phys, addr 5005043011ab0000
Aug 29 17:22:56 athlon kernel: sas: phy-4:2 added to port-4:0, phy_mask:0x4 (               2)
Aug 29 17:22:56 athlon kernel: sas: phy-4:3 added to port-4:1, phy_mask:0x8 (               3)
Aug 29 17:22:56 athlon kernel: sas: DOING DISCOVERY on port 0, pid:6916
Aug 29 17:22:56 athlon kernel: sas: sas_ata_phy_reset: Unable to reset I T nexus?
Aug 29 17:22:56 athlon kernel: sas: sas_ata_phy_reset: Found ATA device.
Aug 29 17:22:56 athlon kernel: ata5.00: ATA-8: OCZ CORE_SSD, 02.10103, max UDMA/100
Aug 29 17:22:56 athlon kernel: ata5.00: 59047936 sectors, multi 0: LBA
Aug 29 17:22:56 athlon kernel: ata5.00: configured for UDMA/100
Aug 29 17:22:56 athlon kernel: scsi 4:0:0:0: Direct-Access     ATA      OCZ CORE_SSD     02.1 PQ: 0 ANSI: 5
Aug 29 17:22:56 athlon kernel: sd 4:0:0:0: Attached scsi generic sg3 type 0
Aug 29 17:22:56 athlon kernel: sas: DONE DISCOVERY on port 0, pid:6916, result:0
Aug 29 17:22:56 athlon kernel: sas: DOING DISCOVERY on port 1, pid:6916
Aug 29 17:22:56 athlon kernel: sd 4:0:0:0: [sdd] 59047936 512-byte hardware sectors: (30.2 GB/28.1 GiB)
Aug 29 17:22:56 athlon kernel: sd 4:0:0:0: [sdd] Write Protect is off
Aug 29 17:22:56 athlon kernel: sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Aug 29 17:22:56 athlon kernel: sd 4:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Aug 29 17:22:56 athlon kernel:  sdd:<5>sas: sas_ata_phy_reset: Unable to reset I T nexus?
Aug 29 17:22:56 athlon kernel: sas: sas_ata_phy_reset: Found ATAPI device.
Aug 29 17:22:56 athlon kernel: ata6.00: ATAPI: HL-DT-ST DVDRAM GH20NS15, IL00, max UDMA/100
Aug 29 17:22:56 athlon kernel: mvsas 0000:02:00.0: RXQ_ERR 30000
Aug 29 17:22:56 athlon kernel: mvsas 0000:02:00.0: ATTN 80000
Aug 29 17:22:56 athlon kernel: ata6.00: configured for UDMA/100
Aug 29 17:22:56 athlon kernel: scsi 4:0:1:0: CD-ROM            HL-DT-ST DVDRAM GH20NS15  IL00 PQ: 0 ANSI: 5
Aug 29 17:22:56 athlon kernel:  sdd1
Aug 29 17:22:56 athlon kernel: sd 4:0:0:0: [sdd] Attached SCSI disk
Aug 29 17:22:56 athlon kernel: sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Aug 29 17:22:56 athlon kernel: Uniform CD-ROM driver Revision: 3.20
Aug 29 17:22:56 athlon kernel: sr 4:0:1:0: Attached scsi CD-ROM sr0
Aug 29 17:22:56 athlon kernel: sr 4:0:1:0: Attached scsi generic sg4 type 5
Aug 29 17:22:56 athlon kernel: sas: DONE DISCOVERY on port 1, pid:6916, result:0

I can actually use both devices (a (slow) OCZ SSD, and a dvd recorder),
but even during initialization, and afterwards, I get tons and tons of
these:

Aug 29 17:45:17 athlon kernel: mvsas 0000:02:00.0: RXQ_ERR 20000
Aug 29 17:45:17 athlon kernel: 00000000 : 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 : ................

Also, I don't like the "sas_ata_phy_reset: Unable to reset I T nexus?"
entries...

BTW: The driver loads fine on 2.6.30.5 x86_64, but oopses on
2.6.27.5 x86_64 (it still "works" anyway).

Unfortunately, my knowledge of Linux driver debugging ends here...
If there's anything I can do to help make this card work flawlessly,
I'd be glad to try it.

Thanks!
Marco

P.S.: lspci -vv goes here:

02:00.0 0107: 9005:0450 (rev 02)
        Subsystem: 11ab:6440
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 4 bytes
        Interrupt: pin A routed to IRQ 19
        Region 2: I/O ports at ee00 [size=128]
        Region 4: Memory at fdcff000 (64-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at fdf00000 [disabled] [size=256K]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Count=1/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 2048 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <256ns, L1 unlimited
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel driver in use: mvsas
