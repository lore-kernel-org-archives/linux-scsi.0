From: Mark Rustad <MRustad@aol.com>
Subject: Re: PROBLEM: kernel crashes on RAID1 drive error
Date: Thu, 28 Oct 2004 14:37:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <D9D4DE7A-2918-11D9-B6DC-0003934F6348@aol.com>
References: <8FA83ADB-22E4-11D9-AC9C-0003934F6348@aol.com> <20041021084514.GY10531@suse.de> <4177BF22.7060208@steeleye.com> <20041021135557.GN10531@suse.de> <4177C13C.10007@steeleye.com> <20041021140236.GO10531@suse.de> <88F77D21-2443-11D9-AAEE-0003934F6348@aol.com>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imo-m19.mx.aol.com ([64.12.137.11]:50073 "EHLO
	imo-m19.mx.aol.com") by vger.kernel.org with ESMTP id S261866AbUJ1Th5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2004 15:37:57 -0400
Received: from MRustad@aol.com
	by imo-m19.mx.aol.com (mail_out_v37_r3.8.) id x.1c6.20186806 (15898)
	 for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2004 15:37:42 -0400 (EDT)
In-Reply-To: <88F77D21-2443-11D9-AAEE-0003934F6348@aol.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've still been trying to resolve this problem. I have reproduced the 
kernel crash on a RAID1 drive error on kernels all the way up to 
2.6.10-rc1-bk6. Seeing a patch to fix a problem in the sg device, I 
turned off sgraidmon as well as mdadmd to have less going on in my 
environment and took the SCSI generic driver out of the kernel. I also 
turned on frame pointers in the kernel, just to aid in walking the 
stack.

With those changes I still get a kernel crash on a drive error. In this 
case I got the following:

raid1: Disk failure on sdb1, disabling device.
raid1: sdb1: rescheduling sector 176
raid1: sda1: redirecting sector 176 to another mirror
Oct 28 10:18:23 xio3d-x3C kernel: SCSI error : <0 0 5 0> return code = 
0x8000002
Oct 28 10:18:23 xio3d-x3C kernel: Info fld=0xf3, Current sdb: sense key 
Medium Error
Oct 28 10:18:23 xio3d-x3C kernel: Additional sense: Unrecovered read 
error
Oct 28 10:18:23 xio3d-x3C kernel: end_request: I/O error, dev sdb, 
sector 240
------------[ cut here ]------------
kernel BUG at /usr/src/linux-2.6.10-rc1-bk6/drivers/scsi/scsi_lib.c:572!
invalid operand: 0000 [#1]
SMP
CPU:    0
EIP:    0060:[<c02ca8fb>]    Not tainted VLI
EFLAGS: 00010046   (2.6.10-rc1-3d-x)
EIP is at scsi_alloc_sgtable+0xe0/0xed
eax: 00000000   ebx: df45899c   ecx: 00000000   edx: ded49e00
esi: ded49e00   edi: ded49e00   ebp: f7cd3d98   esp: f7cd3d80
ds: 007b   es: 007b   ss: 0068
Process scsi_eh_0 (pid: 18, threadinfo=f7cd2000 task=f7ca2a20)
Stack: c0582b94 c05720c0 00000000 df45899c ded49e00 ded49e00 f7cd3db8 
c02caf3a
        ded49e00 00000020 00010000 ded49e00 ded49e00 df45899c f7cd3de0 
c02cb0ee
        ded49e00 00000001 00000000 00000000 f7cacc00 df45899c f7cacc00 
f7c44030
Call Trace:
  [<c0107a93>] show_stack+0xaf/0xb7
  [<c0107c13>] show_registers+0x158/0x1cd
  [<c0107e0f>] die+0xfa/0x182
  [<c0108325>] do_invalid_op+0x108/0x10a
  [<c01076ed>] error_code+0x2d/0x38
  [<c02caf3a>] scsi_init_io+0x62/0x123
  [<c02cb0ee>] scsi_prep_fn+0xae/0x205
  [<c02932ae>] elv_next_request+0x65/0xf7
  [<c02cb465>] scsi_request_fn+0x220/0x429
  [<c02959d5>] blk_insert_request+0xaf/0xe3
  [<c02ca6cd>] scsi_requeue_command+0x40/0x4d
  [<c02ca7b0>] scsi_end_request+0x6c/0xd7
  [<c02cac20>] scsi_io_completion+0x278/0x530
  [<c02faf37>] sd_rw_intr+0x84/0x2ab
  [<c02c5ebe>] scsi_finish_command+0x83/0xe4
  [<c02c99b8>] scsi_eh_flush_done_q+0xb0/0x105
  [<c02c9aa2>] scsi_unjam_host+0x95/0x1eb
  [<c02c9cc8>] scsi_error_handler+0xd0/0x172
  [<c0104ff5>] kernel_thread_helper+0x5/0xb
Code: a0 00 00 00 02 00 eb 8b 66 c7 82 a0 00 00 00 03 00 eb 80 66 c7 82 
a0 00 00
  00 00 00 e9 72 ff ff ff 31 c0 83 c4 0c 5b 5e 5f 5d c3 <0f> 0b 3c 02 f0 
ab 3f c0
  e9 2f ff ff ff 55 89 e5 8b 45 0c 8b 55

The BUG is caused by the nr_phys_segments field being zero, resulting 
in an attempt to have a sg list with no elements. Since I have been 
stimulating the drive failure with "dd of=/dev/null bs=512 
if=/dev/md0", I got to wondering if it was the single-sector reads that 
contribute to the problem, so I changed the bs=512 to bs=4096. Then I 
got the following crash:

raid1: Disk failure on sdb1, disabling device.
raid1: sdb1: rescheduling sector 176
raid1: sda1: redirecting sector 176 to another mirror
Oct 28 13:30:11 xio3d-x3C kernel: SCSI error : <0 0 5 0> return code = 
0x8000002
Oct 28 13:30:11 xio3d-x3C kernel: Info fld=0xf3, Current sdb: sense key 
Medium Error
Oct 28 13:30:11 xio3d-x3C kernel: Additional sense: Unrecovered read 
error
Oct 28 13:30:11 xio3d-x3C kernel: end_request: I/O error, dev sdb, 
sector 240
Unable to handle kernel NULL pointer dereference at virtual address 
00000000 printing eip:
*pde = 00000000
Oops: 0000 [#1]
SMP
CPU:    0
EIP:    0060:[<c0144cfc>]    Not tainted VLI
EFLAGS: 00010292   (2.6.10-rc1-3d-x)
EIP is at page_address+0xc/0x93
eax: 00000000   ebx: 00000000   ecx: c1936c10   edx: c1936c10
esi: c6f11100   edi: 00000000   ebp: c04f7e1c   esp: c04f7e04
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 0, threadinfo=c04f6000 task=c040db40)
Stack: fffffffb 00000000 c04f7e2c ded86d70 c6f11100 00000000 c04f7e2c 
c0296c60
        00000000 00000e00 c04f7e64 c0296e36 ded86d70 00000007 fffffffb 
00000000
        c6f11100 00000001 fffffffb 00000e00 00000007 ded86d70 decbee00 
f7c448b8
Call Trace:
  [<c0107a93>] show_stack+0xaf/0xb7
  [<c0107c13>] show_registers+0x158/0x1cd
  [<c0107e0f>] die+0xfa/0x182
  [<c0118f05>] do_page_fault+0x432/0x5fe
  [<c01076ed>] error_code+0x2d/0x38
  [<c0296c60>] blk_recalc_rq_sectors+0x87/0xa0
  [<c0296e36>] __end_that_request_first+0x1bd/0x23d
  [<c02ca772>] scsi_end_request+0x2e/0xd7
  [<c02cac20>] scsi_io_completion+0x278/0x530
  [<c02faf37>] sd_rw_intr+0x84/0x2ab
  [<c02c5ebe>] scsi_finish_command+0x83/0xe4
  [<c02c5dee>] scsi_softirq+0xd3/0xe7
  [<c01269f5>] __do_softirq+0x65/0xd3
  [<c0126a94>] do_softirq+0x31/0x33
  [<c0109090>] do_IRQ+0x2c/0x33
  [<c01075d0>] common_interrupt+0x18/0x20
  [<c0104e23>] cpu_idle+0x31/0x40
  [<c04f8ada>] start_kernel+0x19b/0x20b
  [<c0100211>] 0xc0100211
Code: da 01 74 ec 3c c0 eb d8 55 89 e5 69 45 08 01 00 37 9e 5d c1 e8 19 
c1 e0 07
  05 00 ed 58 c0 c3 55 89 e5 57 56 53 83 ec 0c 8b 5d 08 <8b> 03 f6 c4 01 
75 1a 2b
  1d 10 6d 59 c0 c1 fb 05 c1 e3 0c 8d 83
  <0>Kernel panic - not syncing: Fatal exception in interrupt
  <0>Rebooting in 5 seconds..

In this case, there was about 30 seconds between the time that the disk 
error was reported and the kernel finally crashed.

Right now I am wondering if this comment in scsi_lib.c could have 
something to do with this problem...
                 /*
                  * XXX: Following is probably broken since deferred 
errors
                  *      fall through [dpg 20040827]
                  */

-- 
Mark Rustad, MRustad@aol.com

