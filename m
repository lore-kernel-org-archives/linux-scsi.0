From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13873] New: QLA2xxx driver causes kernel oops with a qla2200
Date: Wed, 29 Jul 2009 23:27:01 GMT
Message-ID: <bug-13873-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46202 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbZG2X1B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2009 19:27:01 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6TNR1ZI022161
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2009 23:27:01 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13873

           Summary: QLA2xxx driver causes kernel oops with a qla2200
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.30
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: QLOGIC QLA2XXX
        AssignedTo: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
        ReportedBy: tageorgiou@gmail.com
                CC: tageorgiou@gmail.com
        Regression: No


Sometimes, the kernel oopses with the qla2xxx module loaded.  Sometimes it does
not do so for a while.  Here is a sample backtrace:

[ 2021.692201] sd 1:0:3:0: [sdf] Attached SCSI disk                             
[ 2032.157034]  rport-1:0-6: blocked FC remote port time out: removing target
and saving binding                
[ 2032.157413] ready                                                            
[ 2032.157456] BUG: unable to handle kernel <5>sd 1:0:4:0: [sdh] READ CAPACITY
failed                           
[ 2032.157481] sd 1:0:4:0: [sdh] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK                           
[ 2032.157491] sd 1:0:4:0: [sdh] Sense not available.                           
[ 2032.157514] sd 1:0:4:0: [sdh] Write Protect is off                           
[ 2032.157518] sd 1:0:4:0: [sdh] Mode Sense: 00 00 00 00                        
[ 2032.157532] sd 1:0:4:0: [sdh] Asking for cache data failed                   
[ 2032.157535] sd 1:0:4:0: [sdh] Assuming drive cache: write through            
[ 2032.157681] sd 1:0:4:0: [sdh] Attached SCSI disk                             
[ 2032.709189] NULL pointer dereference at 0000000000000010                     
[ 2032.709189] IP: [<ffffffff812b8dc2>] device_del+0x10/0x19e                   
[ 2032.709189] PGD 19850c067 PUD 198491067 PMD 0                                
[ 2032.709189] Oops: 0000 [#1] SMP                                              
[ 2032.709189] last sysfs file:
/sys/devices/pci0000:00/0000:00:06.0/0000:05:00.2/0000:0a:01.0/host1/rport-1:0-6/target1:0:4/fc_transport/target1:0:4/port_name 
[ 2032.709189] CPU 1                                                            
[ 2032.709189] Modules linked in: qla2xxx                                       
[ 2032.709189] Pid: 5759, comm: fc_wq_1 Not tainted 2.6.30-gentoo-r4dl380 #2
ProLiant DL380 G4                  
[ 2032.709189] RIP: 0010:[<ffffffff812b8dc2>]  [<ffffffff812b8dc2>]
device_del+0x10/0x19e                       
[ 2032.709189] RSP: 0018:ffff880196439c70  EFLAGS: 00010282                     
[ 2032.709189] RAX: ffffffff812ff00e RBX: 0000000000000010 RCX:
00000000ffffffff                                
[ 2032.709189] RDX: ffff880199f1b520 RSI: ffffffff812e47ed RDI:
0000000000000010                                
[ 2032.709189] RBP: ffff880196439c90 R08: 0000000000000000 R09:
000000000000261c                                
[ 2032.709189] R10: 0000000096439c90 R11: ffff88018a8a32e8 R12:
ffff880199f1b520                                
[ 2032.709189] R13: 0000000000000010 R14: 0000000000000000 R15:
ffff88019ada0e80                                
[ 2032.709189] FS:  0000000000000000(0000) GS:ffff88002804d000(0000)
knlGS:0000000000000000                     
[ 2032.709189] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b                
[ 2032.709189] CR2: 0000000000000010 CR3: 0000000190156000 CR4:
00000000000006e0                                
[ 2032.709189] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000                                
[ 2032.709189] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400                                
[ 2032.709189] Process fc_wq_1 (pid: 5759, threadinfo ffff880196438000, task
ffff88019ada0e80)                  
[ 2032.709189] Stack:                                                           
[ 2032.709189]  0000000000000000 0000000000000000 ffff880199f1b520
0000000000000010                             
[ 2032.709189]  ffff880196439cc0 ffffffff812ff031 0000000000000004
ffff880199f1b520                             
[ 2032.709189]  ffffffff818115a8 ffffffff8180ede0 ffff880196439ce0
ffffffff812e8222                             
[ 2032.709189] Call Trace:                                                      
[ 2032.709189]  [<ffffffff812ff031>] sd_remove+0x23/0x6e                        
[ 2032.709189]  [<ffffffff812e8222>] scsi_bus_remove+0x38/0x3f                  
[ 2032.709189]  [<ffffffff812baf48>] __device_release_driver+0x7a/0x9f          
[ 2032.709189]  [<ffffffff812bb02c>] device_release_driver+0x1e/0x2b            
[ 2032.709189]  [<ffffffff812ba633>] bus_remove_device+0x96/0xb4                
[ 2032.709189]  [<ffffffff812b8ee4>] device_del+0x132/0x19e                     
[ 2032.709189]  [<ffffffff812e84fb>] __scsi_remove_device+0x44/0x81             
[ 2032.709189]  [<ffffffff812e8559>] scsi_remove_device+0x21/0x2e               
[ 2032.709189]  [<ffffffff812e85ff>] __scsi_remove_target+0x87/0xc5             
[ 2032.709189]  [<ffffffff812e8685>] ? __remove_child+0x0/0x25                  
[ 2032.709189]  [<ffffffff812e86a3>] __remove_child+0x1e/0x25                   
[ 2032.709189]  [<ffffffff812e8685>] ? __remove_child+0x0/0x25                  
[ 2032.709189]  [<ffffffff812b8975>] device_for_each_child+0x38/0x6f            
[ 2032.709189]  [<ffffffff812e8678>] scsi_remove_target+0x3b/0x48               
[ 2032.709189]  [<ffffffff812efc3e>] fc_starget_delete+0x21/0x26                
[ 2032.709189]  [<ffffffff81047e86>] worker_thread+0x131/0x1ca                  
[ 2032.709189]  [<ffffffff812efc1d>] ? fc_starget_delete+0x0/0x26               
[ 2032.709189]  [<ffffffff8104b978>] ? autoremove_wake_function+0x0/0x38        
[ 2032.709189]  [<ffffffff81047d55>] ? worker_thread+0x0/0x1ca                  
[ 2032.709189]  [<ffffffff81047d55>] ? worker_thread+0x0/0x1ca                  
[ 2032.709189]  [<ffffffff8104b586>] kthread+0x56/0x83                          
[ 2032.709189]  [<ffffffff8100caba>] child_rip+0xa/0x20                         
[ 2032.709189]  [<ffffffff8104b530>] ? kthread+0x0/0x83                         
[ 2032.709189]  [<ffffffff8100cab0>] ? child_rip+0x0/0x20                       
[ 2032.709189] Code: 48 6b c0 28 49 8d 74 05 00 48 83 3e 00 75 df 5e 5b 41 5c
41 5d 41 5e 41 5f 5d c3 55 48 89 e5 41 55 41 54 53 48 83 ec 08 48 89 fb <4c> 8b
2f 48 8b 47 78 48 85 c0 74 18 48 8b 78 70 48 81 c7 c0 00          
[ 2032.709189] RIP  [<ffffffff812b8dc2>] device_del+0x10/0x19e                  
[ 2032.709189]  RSP <ffff880196439c70>                                          
[ 2032.709189] CR2: 0000000000000010                                            
[ 2032.709694] ---[ end trace d34a21a81741a1cf ]---                             
[ 2032.838964]  rport-0:0-5: blocked FC remote port time out: removing target
and saving binding                
[ 2032.839334] BUG: unable to handle kernel NULL pointer dereference at
0000000000000010                        
[ 2032.839338] IP: [<ffffffff812b8dc2>] device_del+0x10/0x19e                   
[ 2032.839345] PGD 190116067 PUD 19713f067 PMD 0                                
[ 2032.839349] Oops: 0000 [#2] SMP                                              
[ 2032.839352] last sysfs file:
/sys/devices/pci0000:00/0000:00:06.0/0000:05:00.2/0000:0a:01.0/host1/rport-1:0-5/target1:0:3/1:0:3:0/block/sdf/uevent 
[ 2032.839356] CPU 1                                                            
[ 2032.839357] Modules linked in: qla2xxx                                       
[ 2032.839362] Pid: 5718, comm: fc_wq_0 Tainted: G      D   
2.6.30-gentoo-r4dl380 #2 ProLiant DL380 G4         
[ 2032.839365] RIP: 0010:[<ffffffff812b8dc2>]  [<ffffffff812b8dc2>]
device_del+0x10/0x19e                       
[ 2032.839371] RSP: 0018:ffff8801971bdc70  EFLAGS: 00010282                     
[ 2032.839374] RAX: ffffffff812ff00e RBX: 0000000000000010 RCX:
00000000ffffffff                                
[ 2032.839377] RDX: ffff880199f1f520 RSI: ffffffff812e47ed RDI:
0000000000000010                                
[ 2032.839380] RBP: ffff8801971bdc90 R08: 0000000000000000 R09:
000000000000259c                                
[ 2032.839384] R10: 00000000971bdc90 R11: ffff88018a8a19d0 R12:
ffff880199f1f520                                
[ 2032.839387] R13: 0000000000000010 R14: 0000000000000000 R15:
ffff880198535e40                                
[ 2032.839390] FS:  0000000000000000(0000) GS:ffff88002804d000(0000)
knlGS:0000000000000000                     
[ 2032.839394] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b                
[ 2032.839397] CR2: 0000000000000010 CR3: 000000019713a000 CR4:
00000000000006e0                                
[ 2032.839400] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000                                
[ 2032.839404] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400                                
[ 2032.839407] Process fc_wq_0 (pid: 5718, threadinfo ffff8801971bc000, task
ffff880198535e40)                  
[ 2032.839410] Stack:                                                           
[ 2032.839411]  0000000000000000 0000000000000000 ffff880199f1f520
0000000000000010                             
[ 2032.839415]  ffff8801971bdcc0 ffffffff812ff031 0000000000000004
ffff880199f1f520                             
[ 2032.839419]  ffffffff818115a8 ffffffff8180ede0 ffff8801971bdce0
ffffffff812e8222                             
[ 2032.839424] Call Trace:                                                      
[ 2032.839426]  [<ffffffff812ff031>] sd_remove+0x23/0x6e                        
[ 2032.839432]  [<ffffffff812e8222>] scsi_bus_remove+0x38/0x3f                  
[ 2032.839438]  [<ffffffff812baf48>] __device_release_driver+0x7a/0x9f          
[ 2032.839442]  [<ffffffff812bb02c>] device_release_driver+0x1e/0x2b            
[ 2032.839446]  [<ffffffff812ba633>] bus_remove_device+0x96/0xb4                
[ 2032.839451]  [<ffffffff812b8ee4>] device_del+0x132/0x19e                     
[ 2032.839455]  [<ffffffff812e84fb>] __scsi_remove_device+0x44/0x81             
[ 2032.839460]  [<ffffffff812e8559>] scsi_remove_device+0x21/0x2e               
[ 2032.839464]  [<ffffffff812e85ff>] __scsi_remove_target+0x87/0xc5             
[ 2032.839469]  [<ffffffff812e8685>] ? __remove_child+0x0/0x25                  
[ 2032.839473]  [<ffffffff812e86a3>] __remove_child+0x1e/0x25                   
[ 2032.839477]  [<ffffffff812e8685>] ? __remove_child+0x0/0x25                  
[ 2032.839481]  [<ffffffff812b8975>] device_for_each_child+0x38/0x6f            
[ 2032.839486]  [<ffffffff812e8678>] scsi_remove_target+0x3b/0x48               
[ 2032.839490]  [<ffffffff812efc3e>] fc_starget_delete+0x21/0x26                
[ 2032.839495]  [<ffffffff81047e86>] worker_thread+0x131/0x1ca                  
[ 2032.839499]  [<ffffffff812efc1d>] ? fc_starget_delete+0x0/0x26               
[ 2032.839504]  [<ffffffff8104b978>] ? autoremove_wake_function+0x0/0x38        
[ 2032.839508]  [<ffffffff81047d55>] ? worker_thread+0x0/0x1ca                  
[ 2032.839512]  [<ffffffff81047d55>] ? worker_thread+0x0/0x1ca                  
[ 2032.839516]  [<ffffffff8104b586>] kthread+0x56/0x83                          
[ 2032.839520]  [<ffffffff8100caba>] child_rip+0xa/0x20                         
[ 2032.839524]  [<ffffffff8104b530>] ? kthread+0x0/0x83                         
[ 2032.839528]  [<ffffffff8100cab0>] ? child_rip+0x0/0x20                       
[ 2032.839532] Code: 48 6b c0 28 49 8d 74 05 00 48 83 3e 00 75 df 5e 5b 41 5c
41 5d 41 5e 41 5f 5d c3 55 48 89 e5 41 55 41 54 53 48 83 ec 08 48 89 fb <4c> 8b
2f 48 8b 47 78 48 85 c0 74 18 48 8b 78 70 48 81 c7 c0 00          
[ 2032.839562] RIP  [<ffffffff812b8dc2>] device_del+0x10/0x19e                  
[ 2032.839567]  RSP <ffff8801971bdc70>                                          
[ 2032.839569] CR2: 0000000000000010                                            
[ 2032.839572] ---[ end trace d34a21a81741a1d0 ]---                             
[ 2032.839594] ready                                                            
[ 2032.839645] sd 0:0:4:0: [sdg] READ CAPACITY failed                           
[ 2032.839648] sd 0:0:4:0: [sdg] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK                           
[ 2032.839653] sd 0:0:4:0: [sdg] Sense not available.                           
[ 2032.839669] sd 0:0:4:0: [sdg] Write Protect is off                           
[ 2032.839673] sd 0:0:4:0: [sdg] Mode Sense: 00 00 00 00                        
[ 2032.839687] sd 0:0:4:0: [sdg] Asking for cache data failed                   
[ 2032.839690] sd 0:0:4:0: [sdg] Assuming drive cache: write through            
[ 2032.839827] sd 0:0:4:0: [sdg] Attached SCSI disk                             
[ 2056.852015]  rport-0:0-0: blocked FC remote port time out: removing target
and saving binding                
[ 2056.852023]  rport-1:0-0: blocked FC remote port time out: removing target
and saving binding                
[ 2057.056821]  rport-1:0-3: blocked FC remote port time out: removing target
and saving binding                
[ 2057.159438]  rport-1:0-5: blocked FC remote port time out: removing target
and saving binding                
[ 2057.159610]  rport-0:0-2: blocked FC remote port time out: removing target
and saving binding                
[ 2057.159647]  rport-0:0-4: blocked FC remote port time out: removing target
and saving binding                
[ 2151.332237] sd 0:0:0:0: [sda] Unhandled error code                           
[ 2151.389721] sd 0:0:0:0: [sda] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK                           
[ 2151.424245] end_request: I/O error, dev sda, sector 0                        
[ 2151.427138] sd 1:0:0:0: [sdb] Unhandled error code                           
[ 2151.427140] sd 1:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
