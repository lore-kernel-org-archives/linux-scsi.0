From: Mikko Korkalo <mikko@korkalo.fi>
Subject: Re: 2.6.36: Dropped interrupts in ata_piix
Date: Mon, 29 Nov 2010 13:41:29 +0200
Message-ID: <4CF39169.6010601@korkalo.fi>
Reply-To: 4CC78F95.4050107@google.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.f-solutions.fi ([80.75.108.135]:58868 "EHLO
	mail.f-solutions.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab0K2LtB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2010 06:49:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mikew@google.com

Hi,

I am replying to the message here:
http://www.spinics.net/lists/linux-scsi/msg47723.html
(I just registered to the mailing list, so I manually added the Reply-To
header, hopefully it's correct)

It seems I have very similar symptoms with 2.6.36, I can reproduce them
easily in a live system, I could even grant shell access if necessary.
It didn't happen at all with stock ubuntu 8.04 LTS kernel
(2.6.32-25-generic-pae).

Currently, 1 out of 3 SATA hard drives are suffering from this.
I left a dd command overnight to read the drive contents to /dev/null.
One drive didn't finish while all the other drives finished with normal
speeds.
I have attached dmesg and smartctl messages.

Should I try and revert the mentioned patches, or something else?
Anyone able to provide direct links to these patches, I don't normally
involve in kernel development so I'm kind of new to this.

Here are my logs. SMART doesn't report any errors, but I see a lot of
errors in dmesg.

$ sudo smartctl -a /dev/sdc
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD20EADS-00S2B0
Serial Number:    WD-WCAVY0359972
Firmware Version: 04.05G04
User Capacity:    2,000,398,934,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Nov 29 12:18:20 2010 EET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activity
                                        was suspended by an interrupting command from host.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                 (43200) seconds.
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
recommended polling time:        ( 255) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x303f) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       0
  3 Spin_Up_Time            0x0027   157   133   021    Pre-fail  Always       -       9108
  4 Start_Stop_Count        0x0032   099   099   000    Old_age   Always       -       1198
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   085   085   000    Old_age   Always       -       11337
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       58
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       22
193 Load_Cycle_Count        0x0032   172   172   000    Old_age   Always       -       86640
194 Temperature_Celsius     0x0022   109   095   000    Old_age   Always       -       43
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       1279
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      5200         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

$ dmesg|tail -30
[51214.053097] ata4.00: failed command: READ DMA EXT
[51214.055504] ata4.00: cmd 25/00:00:bf:0d:38/00:02:94:00:00/e0 tag 0 dma 262144 in
[51214.055507]          res 40/00:00:00:00:00/84:01:09:00:00/00 Emask 0x24 (host bus error)
[51214.060435] ata4.00: status: { DRDY }
[51214.062824] ata4: soft resetting link
[51214.339049] ata4.00: configured for UDMA/33
[51214.339059] ata4.00: device reported invalid CHS sector 0
[51214.339117] ata4: EH complete
[51253.024028] ata4: lost interrupt (Status 0x51)
[51253.024050] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[51253.026504] ata4.00: BMDMA stat 0x26, BMDMA stat 0x0, BMDMA stat 0x0, BMDMA stat 0x0, BMDMA stat 0x0
[51253.029131] ata4.00: failed command: READ DMA EXT
[51253.031523] ata4.00: cmd 25/00:00:bf:49:38/00:01:94:00:00/e0 tag 0 dma 131072 in
[51253.031526]          res 40/00:00:00:00:00/84:01:09:00:00/00 Emask 0x24 (host bus error)
[51253.036463] ata4.00: status: { DRDY }
[51253.038863] ata4: soft resetting link
[51253.339048] ata4.00: configured for UDMA/33
[51253.339055] ata4.00: device reported invalid CHS sector 0
[51253.339066] ata4: EH complete
[51288.008028] ata4: lost interrupt (Status 0x51)
[51288.008050] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[51288.010468] ata4.00: BMDMA stat 0x26, BMDMA stat 0x0, BMDMA stat 0x0, BMDMA stat 0x0, BMDMA stat 0x0
[51288.013096] ata4.00: failed command: READ DMA EXT
[51288.015506] ata4.00: cmd 25/00:00:bf:5f:38/00:01:94:00:00/e0 tag 0 dma 131072 in
[51288.015509]          res 40/00:00:00:00:00/84:01:09:00:00/00 Emask 0x24 (host bus error)
[51288.020517] ata4.00: status: { DRDY }
[51288.022906] ata4: soft resetting link
[51288.339041] ata4.00: configured for UDMA/33
[51288.339049] ata4.00: device reported invalid CHS sector 0
[51288.339059] ata4: EH complete

My kernel is stock except for BFS scheduler patches. I don't see how that could cause this.

Best Regards
Mikko Korkalo


