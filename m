From: Andrew Morton <akpm@osdl.org>
Subject: aic7xxx timer handling bug
Date: Mon, 9 Jan 2006 04:06:06 -0800
Message-ID: <20060109040606.118a0d33.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:8158 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751259AbWAIMGU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2006 07:06:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org


While doing a binary search for a buggy patch (it was
gregkh-pci-x86-pci-domain-support-the-meat.patch, reported on
linux-kernel), I hit the below.


PIIX4: IDE controller at PCI slot 0000:00:10.0
PIIX4: device not capable of full native PCI mode
PIIX4: device disabled (BIOS)                    
PIIX4: IDE controller at PCI slot 0000:00:10.0
PIIX4: device not capable of full native PCI mode
PIIX4: device disabled (BIOS)                    
hda: max request size: 128KiB
hda: 120064896 sectors (61473 MB) w/2048KiB Cache, CHS=65535/16/63, UDMA(33)
hda: cache flushes notsupported                                             
 hda: hda1 hda2 hda3           
hdc: ATAPI 24X CD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.20    
ACPI: PCI Interrupt 0000:03:04.0[A]: no GSI - using IRQ 11
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 29160 Ultra160 SCSI adapter>                
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
                                                                
 0:0:0:0: Attempting to queue an ABORT message
CDB: 0x12 0x0 0x0 0x0 0x24 0x0                
 0:0:0:0: Command already completed
aic7xxx_abort returns 0x2002       
 0:0:0:0: Attempting to queue an ABORT message
CDB: 0x0 0x0 0x0 0x0 0x0 0x0                  
------------[ cut here ]------------
kernel BUG at kernel/timer.c:293!   
invalid opcode: 0000 [#1]        
SMP                      
Modules linked in:
CPU:    1         
EIP:    0060:[<c0120388>]    Not tainted VLI
EFLAGS: 00010046   (2.6.15)                 
EIP is at mod_timer+0x21/0x2b
eax: c36e3d18   ebx: c3efde00   ecx: c3f38068   edx: ffff04b2
esi: c3609800   edi: c3f00080   ebp: c3621e5c   esp: c3621e5c
ds: 007b   es: 007b   ss: 0068                               
Process scsi_eh_0 (pid: 817, threadinfo=c3620000 task=c3cc2550)
Stack: c3621eb4 c02791ed 00000001 00000246 00000000 c3efde98 c3cbd800 c3cbd800 
       c3cbd900 c3f38068 00000071 00000007 00000000 c3620001 00000000 00000000 
       00000041 00000001 41607c00 c3efde00 00000071 000003e8 c3621ecc c027fd70 
Call Trace:                                                                    
 [<c01036c5>] show_stack+0x6e/0x88
 [<c01037fa>] show_registers+0x104/0x15c
 [<c01039b2>] die+0xe9/0x166            
 [<c0103ac1>] do_trap+0x92/0x94
 [<c0103d14>] do_invalid_op+0x95/0x9c
 [<c01033cf>] error_code+0x4f/0x54   
 [<c02791ed>] ahc_handle_seqint+0x1324/0x13eb
 [<c027fd70>] ahc_pause_and_flushwork+0x3c6/0x441
 [<c028ac5f>] ahc_linux_queue_recovery_cmd+0x247/0x84d
 [<c028892f>] ahc_linux_abort+0xe/0x2a                
 [<c026cb61>] scsi_send_eh_cmnd+0xba/0xd2
 [<c026ce19>] scsi_eh_tur+0x80/0xbd      
 [<c026ceb8>] scsi_eh_abort_cmds+0x62/0x72
 [<c026d79f>] scsi_unjam_host+0x85/0x97   
 [<c026d81e>] scsi_error_handler+0x6d/0x91
 [<c012a1e9>] kthread+0x9f/0xa4           
 [<c0100f01>] kernel_thread_helper+0x5/0xb
Code: 0f 0b 08 01 d1 5f 35 c0 eb d3 55 89 e5 83 78 0c 00 74 18 39 50 08 74 07 e 

I don't think the PCI domain patch is the cause of this - it's just the
thing which cause the abort handler to run.  I'd be suspecting that the
aix7xxx abort handling is bust.  I seem to recall seeing someone else
report this a month or so ago?
