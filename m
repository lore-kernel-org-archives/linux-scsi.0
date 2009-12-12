From: uprooter <uprooter@gmail.com>
Subject: Fusion MPT Ultra320 disks  detected as Ultra2
Date: Sat, 12 Dec 2009 14:38:00 -0800 (PST)
Message-ID: <26761757.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:39494 "HELO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933123AbZLMBXE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2009 20:23:04 -0500
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1NJabA-0002Pg-SN
	for linux-scsi@vger.kernel.org; Sat, 12 Dec 2009 14:38:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello. I'm struggling a IBM x336 machine with FustionMPT LSI53C1030.
This controller can't do radi0 so I disabled raid in the BIOS.
Problem is that disks are detected wrong and IO is very slow
hdparm -t gives only 37MB/s
dmesg shows that both disks are recognized as FAST-20 while it should be
FAST-160. also cache is disabled.
I've googled around for hours, saw many problems related to the MPT being
slow when compiled into the kernel in old versions (I have tried module) but
I'm using using 2.6.31.
Here are some logs:

6 23:35:16 localhost kernel: Fusion MPT base driver 3.04.07
6 23:35:16 localhost kernel: Copyright (c) 1999-2008 LSI Corporation
6 23:35:16 localhost kernel: Fusion MPT SPI Host driver 3.04.07
6 23:35:16 localhost kernel: mptspi 0000:04:01.0: PCI INT A -> GSI 28
(level, low) -> IRQ 28
6 23:35:16 localhost kernel: mptbase: ioc0: Initiating bringup
6 23:35:16 localhost kernel: ata1.00: ATAPI: DV-18E, 2.0D, max UDMA/33
6 23:35:16 localhost kernel: ata1.00: configured for UDMA/33
6 23:35:16 localhost kernel: scsi 0:0:0:0: CD-ROM            TEAC     DV-18E          
2.0D PQ: 0 ANSI: 5
6 23:35:16 localhost kernel: sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2
cdda tray
6 23:35:16 localhost kernel: Uniform CD-ROM driver Revision: 3.20
6 23:35:16 localhost kernel: sr 0:0:0:0: Attached scsi CD-ROM sr0
6 23:35:16 localhost kernel: Switched to high resolution mode on CPU 3
6 23:35:16 localhost kernel: Switched to high resolution mode on CPU 1
6 23:35:16 localhost kernel: Switched to high resolution mode on CPU 2
6 23:35:16 localhost kernel: Switched to high resolution mode on CPU 0
6 23:35:16 localhost kernel: ioc0: LSI53C1030 C0: Capabilities={Initiator}
6 23:35:16 localhost kernel: scsi2 : ioc0: LSI53C1030 C0, FwRev=01032821h,
Ports=1, MaxQ=222, IRQ=28
6 23:35:16 localhost kernel: Fusion MPT FC Host driver 3.04.07
6 23:35:16 localhost kernel: Fusion MPT SAS Host driver 3.04.07
6 23:35:16 localhost kernel: Fusion MPT misc device (ioctl) driver 3.04.07
6 23:35:16 localhost kernel: mptctl: Registered with Fusion MPT base driver
6 23:35:16 localhost kernel: mptctl: /dev/mptctl @ (major,minor=10,220)
6 23:35:16 localhost kernel: Fusion MPT LAN driver 3.04.07
6 23:35:16 localhost kernel: mptlan: ioc0: PortNum=0, ProtocolFlags=08h
(Itlb)
6 23:35:16 localhost kernel: mptlan: ioc0: Hmmm... LAN protocol seems to be
disabled on this adapter port!
....

scsi: waiting for bus probes to complete ...
Nov 26 23:35:16 localhost kernel: scsi 2:0:0:0: Direct-Access     IBM     
IC35L146UCDY10-0 S27N PQ: 0 ANSI: 3
Nov 26 23:35:16 localhost kernel: target2:0:0: Beginning Domain Validation
Nov 26 23:35:16 localhost kernel: target2:0:0: Domain Validation skipping
write tests
Nov 26 23:35:16 localhost kernel: target2:0:0: Ending Domain Validation
Nov 26 23:35:16 localhost kernel: target2:0:0: FAST-20 WIDE SCSI 40.0 MB/s
ST (50 ns, offset 8)
Nov 26 23:35:16 localhost kernel: scsi 2:0:1:0: Direct-Access     IBM     
IC35L146UCDY10-0 S27N PQ: 0 ANSI: 3
Nov 26 23:35:16 localhost kernel: target2:0:1: Beginning Domain Validation
Nov 26 23:35:16 localhost kernel: target2:0:1: Domain Validation skipping
write tests
Nov 26 23:35:16 localhost kernel: target2:0:1: Ending Domain Validation
Nov 26 23:35:16 localhost kernel: target2:0:1: FAST-20 WIDE SCSI 40.0 MB/s
ST (50 ns, offset 8)
Nov 26 23:35:16 localhost kernel: scsi 2:0:8:0: Processor         IBM     
25P3495a S320  1 1    PQ: 0 ANSI: 2
Nov 26 23:35:16 localhost kernel: target2:0:8: Beginning Domain Validation
Nov 26 23:35:16 localhost kernel: target2:0:8: Ending Domain Validation
Nov 26 23:35:16 localhost kernel: target2:0:8: asynchronous
Nov 26 23:35:16 localhost kernel: BIOS EDD facility v0.16 2004-Jun-25, 2
devices found
Nov 26 23:35:16 localhost kernel: sd 2:0:0:0: [sda] 286749610 512-byte
hardware sectors: (146 GB/136 GiB)
Nov 26 23:35:16 localhost kernel: sd 2:0:1:0: [sdb] 286749610 512-byte
hardware sectors: (146 GB/136 GiB)
Nov 26 23:35:16 localhost kernel: sd 2:0:1:0: [sdb] Write Protect is off
Nov 26 23:35:16 localhost kernel: sd 2:0:0:0: [sda] Write Protect is off
Nov 26 23:35:16 localhost kernel: sd 2:0:0:0: [sda] Mode Sense: cb 00 00 08
Nov 26 23:35:16 localhost kernel: sd 2:0:1:0: [sdb] Mode Sense: cb 00 00 08
Nov 26 23:35:16 localhost kernel: sd 2:0:0:0: [sda] Write cache: disabled,
read cache: enabled, doesn't support DPO or FUA
Nov 26 23:35:16 localhost kernel: sd 2:0:1:0: [sdb] Write cache: disabled,
read cache: enabled, doesn't support DPO or FUA

Also tried to echo 1 > revalidate on all spi_tagets , no effect.
I'll appreciate any help.
Thank you.

-- 
View this message in context: http://old.nabble.com/Fusion-MPT-Ultra320-disks--detected-as-Ultra2-tp26761757p26761757.html
Sent from the linux-scsi mailing list archive at Nabble.com.

