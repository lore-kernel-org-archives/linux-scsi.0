From: Catalin Muresan <catalin.muresan@astral.ro>
Subject: Apple Xserve RAID and qlogic ISP2312 (qla2300)
Date: Thu, 28 Oct 2004 02:33:21 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041027233321.GA842@astral.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dummy.cluj.astral.ro ([193.230.240.25]:56043 "EHLO
	cnn.astral.ro") by vger.kernel.org with ESMTP id S262682AbUJ0XjR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 19:39:17 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bogdan.luca@astral.ro


	Hi,

	I have the hardware from the subject, the problem i have is that the
scsi layer doesn't see any luns i made on the raid except LUN 0. here is an
example:

[root@zerg-b root]# cd /proc/scsi/qla2xxx/  
[root@zerg-b qla2xxx]# cat 0
QLogic PCI to Fibre Channel Host Adapter for IBM HS20:
        Firmware version 3.02.30 IPX, Driver version 8.00.00b15-k
Entry address = f88f1000
ISP: ISP2312, Serial# N02631
Request Queue = 0x35780000, Response Queue = 0x35750000
Request Queue count = 2048, Response Queue count = 512
Total number of active commands = 0
Total number of interrupts = 345631
    Device queue depth = 0x10
Number of free request entries = 2047
Number of mailbox timeouts = 0
Number of ISP aborts = 0
Number of loop resyncs = 0
Number of retries for empty slots = 0
Number of reqs in pending_q= 0, retry_q= 0, done_q= 0, scsi_retry_q= 0
Host adapter:loop state = <READY>, flags = 0x1803
Dpc flags = 0x0
MBX flags = 0x0
Link down Timeout = 030
Port down retry = 030
Login retry count = 030
Commands retried with dropped frame(s) = 0
Product ID = 4953 5020 2020 0002


SCSI Device Information:
scsi-qla0-adapter-node=2000000d60d367e0;
scsi-qla0-adapter-port=2100000d60d367e0;
scsi-qla0-target-0=60003930000026b4;

SCSI LUN Information:
(Id:Lun)  * - indicates lun is not registered with the OS.
( 0: 5): Total reqs 0, Pending reqs 0, flags 0x0*, 0:0:83 00
[root@zerg-b qla2xxx]# 

	you can see that the driver has found the 5th LUN but scsi_scan
doesn't se it when scanning, scsi_probe_and_add_lun for LUN 0 returns
SCSI_SCAN_NO_RESPONSE instead of SCSI_SCAN_TARGET_PRESENT. I have added
{"APPLE", "Xserve RAID", NULL, BLIST_SPARSELUN}, in scsi_devinfo.c so
scsi_scan will try and perform a sparse scan on the LUNs but that doesn't
help because scanning LUN 0 fails.

Oct 28 01:59:37 zerg-b kernel: scsi_scan_host_selected: <0:4294967295:4294967295:4294967295>
Oct 28 01:59:37 zerg-b kernel: scsi scan: INQUIRY to host 0 channel 0 id 0 lun 0
Oct 28 01:59:37 zerg-b kernel: scsi scan: 1st INQUIRY failed with code 0x10000
Oct 28 01:59:37 zerg-b kernel: scsi scan: INQUIRY to host 0 channel 0 id 1 lun 0
Oct 28 01:59:37 zerg-b kernel: scsi scan: 1st INQUIRY failed with code 0x10000
Oct 28 01:59:37 zerg-b kernel: scsi scan: INQUIRY to host 0 channel 0 id 2 lun 0
Oct 28 01:59:37 zerg-b kernel: scsi scan: 1st INQUIRY failed with code 0x10000

	details on hardware: IBM HS20 blade with Qlogic FC module, 

02:02.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 02)
02:02.1 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 02)

	storage is APPLE Xserve RAID, latest firmware with lun masking activated, for this node
the 5th LUN is allowed. using add-single-device does the trick but i need a
kernel to boot from FC. here is the output after 

# echo "scsi add-single-device 0 0 0 5" > /proc/scsi/scsi

Oct 28 02:31:38 zerg-b kernel: scsi_scan_host_selected: <0:0:0:5>
Oct 28 02:31:38 zerg-b kernel: scsi scan: INQUIRY to host 0 channel 0 id 0 lun 5
Oct 28 02:31:38 zerg-b kernel: scsi scan: 1st INQUIRY successful with code 0x0
Oct 28 02:31:38 zerg-b kernel:   Vendor: APPLE     Model: Xserve RAID       Rev: 1.21
Oct 28 02:31:38 zerg-b kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Oct 28 02:31:38 zerg-b kernel: qla2300 0000:02:02.0: scsi(0:0:0:5): Enabled tagged queuing, queue depth 32.

	any patches, suggestions, questions etc are appreciated.
	please CC me as I'm not on the list.

-- 
Kat
