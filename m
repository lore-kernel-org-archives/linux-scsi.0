From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15623] doesn't allow SMART-passthrough on Adaptec Series 5
 controller
Date: Wed, 24 Mar 2010 18:45:48 GMT
Message-ID: <201003241845.o2OIjmNv014049@demeter.kernel.org>
References: <bug-15623-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48317 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab0CXSpx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2010 14:45:53 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2OIjmNH014051
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2010 18:45:49 GMT
In-Reply-To: <bug-15623-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15623





--- Comment #2 from lkolbe@techfak.uni-bielefeld.de  2010-03-24 18:45:10 ---
> So in lk 2.6.32 aacraid driver version 24900 was used
> successfully but with lk 2.6.33 the aacraid driver
> version reverted to 24702 and didn't work. It might be
> interesting to find the aacraid changelog between those
> two versions.

I wonder as well. Vanilla 2.6.32 has aacraid version 2461 (IIRC), vanilla
2.6.33 has 24702, and Adaptec upstream has 24900, which is what they recommend
for using for the 'enterprise'. I have no idea about the politics side of this,
if there is any. There must be some reason why vanilla doesn't include 24900 by
default, though - it was released in 9/2009 IIRC.

> Anyway the kernel messages shown by dmesg are just
> noise and should disappear in lk 2.6.34 .
> IOW "ATA pass through information available" indicates
> normal operation of SAT.

Great, less noise ;)

> smartctl will provide more debug information if a
> '-r ioctl,3' option is added.

good to know, output follows:

smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce
Allen
Home page is http://smartmontools.sourceforge.net/


REPORT-IOCTL: DeviceFD=3 Command=IDENTIFY DEVICE
 [ata pass-through(16): 85 08 0e 00 00 00 01 00 00 00 00 00 00 00 ec 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=12 milliseconds  resid=0
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
REPORT-IOCTL: DeviceFD=3 Command=IDENTIFY DEVICE returned 0

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
Device Model:     ST31000340NS
Serial Number:    9QJ2XFQP
Firmware Version: SN06
User Capacity:    1,000,204,886,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Wed Mar 24 18:40:13 2010 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF ENABLE/DISABLE COMMANDS SECTION ===

REPORT-IOCTL: DeviceFD=3 Command=SMART ENABLE
 [ata pass-through(16): 85 06 0c 00 d8 00 00 00 01 00 4f 00 c2 00 b0 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=20 milliseconds  resid=0
  status=0x0
REPORT-IOCTL: DeviceFD=3 Command=SMART ENABLE returned 0
SMART Enabled.

REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS
 [ata pass-through(16): 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00 ]
  scsi_status=0x2, host_status=0x7, driver_status=0x8
  info=0x1  duration=104 milliseconds  resid=0
sat_command_interface: do_scsi_cmnd_io() failed, status=-5
REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS returned -1
SMART Disabled. Use option -s with argument 'on' to enable it.


> Doug Gilbert

Kind regards,
Lukas

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
