From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13594] SMART responses for SATA disks on SAS get interpreted as
 errors
Date: Sat, 21 Nov 2009 00:20:32 GMT
Message-ID: <200911210020.nAL0KWWJ030566@demeter.kernel.org>
References: <bug-13594-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56991 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZKUAU0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2009 19:20:26 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAL0KWqC030567
	for <linux-scsi@vger.kernel.org>; Sat, 21 Nov 2009 00:20:32 GMT
In-Reply-To: <bug-13594-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13594


Al Tobey <tobert@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tobert@gmail.com




--- Comment #8 from Al Tobey <tobert@gmail.com>  2009-11-21 00:20:30 ---
I get the same issue on LSI SAS2008 using the mpt2sas driver in 2.6.32-rc5.  
It wouldn't be a big deal, but it actually increments
/sys/block/$dev/device/ioerr_cnt, which I'd like to use for quick & dirty
checks for drives going south (I realize it's not perfect).

This occurs with both smartmontools 5.38-2+lenny1 as shipped with Debian 5 and
with a local backport of 5.38+svn2956 from experimental.

Trying smartctl -d scsi returns an outright failure. 

I can also reproduce with sg_sat_identify -c.

~$ sudo sg_sat_identify -c /dev/sg13
~$ dmesg |tail -n 5
sd 4:0:11:0: [sg13] Sense Key : Recovered Error [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00 
        00 00 00 00 00 00 
sd 4:0:11:0: [sg13] Add. Sense: ATA pass through information available

~$ cat /sys/block/sdm/device/ioerr_cnt
0x5

~$ sudo smartctl -d sat -q errorsonly -H /dev/sdm
smartctl 5.39 2009-10-10 r2955 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-9 by Bruce Allen, http://smartmontools.sourceforge.net

Warning! SMART Attribute Thresholds Structure error: invalid SMART checksum.
=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

~$ cat /sys/block/sdm/device/ioerr_cnt
0x6

~$ cat /sys/class/scsi_host/host4/device_delay
00
~$ cat /sys/class/scsi_host/host4/version_fw
02.00.50.00
~$ cat /sys/class/scsi_host/host4/version_mpi
200.0b
~$ cat /sys/class/scsi_host/host4/version_product 
LSISAS2008
~$ cat /sys/class/scsi_host/host4/version_bios
07.01.01.00

~$ sudo sg_inq /dev/sg12
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=1  Resp_data_format=2
  SCCS=0  ACC=0  TGPS=0  3PC=0  Protect=0  BQue=0
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=74 (0x4a)   Peripheral device type: disk
 Vendor identification: ATA     
 Product identification: WDC WD2002FYPS-0
 Product revision level: 5G04
 Unit serial number:      WD-WCAVY0517841

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
