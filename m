From: Andrew Morton <akpm@osdl.org>
Subject: Fw: 2.6.0-test9 kernel oops
Date: Sun, 23 Nov 2003 23:10:37 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031123231037.44115c6f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:13550 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263619AbTKXHEP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 02:04:15 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Tomas Kostrian <kostrian@deepblue.sk>


Can anyone else with an aic7xxx reproduce (and hence fix) this?
/proc/scsi/aic7xxx/0 works happily on my test box.


Begin forwarded message:

Date: Mon, 24 Nov 2003 06:36:32 +0100
From: Tomas Kostrian <kostrian@deepblue.sk>
To: akpm@osdl.org
Subject: 2.6.0-test9 kernel oops


kostrian@test:~$ uname -a
Linux test.[SNIFF].sk 2.6.0-test9 #1 Sun Nov 9 01:35:44 CET 2003 i686
unknown
kostrian@test:~$ ls -la /proc/scsi/aic7xxx/
total 0
dr-xr-xr-x    2 root     root            0 Nov 24 00:06 .
dr-xr-xr-x    4 root     root            0 Nov 24 00:06 ..
-rw-r--r--    1 root     root            0 Nov 24 00:06 0
kostrian@test:~$ cat /proc/scsi/aic7xxx/0
Segmentation fault
kostrian@test:~$ dmesg
.
.
[SNIFF]
.
.
Unable to handle kernel NULL pointer dereference at virtual address
00000120
 printing eip:
c02624d8
*pde = 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<c02624d8>]    Not tainted
EFLAGS: 00010286
EIP is at aic7xxx_proc_info+0x1c/0xab4
eax: c02624bc   ebx: c3a63f78   ecx: 00000000   edx: 00000000
esi: 00000400   edi: c3aca000   ebp: c3a63f74   esp: c3a63ef4
s: 007b   es: 007b   ss: 0068
Process cat (pid: 657, threadinfo=c3a62000 task=c5e37350)
Stack: c3a63f78 00000400 c3aca000 c3a63f74 00000000 c03a8054 c012d24b c025139b
       c1187000 c3aca000 c3a63f78 00000000 00000400 00000000 00000000 c6332400
       00000400 c3aca000 c016a508 c3aca000 c3a63f78 00000000 00000400 c3a63f74
Call Trace:
 [<c012d24b>] __alloc_pages+0xa3/0x2dc
 [<c025139b>] proc_scsi_read+0x2b/0x44
 [<c016a508>] proc_file_read+0x10c/0x238
 [<c013fdb5>] vfs_read+0xb5/0xe4
 [<c013ffb5>] sys_read+0x31/0x4c
 [<c0108a53>] syscall_call+0x7/0xb

Code: 83 b9 20 01 00 00 00 75 f1 85 c9 75 2f 0f b7 05 58 00 00 00
