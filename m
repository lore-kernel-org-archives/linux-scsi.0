From: "Michael W. Shaffer" <mwshaffer@yahoo.com>
Subject: No LUNs detected with 2.6.1-mm4 qla2xxx / qla2300
Date: Sun, 18 Jan 2004 15:25:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040118232525.59450.qmail@web10412.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web10412.mail.yahoo.com ([216.136.128.126]:56203 "HELO
	web10412.mail.yahoo.com") by vger.kernel.org with SMTP
	id S264275AbUARXZ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 18:25:26 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have the following (briefly):

- HP NetServer LH6000r
- 2 x QLogic QLA2340 2GBps HBA
- 2 x Nexsan ATABoy2 RAID Array

The server has two HBAs in it. One HBA connects to
one array, the other HBA to the other array (duh).

Running kernel 2.4.21-xfs with the Feral Software
ISP driver loaded as a module, everything works
fine (well, except for the fact that 2.4 is a total
POS under I/O load...). Two HBAs detected, one LUN
shows up on each HBA, two SCSI block devices sdb
and sdc are registered, RAID1 across them, XFS file
system on /dev/md0 -- everything is happy.

I just compiled kernel 2.6.1-mm4, which includes
this merged version of the QLogic drivers called
qla2xxx. I built the qla2300 driver as a module,
and when I load it, the HBAs are detected just
fine, and I see their port and node IDs, but no
LUNs are detected, and no SCSI devices registered.

Apparently this new driver is my only option now.
I tried the qlogicfc and cpqfc drivers, but they
don't appear to recognize the HBAs I have at all.
The factory QLogic drivers don't work with 2.6,
and the Feral ISP driver was dropped from the -mm
patchset back around 2.6.1-test5 or so, apparently
because it is considered 'old and broken' (at least
with respect to 2.6, I've had very good results
with it so far in 2.4).

I can see on the status monitor for these arrays
that their ports change from 'Loop Down' to 'Loop Up'
status when I load the qla2300 driver, so it looks
like the HBA is being initialized and is joining the
loop ok or whatever -- it just doesn't give me any
disk devices to use. Reboot the system with the old
kernel -- everything works fine again.

Output of dmesg and contents of /proc/scsi/qla2xxx/*
below, any advice would be greatly appreciated.

dmesg:
-------------------------------------------------
QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA Driver (f8a29000)
qla2300 0000:01:02.0: Found an ISP2312, irq 25, iobase 0xf8893000
qla2300 0000:01:02.0: Configuring PCI space...
qla2300 0000:01:02.0: Configure NVRAM parameters...
qla2300 0000:01:02.0: Verifying loaded RISC code...
qla2300 0000:01:02.0: LIP reset occured (f8f7).
qla2300 0000:01:02.0: Waiting for LIP to complete...
qla2300 0000:01:02.0: LIP occured (f8f7).
qla2300 0000:01:02.0: LOOP UP detected (2 Gbps).
qla2300 0000:01:02.0: Topology - (Loop), Host Loop address 0x1
scsi2 : qla2xxx
qla2300 0000:01:02.0:
 QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA Driver: 8.00.00b8
  QLogic QLA2340 -
  ISP2312: PCI (66 MHz) @ 0000:01:02.0 hdma-, host#=2, fw=3.02.18 TPX
qla2300 0000:01:03.0: Found an ISP2312, irq 25, iobase 0xf8895000
qla2300 0000:01:03.0: Configuring PCI space...
qla2300 0000:01:03.0: Configure NVRAM parameters...
qla2300 0000:01:03.0: Verifying loaded RISC code...
qla2300 0000:01:03.0: LIP reset occured (f8f7).
qla2300 0000:01:03.0: Waiting for LIP to complete...
qla2300 0000:01:03.0: LIP occured (f8f7).
qla2300 0000:01:03.0: LOOP UP detected (2 Gbps).
qla2300 0000:01:03.0: Topology - (Loop), Host Loop address 0x1
scsi3 : qla2xxx
qla2300 0000:01:03.0:
 QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA Driver: 8.00.00b8
  QLogic QLA2340 -
  ISP2312: PCI (66 MHz) @ 0000:01:03.0 hdma-, host#=3, fw=3.02.18 TPX
-------------------------------------------------

/proc/scsi/qla2xxx/2:
-------------------------------------------------
QLogic PCI to Fibre Channel Host Adapter for QLA2340:
        Firmware version 3.02.18 TPX, Driver version 8.00.00b8
Entry address = f8a29000
ISP: ISP2312, Serial# J38360
Request Queue = 0x36ba0000, Response Queue = 0x36b90000
Request Queue count = 1024, Response Queue count = 512
Total number of active commands = 0
Total number of interrupts = 14638
    Device queue depth = 0x10
Number of free request entries = 1023
Number of mailbox timeouts = 0
Number of ISP aborts = 0
Number of loop resyncs = 0
Number of retries for empty slots = 0
Number of reqs in pending_q= 0, retry_q= 0, done_q= 0, scsi_retry_q= 0
Host adapter:loop state = <READY>, flags = 0x1813
Dpc flags = 0x80000
MBX flags = 0x0
Link down Timeout = 030
Port down retry = 030
Login retry count = 030
Commands retried with dropped frame(s) = 0
Info -- pci=104 xchgs=0x200 iocbs=0x307


SCSI Device Information:
scsi-qla0-adapter-node=200000e08b0e7851;
scsi-qla0-adapter-port=210000e08b0e7851;

SCSI LUN Information:
(Id:Lun)  * - indicates lun is not registered with the OS.
-------------------------------------------------

/proc/scsi/qla2xxx/3:
-------------------------------------------------
QLogic PCI to Fibre Channel Host Adapter for QLA2340:
        Firmware version 3.02.18 TPX, Driver version 8.00.00b8
Entry address = f8a29000
ISP: ISP2312, Serial# J48818
Request Queue = 0x36b40000, Response Queue = 0x36b60000
Request Queue count = 1024, Response Queue count = 512
Total number of active commands = 0
Total number of interrupts = 8412
    Device queue depth = 0x10
Number of free request entries = 1023
Number of mailbox timeouts = 0
Number of ISP aborts = 0
Number of loop resyncs = 0
Number of retries for empty slots = 0
Number of reqs in pending_q= 0, retry_q= 0, done_q= 0, scsi_retry_q= 0
Host adapter:loop state = <READY>, flags = 0x1813
Dpc flags = 0x80000
MBX flags = 0x0
Link down Timeout = 030
Port down retry = 030
Login retry count = 030
Commands retried with dropped frame(s) = 0
Info -- pci=104 xchgs=0x200 iocbs=0x307


SCSI Device Information:
scsi-qla1-adapter-node=200000e08b0e527a;
scsi-qla1-adapter-port=210000e08b0e527a;

SCSI LUN Information:
(Id:Lun)  * - indicates lun is not registered with the OS.
-------------------------------------------------

__________________________________
Do you Yahoo!?
Yahoo! Hotjobs: Enter the "Signing Bonus" Sweepstakes
http://hotjobs.sweepstakes.yahoo.com/signingbonus
