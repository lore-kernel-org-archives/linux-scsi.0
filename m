From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 3125] New: Can't read data from zip250
 reiserfs partition
Date: Tue, 27 Jul 2004 12:57:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040727125712.71011b65.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:41622 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266531AbUG0T6g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2004 15:58:36 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "viro@parcelfarce.linux.theplanet.co.uk" <viro@parcelfarce.linux.theplanet.co.uk>


Looks like a repeatable crash in the imm.c driver.

Begin forwarded message:

Date: Tue, 27 Jul 2004 12:27:49 -0700
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 3125] New: Can't read data from zip250 reiserfs partition


http://bugme.osdl.org/show_bug.cgi?id=3125

           Summary: Can't read data from zip250 reiserfs partition
    Kernel Version: 2.6.7
            Status: NEW
          Severity: normal
             Owner: reiserfs-dev@namesys.com
         Submitter: wwh20610@cmsu2.cmsu.edu


Distribution: My Own
Hardware Environment: i686 pentium3 i386
Software Environment: GNU/linux

Gnu C                  3.4.1
Gnu make               3.80
binutils               2.15.91.0.1
util-linux             2.12a
mount                  2.12a
module-init-tools      3.0
e2fsprogs              1.35
Linux C Library        2.3.4
Dynamic linker (ldd)   2.3.4
Linux C++ Library      6.0.1
Procps                 3.2.1
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.2.1
Modules Loaded

Problem Description: Not able to read data from reiserfs partition on zip250 
disk.  Using imm driver in scsi low level drivers in the kernel.

Steps to reproduce:

Mount a zip250 with a reiserfs partition on it not created from the host 
machine.  Try to cat, move, copy, or anything with the file and the kernel is 
not happy.

Here's the information:

SCSI device sdc: 489532 512-byte hdwr sectors (251 MB)
sdc: Write Protect is off
sdc: Mode Sense: 31 00 00 08
SCSI device sdc: drive cache: write back
SCSI device sdc: 489532 512-byte hdwr sectors (251 MB)
sdc: Write Protect is off
sdc: Mode Sense: 31 00 00 08
SCSI device sdc: drive cache: write back
 sdc: sdc4
ReiserFS: sdc4: found reiserfs format "3.6" with standard journal
ReiserFS: sdc4: using ordered data mode
ReiserFS: sdc4: journal params: device sdc4, size 8192, journal first block 18, 
max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sdc4: checking transaction log (sdc4)
ReiserFS: sdc4: Using r5 hash to sort names
Unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
c02bef2b
*pde = 00000000
Oops: 0002 [#1]
PREEMPT SMP 
Modules linked in:
CPU:    1
EIP:    0060:[<c02bef2b>]    Not tainted
EFLAGS: 00010202   (2.6.7) 
EIP is at imm_byte_in+0x3b/0x60
eax: 000000d0   ebx: 00000200   ecx: 0000037a   edx: 00000378
esi: 00000001   edi: 00000378   ebp: 00000000   esp: c2071e80
ds: 007b   es: 007b   ss: 0068
Process events/1 (pid: 7, threadinfo=c2071000 task=c20fcb70)
Stack: f7fc4758 00000378 00000000 00000379 c02bf232 00000378 00000000 00000200 
       c2022be0 00000200 f528cb80 f7fc4758 00000379 c02bf6ef f7fc4758 00000000 
       00000200 0000037a 00000001 004b1b45 000007d0 00000006 f528cb80 f7fc4758 
Call Trace:
 [<c02bf232>] imm_in+0x152/0x190
 [<c02bf6ef>] imm_completion+0x1cf/0x220
 [<c02bfc93>] imm_engine+0x403/0x480
 [<c02bf777>] imm_interrupt+0x37/0x150
 [<c0130686>] worker_thread+0x1f6/0x2d0
 [<c02bf740>] imm_interrupt+0x0/0x150
 [<c011b130>] default_wake_function+0x0/0x20
 [<c011b130>] default_wake_function+0x0/0x20 [<c0102185>] 
kernel_thread_helper+0x5/0x10

Code: 88 45 00 89 ca b0 25 ee 4b 75 ea 8b 1c 24 b8 01 00 00 00 8b 
 <6>parport0: imm already owner
parport0: imm already owner
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 6 
lun 0
SCSI error : <1 0 6 0> return code = 0x70000
end_request: I/O error, dev sdc, sector 76560
scsi1 (6:0): rejecting I/O to offline device
scsi1 (6:0): rejecting I/O to offline device
Buffer I/O error on device sdc4, logical block 95
lost page write due to I/O error on sdc4
Buffer I/O error on device sdc4, logical block 96
REISERFS: panic (device sdc4): journal-601, buffer write failed

------------[ cut here ]------------
kernel BUG at fs/reiserfs/prints.c:362!
invalid operand: 0000 [#2]
PREEMPT SMP 
Modules linked in:
CPU:    0
EIP:    0060:[<c01b95c2>]    Not tainted
EFLAGS: 00010286   (2.6.7) 
lost page write due to I/O error on sdc4
EIP is at reiserfs_panic+0x52/0x80
eax: 00000044   ebx: c03ae800   ecx: c03eba14   edx: f7d13000
esi: f7cb4c00   edi: f7cb4d44   ebp: f7cb4c00   esp: f7d13df8
ds: 007b   es: 007b   ss: 0068
Process pdflush (pid: 13, threadinfo=f7d13000 task=f7ceb6d0)
Stack: c03b3220 f7cb4d44 c04ceaa0 f3b58000 f7f9ad58 00000000 c01c6b83 f7cb4c00 
       c03b42f4 00001000 fabe6070 f3b58000 00000001 f7f9ad70 f58bc83c f7cb4c00 
       f7f9ad58 00000000 f7f9ad58 c01cbd98 f7cb4c00 f7f9ad58 00000001 00000006 
Call Trace:
 [<c01c6b83>] flush_commit_list+0x443/0x470
 [<c01cbd98>] do_journal_end+0xb18/0xb99
 [<c01ca718>] journal_end_sync+0x48/0xb0
 [<c01b5a09>] reiserfs_sync_fs+0x79/0xe0
 [<c0168d1d>] put_super+0x2d/0x70
 [<c0169490>] sync_supers+0x120/0x130
 [<c0145415>] wb_kupdate+0x35/0x130
 [<c0394c6b>] schedule+0x1cb/0x670
 [<c014612b>] __pdflush+0x10b/0x240
 [<c0146260>] pdflush+0x0/0x30
 [<c0146286>] pdflush+0x26/0x30
 [<c01453e0>] wb_kupdate+0x0/0x130
 [<c0146260>] pdflush+0x0/0x30
 [<c013478c>] kthread+0xbc/0x100
 [<c01346d0>] kthread+0x0/0x100
 [<c0102185>] kernel_thread_helper+0x5/0x10

Code: 0f 0b 6a 01 cb ec 3a c0 c7 04 24 44 32 3b c0 85 f6 be a0 ea 
 <3>scsi1 (6:0): rejecting I/O to offline device
Buffer I/O error on device sdc4, logical block 9566
 [<c0130490>] worker_thread+0x0/0x2d0
 [<c013478c>] kthread+0xbc/0x100
 [<c01346d0>] kthread+0x0/0x100

Here is what I have done to confirm my hardware is ok.  I installed slackware 
8.1 using the 2.4.18 kernel and it read the data from the zip250 disk I'm 
having problems with on 2.6.7.  I have another zip250 disk I deleted the 
partitions, cleared the disk, and then made a partition on it and a formatted 
it with reiserfs with the 2.6.7 machine.  I was able to mount and copy and read 
files to the partition.  I took that same disk I made with the 2.6.7 machine 
and took it to the 2.4.18 machine and it could read and write files to it.

With the 2.4.18 machine, I copied the files I needed from the zip250 disk I'm 
having problems with and then copied the files to the zip250 disk made on the 
2.6.7 machine.  I took that disk back to the 2.6.7 machine, mounted it and 
tried to copy a file from it and the kernel gave messages.

My problem, I can't share zipdisks between older kernels and 2.6.7  I do not 
know if it affects kernels in the 2.6 before 2.6.7.  Somehow, writing from the 
2.4.18 kernel messed it up enough that the 2.6.7 kernel has problems reading 
the data.  I can get directory listings no problem in the 2.6.7 kernel.

2.6.7 can work with its own but not with the 2.4.18-22 (havne't confirmed with 
23-26)

2.4.18 can work with it's own and other kernels

The original zip250 disk I'm having problems with was created on a 2.4.22 
machine.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
