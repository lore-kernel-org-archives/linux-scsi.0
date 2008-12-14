From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12223] New: kernel BUG at drivers/pci/intel-iommu.c:1373!
Date: Sun, 14 Dec 2008 09:53:14 -0800 (PST)
Message-ID: <bug-12223-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbYLNRxq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Dec 2008 12:53:46 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBEHrE94008927
	for <linux-scsi@vger.kernel.org>; Sun, 14 Dec 2008 09:53:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12223

           Summary: kernel BUG at drivers/pci/intel-iommu.c:1373!
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.26-gentoo-r4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: john.blbec@centrum.cz
                CC: anil.s.keshavamurthy@intel.com


Latest working kernel version: unknown

Earliest failing kernel version:2.6.26-gentoo-r4

Distribution: gentoo 2008.0

Hardware Environment: see http://rpolasek.webpark.cz/lshw.txt and
http://rpolasek.webpark.cz/lspci.txt

$ cat /proc/version 
Linux version 2.6.26-gentoo-r4 (root@rpc-linux) (gcc version 4.1.2 (Gentoo
4.1.2 p1.1)) #1 SMP Sun Dec 14 12:15:39 CET 2008

# cat /proc/scsi/scsi 
Attached devices:
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: BDDVDRW GGC-H20L Rev: 1.03
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 00
  Vendor: AMCC     Model: 9650SE-4LP DISK  Rev: 3.08
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 01
  Vendor: AMCC     Model: 9650SE-4LP DISK  Rev: 3.08
  Type:   Direct-Access                    ANSI  SCSI revision: 05

Software Environment: see my kernel config at
http://rpolasek.webpark.cz/kernel-config-x86_64-2.6.26-gentoo-r4.txt

$ cat /proc/modules 
nvidia 7804584 26 - Live 0xffffffffa0378000 (P)
ipv6 280648 20 - Live 0xffffffffa0332000
snd_seq_oss 33216 0 - Live 0xffffffffa0328000
snd_seq_midi_event 8832 1 snd_seq_oss, Live 0xffffffffa0324000
snd_seq 57184 4 snd_seq_oss,snd_seq_midi_event, Live 0xffffffffa0315000
snd_seq_device 8596 2 snd_seq_oss,snd_seq, Live 0xffffffffa0311000
snd_pcm_oss 39904 0 - Live 0xffffffffa0306000
snd_mixer_oss 16512 1 snd_pcm_oss, Live 0xffffffffa0300000
rtc_cmos 11512 0 - Live 0xffffffffa02fc000
rtc_core 20100 1 rtc_cmos, Live 0xffffffffa02f6000
rtc_lib 4032 1 rtc_core, Live 0xffffffffa021b000
snd_hda_intel 453976 2 - Live 0xffffffffa0286000
snd_pcm 78856 2 snd_pcm_oss,snd_hda_intel, Live 0xffffffffa0271000
snd_timer 23952 2 snd_seq,snd_pcm, Live 0xffffffffa026a000
thermal 19232 0 - Live 0xffffffffa0264000
processor 31412 1 thermal, Live 0xffffffffa025b000
snd_page_alloc 9872 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0257000
button 8032 0 - Live 0xffffffffa0254000
snd_hwdep 8840 1 snd_hda_intel, Live 0xffffffffa0250000
snd 66312 13
snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_hda_intel,snd_pcm,snd_timer,snd_hwdep,
Live 0xffffffffa023e000
thermal_sys 13120 2 thermal,processor, Live 0xffffffffa0239000
psmouse 42844 0 - Live 0xffffffffa022d000
pcspkr 3520 0 - Live 0xffffffffa022b000
i2c_i801 10396 0 - Live 0xffffffffa0225000
i2c_core 25888 2 nvidia,i2c_i801, Live 0xffffffffa021d000
e1000e 106916 0 - Live 0xffffffffa01ff000
nfs 147320 0 - Live 0xffffffffa01da000
lockd 71760 1 nfs, Live 0xffffffffa01c7000
sunrpc 210440 4 nfs,lockd, Live 0xffffffffa0192000
dm_bbr 11520 0 - Live 0xffffffffa018e000
dm_snapshot 17608 0 - Live 0xffffffffa0188000
dm_mirror 19200 0 - Live 0xffffffffa0182000
dm_log 11268 1 dm_mirror, Live 0xffffffffa017e000
dm_mod 61424 27 dm_bbr,dm_snapshot,dm_mirror,dm_log, Live 0xffffffffa016e000
sbp2 23244 0 - Live 0xffffffffa0167000
ohci1394 32244 0 - Live 0xffffffffa015e000
ieee1394 97976 2 sbp2,ohci1394, Live 0xffffffffa0145000
sl811_hcd 12992 0 - Live 0xffffffffa0140000
usbhid 30048 0 - Live 0xffffffffa0137000
ohci_hcd 25732 0 - Live 0xffffffffa012f000
ssb 44420 1 ohci_hcd, Live 0xffffffffa0123000
pcmcia 38808 1 ssb, Live 0xffffffffa0118000
firmware_class 9408 1 pcmcia, Live 0xffffffffa0114000
pcmcia_core 40740 2 ssb,pcmcia, Live 0xffffffffa0109000
uhci_hcd 24344 0 - Live 0xffffffffa0102000
usb_storage 95552 0 - Live 0xffffffffa00e9000
ehci_hcd 36044 0 - Live 0xffffffffa00df000
usbcore 151000 7 sl811_hcd,usbhid,ohci_hcd,uhci_hcd,usb_storage,ehci_hcd, Live
0xffffffffa00b9000
3w_9xxx 34052 2 - Live 0xffffffffa00af000
mptsas 28368 0 - Live 0xffffffffa00a7000
scsi_transport_sas 37376 1 mptsas, Live 0xffffffffa009c000
mptfc 15624 0 - Live 0xffffffffa0097000
scsi_transport_fc 51140 1 mptfc, Live 0xffffffffa0089000
scsi_tgt 14864 1 scsi_transport_fc, Live 0xffffffffa0084000
mptspi 17040 0 - Live 0xffffffffa007e000
scsi_transport_spi 25664 1 mptspi, Live 0xffffffffa0076000
mptscsih 28864 3 mptsas,mptfc,mptspi, Live 0xffffffffa006d000
mptbase 63076 4 mptsas,mptfc,mptspi,mptscsih, Live 0xffffffffa005c000
sg 32032 0 - Live 0xffffffffa0053000
videobuf_core 21252 0 - Live 0xffffffffa004c000
ata_piix 21060 0 - Live 0xffffffffa0045000
ahci 30472 0 - Live 0xffffffffa003c000
scsi_wait_scan 1984 0 - Live 0xffffffffa003a000
pata_marvell 5120 0 - Live 0xffffffffa0037000
pata_platform 6720 0 - Live 0xffffffffa0034000
pata_mpiix 5636 0 - Live 0xffffffffa0031000
libata 178240 5 ata_piix,ahci,pata_marvell,pata_platform,pata_mpiix, Live
0xffffffffa0004000
dock 10528 1 libata, Live 0xffffffffa0000000

$ cat /proc/iomem 
00000000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000c0000-000dffff : pnp 00:01
000e0000-000fffff : reserved
00100000-ce8d8fff : System RAM
  00200000-00514b65 : Kernel code
  00514b66-00645667 : Kernel data
  006b8000-00707377 : Kernel bss
ce8d9000-ce96cfff : ACPI Non-volatile Storage
ce96d000-cfaf1fff : System RAM
cfaf2000-cfaf3fff : reserved
cfaf4000-cfb89fff : System RAM
cfb8a000-cfbe0fff : ACPI Non-volatile Storage
cfbe1000-cfbe5fff : System RAM
cfbe6000-cfbf1fff : ACPI Tables
cfbf2000-cfbf2fff : System RAM
cfbf3000-cfbfefff : ACPI Tables
cfbff000-cfbfffff : System RAM
cfc00000-cfffffff : reserved
d0000000-dfffffff : PCI Bus 0000:01
  d0000000-dfffffff : 0000:01:00.0
e0000000-e1ffffff : PCI Bus 0000:02
  e0000000-e1ffffff : 0000:02:00.0
    e0000000-e1ffffff : 3w-9xxx
e2000000-e4ffffff : PCI Bus 0000:01
  e2000000-e3ffffff : 0000:01:00.0
    e3000000-e3dfffff : uvesafb
  e4000000-e4ffffff : 0000:01:00.0
    e4000000-e4ffffff : nvidia
e5000000-e50fffff : PCI Bus 0000:04
  e5000000-e5003fff : 0000:04:03.0
  e5004000-e50047ff : 0000:04:03.0
    e5004000-e50047ff : ohci1394
e5100000-e51fffff : PCI Bus 0000:03
  e5100000-e51003ff : 0000:03:00.0
e5200000-e52fffff : PCI Bus 0000:02
  e5200000-e5200fff : 0000:02:00.0
    e5200000-e5200fff : 3w-9xxx
  e5220000-e523ffff : 0000:02:00.0
e5300000-e531ffff : 0000:00:19.0
  e5300000-e531ffff : e1000e
e5320000-e5323fff : 0000:00:1b.0
  e5320000-e5323fff : ICH HD audio
e5324000-e5324fff : 0000:00:19.0
  e5324000-e5324fff : e1000e
e5325000-e53257ff : 0000:00:1f.2
  e5325000-e53257ff : ahci
e5325800-e5325bff : 0000:00:1d.7
  e5325800-e5325bff : ehci_hcd
e5325c00-e5325fff : 0000:00:1a.7
  e5325c00-e5325fff : ehci_hcd
e5326000-e53260ff : 0000:00:1f.3
f0000000-f7ffffff : PCI MMCONFIG 0
  f0000000-f7ffffff : reserved
feb00000-feb03fff : pnp 00:01
fec00000-fec00fff : IOAPIC 0
fed13000-fed13fff : pnp 00:01
fed14000-fed17fff : pnp 00:01
fed18000-fed18fff : pnp 00:01
fed19000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:01
fed20000-fed3ffff : pnp 00:01
fed45000-fed99fff : pnp 00:01
fee00000-fee00fff : Local APIC
ffe00000-ffffffff : reserved
100000000-12fffffff : System RAM

$ cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : ide_generic
01f0-01f7 : ide_generic
02f8-02ff : serial
0376-0376 : ide_generic
03c0-03df : vga+
  03c0-03df : uvesafb
03f6-03f6 : ide_generic
0400-047f : 0000:00:1f.0
  0400-047f : pnp 00:06
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-042f : ACPI GPE0_BLK
    0450-0450 : ACPI PM2_CNT_BLK
0500-053f : 0000:00:1f.0
  0500-053f : pnp 00:06
0680-06ff : pnp 00:06
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus 0000:03
  1000-100f : 0000:03:00.0
    1000-100f : pata_marvell
  1010-1017 : 0000:03:00.0
    1010-1017 : pata_marvell
  1018-101f : 0000:03:00.0
    1018-101f : pata_marvell
  1020-1023 : 0000:03:00.0
    1020-1023 : pata_marvell
  1024-1027 : 0000:03:00.0
    1024-1027 : pata_marvell
2000-2fff : PCI Bus 0000:02
  2000-20ff : 0000:02:00.0
    2000-20ff : 3w-9xxx
3000-3fff : PCI Bus 0000:01
  3000-307f : 0000:01:00.0
4000-401f : 0000:00:1f.3
  4000-401f : i801_smbus
4020-403f : 0000:00:1f.2
  4020-403f : ahci
4040-405f : 0000:00:1d.2
  4040-405f : uhci_hcd
4060-407f : 0000:00:1d.1
  4060-407f : uhci_hcd
4080-409f : 0000:00:1d.0
  4080-409f : uhci_hcd
40a0-40bf : 0000:00:1a.2
  40a0-40bf : uhci_hcd
40c0-40df : 0000:00:1a.1
  40c0-40df : uhci_hcd
40e0-40ff : 0000:00:1a.0
  40e0-40ff : uhci_hcd
4400-441f : 0000:00:19.0
  4400-441f : e1000e
4420-4427 : 0000:00:1f.2
  4420-4427 : ahci
4428-442f : 0000:00:1f.2
  4428-442f : ahci
4430-4433 : 0000:00:1f.2
  4430-4433 : ahci
4434-4437 : 0000:00:1f.2
  4434-4437 : ahci

Problem Description: I am not able to get a kernel's core dump or some text
output on my disk because press the hard reset button is the only one
possibility what I can do after this issue. well, I have taken a photo of my
lcd with the bug and you can see it at
http://rpolasek.webpark.cz/linux-crash2.jpg - the bug is realy very annoying
:o( 

Steps to reproduce: I am able to reproduce this bug everytime I run bonnie++ or
when I copy or move file(s) of size more then about 4GB.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
