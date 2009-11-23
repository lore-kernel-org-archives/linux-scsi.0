From: tmhikaru@gmail.com
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem readonly
Date: Mon, 23 Nov 2009 03:09:19 -0500
Message-ID: <20091123080919.GA3115@roll>
References: <20091113050907.GA4965@roll> <20091119160700.GC2943@atrey.karlin.mff.cuni.cz> <20091120082359.GA29538@roll> <20091120094641.GB15422@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091120094641.GB15422@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

	Okay, finally had some time to dismantle the machine in question and
inserted the backup drive without the enclosure. Now that I was able to get
smartctl to give me information on what was going on, it seems there's
nothing wrong with the drive itself (no remapped sectors, nothing prefail or
fail going wrong, drive's smart status is good) but it's had a history of
406 (!!!) errors reported, the last five happening within the same second,
all of which seem (to my untrained eye) to imply a bad IDE cable. Which
means likely my USB enclosure is screwing up.

	To be sure, I did some extended testing with it hooked up: Tried
doing a full and incremental backup of my machine with no errors reported,
as well as an offline and then immediately afterwards, long test via
smartctl. Nothing changed in the output.

	I've attached the output of smartctl at various points in the tests:
the first being the initial immediate display of information at startup, the
second just after the long test, and the third just after the two backups
(Full and incremental) were tried. Nothing seems to shout at me in the
output, I'm frankly pretty sure something's wrong with the enclosure. If
it's the drive, it's not showing up here at least.

	I'd like your thoughts and suggestions on this. While I'm pretty
sure I know what the smartctl output means, I'm always capable of being
entirely wrong. Please let me know if I've misinterpreted the information.

Timothy McGrath
--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=diskstats

smartctl version 5.38 [i486-slackware-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.8 family
Device Model:     ST3250823A
Serial Number:    5ND3CC5A
Firmware Version: 3.06
User Capacity:    250,059,350,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Nov 23 00:23:54 2009 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 ( 430) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 (  84) minutes.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   074   036   006    Pre-fail  Always       -       50613791
  3 Spin_Up_Time            0x0003   099   098   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       112
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   050   047   030    Pre-fail  Always       -       1443141758905
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       354
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       157
194 Temperature_Celsius     0x0022   027   052   000    Old_age   Always       -       27 (0 19 0 0)
195 Hardware_ECC_Recovered  0x001a   051   046   000    Old_age   Always       -       760201
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age   Offline      -       0
202 TA_Increase_Count       0x0032   100   253   000    Old_age   Always       -       0

SMART Error Log Version: 1
ATA Error Count: 406 (device log contains only the most recent five errors)
	CR = Command Register [HEX]
	FR = Features Register [HEX]
	SC = Sector Count Register [HEX]
	SN = Sector Number Register [HEX]
	CL = Cylinder Low Register [HEX]
	CH = Cylinder High Register [HEX]
	DH = Device/Head Register [HEX]
	DC = Device Command Register [HEX]
	ER = Error register [HEX]
	ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 406 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:36.934  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

Error 405 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:36.934  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

Error 404 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:36.934  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

Error 403 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:36.934  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

Error 402 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:30.579  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]


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


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=diskstats2

smartctl version 5.38 [i486-slackware-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.8 family
Device Model:     ST3250823A
Serial Number:    5ND3CC5A
Firmware Version: 3.06
User Capacity:    250,059,350,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Nov 23 02:37:01 2009 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 ( 430) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 (  84) minutes.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   053   036   006    Pre-fail  Always       -       73989115
  3 Spin_Up_Time            0x0003   099   098   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       112
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   050   047   030    Pre-fail  Always       -       1443142340790
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       357
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       157
194 Temperature_Celsius     0x0022   040   052   000    Old_age   Always       -       40 (0 19 0 0)
195 Hardware_ECC_Recovered  0x001a   050   046   000    Old_age   Always       -       33250523
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age   Offline      -       0
202 TA_Increase_Count       0x0032   100   253   000    Old_age   Always       -       0

SMART Error Log Version: 1
ATA Error Count: 406 (device log contains only the most recent five errors)
	CR = Command Register [HEX]
	FR = Features Register [HEX]
	SC = Sector Count Register [HEX]
	SN = Sector Number Register [HEX]
	CL = Cylinder Low Register [HEX]
	CH = Cylinder High Register [HEX]
	DH = Device/Head Register [HEX]
	DC = Device Command Register [HEX]
	ER = Error register [HEX]
	ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 406 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:36.934  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

Error 405 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:36.934  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

Error 404 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:36.934  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

Error 403 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:36.934  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

Error 402 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:30.579  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended captive    Completed without error       00%       356         -

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


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=diskstats3

smartctl version 5.38 [i486-slackware-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.8 family
Device Model:     ST3250823A
Serial Number:    5ND3CC5A
Firmware Version: 3.06
User Capacity:    250,059,350,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Nov 23 02:42:34 2009 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 ( 430) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 (  84) minutes.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   051   036   006    Pre-fail  Always       -       72983290
  3 Spin_Up_Time            0x0003   099   098   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       112
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   050   047   030    Pre-fail  Always       -       1443142359378
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       357
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       157
194 Temperature_Celsius     0x0022   040   052   000    Old_age   Always       -       40 (0 19 0 0)
195 Hardware_ECC_Recovered  0x001a   049   046   000    Old_age   Always       -       48607152
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age   Offline      -       0
202 TA_Increase_Count       0x0032   100   253   000    Old_age   Always       -       0

SMART Error Log Version: 1
ATA Error Count: 406 (device log contains only the most recent five errors)
	CR = Command Register [HEX]
	FR = Features Register [HEX]
	SC = Sector Count Register [HEX]
	SN = Sector Number Register [HEX]
	CL = Cylinder Low Register [HEX]
	CH = Cylinder High Register [HEX]
	DH = Device/Head Register [HEX]
	DC = Device Command Register [HEX]
	ER = Error register [HEX]
	ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 406 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:36.934  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

Error 405 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:36.934  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

Error 404 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:36.934  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

Error 403 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:36.934  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

Error 402 occurred at disk power-on lifetime: 160 hours (6 days + 16 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 01 07 00 00 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00000007 = 7

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 03 08 00 00 00 e0 00      00:00:30.579  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.511  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:36.087  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.663  READ DMA
  c8 03 08 00 00 00 e0 00      00:00:35.240  READ DMA

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended captive    Completed without error       00%       356         -

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


--liOOAslEiF7prFVr--
