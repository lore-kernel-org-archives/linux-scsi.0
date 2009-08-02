From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13873] QLA2xxx driver causes kernel oops with a qla2200
Date: Sun, 2 Aug 2009 13:28:05 GMT
Message-ID: <200908021328.n72DS5X3016215@demeter.kernel.org>
References: <bug-13873-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54952 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZHBN2G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Aug 2009 09:28:06 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n72DS50P016216
	for <linux-scsi@vger.kernel.org>; Sun, 2 Aug 2009 13:28:05 GMT
In-Reply-To: <bug-13873-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13873





--- Comment #2 from Thomas <tageorgiou@gmail.com>  2009-08-02 13:28:04 ---
another backtrace from a different kernel
[ 5998.559852] kernel BUG at drivers/scsi/scsi_transport_fc.c:3022!             
[ 5998.559852] invalid opcode: 0000 [#1] SMP                                    
[ 5998.559852] last sysfs file:
/sys/devices/pci0000:00/0000:00:06.0/0000:05:00.0/0000:06:02.0/host0/rport-0:0-34/target0:0:33/0:0:33:0/type
[ 5998.559852] CPU 1                                                            
[ 5998.559852] Modules linked in: iscsi_trgt qla2xxx                            
[ 5998.559852] Pid: 4796, comm: fc_dl_0 Not tainted 2.6.30-gentoo-r4dl380 #2
ProLiant DL380 G4                                              
[ 5998.559852] RIP: 0010:[<ffffffff812e64c5>]  [<ffffffff812e64c5>]
fc_timeout_deleted_rport+0x28c/0x31e                                    
[ 5998.559852] RSP: 0018:ffff880197c69e50  EFLAGS: 00010202                     
[ 5998.559852] RAX: ffff88019a83c400 RBX: ffff88019a5f5f60 RCX:
ffffffff812d9502                                                            
[ 5998.559852] RDX: ffff880197d35900 RSI: 0000000000000040 RDI:
ffff880197c69e40                                                            
[ 5998.559852] RBP: ffff880197c69e90 R08: 0000000000000000 R09:
ffff880197c69d50                                                            
[ 5998.559852] R10: ffff880197d35900 R11: 0000000000000000 R12:
ffff88019a83c400                                                            
[ 5998.559852] R13: ffff88019a83b5a0 R14: ffff88019a83b400 R15:
ffff88019a627000                                                            
[ 5998.559852] FS:  0000000000000000(0000) GS:ffff88002804d000(0000)
knlGS:0000000000000000                                                 
[ 5998.559852] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b                
[ 5998.559852] CR2: 00007fba710bcdd0 CR3: 0000000195513000 CR4:
00000000000006e0                                                            
[ 5998.559852] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000                                                            
[ 5998.559852] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400                                                            
[ 5998.559852] Process fc_dl_0 (pid: 4796, threadinfo ffff880197c68000, task
ffff88019a9c2440)                                              
[ 5998.559852] Stack:                                                           
[ 5998.559852]  0000000100000000 0000000000000202 ffff880198873000
ffffc20000081080                                                         
[ 5998.559852]  ffffc20000081080 ffff88019a83b5a0 ffff88019a83b5a8
ffff88019a9c2440                                                         
[ 5998.559852]  ffff880197c69f20 ffffffff81046592 ffff880197c69eb0
ffffc20000081098                                                         
[ 5998.559852] Call Trace:                                                      
[ 5998.559852]  [<ffffffff81046592>] worker_thread+0x131/0x1ca                  
[ 5998.559852]  [<ffffffff812e6239>] ? fc_timeout_deleted_rport+0x0/0x31e       
[ 5998.559852]  [<ffffffff8104a072>] ? autoremove_wake_function+0x0/0x38        
[ 5998.559852]  [<ffffffff81046461>] ? worker_thread+0x0/0x1ca                  
[ 5998.559852]  [<ffffffff81046461>] ? worker_thread+0x0/0x1ca                  
[ 5998.559852]  [<ffffffff81049c92>] kthread+0x56/0x83                          
[ 5998.559852]  [<ffffffff8100caba>] child_rip+0xa/0x20                         
[ 5998.559852]  [<ffffffff81049c3c>] ? kthread+0x0/0x83                         
[ 5998.559852]  [<ffffffff8100cab0>] ? child_rip+0x0/0x20                       
[ 5998.559852] Code: e0 fb 83 c8 08 41 88 85 a8 fe ff ff 49 8b 7f 58 48 8b 75
c8 e8 5b dd 22 00 4c 89 f7 e8 f6 ed ff ff 41 83 bd 88 fe ff ff 01 74 04 <0f> 0b
eb fe 41 8b 84 24 d0 02 00 00 83 f8 01 74 0c 83 f8 02 74                        
[ 5998.559852] RIP  [<ffffffff812e64c5>] fc_timeout_deleted_rport+0x28c/0x31e   
[ 5998.559852]  RSP <ffff880197c69e50>                                          
[ 6001.459233] ---[ end trace 024add554f5ef48f ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
