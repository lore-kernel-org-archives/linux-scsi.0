From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13873] QLA2xxx driver causes kernel oops with a qla2200
Date: Thu, 11 Feb 2010 11:19:09 GMT
Message-ID: <201002111119.o1BBJ9RV027698@demeter.kernel.org>
References: <bug-13873-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44714 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab0BKLTK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2010 06:19:10 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1BBJ9p1027699
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2010 11:19:09 GMT
In-Reply-To: <bug-13873-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13873


Le Gall <r1.legall@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |r1.legall@gmail.com




--- Comment #5 from Le Gall <r1.legall@gmail.com>  2010-02-11 11:18:18 ---
Append here with 2.6.26:

[  243.237356] sd 1:0:0:1: Attached scsi generic sg7 type 0                     
[  243.237434] scsi 1:0:0:0: Unexpected response from lun 31 while scanning,
scan aborted                                                                    
[  243.237356] BUG: unable to handle kernel NULL pointer dereference at
0000000000000028                                                                
[  243.237356] IP: [<ffffffff802e2722>] sysfs_find_dirent+0x9/0x2f              
[  243.237356] PGD 41f17e067 PUD 41f17f067 PMD 0                                
[  243.237357] Oops: 0000 [1] SMP                                               
[  243.237357] CPU 5                                                            
[  243.237357] Modules linked in: ipv6 dm_round_robin dm_multipath dm_mod loop
snd_pcm snd_timer snd soundcore snd_page_alloc serio_raw joydev shpchp evdev
pcspkr psmouse rng_core pci_hotplug button dcdbas ext3 jbd mbcache sg sr_mod
cdrom ide_pci_generic ide_core usb_storage usbhid hid ff_memless ata_piix ses
sd_mod enclosure ata_generic libata dock ehci_hcd uhci_hcd bnx2 qla2xxx
firmware_class scsi_transport_fc scsi_tgt megaraid_sas scsi_mod thermal
processor fan thermal_sys [last unloaded: scsi_wait_scan]                       
[  243.237357] Pid: 1782, comm: fc_wq_1 Not tainted 2.6.26-2-amd64 #1           
[  243.237357] RIP: 0010:[<ffffffff802e2722>]  [<ffffffff802e2722>]
sysfs_find_dirent+0x9/0x2f                                                      
[  243.237357] RSP: 0018:ffff81043987fd30  EFLAGS: 00010286                     
[  243.237357] RAX: 0000000000000000 RBX: ffffffff804ae609 RCX:
ffff81043e54b002                                                                
[  243.237357] RDX: 0000000000000000 RSI: ffffffff804ae609 RDI:
0000000000000000                                                                
[  243.237357] RBP: ffffffff804ae609 R08: ffff81043987e000 R09:
ffffffff8021a826                                                                
[  243.237357] R10: ffff81043b127000 R11: 0000000000000000 R12:
0000000000000000                                                                
[  243.237357] R13: ffff81043b127448 R14: ffffffff805a64c0 R15:
0000000000000000                                                                
[  243.237357] FS:  0000000000000000(0000) GS:ffff81043e53f6c0(0000)
knlGS:0000000000000000                                                          
[  243.237357] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b                
[  243.237357] CR2: 0000000000000028 CR3: 000000041f17d000 CR4:
00000000000006e0                                                                
[  243.237357] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000                                                                
[  243.237357] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400                                                                
[  243.237357] Process fc_wq_1 (pid: 1782, threadinfo ffff81043987e000, task
ffff81043a61ef60)                                                               
[  243.237357] Stack:  ffff81043b9540b8 ffffffff804ae609 0000000000000000
ffffffff802e31b9                                                                
[  243.237357]  000000053b127120 ffff81043b127358 ffffffff8051c660
ffffffff802e3a8a                                                                
[  243.237357]  0000000000000000 ffff81043b127358 ffff81043b127120
ffff81043b127120                                                                
[  243.237357] Call Trace:                                                      
[  243.237357]  [<ffffffff802e31b9>] ? sysfs_get_dirent+0x24/0x59               
[  243.237357]  [<ffffffff802e3a8a>] ? sysfs_remove_group+0x24/0xc2             
[  243.237357]  [<ffffffff80388133>] ? device_pm_remove+0x18/0x49               
[  243.237357]  [<ffffffff80383628>] ? device_del+0x13/0x15d                    
[  243.237357]  [<ffffffff8038377b>] ? device_unregister+0x9/0x12               
[  243.237357]  [<ffffffffa0026d56>] ? :scsi_mod:__scsi_remove_device+0x33/0x83 
[  243.237357]  [<ffffffffa0026dc7>] ? :scsi_mod:scsi_remove_device+0x21/0x2e   
[  243.237357]  [<ffffffffa0026e59>] ? :scsi_mod:__scsi_remove_target+0x85/0xc3 
[  243.237357]  [<ffffffffa0026ede>] ? :scsi_mod:__remove_child+0x0/0x1a        
[  243.237357]  [<ffffffffa0026ef4>] ? :scsi_mod:__remove_child+0x16/0x1a       
[  243.237357]  [<ffffffff80383064>] ? device_for_each_child+0x22/0x4d          
[  243.237357]  [<ffffffffa0026ed2>] ? :scsi_mod:scsi_remove_target+0x3b/0x47   
[  243.237357]  [<ffffffffa00597dd>] ?
:scsi_transport_fc:fc_starget_delete+0x0/0x64                                   
[  243.237357]  [<ffffffff8024314c>] ? run_workqueue+0x82/0x111
[  243.237357]  [<ffffffff80243a19>] ? worker_thread+0xd5/0xe0
[  243.237357]  [<ffffffff8024624d>] ? autoremove_wake_function+0x0/0x2e
[  243.237357]  [<ffffffff80243944>] ? worker_thread+0x0/0xe0
[  243.237357]  [<ffffffff80246127>] ? kthread+0x47/0x74
[  243.237357]  [<ffffffff802301c9>] ? schedule_tail+0x27/0x5c
[  243.237357]  [<ffffffff8020cf28>] ? child_rip+0xa/0x12
[  243.237357]  [<ffffffff8021a826>] ? lapic_next_event+0xf/0x13
[  243.237357]  [<ffffffff802460e0>] ? kthread+0x0/0x74
[  243.237357]  [<ffffffff8020cf1e>] ? child_rip+0x0/0x12
[  243.237357]
[  243.237357]
[  243.237357] Code: 0f 0b eb fe 48 8b 48 38 48 39 4f 38 72 0c 48 8d 50 10 48
8b 02 48 85 c0 75 ea 48 89 47 10 48 89 3a c3 55 48 89 f5 53 48 83 ec 08 <48> 8b
5f 28 eb 14 48 8b 7b 18 48 89 ee e8 56 bc 03 00 85 c0 74
[  243.237357] RIP  [<ffffffff802e2722>] sysfs_find_dirent+0x9/0x2f
[  243.237357]  RSP <ffff81043987fd30>
[  243.237357] CR2: 0000000000000028
[  243.582801] ---[ end trace bc59edd19c2b9a7e ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
