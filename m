From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: sysfs group not found for kobject on mpt2sas unload
Date: Wed, 20 Nov 2013 14:08:40 -0500
Message-ID: <20131120140840.4d1f23ca@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o143.mxlogic.net ([208.65.144.66]:38569 "EHLO
	p01c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3KTTIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2013 14:08:45 -0500
Received: from EXHQ1.corp.stratus.com (exhq1.corp.stratus.com [134.111.200.125])
	by mailhub5.stratus.com (8.12.11/8.12.11) with ESMTP id rAKJ7sPP014555
	for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2013 14:07:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Starting in 3.12, when loading and unloading the mpt2sas driver, I see
the following warning:

------------[ cut here ]------------
WARNING: CPU: 20 PID: 19096 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
sysfs group ffffffff81ca2f40 not found for kobject 'end_device-30:0'
Modules linked in: mpt2sas(-) stap_edcc1781e2697fc53c3d320bc2530218_19063(OF) ebtable_nat osst nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack bonding ebtable_filter ebtables ip6table_filter ip6_tables ixgbe igb x86_pkg_temp_thermal ptp coretemp pps_core joydev mdio crc32_pclmul crc32c_intel raid_class pcspkr ghash_clmulni_intel scsi_transport_sas ipmi_si dca ipmi_msghandler ntb uinput dm_round_robin sd_mod qla2xxx syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm scsi_transport_fc scsi_tgt usb_storage i2c_core dm_multipath [last unloaded: stap_2da929a187c82c607a23237c
 27bf2d06_18803]
CPU: 20 PID: 19096 Comm: rmmod Tainted: GF       W  O 3.12.0+ #4
Hardware name: Stratus ftServer 6400/G7LAZ, BIOS BIOS Version 6.2:52 04/09/2013
 0000000000000009 ffff88083ad3bb88 ffffffff8165265e ffff88083ad3bbd0
 ffff88083ad3bbc0 ffffffff8105514d 0000000000000000 ffffffff81ca2f40
 ffff880851f46ef8 ffff88007a73cf38 ffff88083fb8c6e8 ffff88083ad3bc20
Call Trace:
 [<ffffffff8165265e>] dump_stack+0x4d/0x66
 [<ffffffff8105514d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff810551bc>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffff8121873e>] ? sysfs_get_dirent_ns+0x4e/0x70
 [<ffffffff81219a46>] sysfs_remove_group+0xc6/0xd0
 [<ffffffff813edb43>] dpm_sysfs_remove+0x43/0x50
 [<ffffffff813e38c5>] device_del+0x45/0x1c0
 [<ffffffff813e3a5e>] device_unregister+0x1e/0x60
 [<ffffffff812eb9ce>] bsg_unregister_queue+0x5e/0xa0
 [<ffffffffa00dd0ba>] sas_rphy_free+0x7a/0xb0 [scsi_transport_sas]
 [<ffffffffa00def95>] sas_port_delete+0x35/0x160 [scsi_transport_sas]
 [<ffffffff81218c53>] ? sysfs_remove_link+0x23/0x30
 [<ffffffffa023662a>] mpt2sas_transport_port_remove+0x19a/0x1e0 [mpt2sas]
 [<ffffffffa0227b10>] _scsih_remove_device+0xb0/0x100 [mpt2sas]
 [<ffffffffa022f519>] mpt2sas_device_remove_by_sas_address.part.54+0x59/0x80 [mpt2sas]
 [<ffffffffa02322f9>] _scsih_remove+0xf9/0x210 [mpt2sas]
 [<ffffffff8133108b>] pci_device_remove+0x3b/0xb0
 [<ffffffff813e759f>] __device_release_driver+0x7f/0xf0
 [<ffffffff813e7f20>] driver_detach+0xc0/0xd0
 [<ffffffff813e71d5>] bus_remove_driver+0x55/0xd0
 [<ffffffff813e853c>] driver_unregister+0x2c/0x50
 [<ffffffff8132fbb3>] pci_unregister_driver+0x23/0x80
 [<ffffffffa023b713>] _scsih_exit+0x25/0x912 [mpt2sas]
 [<ffffffff810c93ed>] SyS_delete_module+0x16d/0x2d0
 [<ffffffff8165d81e>] ? do_page_fault+0xe/0x10
 [<ffffffff81661dd2>] system_call_fastpath+0x16/0x1b
---[ end trace b4eef98870c871fd ]---

Instrumenting the module loading/unloading cycle with systemtap, it
reports the following sequence of events:

modprobe
  device_add(A)
  device_add(B child of A)
  device_add(C child of A)
  device_add(D child of A)

rmmod
  device_del(B child of A)
  device_del(C child of A)
  device_del(A)
  device_del(D child of A)             << WARNING

The same sequence of device_add/del events occur in 3.11, but without
the warning.  Git bisect shows bcdde7e221a8750f9b62b6d0bd31b72ea4ad9309
"sysfs: make __sysfs_remove_dir() recursive" as the first bad commit.

The systemtap script and its output (from mpt2sas calls only) below:

% stap -d scsi_transport_sas -d mpt2sas -e 'probe kernel.function("device_add"),kernel.function("device_del") { printf("%s dev=%p\n%s", pp(), $dev, $$parms$$); print_backtrace(); printf("\n"); }  probe begin { printf("loaded\n") }'

% modprobe mpt2sas

kernel.function("device_add@drivers/base/core.c:976") dev=0xffff88007a73cf38
dev={.parent=0xffff88007a73bf60, .p=0x0, .kobj={.name="end_device-30:0", .entry={.next=0xffff88007a73cf50, .prev=0xffff88007a73cf50}, .parent=0x0, .kset=0xffff88085f878848, .ktype=0xffffffff81ca2300, .sd=0x0, .kref={.refcount={.counter=3}}, .state_initialized=1, .state_in_sysfs=0, .state_add_uevent_sent=0, .state_remove_uevent_sent=0, .uevent_suppress=0}, .init_name="<unknown>", .type=0x0, .mutex={.count={.counter=1}, .wait_lock={<union>={.rlock={.raw_lock={<union>={.head_tail=0, .tickets={.head='\000', .t 0xffffffff813e4760 : device_add+0x0/0x640 [kernel]
 0xffffffffa00dcd54 : sas_rphy_add+0x64/0x170 [scsi_transport_sas]
 0xffffffffa0235c73 : mpt2sas_transport_port_add+0x273/0xa90 [mpt2sas]
 0xffffffffa022aace : _scsih_scan_finished+0x20e/0x2c0 [mpt2sas]
 0xffffffff8141dd77 : do_scsi_scan_host+0x77/0xa0 [kernel]
 0xffffffff8141df6c : do_scan_async+0x1c/0x150 [kernel]
 0xffffffff8107d829 : async_run_entry_fn+0x39/0x120 [kernel]
 0xffffffff81070507 : process_one_work+0x177/0x460 [kernel]
 0xffffffff810711eb : worker_thread+0x11b/0x3a0 [kernel]
 0xffffffff81077822 : kthread+0xd2/0xf0 [kernel]
 0xffffffff81661d2c : ret_from_fork+0x7c/0xb0 [kernel]

kernel.function("device_add@drivers/base/core.c:976") dev=0xffff88007a73b4f8
dev={.parent=0xffff88007a73cf38, .p=0x0, .kobj={.name="end_device-30:0", .entry={.next=0xffff88007a73b510, .prev=0xffff88007a73b510}, .parent=0x0, .kset=0xffff88085f878848, .ktype=0xffffffff81ca2300, .sd=0x0, .kref={.refcount={.counter=2}}, .state_initialized=1, .state_in_sysfs=0, .state_add_uevent_sent=0, .state_remove_uevent_sent=0, .uevent_suppress=0}, .init_name="<unknown>", .type=0x0, .mutex={.count={.counter=1}, .wait_lock={<union>={.rlock={.raw_lock={<union>={.head_tail=0, .tickets={.head='\000', .t 0xffffffff813e4760 : device_add+0x0/0x640 [kernel]
 0xffffffff813ebad2 : attribute_container_add_class_device+0x12/0x30 [kernel]
 0xffffffff813ebf8a : transport_add_class_device+0x1a/0x40 [kernel]
 0xffffffff813eb9bc : attribute_container_device_trigger+0xbc/0xc0 [kernel]
 0xffffffff813ebf25 : transport_add_device+0x15/0x20 [kernel]
 0xffffffffa00dcd70 : sas_rphy_add+0x80/0x170 [scsi_transport_sas]
 0xffffffffa0235c73 : mpt2sas_transport_port_add+0x273/0xa90 [mpt2sas]
 0xffffffffa022aace : _scsih_scan_finished+0x20e/0x2c0 [mpt2sas]
 0xffffffff8141dd77 : do_scsi_scan_host+0x77/0xa0 [kernel]
 0xffffffff8141df6c : do_scan_async+0x1c/0x150 [kernel]
 0xffffffff8107d829 : async_run_entry_fn+0x39/0x120 [kernel]
 0xffffffff81070507 : process_one_work+0x177/0x460 [kernel]
 0xffffffff810711eb : worker_thread+0x11b/0x3a0 [kernel]
 0xffffffff81077822 : kthread+0xd2/0xf0 [kernel]
 0xffffffff81661d2c : ret_from_fork+0x7c/0xb0 [kernel]

kernel.function("device_add@drivers/base/core.c:976") dev=0xffff88007a73d9f0
dev={.parent=0xffff88007a73cf38, .p=0x0, .kobj={.name="end_device-30:0", .entry={.next=0xffff88007a73da08, .prev=0xffff88007a73da08}, .parent=0x0, .kset=0xffff88085f878848, .ktype=0xffffffff81ca2300, .sd=0x0, .kref={.refcount={.counter=2}}, .state_initialized=1, .state_in_sysfs=0, .state_add_uevent_sent=0, .state_remove_uevent_sent=0, .uevent_suppress=0}, .init_name="<unknown>", .type=0x0, .mutex={.count={.counter=1}, .wait_lock={<union>={.rlock={.raw_lock={<union>={.head_tail=0, .tickets={.head='\000', .t 0xffffffff813e4760 : device_add+0x0/0x640 [kernel]
 0xffffffff813ebad2 : attribute_container_add_class_device+0x12/0x30 [kernel]
 0xffffffff813ebf8a : transport_add_class_device+0x1a/0x40 [kernel]
 0xffffffff813eb9bc : attribute_container_device_trigger+0xbc/0xc0 [kernel]
 0xffffffff813ebf25 : transport_add_device+0x15/0x20 [kernel]
 0xffffffffa00dcd70 : sas_rphy_add+0x80/0x170 [scsi_transport_sas]
 0xffffffffa0235c73 : mpt2sas_transport_port_add+0x273/0xa90 [mpt2sas]
 0xffffffffa022aace : _scsih_scan_finished+0x20e/0x2c0 [mpt2sas]
 0xffffffff8141dd77 : do_scsi_scan_host+0x77/0xa0 [kernel]
 0xffffffff8141df6c : do_scan_async+0x1c/0x150 [kernel]
 0xffffffff8107d829 : async_run_entry_fn+0x39/0x120 [kernel]
 0xffffffff81070507 : process_one_work+0x177/0x460 [kernel]
 0xffffffff810711eb : worker_thread+0x11b/0x3a0 [kernel]
 0xffffffff81077822 : kthread+0xd2/0xf0 [kernel]
 0xffffffff81661d2c : ret_from_fork+0x7c/0xb0 [kernel]

kernel.function("device_add@drivers/base/core.c:976") dev=0xffff880851f46ee8
dev={.parent=0xffff88007a73cf38, .p=0xffff8808506f5a68, .kobj={.name="end_device-30:0", .entry={.next=0xffff880851f46f00, .prev=0xffff880851f46f00}, .parent=0x0, .kset=0xffff88085f878848, .ktype=0xffffffff81ca2300, .sd=0x0, .kref={.refcount={.counter=1}}, .state_initialized=1, .state_in_sysfs=0, .state_add_uevent_sent=0, .state_remove_uevent_sent=0, .uevent_suppress=0}, .init_name="<unknown>", .type=0x0, .mutex={.count={.counter=1}, .wait_lock={<union>={.rlock={.raw_lock={<union>={.head_tail=0, .tickets={. 0xffffffff813e4760 : device_add+0x0/0x640 [kernel]
 0xffffffff813e4fb0 : device_create_groups_vargs+0xe0/0x110 [kernel]
 0xffffffff813e5041 : device_create+0x41/0x50 [kernel]
 0xffffffff812ea93a : bsg_register_queue+0x11a/0x290 [kernel]
 0xffffffffa00dcbf3 : sas_bsg_initialize+0x83/0x180 [scsi_transport_sas]
 0xffffffffa00dcd83 : sas_rphy_add+0x93/0x170 [scsi_transport_sas]
 0xffffffffa0235c73 : mpt2sas_transport_port_add+0x273/0xa90 [mpt2sas]
 0xffffffffa022aace : _scsih_scan_finished+0x20e/0x2c0 [mpt2sas]
 0xffffffff8141dd77 : do_scsi_scan_host+0x77/0xa0 [kernel]
 0xffffffff8141df6c : do_scan_async+0x1c/0x150 [kernel]
 0xffffffff8107d829 : async_run_entry_fn+0x39/0x120 [kernel]
 0xffffffff81070507 : process_one_work+0x177/0x460 [kernel]
 0xffffffff810711eb : worker_thread+0x11b/0x3a0 [kernel]
 0xffffffff81077822 : kthread+0xd2/0xf0 [kernel]
 0xffffffff81661d2c : ret_from_fork+0x7c/0xb0 [kernel]

% rmmod mpt2sas

kernel.function("device_del@drivers/base/core.c:1186") dev=0xffff88007a73b4f8
dev={.parent=0xffff88007a73cf38, .p=0xffff8808506f4410, .kobj={.name="end_device-30:0", .entry={.next=0xffff88007a73da08, .prev=0xffff88007a73cf50}, .parent=0xffff88083fb8f500, .kset=0xffff88085f878848, .ktype=0xffffffff81ca2300, .sd=0xffff880833fc92e8, .kref={.refcount={.counter=4}}, .state_initialized=1, .state_in_sysfs=1, .state_add_uevent_sent=1, .state_remove_uevent_sent=0, .uevent_suppress=0}, .init_name="<unknown>", .type=0x0, .mutex={.count={.counter=1}, .wait_lock={<union>={.rlock={.raw_lock={<uni 0xffffffff813e3880 : device_del+0x0/0x1c0 [kernel]
 0xffffffff813ebdfa : attribute_container_class_device_del+0x1a/0x20 [kernel]
 0xffffffff813ebffe : transport_remove_classdev+0x4e/0x60 [kernel]
 0xffffffff813eb9bc : attribute_container_device_trigger+0xbc/0xc0 [kernel]
 0xffffffff813ebf65 : transport_remove_device+0x15/0x20 [kernel]
 0xffffffffa00dd17b : sas_rphy_remove+0x3b/0x60 [scsi_transport_sas]
 0xffffffffa00def8d : sas_port_delete+0x2d/0x160 [scsi_transport_sas]
 0xffffffffa023662a : mpt2sas_transport_port_remove+0x19a/0x1e0 [mpt2sas]
 0xffffffffa0227b10 : _scsih_remove_device+0xb0/0x100 [mpt2sas]
 0xffffffffa022f519 : mpt2sas_device_remove_by_sas_address.part.54+0x59/0x80 [mpt2sas]
 0xffffffffa02322f9 : _scsih_remove+0xf9/0x210 [mpt2sas]
 0xffffffff8133108b : pci_device_remove+0x3b/0xb0 [kernel]
 0xffffffff813e759f : __device_release_driver+0x7f/0xf0 [kernel]
 0xffffffff813e7f20 : driver_detach+0xc0/0xd0 [kernel]
 0xffffffff813e71d5 : bus_remove_driver+0x55/0xd0 [kernel]
 0xffffffff813e853c : driver_unregister+0x2c/0x50 [kernel]
 0xffffffff8132fbb3 : pci_unregister_driver+0x23/0x80 [kernel]
 0xffffffffa023b713 : cleanup_module+0x25/0x0 [mpt2sas]
 0xffffffff810c93ed : sys_delete_module+0x16d/0x2d0 [kernel] (inexact)
 0xffffffff8165d81e : do_page_fault+0xe/0x10 [kernel] (inexact)

kernel.function("device_del@drivers/base/core.c:1186") dev=0xffff88007a73d9f0
dev={.parent=0xffff88007a73cf38, .p=0xffff8808506f6080, .kobj={.name="end_device-30:0", .entry={.next=0xffff880851f46f00, .prev=0xffff88007a73cf50}, .parent=0xffff88084f062120, .kset=0xffff88085f878848, .ktype=0xffffffff81ca2300, .sd=0xffff880833859b80, .kref={.refcount={.counter=4}}, .state_initialized=1, .state_in_sysfs=1, .state_add_uevent_sent=1, .state_remove_uevent_sent=0, .uevent_suppress=0}, .init_name="<unknown>", .type=0x0, .mutex={.count={.counter=1}, .wait_lock={<union>={.rlock={.raw_lock={<uni 0xffffffff813e3880 : device_del+0x0/0x1c0 [kernel]
 0xffffffff813ebdfa : attribute_container_class_device_del+0x1a/0x20 [kernel]
 0xffffffff813ebffe : transport_remove_classdev+0x4e/0x60 [kernel]
 0xffffffff813eb9bc : attribute_container_device_trigger+0xbc/0xc0 [kernel]
 0xffffffff813ebf65 : transport_remove_device+0x15/0x20 [kernel]
 0xffffffffa00dd17b : sas_rphy_remove+0x3b/0x60 [scsi_transport_sas]
 0xffffffffa00def8d : sas_port_delete+0x2d/0x160 [scsi_transport_sas]
 0xffffffffa023662a : mpt2sas_transport_port_remove+0x19a/0x1e0 [mpt2sas]
 0xffffffffa0227b10 : _scsih_remove_device+0xb0/0x100 [mpt2sas]
 0xffffffffa022f519 : mpt2sas_device_remove_by_sas_address.part.54+0x59/0x80 [mpt2sas]
 0xffffffffa02322f9 : _scsih_remove+0xf9/0x210 [mpt2sas]
 0xffffffff8133108b : pci_device_remove+0x3b/0xb0 [kernel]
 0xffffffff813e759f : __device_release_driver+0x7f/0xf0 [kernel]
 0xffffffff813e7f20 : driver_detach+0xc0/0xd0 [kernel]
 0xffffffff813e71d5 : bus_remove_driver+0x55/0xd0 [kernel]
 0xffffffff813e853c : driver_unregister+0x2c/0x50 [kernel]
 0xffffffff8132fbb3 : pci_unregister_driver+0x23/0x80 [kernel]
 0xffffffffa023b713 : cleanup_module+0x25/0x0 [mpt2sas]
 0xffffffff810c93ed : sys_delete_module+0x16d/0x2d0 [kernel] (inexact)
 0xffffffff8165d81e : do_page_fault+0xe/0x10 [kernel] (inexact)

For reference, the next two systemtap probe points are the following two
lines:

/usr/src/kernels/linux/drivers/scsi/scsi_transport_sas.c: 1641
  <sas_port_delete+0x25>:      mov    %rbx,%rdi
  <sas_port_delete+0x28>:      callq  0xffffffffa00dd140 <sas_rphy_remove>
...
/usr/src/kernels/linux/drivers/scsi/scsi_transport_sas.c: 1642
  <sas_port_delete+0x2d>:      mov    %rbx,%rdi
  <sas_port_delete+0x30>:      callq  0xffffffffa00dd040 <sas_rphy_free>

drivers/scsi/scsi_transport_sas.c :

1639 sas_rphy_delete(struct sas_rphy *rphy)
1640 {
1641         sas_rphy_remove(rphy);
1642         sas_rphy_free(rphy);
1643 }

kernel.function("device_del@drivers/base/core.c:1186") dev=0xffff88007a73cf38
dev={.parent=0xffff88007a73bf60, .p=0xffff880851539a68, .kobj={.name="end_device-30:0", .entry={.next=0xffff880851f46f00, .prev=0xffff88007a73ba58}, .parent=0xffff88007a73bf70, .kset=0xffff88085f878848, .ktype=0xffffffff81ca2300, .sd=0xffff880833fc8898, .kref={.refcount={.counter=7}}, .state_initialized=1, .state_in_sysfs=1, .state_add_uevent_sent=0, .state_remove_uevent_sent=0, .uevent_suppress=0}, .init_name="<unknown>", .type=0x0, .mutex={.count={.counter=1}, .wait_lock={<union>={.rlock={.raw_lock={<uni 0xffffffff813e3880 : device_del+0x0/0x1c0 [kernel]
 0xffffffffa00dd183 : sas_rphy_remove+0x43/0x60 [scsi_transport_sas]
 0xffffffffa00def8d : sas_port_delete+0x2d/0x160 [scsi_transport_sas]
 0xffffffffa023662a : mpt2sas_transport_port_remove+0x19a/0x1e0 [mpt2sas]
 0xffffffffa0227b10 : _scsih_remove_device+0xb0/0x100 [mpt2sas]
 0xffffffffa022f519 : mpt2sas_device_remove_by_sas_address.part.54+0x59/0x80 [mpt2sas]
 0xffffffffa02322f9 : _scsih_remove+0xf9/0x210 [mpt2sas]
 0xffffffff8133108b : pci_device_remove+0x3b/0xb0 [kernel]
 0xffffffff813e759f : __device_release_driver+0x7f/0xf0 [kernel]
 0xffffffff813e7f20 : driver_detach+0xc0/0xd0 [kernel]
 0xffffffff813e71d5 : bus_remove_driver+0x55/0xd0 [kernel]
 0xffffffff813e853c : driver_unregister+0x2c/0x50 [kernel]
 0xffffffff8132fbb3 : pci_unregister_driver+0x23/0x80 [kernel]
 0xffffffffa023b713 : cleanup_module+0x25/0x0 [mpt2sas]
 0xffffffff810c93ed : sys_delete_module+0x16d/0x2d0 [kernel] (inexact)
 0xffffffff8165d81e : do_page_fault+0xe/0x10 [kernel] (inexact)
 0xffffffff81661dd2 : system_call_fastpath+0x16/0x1b [kernel] (inexact)

kernel.function("device_del@drivers/base/core.c:1186") dev=0xffff880851f46ee8
dev={.parent=0xffff88007a73cf38, .p=0xffff8808506f5a68, .kobj={.name="end_device-30:0", .entry={.next=0xffff88085f878848, .prev=0xffff88007a73ba58}, .parent=0xffff88084f061730, .kset=0xffff88085f878848, .ktype=0xffffffff81ca2300, .sd=0xffff880833859810, .kref={.refcount={.counter=3}}, .state_initialized=1, .state_in_sysfs=1, .state_add_uevent_sent=1, .state_remove_uevent_sent=0, .uevent_suppress=0}, .init_name="<unknown>", .type=0x0, .mutex={.count={.counter=1}, .wait_lock={<union>={.rlock={.raw_lock={<uni 0xffffffff813e3880 : device_del+0x0/0x1c0 [kernel]
 0xffffffff813e3a5e : device_unregister+0x1e/0x60 [kernel]
 0xffffffff812eb9ce : bsg_unregister_queue+0x5e/0xa0 [kernel]
 0xffffffffa00dd0ba : sas_rphy_free+0x7a/0xb0 [scsi_transport_sas]
 0xffffffffa00def95 : sas_port_delete+0x35/0x160 [scsi_transport_sas]
 0xffffffffa023662a : mpt2sas_transport_port_remove+0x19a/0x1e0 [mpt2sas]
 0xffffffffa0227b10 : _scsih_remove_device+0xb0/0x100 [mpt2sas]
 0xffffffffa022f519 : mpt2sas_device_remove_by_sas_address.part.54+0x59/0x80 [mpt2sas]
 0xffffffffa02322f9 : _scsih_remove+0xf9/0x210 [mpt2sas]
 0xffffffff8133108b : pci_device_remove+0x3b/0xb0 [kernel]
 0xffffffff813e759f : __device_release_driver+0x7f/0xf0 [kernel]
 0xffffffff813e7f20 : driver_detach+0xc0/0xd0 [kernel]
 0xffffffff813e71d5 : bus_remove_driver+0x55/0xd0 [kernel]
 0xffffffff813e853c : driver_unregister+0x2c/0x50 [kernel]
 0xffffffff8132fbb3 : pci_unregister_driver+0x23/0x80 [kernel]
 0xffffffffa023b713 : cleanup_module+0x25/0x0 [mpt2sas]
 0xffffffff810c93ed : sys_delete_module+0x16d/0x2d0 [kernel] (inexact)
 0xffffffff8165d81e : do_page_fault+0xe/0x10 [kernel] (inexact)
 0xffffffff81661dd2 : system_call_fastpath+0x16/0x1b [kernel] (inexact)


If I play code jenga (see diff below) and move the sas_bsg_remove call
from sas_rphy_free to sas_rphy_remove before transport_remove_device is
called, mimicing the ordering as done in __scsi_remove_device for the
functions:

  bsg_unregister_queue
  device_unregister
  transport_remove_device
  device_del

it imposes the following device_add/del order when loading and
unloading mpt2sas:

  device_add: A, B, C, D
  device_del: D, B, C, A

which still isn't completely symmetric, but at least parent device A is
removed after its children and the sysfs warning is averted.  I was
hoping that someone on the list might have a better idea of what should
be done to properly tear down these resources while keeping sysfs happy.
Any ideas?

Thanks,

-- Joe


diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 1b681427dde0..93f7463d68d9 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1614,14 +1614,6 @@ EXPORT_SYMBOL(sas_rphy_add);
 void sas_rphy_free(struct sas_rphy *rphy)
 {
 	struct device *dev = &rphy->dev;
-	struct Scsi_Host *shost = dev_to_shost(rphy->dev.parent->parent);
-	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
-
-	mutex_lock(&sas_host->lock);
-	list_del(&rphy->list);
-	mutex_unlock(&sas_host->lock);
-
-	sas_bsg_remove(shost, rphy);
 
 	transport_destroy_device(dev);
 
@@ -1667,6 +1659,8 @@ void
 sas_rphy_remove(struct sas_rphy *rphy)
 {
 	struct device *dev = &rphy->dev;
+	struct Scsi_Host *shost = dev_to_shost(rphy->dev.parent->parent);
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 
 	switch (rphy->identify.device_type) {
 	case SAS_END_DEVICE:
@@ -1681,6 +1675,11 @@ sas_rphy_remove(struct sas_rphy *rphy)
 	}
 
 	sas_rphy_unlink(rphy);
+	mutex_lock(&sas_host->lock);
+	list_del(&rphy->list);
+	mutex_unlock(&sas_host->lock);
+	sas_bsg_remove(shost, rphy);
+
 	transport_remove_device(dev);
 	device_del(dev);
 }

