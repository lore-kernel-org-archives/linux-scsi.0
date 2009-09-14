From: Gabor Gombas <gombasg@sztaki.hu>
Subject: SMART causes disks to go offline on an LSI SAS 1068 controller
Date: Mon, 14 Sep 2009 16:29:39 +0200
Message-ID: <20090914142939.GE14072@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:41475 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbZINO3h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 10:29:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: smartmontools-support@lists.sourceforge.net, linux-scsi@vger.kernel.org

Hi,

I'm having problems when using smartmontools with SATA disks behind an
LSI SAS controller. The machine is a Dell PowerEdge 1950-II, the
controller in question:

02:08.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic SAS1068 PCI-X Fusion-MPT SAS [1000:0054] (rev 01)
        Subsystem: Dell SAS 5/i Integrated Controller [1028:1f06]
        Flags: bus master, 66MHz, medium devsel, latency 72, IRQ 1270
        I/O ports at ec00 [disabled] [size=256]
        Memory at fc8fc000 (64-bit, non-prefetchable) [size=16K]
        Memory at fc8e0000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at fc900000 [disabled] [size=1M]
        Capabilities: [50] Power Management version 2
        Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
        Capabilities: [68] PCI-X non-bridge device
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
        Kernel driver in use: mptsas
        Kernel modules: mptsas

History:

- The machine was running with kernel 2.6.22 and smartmontools 5.37 &
  5.38 (from Debian) for a long time. smartd occassionally complained
  about "Device: /dev/sdX, not capable of SMART self-check", but other
  than that the machine was stable. smartd configuration:

  /dev/sda -d sat -a -s (L/../../4/03|S/../.././02|O/../../6/03) -m root -I 190 -I 194
  /dev/sdb -d sat -a -s (L/../../4/03|S/../.././02|O/../../6/03) -m root -I 190 -I 194

  sda is a Samsung HD160JJ, sdb is a Seagate ST3160812AS (oh well).

- After switching to 2.6.26 (from Debian Lenny), running smartd started
  to cause the disks to go offline in a couple of hours after boot. Log
  sample:

Sep  7 08:50:36 gw kernel: [4917120.304690] mptscsih: ioc0: attempting task abort! (sc=ffff81007ff26940)
Sep  7 08:50:36 gw kernel: [4917120.304690] sd 0:0:1:0: [sdb] CDB: ATA command pass through(16): 85 08 0e 00 00 00 01 00 00 00 00 00 00 00 ec 00
Sep  7 08:50:40 gw kernel: [4917126.213130] mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Sep  7 08:50:40 gw kernel: [4917126.215970] mptsas: ioc0: removing sata device, channel 0, id 1, phy 1
Sep  7 08:50:40 gw kernel: [4917126.215974]  port-0:1: mptsas: ioc0: delete port (1)
Sep  7 08:50:40 gw kernel: [4917126.216570] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
Sep  7 08:50:40 gw kernel: [4917126.563597] mptscsih: ioc0: task abort: SUCCESS (sc=ffff81007ff26940)
Sep  7 08:50:40 gw kernel: [4917126.563606] mptscsih: ioc0: attempting task abort! (sc=ffff81007ff26bc0)
Sep  7 08:50:40 gw kernel: [4917126.563609] sd 0:0:1:0: [sdb] CDB: Write(10): 2a 00 01 49 f2 98 00 00 08 00
Sep  7 08:50:40 gw kernel: [4917126.563617] mptscsih: ioc0: task abort: SUCCESS (sc=ffff81007ff26bc0)
Sep  7 08:50:40 gw kernel: [4917126.563623] mptscsih: ioc0: attempting target reset! (sc=ffff81007ff26940)
Sep  7 08:50:40 gw kernel: [4917126.563625] sd 0:0:1:0: [sdb] CDB: ATA command pass through(16): 85 08 0e 00 00 00 01 00 00 00 00 00 00 00 ec 00
Sep  7 08:50:40 gw kernel: [4917126.897143] mptscsih: ioc0: target reset: SUCCESS (sc=ffff81007ff26940)
Sep  7 08:50:40 gw kernel: [4917126.897143] mptscsih: ioc0: attempting bus reset! (sc=ffff81007ff26940)
Sep  7 08:50:40 gw kernel: [4917126.897143] sd 0:0:1:0: [sdb] CDB: ATA command pass through(16): 85 08 0e 00 00 00 01 00 00 00 00 00 00 00 ec 00
Sep  7 08:50:44 gw kernel: [4917131.074580] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff81007ff26940)
Sep  7 08:50:54 gw kernel: [4917145.159523] mptscsih: ioc0: attempting host reset! (sc=ffff81007ff26940)
Sep  7 08:50:54 gw kernel: [4917145.163513] mptbase: ioc0: Initiating recovery
Sep  7 08:51:10 gw kernel: [4917167.457273] mptscsih: ioc0: host reset: SUCCESS (sc=ffff81007ff26940)
Sep  7 08:51:10 gw kernel: [4917167.457279] sd 0:0:1:0: Device offlined - not ready after error recovery
Sep  7 08:51:10 gw kernel: [4917167.457282] sd 0:0:1:0: Device offlined - not ready after error recovery
Sep  7 08:51:10 gw kernel: [4917167.457350] sd 0:0:1:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Sep  7 08:51:10 gw kernel: [4917167.457357] end_request: I/O error, dev sdb, sector 21623448
Sep  7 08:51:10 gw kernel: [4917167.457364] raid1: Disk failure on sdb6, disabling device.
Sep  7 08:51:10 gw kernel: [4917167.457365] raid1: Operation continuing on 1 devices.
Sep  7 08:51:10 gw kernel: [4917167.457388] end_request: I/O error, dev sdb, sector 1959743
Sep  7 08:51:10 gw kernel: [4917167.457393] md: super_written gets error=-5, uptodate=0
Sep  7 08:51:10 gw kernel: [4917167.457398] raid1: Disk failure on sdb1, disabling device.
Sep  7 08:51:22 gw kernel: [4917167.457399] raid1: Operation continuing on 1 devices.
Sep  7 08:51:22 gw kernel: [4917167.457411] end_request: I/O error, dev sdb, sector 21478687
Sep  7 08:51:22 gw kernel: [4917167.457415] md: super_written gets error=-5, uptodate=0
Sep  7 08:51:22 gw kernel: [4917167.457420] raid1: Disk failure on sdb5, disabling device.
Sep  7 08:51:22 gw kernel: [4917167.457421] raid1: Operation continuing on 1 devices.
Sep  7 08:51:22 gw kernel: [4917167.461613] sd 0:0:1:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Sep  7 08:51:22 gw kernel: [4917167.526799] raid1: Disk failure on sdb2, disabling device.
Sep  7 08:51:22 gw kernel: [4917167.526801] raid1: Operation continuing on 1 devices.

  After such an error I have to manually remove and re-insert the drive
  to make the controller detect it again.
 
- Upgrading to 2.6.30 (from Debian Sid) did not help.

- Upgrading the controller firmware to the latest version available from
  Dell (the driver reports: FwRev=000a3300h) did not help.

- I've found this thread:
  http://marc.info/?l=smartmontools-support&m=122518510306493&w=2

  It claimed that a similar bug has been fixed in smartd in CVS HEAD as
  of 2008-10-30, so I've upgraded to smartmontools 5.38+svn2879-4 from
  Debian Sid (smartctl -V gives: smartctl 5.39 2009-08-29 r2879), but
  that also did not help.

Is this a kernel bug (2.6.22 at least did not drop the disks), or a bug
in smartmontools?

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
