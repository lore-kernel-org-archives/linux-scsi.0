From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] 2.6.0-test9 kernel oops (aic7x_old)
Date: Mon, 24 Nov 2003 11:46:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031124114648.69d53fe1.rddunlap@osdl.org>
References: <20031123231037.44115c6f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:26528 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262321AbTKXTwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 14:52:45 -0500
In-Reply-To: <20031123231037.44115c6f.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, kostrian@deepblue.sk, hch@infradead.org, jejb <james.bottomley@steeleye.com>, torvalds <torvalds@osdl.org>

On Sun, 23 Nov 2003 23:10:37 -0800 Andrew Morton <akpm@osdl.org> wrote:

| 
| Can anyone else with an aic7xxx reproduce (and hence fix) this?
| /proc/scsi/aic7xxx/0 works happily on my test box.
| 
| 
| Unable to handle kernel NULL pointer dereference at virtual address
| 00000120
|  printing eip:
| c02624d8
| *pde = 00000000
| Oops: 0000 [#1]
| CPU:    0
| EIP:    0060:[<c02624d8>]    Not tainted
| EFLAGS: 00010286
| EIP is at aic7xxx_proc_info+0x1c/0xab4
| eax: c02624bc   ebx: c3a63f78   ecx: 00000000   edx: 00000000
| esi: 00000400   edi: c3aca000   ebp: c3a63f74   esp: c3a63ef4
| s: 007b   es: 007b   ss: 0068
| Process cat (pid: 657, threadinfo=c3a62000 task=c5e37350)
| Stack: c3a63f78 00000400 c3aca000 c3a63f74 00000000 c03a8054 c012d24b c025139b
|        c1187000 c3aca000 c3a63f78 00000000 00000400 00000000 00000000 c6332400
|        00000400 c3aca000 c016a508 c3aca000 c3a63f78 00000000 00000400 c3a63f74
| Call Trace:
|  [<c012d24b>] __alloc_pages+0xa3/0x2dc
|  [<c025139b>] proc_scsi_read+0x2b/0x44
|  [<c016a508>] proc_file_read+0x10c/0x238
|  [<c013fdb5>] vfs_read+0xb5/0xe4
|  [<c013ffb5>] sys_read+0x31/0x4c
|  [<c0108a53>] syscall_call+0x7/0xb
| 
| Code: 83 b9 20 01 00 00 00 75 f1 85 c9 75 2f 0f b7 05 58 00 00 00


Patch below (to -test10) fixes it for me.
Please apply.

--
~Randy



description:	repair oops in aic7xxx_old proc_info()
author:		Randy.Dunlap <rddunlap@osdl.org>

diffstat:=
 drivers/scsi/aic7xxx_old/aic7xxx_proc.c |    2 --
 1 files changed, 2 deletions(-)

diff -Naurp ./drivers/scsi/aic7xxx_old/aic7xxx_proc.c~aic7_proc ./drivers/scsi/aic7xxx_old/aic7xxx_proc.c
--- ./drivers/scsi/aic7xxx_old/aic7xxx_proc.c~aic7_proc	2003-11-23 17:32:55.000000000 -0800
+++ ./drivers/scsi/aic7xxx_old/aic7xxx_proc.c	2003-11-24 11:47:16.000000000 -0800
@@ -90,8 +90,6 @@ aic7xxx_proc_info ( struct Scsi_Host *HB
   unsigned char i;
   unsigned char tindex;
 
-  HBAptr = NULL;
-
   for(p=first_aic7xxx; p->host != HBAptr; p=p->next)
     ;
 

