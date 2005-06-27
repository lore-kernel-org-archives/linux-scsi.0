From: Jan Merka <jm@wo.cz>
Subject: Kernel 2.6.12x breaks the qlaxxxx driver
Date: Mon, 27 Jun 2005 18:17:09 -0400
Message-ID: <200506271817.09202.jm@wo.cz>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost2.gsfc.nasa.gov ([128.183.244.130]:60857 "EHLO
	mailhost2.gsfc.nasa.gov") by vger.kernel.org with ESMTP
	id S261949AbVF0WRp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 18:17:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org

Hi,

The 2.6.12 and 2.6.12.1 kernels break the qlaxxxx driver(s).

Problem description:
Loading the qlaxxxx driver finds the attached FC array but doesn't find/create 
any SCSI devices because of the following error issued for each available 
LUN:

scsi: host 0 channel 0 id 0 lun1 has a LUN larger than allowed by the host 
adapter

This is the full excerpt from dmesg related to loading the qlaxxx module under 
2.6.12 or 2.6.12.1 kernels (the result doesn't change if the driver is 
compiled in the kernel):

QLogic Fibre Channel HBA Driver
ACPI: PCI Interrupt 0000:05:07.0[A] -> GSI 34 (level, low) -> IRQ 34
qla2300 0000:05:07.0: Found an ISP2312, irq 34, iobase 0xf8834000
scsi0 : qla2xxx
qla2300 0000:05:07.0: Configuring PCI space...
qla2300 0000:05:07.0: Configure NVRAM parameters...
qla2300 0000:05:07.0: Verifying loaded RISC code...
qla2300 0000:05:07.0: Waiting for LIP to complete...
qla2300 0000:05:07.0: LIP reset occured (f8f7).
qla2300 0000:05:07.0: LIP occured (f8f7).
qla2300 0000:05:07.0: LOOP UP detected (2 Gbps).
qla2300 0000:05:07.0: Topology - (Loop), Host Loop address 0x0
qla2300 0000:05:07.0: 
 QLogic Fibre Channel HBA Driver: 8.00.02b5-k
  QLogic QLA2340 - 
  ISP2312: PCI-X (100 MHz) @ 0000:05:07.0 hdma-, host#=0, fw=3.03.08 IPX
  Vendor: nStor     Model: NexStor Wahoo     Rev:     
  Type:   Processor                          ANSI SCSI revision: 03
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 3
scsi: host 0 channel 0 id 0 lun1 has a LUN larger than allowed by the host 
adapt
er

Contrast it with the dmesg output on the 2.6.11.12 kernel:

QLogic Fibre Channel HBA Driver
ACPI: PCI interrupt 0000:05:07.0[A] -> GSI 34 (level, low) -> IRQ 34
qla2300 0000:05:07.0: Found an ISP2312, irq 34, iobase 0xf8834000
qla2300 0000:05:07.0: Configuring PCI space...
qla2300 0000:05:07.0: Configure NVRAM parameters...
qla2300 0000:05:07.0: Verifying loaded RISC code...
qla2300 0000:05:07.0: Waiting for LIP to complete...
qla2300 0000:05:07.0: LIP reset occured (f8f7).
qla2300 0000:05:07.0: LIP occured (f8f7).
qla2300 0000:05:07.0: LOOP UP detected (2 Gbps).
qla2300 0000:05:07.0: Topology - (Loop), Host Loop address 0x0
scsi0 : qla2xxx
qla2300 0000:05:07.0: 
 QLogic Fibre Channel HBA Driver: 8.00.02b4-k
  QLogic QLA2340 - 
  ISP2312: PCI-X (100 MHz) @ 0000:05:07.0 hdma-, host#=0, fw=3.03.08 IPX
  Vendor: nStor     Model: NexStor Wahoo     Rev:     
  Type:   Processor                          ANSI SCSI revision: 03
qla2300 0000:05:07.0: scsi(0:0:0:0): Enabled tagged queuing, queue depth 32.
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 3
  Vendor: nStor     Model: NexStor Wahoo     Rev:     
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:05:07.0: scsi(0:0:0:1): Enabled tagged queuing, queue depth 32.
SCSI device sda: 1418452992 512-byte hdwr sectors (726248 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 1418452992 512-byte hdwr sectors (726248 MB)
SCSI device sda: drive cache: write back
 sda: sda1
Attached scsi disk sda at scsi0, channel 0, id 0, lun 1
Attached scsi generic sg1 at scsi0, channel 0, id 0, lun 1,  type 0

HW information: HP ProLiant DL385 (dual Opteron, 4GB RAM), QLA2312 FC Adapter

Please let me know, if I can provide more useful information.

Best regards,

Jan
