From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: sd or block: regression in 2.6.28-rc WRT manage_start_stop
Date: Wed, 26 Nov 2008 23:56:19 +0100
Message-ID: <492DD413.70400@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:34395 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYKZW42 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2008 17:56:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux1394-devel@lists.sourceforge.net

Hi,

I only recently switched from 2.6.27.y to 2.6.28-rc6 and discovered the
following regression with some FireWire HDDs (based on the OXUF 922,
OXFW 921, OXUF 924DSB SBP-2 to IDE or SATA bridge chips).

The background is that the SBP-2 drivers switch sdev->manage_start_stop
unconditionally on for all HDDs since Linux 2.6.27.  For example, when I
unload firewire-sbp2, the disk's spindle is stopped.  When I then reload
firewire-sbp2, the SCSI stack does not succeed to restart the HDD under
Linux 2.6.28-rc6.  It worked under 2.6.27.y.

This does not happen with some other disks (tested: HDDs based on OXFW
911, PL-3507, TSB42AA9).  The difference between the failing disks and
the unaffected disks is explained below.


=== example of a failing session, 2.6.26-rc8 ===

# modprobe -r firewire-sbp2

Nov 26 23:25:34 mini sd 2:0:0:0: [sdb] Synchronizing SCSI cache
Nov 26 23:25:34 mini sd 2:0:0:0: [sdb] Stopping disk
Nov 26 23:25:34 mini firewire_sbp2: released fw1.0, target 2:0:0

# modprobe firewire-sbp2

Nov 26 23:25:44 mini scsi3 : SBP-2 IEEE-1394
Nov 26 23:25:44 mini firewire_sbp2: fw1.0: logged in to LUN 0000 (0 retries)
Nov 26 23:25:44 mini scsi 3:0:0:0: Direct-Access-RBC ST340083 2A
       3.03 PQ: 0 ANSI: 4
Nov 26 23:25:44 mini sd 3:0:0:0: [sdb] 781422768 512-byte hardware
sectors: (400 GB/372 GiB)
Nov 26 23:25:44 mini sd 3:0:0:0: [sdb] Write Protect is off
Nov 26 23:25:44 mini sd 3:0:0:0: [sdb] Mode Sense: 11 00 00 00
Nov 26 23:25:44 mini sd 3:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
Nov 26 23:25:44 mini sd 3:0:0:0: [sdb] 781422768 512-byte hardware
sectors: (400 GB/372 GiB)
Nov 26 23:25:44 mini sd 3:0:0:0: [sdb] Write Protect is off
Nov 26 23:25:44 mini sd 3:0:0:0: [sdb] Mode Sense: 11 00 00 00
Nov 26 23:25:44 mini sd 3:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
Nov 26 23:25:44 mini sdb:<5>firewire_sbp2: fw1.0: sbp2_scsi_abort
Nov 26 23:25:44 mini sd 3:0:0:0: Device offlined - not ready after error
recovery
Nov 26 23:25:44 mini sd 3:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 26 23:25:44 mini end_request: I/O error, dev sdb, sector 0
Nov 26 23:25:44 mini Buffer I/O error on device sdb, logical block 0
Nov 26 23:25:44 mini sd 3:0:0:0: rejecting I/O to offline device
Nov 26 23:25:44 mini Buffer I/O error on device sdb, logical block 0
Nov 26 23:25:44 mini sd 3:0:0:0: rejecting I/O to offline device
Nov 26 23:25:44 mini Buffer I/O error on device sdb, logical block 0
Nov 26 23:25:44 mini ldm_validate_partition_table(): Disk read failed.
Nov 26 23:25:44 mini sd 3:0:0:0: rejecting I/O to offline device
Nov 26 23:25:44 mini Buffer I/O error on device sdb, logical block 0
Nov 26 23:25:44 mini sd 3:0:0:0: rejecting I/O to offline device
Nov 26 23:25:44 mini Buffer I/O error on device sdb, logical block 0
Nov 26 23:25:44 mini unable to read partition table
Nov 26 23:25:44 mini sd 3:0:0:0: [sdb] Attached SCSI disk
Nov 26 23:25:44 mini sd 3:0:0:0: Attached scsi generic sg1 type 14
Nov 26 23:25:46 mini firewire_core: phy config: card 0, new root=ffc2,
gap_count=7
Nov 26 23:25:46 mini firewire_sbp2: fw1.0: reconnected to LUN 0000 (0
retries)
Nov 26 23:25:53 mini firewire_core: phy config: card 0, new root=ffc2,
gap_count=7
Nov 26 23:25:53 mini firewire_sbp2: fw1.0: reconnected to LUN 0000 (0
retries)


=== example of a working session, 2.6.27.4, same disk ===

# modprobe -r firewire-sbp2

Nov 26 23:28:30 mini sd 2:0:0:0: [sdb] Synchronizing SCSI cache
Nov 26 23:28:30 mini sd 2:0:0:0: [sdb] Stopping disk
Nov 26 23:28:30 mini firewire_sbp2: released fw1.0, target 2:0:0

# modprobe firewire-sbp2

Nov 26 23:29:50 mini scsi4 : SBP-2 IEEE-1394
Nov 26 23:29:50 mini firewire_sbp2: fw1.0: logged in to LUN 0000 (0 retries)
Nov 26 23:29:50 mini scsi 4:0:0:0: Direct-Access-RBC ST340083 2A
       3.03 PQ: 0 ANSI: 4
Nov 26 23:29:50 mini sd 4:0:0:0: [sdb] 781422768 512-byte hardware
sectors (400088 MB)
Nov 26 23:29:50 mini sd 4:0:0:0: [sdb] Write Protect is off
Nov 26 23:29:50 mini sd 4:0:0:0: [sdb] Mode Sense: 11 00 00 00
Nov 26 23:29:50 mini sd 4:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
Nov 26 23:29:50 mini sd 4:0:0:0: [sdb] 781422768 512-byte hardware
sectors (400088 MB)
Nov 26 23:29:50 mini sd 4:0:0:0: [sdb] Write Protect is off
Nov 26 23:29:50 mini sd 4:0:0:0: [sdb] Mode Sense: 11 00 00 00
Nov 26 23:29:50 mini sd 4:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
Nov 26 23:29:58 mini sdb: sdb1
Nov 26 23:29:58 mini sd 4:0:0:0: [sdb] Attached SCSI disk
Nov 26 23:29:58 mini sd 4:0:0:0: Attached scsi generic sg1 type 14


Note how there are 8 seconds pause in the working session between when
the cache type is determined and when the partition table is read.

Compare this with the failing session where there is a command abortion
immediately after the cache type was read.

The failing disks spin up late at the moment when the "reconnected"
messages are logged under 2.6.28-rc, and when they received the first
READ command under 2.6.27.y.  The still working disks spin up earlier or
quicker.
-- 
Stefan Richter
-=====-==--- =-== ==-=-
http://arcgraph.de/sr/
