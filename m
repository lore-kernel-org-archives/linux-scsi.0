From: Mark Lord <lkml@rtr.ca>
Subject: Re: libata /dev/scd0 problem: mount after burn fails without eject
Date: Tue, 01 May 2007 10:17:53 -0400
Message-ID: <46374C11.1010702@rtr.ca>
References: <20070501135951.GA17072@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070501135951.GA17072@janus>
Sender: linux-ide-owner@vger.kernel.org
To: Frank van Maarseveen <frankvm@frankvm.com>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Forwarding to linux-scsi and linux-ide mailing lists.

Frank van Maarseveen wrote:
> Tested on 2.6.20.6 and 2.6.21.1
> 
> I decided to swich from the old IDE drivers to libata and now there
> seems to be a little but annoying problem: cannot mount an ISO image
> after burning it.
> 
> May  1 14:32:55 kernel: attempt to access beyond end of device
> May  1 14:32:55 kernel: sr0: rw=0, want=68, limit=4
> May  1 14:32:55 kernel: isofs_fill_super: bread failed, dev=sr0, iso_blknum=16, block=16
> 
> an "eject" command seems to fix the state of the PATA DVD writer
> or driver. The problem occurs for burning a CD and for DVD too with
> identical error messages.
> 
> 
> relevant kernel boot messages:
> | ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
> | ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
> | scsi0 : ata_piix
> | ata1.00: ATA-7: ST3120814A, 3.AAJ, max UDMA/100
> | ata1.00: 234441648 sectors, multi 8: LBA48 
> | ata1.00: configured for UDMA/100
> | scsi1 : ata_piix
> | ata2.00: ATAPI, max UDMA/33
> | ata2.01: ATAPI, max UDMA/33
> | ata2.00: configured for UDMA/33
> | ata2.01: configured for UDMA/33
> | scsi 0:0:0:0: Direct-Access     ATA      ST3120814A       3.AA PQ: 0 ANSI: 5
> | SCSI device sda: 234441648 512-byte hdwr sectors (120034 MB)
> | sda: Write Protect is off
> | SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> | SCSI device sda: 234441648 512-byte hdwr sectors (120034 MB)
> | sda: Write Protect is off
> | SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> |  sda: sda1 sda2 sda4
> | sd 0:0:0:0: Attached scsi disk sda
> | sd 0:0:0:0: Attached scsi generic sg0 type 0
> | scsi 1:0:0:0: CD-ROM            HP       DVD Writer 640c  CS30 PQ: 0 ANSI: 5
> | sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
> | Uniform CD-ROM driver Revision: 3.20
> | sr 1:0:0:0: Attached scsi generic sg1 type 5
> | scsi 1:0:1:0: CD-ROM            SAMSUNG  CD-ROM SC-148C   B105 PQ: 0 ANSI: 5
> | sr1: scsi3-mmc drive: 1x/48x cd/rw xa/form2 cdda tray
> | sr 1:0:1:0: Attached scsi generic sg2 type 5
> 
> stripped config (well, as far of I'm sure it shouldn't matter):
> | CONFIG_PM=y
> | CONFIG_PM_LEGACY=y
> | 
> | CONFIG_ACPI=y
> | CONFIG_ACPI_PROCFS=y
> | CONFIG_ACPI_FAN=y
> | CONFIG_ACPI_PROCESSOR=y
> | CONFIG_ACPI_THERMAL=y
> | CONFIG_ACPI_BLACKLIST_YEAR=0
> | CONFIG_ACPI_EC=y
> | CONFIG_ACPI_POWER=y
> | CONFIG_ACPI_SYSTEM=y
> | CONFIG_X86_PM_TIMER=y
> | 
> | CONFIG_PCI=y
> | CONFIG_PCI_GOANY=y
> | CONFIG_PCI_BIOS=y
> | CONFIG_PCI_DIRECT=y
> | CONFIG_PCI_MMCONFIG=y
> | CONFIG_PCIEPORTBUS=y
> | CONFIG_PCIEAER=y
> | CONFIG_HT_IRQ=y
> | CONFIG_ISA_DMA_API=y
> | 
> | CONFIG_PNP=y
> | 
> | CONFIG_PNPACPI=y
> | 
> | CONFIG_CDROM_PKTCDVD=y
> | CONFIG_CDROM_PKTCDVD_BUFFERS=8
> | 
> | CONFIG_IDE=y
> | 
> | CONFIG_RAID_ATTRS=y
> | CONFIG_SCSI=y
> | CONFIG_SCSI_PROC_FS=y
> | 
> | CONFIG_BLK_DEV_SD=y
> | CONFIG_BLK_DEV_SR=y
> | CONFIG_CHR_DEV_SG=y
> | 
> | CONFIG_SCSI_MULTI_LUN=y
> | CONFIG_SCSI_CONSTANTS=y
> | CONFIG_SCSI_LOGGING=y
> | 
> | CONFIG_SCSI_SPI_ATTRS=y
> | 
> | CONFIG_ATA=y
> | CONFIG_SATA_AHCI=y
> | CONFIG_ATA_PIIX=y
> | CONFIG_SATA_INTEL_COMBINED=y
> | CONFIG_SATA_ACPI=y
> | CONFIG_PATA_SERVERWORKS=y
> 
> 
> lspci:
> 00:00.0 Host bridge: Intel Corporation 82845G/GL[Brookdale-G]/GE/PE DRAM Controller/Host-Hub Interface (rev 01)
> 00:01.0 PCI bridge: Intel Corporation 82845G/GL[Brookdale-G]/GE/PE Host-to-AGP Bridge (rev 01)
> 00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 01)
> 00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 01)
> 00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 01)
> 00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 01)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 81)
> 00:1f.0 ISA bridge: Intel Corporation 82801DB/DBL (ICH4/ICH4-L) LPC Interface Bridge (rev 01)
> 00:1f.1 IDE interface: Intel Corporation 82801DB (ICH4) IDE Controller (rev 01)
> 00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 01)
> 00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 01)
> 01:00.0 VGA compatible controller: nVidia Corporation NV18 [GeForce4 MX 440 AGP 8x] (rev a2)
> 02:0c.0 Ethernet controller: Intel Corporation 82541PI Gigabit Ethernet Controller (rev 05)
> 
> lspci -v -v -v for IDE
> 00:1f.1 IDE interface: Intel Corporation 82801DB (ICH4) IDE Controller (rev 01) (prog-if 8a [Master SecP PriP])
>         Subsystem: Dell Unknown device 0142
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 17
>         Region 0: I/O ports at 01f0 [size=8]
>         Region 1: I/O ports at 03f4 [size=1]
>         Region 2: I/O ports at 0170 [size=8]
>         Region 3: I/O ports at 0374 [size=1]
>         Region 4: I/O ports at ffa0 [size=16]
>         Region 5: Memory at 50100000 (32-bit, non-prefetchable) [size=1K]
> 

