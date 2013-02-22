From: Jean Delvare <jdelvare@suse.de>
Subject: Kernel oops on st module cycling
Date: Fri, 22 Feb 2013 14:02:50 +0100
Message-ID: <1361538170.24311.209.camel@amber.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab3BVNCo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2013 08:02:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

Hi Kai, James,

It only takes a few st module rmmod/modprobe cycles to get a kernel
oops. It was reported to me, and reproduced by me, on kernel 3.0.58 /
SLES11 SP2, but I was also able to reproduce it on more recent kernels
(3.4.6 / openSUSE 12.2 and 3.7.6 / openSUSE 12.3 RC1.)

The oops doesn't happen on modprobe proper, but on an scsi_id command
ran by udev right after modprobe:
KERNEL=="st*[0-9]|nst*[0-9]", ENV{ID_SERIAL}!="?*", WAIT_FOR="$env{BSG_DEV}", IMPORT="scsi_id --whitelisted --export --device=$env{BSG_DEV}", ENV{ID_BUS}="scsi"

Using kdb I could gather the following backtrace:
Stack traceback for pid 4037
0xffff880039dfa040     4037     4027  1    0   R  0xffff880039dfa4e0 *scsi_id
 [<ffffffff812482d9>] blk_get_queue+0x9/0x30
 [<ffffffff81255f88>] bsg_add_device+0x38/0x1c0
 [<ffffffff81256214>] bsg_get_device+0x104/0x140
 [<ffffffff81256266>] bsg_open+0x16/0x40
 [<ffffffff8117949f>] chrdev_open+0x13f/0x200
 [<ffffffff8117303e>] __dentry_open+0x18e/0x310
 [<ffffffff811732bb>] nameidata_to_filp+0x7b/0x80
 [<ffffffff81182942>] do_last+0x1f2/0x7f0
 [<ffffffff81183ed8>] path_openat+0xc8/0x3f0
 [<ffffffff81184328>] do_filp_open+0x48/0xa0
 [<ffffffff811744c2>] do_sys_open+0x162/0x1f0
 [<ffffffff81174590>] sys_open+0x20/0x30
 [<ffffffff814984c2>] system_call_fastpath+0x16/0x1b
 [<00007f205bf94da0>] 0x7f205bf94da0
     r15 = 0xffff88003b9887b8      r14 = 0xffff88003c469368 
     r13 = 0xffff88003bac5b50      r12 = 0x6b6b6b6b6b6b6b6b 
      bp = 0xffff88003bb23bd8       bx = 0xfffffffffffffffa 
     r11 = 0x0000000000000001      r10 = 0x0000000000000000 
      r9 = 0xffff88003d637290       r8 = 0x0000000000000000 
      ax = 0x0000000000000000       cx = 0xffff88003fc00000 
      dx = 0xffff88003bac5b50       si = 0x6b6b6b6b6b6b6b6b 
      di = 0x6b6b6b6b6b6b6b6b  orig_ax = 0xffffffffffffffff 
      ip = 0xffffffff812482d9       cs = 0x0000000000000010 
   flags = 0x0000000000010286       sp = 0xffff88003bb23bc0 
      ss = 0x0000000000000018 &regs = 0xffff88003bb23b28

Note that the kernel log message right before the oops are suspicious.
Normally I would get:

[  272.155460] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[  272.156586] st 3:0:4:0: Attached scsi tape st0
[  272.156592] st 3:0:4:0: st0: try direct i/o: yes (alignment 4 B)

but before the oops I get:

[  482.428527] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[  482.429509] st 3:0:4:0: Attached scsi tape st0
[  482.429515] st 3:0:4:0: st0: try direct i/o: yes (alignment 1802201964 B)
[  482.449542] general protection fault: 0000 [#1] SMP 

Note the odd alignment value.

According to gdb, blk_get_queue+0x9 is:

563	if (likely(!test_bit(QUEUE_FLAG_DEAD, &q->queue_flag))) {

where test_bit is implemented by inline function constant_test_bit().

With kernel 3.4.6 I got a different backtrace, I had no serial console
setup at the time so I could only take a picture, below if a manual copy
of the trace, hope I didn't make any typo:

RIP: elv_may_queue+0x7/0x20
Call trace:
 get_request+0x112/0x4a0
 get_request_wait+0x2d/0x210
 blk_get_request+0x6c/0x90
 bsg_map_hdr.isra.7+0xbe/0x340
 bsg_ioctl+0x187/0x230
 do_vfs_ioctl+0x8f/0x530
 sys_ioctl+0x98/0xa0
 system_call_fastpath+0x1a/0x1f

Original pictures are here if needed:
http://users.suse.com/~jdelvare/work/st-oops/

I'd like this bug to be fixed. What extra information can I provide that
would be helpful?

Thanks,
-- 
Jean Delvare
Suse L3

