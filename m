From: "ezIX" <bugs@ezix.org>
Subject: [ezIX] #753: LSHW Causing Rewinds On LTO7 Drives
Date: Thu, 10 Aug 2017 16:46:55 -0000
Message-ID: <045.63fa297e4602f9b1538599f5eb34c6d6@ezix.org>
Reply-To: support@ezix.org
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dedibox.ezix.org ([163.172.64.21]:49484 "EHLO mail.ezix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752524AbdHJQzf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 12:55:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: support@ezix.org

#753: LSHW Causing Rewinds On LTO7 Drives
-----------------------------+--------------------
 Reporter:  a.richman@…      |      Owner:  lyonel
     Type:  defect           |     Status:  new
 Priority:  major            |  Milestone:
Component:  lshw             |    Version:
 Keywords:  lto lto7 rewind  |
-----------------------------+--------------------
 Hi,

 We're running into an issue with LTO7 drives on Linux, where LSHW will
 cause the drive to rewind when it queries it.  We haven't seen this at all
 on LTO6 drives so it could be an issue with the LTO7 drivers but I figured
 I'd try here first.

 I tracked this down by adding debug logging to the scsi/st drivers on
 rewind, the logs below show it was the LSHW process that caused the
 rewind:
 [  629.456892] st.c break 1 REZERO_UNIT
 [  629.456897] CPU: 6 PID: 17091 Comm: lshw Not tainted
 4.4.78-gentoo-r2-rev1.15 #1
 [  629.456899] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS
 2.0b 09/17/2012
 [  629.456901]  0000000000000000 ffff88034f243e30 ffffffff8136536e
 ffff880409ff4800
 [  629.456904]  0000000000000006 ffff88034f243e98 ffffffffa0427411
 ffff88034f243e48
 [  629.456907]  ffff88041bf6b808 00155cc02f7ce620 0000000000000000
 0000000000000000
 [  629.456909] Call Trace:
 [  629.456913]  [<ffffffff8136536e>] dump_stack+0x63/0x85
 [  629.456918]  [<ffffffffa0427411>] st_int_ioctl+0x401/0x1060 [st]
 [  629.456922]  [<ffffffffa042c3ef>] st_flush+0x26f/0x500 [st]
 [  629.456925]  [<ffffffff811b4a63>] ? do_vfs_ioctl+0x283/0x460
 [  629.456927]  [<ffffffff811a1afa>] filp_close+0x2a/0x70
 [  629.456930]  [<ffffffff811be1dc>] __close_fd+0x8c/0xb0
 [  629.456932]  [<ffffffff811a1b5e>] SyS_close+0x1e/0x50
 [  629.456936]  [<ffffffff816c1d72>] entry_SYSCALL_64_fastpath+0x16/0x71

 Haven't looked too closely at the LSHW source, but I assume it opens LTO
 devices to throw iocotls at them to get statistics etc?  And this is
 somehow causing a rewind on LTO7 but not LTO6 or earlier.

 Any ideas what could be causing this?

 CC'd in linux-scsi in case it's a LTO7 driver specific problem.

 Thanks,
 - Alex.

--
Ticket URL: <//ezix.org/project/ticket/753>
ezIX <//ezix.org/>
ezIX O/S
