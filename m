From: Richard Scobie <richard@sauce.co.nz>
Subject: smartd/smartctl offlining drives
Date: Sat, 25 Oct 2008 20:53:32 +1300
Message-ID: <4902D07C.1020304@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sauce.co.nz ([210.48.49.72]:43219 "EHLO smtp.sauce.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbYJYIB2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Oct 2008 04:01:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have 2 similarly specced machines with Fedora 9 installed using kernel 
2.6.26.5-45.fc9.x86_64  and a 16 x SATA md RAID6 behind an LSISAS1068E 
SAS controller. Both are running a locally compiled version of Samba 3.0.29.

If they are configured to start samba and smartd on boot, these two 
services are the last to start - samba directly followed by smartd.

This results in the SAS controller progressively offlining each of the 
16 drives in turn, as the SMART commands cause the controller to 
repeatedly reset each drive:

Oct 25 12:39:13 storage smartd[3147]: Device: /dev/sdc, opened
Oct 25 12:39:13 storage smartd[3147]: Device: /dev/sdc, not found in 
smartd database.
Oct 25 12:39:19 storage kernel: mptscsih: ioc0: attempting task abort! 
(sc=ffff81022d0597c0)
Oct 25 12:39:19 storage kernel: sd 8:0:0:0: [sdc] CDB: ATA command pass 
through(16): 85 08 0e 00 d5 00 01 00 01 00 4f 00 c2 00 b0 00
Oct 25 12:39:20 storage kernel: mptbase: ioc0: LogInfo(0x31140000): 
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Oct 25 12:39:21 storage kernel: mptscsih: ioc0: task abort: SUCCESS 
(sc=ffff81022d0597c0)
Oct 25 12:39:31 storage kernel: mptscsih: ioc0: attempting task abort! 
(sc=ffff81022d0597c0)
Oct 25 12:39:31 storage kernel: sd 8:0:0:0: [sdc] CDB: Test Unit Ready: 
00 00 00 00 00 00
Oct 25 12:39:32 storage kernel: mptbase: ioc0: LogInfo(0x31140000): 
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Oct 25 12:39:32 storage kernel: mptscsih: ioc0: task abort: SUCCESS 
(sc=ffff81022d0597c0)
Oct 25 12:39:32 storage kernel: mptscsih: ioc0: attempting target reset! 
(sc=ffff81022d0597c0)
Oct 25 12:39:32 storage kernel: sd 8:0:0:0: [sdc] CDB: ATA command pass 
through(16): 85 08 0e 00 d5 00 01 00 01 00 4f 00 c2 00 b0 00
Oct 25 12:39:34 storage kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Oct 25 12:39:34 storage kernel: mptscsih: ioc0: target reset: FAILED 
(sc=ffff81022d0597c0)
Oct 25 12:39:34 storage kernel: mptscsih: ioc0: attempting bus reset! 
(sc=ffff81022d0597c0)
Oct 25 12:39:34 storage kernel: sd 8:0:0:0: [sdc] CDB: ATA command pass 
through(16): 85 08 0e 00 d5 00 01 00 01 00 4f 00 c2 00 b0 00
Oct 25 12:39:43 storage kernel: mptscsih: ioc0: bus reset: SUCCESS 
(sc=ffff81022d0597c0)
Oct 25 12:40:03 storage kernel: mptscsih: ioc0: attempting task abort! 
(sc=ffff81022d0597c0)
Oct 25 12:40:03 storage kernel: sd 8:0:0:0: [sdc] CDB: Test Unit Ready: 
00 00 00 00 00 00
Oct 25 12:40:04 storage kernel: mptbase: ioc0: LogInfo(0x31140000): 
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Oct 25 12:40:04 storage kernel: mptscsih: ioc0: task abort: SUCCESS 
(sc=ffff81022d0597c0)
Oct 25 12:40:04 storage kernel: mptscsih: ioc0: attempting host reset! 
(sc=ffff81022d0597c0)
Oct 25 12:40:04 storage kernel: mptbase: ioc0: Initiating recovery
Oct 25 12:40:19 storage kernel: mptscsih: ioc0: host reset: SUCCESS 
(sc=ffff81022d0597c0)
Oct 25 12:40:19 storage kernel: sd 8:0:0:0: Device offlined - not ready 
after error recovery
Oct 25 12:40:19 storage smartd[3147]: Device: /dev/sdc, Read SMART Error 
Log Failed
Oct 25 12:40:19 storage smartd[3147]: Device: /dev/sdc, no SMART Error 
log; remove -l error Directive from smartd.conf
Oct 25 12:40:19 storage smartd[3147]: Device: /dev/sdc, is SMART 
capable. Adding to "monitor" list.
Oct 25 12:40:19 storage smartd[3147]: Device: /dev/sdd, opened
Oct 25 12:40:19 storage smartd[3147]: Device: /dev/sdd, not found in 
smartd database.
Oct 25 12:40:26 storage kernel: mptscsih: ioc0: attempting task abort! 
(sc=ffff81022d207b80)
Oct 25 12:40:26 storage kernel: sd 8:0:1:0: [sdd] CDB: ATA command pass 
through(16): 85 08 0e 00 d5 00 01 00 01 00 4f 00 c2 00 b0 00

and so on until all 16 drives are down.

If samba is disabled on boot, with smartd enabled and samba is then 
manually started later or smartd is disabled on boot, with samba enabled 
and smartd started manually, everything works perfectly - smartd and 
smartctl work perfectly.

I am unsure exactly which component - samba, smartd or mpt driver is at 
fault here.

Regards,

Richard

