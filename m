From: Douglas Gilbert <dougg@torque.net>
Subject: Re: ide-scsi error handling
Date: Mon, 19 May 2003 23:01:23 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC8D5A3.8020600@torque.net>
References: <20030518230706.GA19202@linnie.riede.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060509050005020607040506"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:56581 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262445AbTESMrq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 08:47:46 -0400
In-Reply-To: <20030518230706.GA19202@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org, rddunlap@osdl.org

This is a multi-part message in MIME format.
--------------060509050005020607040506
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Willem Riede wrote:
> Now that current 2.5 kernels boot again for me (haven't been able
> to run current kernels for months, but I digress) I've done some
> more work on the error handling in ide-scsi.
> 
> The patch below works for me "most of the time". I'd appreciate if
> others try it, and report results, or inspect the patch and comment.

Willem,
As reported to you earlier I got the attached "sleeping
from illegal context" followed by an oops when I tried
to exercise ide-scsi with your patch on bk13. My setup:
   - SMP kernel running on a UP machine with all kernel
     debugging configured on
   - PIO which is the default (can try with DMA later)
   - cdrecord on an atapi writer running at the same time
     as sg_dd on an atapi reader (i.e. 2 active ide-scsi
     devices)
The machine was still usable after the oops (sg_dd
seg faulted).

This was same test that broke my patches a few days
back. Randy Dunlap seemed to be able to get ide-scsi
to break with far less provocation.

Doug Gilbert

--------------060509050005020607040506
Content-Type: text/plain;
 name="ide-scsi2569bk14wr.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ide-scsi2569bk14wr.txt"

Debug: sleeping function called from illegal context at include/linux/rwsem.h:43
Call Trace:
 [<c011f92c>] __might_sleep+0x5c/0x5e
 [<c011b2d8>] do_page_fault+0x78/0x4a8
 [<e0823c4b>] idescsi_transfer_pc+0xfb/0x130 [ide_scsi]
 [<c0233ce7>] start_request+0x107/0x160
 [<c021ac05>] elv_queue_empty+0x25/0x30
 [<c0233dc6>] ide_do_request+0x56/0x3e0
 [<c021a9e3>] __elv_add_request+0x33/0x50
 [<c011b260>] do_page_fault+0x0/0x4a8
 [<c010a1c9>] error_code+0x2d/0x38
 [<e0824534>] idescsi_queue+0x244/0x6d0 [ide_scsi]
 [<c0246909>] __scsi_get_command+0x29/0xc0
 [<c0246fc8>] scsi_dispatch_cmd+0x218/0x3e0
 [<c0247320>] scsi_done+0x0/0x80
 [<c024a6d0>] scsi_times_out+0x0/0x90
 [<c024d946>] scsi_prep_fn+0xd6/0x150
 [<c024ca70>] scsi_init_cmd_errh+0xa0/0xd0
 [<c024dc06>] scsi_request_fn+0x246/0x410
 [<c021a9e3>] __elv_add_request+0x33/0x50
 [<c021ce1c>] blk_insert_request+0x9c/0xf0
 [<c024c819>] scsi_do_req+0x49/0xa0
 [<c024c673>] scsi_insert_special_req+0x33/0x40
 [<e0893062>] sg_common_write+0x1c2/0x240 [sg]
 [<e08944a0>] sg_cmd_done+0x0/0x330 [sg]
 [<e0892df9>] sg_new_write+0x1e9/0x290 [sg]
 [<c024d9fe>] scsi_request_fn+0x3e/0x410
 [<e0893cbf>] sg_ioctl+0xbdf/0xe00 [sg]
 [<c021aab6>] elv_next_request+0x16/0x100
 [<c024d9fe>] scsi_request_fn+0x3e/0x410
 [<c011da9a>] __wake_up_common+0x3a/0x60
 [<c016f074>] kill_fasync+0x44/0x4d
 [<e0894645>] sg_cmd_done+0x1a5/0x330 [sg]
 [<c0247719>] scsi_finish_command+0xf9/0x150
 [<c024748c>] scsi_softirq+0xec/0x240
 [<c016f42d>] sys_ioctl+0x15d/0x2e6
 [<c0118abd>] smp_apic_timer_interrupt+0xcd/0x140
 [<c010975f>] syscall_call+0x7/0xb

Unable to handle kernel paging request at virtual address 6b6b6b7b
 printing eip:
e0824534
*pde = 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<e0824534>]    Tainted: G S
EFLAGS: 00010086
EIP is at idescsi_queue+0x244/0x6d0 [ide_scsi]
eax: 6b6b6b6b   ebx: df65eb1c   ecx: c0406b48   edx: 00000000
esi: dfd94998   edi: de1c3000   ebp: db233c84   esp: db233c3c
ds: 007b   es: 007b   ss: 0068
Process sg_dd (pid: 1900, threadinfo=db232000 task=ddcac080)
Stack: c0406b48 dffe587c 00000003 c0246909 dfdff500 00000020 0011b565 c150b400 
       00000000 dfd949e5 de3d7c38 dffe587c c0406b48 db233c98 0000ea60 de3d7aac 
       dfd94998 de3d7a80 db233cd4 c0246fc8 dfd94998 c0247320 c024a6d0 db233cb8 
Call Trace:
 [<c0246909>] __scsi_get_command+0x29/0xc0
 [<c0246fc8>] scsi_dispatch_cmd+0x218/0x3e0
 [<c0247320>] scsi_done+0x0/0x80
 [<c024a6d0>] scsi_times_out+0x0/0x90
 [<c024d946>] scsi_prep_fn+0xd6/0x150
 [<c024ca70>] scsi_init_cmd_errh+0xa0/0xd0
 [<c024dc06>] scsi_request_fn+0x246/0x410
 [<c021a9e3>] __elv_add_request+0x33/0x50
 [<c021ce1c>] blk_insert_request+0x9c/0xf0
 [<c024c819>] scsi_do_req+0x49/0xa0
 [<c024c673>] scsi_insert_special_req+0x33/0x40
 [<e0893062>] sg_common_write+0x1c2/0x240 [sg]
 [<e08944a0>] sg_cmd_done+0x0/0x330 [sg]
 [<e0892df9>] sg_new_write+0x1e9/0x290 [sg]
 [<c024d9fe>] scsi_request_fn+0x3e/0x410
 [<e0893cbf>] sg_ioctl+0xbdf/0xe00 [sg]
 [<c021aab6>] elv_next_request+0x16/0x100
 [<c024d9fe>] scsi_request_fn+0x3e/0x410
 [<c011da9a>] __wake_up_common+0x3a/0x60
 [<c016f074>] kill_fasync+0x44/0x4d
 [<e0894645>] sg_cmd_done+0x1a5/0x330 [sg]
 [<c0247719>] scsi_finish_command+0xf9/0x150
 [<c024748c>] scsi_softirq+0xec/0x240
 [<c016f42d>] sys_ioctl+0x15d/0x2e6
 [<c0118abd>] smp_apic_timer_interrupt+0xcd/0x140
 [<c010975f>] syscall_call+0x7/0xb

Code: 8b 40 10 8b 70 34 81 7e 04 ad 4e ad de 74 1c c7 44 24 04 0f 

--------------060509050005020607040506--

