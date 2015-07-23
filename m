From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101891] mvsas prep failed, NULL pointer dereference in
 mvs_slot_task_free+0x5/0x1f0 [mvsas]
Date: Thu, 23 Jul 2015 22:01:55 +0000
Message-ID: <bug-101891-11613-9Ezq1vb8ml@https.bugzilla.kernel.org/>
References: <bug-101891-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44029 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbbGWWCC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2015 18:02:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6CF0D2054E
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2015 22:01:59 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8654720641
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2015 22:01:55 +0000 (UTC)
In-Reply-To: <bug-101891-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D101891

--- Comment #1 from D=C4=81vis <davispuh@gmail.com> ---
Some more call traces


------------[ cut here ]------------
kernel: WARNING: CPU: 4 PID: 6442 at fs/sysfs/group.c:224
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff8189de80 not found for kobject 'end_device-=
8:0'
kernel: Modules linked in: fuse nf_conntrack_netbios_ns nf_conntrack_br=
oadcast
xt_tcpudp ip6t_rpfilter
kernel:  aesni_intel rc_core snd_hda_codec_realtek aes_x86_64 lrw gf128=
mul
videobuf2_dma_sg glue_helper
kernel: CPU: 4 PID: 6442 Comm: kworker/u16:12 Tainted: P  R   D    O  =20
4.1.2-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_8 sas_destruct_devices [libsas]
kernel:  0000000000000000 00000000fff093ac ffff88008071bbf8 ffffffff815=
85c8e
kernel:  0000000000000000 ffff88008071bc50 ffff88008071bc38 ffffffff810=
78c9a
kernel:  ffff88008071bc68 0000000000000000 ffffffff8189de80 ffff8802225=
50810
kernel: Call Trace:
kernel:  [<ffffffff81585c8e>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81078c9a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81078d25>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff81258b9c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff8125c351>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813fc4c7>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813ef828>] device_del+0x58/0x270
kernel:  [<ffffffff813ef2f7>] ? put_device+0x17/0x20
kernel:  [<ffffffff813efa62>] device_unregister+0x22/0x80
kernel:  [<ffffffff812b5a00>] bsg_unregister_queue+0x60/0xc0
kernel:  [<ffffffffa003a7dc>] sas_rphy_remove+0x4c/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa003a826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa0114a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8109193b>] process_one_work+0x14b/0x470
kernel:  [<ffffffff81091ca8>] worker_thread+0x48/0x4c0
kernel:  [<ffffffff81091c60>] ? process_one_work+0x470/0x470
kernel:  [<ffffffff810977f8>] kthread+0xd8/0xf0
kernel:  [<ffffffff81097720>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8158b962>] ret_from_fork+0x42/0x70
kernel:  [<ffffffff81097720>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 18b7a6f928680375 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 4 PID: 6442 at fs/sysfs/group.c:224
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff8189de80 not found for kobject 'end_device-=
8:1'
kernel: Modules linked in: fuse nf_conntrack_netbios_ns nf_conntrack_br=
oadcast
xt_tcpudp ip6t_rpfilter ip
kernel:  aesni_intel rc_core snd_hda_codec_realtek aes_x86_64 lrw gf128=
mul
videobuf2_dma_sg glue_helper a
kernel: CPU: 4 PID: 6442 Comm: kworker/u16:12 Tainted: P  R   D W  O  =20
4.1.2-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_8 sas_destruct_devices [libsas]
kernel:  0000000000000000 00000000fff093ac ffff88008071bc38 ffffffff815=
85c8e
kernel:  0000000000000000 ffff88008071bc90 ffff88008071bc78 ffffffff810=
78c9a
kernel:  ffff88008071bc78 0000000000000000 ffffffff8189de80 ffff8802225=
4c810
kernel: Call Trace:
kernel:  [<ffffffff81585c8e>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81078c9a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81078d25>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff81258b9c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff8125c351>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813fc4c7>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813ef828>] device_del+0x58/0x270
kernel:  [<ffffffffa003a7ec>] sas_rphy_remove+0x5c/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa003a826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa0114a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8109193b>] process_one_work+0x14b/0x470
kernel:  [<ffffffff81091ca8>] worker_thread+0x48/0x4c0
kernel:  [<ffffffff81091c60>] ? process_one_work+0x470/0x470
kernel:  [<ffffffff810977f8>] kthread+0xd8/0xf0
kernel:  [<ffffffff81097720>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8158b962>] ret_from_fork+0x42/0x70
kernel:  [<ffffffff81097720>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 18b7a6f92868037c ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 4 PID: 6442 at fs/sysfs/group.c:224
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff8189de80 not found for kobject 'end_device-=
8:2'
kernel: Modules linked in: fuse nf_conntrack_netbios_ns nf_conntrack_br=
oadcast
xt_tcpudp ip6t_rpfilter ip
kernel:  aesni_intel rc_core snd_hda_codec_realtek aes_x86_64 lrw gf128=
mul
videobuf2_dma_sg glue_helper a
kernel: CPU: 4 PID: 6442 Comm: kworker/u16:12 Tainted: P  R   D W  O  =20
4.1.2-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_8 sas_destruct_devices [libsas]
kernel:  0000000000000000 00000000fff093ac ffff88008071bb88 ffffffff815=
85c8e
kernel:  0000000000000000 ffff88008071bbe0 ffff88008071bbc8 ffffffff810=
78c9a
kernel:  ffff88008071bbc8 0000000000000000 ffffffff8189de80 ffff8802225=
4d838
kernel: Call Trace:
kernel:  [<ffffffff81585c8e>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81078c9a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81078d25>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff81258b9c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff8125c351>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813fc4c7>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813ef828>] device_del+0x58/0x270
kernel:  [<ffffffff813eed79>] ? device_remove_file+0x19/0x20
kernel:  [<ffffffff813f920e>] attribute_container_class_device_del+0x1e=
/0x30
kernel:  [<ffffffff813f9422>] transport_remove_classdev+0x52/0x60
kernel:  [<ffffffff813f93d0>] ? transport_add_class_device+0x40/0x40
kernel:  [<ffffffff813f8d7c>] attribute_container_device_trigger+0xdc/0=
xf0
kernel:  [<ffffffff813f9385>] transport_remove_device+0x15/0x20
kernel:  [<ffffffffa003a7e4>] sas_rphy_remove+0x54/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa003a826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa0114a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8109193b>] process_one_work+0x14b/0x470
kernel:  [<ffffffff81091ca8>] worker_thread+0x48/0x4c0
kernel:  [<ffffffff81091c60>] ? process_one_work+0x470/0x470
kernel:  [<ffffffff810977f8>] kthread+0xd8/0xf0
kernel:  [<ffffffff81097720>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8158b962>] ret_from_fork+0x42/0x70
kernel:  [<ffffffff81097720>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 18b7a6f92868037e ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 4 PID: 6442 at fs/sysfs/group.c:224
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff8189de80 not found for kobject 'end_device-=
8:2'
kernel: Modules linked in: fuse nf_conntrack_netbios_ns nf_conntrack_br=
oadcast
xt_tcpudp ip6t_rpfilter ip
kernel:  aesni_intel rc_core snd_hda_codec_realtek aes_x86_64 lrw gf128=
mul
videobuf2_dma_sg glue_helper a
kernel: CPU: 4 PID: 6442 Comm: kworker/u16:12 Tainted: P  R   D W  O  =20
4.1.2-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_8 sas_destruct_devices [libsas]
kernel:  0000000000000000 00000000fff093ac ffff88008071bb88 ffffffff815=
85c8e
kernel:  0000000000000000 ffff88008071bbe0 ffff88008071bbc8 ffffffff810=
78c9a
kernel:  ffff88008071bbc8 0000000000000000 ffffffff8189de80 ffff8802225=
4dc38
kernel: Call Trace:
kernel:  [<ffffffff81585c8e>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81078c9a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81078d25>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff81258b9c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff8125c351>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813fc4c7>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813ef828>] device_del+0x58/0x270
kernel:  [<ffffffff813eed79>] ? device_remove_file+0x19/0x20
kernel:  [<ffffffff813f920e>] attribute_container_class_device_del+0x1e=
/0x30
kernel:  [<ffffffff813f9422>] transport_remove_classdev+0x52/0x60
kernel:  [<ffffffff813f93d0>] ? transport_add_class_device+0x40/0x40
kernel:  [<ffffffff813f8d7c>] attribute_container_device_trigger+0xdc/0=
xf0
kernel:  [<ffffffff813f9385>] transport_remove_device+0x15/0x20
kernel:  [<ffffffffa003a7e4>] sas_rphy_remove+0x54/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa003a826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa0114a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8109193b>] process_one_work+0x14b/0x470
kernel:  [<ffffffff81091ca8>] worker_thread+0x48/0x4c0
kernel:  [<ffffffff81091c60>] ? process_one_work+0x470/0x470
kernel:  [<ffffffff810977f8>] kthread+0xd8/0xf0
kernel:  [<ffffffff81097720>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8158b962>] ret_from_fork+0x42/0x70
kernel:  [<ffffffff81097720>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 18b7a6f92868037f ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 0 PID: 5845 at fs/sysfs/group.c:224
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff8189de80 not found for kobject '8:0:0:0'
kernel: Modules linked in: fuse nf_conntrack_netbios_ns nf_conntrack_br=
oadcast
xt_tcpudp ip6t_rpfilter ip
kernel:  aesni_intel rc_core snd_hda_codec_realtek aes_x86_64 lrw gf128=
mul
videobuf2_dma_sg glue_helper a
kernel: CPU: 0 PID: 5845 Comm: rmmod Tainted: P  R   D W  O    4.1.2-2-=
ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel:  0000000000000000 0000000015da1c4c ffff880100a9bbb8 ffffffff815=
85c8e
kernel:  0000000000000000 ffff880100a9bc10 ffff880100a9bbf8 ffffffff810=
78c9a
kernel:  ffff880100a9bbf8 0000000000000000 ffffffff8189de80 ffff8802224=
b5810
kernel: Call Trace:
kernel:  [<ffffffff81585c8e>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81078c9a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81078d25>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff81258b9c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff8125c351>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813fc4c7>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813ef828>] device_del+0x58/0x270
kernel:  [<ffffffff813efa62>] device_unregister+0x22/0x80
kernel:  [<ffffffff812b5a00>] bsg_unregister_queue+0x60/0xc0
kernel:  [<ffffffffa008c501>] __scsi_remove_device+0xb1/0xe0 [scsi_mod]
kernel:  [<ffffffffa008a964>] scsi_forget_host+0x64/0x70 [scsi_mod]
kernel:  [<ffffffffa007f4e9>] scsi_remove_host+0x79/0x160 [scsi_mod]
kernel:  [<ffffffffa020c5fe>] mvs_pci_remove+0x4e/0xe0 [mvsas]
kernel:  [<ffffffff81311e2f>] pci_device_remove+0x3f/0xc0
kernel:  [<ffffffff813f3d87>] __device_release_driver+0x87/0x120
kernel:  [<ffffffff813f4898>] driver_detach+0xc8/0xd0
kernel:  [<ffffffff813f39e9>] bus_remove_driver+0x59/0xe0
kernel:  [<ffffffff813f5130>] driver_unregister+0x30/0x70
kernel:  [<ffffffff8131179d>] pci_unregister_driver+0x2d/0xa0
kernel:  [<ffffffffa0215969>] mvs_exit+0x10/0x6a7 [mvsas]
kernel:  [<ffffffff811006df>] SyS_delete_module+0x1cf/0x280
kernel:  [<ffffffff8158b56e>] system_call_fastpath+0x12/0x71
kernel: ---[ end trace 18b7a6f928680389 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 0 PID: 5845 at fs/sysfs/group.c:224
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff8189de80 not found for kobject '8:0:0:0'
kernel: Modules linked in: fuse nf_conntrack_netbios_ns nf_conntrack_br=
oadcast
xt_tcpudp ip6t_rpfilter ip
kernel:  aesni_intel rc_core snd_hda_codec_realtek aes_x86_64 lrw gf128=
mul
videobuf2_dma_sg glue_helper a
kernel: CPU: 0 PID: 5845 Comm: rmmod Tainted: P  R   D W  O    4.1.2-2-=
ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel:  0000000000000000 0000000015da1c4c ffff880100a9bb08 ffffffff815=
85c8e
kernel:  0000000000000000 ffff880100a9bb60 ffff880100a9bb48 ffffffff810=
78c9a
kernel:  ffff880100a9bb48 0000000000000000 ffffffff8189de80 ffff8802224=
b4820
kernel: Call Trace:
kernel:  [<ffffffff81585c8e>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81078c9a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81078d25>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff81258b9c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff8125c351>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813fc4c7>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813ef828>] device_del+0x58/0x270
kernel:  [<ffffffffa0008ba5>] sd_remove+0x55/0xc0 [sd_mod]
kernel:  [<ffffffff813f3d87>] __device_release_driver+0x87/0x120
kernel:  [<ffffffff813f3e43>] device_release_driver+0x23/0x30
kernel:  [<ffffffff813f36c8>] bus_remove_device+0x108/0x180
kernel:  [<ffffffff813ef911>] device_del+0x141/0x270
kernel:  [<ffffffffa008c51d>] __scsi_remove_device+0xcd/0xe0 [scsi_mod]
kernel:  [<ffffffffa008a964>] scsi_forget_host+0x64/0x70 [scsi_mod]
kernel:  [<ffffffffa007f4e9>] scsi_remove_host+0x79/0x160 [scsi_mod]
kernel:  [<ffffffffa020c5fe>] mvs_pci_remove+0x4e/0xe0 [mvsas]
kernel:  [<ffffffff81311e2f>] pci_device_remove+0x3f/0xc0
kernel:  [<ffffffff813f3d87>] __device_release_driver+0x87/0x120
kernel:  [<ffffffff813f4898>] driver_detach+0xc8/0xd0
kernel:  [<ffffffff813f39e9>] bus_remove_driver+0x59/0xe0
kernel:  [<ffffffff813f5130>] driver_unregister+0x30/0x70
kernel:  [<ffffffff8131179d>] pci_unregister_driver+0x2d/0xa0
kernel:  [<ffffffffa0215969>] mvs_exit+0x10/0x6a7 [mvsas]
kernel:  [<ffffffff811006df>] SyS_delete_module+0x1cf/0x280
kernel:  [<ffffffff8158b56e>] system_call_fastpath+0x12/0x71
kernel: ---[ end trace 18b7a6f92868038c ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 0 PID: 5845 at fs/sysfs/group.c:224
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff8189de80 not found for kobject 'sdj1'
kernel: Modules linked in: fuse nf_conntrack_netbios_ns nf_conntrack_br=
oadcast
xt_tcpudp ip6t_rpfilter ip
kernel:  aesni_intel rc_core snd_hda_codec_realtek aes_x86_64 lrw gf128=
mul
videobuf2_dma_sg glue_helper a
kernel: CPU: 0 PID: 5845 Comm: rmmod Tainted: P  R   D W  O    4.1.2-2-=
ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel:  0000000000000000 0000000015da1c4c ffff880100a9ba98 ffffffff815=
85c8e
kernel:  0000000000000000 ffff880100a9baf0 ffff880100a9bad8 ffffffff810=
78c9a
kernel:  ffff880100a9bad8 0000000000000000 ffffffff8189de80 ffff8802225=
55038
kernel: Call Trace:
kernel:  [<ffffffff81585c8e>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81078c9a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81078d25>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff81258b9c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff8125c351>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813fc4c7>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813ef828>] device_del+0x58/0x270
kernel:  [<ffffffff812aebec>] delete_partition+0x4c/0x80
kernel:  [<ffffffff812ad140>] del_gendisk+0xd0/0x240
kernel:  [<ffffffffa0008bb1>] sd_remove+0x61/0xc0 [sd_mod]
kernel:  [<ffffffff813f3d87>] __device_release_driver+0x87/0x120
kernel:  [<ffffffff813f3e43>] device_release_driver+0x23/0x30
kernel:  [<ffffffff813f36c8>] bus_remove_device+0x108/0x180
kernel:  [<ffffffff813ef911>] device_del+0x141/0x270
kernel:  [<ffffffffa008c51d>] __scsi_remove_device+0xcd/0xe0 [scsi_mod]
kernel:  [<ffffffffa008a964>] scsi_forget_host+0x64/0x70 [scsi_mod]
kernel:  [<ffffffffa007f4e9>] scsi_remove_host+0x79/0x160 [scsi_mod]
kernel:  [<ffffffffa020c5fe>] mvs_pci_remove+0x4e/0xe0 [mvsas]
kernel:  [<ffffffff81311e2f>] pci_device_remove+0x3f/0xc0
kernel:  [<ffffffff813f3d87>] __device_release_driver+0x87/0x120
kernel:  [<ffffffff813f4898>] driver_detach+0xc8/0xd0
kernel:  [<ffffffff813f39e9>] bus_remove_driver+0x59/0xe0
kernel:  [<ffffffff813f5130>] driver_unregister+0x30/0x70
kernel:  [<ffffffff8131179d>] pci_unregister_driver+0x2d/0xa0
kernel:  [<ffffffffa0215969>] mvs_exit+0x10/0x6a7 [mvsas]
kernel:  [<ffffffff811006df>] SyS_delete_module+0x1cf/0x280
kernel:  [<ffffffff8158b56e>] system_call_fastpath+0x12/0x71
kernel: ---[ end trace 18b7a6f92868038d ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 1 PID: 5845 at fs/sysfs/group.c:224
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81859160 not found for kobject 'sdj'
kernel: Modules linked in: fuse nf_conntrack_netbios_ns nf_conntrack_br=
oadcast
xt_tcpudp ip6t_rpfilter ip
kernel:  aesni_intel rc_core snd_hda_codec_realtek aes_x86_64 lrw gf128=
mul
videobuf2_dma_sg glue_helper a
kernel: CPU: 1 PID: 5845 Comm: rmmod Tainted: P  R   D W  O    4.1.2-2-=
ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel:  0000000000000000 0000000015da1c4c ffff880100a9baf8 ffffffff815=
85c8e
kernel:  0000000000000000 ffff880100a9bb50 ffff880100a9bb38 ffffffff810=
78c9a
kernel:  ffff880226087100 0000000000000000 ffffffff81859160 ffff8802224=
b4c80
kernel: Call Trace:
kernel:  [<ffffffff81585c8e>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81078c9a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81078d25>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff81258b9c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff8125c351>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff8113d7f4>] blk_trace_remove_sysfs+0x14/0x20
kernel:  [<ffffffff8129eed5>] blk_unregister_queue+0x65/0xa0
kernel:  [<ffffffff812ad19e>] del_gendisk+0x12e/0x240
kernel:  [<ffffffffa0008bb1>] sd_remove+0x61/0xc0 [sd_mod]
kernel:  [<ffffffff813f3d87>] __device_release_driver+0x87/0x120
kernel:  [<ffffffff813f3e43>] device_release_driver+0x23/0x30
kernel:  [<ffffffff813f36c8>] bus_remove_device+0x108/0x180
kernel:  [<ffffffff813ef911>] device_del+0x141/0x270
kernel:  [<ffffffffa008c51d>] __scsi_remove_device+0xcd/0xe0 [scsi_mod]
kernel:  [<ffffffffa008a964>] scsi_forget_host+0x64/0x70 [scsi_mod]
kernel:  [<ffffffffa007f4e9>] scsi_remove_host+0x79/0x160 [scsi_mod]
kernel:  [<ffffffffa020c5fe>] mvs_pci_remove+0x4e/0xe0 [mvsas]
kernel:  [<ffffffff81311e2f>] pci_device_remove+0x3f/0xc0
kernel:  [<ffffffff813f3d87>] __device_release_driver+0x87/0x120
kernel:  [<ffffffff813f4898>] driver_detach+0xc8/0xd0
kernel:  [<ffffffff813f39e9>] bus_remove_driver+0x59/0xe0
kernel:  [<ffffffff813f5130>] driver_unregister+0x30/0x70
kernel:  [<ffffffff8131179d>] pci_unregister_driver+0x2d/0xa0
kernel:  [<ffffffffa0215969>] mvs_exit+0x10/0x6a7 [mvsas]
kernel:  [<ffffffff811006df>] SyS_delete_module+0x1cf/0x280
kernel:  [<ffffffff8158b56e>] system_call_fastpath+0x12/0x71
kernel: ---[ end trace 18b7a6f92868038f ]---
kernel: sd 8:0:0:0: [sdj] Synchronizing SCSI cache
kernel: BUG: unable to handle kernel NULL pointer dereference at
0000000000000018
kernel: IP: [<ffffffffa020e1ea>] mvs_task_exec.isra.3+0x2a/0xe90 [mvsas=
]
kernel: PGD 1663e9067 PUD 153765067 PMD 0=20
kernel: Oops: 0000 [#2] PREEMPT SMP=20
kernel: Modules linked in: fuse nf_conntrack_netbios_ns nf_conntrack_br=
oadcast
xt_tcpudp ip6t_rpfilter ip
kernel:  aesni_intel rc_core snd_hda_codec_realtek aes_x86_64 lrw gf128=
mul
videobuf2_dma_sg glue_helper a
kernel: CPU: 1 PID: 5845 Comm: rmmod Tainted: P  R   D W  O    4.1.2-2-=
ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: task: ffff880118008a30 ti: ffff880100a98000 task.ti: ffff880100=
a98000
kernel: RIP: 0010:[<ffffffffa020e1ea>]  [<ffffffffa020e1ea>]
mvs_task_exec.isra.3+0x2a/0xe90 [mvsas]
kernel: RSP: 0018:ffff880100a9b758  EFLAGS: 00010092
kernel: RAX: 0000000000000000 RBX: ffff8802253bc4f8 RCX: ffff880100b5c7=
18
kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880100b5c7=
00
kernel: RBP: ffff880100a9b7f8 R08: ffffffffa011201d R09: ffff880100b5c7=
00
kernel: R10: 000000000003002f R11: 000000000000002f R12: 00000000000000=
00
kernel: R13: ffff8802253bc000 R14: ffff880100b5c700 R15: ffff880100b5c7=
00
kernel: FS:  00007fac1bb7b700(0000) GS:ffff88022ec40000(0000)
knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
kernel: CR2: 0000000000000018 CR3: 000000014a767000 CR4: 00000000000407=
e0
kernel: Stack:
kernel:  000000000000000a 0000000015da1c4c ffff880100a9b798 ffffffff81a=
52e87
kernel:  ffffffffffffffff ffffffff81713cb4 ffff880100a9b7b8 ffffffff812=
581cc
kernel:  ffff8802230b2348 0000000000000086 ffff880100000000 00000000000=
00000
kernel: Call Trace:
kernel:  [<ffffffff812581cc>] ? kernfs_path_locked+0x3c/0x90
kernel:  [<ffffffffa011201d>] ? sas_alloc_task+0x1d/0x40 [libsas]
kernel:  [<ffffffffa020f832>] mvs_queue_command+0x12/0x20 [mvsas]
kernel:  [<ffffffffa011aec1>] sas_ata_qc_issue+0x1b1/0x260 [libsas]
kernel:  [<ffffffffa0263950>] ata_qc_issue+0x170/0x3e0 [libata]
kernel:  [<ffffffff810e4c83>] ? internal_add_timer+0x63/0x80
kernel:  [<ffffffffa0268680>] ? ata_scsi_em_message_show+0x40/0x40 [lib=
ata]
kernel:  [<ffffffffa026a3b6>] ata_scsi_translate+0xb6/0x1d0 [libata]
kernel:  [<ffffffffa026ccaf>] ata_sas_queuecmd+0x9f/0x250 [libata]
kernel:  [<ffffffffa01199cf>] sas_queuecommand+0x18f/0x1f0 [libsas]
kernel:  [<ffffffffa00842d3>] scsi_dispatch_cmd+0xc3/0x1c0 [scsi_mod]
kernel:  [<ffffffffa008748d>] scsi_request_fn+0x2dd/0x590 [scsi_mod]
kernel:  [<ffffffff812992e7>] __blk_run_queue+0x37/0x50
kernel:  [<ffffffff812a1565>] blk_execute_rq_nowait+0xb5/0x180
kernel:  [<ffffffff8129a91f>] ? get_request+0x2ef/0x7f0
kernel:  [<ffffffff812a16bb>] blk_execute_rq+0x8b/0x150
kernel:  [<ffffffff8129aea6>] ? blk_get_request+0x86/0xf0
kernel:  [<ffffffffa0084531>] scsi_execute+0x141/0x1f0 [scsi_mod]
kernel:  [<ffffffffa008468e>] scsi_execute_req_flags+0x8e/0x100 [scsi_m=
od]
kernel:  [<ffffffffa00085f7>] sd_sync_cache+0xa7/0x1a0 [sd_mod]
kernel:  [<ffffffffa0008aa2>] sd_shutdown+0x72/0x120 [sd_mod]
kernel:  [<ffffffffa0008bb9>] sd_remove+0x69/0xc0 [sd_mod]
kernel:  [<ffffffff813f3d87>] __device_release_driver+0x87/0x120
kernel:  [<ffffffff813f3e43>] device_release_driver+0x23/0x30
kernel:  [<ffffffff813f36c8>] bus_remove_device+0x108/0x180
kernel:  [<ffffffff813ef911>] device_del+0x141/0x270
kernel:  [<ffffffffa008c51d>] __scsi_remove_device+0xcd/0xe0 [scsi_mod]
kernel:  [<ffffffffa008a964>] scsi_forget_host+0x64/0x70 [scsi_mod]
kernel:  [<ffffffffa007f4e9>] scsi_remove_host+0x79/0x160 [scsi_mod]
kernel:  [<ffffffffa020c5fe>] mvs_pci_remove+0x4e/0xe0 [mvsas]
kernel:  [<ffffffff81311e2f>] pci_device_remove+0x3f/0xc0
kernel:  [<ffffffff813f3d87>] __device_release_driver+0x87/0x120
kernel:  [<ffffffff813f4898>] driver_detach+0xc8/0xd0
kernel:  [<ffffffff813f39e9>] bus_remove_driver+0x59/0xe0
kernel:  [<ffffffff813f5130>] driver_unregister+0x30/0x70
kernel:  [<ffffffff8131179d>] pci_unregister_driver+0x2d/0xa0
kernel:  [<ffffffffa0215969>] mvs_exit+0x10/0x6a7 [mvsas]
kernel:  [<ffffffff811006df>] SyS_delete_module+0x1cf/0x280
kernel:  [<ffffffff8158b56e>] system_call_fastpath+0x12/0x71
kernel: Code: 00 66 66 66 66 90 55 48 89 e5 41 57 41 56 41 55 41 54 49 =
89 ff 53
48 83 ec 78 48 8b 07 48 8
kernel: RIP  [<ffffffffa020e1ea>] mvs_task_exec.isra.3+0x2a/0xe90 [mvsa=
s]
kernel:  RSP <ffff880100a9b758>
kernel: CR2: 0000000000000018
kernel: ---[ end trace 18b7a6f928680391 ]---
kernel: sas: Enter sas_scsi_recover_host busy: 1 failed: 1
kernel: sas: trying to find task 0xffff880100b5c700
kernel: sas: sas_scsi_find_task: aborting task 0xffff880100b5c700
kernel: drivers/scsi/mvsas/mv_sas.c 1487:Device has removed
kernel: sas: sas_scsi_find_task: querying task 0xffff880100b5c700
kernel: drivers/scsi/mvsas/mv_sas.c 1470:mvs_query_task:rc=3D 5
kernel: sas: sas_scsi_find_task: task 0xffff880100b5c700 failed to abor=
t
kernel: sas: task 0xffff880100b5c700 is not at LU: I_T recover
kernel: sas: I_T nexus reset for dev 0000000000000000
kernel: BUG: unable to handle kernel NULL pointer dereference at
0000000000000085
kernel: IP: [<ffffffffa02111bd>] mvs_I_T_nexus_reset+0x1d/0xe0 [mvsas]
kernel: PGD 0
kernel: Oops: 0000 [#3] PREEMPT SMP
kernel: Modules linked in: fuse nf_conntrack_netbios_ns nf_conntrack_br=
oadcast
xt_tcpudp ip6t_rpfilter ip
kernel:  aesni_intel rc_core snd_hda_codec_realtek aes_x86_64 lrw gf128=
mul
videobuf2_dma_sg glue_helper a
kernel: CPU: 0 PID: 230 Comm: scsi_eh_8 Tainted: P  R   D W  O    4.1.2=
-2-ARCH
#1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: task: ffff88007f84bd20 ti: ffff88007fc14000 task.ti: ffff88007f=
c14000
kernel: RIP: 0010:[<ffffffffa02111bd>]  [<ffffffffa02111bd>]
mvs_I_T_nexus_reset+0x1d/0xe0 [mvsas]
kernel: RSP: 0018:ffff88007fc17d28  EFLAGS: 00010296
kernel: RAX: ffffffffa02111a0 RBX: ffff880222c91e00 RCX: 00000000000000=
2d
kernel: RDX: 0000000000000000 RSI: 0000000000000282 RDI: ffff880222c91e=
00
kernel: RBP: ffff88007fc17d58 R08: 000000000000000a R09: 0000000000000a=
42
kernel: R10: 000000000003f190 R11: 0000000000000a42 R12: 00000000000000=
00
kernel: R13: ffff880100b5c708 R14: ffff8802230ef000 R15: ffff880100b5c7=
00
kernel: FS:  00007f833dffa700(0000) GS:ffff88022ec00000(0000)
knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
kernel: CR2: 0000000000000085 CR3: 000000021c800000 CR4: 00000000000407=
f0
kernel: Stack:
kernel:  ffff88007fc17d78 ffff880222c91e00 ffff8802230ef000 ffff880100b=
5c708
kernel:  ffff8802230ef000 ffff880100b5c700 ffff88007fc17e28 ffffffffa01=
19cd8
kernel:  ffff88007fc17d90 ffff88007f841088 ffff880222c92a00 ffff880222c=
92a00
kernel: Call Trace:
kernel:  [<ffffffffa0119cd8>] sas_scsi_recover_host+0x2a8/0xc20 [libsas=
]
kernel:  [<ffffffffa0083afc>] scsi_error_handler+0xfc/0x580 [scsi_mod]
kernel:  [<ffffffff81587212>] ? __schedule+0x362/0xa30
kernel:  [<ffffffffa0083a00>] ? scsi_eh_get_sense+0x190/0x190 [scsi_mod=
]
kernel:  [<ffffffff810977f8>] kthread+0xd8/0xf0
kernel:  [<ffffffff81097720>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8158b962>] ret_from_fork+0x42/0x70
kernel:  [<ffffffff81097720>] ? kthread_worker_fn+0x170/0x170
kernel: Code: e8 c9 78 e6 e0 66 0f 1f 84 00 00 00 00 00 66 66 66 66 90 =
55 48 89
e5 41 57 41 56 41 55 41 5
kernel: RIP  [<ffffffffa02111bd>] mvs_I_T_nexus_reset+0x1d/0xe0 [mvsas]
kernel:  RSP <ffff88007fc17d28>
kernel: CR2: 0000000000000085
kernel: ---[ end trace 18b7a6f928680392 ]---

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
