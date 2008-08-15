From: Vlad Seliverstov <vseliverstov@yandex-team.ru>
Subject: Re: Strange hotswap behaviour on 2.6.26-5 kernel with SAS1064ET
Date: Fri, 15 Aug 2008 20:34:18 +0400
Message-ID: <48A5B00A.8060307@yandex-team.ru>
References: <48A47EA2.2020508@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cavolo.yandex.ru ([87.250.244.45]:39907 "EHLO cavolo.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759492AbYHOQeV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2008 12:34:21 -0400
Received: from [87.250.250.12] (behemot.yandex.ru [87.250.250.12])
	by cavolo.yandex.ru (8.14.2/8.14.2) with ESMTP id m7FGYIgt029635
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 20:34:18 +0400 (MSD)
	(envelope-from vseliverstov@yandex-team.ru)
In-Reply-To: <48A47EA2.2020508@yandex-team.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

It's definitely a bug, because when I tried this with 2.6.22-14-server stock Ubuntu kernel, it worked as expected. Even hotplug events were handled correctly, so I just pulled disk off, and inserted another without exporting it from system. Like this:

# dmesg | tail -16
[  538.313459] mptsas: ioc0: removing ssp device, channel 0, id 9, phy 0
[  538.313591] sd 0:0:4:0: [sda] Synchronizing SCSI cache
[  538.316497] sd 0:0:4:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  558.944876] mptsas: ioc0: attaching ssp device, channel 0, id 4, phy 0
[  558.945896] scsi 0:0:5:0: Direct-Access     FUJITSU  MBA3147RC        0103 PQ: 0 ANSI: 5
[  558.947265] sd 0:0:5:0: [sda] 287277984 512-byte hardware sectors (147086 MB)
[  558.949117] sd 0:0:5:0: [sda] Write Protect is off
[  558.949119] sd 0:0:5:0: [sda] Mode Sense: bf 00 00 08
[  558.950360] sd 0:0:5:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  558.951024] sd 0:0:5:0: [sda] 287277984 512-byte hardware sectors (147086 MB)
[  558.952876] sd 0:0:5:0: [sda] Write Protect is off
[  558.952878] sd 0:0:5:0: [sda] Mode Sense: bf 00 00 08
[  558.954126] sd 0:0:5:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  558.954128]  sda: sda1
[  558.964969] sd 0:0:5:0: [sda] Attached SCSI disk
[  558.964990] sd 0:0:5:0: Attached scsi generic sg0 type 0

# uname -a
Linux soap.bsadm-d 2.6.22-14-server #1 SMP Fri Aug 15 20:08:01 MSD 2008 x86_64 GNU/Linux

Vlad Seliverstov wrote:
> Hi.
> 
> I'm experiencing some strange problem with hotswap on my linux box with 
> SAS1064ET SAS controller and 2.6.26-5 kernel. When I'm trying to remove 
> disk from system, like this:
> 
> # systool -b scsi
> Bus = "scsi"
> 
>  Device = "0:0:0:0"
>  Device = "0:0:1:0"
>  Device = "0:0:2:0"
>  Device = "0:0:3:0"
>  Device = "1:0:0:0"
> 
> # echo 1 > 
> /sys/class/scsi_host/host0/device/port-0\:0/end_device-0\:0/target0\:0\:0/0\:0\:0\:0/delete 
> 
> # systool -b scsi
> Bus = "scsi"
> 
>  Device = "0:0:1:0"
>  Device = "0:0:2:0"
>  Device = "0:0:3:0"
>  Device = "1:0:0:0"
> 
> It's OK. Disk successfully removed. When I'm trying to rescan bus 
> without physical removal of this disk like this:
> 
> # echo "- - -" > /sys/class/scsi_host/host0/scan
> It's OK again. Disk successfully attached:
> 
> # systool -b scsi
> Bus = "scsi"
> 
>  Device = "0:0:0:0"
>  Device = "0:0:1:0"
>  Device = "0:0:2:0"
>  Device = "0:0:3:0"
>  Device = "1:0:0:0"
> 
> But when I detach disk from system, physically remove it from box, swap 
> it with another one and try to attach it like:
> 
> # echo "- - -" > /sys/class/scsi_host/host0/scan
> 
> Nothing happens. Linux doesn't see any new hard drives attached to this 
> host.
> Interesting, that if I will swap disk drives again (inserting an old 
> one), and rescan bus - It'll be OK again, and disk will be successfully 
> attached.
> Are there any probability of kernel bug?
> 
> I tried 2.6.24-19 and 2.6.26-5 kernels from Ubuntu distribution and got 
> the same on both of them.
> 
> Here is some info about my box:
> 
> # uname -a
> Linux soap 2.6.26-5-server #1 SMP Tue Aug 12 22:15:37 MSD 2008 x86_64 
> GNU/Linux
> 
> # lspci -nn
> 00:00.0 Host bridge [0600]: Intel Corporation 5000P Chipset Memory 
> Controller Hub [8086:25d8] (rev b1)
> 00:02.0 PCI bridge [0604]: Intel Corporation 5000 Series Chipset PCI 
> Express x8 Port 2-3 [8086:25f7] (rev b1)
> 00:04.0 PCI bridge [0604]: Intel Corporation 5000 Series Chipset PCI 
> Express x8 Port 4-5 [8086:25f8] (rev b1)
> 00:06.0 PCI bridge [0604]: Intel Corporation 5000 Series Chipset PCI 
> Express x8 Port 6-7 [8086:25f9] (rev b1)
> 00:08.0 System peripheral [0880]: Intel Corporation 5000 Series Chipset 
> DMA Engine [8086:1a38] (rev b1)
> 00:10.0 Host bridge [0600]: Intel Corporation 5000 Series Chipset FSB 
> Registers [8086:25f0] (rev b1)
> 00:10.1 Host bridge [0600]: Intel Corporation 5000 Series Chipset FSB 
> Registers [8086:25f0] (rev b1)
> 00:10.2 Host bridge [0600]: Intel Corporation 5000 Series Chipset FSB 
> Registers [8086:25f0] (rev b1)
> 00:11.0 Host bridge [0600]: Intel Corporation 5000 Series Chipset 
> Reserved Registers [8086:25f1] (rev b1)
> 00:13.0 Host bridge [0600]: Intel Corporation 5000 Series Chipset 
> Reserved Registers [8086:25f3] (rev b1)
> 00:15.0 Host bridge [0600]: Intel Corporation 5000 Series Chipset FBD 
> Registers [8086:25f5] (rev b1)
> 00:16.0 Host bridge [0600]: Intel Corporation 5000 Series Chipset FBD 
> Registers [8086:25f6] (rev b1)
> 00:1c.0 PCI bridge [0604]: Intel Corporation 631xESB/632xESB/3100 
> Chipset PCI Express Root Port 1 [8086:2690] (rev 09)
> 00:1d.0 USB Controller [0c03]: Intel Corporation 631xESB/632xESB/3100 
> Chipset UHCI USB Controller #1 [8086:2688] (rev 09)
> 00:1d.1 USB Controller [0c03]: Intel Corporation 631xESB/632xESB/3100 
> Chipset UHCI USB Controller #2 [8086:2689] (rev 09)
> 00:1d.2 USB Controller [0c03]: Intel Corporation 631xESB/632xESB/3100 
> Chipset UHCI USB Controller #3 [8086:268a] (rev 09)
> 00:1d.3 USB Controller [0c03]: Intel Corporation 631xESB/632xESB/3100 
> Chipset UHCI USB Controller #4 [8086:268b] (rev 09)
> 00:1d.7 USB Controller [0c03]: Intel Corporation 631xESB/632xESB/3100 
> Chipset EHCI USB2 Controller [8086:268c] (rev 09)
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge 
> [8086:244e] (rev d9)
> 00:1f.0 ISA bridge [0601]: Intel Corporation 631xESB/632xESB/3100 
> Chipset LPC Interface Controller [8086:2670] (rev 09)
> 00:1f.1 IDE interface [0101]: Intel Corporation 631xESB/632xESB IDE 
> Controller [8086:269e] (rev 09)
> 00:1f.3 SMBus [0c05]: Intel Corporation 631xESB/632xESB/3100 Chipset 
> SMBus Controller [8086:269b] (rev 09)
> 01:00.0 PCI bridge [0604]: Intel Corporation 6311ESB/6321ESB PCI Express 
> Upstream Port [8086:3500] (rev 01)
> 01:00.3 PCI bridge [0604]: Intel Corporation 6311ESB/6321ESB PCI Express 
> to PCI-X Bridge [8086:350c] (rev 01)
> 02:00.0 PCI bridge [0604]: Intel Corporation 6311ESB/6321ESB PCI Express 
> Downstream Port E1 [8086:3510] (rev 01)
> 02:02.0 PCI bridge [0604]: Intel Corporation 6311ESB/6321ESB PCI Express 
> Downstream Port E3 [8086:3518] (rev 01)
> 04:00.0 Ethernet controller [0200]: Intel Corporation 80003ES2LAN 
> Gigabit Ethernet Controller (Copper) [8086:1096] (rev 01)
> 04:00.1 Ethernet controller [0200]: Intel Corporation 80003ES2LAN 
> Gigabit Ethernet Controller (Copper) [8086:1096] (rev 01)
> 06:00.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic 
> SAS1064ET PCI-Express Fusion-MPT SAS [1000:0056] (rev 08)
> 08:00.0 PCI bridge [0604]: Intel Corporation 6702PXH PCI Express-to-PCI 
> Bridge A [8086:032c] (rev 09)
> 0a:01.0 VGA compatible controller [0300]: ATI Technologies Inc ES1000 
> [1002:515e] (rev 02)
> 
> # lsmod
> Module                  Size  Used by
> sbs                    22544  0 battery                21512  0 
> sbshc                  14592  1 sbs
> ac                     13576  0 video                  29588  0 
> output                 12032  1 video
> iptable_filter         11648  0 ip_tables              28816  1 
> iptable_filter
> x_tables               31624  1 ip_tables
> ext3                  146064  1 jbd                    61992  1 ext3
> parport_pc             45096  0 lp                     19460  0 
> parport                49456  2 parport_pc,lp
> loop                   26636  0 snd_pcsp               19708  0 
> snd_pcm                98184  1 snd_pcsp
> snd_timer              33936  1 snd_pcm
> snd                    76872  3 snd_pcsp,snd_pcm,snd_timer
> serio_raw              14596  0 soundcore              16672  1 snd
> iTCO_wdt               20688  0 e1000e                133284  0 
> psmouse                51100  0 snd_page_alloc         17808  1 snd_pcm
> iTCO_vendor_support    12932  1 iTCO_wdt
> ipv6                  308456  44 container              12544  0 
> button                 15904  0 shpchp                 41760  0 
> pci_hotplug            39352  1 shpchp
> i5000_edac             18824  0 edac_core              58776  3 i5000_edac
> joydev                 20864  0 evdev                  20480  0 
> ext2                   80400  1 mbcache                17412  2 ext3,ext2
> pata_acpi              13440  0 sg                     44768  0 
> sd_mod                 36160  8 ata_piix               29316  1 
> usbhid                 40288  0 hid                    56000  1 usbhid
> ata_generic            14212  0 floppy                 73192  0 
> e1000                 143680  0 libata                191968  3 
> pata_acpi,ata_piix,ata_generic
> mptsas                 44816  3 dock                   18592  1 libata
> ehci_hcd               46988  0 uhci_hcd               34208  0 
> mptscsih               49408  1 mptsas
> mptbase                91364  2 mptsas,mptscsih
> scsi_transport_sas     45184  1 mptsas
> usbcore               172696  4 usbhid,ehci_hcd,uhci_hcd
> scsi_mod              179576  6 
> sg,sd_mod,libata,mptsas,mptscsih,scsi_transport_sas
> raid10                 30848  1 raid456               138272  0 
> async_xor              12800  1 raid456
> async_memcpy           11008  1 raid456
> async_tx               16500  3 raid456,async_xor,async_memcpy
> xor                    14096  2 raid456,async_xor
> raid1                  31488  0 raid0                  15488  0 
> multipath              16512  0 linear                 13568  0 
> md_mod                 94884  7 raid10,raid456,raid1,raid0,multipath,linear
> thermal                27680  0 processor              50496  1 thermal
> fan                    13576  0 fbcon                  51200  0 
> tileblit               11392  1 fbcon
> font                   17152  1 fbcon
> bitblit                14464  1 fbcon
> softcursor             10496  1 bitblit
> uvesafb                38184  0 cn                     17324  1 uvesafb
> fuse                   66112  1
> 



-- 
Vlad Seliverstov

