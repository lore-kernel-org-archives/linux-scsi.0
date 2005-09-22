From: "Mr. Berkley Shands" <bshands@exegy.com>
Subject: 2.6.14-rc2 hang on Marvell Sata HBA
Date: Thu, 22 Sep 2005 08:39:30 -0500
Message-ID: <4332B412.40808@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 66.64.135.114.nw.nuvox.net ([66.64.135.114]:25007 "EHLO
	service.eng.exegy.net") by vger.kernel.org with ESMTP
	id S1030341AbVIVNkO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 09:40:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: russb@emc.com, linux-scsi@vger.kernel.org
Cc: bshands@exegy.com

Sep 22 06:48:10 exegysatademo02 syslogd 1.4.1: restart.
< /sbin/modprobe sata_mv>
Sep 22 06:48:19 exegysatademo02 kernel: ACPI: PCI Interrupt 
0000:02:07.0[A] -> GSI 26 (level, low) -> IRQ 193
Sep 22 06:48:19 exegysatademo02 kernel: ata5: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000922120 bmdma 0x0 irq 193
Sep 22 06:48:19 exegysatademo02 kernel: ata6: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000924120 bmdma 0x0 irq 193
Sep 22 06:48:19 exegysatademo02 kernel: ata7: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000926120 bmdma 0x0 irq 193
Sep 22 06:48:19 exegysatademo02 kernel: ata8: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000928120 bmdma 0x0 irq 193
Sep 22 06:48:19 exegysatademo02 kernel: ata9: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000932120 bmdma 0x0 irq 193
Sep 22 06:48:19 exegysatademo02 kernel: ata10: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000934120 bmdma 0x0 irq 193
Sep 22 06:48:19 exegysatademo02 kernel: ata11: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000936120 bmdma 0x0 irq 193
Sep 22 06:48:19 exegysatademo02 kernel: ata12: SATA max PIO4 cmd 0x0 ctl 
0xFFFFC20000938120 bmdma 0x0 irq 193
Sep 22 06:48:19 exegysatademo02 kernel: ata5: dev 0 ATA, max UDMA/133, 
390721968 sectors: lba48
<hung>

Note that there are THREE HBAs here, with two logical raid0's each, so 
there should be 6 drives
sdb - sdg, not 8.

the hptmv6 driver (from highpoint-tech) says...
Sep 22 07:05:22 exegysatademo02 kernel: hptmv6: module license 
'Proprietary' taints kernel.
Sep 22 07:05:22 exegysatademo02 kernel: hptmv6:1: RocketRAID 222x 
controller driver v1.02 (Sep 16 2005 06:30:24)
Sep 22 07:05:22 exegysatademo02 kernel: ACPI: PCI interrupt 
0000:02:07.0[A] -> GSI 26 (level, low) -> IRQ 177
Sep 22 07:05:23 exegysatademo02 kernel: hptmv6:1: adapter at PCI 2:7:0, 
IRQ 177
Sep 22 07:05:23 exegysatademo02 kernel: ACPI: PCI interrupt 
0000:02:08.0[A] -> GSI 27 (level, low) -> IRQ 185
Sep 22 07:05:23 exegysatademo02 kernel: hptmv6:1: adapter at PCI 2:8:0, 
IRQ 185
Sep 22 07:05:23 exegysatademo02 kernel: ACPI: PCI interrupt 
0000:01:06.0[A] -> GSI 29 (level, low) -> IRQ 193
Sep 22 07:05:23 exegysatademo02 kernel: hptmv6:1: adapter at PCI 1:6:0, 
IRQ 193
Sep 22 07:05:23 exegysatademo02 kernel: hptmv6:1: start channel [0,0]
<blah>
Sep 22 07:05:23 exegysatademo02 kernel: hptmv6:1: channel [0,1] started 
successfully
<more blah>
Sep 22 07:55:25 exegysatademo02 kernel: scsi4 : hptmv6
Sep 22 07:55:25 exegysatademo02 kernel:   Vendor: HPT       Model: DISK 
4_0          Rev: 4.00
Sep 22 07:55:25 exegysatademo02 kernel:   Type:   
Direct-Access                      ANSI SCSI revision: 00
Sep 22 07:55:25 exegysatademo02 kernel: SCSI device sdb: 1561853952 
512-byte hdwr sectors (799669 MB)
Sep 22 07:55:25 exegysatademo02 kernel: SCSI device sdb: drive cache: 
write through
Sep 22 07:55:25 exegysatademo02 kernel: SCSI device sdb: 1561853952 
512-byte hdwr sectors (799669 MB)
Sep 22 07:55:25 exegysatademo02 kernel: SCSI device sdb: drive cache: 
write through
Sep 22 07:55:25 exegysatademo02 kernel:  sdb: sdb1
Sep 22 07:55:25 exegysatademo02 kernel: Attached scsi disk sdb at scsi4, 
channel 0, id 0, lun 0
Sep 22 07:55:25 exegysatademo02 kernel:   Vendor: HPT       Model: DISK 
4_1          Rev: 4.00
Sep 22 07:55:25 exegysatademo02 kernel:   Type:   
Direct-Access                      ANSI SCSI revision: 00
Sep 22 07:55:25 exegysatademo02 kernel: SCSI device sdc: 1561853952 
512-byte hdwr sectors (799669 MB)
Sep 22 07:55:25 exegysatademo02 kernel: SCSI device sdc: drive cache: 
write through
Sep 22 07:55:26 exegysatademo02 kernel: SCSI device sdc: 1561853952 
512-byte hdwr sectors (799669 MB)
Sep 22 07:55:26 exegysatademo02 kernel: SCSI device sdc: drive cache: 
write through
Sep 22 07:55:26 exegysatademo02 kernel:  sdc: sdc1
Sep 22 07:55:26 exegysatademo02 kernel: Attached scsi disk sdc at scsi4, 
channel 0, id 1, lun 0

oops :-)

berkley
