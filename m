From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Tue, 29 Jun 2010 20:26:49 GMT
Message-ID: <201006292026.o5TKQnf8011351@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34530 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab0F2U0u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jun 2010 16:26:50 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o5TKQnd3011352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2010 20:26:49 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831


starlight@binnacle.cx changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |starlight@binnacle.cx




--- Comment #31 from starlight@binnacle.cx  2010-06-29 20:26:33 ---
FYI

Experiencing same problem on CentOS kernel with latest LSI
driver and and firmware:

LSI 2008
eight Seagate Momentus ST9500420AS SATA drives
LVM2 8x striped LV

CentOS 5.5 kernel 2.6.18-194.3.1.el5
MPT2BIOS 7.05.01.00 (2010.09.09)
SAS2008-IT 5.00.00.00
LSI mpt2sas 05.00.00.00

also

CentOS 5.4 kernel 2.6.18-164.10.1.el5
MPT2BIOS 7.03.00.00 (2009-10-12)
SAS2008-IR 4.00.00.00
distro mpt2sas version 01.101.00.00

-----

With 'smartd' running controller resets and drops last drive 
after about one or two days.  Fails during very light write 
activity rather than heavy write activity.  LV is used for a 
writing a very large log file to an 'ext4' file system.

With 'smartd' disabled ran for longer under mpt2sas v01.101,
but a somewhat different error corrupted the 'ext4' filesystem
after about three weeks.

EXT4-fs error (device dm-19): ext4_mb_generate_buddy: EXT4-fs: group 1168:
32768 blocks in bitmap, 32720 in gd
EXT4-fs error (device dm-19): ext4_mb_mark_diskspace_used: Allocating block
38273024 in system zone of 1168 group
.
.
.
mpt2sas0: attempting task abort! scmd(ffff810130449540)
sd 0:0:2:0: command: Read(10): 28 00 11 35 5b 07 00 00 08 00
mpt2sas0: task abort: SUCCESS scmd(ffff810130449540)
.
.
.

Too soon to tell if mpt2sas-05.00.00.00 is better.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
