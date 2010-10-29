From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13594] SMART responses for SATA disks on SAS get interpreted as
 errors
Date: Fri, 29 Oct 2010 03:30:39 GMT
Message-ID: <201010290330.o9T3Udcb031588@demeter2.kernel.org>
References: <bug-13594-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:57595 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758043Ab0J2Dak (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 23:30:40 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9T3UdPv031589
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2010 03:30:39 GMT
In-Reply-To: <bug-13594-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=13594


pipa.tk <bigplum@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bigplum@gmail.com




--- Comment #18 from pipa.tk <bigplum@gmail.com>  2010-10-29 03:30:34 ---
I also use LSI Logic / Symbios Logic SAS1068E PCI-Express Fusion-MPT SAS and
seagate ST31500341AS 1.5TB harddisk. 

I found that the ST31500341AS has firmware issue:
http://www.avsforum.com/avs-vb/showthread.php?t=1080005. So I check the
/var/log/message and lsscsi, there are 2 firmware version in the server, and
all sdX error messages loged are version SD17. The SD17 version should be
upgrade to SD1B, or it will hung IO for almost half a minute randomly.

Oct 29 08:27:21 XEN-ST-27 kernel: mptscsih: ioc0: attempting task abort!
(sc=ffff8801e5465840)
Oct 29 08:27:21 XEN-ST-27 kernel: sd 4:0:3:0:
Oct 29 08:27:21 XEN-ST-27 kernel:         command: Synchronize Cache(10): 35 00
00 00 00 00 00 00 00 00
Oct 29 08:27:23 XEN-ST-27 kernel: mptbase: ioc0: LogInfo(0x31140000):
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Oct 29 08:27:23 XEN-ST-27 kernel: mptscsih: ioc0: task abort: SUCCESS
(sc=ffff8801e5465840)

[4:0:0:0]    disk    ATA      ST31500341AS     SD17  /dev/sda
[4:0:1:0]    disk    ATA      ST31500341AS     CC1H  /dev/sdb
[4:0:2:0]    disk    ATA      ST31500341AS     CC1H  /dev/sdc
[4:0:3:0]    disk    ATA      ST31500341AS     SD17  /dev/sdd
[4:0:4:0]    disk    ATA      ST31500341AS     CC1H  /dev/sde
[4:0:5:0]    disk    ATA      ST31500341AS     SD17  /dev/sdf
[4:0:6:0]    disk    ATA      ST31500341AS     SD17  /dev/sdg
[4:0:7:0]    disk    ATA      ST31500341AS     CC1H  /dev/sdh
[4:0:8:0]    disk    ATA      ST31500341AS     CC1H  /dev/sdi
[4:0:9:0]    disk    ATA      ST31500341AS     CC1H  /dev/sdj
[4:0:10:0]   disk    ATA      ST31500341AS     CC1H  /dev/sdk
[4:0:11:0]   disk    ATA      ST31500341AS     CC1H  /dev/sdl

I am suffering IO hung in many xen servers. I've apply this patch
http://lkml.org/lkml/2010/4/26/335 in 2.6.18-xen with mpt version
mptlinux-3.04.01, and "task abort" still show in dmesg. But smartctl -a will
not trigger error even without this patch. So I think havey IO hung issue may
be caused by seagate firmware and ATA path-through bug in the kernel.

I didn't find ATA path-through issue in 2.6.18-xen and 2.6.16-xen, but 2.6.29
and 2.6.31 and 2.6.32 have this issue. It could be reproduced easily by running
"while true; do smartctl -a /dev/sdd > /dev/null; done". Even apply patch
http://lkml.org/lkml/2010/4/26/335, and try all mpt fusion driver I can find
form 3.04.01 to the latest lsi version 4.0.22.

Finally I test 2.6.36, ATA issue seems solved. But it doesn't support xen dom0,
I can't test this kernel in productive server. I'am trying reproduce IO hung
issue in lab, and upgrade seagate firmware version to verify it.

Related bug: https://bugzilla.kernel.org/show_bug.cgi?id=18652

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
