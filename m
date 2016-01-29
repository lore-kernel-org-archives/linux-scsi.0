From: "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Subject: RE: [Bug 111441] New: iscsi fails to attach to targets
Date: Fri, 29 Jan 2016 12:04:15 +0000
Message-ID: <a331d83963b64d7da77352b01c1d10da@XCH-ALN-006.cisco.com>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
 <56AAC605.1080707@cs.wisc.edu>
 <9cf7d536fcc44d9d8f35d81503543497@XCH-ALN-006.cisco.com>
 <36266784-E570-406E-8C3A-56D0F728768B@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-6.cisco.com ([173.37.86.77]:35189 "EHLO
	rcdn-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbcA2MEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2016 07:04:23 -0500
In-Reply-To: <36266784-E570-406E-8C3A-56D0F728768B@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: "bugzilla-daemon@bugzilla.kernel.org" <bugzilla-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Actually this server uses both cases: Local taregts (since it is OpenStack server) and remote targets as it tries to mount 4 remotefile systems.  

You are correct, I always use the same box I just change the kernel it is using to boot. No other changes to the environment. I do not mind to load a test kernel without that suspected patch, just get me the RPM.

As you can see the first type of traceback happens when the server tries to attach to remote targets, the second type of traceback happens when I try to start OpenStack instance with local LVM volume which is represented as a local iscsi target. Please see below.

[Remote taregt case]

targetcli
targetcli shell version 2.1.fb41
Copyright 2011-2013 by Datera, Inc and others.
For help on commands, type 'help'.

/> ls
o- / ......................................................................................................................... [...]
  o- backstores .............................................................................................................. [...]
  | o- block .................................................................................................. [Storage Objects: 0]
  | o- fileio ................................................................................................. [Storage Objects: 0]
  | o- pscsi .................................................................................................. [Storage Objects: 0]
  | o- ramdisk ................................................................................................ [Storage Objects: 0]
  o- iscsi ............................................................................................................ [Targets: 0]
  o- loopback ......................................................................................................... [Targets: 0]
/> exit


[   25.670239] scsi host3: iSCSI Initiator over TCP/IP
[   25.682122] scsi host4: iSCSI Initiator over TCP/IP
[   25.692401] scsi host5: iSCSI Initiator over TCP/IP
[   25.693530] scsi 3:0:0:2: Direct-Access     LIO-ORG  san-disk-2       4.0  PQ: 0 ANSI: 5     < ------------------------ Remote target
[   25.693936] sd 3:0:0:2: alua: supports implicit and explicit TPGS
[   25.694078] sd 3:0:0:2: alua: No target port descriptors found
[   25.694080] sd 3:0:0:2: alua: Attach failed (-22)
[   25.694081] sd 3:0:0:2: failed to add device handler: -22
[   25.694121] sd 3:0:0:2: [sdc] 20507809792 512-byte logical blocks: (10.4 TB/9.54 TiB)
[   25.694127] sd 3:0:0:2: [sdc] Write Protect is off
[   25.694129] sd 3:0:0:2: [sdc] Mode Sense: 00 00 00 00
[   25.694131] sd 3:0:0:2: [sdc] Asking for cache data failed
[   25.694132] sd 3:0:0:2: [sdc] Assuming drive cache: write through
[   25.695112] ------------[ cut here ]------------
[   25.695119] WARNING: CPU: 12 PID: 841 at block/genhd.c:626 add_disk+0x443/0x4a0()
[   25.695120] Modules linked in: iscsi_tcp libiscsi_tcp 8021q garp mrp rpcrdma ib_isert iscsi_target_mod bonding ib_iser libiscsi scsi_transport_iscsi openvswitch ib_srpt target_core_mod nf_defrag_ipv6 ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm xt_comment xt_multiport ib_sa iptable_filter ib_mad iptable_nat nf_conntrack_ipv4 usnic_verbs nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ib_core ib_addr iptable_mangle x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul aesni_intel nfsd lrw gf128mul glue_helper ablk_helper ses cryptd enclosure ipmi_devintf sg sb_edac iTCO_wdt shpchp edac_core iTCO_vendor_support ipmi_si pcspkr lpc_ich ipmi_msghandler mfd_core auth_rpcgss acpi_power_meter wmi nfs_acl l
 ockd br_netfilter
[   25.695161]  grace sunrpc bridge stp llc dm_multipath ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm ixgbe(O) fnic i40e libfcoe igb crc32c_intel megaraid_sas enic libfc vxlan ip6_udp_tunnel udp_tunnel ptp scsi_transport_fc i2c_algo_bit i2c_core pps_core dca dm_mirror dm_region_hash dm_log dm_mod
[   25.695183] CPU: 12 PID: 841 Comm: kworker/u82:2 Tainted: G           O    4.4.0 #1
[   25.695185] Hardware name: Cisco Systems Inc UCSC-C240-M3S/UCSC-C240-M3S, BIOS C240M3.2.0.8.0.071620152208 07/16/2015
[   25.695189] Workqueue: events_unbound async_run_entry_fn
[   25.695191]  0000000000000000 000000004b5682c8 ffff885f9b887cf8 ffffffff81329090
[   25.695193]  0000000000000000 ffff885f9b887d30 ffffffff810862c6 ffff885fa5ef2000
[   25.695194]  ffff885fa5ef2080 ffff885f9d2fe1a0 ffff885fa5ef200c ffff885f86b10000
[   25.695196] Call Trace:
[   25.695204]  [<ffffffff81329090>] dump_stack+0x44/0x64
[   25.695207]  [<ffffffff810862c6>] warn_slowpath_common+0x86/0xc0
[   25.695209]  [<ffffffff8108640a>] warn_slowpath_null+0x1a/0x20
[   25.695210]  [<ffffffff8130ef23>] add_disk+0x443/0x4a0
[   25.695216]  [<ffffffffa008ba35>] sd_probe_async+0x115/0x1d0 [sd_mod]
[   25.695217]  [<ffffffff810a70fa>] async_run_entry_fn+0x4a/0x140
[   25.695220]  [<ffffffff8109e09c>] process_one_work+0x14c/0x3c0
[   25.695221]  [<ffffffff8109e8d4>] worker_thread+0x114/0x470
[   25.695226]  [<ffffffff816905ba>] ? __schedule+0x2aa/0x700
[   25.695237]  [<ffffffff8109e7c0>] ? rescuer_thread+0x310/0x310
[   25.695241]  [<ffffffff810a43d8>] kthread+0xd8/0xf0
[   25.695243]  [<ffffffff810a4300>] ? kthread_park+0x60/0x60
[   25.695245]  [<ffffffff8169490f>] ret_from_fork+0x3f/0x70
[   25.695247]  [<ffffffff810a4300>] ? kthread_park+0x60/0x60
[   25.695248] ---[ end trace bcfb1475313b5f60 ]---
[   25.695262] sd 3:0:0:2: [sdc] Attached SCSI disk
[   25.703053] scsi host6: iSCSI Initiator over TCP/IP
[   25.704370] scsi 3:0:0:0: Unexpected response from lun 2 while scanning, scan aborted


[local target case]


/> ls
o- / ......................................................................................................................... [...]
  o- backstores .............................................................................................................. [...]
  | o- block .................................................................................................. [Storage Objects: 1]
  | | o- iqn.2010-10.org.openstack:volume-07e39fbc-4767-4455-bb96-c6b53be6a10c  [/dev/cinder-volumes-local/volume-07e39fbc-4767-4455-bb96-c6b53be6a10c (55.0GiB) write-thru activated]
  | o- fileio ................................................................................................. [Storage Objects: 0]
  | o- pscsi .................................................................................................. [Storage Objects: 0]
  | o- ramdisk ................................................................................................ [Storage Objects: 0]
  o- iscsi ............................................................................................................ [Targets: 1]
  | o- iqn.2010-10.org.openstack:volume-07e39fbc-4767-4455-bb96-c6b53be6a10c ............................................. [TPGs: 1]
  |   o- tpg1 .......................................................................................... [no-gen-acls, auth per-acl]
  |     o- acls .......................................................................................................... [ACLs: 1]
  |     | o- iqn.1994-05.com.redhat:cf7f1fafca4b ...................................................... [1-way auth, Mapped LUNs: 1]
  |     |   o- mapped_lun0 ................. [lun0 block/iqn.2010-10.org.openstack:volume-07e39fbc-4767-4455-bb96-c6b53be6a10c (rw)]
  |     o- luns .......................................................................................................... [LUNs: 1]
  |     | o- lun0  [block/iqn.2010-10.org.openstack:volume-07e39fbc-4767-4455-bb96-c6b53be6a10c (/dev/cinder-volumes-local/volume-07e39fbc-4767-4455-bb96-c6b53be6a10c)]
  |     o- portals .................................................................................................... [Portals: 1]
  |       o- 192.168.80.23:3260 ............................................................................................... [OK]
  o- loopback ......................................................................................................... [Targets: 0]
/>


[root@sbezverk-osp-3 ~(keystone_admin)]# lvs
  LV                                          VG                   Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  swift-volume                                cinder-volumes-local -wi-ao---- 200.00g                                                    
  volume-07e39fbc-4767-4455-bb96-c6b53be6a10c cinder-volumes-local -wi-a-----  55.00g              < ----- Local volume and a local target for OpenStack instance                                      
  volume-c69da50c-c66a-4f94-9a40-b4f7d7f28eae cinder-volumes-local -wi-a-----   1.00g                    < ----- Local volume and a local target for OpenStack instance           


Here are tracebacks when OpenStack tries to attach to these two local targets:

[ 1019.953129] Unable to load target_core_user
[ 1033.758866] scsi host7: iSCSI Initiator over TCP/IP
[ 1033.776279] scsi 7:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[ 1033.776658] sd 7:0:0:0: alua: supports implicit and explicit TPGS
[ 1033.776721] TARGET_CORE[iSCSI]: Expected Transfer Length: 264 does not match SCSI CDB Length: 8 for SAM Opcode: 0x12
[ 1033.776763] sd 7:0:0:0: alua: No target port descriptors found
[ 1033.776765] sd 7:0:0:0: alua: Attach failed (-22)
[ 1033.776782] sd 7:0:0:0: failed to add device handler: -22
[ 1033.776786] sd 7:0:0:0: [sdg] 115343360 512-byte logical blocks: (59.0 GB/55.0 GiB)             < ----------------------------------- first 55G volume
[ 1033.776791] sd 7:0:0:0: [sdg] Write Protect is off
[ 1033.776792] sd 7:0:0:0: [sdg] Mode Sense: 00 00 00 00
[ 1033.776795] sd 7:0:0:0: [sdg] Asking for cache data failed
[ 1033.776820] sd 7:0:0:0: [sdg] Assuming drive cache: write through
[ 1033.776960] ------------[ cut here ]------------
[ 1033.776965] WARNING: CPU: 6 PID: 7 at lib/kobject.c:244 kobject_add_internal+0x10d/0x320()
[ 1033.776966] kobject_add_internal failed for block (error: -2 parent: 7:0:0:0)
[ 1033.776967] Modules linked in: target_core_pscsi target_core_file target_core_iblock xt_REDIRECT nf_nat_redirect xt_nat xt_mark xt_CHECKSUM nf_conntrack_ipv6 xt_mac xt_physdev xt_set xt_conntrack iptable_raw ip_set_hash_net ip_set nfnetlink veth ebtable_filter ebtables ip6table_filter ip6_tables iscsi_tcp libiscsi_tcp 8021q garp mrp rpcrdma ib_isert iscsi_target_mod bonding ib_iser libiscsi scsi_transport_iscsi openvswitch ib_srpt target_core_mod nf_defrag_ipv6 ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm xt_comment xt_multiport ib_sa iptable_filter ib_mad iptable_nat nf_conntrack_ipv4 usnic_verbs nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ib_core ib_addr iptable_mangle x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
  crct10dif_pclmul
[ 1033.777008]  crc32_pclmul aesni_intel nfsd lrw gf128mul glue_helper ablk_helper ses cryptd enclosure ipmi_devintf sg sb_edac iTCO_wdt shpchp edac_core iTCO_vendor_support ipmi_si pcspkr lpc_ich ipmi_msghandler mfd_core auth_rpcgss acpi_power_meter wmi nfs_acl lockd br_netfilter grace sunrpc bridge stp llc dm_multipath ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm ixgbe(O) fnic i40e libfcoe igb crc32c_intel megaraid_sas enic libfc vxlan ip6_udp_tunnel udp_tunnel ptp scsi_transport_fc i2c_algo_bit i2c_core pps_core dca dm_mirror dm_region_hash dm_log dm_mod
[ 1033.777040] CPU: 6 PID: 7 Comm: kworker/u81:0 Tainted: G        W  O    4.4.0 #1
[ 1033.777041] Hardware name: Cisco Systems Inc UCSC-C240-M3S/UCSC-C240-M3S, BIOS C240M3.2.0.8.0.071620152208 07/16/2015
[ 1033.777045] Workqueue: events_unbound async_run_entry_fn
[ 1033.777046]  0000000000000000 00000000f9d0f617 ffff882fa6bcbb60 ffffffff81329090
[ 1033.777048]  ffff882fa6bcbba8 ffff882fa6bcbb98 ffffffff810862c6 ffff885d991d0360
[ 1033.777050]  ffff885fa5f5c978 00000000fffffffe ffff885fa5f5c978 ffff882e7b520070
[ 1033.777052] Call Trace:
[ 1033.777057]  [<ffffffff81329090>] dump_stack+0x44/0x64
[ 1033.777060]  [<ffffffff810862c6>] warn_slowpath_common+0x86/0xc0
[ 1033.777061]  [<ffffffff8108635c>] warn_slowpath_fmt+0x5c/0x80
[ 1033.777063]  [<ffffffff8132bebd>] kobject_add_internal+0x10d/0x320
[ 1033.777067]  [<ffffffff811a34d2>] ? kfree_const+0x22/0x30
[ 1033.777068]  [<ffffffff8132c305>] kobject_add+0x75/0xd0
[ 1033.777073]  [<ffffffff811e2a8e>] ? kmem_cache_alloc_trace+0x1be/0x1e0
[ 1033.777076]  [<ffffffff81451f62>] ? get_device_parent+0x122/0x1d0
[ 1033.777078]  [<ffffffff81451fa8>] get_device_parent+0x168/0x1d0
[ 1033.777079]  [<ffffffff81452557>] device_add+0xf7/0x610
[ 1033.777081]  [<ffffffff8130ecad>] add_disk+0x1cd/0x4a0
[ 1033.777085]  [<ffffffff81460ec5>] ? update_autosuspend+0x55/0x60
[ 1033.777088]  [<ffffffff81460f84>] ? __pm_runtime_use_autosuspend+0x54/0x70
[ 1033.777092]  [<ffffffffa008ba35>] sd_probe_async+0x115/0x1d0 [sd_mod]
[ 1033.777093]  [<ffffffff810a70fa>] async_run_entry_fn+0x4a/0x140
[ 1033.777096]  [<ffffffff8109e09c>] process_one_work+0x14c/0x3c0
[ 1033.777097]  [<ffffffff8109e8d4>] worker_thread+0x114/0x470
[ 1033.777098]  [<ffffffff8109e7c0>] ? rescuer_thread+0x310/0x310
[ 1033.777101]  [<ffffffff810a43d8>] kthread+0xd8/0xf0
[ 1033.777103]  [<ffffffff810a4300>] ? kthread_park+0x60/0x60
[ 1033.777105]  [<ffffffff8169490f>] ret_from_fork+0x3f/0x70
[ 1033.777107]  [<ffffffff810a4300>] ? kthread_park+0x60/0x60
[ 1033.777108] ---[ end trace bcfb1475313b5f61 ]---
[ 1033.777855] sd 7:0:0:0: [sdg] Attached SCSI disk
[ 1033.911169] scsi 7:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[ 1033.911465] ------------[ cut here ]------------
[ 1033.911470] WARNING: CPU: 22 PID: 10565 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
[ 1033.911471] sysfs: cannot create duplicate filename '/bus/scsi/devices/7:0:0:0'
[ 1033.911472] Modules linked in: target_core_pscsi target_core_file target_core_iblock xt_REDIRECT nf_nat_redirect xt_nat xt_mark xt_CHECKSUM nf_conntrack_ipv6 xt_mac xt_physdev xt_set xt_conntrack iptable_raw ip_set_hash_net ip_set nfnetlink veth ebtable_filter ebtables ip6table_filter ip6_tables iscsi_tcp libiscsi_tcp 8021q garp mrp rpcrdma ib_isert iscsi_target_mod bonding ib_iser libiscsi scsi_transport_iscsi openvswitch ib_srpt target_core_mod nf_defrag_ipv6 ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm xt_comment xt_multiport ib_sa iptable_filter ib_mad iptable_nat nf_conntrack_ipv4 usnic_verbs nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ib_core ib_addr iptable_mangle x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
  crct10dif_pclmul
[ 1033.911502]  crc32_pclmul aesni_intel nfsd lrw gf128mul glue_helper ablk_helper ses cryptd enclosure ipmi_devintf sg sb_edac iTCO_wdt shpchp edac_core iTCO_vendor_support ipmi_si pcspkr lpc_ich ipmi_msghandler mfd_core auth_rpcgss acpi_power_meter wmi nfs_acl lockd br_netfilter grace sunrpc bridge stp llc dm_multipath ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm ixgbe(O) fnic i40e libfcoe igb crc32c_intel megaraid_sas enic libfc vxlan ip6_udp_tunnel udp_tunnel ptp scsi_transport_fc i2c_algo_bit i2c_core pps_core dca dm_mirror dm_region_hash dm_log dm_mod
[ 1033.911533] CPU: 22 PID: 10565 Comm: iscsiadm Tainted: G        W  O    4.4.0 #1
[ 1033.911534] Hardware name: Cisco Systems Inc UCSC-C240-M3S/UCSC-C240-M3S, BIOS C240M3.2.0.8.0.071620152208 07/16/2015
[ 1033.911535]  0000000000000000 000000004e211399 ffff885d9a9d3948 ffffffff81329090
[ 1033.911537]  ffff885d9a9d3990 ffff885d9a9d3980 ffffffff810862c6 ffff882fa033c000
[ 1033.911538]  ffff885f9f5bf490 ffff885fa5329e10 0000000000000001 ffffffffffffffef
[ 1033.911540] Call Trace:
[ 1033.911545]  [<ffffffff81329090>] dump_stack+0x44/0x64
[ 1033.911548]  [<ffffffff810862c6>] warn_slowpath_common+0x86/0xc0
[ 1033.911549]  [<ffffffff8108635c>] warn_slowpath_fmt+0x5c/0x80
[ 1033.911552]  [<ffffffff8127e9a8>] ? kernfs_path+0x48/0x60
[ 1033.911553]  [<ffffffff81282014>] sysfs_warn_dup+0x64/0x80
[ 1033.911555]  [<ffffffff812823aa>] sysfs_do_create_link_sd.isra.2+0xaa/0xb0
[ 1033.911556]  [<ffffffff812823d5>] sysfs_create_link+0x25/0x40
[ 1033.911560]  [<ffffffff81454a6b>] bus_add_device+0x10b/0x1f0
[ 1033.911561]  [<ffffffff81452815>] device_add+0x3b5/0x610
[ 1033.911564]  [<ffffffff81487df5>] scsi_sysfs_add_sdev+0xa5/0x290
[ 1033.911566]  [<ffffffff81485355>] scsi_probe_and_add_lun+0xb65/0xd80
[ 1033.911570]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[ 1033.911572]  [<ffffffff81485d67>] __scsi_scan_target+0xf7/0x260
[ 1033.911574]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[ 1033.911577]  [<ffffffff81485fa7>] scsi_scan_target+0xd7/0xf0
[ 1033.911587]  [<ffffffffa07c29f5>] iscsi_user_scan_session.part.14+0x105/0x140 [scsi_transport_iscsi]
[ 1033.911592]  [<ffffffffa07c2a30>] ? iscsi_user_scan_session.part.14+0x140/0x140 [scsi_transport_iscsi]
[ 1033.911596]  [<ffffffffa07c2a4e>] iscsi_user_scan_session+0x1e/0x30 [scsi_transport_iscsi]
[ 1033.911599]  [<ffffffff81450b80>] device_for_each_child+0x50/0x90
[ 1033.911604]  [<ffffffffa07c083d>] iscsi_user_scan+0x3d/0x60 [scsi_transport_iscsi]
[ 1033.911607]  [<ffffffff81487bb6>] store_scan+0xa6/0x100
[ 1033.911612]  [<ffffffff811e3158>] ? __kmalloc+0x1b8/0x250
[ 1033.911616]  [<ffffffff81450318>] dev_attr_store+0x18/0x30
[ 1033.911618]  [<ffffffff8128170a>] sysfs_kf_write+0x3a/0x50
[ 1033.911620]  [<ffffffff81280d90>] kernfs_fop_write+0x120/0x170
[ 1033.911623]  [<ffffffff81203f17>] __vfs_write+0x37/0x100
[ 1033.911626]  [<ffffffff812b6c03>] ? selinux_file_permission+0xc3/0x110
[ 1033.911630]  [<ffffffff812ae75d>] ? security_file_permission+0x3d/0xc0
[ 1033.911634]  [<ffffffff810cd95f>] ? percpu_down_read+0x1f/0x50
[ 1033.911636]  [<ffffffff812045f2>] vfs_write+0xa2/0x1a0
[ 1033.911640]  [<ffffffff81003176>] ? do_audit_syscall_entry+0x66/0x70
[ 1033.911641]  [<ffffffff812053b5>] SyS_write+0x55/0xc0
[ 1033.911644]  [<ffffffff816945ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1033.911645] ---[ end trace bcfb1475313b5f62 ]---
[ 1033.911676] scsi 7:0:0:0: failed to add device: -17
[ 1033.982858] scsi 7:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[ 1033.983185] ------------[ cut here ]------------
[ 1033.983191] WARNING: CPU: 1 PID: 10574 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
[ 1033.983192] sysfs: cannot create duplicate filename '/bus/scsi/devices/7:0:0:0'
[ 1033.983193] Modules linked in: target_core_pscsi target_core_file target_core_iblock xt_REDIRECT nf_nat_redirect xt_nat xt_mark xt_CHECKSUM nf_conntrack_ipv6 xt_mac xt_physdev xt_set xt_conntrack iptable_raw ip_set_hash_net ip_set nfnetlink veth ebtable_filter ebtables ip6table_filter ip6_tables iscsi_tcp libiscsi_tcp 8021q garp mrp rpcrdma ib_isert iscsi_target_mod bonding ib_iser libiscsi scsi_transport_iscsi openvswitch ib_srpt target_core_mod nf_defrag_ipv6 ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm xt_comment xt_multiport ib_sa iptable_filter ib_mad iptable_nat nf_conntrack_ipv4 usnic_verbs nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ib_core ib_addr iptable_mangle x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
  crct10dif_pclmul
[ 1033.983224]  crc32_pclmul aesni_intel nfsd lrw gf128mul glue_helper ablk_helper ses cryptd enclosure ipmi_devintf sg sb_edac iTCO_wdt shpchp edac_core iTCO_vendor_support ipmi_si pcspkr lpc_ich ipmi_msghandler mfd_core auth_rpcgss acpi_power_meter wmi nfs_acl lockd br_netfilter grace sunrpc bridge stp llc dm_multipath ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm ixgbe(O) fnic i40e libfcoe igb crc32c_intel megaraid_sas enic libfc vxlan ip6_udp_tunnel udp_tunnel ptp scsi_transport_fc i2c_algo_bit i2c_core pps_core dca dm_mirror dm_region_hash dm_log dm_mod
[ 1033.983255] CPU: 1 PID: 10574 Comm: iscsiadm Tainted: G        W  O    4.4.0 #1
[ 1033.983256] Hardware name: Cisco Systems Inc UCSC-C240-M3S/UCSC-C240-M3S, BIOS C240M3.2.0.8.0.071620152208 07/16/2015
[ 1033.983258]  0000000000000000 00000000b4fefb6b ffff882e7b617948 ffffffff81329090
[ 1033.983260]  ffff882e7b617990 ffff882e7b617980 ffffffff810862c6 ffff882e793b5000
[ 1033.983261]  ffff882f9f78ded0 ffff885fa5329e10 0000000000000001 ffffffffffffffef
[ 1033.983263] Call Trace:
[ 1033.983268]  [<ffffffff81329090>] dump_stack+0x44/0x64
[ 1033.983270]  [<ffffffff810862c6>] warn_slowpath_common+0x86/0xc0
[ 1033.983271]  [<ffffffff8108635c>] warn_slowpath_fmt+0x5c/0x80
[ 1033.983274]  [<ffffffff8127e9a8>] ? kernfs_path+0x48/0x60
[ 1033.983276]  [<ffffffff81282014>] sysfs_warn_dup+0x64/0x80
[ 1033.983278]  [<ffffffff812823aa>] sysfs_do_create_link_sd.isra.2+0xaa/0xb0
[ 1033.983279]  [<ffffffff812823d5>] sysfs_create_link+0x25/0x40
[ 1033.983282]  [<ffffffff81454a6b>] bus_add_device+0x10b/0x1f0
[ 1033.983284]  [<ffffffff81452815>] device_add+0x3b5/0x610
[ 1033.983287]  [<ffffffff81487df5>] scsi_sysfs_add_sdev+0xa5/0x290
[ 1033.983289]  [<ffffffff81485355>] scsi_probe_and_add_lun+0xb65/0xd80
[ 1033.983293]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[ 1033.983295]  [<ffffffff81485d67>] __scsi_scan_target+0xf7/0x260
[ 1033.983297]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[ 1033.983298]  [<ffffffff81485fa7>] scsi_scan_target+0xd7/0xf0
[ 1033.983306]  [<ffffffffa07c29f5>] iscsi_user_scan_session.part.14+0x105/0x140 [scsi_transport_iscsi]
[ 1033.983309]  [<ffffffffa07c2a30>] ? iscsi_user_scan_session.part.14+0x140/0x140 [scsi_transport_iscsi]
[ 1033.983313]  [<ffffffffa07c2a4e>] iscsi_user_scan_session+0x1e/0x30 [scsi_transport_iscsi]
[ 1033.983314]  [<ffffffff81450b80>] device_for_each_child+0x50/0x90
[ 1033.983318]  [<ffffffffa07c083d>] iscsi_user_scan+0x3d/0x60 [scsi_transport_iscsi]
[ 1033.983320]  [<ffffffff81487bb6>] store_scan+0xa6/0x100
[ 1033.983324]  [<ffffffff811e3158>] ? __kmalloc+0x1b8/0x250
[ 1033.983327]  [<ffffffff81450318>] dev_attr_store+0x18/0x30
[ 1033.983329]  [<ffffffff8128170a>] sysfs_kf_write+0x3a/0x50
[ 1033.983330]  [<ffffffff81280d90>] kernfs_fop_write+0x120/0x170
[ 1033.983332]  [<ffffffff81203f17>] __vfs_write+0x37/0x100
[ 1033.983335]  [<ffffffff812b6c03>] ? selinux_file_permission+0xc3/0x110
[ 1033.983338]  [<ffffffff812ae75d>] ? security_file_permission+0x3d/0xc0
[ 1033.983341]  [<ffffffff810cd95f>] ? percpu_down_read+0x1f/0x50
[ 1033.983342]  [<ffffffff812045f2>] vfs_write+0xa2/0x1a0
[ 1033.983345]  [<ffffffff81003176>] ? do_audit_syscall_entry+0x66/0x70
[ 1033.983346]  [<ffffffff812053b5>] SyS_write+0x55/0xc0
[ 1033.983349]  [<ffffffff816945ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1033.983350] ---[ end trace bcfb1475313b5f63 ]---
[ 1033.983379] scsi 7:0:0:0: failed to add device: -17
[ 1035.052654] scsi 7:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[ 1035.052938] ------------[ cut here ]------------
[ 1035.052943] WARNING: CPU: 1 PID: 10583 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
[ 1035.052944] sysfs: cannot create duplicate filename '/bus/scsi/devices/7:0:0:0'
[ 1035.052945] Modules linked in: target_core_pscsi target_core_file target_core_iblock xt_REDIRECT nf_nat_redirect xt_nat xt_mark xt_CHECKSUM nf_conntrack_ipv6 xt_mac xt_physdev xt_set xt_conntrack iptable_raw ip_set_hash_net ip_set nfnetlink veth ebtable_filter ebtables ip6table_filter ip6_tables iscsi_tcp libiscsi_tcp 8021q garp mrp rpcrdma ib_isert iscsi_target_mod bonding ib_iser libiscsi scsi_transport_iscsi openvswitch ib_srpt target_core_mod nf_defrag_ipv6 ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm xt_comment xt_multiport ib_sa iptable_filter ib_mad iptable_nat nf_conntrack_ipv4 usnic_verbs nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ib_core ib_addr iptable_mangle x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
  crct10dif_pclmul
[ 1035.052976]  crc32_pclmul aesni_intel nfsd lrw gf128mul glue_helper ablk_helper ses cryptd enclosure ipmi_devintf sg sb_edac iTCO_wdt shpchp edac_core iTCO_vendor_support ipmi_si pcspkr lpc_ich ipmi_msghandler mfd_core auth_rpcgss acpi_power_meter wmi nfs_acl lockd br_netfilter grace sunrpc bridge stp llc dm_multipath ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm ixgbe(O) fnic i40e libfcoe igb crc32c_intel megaraid_sas enic libfc vxlan ip6_udp_tunnel udp_tunnel ptp scsi_transport_fc i2c_algo_bit i2c_core pps_core dca dm_mirror dm_region_hash dm_log dm_mod
[ 1035.053043] CPU: 1 PID: 10583 Comm: iscsiadm Tainted: G        W  O    4.4.0 #1
[ 1035.053044] Hardware name: Cisco Systems Inc UCSC-C240-M3S/UCSC-C240-M3S, BIOS C240M3.2.0.8.0.071620152208 07/16/2015
[ 1035.053045]  0000000000000000 00000000acef2a8b ffff882e7b603948 ffffffff81329090
[ 1035.053047]  ffff882e7b603990 ffff882e7b603980 ffffffff810862c6 ffff882e793b5000
[ 1035.053049]  ffff882f9feaa880 ffff885fa5329e10 0000000000000001 ffffffffffffffef
[ 1035.053050] Call Trace:
[ 1035.053056]  [<ffffffff81329090>] dump_stack+0x44/0x64
[ 1035.053058]  [<ffffffff810862c6>] warn_slowpath_common+0x86/0xc0
[ 1035.053060]  [<ffffffff8108635c>] warn_slowpath_fmt+0x5c/0x80
[ 1035.053063]  [<ffffffff8127e9a8>] ? kernfs_path+0x48/0x60
[ 1035.053064]  [<ffffffff81282014>] sysfs_warn_dup+0x64/0x80
[ 1035.053066]  [<ffffffff812823aa>] sysfs_do_create_link_sd.isra.2+0xaa/0xb0
[ 1035.053068]  [<ffffffff812823d5>] sysfs_create_link+0x25/0x40
[ 1035.053071]  [<ffffffff81454a6b>] bus_add_device+0x10b/0x1f0
[ 1035.053073]  [<ffffffff81452815>] device_add+0x3b5/0x610
[ 1035.053076]  [<ffffffff81487df5>] scsi_sysfs_add_sdev+0xa5/0x290
[ 1035.053078]  [<ffffffff81485355>] scsi_probe_and_add_lun+0xb65/0xd80
[ 1035.053082]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[ 1035.053084]  [<ffffffff81485d67>] __scsi_scan_target+0xf7/0x260
[ 1035.053085]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[ 1035.053087]  [<ffffffff81485fa7>] scsi_scan_target+0xd7/0xf0
[ 1035.053094]  [<ffffffffa07c29f5>] iscsi_user_scan_session.part.14+0x105/0x140 [scsi_transport_iscsi]
[ 1035.053097]  [<ffffffffa07c2a30>] ? iscsi_user_scan_session.part.14+0x140/0x140 [scsi_transport_iscsi]
[ 1035.053101]  [<ffffffffa07c2a4e>] iscsi_user_scan_session+0x1e/0x30 [scsi_transport_iscsi]
[ 1035.053102]  [<ffffffff81450b80>] device_for_each_child+0x50/0x90
[ 1035.053106]  [<ffffffffa07c083d>] iscsi_user_scan+0x3d/0x60 [scsi_transport_iscsi]
[ 1035.053108]  [<ffffffff81487bb6>] store_scan+0xa6/0x100
[ 1035.053111]  [<ffffffff811e3158>] ? __kmalloc+0x1b8/0x250
[ 1035.053115]  [<ffffffff81450318>] dev_attr_store+0x18/0x30
[ 1035.053116]  [<ffffffff8128170a>] sysfs_kf_write+0x3a/0x50
[ 1035.053118]  [<ffffffff81280d90>] kernfs_fop_write+0x120/0x170
[ 1035.053120]  [<ffffffff81203f17>] __vfs_write+0x37/0x100
[ 1035.053122]  [<ffffffff812b6c03>] ? selinux_file_permission+0xc3/0x110
[ 1035.053126]  [<ffffffff812ae75d>] ? security_file_permission+0x3d/0xc0
[ 1035.053129]  [<ffffffff810cd95f>] ? percpu_down_read+0x1f/0x50
[ 1035.053130]  [<ffffffff812045f2>] vfs_write+0xa2/0x1a0
[ 1035.053132]  [<ffffffff81003176>] ? do_audit_syscall_entry+0x66/0x70
[ 1035.053134]  [<ffffffff812053b5>] SyS_write+0x55/0xc0
[ 1035.053137]  [<ffffffff816945ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1035.053138] ---[ end trace bcfb1475313b5f64 ]---
[ 1035.053185] scsi 7:0:0:0: failed to add device: -17
[ 1039.129111] scsi 7:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[ 1039.129445] ------------[ cut here ]------------
[ 1039.129450] WARNING: CPU: 1 PID: 10604 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
[ 1039.129451] sysfs: cannot create duplicate filename '/bus/scsi/devices/7:0:0:0'
[ 1039.129452] Modules linked in: target_core_pscsi target_core_file target_core_iblock xt_REDIRECT nf_nat_redirect xt_nat xt_mark xt_CHECKSUM nf_conntrack_ipv6 xt_mac xt_physdev xt_set xt_conntrack iptable_raw ip_set_hash_net ip_set nfnetlink veth ebtable_filter ebtables ip6table_filter ip6_tables iscsi_tcp libiscsi_tcp 8021q garp mrp rpcrdma ib_isert iscsi_target_mod bonding ib_iser libiscsi scsi_transport_iscsi openvswitch ib_srpt target_core_mod nf_defrag_ipv6 ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm xt_comment xt_multiport ib_sa iptable_filter ib_mad iptable_nat nf_conntrack_ipv4 usnic_verbs nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ib_core ib_addr iptable_mangle x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
  crct10dif_pclmul
[ 1039.129483]  crc32_pclmul aesni_intel nfsd lrw gf128mul glue_helper ablk_helper ses cryptd enclosure ipmi_devintf sg sb_edac iTCO_wdt shpchp edac_core iTCO_vendor_support ipmi_si pcspkr lpc_ich ipmi_msghandler mfd_core auth_rpcgss acpi_power_meter wmi nfs_acl lockd br_netfilter grace sunrpc bridge stp llc dm_multipath ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm ixgbe(O) fnic i40e libfcoe igb crc32c_intel megaraid_sas enic libfc vxlan ip6_udp_tunnel udp_tunnel ptp scsi_transport_fc i2c_algo_bit i2c_core pps_core dca dm_mirror dm_region_hash dm_log dm_mod
[ 1039.129513] CPU: 1 PID: 10604 Comm: iscsiadm Tainted: G        W  O    4.4.0 #1
[ 1039.129514] Hardware name: Cisco Systems Inc UCSC-C240-M3S/UCSC-C240-M3S, BIOS C240M3.2.0.8.0.071620152208 07/16/2015
[ 1039.129515]  0000000000000000 00000000c52587c8 ffff885fa5c9b948 ffffffff81329090
[ 1039.129517]  ffff885fa5c9b990 ffff885fa5c9b980 ffffffff810862c6 ffff882e793b5000
[ 1039.129519]  ffff882f9fb97fa8 ffff885fa5329e10 0000000000000001 ffffffffffffffef
[ 1039.129530] Call Trace:
[ 1039.129535]  [<ffffffff81329090>] dump_stack+0x44/0x64
[ 1039.129538]  [<ffffffff810862c6>] warn_slowpath_common+0x86/0xc0
[ 1039.129539]  [<ffffffff8108635c>] warn_slowpath_fmt+0x5c/0x80
[ 1039.129542]  [<ffffffff8127e9a8>] ? kernfs_path+0x48/0x60
[ 1039.129544]  [<ffffffff81282014>] sysfs_warn_dup+0x64/0x80
[ 1039.129545]  [<ffffffff812823aa>] sysfs_do_create_link_sd.isra.2+0xaa/0xb0
[ 1039.129547]  [<ffffffff812823d5>] sysfs_create_link+0x25/0x40
[ 1039.129550]  [<ffffffff81454a6b>] bus_add_device+0x10b/0x1f0
[ 1039.129552]  [<ffffffff81452815>] device_add+0x3b5/0x610
[ 1039.129555]  [<ffffffff81487df5>] scsi_sysfs_add_sdev+0xa5/0x290
[ 1039.129557]  [<ffffffff81485355>] scsi_probe_and_add_lun+0xb65/0xd80
[ 1039.129561]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[ 1039.129562]  [<ffffffff81485d67>] __scsi_scan_target+0xf7/0x260
[ 1039.129564]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[ 1039.129566]  [<ffffffff81485fa7>] scsi_scan_target+0xd7/0xf0
[ 1039.129573]  [<ffffffffa07c29f5>] iscsi_user_scan_session.part.14+0x105/0x140 [scsi_transport_iscsi]
[ 1039.129576]  [<ffffffffa07c2a30>] ? iscsi_user_scan_session.part.14+0x140/0x140 [scsi_transport_iscsi]
[ 1039.129580]  [<ffffffffa07c2a4e>] iscsi_user_scan_session+0x1e/0x30 [scsi_transport_iscsi]
[ 1039.129581]  [<ffffffff81450b80>] device_for_each_child+0x50/0x90
[ 1039.129585]  [<ffffffffa07c083d>] iscsi_user_scan+0x3d/0x60 [scsi_transport_iscsi]
[ 1039.129587]  [<ffffffff81487bb6>] store_scan+0xa6/0x100
[ 1039.129591]  [<ffffffff811e3158>] ? __kmalloc+0x1b8/0x250
[ 1039.129594]  [<ffffffff81450318>] dev_attr_store+0x18/0x30
[ 1039.129596]  [<ffffffff8128170a>] sysfs_kf_write+0x3a/0x50
[ 1039.129597]  [<ffffffff81280d90>] kernfs_fop_write+0x120/0x170
[ 1039.129599]  [<ffffffff81203f17>] __vfs_write+0x37/0x100
[ 1039.129602]  [<ffffffff812b6c03>] ? selinux_file_permission+0xc3/0x110
[ 1039.129605]  [<ffffffff812ae75d>] ? security_file_permission+0x3d/0xc0
[ 1039.129607]  [<ffffffff810cd95f>] ? percpu_down_read+0x1f/0x50
[ 1039.129609]  [<ffffffff812045f2>] vfs_write+0xa2/0x1a0
[ 1039.129611]  [<ffffffff81003176>] ? do_audit_syscall_entry+0x66/0x70
[ 1039.129612]  [<ffffffff812053b5>] SyS_write+0x55/0xc0
[ 1039.129615]  [<ffffffff816945ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1039.129616] ---[ end trace bcfb1475313b5f65 ]---
[ 1039.129638] scsi 7:0:0:0: failed to add device: -17
[ 1048.204151] scsi 7:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[ 1048.204524] ------------[ cut here ]------------
[ 1048.204530] WARNING: CPU: 2 PID: 10624 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
[ 1048.204531] sysfs: cannot create duplicate filename '/bus/scsi/devices/7:0:0:0'
[ 1048.204532] Modules linked in: target_core_pscsi target_core_file target_core_iblock xt_REDIRECT nf_nat_redirect xt_nat xt_mark xt_CHECKSUM nf_conntrack_ipv6 xt_mac xt_physdev xt_set xt_conntrack iptable_raw ip_set_hash_net ip_set nfnetlink veth ebtable_filter ebtables ip6table_filter ip6_tables iscsi_tcp libiscsi_tcp 8021q garp mrp rpcrdma ib_isert iscsi_target_mod bonding ib_iser libiscsi scsi_transport_iscsi openvswitch ib_srpt target_core_mod nf_defrag_ipv6 ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm xt_comment xt_multiport ib_sa iptable_filter ib_mad iptable_nat nf_conntrack_ipv4 usnic_verbs nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ib_core ib_addr iptable_mangle x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
  crct10dif_pclmul
[ 1048.204564]  crc32_pclmul aesni_intel nfsd lrw gf128mul glue_helper ablk_helper ses cryptd enclosure ipmi_devintf sg sb_edac iTCO_wdt shpchp edac_core iTCO_vendor_support ipmi_si pcspkr lpc_ich ipmi_msghandler mfd_core auth_rpcgss acpi_power_meter wmi nfs_acl lockd br_netfilter grace sunrpc bridge stp llc dm_multipath ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm ixgbe(O) fnic i40e libfcoe igb crc32c_intel megaraid_sas enic libfc vxlan ip6_udp_tunnel udp_tunnel ptp scsi_transport_fc i2c_algo_bit i2c_core pps_core dca dm_mirror dm_region_hash dm_log dm_mod
[ 1048.204597] CPU: 2 PID: 10624 Comm: iscsiadm Tainted: G        W  O    4.4.0 #1
[ 1048.204599] Hardware name: Cisco Systems Inc UCSC-C240-M3S/UCSC-C240-M3S, BIOS C240M3.2.0.8.0.071620152208 07/16/2015
[ 1048.204600]  0000000000000000 0000000088d9f919 ffff882e7aa0b948 ffffffff81329090
[ 1048.204602]  ffff882e7aa0b990 ffff882e7aa0b980 ffffffff810862c6 ffff882e7b4f1000
[ 1048.204604]  ffff885f9f16f2c8 ffff885fa5329e10 0000000000000001 ffffffffffffffef
[ 1048.204605] Call Trace:
[ 1048.204612]  [<ffffffff81329090>] dump_stack+0x44/0x64
[ 1048.204614]  [<ffffffff810862c6>] warn_slowpath_common+0x86/0xc0
[ 1048.204616]  [<ffffffff8108635c>] warn_slowpath_fmt+0x5c/0x80
[ 1048.204619]  [<ffffffff8127e9a8>] ? kernfs_path+0x48/0x60
[ 1048.204620]  [<ffffffff81282014>] sysfs_warn_dup+0x64/0x80
[ 1048.204622]  [<ffffffff812823aa>] sysfs_do_create_link_sd.isra.2+0xaa/0xb0
[ 1048.204624]  [<ffffffff812823d5>] sysfs_create_link+0x25/0x40
[ 1048.204627]  [<ffffffff81454a6b>] bus_add_device+0x10b/0x1f0
[ 1048.204628]  [<ffffffff81452815>] device_add+0x3b5/0x610
[ 1048.204632]  [<ffffffff81487df5>] scsi_sysfs_add_sdev+0xa5/0x290
[ 1048.204634]  [<ffffffff81485355>] scsi_probe_and_add_lun+0xb65/0xd80
[ 1048.204638]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[ 1048.204640]  [<ffffffff81485d67>] __scsi_scan_target+0xf7/0x260
[ 1048.204641]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[ 1048.204643]  [<ffffffff81485fa7>] scsi_scan_target+0xd7/0xf0
[ 1048.204651]  [<ffffffffa07c29f5>] iscsi_user_scan_session.part.14+0x105/0x140 [scsi_transport_iscsi]
[ 1048.204654]  [<ffffffffa07c2a30>] ? iscsi_user_scan_session.part.14+0x140/0x140 [scsi_transport_iscsi]
[ 1048.204658]  [<ffffffffa07c2a4e>] iscsi_user_scan_session+0x1e/0x30 [scsi_transport_iscsi]
[ 1048.204659]  [<ffffffff81450b80>] device_for_each_child+0x50/0x90
[ 1048.204663]  [<ffffffffa07c083d>] iscsi_user_scan+0x3d/0x60 [scsi_transport_iscsi]
[ 1048.204665]  [<ffffffff81487bb6>] store_scan+0xa6/0x100
[ 1048.204669]  [<ffffffff811e3158>] ? __kmalloc+0x1b8/0x250
[ 1048.204673]  [<ffffffff81450318>] dev_attr_store+0x18/0x30
[ 1048.204674]  [<ffffffff8128170a>] sysfs_kf_write+0x3a/0x50
[ 1048.204676]  [<ffffffff81280d90>] kernfs_fop_write+0x120/0x170
[ 1048.204678]  [<ffffffff81203f17>] __vfs_write+0x37/0x100
[ 1048.204680]  [<ffffffff812b6c03>] ? selinux_file_permission+0xc3/0x110
[ 1048.204684]  [<ffffffff812ae75d>] ? security_file_permission+0x3d/0xc0
[ 1048.204687]  [<ffffffff810cd95f>] ? percpu_down_read+0x1f/0x50
[ 1048.204688]  [<ffffffff812045f2>] vfs_write+0xa2/0x1a0
[ 1048.204690]  [<ffffffff81003176>] ? do_audit_syscall_entry+0x66/0x70
[ 1048.204692]  [<ffffffff812053b5>] SyS_write+0x55/0xc0
[ 1048.204695]  [<ffffffff816945ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1048.204697] ---[ end trace bcfb1475313b5f66 ]---
[ 1048.204719] scsi 7:0:0:0: failed to add device: -17
[ 1064.276300] scsi 7:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[ 1064.276598] ------------[ cut here ]------------
[ 1064.276603] WARNING: CPU: 1 PID: 10652 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
[ 1064.276604] sysfs: cannot create duplicate filename '/bus/scsi/devices/7:0:0:0'
[ 1064.276604] Modules linked in: target_core_pscsi target_core_file target_core_iblock xt_REDIRECT nf_nat_redirect xt_nat xt_mark xt_CHECKSUM nf_conntrack_ipv6 xt_mac xt_physdev xt_set xt_conntrack iptable_raw ip_set_hash_net ip_set nfnetlink veth ebtable_filter ebtables ip6table_filter ip6_tables iscsi_tcp libiscsi_tcp 8021q garp mrp rpcrdma ib_isert iscsi_target_mod bonding ib_iser libiscsi scsi_transport_iscsi openvswitch ib_srpt target_core_mod nf_defrag_ipv6 ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm xt_comment xt_multiport ib_sa iptable_filter ib_mad iptable_nat nf_conntrack_ipv4 usnic_verbs nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ib_core ib_addr iptable_mangle x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
  crct10dif_pclmul
[ 1064.276649]  crc32_pclmul aesni_intel nfsd lrw gf128mul glue_helper ablk_helper ses cryptd enclosure ipmi_devintf sg sb_edac iTCO_wdt shpchp edac_core iTCO_vendor_support ipmi_si pcspkr lpc_ich ipmi_msghandler mfd_core auth_rpcgss acpi_power_meter wmi nfs_acl lockd br_netfilter grace sunrpc bridge stp llc dm_multipath ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm ixgbe(O) fnic i40e libfcoe igb crc32c_intel megaraid_sas enic libfc vxlan ip6_udp_tunnel udp_tunnel ptp scsi_transport_fc i2c_algo_bit i2c_core pps_core dca dm_mirror dm_region_hash dm_log dm_mod
[ 1064.276682] CPU: 1 PID: 10652 Comm: iscsiadm Tainted: G        W  O    4.4.0 #1
[ 1064.276683] Hardware name: Cisco Systems Inc UCSC-C240-M3S/UCSC-C240-M3S, BIOS C240M3.2.0.8.0.071620152208 07/16/2015
[ 1064.276684]  0000000000000000 0000000080e19618 ffff882e7aa0b948 ffffffff81329090
[ 1064.276686]  ffff882e7aa0b990 ffff882e7aa0b980 ffffffff810862c6 ffff882f9fed7000
[ 1064.276688]  ffff885f9f16f2d0 ffff885fa5329e10 0000000000000001 ffffffffffffffef
[ 1064.276689] Call Trace:
[ 1064.276695]  [<ffffffff81329090>] dump_stack+0x44/0x64
[ 1064.276698]  [<ffffffff810862c6>] warn_slowpath_common+0x86/0xc0
[ 1064.276700]  [<ffffffff8108635c>] warn_slowpath_fmt+0x5c/0x80
[ 1064.276703]  [<ffffffff8127e9a8>] ? kernfs_path+0x48/0x60
[ 1064.276704]  [<ffffffff81282014>] sysfs_warn_dup+0x64/0x80
[ 1064.276706]  [<ffffffff812823aa>] sysfs_do_create_link_sd.isra.2+0xaa/0xb0
[ 1064.276708]  [<ffffffff812823d5>] sysfs_create_link+0x25/0x40
[ 1064.276711]  [<ffffffff81454a6b>] bus_add_device+0x10b/0x1f0
[ 1064.276712]  [<ffffffff81452815>] device_add+0x3b5/0x610
[ 1064.276716]  [<ffffffff81487df5>] scsi_sysfs_add_sdev+0xa5/0x290
[ 1064.276718]  [<ffffffff81485355>] scsi_probe_and_add_lun+0xb65/0xd80
[ 1064.276722]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[ 1064.276724]  [<ffffffff81485d67>] __scsi_scan_target+0xf7/0x260
[ 1064.276725]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[ 1064.276727]  [<ffffffff81485fa7>] scsi_scan_target+0xd7/0xf0
[ 1064.276734]  [<ffffffffa07c29f5>] iscsi_user_scan_session.part.14+0x105/0x140 [scsi_transport_iscsi]
[ 1064.276738]  [<ffffffffa07c2a30>] ? iscsi_user_scan_session.part.14+0x140/0x140 [scsi_transport_iscsi]
[ 1064.276742]  [<ffffffffa07c2a4e>] iscsi_user_scan_session+0x1e/0x30 [scsi_transport_iscsi]
[ 1064.276743]  [<ffffffff81450b80>] device_for_each_child+0x50/0x90
[ 1064.276747]  [<ffffffffa07c083d>] iscsi_user_scan+0x3d/0x60 [scsi_transport_iscsi]
[ 1064.276749]  [<ffffffff81487bb6>] store_scan+0xa6/0x100
[ 1064.276753]  [<ffffffff811e3158>] ? __kmalloc+0x1b8/0x250
[ 1064.276757]  [<ffffffff81450318>] dev_attr_store+0x18/0x30
[ 1064.276759]  [<ffffffff8128170a>] sysfs_kf_write+0x3a/0x50
[ 1064.276760]  [<ffffffff81280d90>] kernfs_fop_write+0x120/0x170
[ 1064.276762]  [<ffffffff81203f17>] __vfs_write+0x37/0x100
[ 1064.276765]  [<ffffffff812b6c03>] ? selinux_file_permission+0xc3/0x110
[ 1064.276769]  [<ffffffff812ae75d>] ? security_file_permission+0x3d/0xc0
[ 1064.276772]  [<ffffffff810cd95f>] ? percpu_down_read+0x1f/0x50
[ 1064.276773]  [<ffffffff812045f2>] vfs_write+0xa2/0x1a0
[ 1064.276776]  [<ffffffff81003176>] ? do_audit_syscall_entry+0x66/0x70
[ 1064.276777]  [<ffffffff812053b5>] SyS_write+0x55/0xc0
[ 1064.276780]  [<ffffffff816945ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1064.276781] ---[ end trace bcfb1475313b5f67 ]---
[ 1064.276817] scsi 7:0:0:0: failed to add device: -17


                                                               

Thank you

Serguei


-----Original Message-----
From: Michael Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Friday, January 29, 2016 3:02 AM
To: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>
Cc: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets

Can you send me your lio config?

Are you running lio on the same box as the initiator so it is also changing kernel version with each test?

It looks like the scsi scan code is not handling the lack of LUN 0 correctly. I think I know what patch is causing it, but cannot get my lio config to return the same info as you for the non existent LUNs, so I think I am hitting slightly different error paths.


> On Jan 28, 2016, at 8:55 PM, Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com> wrote:
> 
> HI Mike,
> 
> Thank you for looking into this issue.
> I reproduced this issue  this using both mainline compiled kernel and the one posted by El Repo.  I used both of these kernels with RHEL 7.2, both kernels showed exactly the same issue. When I rollback to the original kernel 3.10.0-327.4.4, I do not see the issue.
> 
> As per your request attaching kernel config file. Please let me know if you need any additional info or if you want to take a look at the router, I can setup a webex meeting to show you the issue.
> 
> Thank you
> 
> Serguei
> 
> 
> 
> 
> Serguei Bezverkhi,
> TECHNICAL LEADER.SERVICES
> Global SP Services
> sbezverk@cisco.com
> Phone: +1 416 306 7312
> Mobile: +1 514 234 7374
> 
> CCIE (R&S,SP,Sec) - #9527
> 
> Cisco.com
> 
> 
> 
>  Think before you print.
> This email may contain confidential and privileged material for the sole use of the intended recipient. Any review, use, distribution or disclosure by others is strictly prohibited. If you are not the intended recipient (or authorized to receive for the recipient), please contact the sender by reply email and delete all copies of this message.
> Please click here for Company Registration Information.
> 
> 
> 
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mike Christie
> Sent: Thursday, January 28, 2016 8:53 PM
> To: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org
> Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
> 
> On 01/28/2016 04:51 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=111441
>> 
>>            Bug ID: 111441
>>           Summary: iscsi fails to attach to targets
>>           Product: IO/Storage
>>           Version: 2.5
>>    Kernel Version: 4.4.0-1
>>          Hardware: x86-64
>>                OS: Linux
>>              Tree: Mainline
>>            Status: NEW
> 
> 
>> 4.4.0-1.el7.elrepo.x86_64 #1
> 
> I have not seen this oops before. We saw similar ones around 5 or 6 years ago, but they were due to some sysfs or block or scsi issue (I cannot remember exacty) and fixed there.
> 
> Is this a distro kernel or mainline. BZ says mainline, but the kernel name in bug looks like a red hat related one. Where did you get it?
> 
> I do not hit this in 4.4 mainline. Send me your kernel .config, so I can make sure I have the same options.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
