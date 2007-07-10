From: Philippe Troin <phil@fifi.org>
Subject: mptsas drops then re-adds hard drive
Date: 09 Jul 2007 19:30:17 -0700
Message-ID: <87hcodourq.fsf@old-tantale.fifi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from old-tantale.fifi.org ([64.81.30.200]:39666 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227AbXGJCga (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 22:36:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mpt_linux_developer@lsi.com

System info:
Linux 2.6.20-1.2320.fc5 SMP x86_64

lspci:
00:06.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8111 PCI (rev 07)
00:07.0 ISA bridge: Advanced Micro Devices [AMD] AMD-8111 LPC (rev 05)
00:07.1 IDE interface: Advanced Micro Devices [AMD] AMD-8111 IDE (rev 03)
00:07.2 SMBus: Advanced Micro Devices [AMD] AMD-8111 SMBus 2.0 (rev 02)
00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-8111 ACPI (rev 05)
00:07.5 Multimedia audio controller: Advanced Micro Devices [AMD] AMD-8111 AC97 Audio (rev 03)
00:0a.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 12)
00:0a.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
00:0b.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 12)
00:0b.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:00.0 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
01:00.1 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
01:0a.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
01:0a.1 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
01:0a.2 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
01:0a.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01)
01:0a.4 FireWire (IEEE 1394): ALi Corporation M5253 P1394 OHCI 1.1 Controller
01:0c.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 Controller (PHY/Link)
02:07.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X Fusion-MPT SAS (rev 01)
02:09.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5703X Gigabit Ethernet (rev 02)
03:06.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
04:00.0 Host bridge: Advanced Micro Devices [AMD] AMD-8151 System Controller (rev 13)
04:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8151 AGP Bridge (rev 13)
05:00.0 VGA compatible controller: ATI Technologies Inc RV280 [Radeon 9200] (rev 01)
05:00.1 Display controller: ATI Technologies Inc RV280 [Radeon 9200] (Secondary) (rev 01)

% cat /proc/scsi/mptsas/1
ioc0: LSISAS1068, FwRev=01120000h, Ports=1, MaxQ=511


I have four SATA drives attached to the SAS1068X-R controller, all
four are Seagate ST3750640AS (750 GB Barracuda 7200.10) with firmware
revision 3.AAE.

I was doing load-testing for a RAID array and running badblocks in a
loop over all four drives in parallel.  One drive was dropped after
about 24h.  By dropped I mean the device node /dev/sdb became
"unresponsive" and the drive was re-added with another device node
(sdj).

This is the kernel message:

mptbase: ioc0: LogInfo(0x31110d00): Originator={PL}, Code={Reset}, SubCode(0x0d00)
mptbase: ioc0: LogInfo(0x31110d00): Originator={PL}, Code={Reset}, SubCode(0x0d00)
mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
mptbase: ioc0: LogInfo(0x31130000): Originator={PL}, Code={IO Not Yet Executed}, SubCode(0x0000)
sd 1:0:0:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sdb, sector 330342400
sd 1:0:0:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sdb, sector 330342400
Buffer I/O error on device sdb, logical block 41292800
Buffer I/O error on device sdb, logical block 41292801
Buffer I/O error on device sdb, logical block 41292802
Buffer I/O error on device sdb, logical block 41292803
Buffer I/O error on device sdb, logical block 41292804
Buffer I/O error on device sdb, logical block 41292805
Buffer I/O error on device sdb, logical block 41292806
Buffer I/O error on device sdb, logical block 41292807
Buffer I/O error on device sdb, logical block 41292808
Buffer I/O error on device sdb, logical block 41292809
sd 1:0:0:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sdb, sector 330342400

lots more of these, until finally:

mptbase: ioc0: LogInfo(0x31111000): Originator={PL}, Code={Reset}, SubCode(0x1000)
mptbase: ioc0: LogInfo(0x31111000): Originator={PL}, Code={Reset}, SubCode(0x1000)
mptsas: ioc0: attaching sata device, channel 0, id 13, phy 0
scsi 1:0:4:0: Direct-Access     ATA      ST3750640AS      E    PQ: 0 ANSI: 5
SCSI device sdj: 1465149168 512-byte hdwr sectors (750156 MB)
sdj: Write Protect is off
SCSI device sdj: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdj: 1465149168 512-byte hdwr sectors (750156 MB)
sdj: Write Protect is off
SCSI device sdj: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sdj: unknown partition table
sd 1:0:4:0: Attached scsi disk sdj
sd 1:0:4:0: Attached scsi generic sg1 type 0

Is it a bad drive, a bad controller, or both?  Or a driver bug?

Thanks for any hints.
Phil.
