From: Pat LaVarre <p.lavarre@ieee.org>
Subject: max GiB written per boot
Date: 22 Sep 2003 08:52:45 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064242365.13428.6.camel@patehci2>
References: <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org>
	 <1063217791.3669.43.camel@patehci2>  <1063219776.3669.72.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:18924 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263170AbTIVOwH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 10:52:07 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 579E51909
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2003 08:52:06 -0600 (MDT)
In-Reply-To: <1063219776.3669.72.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


> ... always ... an oops ... Must be fixed.

Here's another "kernel NULL pointer dereference", for we of linux-scsi
to fix, again brought to us courtesy the [usb-storage] mailing list  ...

Specifically I tried trivially repeating writes in 2.6.0-test5:

date ; sync
date ; dd of=/dev/scd1 if=/dev/zero bs=1M
date ; sync
...

Two days and five hours later, my 77th write completed normally:
dd: writing `/dev/scd1': No space left on device

But five minutes after that, my 78th write and all my following writes
completed abnormally:
dd: opening `/dev/scd1': No such device or address

Some hours after that I collected the following `tail` of a `dmesg`:

Then I rebooted.

Pat LaVarre

...
lost page write due to I/O error on sr1
SCSI error : <2 0 0 0> return code = 0x10000
end_request: I/O error, dev sr1, sector 54044664
Buffer I/O error on device sr1, logical block 6755583
lost page write due to I/O error on sr1
Unable to handle kernel NULL pointer dereference at virtual address
00000000
 printing eip:
c01e818f
*pde = 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<c01e818f>]    Not tainted
EFLAGS: 00010282
EIP is at get_kobj_path_length+0x19/0x30
eax: 00000000   ebx: 00000000   ecx: ffffffff   edx: cb0eaef4
esi: 00000015   edi: 00000000   ebp: c9eb5e88   esp: c9eb5e7c
ds: 007b   es: 007b   ss: 0068
Process dd (pid: 29851, threadinfo=c9eb4000 task=de3dace0)
Stack: c9eb4000 000000a5 d2c1b900 c9eb5ed0 c01e834f c03f5b60 c17149ac
000000a5 
       d2c1b880 c1714800 c9eb5eb8 cddfb400 d2c1b880 cddfb419 c03ba0a0
c0383d13 
       00000000 c1714988 c17149ac d36778ac c1714800 c9eb5ee8 c01e881d
c037dfa5 
Call Trace:
 [<c01e834f>] kset_hotplug+0x15e/0x2b0
 [<c01e881d>] kobject_del+0x66/0x6d
 [<c02470fc>] device_del+0x72/0x98
 [<c027b92a>] scsi_device_put+0xc9/0xe7
 [<df9088d6>] cdrom_release+0x8c/0x105 [cdrom]
 [<c0164fb6>] blkdev_put+0x1df/0x20b
 [<c015d0c3>] __fput+0x123/0x135
 [<c015b79b>] filp_close+0x57/0x81
 [<c015b846>] sys_close+0x81/0xc7
 [<c010b409>] sysenter_past_esp+0x52/0x71

Code: f2 ae f7 d1 49 8b 52 24 8d 74 31 01 85 d2 75 e7 5b 89 f0 5e 
 <6>usb 1-2: USB disconnect, address 5


