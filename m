From: James Pearson <james-p@moving-picture.com>
Subject: Problems seeing raid array attached to a qla2312
Date: Thu, 19 Aug 2004 12:22:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41248D91.5070100@moving-picture.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:46997 "EHLO
	moving-picture.com") by vger.kernel.org with ESMTP id S265462AbUHSLW6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 07:22:58 -0400
Received: from minion.mpc.local ([172.16.11.112] helo=moving-picture.com)
	by moving-picture.com with esmtp (Exim 4.24)
	id 1Bxl0T-000804-DK
	for linux-scsi@vger.kernel.org; Thu, 19 Aug 2004 12:22:57 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm having problems seeing a Fibrenetix VP-1242-FC raid array via a 
qla2312 HBA on a dual Xeon box running a RHEL3.0 clone - using a 2.4.21 
based kernel.

The first port on the qla2312 has a Quantum tape library and two SDLT 
tape drives - which the OS can see fine.

The raid array is attached to the 2nd port on the qla2312 - it is 
configured with 3 volumes at luns 0, 1 and 2 - unfortunately, the OS 
can't 'see' the 3 disk volumes ...

The two ports on the qla2312 are scsi2 and scsi3

/proc/scsi/scsi shows

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: SEAGATE  Model: ST336607LC       Rev: 0007
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 01 Lun: 00
   Vendor: SEAGATE  Model: ST373307LC       Rev: 0006
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 06 Lun: 00
   Vendor: ESG-SHV  Model: SCA HSBP M16     Rev: 0.05
   Type:   Processor                        ANSI SCSI revision: 02
Host: scsi2 Channel: 00 Id: 00 Lun: 00
   Vendor: ATL      Model: M2500            Rev: 6.0
   Type:   Medium Changer                   ANSI SCSI revision: 02
Host: scsi2 Channel: 00 Id: 00 Lun: 01
   Vendor: QUANTUM  Model: SDLT600          Rev: 1515
   Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi2 Channel: 00 Id: 00 Lun: 02
   Vendor: QUANTUM  Model: SDLT600          Rev: 1515
   Type:   Sequential-Access                ANSI SCSI revision: 02


However, at the BIOS level, the array can be seen. Also, the file 
/proc/scsi/qla2300/3 ends with:

SCSI LUN Information:
(Id:Lun)  * - indicates lun is not registered with the OS.
( 0: 0): Total reqs 60, Pending reqs 0, flags 0x0, 1:0:00,
( 0: 1): Total reqs 0, Pending reqs 0, flags 0x0*, 1:0:00,
( 0: 2): Total reqs 0, Pending reqs 0, flags 0x0*, 1:0:00,

which seems to indicate something is there ...

(full output from /proc/scsi/qla2300/[23] below.

I'm using v7.00.03 of the qla2300 driver (downloaded from Qlogic's web 
site).

I've tried:

echo "scsi add-single-device 3 0 0 0" > /proc/scsi/scsi

etc. but it doesn't make a difference

As a test, I attached the raid array to an SGI IRIX server (using 
qla2342 HBA) - and it could see the three volumes with out a problem.

Is there anything else I can try?

Thanks

James Pearson



Output of /proc/scsi/qla2300/2 (port with the tape robot and tape drives):

QLogic PCI to Fibre Channel Host Adapter for QLA2342         :
         Firmware version:  3.02.28, Driver version 7.00.03-fo
Entry address = f8b1d060
HBA: QLA2312 , Serial# L20754
Request Queue = 0x35fc0000, Response Queue = 0x35fb0000
Request Queue count= 512, Response Queue count= 512
Total number of active commands = 0
Total number of interrupts = 3
Total number of IOCBs (used/max) = (0/600)
Total number of queued commands = 0
     Device queue depth = 0x20
Number of free request entries = 508
Number of mailbox timeouts = 0
Number of ISP aborts = 0
Number of loop resyncs = 0
Number of retries for empty slots = 0
Number of reqs in pending_q= 0, retry_q= 0, done_q= 0, scsi_retry_q= 0
Number of reqs in failover_q= 0
Host adapter:loop state= <READY>, flags= 0x860a33
Dpc flags = 0x1000040
MBX flags = 0x0
SRB Free Count = 4096
Link down Timeout = 030
Port down retry = 032
Login retry count = 032
Commands retried with dropped frame(s) = 0
Configured characteristic impedence: 50 ohms
Configured data rate: 1-2 Gb/sec auto-negotiate


SCSI Device Information:
scsi-qla0-adapter-node=200100e08b31f219;
scsi-qla0-adapter-port=210100e08b31f219;
scsi-qla0-target-0=2100001086104018;

FC Port Information:
scsi-qla0-port-0=2000001086104018:2100001086104018;

SCSI LUN Information:
(Id:Lun)  * - indicates lun is not registered with the OS.
( 0: 0): Total reqs 1, Pending reqs 0, flags 0x0*, 0:0:00,
( 0: 1): Total reqs 1, Pending reqs 0, flags 0x0*, 0:0:00,
( 0: 2): Total reqs 1, Pending reqs 0, flags 0x0*, 0:0:00,


Output of /proc/scsi/qla2300/3 (raid array attached)

QLogic PCI to Fibre Channel Host Adapter for QLA2342         :
         Firmware version:  3.02.28, Driver version 7.00.03-fo
Entry address = f8b1d060
HBA: QLA2312 , Serial# L20754
Request Queue = 0x35fa0000, Response Queue = 0x35f90000
Request Queue count= 512, Response Queue count= 512
Total number of active commands = 0
Total number of interrupts = 60
Total number of IOCBs (used/max) = (0/600)
Total number of queued commands = 0
     Device queue depth = 0x20
Number of free request entries = 451
Number of mailbox timeouts = 0
Number of ISP aborts = 0
Number of loop resyncs = 0
Number of retries for empty slots = 0
Number of reqs in pending_q= 0, retry_q= 0, done_q= 0, scsi_retry_q= 0
Number of reqs in failover_q= 0
Host adapter:loop state= <READY>, flags= 0x860a33
Dpc flags = 0x1000040
MBX flags = 0x0
SRB Free Count = 4096
Link down Timeout = 030
Port down retry = 032
Login retry count = 032
Commands retried with dropped frame(s) = 60
Configured characteristic impedence: 50 ohms
Configured data rate: 1-2 Gb/sec auto-negotiate


SCSI Device Information:
scsi-qla1-adapter-node=200000e08b11f219;
scsi-qla1-adapter-port=210000e08b11f219;
scsi-qla1-target-0=21000004d9600fc0;

FC Port Information:
scsi-qla1-port-0=20000004d9600fc0:21000004d9600fc0;

SCSI LUN Information:
(Id:Lun)  * - indicates lun is not registered with the OS.
( 0: 0): Total reqs 60, Pending reqs 0, flags 0x0, 1:0:00,
( 0: 1): Total reqs 0, Pending reqs 0, flags 0x0*, 1:0:00,
( 0: 2): Total reqs 0, Pending reqs 0, flags 0x0*, 1:0:00,


