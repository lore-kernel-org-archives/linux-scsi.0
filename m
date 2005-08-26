From: Stephen Lord <lord@xfs.org>
Subject: Oops on scsi_remove_target
Date: Fri, 26 Aug 2005 16:14:31 -0500
Message-ID: <430F8637.2060202@xfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04.roc.ny.frontiernet.net ([66.133.182.167]:59625 "EHLO
	relay04.roc.ny.frontiernet.net") by vger.kernel.org with ESMTP
	id S965173AbVHZVOf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 17:14:35 -0400
Received: from filter07.roc.ny.frontiernet.net (filter07.roc.ny.frontiernet.net [66.133.183.74])
	by relay04.roc.ny.frontiernet.net (Postfix) with ESMTP id 9F077358360
	for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2005 21:14:32 +0000 (UTC)
Received: from relay04.roc.ny.frontiernet.net ([66.133.182.167])
	by filter07.roc.ny.frontiernet.net (filter07.roc.ny.frontiernet.net [66.133.183.74]) (amavisd-new, port 10024)
	with LMTP id 29468-09-29 for <linux-scsi@vger.kernel.org>;
	Fri, 26 Aug 2005 21:14:32 +0000 (UTC)
Received: from [192.168.1.65] (67-137-96-87.dsl2.brv.mn.frontiernet.net [67.137.96.87])
	by relay04.roc.ny.frontiernet.net (Postfix) with ESMTP id 1A0813581D6
	for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2005 21:14:10 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Running 2.6.12 (or one of several descendents of it), someone just let
loose a new device on our fabric, it is causing one of our hosts no
end of grief:

scsi: unknown device type 12
   Vendor: ADIC      Model: SNC               Rev: 42dF
   Type:   RAID                               ANSI SCSI revision: 03
qla2300 0000:18:01.1: Waiting for LIP to complete...
qla2300 0000:18:01.1: LIP reset occured (f7f7).
qla2300 0000:18:01.1: LOOP UP detected (2 Gbps).
qla2300 0000:18:01.1: Topology - (F_Port), Host Loop address 0xffff
qla2300 0000:18:01.0: scsi(3:16:1): Abort command issued -- 197 2002.

and a while later:

Starting udev:  Unable to handle kernel NULL pointer dereference at 
virtual address 0000004c
  printing eip:
*pde = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: sg qla2300 qla2xxx scsi_transport_fc aic7xxx 
scsi_transport_spi sd_mod scsi_mod
CPU:    2
EIP:    0060:[<c0191fe3>]    Not tainted VLI
EFLAGS: 00010282   (2.6.12-kdb)
EIP is at sysfs_hash_and_remove+0xc/0xfe
eax: 00000000   ebx: f7e096b0   ecx: 00000000   edx: f885f6b4
esi: f7e096a8   edi: f885f6ac   ebp: f7feee68   esp: f7feee4c
ds: 007b   es: 007b   ss: 0068
Process events/2 (pid: 12, threadinfo=f7fee000 task=f7fef530)
Stack: 00000002 00000180 f7e09400 00000000 f7e096b0 f7e096a8 f885f6ac 
f7feee78
        c0193aaa 00000000 c02f41fe f7feee9c c0227691 f7e096b0 c02f41fe 
f885f640
        f885f6b4 f7e096a8 c1a1fff8 c1a20030 f7feeeac c0227702 f7e096a8 
f7e09400
Call Trace:
  [<c0103ec2>] show_stack+0x9a/0xd0
  [<c010408d>] show_registers+0x175/0x209
  [<c01042ac>] die+0xfa/0x19c
  [<c0115200>] do_page_fault+0x239/0x6ee
  [<c0103ad7>] error_code+0x4f/0x54
  [<c0193aaa>] sysfs_remove_link+0x1b/0x1d
  [<c0227691>] class_device_del+0x8e/0xed
  [<c0227702>] class_device_unregister+0x12/0x20
  [<f884d083>] scsi_remove_device+0x4e/0x97 [scsi_mod]
  [<f884d156>] __scsi_remove_target+0x8a/0xc9 [scsi_mod]
  [<f884d1b6>] __remove_child+0x21/0x29 [scsi_mod]
  [<c02255bb>] device_for_each_child+0x32/0x53
  [<f884d209>] scsi_remove_target+0x4b/0x5a [scsi_mod]
  [<f883bc54>] fc_timeout_blocked_rport+0x4f/0x55 [scsi_transport_fc]
  [<c012d2ee>] worker_thread+0x18f/0x238
  [<c0131367>] kthread+0xb1/0xb5
  [<c010141d>] kernel_thread_helper+0x5/0xb
Code: c0 e8 29 b2 13 00 89 5c 24 04 8b 45 0c 8b 40 0c 89 04 24 e8 1f b8 
fe ff 83 c4 08 5b 5e 5d c3 55 89 e5 57 56 53 83 ec 10 8b 45 08 <8b> 50 
4c 8b 48 0c f0 ff 49 74 0f 88 e2 00 00 00 8b 42 0c 8d 58

Entering kdb (current=0xf7fef530, pid 12) on processor 2 Oops: Oops
due to oops @ 0xc0191fe3
eax = 0x00000000 ebx = 0xf7e096b0 ecx = 0x00000000 edx = 0xf885f6b4
esi = 0xf7e096a8 edi = 0xf885f6ac esp = 0xf7feee4c eip = 0xc0191fe3
ebp = 0xf7feee68 xss = 0xc0260068 xcs = 0x00000060 eflags = 0x00010282
xds = 0xf885007b xes = 0x0000007b origeax = 0xffffffff &regs = 0xf7feee18
[2]kdb> bt
Stack traceback for pid 12
0xf7fef530       12        1  1    2   R  0xf7fef6f0 *events/2
EBP        EIP        Function (args)
0xf7feee68 0xc0191fe3 sysfs_hash_and_remove+0xc (0x0, 0xc02f41fe)
0xf7feee78 0xc0193aaa sysfs_remove_link+0x1b (0xf7e096b0, 0xc02f41fe, 
0xf885f640, 0xf885f6b4, 0xf7e096a8)
0xf7feee9c 0xc0227691 class_device_del+0x8e (0xf7e096a8, 0xf7e09400)
0xf7feeeac 0xc0227702 class_device_unregister+0x12 (0xf7e096a8, 0x3, 
0xf7e09400, 0xc1a1fff8, 0xc1a20000)
0xf7feeec8 0xf884d083 [scsi_mod]scsi_remove_device+0x4e (0xf7e09400, 
0xf78fb214, 0xf7feef00, 0xf884d195)
0xf7feeee0 0xf884d156 [scsi_mod]__scsi_remove_target+0x8a (0xf78fb200, 0x0)
0xf7feeef0 0xf884d1b6 [scsi_mod]__remove_child+0x21 (0xf78fb214, 0x0, 
0xf7e17840, 0xf7e17844, 0xf78fb220)
0xf7feef18 0xc02255bb device_for_each_child+0x32 (0xf7e17840, 0x0, 
0xf884d195, 0xf7e17840, 0xf7e17958)
0xf7feef34 0xf884d209 [scsi_mod]scsi_remove_target+0x4b (0xf7e17840, 
0xf883bece, 0xf7e178e4, 0xf7e17800)
0xf7feef4c 0xf883bc54 [scsi_transport_fc]fc_timeout_blocked_rport+0x4f 
(0xf7e17800, 0xf7feef7c, 0x0, 0xc193090c, 0xc1930914)
0xf7feefb8 0xc012d2ee worker_thread+0x18f (0xc1930900, 0xff, 0x0, 
0xc012d15f, 0xffffffff)
0xf7feefe4 0xc0131367 kthread+0xb1
            0xc010141d kernel_thread_helper+0x5


Here is another example:
scsi: unknown device type 12
   Vendor: ADIC      Model: SNC               Rev: 42dF
   Type:   RAID                               ANSI SCSI revision: 03
qla2300 0000:18:01.1: scsi(4:16:1): Abort command issued -- 197 2002.
qla2300 0000:18:01.1: scsi(4:16:1): Abort command issued -- 198 2002.
qla2300 0000:18:01.1: scsi(4:16:1): Abort command issued -- 198 2002.
scsi: Device offlined - not ready after error recovery: host 4 channel 0 
id 16 lun 1
scsi: Unexpected response from host 4 channel 0 id 16 lun 1 while 
scanning, scan aborted

followed by the same oops.

I zoned the fabric to get around the problem for now


