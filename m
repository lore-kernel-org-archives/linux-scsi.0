From: Brian King <brking@us.ibm.com>
Subject: PROBLEM: Oops in 2.6.3 with lots of SG_IO activity
Date: Thu, 04 Mar 2004 14:13:07 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40478DD3.10807@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:47800 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262108AbUCDUNJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2004 15:13:09 -0500
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e5.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id i24KD9Jr478688
	for <linux-scsi@vger.kernel.org>; Thu, 4 Mar 2004 15:13:09 -0500
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i24KD8Kf128830
	for <linux-scsi@vger.kernel.org>; Thu, 4 Mar 2004 15:13:08 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have been experiencing occasional oopses in some testing I have been
doing and have recently been able to aggravate the problem to recreate
the oops quite quickly. If I do lots of overlapped SG_IO ioctls while
also doing heavy disk I/O, I can recreate the oops within a few minutes,
although I have also seen the problem under very little load. I have
seen the problem using both the ipr and sym2 drivers.


ksymoops output:

Unable to handle kernel paging request at virtual address c6cf3044
c017e81c
*pde = 0001c067
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<c017e81c>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010286
eax: c6cf3044   ebx: c9545df8   ecx: 00000002   edx: c6cf3044
esi: c6cf3048   edi: c6cf3000   ebp: cc7a7c84   esp: cc7a7c74
ds: 007b   es: 007b   ss: 0068
Stack: cc7a7c84 c9545df8 c6cf3048 c9545df8 cc7a7ca8 d086c547 c6cf3044 0000001d
        00020001 d0889000 cad8ebf8 cec4f000 c9170eb8 cc7a7cc8 c032e743 c9170eb8
        cafd13a8 000000ff c9170eb8 cc7a7cd8 0000000a cc7a7ce8 c032e66b c9170eb8
Call Trace:
  [<d086c547>] sg_cmd_done+0x167/0x280 [sg]
  [<c032e743>] scsi_finish_command+0x73/0xb0
  [<c032e66b>] scsi_softirq+0xab/0xd0
  [<c012a935>] do_softirq+0xe5/0xf0
  [<c010c6b8>] do_IRQ+0x198/0x240
  [<c010a50c>] common_interrupt+0x18/0x20
  [<c0253a60>] __copy_from_user_ll+0x50/0x80
  [<c0171ed7>] blkdev_prepare_write+0x27/0x30
  [<c0146aa3>] generic_file_aio_write_nolock+0x463/0xc20
  [<c01472d8>] generic_file_write_nolock+0x78/0x90
  [<c011fd52>] default_wake_function+0x22/0x30
  [<d086c547>] sg_cmd_done+0x167/0x280 [sg]
  [<c032e743>] scsi_finish_command+0x73/0xb0
  [<c01733b3>] blkdev_file_write+0x33/0x40
  [<c0168b6f>] vfs_write+0xaf/0x120
  [<c0168c7f>] sys_write+0x3f/0x60
  [<c0109b9f>] syscall_call+0x7/0xb
Code: 8b 0a 85 c9 74 4b bb 00 e0 ff ff 21 e3 ff 43 14 b8 84 d2 4f


 >>EIP; c017e81c <kill_fasync+c/75>   <=====

 >>eax; c6cf3044 <_end+66b5b80/3f9c0b3c>
 >>ebx; c9545df8 <_end+8f08934/3f9c0b3c>
 >>edx; c6cf3044 <_end+66b5b80/3f9c0b3c>
 >>esi; c6cf3048 <_end+66b5b84/3f9c0b3c>
 >>edi; c6cf3000 <_end+66b5b3c/3f9c0b3c>
 >>ebp; cc7a7c84 <_end+c16a7c0/3f9c0b3c>
 >>esp; cc7a7c74 <_end+c16a7b0/3f9c0b3c>

Trace; d086c547 <_end+1022f083/3f9c0b3c>
Trace; c032e743 <scsi_finish_command+73/b0>
Trace; c032e66b <scsi_softirq+ab/d0>
Trace; c012a935 <do_softirq+e5/f0>
Trace; c010c6b8 <do_IRQ+198/240>
Trace; c010a50c <common_interrupt+18/20>
Trace; c0253a60 <__copy_from_user_ll+50/80>
Trace; c0171ed7 <blkdev_prepare_write+27/30>
Trace; c0146aa3 <generic_file_aio_write_nolock+463/c20>
Trace; c01472d8 <generic_file_write_nolock+78/90>
Trace; c011fd52 <default_wake_function+22/30>
Trace; d086c547 <_end+1022f083/3f9c0b3c>
Trace; c032e743 <scsi_finish_command+73/b0>
Trace; c01733b3 <blkdev_file_write+33/40>
Trace; c0168b6f <vfs_write+af/120>
Trace; c0168c7f <sys_write+3f/60>
Trace; c0109b9f <syscall_call+7/b>

Code;  c017e81c <kill_fasync+c/75>
00000000 <_EIP>:
Code;  c017e81c <kill_fasync+c/75>   <=====
    0:   8b 0a                     mov    (%edx),%ecx   <=====
Code;  c017e81e <kill_fasync+e/75>
    2:   85 c9                     test   %ecx,%ecx
Code;  c017e820 <kill_fasync+10/75>
    4:   74 4b                     je     51 <_EIP+0x51>
Code;  c017e822 <kill_fasync+12/75>
    6:   bb 00 e0 ff ff            mov    $0xffffe000,%ebx
Code;  c017e827 <kill_fasync+17/75>
    b:   21 e3                     and    %esp,%ebx
Code;  c017e829 <kill_fasync+19/75>
    d:   ff 43 14                  incl   0x14(%ebx)
Code;  c017e82c <kill_fasync+1c/75>
   10:   b8 84 d2 4f 00            mov    $0x4fd284,%eax




Gnu C                  3.2
Gnu make               3.79.1
util-linux             2.11r
mount                  2.11r
module-init-tools      0.9.12
e2fsprogs              1.27
jfsutils               1.0.17
reiserfsprogs          3.6.2
pcmcia-cs              3.1.31
quota-tools            3.06.
PPP                    2.4.1
isdn4k-utils           3.1pre4
nfs-utils              1.0.1
Linux C Library        2.2.93
Dynamic linker (ldd)   2.2.93
Procps                 2.0.7
Net-tools              1.60
Kbd                    1.06
Sh-utils               2.0.12
Modules Loaded         ipr firmware_class sg


cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 11
model name      : Intel(R) Pentium(R) III CPU family      1266MHz
stepping        : 1
cpu MHz         : 1259.071
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips        : 2482.17

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 11
model name      : Intel(R) Pentium(R) III CPU family      1266MHz
stepping        : 1
cpu MHz         : 1259.071
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips        : 2506.75



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

