From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16547] New: mptscsih: ioc0: attempting task abort, raid array
 not detected properly on some boots
Date: Mon, 9 Aug 2010 09:22:13 GMT
Message-ID: <bug-16547-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42635 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab0HIJWO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2010 05:22:14 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o799MDIA021081
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2010 09:22:13 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16547

           Summary: mptscsih: ioc0: attempting task abort, raid array not
                    detected properly on some boots
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.32-bpo.5-amd64 (Debian 2.6.32-15~bpo50+1)
                    (norbert@tretkowski.de) (gcc version 4.3.2 (Debian
                    4.3.2-1.1) ) #1 SMP Fri Jun 11 08:42:31 UTC 2010
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: ms@teamix.de
                CC: io_other@kernel-bugs.osdl.org,
                    linux-scsi@vger.kernel.org
        Regression: Yes


This is with a FibreChannel driver, the MPT Fusion driver, but I did not find
any more suitable category.

Latest kernel known to work: 2.6.26 from Debian Backports

This likely is related to:

LSI Fusion MPT driver problem - recurring messages: mptscsih ioc0 attempting
task abort
https://bugzilla.redhat.com/show_bug.cgi?id=483424

On two FTS servers from a customer I see "attempting task abort" errors on some
boots. Then FibreChannel LUNS are not detected properly. Sometimes I see no
errors, but one external RAID arrays is missing completely. And often it just
works. Errors usually disappear after rebooting, sometimes it needs quite a few
reboots until it works again. On boots where LUNs are detected properly, there
do not seem to be any further errors until next boot.

This did not happen using some SuperMicro servers with exactly the same
FibreChannel hostbus adapter using Debian Etch with kernels from 2.6.18 to
2.6.26 (Debian Backport Kernel). On the FTS server I use 2.6.32 Lenny backport
kernel, since 2.6.26 is not able to boot from the internal SATA controller.

Now to the details:

Our setup is as follows: Two backend servers are each connected to two external
EasyRAID arrays. So both see each array all the time. Usually one server takes
the first one of both arrays and the other one takes the second one. Each LUN
is a SoftRAID 1 with LVM on top of it, so that data is stored synchronously on
both RAID arrays. A heartbeat setup with STONITH makes sure that only one
server ever writes to a LUN even on cluster takeover.

When everything works each server sees the following LUNs - each one twice due
to being connected to both of the RAID arrays which carry the "same" LUNs; the
SoftRAID is over sdb and sdd or sdc and sde:

backend01:~# fdisk -l 2>/dev/null | grep "sd[b-e]"
Disk /dev/sdb: 2097.1 GB, 2097146764800 bytes
/dev/sdb1               1      254963  2047990266   fd  Linux raid autodetect
Disk /dev/sdc: 1101.7 GB, 1101725337600 bytes
/dev/sdc1               1      133943  1075897116   fd  Linux raid autodetect
Disk /dev/sdd: 2097.1 GB, 2097146764800 bytes
/dev/sdd1               1      254963  2047990266   fd  Linux raid autodetect
Disk /dev/sde: 1101.7 GB, 1101725337600 bytes
/dev/sde1               1      133943  1075897116   fd  Linux raid autodetect


Now after upgrading to the new FTS servers and to Debian Lenny with 2.6.32
backport kernel we sometimes see FC errors on boot.

The driver is loaded as:

Aug  2 16:17:22 backend02 kernel: [   27.547240] Fusion MPT base driver 3.04.12
Aug  2 16:17:22 backend02 kernel: [   27.547241] Copyright (c) 1999-2008 LSI
Corporation
Aug  2 16:17:22 backend02 kernel: [   27.548426] dca service started, version
1.12.1
Aug  2 16:17:22 backend02 kernel: [   27.556900] Fusion MPT FC Host driver
3.04.12
Aug  2 16:17:22 backend02 kernel: [   27.556939] mptfc 0000:07:00.0: PCI INT A
-> GSI 33 (level, low) -> IRQ 33

Then the driver detects a LUN:

Aug  2 16:17:22 backend02 kernel: [   38.081418] ioc0: LSIFC949E A1:
Capabilities={Initiator,Target,LAN}
Aug  2 16:17:22 backend02 kernel: [   38.081435] mptfc 0000:07:00.0: setting
latency timer to 64
Aug  2 16:17:22 backend02 kernel: [   39.025071] scsi5 : ioc0: LSIFC949E A1,
FwRev=01030e00h, Ports=1, MaxQ=1023, IRQ=33
Aug  2 16:17:22 backend02 kernel: [   39.025285] mptfc: ioc0: FC Link
Established, Speed = 4 Gbps
Aug  2 16:17:22 backend02 kernel: [   39.025750] mptfc 0000:07:00.1: PCI INT B
-> GSI 31 (level, low) -> IRQ 31
Aug  2 16:17:22 backend02 kernel: [   39.026674] scsi 5:0:0:0: Direct-Access   
 easyRAID easyRAID_Q16P2   0001 PQ: 0 ANSI: 5
Aug  2 16:17:22 backend02 kernel: [   39.026810] sd 5:0:0:0: Attached scsi
generic sg2 type 0
Aug  2 16:17:22 backend02 kernel: [   39.027010] scsi: host 5 channel 0 id 0
lun134217728 has a LUN larger than allowed by the host adapter
Aug  2 16:17:22 backend02 kernel: [   39.027017] sd 5:0:0:0: [sdb] 4095989775
512-byte logical blocks: (2.09 TB/1.90 TiB)
Aug  2 16:17:22 backend02 kernel: [   39.027295] sd 5:0:0:0: [sdb] Write
Protect is off
Aug  2 16:17:22 backend02 kernel: [   39.027297] sd 5:0:0:0: [sdb] Mode Sense:
b7 00 00 08
Aug  2 16:17:22 backend02 kernel: [   39.027415] sd 5:0:0:0: [sdb] Write cache:
enabled, read cache: enabled, doesn't support DPO or FUA

The message "lun134217728 has a LUN larger than allowed by the host adapter"
came to our attention. I don't know how it is related. When everything works
both LUNs are detected properly. Each LUN is below 2 TiB. Maybe this is just a
side effect of not detecting LUNs and their "geometry" properly.

Then some more of these:

Aug  2 16:17:22 backend02 kernel: [   41.768233] scsi6 : ioc1: LSIFC949E A1,
FwRev=01030e00h, Ports=1, MaxQ=1023, IRQ=31
Aug  2 16:17:22 backend02 kernel: [   41.768507] mptfc: ioc1: FC Link
Established, Speed = 4 Gbps
Aug  2 16:17:22 backend02 kernel: [   41.768555]  sdb:
Aug  2 16:17:22 backend02 kernel: [   41.769231] scsi 6:0:0:0: Direct-Access   
 easyRAID easyRAID_Q16P2   0001 PQ: 0 ANSI: 5
Aug  2 16:17:22 backend02 kernel: [   41.769354] sd 6:0:0:0: Attached scsi
generic sg3 type 0
Aug  2 16:17:22 backend02 kernel: [   41.769592] scsi: host 6 channel 0 id 0
lun 0x6561737952414944 has a LUN larger than currently supporte
Aug  2 16:17:22 backend02 kernel: [   41.769597] scsi: host 6 channel 0 id 0
lun 0x6561737952414944 has a LUN larger than currently supporte
Aug  2 16:17:22 backend02 kernel: [   41.769601] scsi: host 6 channel 0 id 0
lun 0x5f51313650322020 has a LUN larger than currently supporte
Aug  2 16:17:22 backend02 kernel: [   41.769605] scsi: host 6 channel 0 id 0
lun134479872 has a LUN larger than allowed by the host adapter
Aug  2 16:17:22 backend02 kernel: [   41.769608] scsi: host 6 channel 0 id 0
lun134217728 has a LUN larger than allowed by the host adapter
Aug  2 16:17:22 backend02 kernel: [   41.769614] sd 6:0:0:0: [sdc] 4095989775
512-byte logical blocks: (2.09 TB/1.90 TiB)
Aug  2 16:17:22 backend02 kernel: [   41.769617] scsi: host 6 channel 0 id 0
lun1934688609 has a LUN larger than allowed by the host adapter
Aug  2 16:17:22 backend02 kernel: [   41.769985] sd 6:0:0:0: [sdc] Write
Protect is off
Aug  2 16:17:22 backend02 kernel: [   41.769988] sd 6:0:0:0: [sdc] Mode Sense:
b7 00 00 08
Aug  2 16:17:22 backend02 kernel: [   41.770145] sd 6:0:0:0: [sdc] Write cache:
enabled, read cache: enabled, doesn't support DPO or FUA
Aug  2 16:17:22 backend02 kernel: [   41.770819]  sdc: unknown partition table
Aug  2 16:17:22 backend02 kernel: [   43.137000] ehci_hcd 0000:00:1d.7: PCI INT
A -> GSI 23 (level, low) -> IRQ 23
Aug  2 16:17:22 backend02 kernel: [   43.137434]  unknown partition table
Aug  2 16:17:22 backend02 kernel: [   43.137715] sd 6:0:0:0: [sdc] Attached
SCSI disk

Including "unknown partition table" which isn't true, cause each LUN contains
one partition of type 0xFD Linux RAID autodetect.

After this there come the error messages which in my pinpoint the real problem:

Aug  2 16:17:22 backend02 kernel: [   73.342434] mptscsih: ioc0: attempting
task abort! (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [   73.378007] mptscsih: ioc1: attempting
task abort! (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [   73.378009] sd 6:0:0:0: [sdc] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [   73.378143] mptscsih: ioc1: task abort:
FAILED (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [   73.378146] mptscsih: ioc1: attempting
target reset! (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [   73.378148] sd 6:0:0:0: [sdc] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [   73.378508] mptscsih: ioc1: target reset:
SUCCESS (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [   73.905285] sd 5:0:0:0: [sdb] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [   73.989932] mptscsih: ioc0: task abort:
FAILED (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [   74.066044] mptscsih: ioc0: attempting
target reset! (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [   74.148385] sd 5:0:0:0: [sdb] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [   74.233436] mptscsih: ioc0: target reset:
SUCCESS (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  104.343825] mptscsih: ioc0: attempting
task abort! (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  104.355877] mptscsih: ioc1: attempting
task abort! (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  104.355878] sd 6:0:0:0: [sdc] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  104.356002] mptscsih: ioc1: task abort:
FAILED (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  104.356004] mptscsih: ioc1: attempting
target reset! (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  104.356005] sd 6:0:0:0: [sdc] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  104.356365] mptscsih: ioc1: target reset:
SUCCESS (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  104.906661] sd 5:0:0:0: [sdb] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  104.991288] mptscsih: ioc0: task abort:
FAILED (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  105.067390] mptscsih: ioc0: attempting
target reset! (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  105.149731] sd 5:0:0:0: [sdb] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  105.234778] mptscsih: ioc0: target reset:
SUCCESS (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  135.322725] mptscsih: ioc0: attempting
task abort! (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  135.334773] mptscsih: ioc1: attempting
task abort! (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  135.334775] sd 6:0:0:0: [sdc] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  135.334900] mptscsih: ioc1: task abort:
FAILED (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  135.334903] mptscsih: ioc1: attempting
target reset! (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  135.334904] sd 6:0:0:0: [sdc] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  135.335262] mptscsih: ioc1: target reset:
SUCCESS (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  135.885560] sd 5:0:0:0: [sdb] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  135.970189] mptscsih: ioc0: task abort:
FAILED (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  136.046292] mptscsih: ioc0: attempting
target reset! (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  136.128630] sd 5:0:0:0: [sdb] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  136.213683] mptscsih: ioc0: target reset:
SUCCESS (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  166.301627] mptscsih: ioc0: attempting
task abort! (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  166.313676] mptscsih: ioc1: attempting
task abort! (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  166.313677] sd 6:0:0:0: [sdc] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  166.313807] mptscsih: ioc1: task abort:
FAILED (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  166.313810] mptscsih: ioc1: attempting
target reset! (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  166.313811] sd 6:0:0:0: [sdc] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  166.314172] mptscsih: ioc1: target reset:
SUCCESS (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  166.864460] sd 5:0:0:0: [sdb] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  166.949102] mptscsih: ioc0: task abort:
FAILED (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  167.025204] mptscsih: ioc0: attempting
target reset! (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  167.107544] sd 5:0:0:0: [sdb] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  167.192601] mptscsih: ioc0: target reset:
SUCCESS (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  197.280524] mptscsih: ioc0: attempting
task abort! (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  197.292576] mptscsih: ioc1: attempting
task abort! (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  197.292577] sd 6:0:0:0: [sdc] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  197.292709] mptscsih: ioc1: task abort:
FAILED (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  197.292711] mptscsih: ioc1: attempting
target reset! (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  197.292713] sd 6:0:0:0: [sdc] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  197.293073] mptscsih: ioc1: target reset:
SUCCESS (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  197.843362] sd 5:0:0:0: [sdb] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  197.928004] mptscsih: ioc0: task abort:
FAILED (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  198.004106] mptscsih: ioc0: attempting
target reset! (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  198.086446] sd 5:0:0:0: [sdb] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  198.171494] mptscsih: ioc0: target reset:
SUCCESS (sc=ffff88023d7d0e00

After some more tries the driver seems to hand the error to the block layer:

Aug  2 16:17:22 backend02 kernel: [  228.260728] mptscsih: ioc0: attempting
task abort! (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  228.260731] sd 5:0:0:0: [sdb] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  228.260916] mptscsih: ioc0: task abort:
FAILED (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  228.260921] mptscsih: ioc0: attempting
target reset! (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  228.260922] sd 5:0:0:0: [sdb] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  228.261439] mptscsih: ioc0: target reset:
SUCCESS (sc=ffff88023d7d0e00)
Aug  2 16:17:22 backend02 kernel: [  228.275519] mptscsih: ioc1: attempting
task abort! (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  228.275521] sd 6:0:0:0: [sdc] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  228.275701] mptscsih: ioc1: task abort:
FAILED (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  228.275704] mptscsih: ioc1: attempting
target reset! (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  228.275706] sd 6:0:0:0: [sdc] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  228.276073] mptscsih: ioc1: target reset:
SUCCESS (sc=ffff88023d78a400)
Aug  2 16:17:22 backend02 kernel: [  228.278697] sd 5:0:0:0: [sdb] Unhandled
error code
Aug  2 16:17:22 backend02 kernel: [  228.278699] sd 5:0:0:0: [sdb] Result:
hostbyte=DID_ERROR driverbyte=DRIVER_OK
Aug  2 16:17:22 backend02 kernel: [  228.278701] sd 5:0:0:0: [sdb] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  228.278704] end_request: I/O error, dev
sdb, sector 1
Aug  2 16:17:22 backend02 kernel: [  228.278707] Buffer I/O error on device
sdb, logical block 1
Aug  2 16:17:22 backend02 kernel: [  228.278709] Buffer I/O error on device
sdb, logical block 2
Aug  2 16:17:22 backend02 kernel: [  228.278711] Buffer I/O error on device
sdb, logical block 3
Aug  2 16:17:22 backend02 kernel: [  228.278712] Buffer I/O error on device
sdb, logical block 4
Aug  2 16:17:22 backend02 kernel: [  228.278713] Buffer I/O error on device
sdb, logical block 5
Aug  2 16:17:22 backend02 kernel: [  228.278715] Buffer I/O error on device
sdb, logical block 6
Aug  2 16:17:22 backend02 kernel: [  228.278716] Buffer I/O error on device
sdb, logical block 7
Aug  2 16:17:22 backend02 kernel: [  228.278720] Buffer I/O error on device
sdb, logical block 8
Aug  2 16:17:22 backend02 kernel: [  228.278721] Buffer I/O error on device
sdb, logical block 9
Aug  2 16:17:22 backend02 kernel: [  228.278723] Buffer I/O error on device
sdb, logical block 10
Aug  2 16:17:22 backend02 kernel: [  228.293595] sd 6:0:0:0: [sdc] Unhandled
error code
Aug  2 16:17:22 backend02 kernel: [  228.293596] sd 6:0:0:0: [sdc] Result:
hostbyte=DID_ERROR driverbyte=DRIVER_OK
Aug  2 16:17:22 backend02 kernel: [  228.293599] sd 6:0:0:0: [sdc] CDB:
Read(10): 28 00 00 00 00 01 00 00 1f 00
Aug  2 16:17:22 backend02 kernel: [  228.293604] end_request: I/O error, dev
sdc, sector 1

Well when it can't read sector one it also can't read the partition, so maybe
these two are related.


On some occasions we just see each LUN once without any apparent error
messages. In those cases, one of the links do not show a remote port - let me
see whether I find this again. There it is - usually I see both remote ports:

backend01:/sys/module/mptfc/drivers/pci:mptfc# ls -ld 0000\:07\:00.0/host?/rp*
drwxr-xr-x 5 root root 0 2010-08-09 11:02 0000:07:00.0/host3/rport-3:0-0
backend01:/sys/module/mptfc/drivers/pci:mptfc# ls -ld 0000\:07\:00.1/host?/rp*
drwxr-xr-x 5 root root 0 2010-08-09 11:02 0000:07:00.1/host6/rport-6:0-0

In that case where one RAID array is missing, I see a remote port on just one
of the links.

Please tell me whether I should open a seperate bug report regarding this
issue.


Speeds are currently as follows:

backend01:/sys/module/mptfc/drivers/pci:mptfc# grep ""
0000\:07\:00.?/host?/fc_host/host?/speed
0000:07:00.0/host3/fc_host/host3/speed:1 Gbit
0000:07:00.1/host6/fc_host/host6/speed:2 Gbit
backend01:/sys/module/mptfc/drivers/pci:mptfc# grep ""
0000\:07\:00.?/host?/fc_host/host?/supported_speeds
0000:07:00.0/host3/fc_host/host3/supported_speeds:1 Gbit, 2 Gbit, 4 Gbit
0000:07:00.1/host6/fc_host/host6/supported_speeds:1 Gbit, 2 Gbit, 4 Gbit

backend02:/sys/module/mptfc/drivers/pci:mptfc# grep ""
0000\:07\:00.?/host?/fc_host/host?/speed
0000:07:00.0/host1/fc_host/host1/speed:4 Gbit
0000:07:00.1/host2/fc_host/host2/speed:4 Gbit
backend02:/sys/module/mptfc/drivers/pci:mptfc# grep ""
0000\:07\:00.?/host?/fc_host/host?/supported_speeds
0000:07:00.0/host1/fc_host/host1/supported_speeds:1 Gbit, 2 Gbit, 4 Gbit
0000:07:00.1/host2/fc_host/host2/supported_speeds:1 Gbit, 2 Gbit, 4 Gbit

These are autonegioted, I don't think that we set any contraints. I do not know
why server backend01 has lower speeds.


This is the Fibre Channel hostbus adapter in use:

07:00.0 Fibre Channel [0c04]: LSI Logic / Symbios Logic FC949ES Fibre Channel
Adapter [1000:0646] (rev 01)
        Subsystem: LSI Logic / Symbios Logic Device [1000:1020]
        Flags: bus master, fast devsel, latency 0, IRQ 33
        I/O ports at 4000 [size=256]
        Memory at ce320000 (64-bit, non-prefetchable) [size=16K]
        Memory at ce300000 (64-bit, non-prefetchable) [size=64K]
        [virtual] Expansion ROM at c0200000 [disabled] [size=1M]
        Capabilities: [50] Power Management version 2
        Capabilities: [68] Express Endpoint, MSI 00
        Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
        Capabilities: [100] Advanced Error Reporting <?>
        Kernel driver in use: mptfc
        Kernel modules: mptfc

07:00.1 Fibre Channel [0c04]: LSI Logic / Symbios Logic FC949ES Fibre Channel
Adapter [1000:0646] (rev 01)
        Subsystem: LSI Logic / Symbios Logic Device [1000:1020]
        Flags: bus master, fast devsel, latency 0, IRQ 31
        I/O ports at 4400 [size=256]
        Memory at ce324000 (64-bit, non-prefetchable) [size=16K]
        Memory at ce310000 (64-bit, non-prefetchable) [size=64K]
        [virtual] Expansion ROM at c0300000 [disabled] [size=1M]
        Capabilities: [50] Power Management version 2
        Capabilities: [68] Express Endpoint, MSI 00
        Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
        Capabilities: [100] Advanced Error Reporting <?>
        Kernel driver in use: mptfc
        Kernel modules: mptfc


Regarding issues mentioned in the RedHat bug reports:
- There is no smartd or hddtemp running


I will attach a full lspci -nnvv. Please tell when you need any further
details. Please note that these are production machines. I can't bisect between
2.6.26 and 2.6.32 there easily. We might be willing to build / backport a newer
Debian / upstream kernel to these machine when there is a good chance that it
fixes the issue. These are Dual-Quadcore Nehalems so they should be building a
kernel package really fast. Due to the cluster nature of the setup we are able
to do some limited testing.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug.
You are watching the assignee of the bug.
