From: Andrew Morton <akpm@digeo.com>
Subject: Fw: 2.5.65 panic in remove_proc_entry() while trying to rmmod
Date: Fri, 21 Mar 2003 16:48:55 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030321164855.598090d7.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Fri__21_Mar_2003_16:48:55_-0800_08581db0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id OAA08159
	for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2003 14:43:46 -0800 (PST)
Received: from digeo-e2k04.digeo.com ([192.168.2.24])
 by digeo-nav01.digeo.com (SAVSMTP 3.0.0.44) with SMTP id M2003032114454605070
 for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2003 14:45:46 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart_Fri__21_Mar_2003_16:48:55_-0800_08581db0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Looks like removal on the scsi_deubg module causes some
/proc entries to be removed twice.


Begin forwarded message:

Date: Fri, 21 Mar 2003 10:36:35 -0800
From: Badari Pulavarty <pbadari@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: andrew <akpm@digeo.com>
Subject: 2.5.65 panic in remove_proc_entry() while trying to rmmod


Hi,

I get following panic while playing with scsi_debug.
Any ideas on how to fix this ?

Thanks,
Badari



--Multipart_Fri__21_Mar_2003_16:48:55_-0800_08581db0
Content-Type: text/plain;
 name="panic"
Content-Disposition: attachment;
 filename="panic"
Content-Transfer-Encoding: 7bit

Unable to handle kernel paging request at virtual address 6b6b6b6d
 printing eip:
c018590a
*pde = 00000000
Oops: 0000 [#1]
CPU:    4
EIP:    0060:[<c018590a>]    Not tainted
EFLAGS: 00010202 VLI
EIP is at proc_match+0xa/0x30
eax: 6b6b6b6b   ebx: 00000002   ecx: d9d61e9c   edx: 6b6b6b6b
esi: d9d61e9c   edi: f7166e74   ebp: c03a2648   esp: d9d61e60
ds: 007b   es: 007b   ss: 0068
Process rmmod (pid: 10547, threadinfo=d9d60000 task=d9ade0a0)
Stack: d9d61e9c f7166e74 c018679e 00000002 d9d61e9c 6b6b6b6b d9d61e9c f440a084
       f440a084 c0295efa d9d61e9c f7166e44 d9d61e9c c03a23cc 0000001a d9003632
       f440a084 c03a2648 c01081cc f440a084 f44259c4 c028f733 f440a084 00000000
Call Trace:
 [<c018679e>] remove_proc_entry+0x5e/0x110
 [<c0295efa>] scsi_proc_host_rm+0x2a/0x50
 [<c01081cc>] __up_wakeup+0x8/0xc
 [<c028f733>] scsi_unregister+0x103/0x120
 [<f8966929>] sdebug_driver_remove+0x119/0x160 [scsi_debug]
 [<f8969440>] sdebug_driverfs_driver+0x0/0x74 [scsi_debug]
 [<f8969440>] sdebug_driverfs_driver+0x0/0x74 [scsi_debug]
 [<c0254134>] device_release_driver+0x44/0x50
 [<f8969498>] sdebug_driverfs_driver+0x58/0x74 [scsi_debug]
 [<c0254169>] driver_detach+0x29/0x40
 [<f8969660>] pseudo_lld_bus+0x40/0xe0 [scsi_debug]
 [<f8969620>] pseudo_lld_bus+0x0/0xe0 [scsi_debug]
 [<c02543e8>] bus_remove_driver+0x38/0x80
 [<f8969440>] sdebug_driverfs_driver+0x0/0x74 [scsi_debug]
 [<f896944c>] sdebug_driverfs_driver+0xc/0x74 [scsi_debug]
 [<f8969440>] sdebug_driverfs_driver+0x0/0x74 [scsi_debug]
 [<c025479f>] driver_unregister+0xf/0x33
 [<f8969440>] sdebug_driverfs_driver+0x0/0x74 [scsi_debug]
 [<f8969700>] +0x0/0x4e0 [scsi_debug]
 [<f896651a>] scsi_debug_unregister_driver+0xa/0x10 [scsi_debug]
 [<f8969440>] sdebug_driverfs_driver+0x0/0x74 [scsi_debug]
 [<f8966984>] +0x14/0x40 [scsi_debug]
 [<f8969440>] sdebug_driverfs_driver+0x0/0x74 [scsi_debug]
 [<c013517f>] sys_delete_module+0x1ff/0x230
 [<c0148f8b>] do_munmap+0x17b/0x190
 [<c0148fe4>] sys_munmap+0x44/0x70
 [<c0109303>] syscall_call+0x7/0xb

Code: 63 08 00 59 e9 8a e6 ff ff 66 4a 0f 85 1b e7 ff ff 51 e8 9a 64 08 00 59 e9 0f e7 ff ff 8d 74 26 00 57 56 8b



--Multipart_Fri__21_Mar_2003_16:48:55_-0800_08581db0--
