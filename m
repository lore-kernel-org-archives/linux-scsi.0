From: Mark Rustad <MRustad@aol.com>
Subject: PROBLEM: kernel crashes on RAID1 drive error
Date: Wed, 20 Oct 2004 17:08:24 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8FA83ADB-22E4-11D9-AC9C-0003934F6348@aol.com>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Folks,

I have been having trouble with kernel crashes resulting from RAID1 
component device failures. I have been testing the robustness of an 
embedded system and have been using a drive that is known to fail after 
a time under load. When this device returns a media error, I always 
wind up with either a kernel hang or reboot. In this environment, each 
drive has four partitions, each of which is part of a RAID1 with its 
partner on the other device. Swap is on md2 so even it should be 
robust.

I have gotten this result with the SuSE standard i386 smp kernels 
2.6.5-7.97 and 2.6.5-7.108. I also get these failures with the 
kernel.org kernels 2.6.8.1, 2.6.9-rc4 and 2.6.9.

The hardware setup is a two cpu Nacona with an Adaptec 7902 SCSI 
controller with two Seagate drives on a SAF-TE bus. I run three or four 
dd commands copying /dev/md0 to /dev/null to provide the activity that 
stimulates the failure.

I suspect that something is going wrong in the retry of the failed I/O 
operations, but I'm really not familiar with any of this area of the 
kernel at all.

In one failure, I get the following messages from kernel 2.6.9:

raid1: Disk failure on sdb1, disabling device.
raid1: sdb1: rescheduling sector 176
raid1: sda1: redirecting sector 176 to another mirror
raid1: sdb1: rescheduling sector 184
raid1: sda1: redirecting sector 184 to another mirror
Incorrect number of segments after building list
counted 2, received 1
req nr_sec 0, cur_nr_sec 7
raid1: sda1: rescheduling sector 176
raid1: sda1: redirecting sector 176 to another mirror
Incorrect number of segments after building list
counted 2, received 1
req nr_sec 0, cur_nr_sec 7
raid1: sda1: rescheduling sector 184
raid1: sda1: redirecting sector 184 to another mirror
Incorrect number of segments after building list
counted 3, received 1
req nr_sec 0, cur_nr_sec 7
raid1: sda1: rescheduling sector 176
raid1: sda1: redirecting sector 176 to another mirror
Incorrect number of segments after building list
counted 2, received 1
---

The above messages go on essentially forever. At least until this 
activity itself causes something to wedge.

The other failure I get is an oops. Here is the output from ksymoops:

ksymoops 2.4.9 on i686 2.6.5-7.97-bigsmp.  Options used
      -v vmlinux (specified)
      -K (specified)
      -L (specified)
      -O (specified)
      -M (specified)

kernel BUG at /usr/src/linux-2.6.9/fs/buffer.c:614!
invalid operand: 0000 [#1]
CPU:    1
EIP:    0060:[<c014faf9>]    Not tainted VLI
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010246   (2.6.9-3d-1)
eax: 00000019   ebx: c0dc695c   ecx: c0dc695c   edx: 00000001
esi: 00000001   edi: 00000000   ebp: 00000000   esp: df9f7d30
ds: 007b   es: 007b   ss: 0068
Stack: dec21540 c0152128 00000000 00000000 c015214b dec21540 c0153338 
c0152956
        c02f26b9 f7cf1d80 df8aea00 f7cf1dc0 f7cf1dc0 df8aea00 c02f2738 
c013637e
        f7cf1dc0 00000001 df8aea00 00000000 c02f2815 00002002 d2a0ab00 
df9f7d94
Call Trace:
  [<c0152128>] end_bio_bh_io_sync+0x0/0x3b
  [<c015214b>] end_bio_bh_io_sync+0x23/0x3b
  [<c0153338>] bio_endio+0x3b/0x65
  [<c0152956>] bio_put+0x21/0x2d
  [<c02f26b9>] put_all_bios+0x3d/0x57
  [<c02f2738>] raid_end_bio_io+0x22/0xb8
  [<c013637e>] mempool_free+0x6c/0x73
  [<c02f2815>] raid1_end_read_request+0x47/0xcb
  [<c02a846d>] scsi_softirq+0xbf/0xcd
  [<c0136257>] mempool_alloc+0x66/0x121
  [<c02f27ce>] raid1_end_read_request+0x0/0xcb
  [<c0153338>] bio_endio+0x3b/0x65
  [<c0279dd4>] __end_that_request_first+0xe3/0x22d
  [<c011e537>] prepare_to_wait_exclusive+0x15/0x4c
  [<c02ac212>] scsi_end_request+0x1b/0xa6
  [<c02ac56d>] scsi_io_completion+0x16a/0x4a3
  [<c011d2d5>] __wake_up+0x32/0x43
  [<c02a851e>] scsi_finish_command+0x7d/0xd1
  [<c02a846d>] scsi_softirq+0xbf/0xcd
  [<c0124342>] __do_softirq+0x62/0xcd
  [<c01243da>] do_softirq+0x2d/0x35
  [<c0108b38>] do_IRQ+0x112/0x129
  [<c0106cc0>] common_interrupt+0x18/0x20
  [<c027007b>] uart_block_til_ready+0x18e/0x193
  [<c02f2b60>] unplug_slaves+0x95/0x97
  [<c02f3b29>] raid1d+0x186/0x18e
  [<c02f85ac>] md_thread+0x174/0x19a
  [<c011e5b9>] autoremove_wake_function+0x0/0x37
  [<c011e5b9>] autoremove_wake_function+0x0/0x37
  [<c02f8438>] md_thread+0x0/0x19a
  [<c01047fd>] kernel_thread_helper+0x5/0xb
Code: ff f0 0f ba 2f 01 eb a0 8b 02 a8 04 74 2a 5b 89 ea b8 f4 28 3e c0 
5e 5f 5d


 >>EIP; c014faf9 <end_buffer_async_read+a4/bb>   <=====

 >>ebx; c0dc695c <pg0+83995c/3fa71400>
 >>ecx; c0dc695c <pg0+83995c/3fa71400>
 >>esp; df9f7d30 <pg0+1f46ad30/3fa71400>

Trace; c0152128 <end_bio_bh_io_sync+0/3b>
Trace; c015214b <end_bio_bh_io_sync+23/3b>
Trace; c0153338 <bio_endio+3b/65>
Trace; c0152956 <bio_put+21/2d>
Trace; c02f26b9 <put_all_bios+3d/57>
Trace; c02f2738 <raid_end_bio_io+22/b8>
Trace; c013637e <mempool_free+6c/73>
Trace; c02f2815 <raid1_end_read_request+47/cb>
Trace; c02a846d <scsi_softirq+bf/cd>
Trace; c0136257 <mempool_alloc+66/121>
Trace; c02f27ce <raid1_end_read_request+0/cb>
Trace; c0153338 <bio_endio+3b/65>
Trace; c0279dd4 <__end_that_request_first+e3/22d>
Trace; c011e537 <prepare_to_wait_exclusive+15/4c>
Trace; c02ac212 <scsi_end_request+1b/a6>
Trace; c02ac56d <scsi_io_completion+16a/4a3>
Trace; c011d2d5 <__wake_up+32/43>
Trace; c02a851e <scsi_finish_command+7d/d1>
Trace; c02a846d <scsi_softirq+bf/cd>
Trace; c0124342 <__do_softirq+62/cd>
Trace; c01243da <do_softirq+2d/35>
Trace; c0108b38 <do_IRQ+112/129>
Trace; c0106cc0 <common_interrupt+18/20>
Trace; c027007b <uart_block_til_ready+18e/193>
Trace; c02f2b60 <unplug_slaves+95/97>
Trace; c02f3b29 <raid1d+186/18e>
Trace; c02f85ac <md_thread+174/19a>
Trace; c011e5b9 <autoremove_wake_function+0/37>
Trace; c011e5b9 <autoremove_wake_function+0/37>
Trace; c02f8438 <md_thread+0/19a>
Trace; c01047fd <kernel_thread_helper+5/b>

Code;  c014faf9 <end_buffer_async_read+a4/bb>
00000000 <_EIP>:
Code;  c014faf9 <end_buffer_async_read+a4/bb>   <=====
    0:   ff f0                     push   %eax   <=====
Code;  c014fafb <end_buffer_async_read+a6/bb>
    2:   0f ba 2f 01               btsl   $0x1,(%edi)
Code;  c014faff <end_buffer_async_read+aa/bb>
    6:   eb a0                     jmp    ffffffa8 <_EIP+0xffffffa8>
Code;  c014fb01 <end_buffer_async_read+ac/bb>
    8:   8b 02                     mov    (%edx),%eax
Code;  c014fb03 <end_buffer_async_read+ae/bb>
    a:   a8 04                     test   $0x4,%al
Code;  c014fb05 <end_buffer_async_read+b0/bb>
    c:   74 2a                     je     38 <_EIP+0x38>
Code;  c014fb07 <end_buffer_async_read+b2/bb>
    e:   5b                        pop    %ebx
Code;  c014fb08 <end_buffer_async_read+b3/bb>
    f:   89 ea                     mov    %ebp,%edx
Code;  c014fb0a <end_buffer_async_read+b5/bb>
   11:   b8 f4 28 3e c0            mov    $0xc03e28f4,%eax
Code;  c014fb0f <end_buffer_async_read+ba/bb>
   16:   5e                        pop    %esi
Code;  c014fb10 <end_buffer_async_write+0/de>
   17:   5f                        pop    %edi
Code;  c014fb11 <end_buffer_async_write+1/de>
   18:   5d                        pop    %ebp

  <0>Kernel panic - not syncing: Fatal exception in interrupt
---

In these cases, the kernel is a monolithic kernel - no modules at all. 
Since the problem also happens with the standard SuSE smp kernel, which 
does have modules, I don't believe that that is a factor. We just don't 
need modules in our embedded system.

I don't know if the problem is in the raid1 code, in the general SCSI 
code or in the Adaptec driver somewhere. Does anyone have a clue?

Note that using mdadm to fail a drive is utterly unlike this and seems 
to work ok. It seems to take an honest-to-goodness broken drive to get 
this failure. Of course, the whole point of RAID1 is to handle a 
failing drive, so this is kind of a serious problem.

-- 
Mark Rustad, MRustad@aol.com

