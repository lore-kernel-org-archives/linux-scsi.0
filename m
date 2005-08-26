From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: regression w/ qla2300 - oopses..
Date: Sat, 27 Aug 2005 00:29:34 +0300
Message-ID: <20050826212934.GO22165@mea-ext.zmailer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from van-1-67.lab.dnainternet.fi ([62.78.96.67]:65226 "EHLO
	mail.zmailer.org") by vger.kernel.org with ESMTP id S965172AbVHZV3f
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 17:29:35 -0400
Received: (mea@mea-ext) by mail.zmailer.org id S1609960AbVHZV3e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Aug 2005 00:29:34 +0300
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Well, not in normal operation, but when I do "rmmod qla2300",
I do get most impressive oops backtrace.  (With Amd64 machine.)

This oops does happen with lattest Fedora Core Development kernel
(as of yesterday) which is up to Linus  2.6.13-rc7.

This crash didn't happen with   vmlinuz-2.6.11-1.1226_FC4  from
past April, but it did happen with a week old 2.6.13 FC5 snapshot.
(I have been jumping back and forth in between them.)

The reason for that rmmod ?   I had to somehow get the card/driver to
do whole re-init and to scan what LUNS are available in the SAN, while
I was debugging my playround, and I just didn't like to do whole
machine reboots...

   /Matti Aarnio


Aug 26 10:40:14 sisakko kernel: Synchronizing SCSI cache for disk sda: 
Aug 26 10:40:14 sisakko kernel: Synchronizing SCSI cache for disk sdb: 
Aug 26 10:40:14 sisakko kernel: general protection fault: 0000 [1] SMP 
Aug 26 10:40:14 sisakko kernel: CPU 0 
Aug 26 10:40:14 sisakko kernel: Modules linked in: lp w83627hf i2c_sensor i2c_isa sunrpc ipv6 ipt_conntrack ip_conntrack_ftp ipt_REJECT ipt_state ip_conntrack iptable_filter ip_tables xfs exportfs dm_mod video button battery ac uhci_hcd ehci_hcd sata_via libata parport_pc parport shpchp i2c_viapro i2c_core snd_via82xx gameport snd_ac97_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device snd soundcore e100 mii skge floppy ext3 jbd raid1 qla2300 qla2xxx scsi_transport_fc sd_mod scsi_mod
Aug 26 10:40:14 sisakko kernel: Pid: 19819, comm: rmmod Not tainted 2.6.12-1.1509_FC5
Aug 26 10:40:14 sisakko kernel: RIP: 0010:[<ffffffff8020034b>] <ffffffff8020034b>{kref_get+4}
Aug 26 10:40:14 sisakko kernel: RSP: 0018:ffff810031459d28  EFLAGS: 00010203
Aug 26 10:40:14 sisakko kernel: RAX: ffff81003f5d35d0 RBX: 6b6b6b6b6b6b6b7b RCX: 0000000000000000
Aug 26 10:40:14 sisakko kernel: RDX: 0000000000000007 RSI: ffffffff8034b06d RDI: 6b6b6b6b6b6b6b7b
Aug 26 10:40:14 sisakko kernel: RBP: ffff810031459d58 R08: 0000000000000000 R09: ffff81003f5d3160
Aug 26 10:40:14 sisakko kernel: R10: 0000000000000000 R11: ffffffff88009ed6 R12: 6b6b6b6b6b6b6b63
Aug 26 10:40:14 sisakko kernel: R13: 0000000000000000 R14: ffffffff88060a78 R15: ffffffff88060a80
Aug 26 10:40:14 sisakko kernel: FS:  00002aaaaadfe6d0(0000) GS:ffffffff80529800(0000) knlGS:00000000f7ea2ba0
Aug 26 10:40:14 sisakko kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 26 10:40:14 sisakko kernel: CR2: 0000555555661200 CR3: 0000000034e55000 CR4: 00000000000006e0
Aug 26 10:40:14 sisakko kernel: Process rmmod (pid: 19819, threadinfo ffff810031458000, task ffff8100330ca030)
Aug 26 10:40:14 sisakko kernel: Stack: 6b6b6b6b6b6b6b6b ffffffff8034b1c4 0000000000000000 ffff81003f5d35c8 
Aug 26 10:40:14 sisakko kernel:        ffffffff8800b631 ffffffff8026bae1 ffff81003f5d35c8 ffff81003f5d35d0 
Aug 26 10:40:14 sisakko kernel:        ffff81003f5d31a0 ffff81003f5d35c8 
Aug 26 10:40:14 sisakko kernel: Call Trace:<ffffffff8034b1c4>{klist_next+69} <ffffffff8800b631>{:scsi_mod:__remove_child+0}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8026bae1>{device_for_each_child+44} <ffffffff8800b688>{:scsi_mod:scsi_remove_target+61}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8803498b>{:scsi_transport_fc:fc_rport_terminate+63}
Aug 26 10:40:14 sisakko kernel:        <ffffffff88034a51>{:scsi_transport_fc:fc_remove_host+52}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8803f0cf>{:qla2xxx:qla2x00_remove_one+34} <ffffffff8020c5b6>{pci_device_remove+36}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8026cc85>{__device_release_driver+93} <ffffffff8026cd3c>{driver_detach+155}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8026c9a9>{bus_remove_driver+122} <ffffffff8026d1a4>{driver_unregister+9}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8020c4b2>{pci_unregister_driver+16} <ffffffff80151799>{sys_delete_module+478}
Aug 26 10:40:14 sisakko kernel:        <ffffffff801107e5>{syscall_trace_enter+217} <ffffffff8010dafe>{tracesys+209}
Aug 26 10:40:14 sisakko kernel: 
Aug 26 10:40:14 sisakko kernel: Code: 8b 07 85 c0 75 2e e8 d5 4b f3 ff 49 89 c0 b9 20 00 00 00 48 
Aug 26 10:40:14 sisakko kernel: RIP <ffffffff8020034b>{kref_get+4} RSP <ffff810031459d28>
Aug 26 10:40:14 sisakko kernel:  <3>Debug: sleeping function called from invalid context at include/linux/rwsem.h:43
Aug 26 10:40:14 sisakko kernel: in_atomic():0, irqs_disabled():1
Aug 26 10:40:14 sisakko kernel: 
Aug 26 10:40:14 sisakko kernel: Call Trace:<ffffffff8013682a>{profile_task_exit+21} <ffffffff801379fd>{do_exit+34}
Aug 26 10:40:14 sisakko kernel:        <ffffffff80214089>{vgacon_cursor+216} <ffffffff8010f4a5>{default_do_nmi+0}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8010f8f5>{do_general_protection+257} <ffffffff8010e4b9>{error_exit+0}
Aug 26 10:40:14 sisakko kernel:        <ffffffff88009ed6>{:scsi_mod:scsi_target_dev_release+0}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8034b06d>{klist_release+0} <ffffffff8020034b>{kref_get+4}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8034b1c4>{klist_next+69} <ffffffff8800b631>{:scsi_mod:__remove_child+0}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8026bae1>{device_for_each_child+44} <ffffffff8800b688>{:scsi_mod:scsi_remove_target+61}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8803498b>{:scsi_transport_fc:fc_rport_terminate+63}
Aug 26 10:40:14 sisakko kernel:        <ffffffff88034a51>{:scsi_transport_fc:fc_remove_host+52}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8803f0cf>{:qla2xxx:qla2x00_remove_one+34} <ffffffff8020c5b6>{pci_device_remove+36}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8026cc85>{__device_release_driver+93} <ffffffff8026cd3c>{driver_detach+155}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8026c9a9>{bus_remove_driver+122} <ffffffff8026d1a4>{driver_unregister+9}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8020c4b2>{pci_unregister_driver+16} <ffffffff80151799>{sys_delete_module+478}
Aug 26 10:40:14 sisakko kernel:        <ffffffff801107e5>{syscall_trace_enter+217} <ffffffff8010dafe>{tracesys+209}
Aug 26 10:40:14 sisakko kernel:        
Aug 26 10:40:14 sisakko kernel: Slab corruption: (Not tainted) start=ffff81003f5d3160, len=1024
Aug 26 10:40:14 sisakko kernel: Redzone: 0x5a2cf071/0x5a2cf071.
Aug 26 10:40:14 sisakko kernel: Last user: [<ffffffff88009f29>](scsi_target_dev_release+0x53/0x63 [scsi_mod])
Aug 26 10:40:14 sisakko kernel: 
Aug 26 10:40:14 sisakko kernel: Call Trace:<ffffffff80168b5e>{check_poison_obj+141} <ffffffff802e7000>{alloc_skb+67}
Aug 26 10:40:14 sisakko kernel:        <ffffffff80168d3d>{cache_alloc_debugcheck_after+55}
Aug 26 10:40:14 sisakko kernel:        <ffffffff802e7000>{alloc_skb+67} <ffffffff802e5709>{sock_alloc_send_skb+97}
Aug 26 10:40:14 sisakko kernel:        <ffffffff8034713e>{unix_dgram_sendmsg+374} <ffffffff8019d61c>{__d_lookup+250}
Aug 26 10:40:14 sisakko kernel:        <ffffffff802e3b5d>{sock_sendmsg+257} <ffffffff801e488e>{avc_has_perm+70}
Aug 26 10:40:14 sisakko kernel:        <ffffffff801e488e>{avc_has_perm+70} <ffffffff8016041d>{find_get_page+75}
Aug 26 10:40:15 sisakko kernel:        <ffffffff8014a5b0>{autoremove_wake_function+0} <ffffffff80202e8c>{vsnprintf+1487}
Aug 26 10:40:15 sisakko kernel:        <ffffffff80171f01>{unmap_vmas+1253} <ffffffff80167ad9>{poison_obj+49}
Aug 26 10:40:15 sisakko kernel:        <ffffffff8015d560>{audit_sockaddr+51} <ffffffff801678ee>{dbg_redzone1+32}
Aug 26 10:40:15 sisakko kernel:        <ffffffff8015d560>{audit_sockaddr+51} <ffffffff80168e15>{cache_alloc_debugcheck_after+271}
Aug 26 10:40:15 sisakko kernel:        <ffffffff8015d580>{audit_sockaddr+83} <ffffffff802e3ee7>{sys_sendto+235}
Aug 26 10:40:15 sisakko kernel:        <ffffffff80168e15>{cache_alloc_debugcheck_after+271}
Aug 26 10:40:15 sisakko kernel:        <ffffffff8015dfdd>{audit_syscall_entry+313} <ffffffff8010dafe>{tracesys+209}
Aug 26 10:40:15 sisakko kernel:        
Aug 26 10:40:15 sisakko kernel: 050: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b
Aug 26 10:40:15 sisakko kernel: Single bit error detected. Possibly bad RAM. Run memtest86.
Aug 26 10:40:15 sisakko kernel: Prev obj: start=ffff81003f5d2d48, len=1024
Aug 26 10:40:15 sisakko kernel: Redzone: 0x170fc2a5/0x170fc2a5.
Aug 26 10:40:15 sisakko kernel: Last user: [<ffffffff8027c334>](cfq_init_queue+0x1b/0x2ba)
Aug 26 10:40:15 sisakko kernel: 000: 1f 00 00 00 00 00 00 00 a0 69 df 3f 00 81 ff ff
Aug 26 10:40:15 sisakko kernel: 010: 58 2d 5d 3f 00 81 ff ff 58 2d 5d 3f 00 81 ff ff
Aug 26 10:40:15 sisakko kernel: Next obj: start=ffff81003f5d3578, len=1024
Aug 26 10:40:15 sisakko kernel: Redzone: 0x170fc2a5/0x170fc2a5.
Aug 26 10:40:15 sisakko kernel: Last user: [<ffffffff880337a0>](fc_rport_create+0x44/0x30f [scsi_transport_fc])
Aug 26 10:40:15 sisakko kernel: 000: ff ff ff ff 00 00 00 00 23 00 00 00 00 00 00 00
Aug 26 10:40:15 sisakko kernel: 010: 86 09 e0 02 04 00 00 10 86 09 e1 02 04 00 00 20
