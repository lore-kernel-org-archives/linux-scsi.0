From: Chris Pearson <chris-linux-scsi@twock.com>
Subject: /dev/megadev0 missing with 2.6.26 kernel megaraid_mm
Date: Sun, 17 May 2009 18:28:34 +0100
Message-ID: <20090517172833.GA9759@lamity.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lamity.org ([212.13.197.69]:43369 "HELO lamity.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751822AbZEQRfT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 May 2009 13:35:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have a Dell PowerEdge 2850 that was running Debian with a 2.4 kernel.
I have just upgraded it to 2.6.26 and as part of that upgrade also begun
using udev.  I am unsure whether this is a udev problem or a kernel
problem.

With 2.4 I used to have a block device "megadev" in /proc/devices which
the Dell/LSI scripts use to communicate with the PERC.  However, since
the upgrade I have no block device and udev is not creating
/dev/megadev0.

The array is functioning fine.  Would anyone be able to offer any
suggestions about how to get /dev/megadev0 back so I can use the
monitoring tools again?  Some potentially useful output below.

Thanks,
Chris

`lspci -vv` gives:
02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller 4 (rev 06)
        Subsystem: Dell PowerEdge Expandable RAID Controller 4e/Di
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping+ SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (32000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 46
        Region 0: Memory at d80f0000 (32-bit, prefetchable) [size=64K]
        Region 2: Memory at dfdc0000 (32-bit, non-prefetchable) [size=256K]
        Expansion ROM at dfe00000 [disabled] [size=128K]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=512 OST=4
                Status: Dev=02:0e.0 64bit+ 133MHz+ SCD- USC- DC=bridge DMMRBC=1024 DMOST=4 DMCRS=16 RSCEM- 266MHz- 533MHz-
        Kernel driver in use: megaraid
        Kernel modules: megaraid_mbox

kern.log:
May 16 13:22:22 sylvester kernel: [   26.411756] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
May 16 13:22:22 sylvester kernel: [   27.824449] SCSI subsystem initialized
May 16 13:22:22 sylvester kernel: [   28.180452] usbcore: registered new interface driver usbfs
May 16 13:22:22 sylvester kernel: [   29.200283] usbcore: registered new interface driver hub
May 16 13:22:22 sylvester kernel: [   29.708285] usbcore: registered new device driver usb
May 16 13:22:22 sylvester kernel: [   30.633321] Uniform Multi-Platform E-IDE driver
May 16 13:22:22 sylvester kernel: [   31.263012] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
May 16 13:22:22 sylvester kernel: [   32.799058] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
May 16 13:22:22 sylvester kernel: [   32.799058] Copyright (c) 1999-2006 Intel Corporation.
May 16 13:22:22 sylvester kernel: [   33.902627] ACPI: PCI Interrupt 0000:06:07.0[A] -> GSI 64 (level, low) -> IRQ 64
May 16 13:22:22 sylvester kernel: [   35.003348] FDC 0 is a National Semiconductor PC87306
May 16 13:22:22 sylvester kernel: [   35.059348] e1000: 0000:06:07.0: e1000_probe: (PCI:66MHz:32-bit) 00:11:43:37:a1:06
May 16 13:22:22 sylvester kernel: [   35.239348] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
May 16 13:22:22 sylvester kernel: [   35.239348] ACPI: PCI Interrupt 0000:07:08.0[A] -> GSI 65 (level, low) -> IRQ 65
May 16 13:22:22 sylvester kernel: [   35.295348] e1000: 0000:07:08.0: e1000_probe: (PCI:66MHz:32-bit) 00:11:43:37:a1:07
May 16 13:22:22 sylvester kernel: [   35.475349] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
May 16 13:22:22 sylvester kernel: [   42.896585] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
May 16 13:22:22 sylvester kernel: [   43.570436] megaraid: probe new device 0x1028:0x0013:0x1028:0x016d: bus 2:slot 14:func 0
May 16 13:22:22 sylvester kernel: [   44.345373] ACPI: PCI Interrupt 0000:02:0e.0[A] -> GSI 46 (level, low) -> IRQ 46
May 16 13:22:22 sylvester kernel: [   45.057324] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 23
May 16 13:22:22 sylvester kernel: [   45.953584] PCI: Setting latency timer of device 0000:00:1d.7 to 64
May 16 13:22:22 sylvester kernel: [   45.953591] ehci_hcd 0000:00:1d.7: EHCI Host Controller
May 16 13:22:22 sylvester kernel: [   46.452736] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
May 16 13:22:22 sylvester kernel: [   47.682627] ehci_hcd 0000:00:1d.7: debug port 1
May 16 13:22:22 sylvester kernel: [   48.115473] PCI: cache line size of 128 is not supported by device 0000:00:1d.7
May 16 13:22:22 sylvester kernel: [   48.115493] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xdff00000
May 16 13:22:22 sylvester kernel: [   48.767471] USB Universal Host Controller Interface driver v3.0
May 16 13:22:22 sylvester kernel: [   49.340882] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
May 16 13:22:22 sylvester kernel: [   50.759986] usb usb1: configuration #1 chosen from 1 choice
May 16 13:22:22 sylvester kernel: [   50.763985] megaraid: fw version:[516A] bios version:[H418]
May 16 13:22:22 sylvester kernel: [   51.824111] hub 1-0:1.0: USB hub found
May 16 13:22:22 sylvester kernel: [   52.180007] scsi0 : LSI Logic MegaRAID driver
May 16 13:22:22 sylvester kernel: [   52.596565] hub 1-0:1.0: 6 ports detected
May 16 13:22:22 sylvester kernel: [   52.656923] scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
May 16 13:22:22 sylvester kernel: [   52.660034] scsi 0:0:6:0: Processor         PE/PV    1x6 SCSI BP      1.0  PQ: 0 ANSI: 2
May 16 13:22:22 sylvester kernel: [   55.601105] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
May 16 13:22:22 sylvester kernel: [   55.500099] scsi[0]: scanning scsi channel 1 [Phy 1] for non-raid devices
May 16 13:22:22 sylvester kernel: [   56.893203] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 16 13:22:22 sylvester kernel: [   57.581440] usb usb1: Product: EHCI Host Controller
May 16 13:22:22 sylvester kernel: [   57.581440] usb 1-3: new high speed USB device using ehci_hcd and address 2
May 16 13:22:22 sylvester kernel: [   59.548564] usb usb1: Manufacturer: Linux 2.6.26-2-686-bigmem ehci_hcd
May 16 13:22:22 sylvester kernel: [   59.089467] usb 1-3: configuration #1 chosen from 1 choice
May 16 13:22:22 sylvester kernel: [   59.089467] hub 1-3:1.0: USB hub found
May 16 13:22:22 sylvester kernel: [   59.089467] hub 1-3:1.0: 2 ports detected
May 16 13:22:22 sylvester kernel: [   60.197362] usb 1-3: New USB device found, idVendor=413c, idProduct=a001
May 16 13:22:22 sylvester kernel: [   60.197362] usb 1-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
May 16 13:22:22 sylvester kernel: [   60.197362] scsi[0]: scanning scsi channel 2 [virtual] for logical drives
May 16 13:22:22 sylvester kernel: [   60.197362] scsi 0:2:0:0: Direct-Access     MegaRAID LD 0 RAID5  279G 516A PQ: 0 ANSI: 2
May 16 13:22:22 sylvester kernel: [   60.197362] scsi 0:2:1:0: Direct-Access     MegaRAID LD 1 RAID0   69G 516A PQ: 0 ANSI: 2
May 16 13:22:22 sylvester kernel: [   70.051871] usb usb1: SerialNumber: 0000:00:1d.7
May 16 13:22:22 sylvester kernel: [   70.578575] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
May 16 13:22:22 sylvester kernel: [   71.021782] scsi 0:0:6:0: Attached scsi generic sg0 type 3
May 16 13:22:22 sylvester kernel: [   71.021782] scsi 0:2:0:0: Attached scsi generic sg1 type 0
May 16 13:22:22 sylvester kernel: [   71.021782] scsi 0:2:1:0: Attached scsi generic sg2 type 0
May 16 13:22:22 sylvester kernel: [   72.862187] PCI: Setting latency timer of device 0000:00:1d.0 to 64
May 16 13:22:22 sylvester kernel: [   72.862202] uhci_hcd 0000:00:1d.0: UHCI Host Controller
May 16 13:22:22 sylvester kernel: [   73.362356] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
May 16 13:22:22 sylvester kernel: [   74.070361] uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000bce0
May 16 13:22:22 sylvester kernel: [   74.622160] usb usb2: configuration #1 chosen from 1 choice
May 16 13:22:22 sylvester kernel: [   75.154276] hub 2-0:1.0: USB hub found
May 16 13:22:22 sylvester kernel: [   75.512799] hub 2-0:1.0: 2 ports detected
May 16 13:22:22 sylvester kernel: [   75.895383] Driver 'sd' needs updating - please use bus_type methods

`lsmod | grep mega` gives:
megaraid_mbox          26800  7
scsi_mod              130092  4 libata,sd_mod,sg,megaraid_mbox
megaraid_mm             9116  1 megaraid_mbox

`cat /proc/devices` gives:
Character devices:
  1 mem
  4 /dev/vc/0
  4 tty
  4 ttyS
  5 /dev/tty
  5 /dev/console
  5 /dev/ptmx
  7 vcs
 10 misc
 13 input
 21 sg
 29 fb
128 ptm
136 pts
180 usb
189 usb_device
251 ipmidev
252 usb_endpoint
253 bsg
254 rtc

Block devices:
  1 ramdisk
  2 fd
  3 ide0
  8 sd
 22 ide1
 65 sd
 66 sd
 67 sd
 68 sd
 69 sd
 70 sd
 71 sd
128 sd
129 sd
130 sd
131 sd
132 sd
133 sd
134 sd
135 sd
254 device-mapper

