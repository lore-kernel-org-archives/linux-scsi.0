From: Phil Carinhas <pac@fortuitous.com>
Subject: System freeze when accessing st.ko and /dev/st0
Date: Fri, 6 Feb 2004 13:42:25 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040206194225.GA27385@mail.fortuitous.com>
Reply-To: pac@fortuitous.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flamingo.mail.pas.earthlink.net ([207.217.120.232]:9183 "EHLO
	flamingo.mail.pas.earthlink.net") by vger.kernel.org with ESMTP
	id S265684AbUBFTm1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2004 14:42:27 -0500
Received: from user-0vvdck9.cable.mindspring.com ([63.246.178.137] helo=mail.fortuitous.com)
	by flamingo.mail.pas.earthlink.net with esmtp (Exim 3.33 #1)
	id 1ApBru-0006JL-00
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2004 11:42:26 -0800
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 System Freeze

When I tried to access the tape drive via 'tar tvfz /dev/st0'
the system froze: Here is the call trace:

 -------- CALL TRACE from /var/log/messages
Feb  6 12:25:48 taren kernel: st: Version 20031228, fixed bufsize 32768, s/g segs 256
Feb  6 12:25:48 taren kernel: Attached scsi tape st0 at scsi1, channel 0, id 6, lun 0
Feb  6 12:25:48 taren kernel: st0: try direct i/o: yes, max page reachable by HBA268435455
Feb  6 12:32:22 taren kernel: st: Unloaded.
Feb  6 12:32:46 taren kernel: Badness in kobject_get at lib/kobject.c:431
Feb  6 12:32:46 taren kernel: Call Trace:
Feb  6 12:32:46 taren kernel:  [<c0274e50>] kobject_get+0x50/0x60
Feb  6 12:32:46 taren kernel:  [<c015c0c9>] cdev_get+0x39/0x80
Feb  6 12:32:46 taren kernel:  [<c015bf9f>] exact_lock+0xf/0x20
Feb  6 12:32:46 taren kernel:  [<c029a135>] kobj_lookup+0xf5/0x1a0
Feb  6 12:32:46 taren kernel:  [<c015bf80>] exact_match+0x0/0x10
Feb  6 12:32:46 taren kernel:  [<c015be73>] chrdev_open+0x143/0x1c0
Feb  6 12:32:46 taren kernel:  [<c0151c70>] dentry_open+0x130/0x1e0
Feb  6 12:32:46 taren kernel:  [<c0151b38>] filp_open+0x68/0x70
Feb  6 12:32:46 taren kernel:  [<c0151f8b>] sys_open+0x5b/0x90
Feb  6 12:32:46 taren kernel:  [<c01090af>] syscall_call+0x7/0xb
Feb  6 12:32:46 taren kernel: 
Feb  6 12:32:46 taren kernel:  printing eip:
Feb  6 12:32:46 taren kernel: c015beda
Feb  6 12:32:46 taren kernel: Oops: 0002 [#1]
Feb  6 12:32:46 taren kernel: CPU:    1
Feb  6 12:32:46 taren kernel: EIP:    0060:[<c015beda>]    Not tainted
Feb  6 12:32:46 taren kernel: EFLAGS: 00010246
Feb  6 12:32:46 taren kernel: EIP is at chrdev_open+0x1aa/0x1c0
Feb  6 12:32:46 taren kernel: eax: 00000000   ebx: e7b57120   ecx: e7b5715c   edx: f713bd2c
Feb  6 12:32:46 taren kernel: esi: 00000000   edi: 00000000   ebp: f713bc10   esp: d29bbf20
Feb  6 12:32:46 taren kernel: ds: 007b   es: 007b   ss: 0068
Feb  6 12:32:46 taren kernel: Process mt (pid: 5807, threadinfo=d29ba000 task=d6fb6670)
Feb  6 12:32:46 taren kernel: Stack: f7fe2c00 00900000 d29bbf2c 00000000 dccb73a0f713bc10 ffffffe9 f7fe6760 
Feb  6 12:32:46 taren kernel:        c0151c70 f713bc10 dccb73a0 00000000 bffffdc4ef414000 d29ba000 c0151b38 
Feb  6 12:32:46 taren kernel:        f714eb60 f7fe6760 00000000 d29bbf70 f714eb60f7fe6760 fffffff4 ef414000 
Feb  6 12:32:46 taren kernel: Call Trace:
Feb  6 12:32:46 taren kernel:  [<c0151c70>] dentry_open+0x130/0x1e0
Feb  6 12:32:46 taren kernel:  [<c0151b38>] filp_open+0x68/0x70
Feb  6 12:32:46 taren kernel:  [<c0151f8b>] sys_open+0x5b/0x90
Feb  6 12:32:46 taren kernel:  [<c01090af>] syscall_call+0x7/0xb
Feb  6 12:32:46 taren kernel: 
Feb  6 12:32:46 taren kernel: Code: 89 50 04 89 4a 04 e9 87 fe ff ff 8d 74 26 00 8d bc 27 00 00 

Here are system specs:
PIII Copermine dual cpu
Both Megaraid and sym53c compiled monolithic.
st is the only module on the system.

 ====
cat /proc/scsi/scsi 
Attached devices:
Host: scsi1 Channel: 00 Id: 06 Lun: 00
  Vendor: HP       Model: C1537A           Rev: L907
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: MegaRAID Model: LD0 RAID1 17500R Rev:   F 
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi2 Channel: 00 Id: 01 Lun: 00
  Vendor: MegaRAID Model: LD1 RAID1  8677R Rev:   F 
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi2 Channel: 04 Id: 05 Lun: 00
  Vendor: HP       Model: SAFTE; U160/M BP Rev: 1020
  Type:   Processor                        ANSI SCSI revision: 02
 ====
cat /proc/scsi/sym53c8xx/*
Chip sym53c896, device id 0xb, revision id 0x6
At PCI address 0000:02:06.0, IRQ 24
Min. period factor 10, Wide SCSI BUS
Max. started commands 510, max. commands per LUN 64
Chip sym53c896, device id 0xb, revision id 0x6
At PCI address 0000:02:06.1, IRQ 25
Min. period factor 10, Wide SCSI BUS
Max. started commands 510, max. commands per LUN 64

 ========
  Question: will compiling st into the kernel monolithically
  change this result?
  
  If possible, please reply to my email address below. If not,
  thanks for looking at this.

-Phil Carinhas
--
 .--------------------------------------------------------.
 | Dr. Philip A. Carinhas       | pac(at)fortuitous.com   |
 | Fortuitous Technologies Inc. | http://fortuitous.com   |
 | Linux Consulting & Training  | Tel : 1-512-218-9561    |
 `--------------------------------------------------------'
