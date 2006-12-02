From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 7614] New: kernel BUG at mm/slab.c:594! Seems
 to affect various SCSI systems in various ways.
Date: Fri, 1 Dec 2006 16:25:28 -0800
Message-ID: <20061201162528.44076c5d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:6621 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1162007AbWLBAZf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Dec 2006 19:25:35 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id kB20PUjQ019687
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 1 Dec 2006 16:25:30 -0800
Received: from akpm.corp.google.com (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id kB20PS14001181
	for <linux-scsi@vger.kernel.org>; Fri, 1 Dec 2006 16:25:29 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Seems pretty common.


Begin forwarded message:

Date: Fri, 1 Dec 2006 15:44:29 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 7614] New: kernel BUG at mm/slab.c:594! Seems to affect various SCSI systems in various ways.


http://bugzilla.kernel.org/show_bug.cgi?id=7614

           Summary: kernel BUG at mm/slab.c:594!   Seems to affect various
                    SCSI systems in various ways.
    Kernel Version: 2.6.18
            Status: NEW
          Severity: normal
             Owner: io_scsi@kernel-bugs.osdl.org
         Submitter: dmartin@sccd.ctc.edu


Most recent kernel where this bug did *NOT* occur: Unknown
Distribution: Fedora
Hardware Environment: i386 with aic7XXX and other
Software Environment: 
Problem Description: In my system, my tape drive generates the error below from
time to time, seemingly randomly.  Others seem to have had the same problem with
different hardware using different scsi devices.  

Here's other people with the same error:

http://lkml.org/lkml/2006/11/12/63
http://www.mail-archive.com/bcm43xx-dev@lists.berlios.de/msg02470.html
http://www.spinics.net/lists/linux-scsi/msg12907.html
http://www.spinics.net/lists/linux-scsi/msg12783.html

------------[ cut here ]------------
kernel BUG at mm/slab.c:594!
invalid opcode: 0000 [#1]
last sysfs file: /class/net/vmnet1/address
Modules linked in: ipv6 vmnet(U) vmmon(U) video sbs i2c_ec container button
battery asus_acpi ac lp parport_pc parport ohci_hcd floppy st sg serio_raw
i2c_piix4 i2c_core cfi_probe gen_probe scb2_flash mtdcore e1000 chipreg
map_funcs pcspkr ide_cd cdrom dm_snapshot dm_zero dm_mirror dm_mod ext3 jbd
aacraid aic7xxx scsi_transport_spi sd_mod scsi_mod
CPU:    0
EIP:    0060:[<c045d3ac>]    Tainted: P      VLI
EFLAGS: 00010202   (2.6.18-1.2239.fc5 #1) 
EIP is at kmem_cache_free+0x29/0x62
eax: c0010068   ebx: f7ffe860   ecx: f7ff5620   edx: c1800000
esi: f7ffcf40   edi: 00000000   ebp: f6b4ac90   esp: ebba4e28
ds: 007b   es: 007b   ss: 0068
Process tar (pid: 5584, ti=ebba4000 task=dff52270 task.ti=ebba4000)
ds: 007b   es: 007b   ss: 0068
Process tar (pid: 5584, ti=ebba4000 task=dff52270 task.ti=ebba4000)
Stack: f7ffe860 f7ffcf40 00000000 c0448c0e 00000000 e0963da0 f7ffcf40 e0963da0 
       c04653e6 00000800 00000000 c046510c f8843f74 00000800 00000000 00000006 
       ebba4f5c da3876c8 00000800 00000000 00000002 c1704480 00002000 00000000 
Call Trace:
 [<c0448c0e>] mempool_free+0x61/0x66
 [<c04653e6>] bio_free+0x25/0x30
 [<c046510c>] bio_put+0x27/0x28
 [<f8843f74>] scsi_execute_async+0x15a/0x32d [scsi_mod]
 [<f8952c57>] st_do_scsi+0x1d1/0x221 [st]
 [<f89565d8>] st_read+0x2ed/0x7a6 [st]
 [<c04613d8>] vfs_read+0xa6/0x157
 [<c0461760>] sys_read+0x41/0x67
 [<c0402d9b>] syscall_call+0x7/0xb
DWARF2 unwinder stuck at syscall_call+0x7/0xb
Leftover inexact backtrace:
 =======================
Code: 5f c3 57 89 d7 8d 92 00 00 00 40 89 c1 c1 ea 0c c1 e2 05 03 15 70 53 79 c0
 56 53 8b 02 f6 c4 40 74 03 8b 52 0c 8b 02 84 c0 78 08 <0f> 0b 52 02 e3 f8 61 c0
 39 4a 18 74 08 0f 0b 99 0d e3 f8 61 c0 
EIP: [<c045d3ac>] kmem_cache_free+0x29/0x62 SS:ESP 0068:ebba4e28

Steps to reproduce: Unknown.  Seriously... Argh.

Sorry that this bug report isn't very helpful.  I just figured havning SCSI
problems was serious enough to warrant posting without better information.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
