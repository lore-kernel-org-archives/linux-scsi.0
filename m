From: Mark Rustad <MRustad@aol.com>
Subject: Re: PROBLEM: kernel crashes on RAID1 drive error
Date: Fri, 22 Oct 2004 11:00:46 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <88F77D21-2443-11D9-AAEE-0003934F6348@aol.com>
References: <8FA83ADB-22E4-11D9-AC9C-0003934F6348@aol.com> <20041021084514.GY10531@suse.de> <4177BF22.7060208@steeleye.com> <20041021135557.GN10531@suse.de> <4177C13C.10007@steeleye.com> <20041021140236.GO10531@suse.de>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041021140236.GO10531@suse.de>
To: Jens Axboe <axboe@suse.de>
Cc: linux-raid@vger.kernel.org, Paul Clements <paul.clements@steeleye.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jens,

On Oct 21, 2004, at 9:02 AM, Jens Axboe wrote:

>>> -97 is the release kernel, -111 is the current update kernel. And it 
>>> has
>>> those raid1 issues fixed already, at least the ones that are known. 
>>> The
>>> scsi segment issue is not, however.
>>
>> Thanks. Good to know that. -111 is currently available to customers? 
>> We
>> may recommend that our customers use that, rather than patching -97
>> ourselves.
>
> Yes it is, it's generally available through the online updates.

FWIW, I tried the -111 kernel and got a crash with my failing drive. 
The messages out of the kernel were:

raid1: Disk failure on sdb1, disabling device.
raid1: sdb1: rescheduling sector 176
raid1: sda1: redirecting sector 176 to another mirror
raid1: sdb1: rescheduling sector 184
raid1: sda1: redirecting sector 184 to another mirror
Oct 22 10:42:03 linux kernel: scsi0: ERROR on channel 0, id 5, lun 0, 
CDB: Read (10) 00 00 00 00 bf 00 01 00 00
Oct 22 10:42:03 linux kernel: Info fld=0xf3, Current sdb: sense key 
Medium Error
Oct 22 10:42:03 linux kernel: Additional sense: Unrecovered read error
Oct 22 10:42:03 linux kernel: end_request: I/O error, dev sdb, sector 
240
Unable to handle kernel NULL pointer dereference at virtual address 
00000000
  printing eip:
*pde = 00000000
Oops: 0000 [#1]
SMP
CPU:    0
EIP:    0060:[<c01559a4>]    Tainted: G  U
EFLAGS: 00010286   (2.6.5-7.111-smp)
EIP is at page_address+0x14/0xc0
eax: 00000000   ebx: 00000000   ecx: d0e50ac0   edx: f782a970
esi: f7d7cd00   edi: 00000001   ebp: 00000008   esp: f7e65e90
ds: 007b   es: 007b   ss: 0068
Process scsi_eh_0 (pid: 220, threadinfo=f7e64000 task=f7e1acb0)
Stack: 00000000 f7d7cd00 00000001 00000008 c0249501 c0127b7a 00000001 
d0e50ac0
        00000000 00000e00 c0249bee c035b0f4 f7eb5e8c 000000ef 00000000 
00000001
        fffffffb 00000e00 00000007 f7d7cd00 f7d7cd00 f71cce00 00000000 
f7def200
Call Trace:
  [<c0249501>] blk_recalc_rq_sectors+0xa1/0x110
  [<c0127b7a>] printk+0x18a/0x1a0
  [<c0249bee>] __end_that_request_first+0x1be/0x240
  [<f883fb99>] scsi_end_request+0x29/0xe0 [scsi_mod]
  [<f883ff74>] scsi_io_completion+0x324/0x4c0 [scsi_mod]
  [<f883a3b2>] scsi_finish_command+0x82/0xf0 [scsi_mod]
  [<c0127b7a>] printk+0x18a/0x1a0
  [<f883e687>] scsi_error_handler+0x987/0xed0 [scsi_mod]
  [<f883dd00>] scsi_error_handler+0x0/0xed0 [scsi_mod]
  [<c0107005>] kernel_thread_helper+0x5/0x10

Code: 8b 00 f6 c4 01 75 26 a1 0c fb 47 c0 29 c3 c1 fb 05 c1 e3 0c
  <1>Unable to handle kernel NULL pointer dereference at virtual address 
00000000
  printing eip:
f88584be
*pde = 00000000
Oops: 0002 [#2]
SMP
CPU:    0
EIP:    0060:[<f88584be>]    Tainted: G  U
EFLAGS: 00010046   (2.6.5-7.111-smp)
EIP is at dump_block_silence+0x1e/0xc0 [dump_blockdev]
eax: 00000000   ebx: f7d86c00   ecx: f8875810   edx: 00000000
esi: f8859740   edi: f7e65e5c   ebp: 00000000   esp: f7e65d28
ds: 007b   es: 007b   ss: 0068
Process scsi_eh_0 (pid: 220, threadinfo=f7e64000 task=f7e1acb0)
Stack: 00000000 00000000 00000000 00000000 00000000 00000000 f8870ae9 
00000000
        00000000 00000000 f8870c49 00000000 00000000 00000000 f8870d05 
00000000
        c0358f00 00000202 f886f852 ffffffef c010aed3 00000000 c010af28 
c03552c0
Call Trace:
  [<f8870ae9>] dump_begin+0x59/0xd0 [dump]
  [<f8870c49>] dump_execute_savedump+0x9/0x50 [dump]
  [<f8870d05>] dump_generic_execute+0x75/0x80 [dump]
  [<f886f852>] dump_execute+0x52/0xa0 [dump]
  [<c010aed3>] die+0x133/0x1b0
  [<c010af28>] die+0x188/0x1b0
  [<c011dc40>] do_page_fault+0x0/0x54d
  [<c011df81>] do_page_fault+0x341/0x54d
  [<f88c9c20>] ahd_linux_queue_cmd_complete+0xe0/0x2a0 [aic79xx]
  [<c011dc40>] do_page_fault+0x0/0x54d
  [<c010a28d>] error_code+0x2d/0x40
  [<c01559a4>] page_address+0x14/0xc0
  [<c0249501>] blk_recalc_rq_sectors+0xa1/0x110
  [<c0127b7a>] printk+0x18a/0x1a0
  [<c0249bee>] __end_that_request_first+0x1be/0x240
  [<f883fb99>] scsi_end_request+0x29/0xe0 [scsi_mod]
  [<f883ff74>] scsi_io_completion+0x324/0x4c0 [scsi_mod]
  [<f883a3b2>] scsi_finish_command+0x82/0xf0 [scsi_mod]
  [<c0127b7a>] printk+0x18a/0x1a0
  [<f883e687>] scsi_error_handler+0x987/0xed0 [scsi_mod]
  [<f883dd00>] scsi_error_handler+0x0/0xed0 [scsi_mod]
  [<c0107005>] kernel_thread_helper+0x5/0x10

Code: 86 02 84 c0 ba f0 ff ff ff 7f 0e 8b 5c 24 10 89 d0 8b 74 24
  <6>LKCD dump already in progress
------------[ cut here ]------------
kernel BUG at kernel/exit.c:833!
invalid operand: 0000 [#3]
SMP
CPU:    0
EIP:    0060:[<c012a108>]    Tainted: G  U
EFLAGS: 00010282   (2.6.5-7.111-smp)
EIP is at do_exit+0x968/0xb60
eax: 00000001   ebx: 00000000   ecx: 00000000   edx: 00000001
esi: f7fa17c0   edi: f7e1acb0   ebp: f7fa17c0   esp: f7e65bd8
ds: 007b   es: 007b   ss: 0068
Process scsi_eh_0 (pid: 220, threadinfo=f7e64000 task=f7e1acb0)
Stack: 00017e5a 00000282 f7e65cf4 c0431a41 00000246 f7e1ad08 00000002 
f7e1ad48
        f7e65c10 00000202 00000002 f7e1ad08 f7e64000 00000002 f7e65cf4 
00000002
        c010af50 0000000b c034405a 00000002 00000002 f7e1acb0 c034405a 
00000000
Call Trace:
  [<c010af50>] do_simd_coprocessor_error+0x0/0xb0
  [<c011dc40>] do_page_fault+0x0/0x54d
  [<c011df81>] do_page_fault+0x341/0x54d
  [<f886fdfe>] dump_lcrash_save_context+0x2e/0x60 [dump]
  [<c0119fa1>] dump_send_ipi+0x11/0x20
  [<f88710e4>] __dump_save_other_cpus+0xb4/0xe0 [dump]
  [<f88700ce>] dump_lcrash_configure_header+0x29e/0x2c0 [dump]
  [<c011dc40>] do_page_fault+0x0/0x54d
  [<c010a28d>] error_code+0x2d/0x40
  [<f88584be>] dump_block_silence+0x1e/0xc0 [dump_blockdev]
  [<f8870ae9>] dump_begin+0x59/0xd0 [dump]
  [<f8870c49>] dump_execute_savedump+0x9/0x50 [dump]
  [<f8870d05>] dump_generic_execute+0x75/0x80 [dump]
  [<f886f852>] dump_execute+0x52/0xa0 [dump]
  [<c010aed3>] die+0x133/0x1b0
  [<c010af28>] die+0x188/0x1b0
  [<c011dc40>] do_page_fault+0x0/0x54d
  [<c011df81>] do_page_fault+0x341/0x54d
  [<f88c9c20>] ahd_linux_queue_cmd_complete+0xe0/0x2a0 [aic79xx]
  [<c011dc40>] do_page_fault+0x0/0x54d
  [<c010a28d>] error_code+0x2d/0x40
  [<c01559a4>] page_address+0x14/0xc0
  [<c0249501>] blk_recalc_rq_sectors+0xa1/0x110
  [<c0127b7a>] printk+0x18a/0x1a0
  [<c0249bee>] __end_that_request_first+0x1be/0x240
  [<f883fb99>] scsi_end_request+0x29/0xe0 [scsi_mod]
  [<f883ff74>] scsi_io_completion+0x324/0x4c0 [scsi_mod]
  [<f883a3b2>] scsi_finish_command+0x82/0xf0 [scsi_mod]
  [<c0127b7a>] printk+0x18a/0x1a0
  [<f883e687>] scsi_error_handler+0x987/0xed0 [scsi_mod]
  [<f883dd00>] scsi_error_handler+0x0/0xed0 [scsi_mod]
  [<c0107005>] kernel_thread_helper+0x5/0x10

Code: 0f 0b 41 03 37 43 34 c0 eb fe 8b 6f 10 85 ed 74 ac eb 9b 8b
  <6>LKCD dump already in progress

*** everything beyond removed, because cpu 0 continued to fault over 
and over

-- 
Mark Rustad, MRustad@aol.com

