From: Robert Heinzmann <Robert.Heinzmann@gmx.net>
Subject: I/O Errors and no Partitions visible with QLogic failover driver
 and Storageworks array (MSA1500)
Date: Sun, 03 Jul 2005 23:21:32 +0200
Message-ID: <42C856DC.9070506@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:18393 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261542AbVGCVVg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jul 2005 17:21:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

we observed some strange behaviour with the Qlogic failover driver 
version 8.00.02 (Kernel 2.6.7) and MSA1500 storagework arrays.

We have a MSA1500 connected to two fabrics and 4 hosts connected to the 
MSA1500, each with 2 Qlogic FC HBA's. Each HBA is connected to one 
fabric. We have seen the following strange behaviour:

a) If we boot one machine and the HBA first found by the operating 
system  is connected to the standby MSA1500 controller, the boot takes 
very long and we get SCSI I/O errors (see below). After the boot no 
partitions are visible on the array. If we issue blockdev --rescanpt on 
the LUN's we see the partitions.

b) If we boot one machine and the HBA first found by the operating 
system is connected to the active MSA1500 controller, the boot is very 
quick (normal) and all partitions are visible after the boot.

Because I'm not such an kernel expert I thought of asking the SCSI 
"gurus" on this list :). Who is responsible for scanning the parition 
tables after inserting a new driver ? Is this the driver itself or the 
kernel ?

I would really appreshiate any hint or help.

Regards,
Robert Heinzmann

------------

Boot log for scenario a) :

qla2300 0000:06:02.0: Found an ISP2312, irq 78, iobase 0xf90f5000
qla2300 0000:06:02.0: Configuring PCI space...
qla2300 0000:06:02.0: Configure NVRAM parameters...
qla2300 0000:06:02.0: Verifying loaded RISC code...
qla2300 0000:06:02.0: Waiting for LIP to complete...
qla2300 0000:06:02.0: LOOP UP detected (2 Gbps).
qla2300 0000:06:02.0: Topology - (F_Port), Host Loop address 0xffff
scsi(0) :Loop id 0x0081 is a MSA1000 device
scsi(0) :Loop id 0x0081 is a MSA1000 device
scsi(0) :Loop id 0x0081 is a MSA1000 device
scsi0 : qla2xxx
qla2300 0000:06:02.0:
QLogic Fibre Channel HBA Driver: 8.00.02-fo
QLogic QLA2340 -
ISP2312: PCI-X (100 MHz) @ 0000:06:02.0 hdma+, host#=0, fw=3.03.11 IPX
scsi: unknown device type 12
Vendor: COMPAQ Model: MSA1000 Rev: 4.32
Type: RAID ANSI SCSI revision: 04
qla2300 0000:06:02.0: scsi(0:0:0:0): Enabled tagged queuing, queue depth 16.
Vendor: COMPAQ Model: MSA1000 VOLUME Rev: 4.32
Type: Direct-Access ANSI SCSI revision: 04
qla2300 0000:06:02.0: scsi(0:0:0:1): Enabled tagged queuing, queue depth 16.
SCSI device sda: 204799680 512-byte hdwr sectors (104857 MB)
SCSI device sda: drive cache: write back
SCSI error : <0 0 0 1> return code = 0x20000
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
SCSI error : <0 0 0 1> return code = 0x20000
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
Attached scsi disk sda at scsi0, channel 0, id 0, lun 1
Vendor: COMPAQ Model: MSA1000 VOLUME Rev: 4.32
Type: Direct-Access ANSI SCSI revision: 04
qla2300 0000:06:02.0: scsi(0:0:0:3): Enabled tagged queuing, queue depth 16.
SCSI device sdb: 40955040 512-byte hdwr sectors (20969 MB)
SCSI device sdb: drive cache: write back
SCSI error : <0 0 0 3> return code = 0x20000
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
SCSI error : <0 0 0 3> return code = 0x20000
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
Attached scsi disk sdb at scsi0, channel 0, id 0, lun 3
