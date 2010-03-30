From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15623] doesn't allow SMART-passthrough on Adaptec Series 5
 controller
Date: Tue, 30 Mar 2010 10:52:20 GMT
Message-ID: <201003301052.o2UAqKQE015534@demeter.kernel.org>
References: <bug-15623-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53483 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab0C3KwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2010 06:52:22 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2UAqLXL015537
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 30 Mar 2010 10:52:21 GMT
In-Reply-To: <bug-15623-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15623





--- Comment #5 from lkolbe@techfak.uni-bielefeld.de  2010-03-30 10:52:08 ---
fyi: It seems that smartmontools 5.39 are able to extract the SMART-Data using
aacraid 24702:

smartctl 5.39.1 2010-01-28 r3054 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net


REPORT-IOCTL: Device=/dev/sg5 Command=IDENTIFY DEVICE
 Input:   FR=...., SC=0x01, LL=...., LM=...., LH=...., DEV=...., CMD=0xec IN
 [ata pass-through(16): 85 08 0e 00 00 00 01 00 00 00 00 00 00 00 ec 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=8 milliseconds  resid=0
  Incoming data, len=512 [only first 256 bytes shown]:
 00     5a 0c ff 3f 37 c8 10 00  00 00 00 00 3f 00 00 00                        
 10     00 00 00 00 20 20 20 20  20 20 20 20 20 20 20 20                        
 20     51 39 32 4a 46 58 50 51  00 00 00 00 04 00 4e 53                        
 30     36 30 20 20 20 20 54 53  31 33 30 30 33 30 30 34                        
 40     53 4e 20 20 20 20 20 20  20 20 20 20 20 20 20 20                        
 50     20 20 20 20 20 20 20 20  20 20 20 20 20 20 10 80                        
 60     00 00 00 2f 00 40 00 02  00 02 07 00 ff 3f 10 00                        
 70     3f 00 10 fc fb 00 10 00  ff ff ff 0f 00 00 07 00                        
 80     03 00 78 00 78 00 78 00  78 00 00 00 00 00 00 00                        
 90     00 00 00 00 00 00 1f 00  06 05 00 00 40 00 40 00                        
 a0     f0 01 29 00 6b 34 01 7d  23 41 49 34 01 bc 23 41                        
 b0     7f 40 61 00 61 00 00 00  fe ff 00 00 00 fe 00 00                        
 c0     00 00 00 00 00 00 00 00  b0 6d 70 74 00 00 00 00                        
 d0     00 00 00 00 00 00 00 00  00 50 00 c5 af 10 7e 93                        
 e0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 1e 40                        
 f0     1c 40 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
  status=0x0
REPORT-IOCTL: Device=/dev/sg5 Command=IDENTIFY DEVICE returned 0

===== [IDENTIFY DEVICE] DATA START (BASE-16) =====
000-015: 5a 0c ff 3f 37 c8 10 00 00 00 00 00 3f 00 00 00
016-031: 00 00 00 00 20 20 20 20 20 20 20 20 20 20 20 20
032-047: 51 39 32 4a 46 58 50 51 00 00 00 00 04 00 4e 53
048-063: 36 30 20 20 20 20 54 53 31 33 30 30 33 30 30 34
064-079: 53 4e 20 20 20 20 20 20 20 20 20 20 20 20 20 20
080-095: 20 20 20 20 20 20 20 20 20 20 20 20 20 20 10 80
096-111: 00 00 00 2f 00 40 00 02 00 02 07 00 ff 3f 10 00
112-127: 3f 00 10 fc fb 00 10 00 ff ff ff 0f 00 00 07 00
128-143: 03 00 78 00 78 00 78 00 78 00 00 00 00 00 00 00
144-159: 00 00 00 00 00 00 1f 00 06 05 00 00 40 00 40 00
160-175: f0 01 29 00 6b 34 01 7d 23 41 49 34 01 bc 23 41
176-191: 7f 40 61 00 61 00 00 00 fe ff 00 00 00 fe 00 00
192-207: 00 00 00 00 00 00 00 00 b0 6d 70 74 00 00 00 00
208-223: 00 00 00 00 00 00 00 00 00 50 00 c5 af 10 7e 93
224-239: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1e 40
240-255: 1c 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00
256-271: 21 00 b0 6d 70 74 b0 6d 70 74 20 20 02 00 40 01
272-287: 00 01 00 50 06 3c 0a 3c 00 00 3c 00 00 00 08 00
288-303: 00 00 00 00 0f 00 80 02 00 00 00 00 08 00 00 00
304-319: 00 00 00 00 00 00 00 00 00 00 00 00 00 27 00 80
320-335: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
336-351: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
352-367: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
368-383: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
384-399: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
400-415: 00 00 00 00 00 00 00 00 00 00 00 00 3d 10 00 00
416-431: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
432-447: 00 00 20 1c 00 00 00 00 00 00 00 00 10 10 00 00
448-463: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
464-479: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
480-495: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
496-511: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a5 77
===== [IDENTIFY DEVICE] DATA END (512 Bytes) =====

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda ES.2
Device Model:     ST31000340NS
Serial Number:    9QJ2XFQP
Firmware Version: SN06
User Capacity:    1,000,204,886,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Tue Mar 30 10:46:32 2010 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled


REPORT-IOCTL: Device=/dev/sg5 Command=SMART STATUS
 Input:   FR=0xda, SC=...., LL=...., LM=0x4f, LH=0xc2, DEV=...., CMD=0xb0
 [ata pass-through(16): 85 06 0c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=56 milliseconds  resid=0
  status=0x0
REPORT-IOCTL: Device=/dev/sg5 Command=SMART STATUS returned 0

REPORT-IOCTL: Device=/dev/sg5 Command=SMART STATUS CHECK
 Input:   FR=0xda, SC=...., LL=...., LM=0x4f, LH=0xc2, DEV=...., CMD=0xb0
 [ata pass-through(16): 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00 ]
  scsi_status=0x2, host_status=0x7, driver_status=0x8
  info=0x1  duration=76 milliseconds  resid=0
  >>> Sense buffer, len=22:
 00     72 01 00 1d 00 00 00 0e  09 0c 00 00 00 00 00 00                        
 10     00 4f 00 c2 40 50                                                       
  status=2: [desc] sense_key=1 asc=0 ascq=1d
Values from ATA Return Descriptor are:
 00     09 0c 00 00 00 00 00 00  00 4f 00 c2 40 50                              
 Output: ERR=0x00, SC=0x00, LL=0x00, LM=0x4f, LH=0xc2, DEV=0x40, STS=0x50
REPORT-IOCTL: Device=/dev/sg5 Command=SMART STATUS CHECK returned 0

REPORT-IOCTL: Device=/dev/sg5 Command=SMART READ ATTRIBUTE VALUES
 Input:   FR=0xd0, SC=0x01, LL=...., LM=0x4f, LH=0xc2, DEV=...., CMD=0xb0 IN
 [ata pass-through(16): 85 08 0e 00 d0 00 01 00 00 00 4f 00 c2 00 b0 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=84 milliseconds  resid=0
  Incoming data, len=512 [only first 256 bytes shown]:
 00     0a 00 01 0f 00 51 3f ac  ef 34 07 00 00 00 03 03                        
 10     00 63 62 00 00 00 00 00  00 00 04 32 00 64 64 17                        
 20     00 00 00 00 00 00 05 33  00 64 64 00 00 00 00 00                        
 30     00 00 07 0f 00 51 3c e9  fa 3d 07 00 00 00 09 32                        
 40     00 5a 5a 38 23 00 00 00  00 00 0a 13 00 64 64 00                        
 50     00 00 00 00 00 00 0c 32  00 64 25 17 00 00 00 00                        
 60     00 00 b8 32 00 64 64 00  00 00 00 00 00 00 bb 32                        
 70     00 64 64 00 00 00 00 00  00 00 bc 32 00 64 48 33                        
 80     00 25 00 1f 00 00 bd 3a  00 62 62 02 00 00 00 00                        
 90     00 00 be 22 00 42 3f 22  00 21 24 00 00 00 c2 22                        
 a0     00 22 28 22 00 00 00 0f  00 00 c3 1a 00 38 1b ac                        
 b0     ef 34 07 00 00 00 c5 12  00 64 64 00 00 00 00 00                        
 c0     00 00 c6 10 00 64 64 00  00 00 00 00 00 00 c7 3e                        
 d0     00 c8 c8 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 e0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 f0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
  status=0x0
REPORT-IOCTL: Device=/dev/sg5 Command=SMART READ ATTRIBUTE VALUES returned 0

===== [SMART READ ATTRIBUTE VALUES] DATA START (BASE-16) =====
000-015: 0a 00 01 0f 00 51 3f ac ef 34 07 00 00 00 03 03
016-031: 00 63 62 00 00 00 00 00 00 00 04 32 00 64 64 17
032-047: 00 00 00 00 00 00 05 33 00 64 64 00 00 00 00 00
048-063: 00 00 07 0f 00 51 3c e9 fa 3d 07 00 00 00 09 32
064-079: 00 5a 5a 38 23 00 00 00 00 00 0a 13 00 64 64 00
080-095: 00 00 00 00 00 00 0c 32 00 64 25 17 00 00 00 00
096-111: 00 00 b8 32 00 64 64 00 00 00 00 00 00 00 bb 32
112-127: 00 64 64 00 00 00 00 00 00 00 bc 32 00 64 48 33
128-143: 00 25 00 1f 00 00 bd 3a 00 62 62 02 00 00 00 00
144-159: 00 00 be 22 00 42 3f 22 00 21 24 00 00 00 c2 22
160-175: 00 22 28 22 00 00 00 0f 00 00 c3 1a 00 38 1b ac
176-191: ef 34 07 00 00 00 c5 12 00 64 64 00 00 00 00 00
192-207: 00 00 c6 10 00 64 64 00 00 00 00 00 00 00 c7 3e
208-223: 00 c8 c8 00 00 00 00 00 00 00 00 00 00 00 00 00
224-239: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
240-255: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
256-271: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
272-287: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
288-303: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
304-319: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
320-335: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
336-351: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
352-367: 00 00 00 00 00 00 00 00 00 00 82 00 71 02 00 7b
368-383: 03 00 01 00 01 e2 02 00 00 00 00 00 00 00 00 00
384-399: 00 00 05 00 00 00 00 00 07 01 01 01 01 01 01 01
400-415: 01 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00
416-431: 00 00 00 00 00 00 00 00 72 1d 96 b2 85 1d 00 00
432-447: 00 00 00 00 01 00 ad da 12 db 18 fd 4c 0a 00 00
448-463: 21 31 38 07 89 df 04 00 00 00 00 00 db 5a 16 00
464-479: 00 00 00 00 00 00 00 00 1f 20 00 00 00 00 00 00
480-495: 17 00 00 00 0c 29 00 00 00 00 00 00 00 00 00 00
496-511: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fb
===== [SMART READ ATTRIBUTE VALUES] DATA END (512 Bytes) =====


REPORT-IOCTL: Device=/dev/sg5 Command=SMART READ ATTRIBUTE THRESHOLDS
 Input:   FR=0xd1, SC=0x01, LL=0x01, LM=0x4f, LH=0xc2, DEV=...., CMD=0xb0 IN
 [ata pass-through(16): 85 08 0e 00 d1 00 01 00 01 00 4f 00 c2 00 b0 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=12 milliseconds  resid=0
  Incoming data, len=512 [only first 256 bytes shown]:
 00     01 00 01 2c 00 00 00 00  00 00 00 00 00 00 03 00                        
 10     00 00 00 00 00 00 00 00  00 00 04 14 00 00 00 00                        
 20     00 00 00 00 00 00 05 24  00 00 00 00 00 00 00 00                        
 30     00 00 07 1e 00 00 00 00  00 00 00 00 00 00 09 00                        
 40     00 00 00 00 00 00 00 00  00 00 0a 61 00 00 00 00                        
 50     00 00 00 00 00 00 0c 14  00 00 00 00 00 00 00 00                        
 60     00 00 b8 63 00 00 00 00  00 00 00 00 00 00 bb 00                        
 70     00 00 00 00 00 00 00 00  00 00 bc 00 00 00 00 00                        
 80     00 00 00 00 00 00 bd 00  00 00 00 00 00 00 00 00                        
 90     00 00 be 2d 00 00 00 00  00 00 00 00 00 00 c2 00                        
 a0     00 00 00 00 00 00 00 00  00 00 c3 00 00 00 00 00                        
 b0     00 00 00 00 00 00 c5 00  00 00 00 00 00 00 00 00                        
 c0     00 00 c6 00 00 00 00 00  00 00 00 00 00 00 c7 00                        
 d0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 e0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 f0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
  status=0x0
REPORT-IOCTL: Device=/dev/sg5 Command=SMART READ ATTRIBUTE THRESHOLDS returned
0

===== [SMART READ ATTRIBUTE THRESHOLDS] DATA START (BASE-16) =====
000-015: 01 00 01 2c 00 00 00 00 00 00 00 00 00 00 03 00
016-031: 00 00 00 00 00 00 00 00 00 00 04 14 00 00 00 00
032-047: 00 00 00 00 00 00 05 24 00 00 00 00 00 00 00 00
048-063: 00 00 07 1e 00 00 00 00 00 00 00 00 00 00 09 00
064-079: 00 00 00 00 00 00 00 00 00 00 0a 61 00 00 00 00
080-095: 00 00 00 00 00 00 0c 14 00 00 00 00 00 00 00 00
096-111: 00 00 b8 63 00 00 00 00 00 00 00 00 00 00 bb 00
112-127: 00 00 00 00 00 00 00 00 00 00 bc 00 00 00 00 00
128-143: 00 00 00 00 00 00 bd 00 00 00 00 00 00 00 00 00
144-159: 00 00 be 2d 00 00 00 00 00 00 00 00 00 00 c2 00
160-175: 00 00 00 00 00 00 00 00 00 00 c3 00 00 00 00 00
176-191: 00 00 00 00 00 00 c5 00 00 00 00 00 00 00 00 00
192-207: 00 00 c6 00 00 00 00 00 00 00 00 00 00 00 c7 00
208-223: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
224-239: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
240-255: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
256-271: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
272-287: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
288-303: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
304-319: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
320-335: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
336-351: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
352-367: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
368-383: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
384-399: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
400-415: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
416-431: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
432-447: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
448-463: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
464-479: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
480-495: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
496-511: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c4
===== [SMART READ ATTRIBUTE THRESHOLDS] DATA END (512 Bytes) =====

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection activity
                    was completed without error.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test routine
completed
                    without error or no self-test has ever 
                    been run.
Total time to complete Offline 
data collection:          ( 625) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine 
recommended polling time:      (   1) minutes.
Extended self-test routine
recommended polling time:      ( 226) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x103d)    SCT Status supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED 
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   081   063   044    Pre-fail  Always      
-       120909740
  3 Spin_Up_Time            0x0003   099   098   000    Pre-fail  Always      
-       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always      
-       23
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always      
-       0
  7 Seek_Error_Rate         0x000f   081   060   030    Pre-fail  Always      
-       121502441
  9 Power_On_Hours          0x0032   090   090   000    Old_age   Always      
-       9016
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always      
-       0
 12 Power_Cycle_Count       0x0032   100   037   020    Old_age   Always      
-       23
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always      
-       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always      
-       0
188 Command_Timeout         0x0032   100   072   000    Old_age   Always      
-       133146411059
189 High_Fly_Writes         0x003a   098   098   000    Old_age   Always      
-       2
190 Airflow_Temperature_Cel 0x0022   066   063   045    Old_age   Always      
-       34 (Lifetime Min/Max 33/36)
194 Temperature_Celsius     0x0022   034   040   000    Old_age   Always      
-       34 (0 15 0 0)
195 Hardware_ECC_Recovered  0x001a   056   027   000    Old_age   Always      
-       120909740
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always      
-       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline     
-       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always      
-       0


REPORT-IOCTL: Device=/dev/sg5 Command=SMART READ LOG InputParameter=1
 Input:   FR=0xd5, SC=0x01, LL=0x01, LM=0x4f, LH=0xc2, DEV=...., CMD=0xb0 IN
 [ata pass-through(16): 85 08 0e 00 d5 00 01 00 01 00 4f 00 c2 00 b0 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=20 milliseconds  resid=0
  Incoming data, len=512 [only first 256 bytes shown]:
 00     01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 20     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 30     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 40     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 50     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 60     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 70     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 80     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 90     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 a0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 b0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 c0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 d0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 e0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 f0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
  status=0x0
REPORT-IOCTL: Device=/dev/sg5 Command=SMART READ LOG returned 0

===== [SMART READ LOG] DATA START (BASE-16) =====
000-015: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
016-031: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
032-047: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
048-063: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
064-079: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
080-095: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
096-111: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
112-127: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
128-143: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
144-159: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
160-175: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
176-191: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
192-207: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
208-223: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
224-239: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
240-255: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
256-271: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
272-287: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
288-303: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
304-319: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
320-335: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
336-351: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
352-367: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
368-383: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
384-399: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
400-415: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
416-431: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
432-447: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
448-463: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
464-479: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
480-495: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
496-511: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff
===== [SMART READ LOG] DATA END (512 Bytes) =====

SMART Error Log Version: 1
No Errors Logged


REPORT-IOCTL: Device=/dev/sg5 Command=SMART READ LOG InputParameter=6
 Input:   FR=0xd5, SC=0x01, LL=0x06, LM=0x4f, LH=0xc2, DEV=...., CMD=0xb0 IN
 [ata pass-through(16): 85 08 0e 00 d5 00 01 00 06 00 4f 00 c2 00 b0 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=56 milliseconds  resid=0
  Incoming data, len=512 [only first 256 bytes shown]:
 00     01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 20     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 30     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 40     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 50     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 60     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 70     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 80     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 90     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 a0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 b0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 c0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 d0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 e0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 f0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
  status=0x0
REPORT-IOCTL: Device=/dev/sg5 Command=SMART READ LOG returned 0

===== [SMART READ LOG] DATA START (BASE-16) =====
000-015: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
016-031: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
032-047: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
048-063: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
064-079: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
080-095: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
096-111: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
112-127: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
128-143: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
144-159: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
160-175: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
176-191: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
192-207: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
208-223: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
224-239: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
240-255: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
256-271: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
272-287: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
288-303: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
304-319: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
320-335: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
336-351: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
352-367: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
368-383: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
384-399: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
400-415: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
416-431: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
432-447: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
448-463: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
464-479: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
480-495: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
496-511: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff
===== [SMART READ LOG] DATA END (512 Bytes) =====

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]



REPORT-IOCTL: Device=/dev/sg5 Command=SMART READ LOG InputParameter=9
 Input:   FR=0xd5, SC=0x01, LL=0x09, LM=0x4f, LH=0xc2, DEV=...., CMD=0xb0 IN
 [ata pass-through(16): 85 08 0e 00 d5 00 01 00 09 00 4f 00 c2 00 b0 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=8 milliseconds  resid=0
  Incoming data, len=512 [only first 256 bytes shown]:
 00     01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 20     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 30     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 40     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 50     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 60     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 70     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 80     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 90     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 a0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 b0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 c0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 d0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 e0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
 f0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00                        
  status=0x0
REPORT-IOCTL: Device=/dev/sg5 Command=SMART READ LOG returned 0

===== [SMART READ LOG] DATA START (BASE-16) =====
000-015: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
016-031: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
032-047: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
048-063: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
064-079: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
080-095: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
096-111: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
112-127: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
128-143: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
144-159: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
160-175: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
176-191: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
192-207: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
208-223: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
224-239: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
240-255: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
256-271: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
272-287: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
288-303: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
304-319: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
320-335: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
336-351: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
352-367: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
368-383: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
384-399: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
400-415: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
416-431: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
432-447: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
448-463: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
464-479: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
480-495: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
496-511: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff
===== [SMART READ LOG] DATA END (512 Bytes) =====

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

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
