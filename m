From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.34.1: link online but device misclassifed / input/output error
Date: Mon, 12 Jul 2010 16:36:50 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.1007121633320.5154@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:52510 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab0GLUpm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 16:45:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hello,

I have two thermaltake docks with two 150GB velociraptors.

It happens on both drives, each on a separate thermaltake dock.

When I run smartctl -a, it hangs when it tries to read the self-test log:

# smartctl -a /dev/sdd
smartctl 5.40 2010-03-16 r3077 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital VelociRaptor family
Device Model:     WDC WD1500HLFS-01G6U3
Serial Number:    --------------
Firmware Version: 04.04V05
User Capacity:    150,039,945,216 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Jul 12 16:33:13 2010 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

Error SMART Thresholds Read failed: Input/output error
Smartctl: SMART Read Thresholds failed.

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80) Offline data collection activity
                                         was never started.
                                         Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                         without error or no self-test has ever
                                         been run.
Total time to complete Offline 
data collection:                 (2400) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                         Auto Offline data collection on/off support.
                                         Suspend Offline collection upon new
                                         command.
                                         Offline surface scan supported.
                                         Self-test supported.
                                         Conveyance Self-test supported.
                                         Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                         power-saving mode.
                                         Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                         General Purpose Logging supported.
Short self-test routine 
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  32) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x303f) SCT Status supported.
                                         SCT Error Recovery Control supported.
                                         SCT Feature Control supported.
                                         SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   100   253   ---    Pre-fail  Always       -       0
   3 Spin_Up_Time            0x0003   200   200   ---    Pre-fail  Always       -       2991
   4 Start_Stop_Count        0x0032   100   100   ---    Old_age   Always       -       10
   5 Reallocated_Sector_Ct   0x0033   200   200   ---    Pre-fail  Always       -       0
   7 Seek_Error_Rate         0x000e   100   253   ---    Old_age   Always       -       0
   9 Power_On_Hours          0x0032   100   100   ---    Old_age   Always       -       0
  10 Spin_Retry_Count        0x0012   100   253   ---    Old_age   Always       -       0
  11 Calibration_Retry_Count 0x0012   100   253   ---    Old_age   Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   ---    Old_age   Always       -       10
192 Power-Off_Retract_Count 0x0032   200   200   ---    Old_age   Always       -       9
193 Load_Cycle_Count        0x0032   200   200   ---    Old_age   Always       -       10
194 Temperature_Celsius     0x0022   122   116   ---    Old_age   Always       -       25
196 Reallocated_Event_Count 0x0032   200   200   ---    Old_age   Always       -       0
197 Current_Pending_Sector  0x0012   200   200   ---    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   253   ---    Old_age   Offline      -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   ---    Old_age   Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]


Error SMART Read Selective Self-Test Log failed: Input/output error
Smartctl: SMART Selective Self Test Log Read Failed
p34:~#

--

[  112.535712] ata10: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
[  112.535717] ata10: irq_stat 0x02400000, PHY RDY changed
[  112.535725] ata10: hard resetting link
[  116.981140] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  116.990551] ata10.00: ATA-8: WDC WD1500HLFS-01G6U1, 04.04V02, max UDMA/133
[  116.990557] ata10.00: 293046768 sectors, multi 0: LBA48 
[  116.994261] ata10.00: configured for UDMA/133
[  116.994265] ata10: EH complete
[  116.994389] scsi 11:0:0:0: Direct-Access     ATA      WDC WD1500HLFS-0 04.0 PQ: 0 ANSI: 5
[  116.994493] sd 11:0:0:0: [sdc] 293046768 512-byte logical blocks: (150 GB/139 GiB)
[  116.994513] sd 11:0:0:0: [sdc] Write Protect is off
[  116.994514] sd 11:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[  116.994523] sd 11:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  116.994579]  sdc: unknown partition table
[  117.003178] sd 11:0:0:0: [sdc] Attached SCSI disk
[  154.893776] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  154.893783] ata10.00: failed command: SMART
[  154.893792] ata10.00: cmd b0/d5:01:06:4f:c2/00:00:00:00:00/00 tag 0 pio 512 in
[  154.893794]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  154.893797] ata10.00: status: { DRDY }
[  154.893803] ata10: hard resetting link
[  155.198680] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  155.198691] ata10.00: link online but device misclassifed
[  155.206089] ata10.00: configured for UDMA/133
[  155.206108] ata10: EH complete
[  176.286644] ata9: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
[  176.286649] ata9: irq_stat 0x02400000, PHY RDY changed
[  176.286657] ata9: hard resetting link
[  178.889785] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  178.889791] ata10.00: failed command: SMART
[  178.889800] ata10.00: cmd b0/d5:01:09:4f:c2/00:00:00:00:00/00 tag 0 pio 512 in
[  178.889802]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  178.889806] ata10.00: status: { DRDY }
[  178.889810] ata10: hard resetting link
[  179.194749] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  179.194761] ata10.00: link online but device misclassifed
[  179.202676] ata10.00: configured for UDMA/133
[  179.202691] ata10: EH complete
[  181.853312] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  181.864114] ata9.00: ATA-8: WDC WD1500HLFS-01G6U3, 04.04V05, max UDMA/133
[  181.864119] ata9.00: 293046768 sectors, multi 0: LBA48 
[  181.867582] ata9.00: configured for UDMA/133
[  181.867590] ata9: EH complete
[  181.867747] scsi 10:0:0:0: Direct-Access     ATA      WDC WD1500HLFS-0 04.0 PQ: 0 ANSI: 5
[  181.867908] sd 10:0:0:0: [sdd] 293046768 512-byte logical blocks: (150 GB/139 GiB)
[  181.867927] sd 10:0:0:0: [sdd] Write Protect is off
[  181.867928] sd 10:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[  181.867936] sd 10:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  181.867990]  sdd: unknown partition table
[  181.870859] sd 10:0:0:0: [sdd] Attached SCSI disk
[  203.888696] ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  203.888705] ata9.00: failed command: SMART
[  203.888717] ata9.00: cmd b0/d5:01:09:4f:c2/00:00:00:00:00/00 tag 0 pio 512 in
[  203.888719]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  203.888725] ata9.00: status: { DRDY }
[  203.888733] ata9: hard resetting link
[  204.193579] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  204.193590] ata9.00: link online but device misclassifed
[  204.200938] ata9.00: configured for UDMA/133
[  204.200956] ata9: EH complete

Justin.

