From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111441] iscsi fails to attach to targets
Date: Fri, 29 Jan 2016 03:32:41 +0000
Message-ID: <bug-111441-11613-YJB4zFCAjW@https.bugzilla.kernel.org/>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60017 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbcA2Dcu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 22:32:50 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9576D20340
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2016 03:32:47 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4045F20361
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2016 03:32:42 +0000 (UTC)
In-Reply-To: <bug-111441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111441

--- Comment #3 from Serguei Bezverkhi <sbezverk@cisco.com> ---
Additional tracebacks:

[   25.799382] WARNING: CPU: 18 PID: 1482 at block/genhd.c:626
add_disk+0x443/0x4a0()
[   25.799383] Modules linked in: iscsi_tcp libiscsi_tcp 8021q garp mrp rpcrdma
ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt
target_core_mod openvswitch bonding ib_srp scsi_transport_srp ib_ipoib
nf_defrag_ipv6 rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_sa
ib_mad usnic_verbs ib_core xt_comment xt_multiport iptable_filter ib_addr
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 x86_pkg_temp_thermal nf_nat_ipv4
intel_powerclamp nf_nat coretemp kvm_intel nf_conntrack kvm iptable_mangle
irqbypass crct10dif_pclmul crc32_pclmul nfsd aesni_intel lrw gf128mul
glue_helper ablk_helper cryptd ses enclosure sb_edac sg auth_rpcgss edac_core
iTCO_wdt ipmi_devintf iTCO_vendor_support nfs_acl lockd shpchp pcspkr lpc_ich
ipmi_si ipmi_msghandler mfd_core wmi acpi_power_meter grace
[   25.799435]  sunrpc br_netfilter bridge stp llc dm_multipath ip_tables xfs
libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops ttm ixgbe(O) drm fnic i40e libfcoe igb megaraid_sas enic libfc
crc32c_intel vxlan ip6_udp_tunnel udp_tunnel ptp scsi_transport_fc i2c_algo_bit
dca i2c_core pps_core dm_mirror dm_region_hash dm_log dm_mod
[   25.799462] CPU: 18 PID: 1482 Comm: kworker/u82:3 Tainted: G           O   
4.4.0 #1
[   25.799464] Hardware name: Cisco Systems Inc UCSC-C240-M3S/UCSC-C240-M3S,
BIOS C240M3.2.0.8.0.071620152208 07/16/2015
[   25.799470] Workqueue: events_unbound async_run_entry_fn
[   25.799473]  0000000000000000 00000000866f6387 ffff885f9d34bcf8
ffffffff81329090
[   25.799476]  0000000000000000 ffff885f9d34bd30 ffffffff810862c6
ffff885e6c3a8800
[   25.799478]  ffff885e6c3a8880 ffff885f9c59ea80 ffff885e6c3a880c
ffff885e6bc78000
[   25.799481] Call Trace:
[   25.799492]  [<ffffffff81329090>] dump_stack+0x44/0x64
[   25.799496]  [<ffffffff810862c6>] warn_slowpath_common+0x86/0xc0
[   25.799499]  [<ffffffff8108640a>] warn_slowpath_null+0x1a/0x20
[   25.799502]  [<ffffffff8130ef23>] add_disk+0x443/0x4a0
[   25.799508]  [<ffffffffa0086a35>] sd_probe_async+0x115/0x1d0 [sd_mod]
[   25.799511]  [<ffffffff810a70fa>] async_run_entry_fn+0x4a/0x140
[   25.799515]  [<ffffffff8109e09c>] process_one_work+0x14c/0x3c0
[   25.799517]  [<ffffffff8109e8d4>] worker_thread+0x114/0x470
[   25.799520]  [<ffffffff8109e7c0>] ? rescuer_thread+0x310/0x310
[   25.799524]  [<ffffffff810a43d8>] kthread+0xd8/0xf0
[   25.799527]  [<ffffffff810a4300>] ? kthread_park+0x60/0x60
[   25.799532]  [<ffffffff8169490f>] ret_from_fork+0x3f/0x70
[   25.799535]  [<ffffffff810a4300>] ? kthread_park+0x60/0x60
[   25.799538] ---[ end trace 5d59079faf7d2510 ]---
[   25.799568] sd 3:0:0:2: [sdc] Attached SCSI disk
[   25.808827] scsi 3:0:0:0: Unexpected response from lun 2 while scanning,
scan aborted
[   25.810073] scsi host6: iSCSI Initiator over TCP/IP
[   25.811250] scsi 4:0:0:3: Direct-Access     LIO-ORG  san-disk-3       4.0 
PQ: 0 ANSI: 5
[   25.811776] sd 4:0:0:3: alua: supports implicit and explicit TPGS
[   25.811914] sd 4:0:0:3: [sdd] 9765625856 512-byte logical blocks: (5.00
TB/4.54 TiB)
[   25.811958] sd 4:0:0:3: alua: No target port descriptors found
[   25.811961] sd 4:0:0:3: alua: Attach failed (-22)
[   25.811964] sd 4:0:0:3: failed to add device handler: -22
[   25.812001] sd 4:0:0:3: [sdd] Write Protect is off
[   25.812005] sd 4:0:0:3: [sdd] Mode Sense: 00 00 00 00
[   25.812009] sd 4:0:0:3: [sdd] Asking for cache data failed
[   25.812011] sd 4:0:0:3: [sdd] Assuming drive cache: write through
[   25.815398] sd 4:0:0:3: [sdd] Attached SCSI disk
[   25.819131] ixgbe 0000:04:00.1: SR-IOV enabled with 8 VFs
[   25.819134] ixgbe 0000:04:00.1: configure port vlans to keep your VFs secure
[   25.824709] scsi 4:0:0:0: Unexpected response from lun 3 while scanning,
scan aborted
[   25.832694] scsi 6:0:0:4: Direct-Access     LIO-ORG  san-disk-4       4.0 
PQ: 0 ANSI: 5
[   25.832921] scsi 5:0:0:1: Direct-Access     LIO-ORG  san-disk-1       4.0 
PQ: 0 ANSI: 5
[   25.833195] sd 6:0:0:4: alua: supports implicit and explicit TPGS
[   25.833360] sd 6:0:0:4: alua: No target port descriptors found
[   25.833363] sd 6:0:0:4: alua: Attach failed (-22)
[   25.833365] sd 6:0:0:4: failed to add device handler: -22
[   25.833394] sd 5:0:0:1: alua: supports implicit and explicit TPGS
[   25.851814] sd 6:0:0:4: [sde] 10742171648 512-byte logical blocks: (5.49
TB/5.00 TiB)
[   25.851820] sd 5:0:0:1: [sdf] 7812499389 512-byte logical blocks: (3.99
TB/3.63 TiB)
[   25.851821] sd 6:0:0:4: [sde] Write Protect is off
[   25.851823] sd 6:0:0:4: [sde] Mode Sense: 00 00 00 00
[   25.851825] sd 6:0:0:4: [sde] Asking for cache data failed
[   25.851827] sd 6:0:0:4: [sde] Assuming drive cache: write through
[   25.851843] sd 5:0:0:1: alua: No target port descriptors found
[   25.851847] sd 5:0:0:1: alua: Attach failed (-22)
[   25.851849] sd 5:0:0:1: failed to add device handler: -22
[   25.851946] sd 5:0:0:1: [sdf] Write Protect is off
[   25.851948] sd 5:0:0:1: [sdf] Mode Sense: 00 00 00 00
[   25.851949] sd 5:0:0:1: [sdf] Asking for cache data failed
[   25.851951] sd 5:0:0:1: [sdf] Assuming drive cache: write through
[   25.852160] sd 6:0:0:4: [sde] Attached SCSI disk
[   25.852172] sd 5:0:0:1: [sdf] Attached SCSI disk
[   25.854892] scsi 6:0:0:0: Unexpected response from lun 4 while scanning,
scan aborted
[   25.862806] scsi 5:0:0:0: Unexpected response from lun 1 while scanning,
scan aborted
[   25.890721] ixgbe 0000:04:00.0 enp4s0f0: detected SFP+: 7
[   25.919701] pci 0000:04:10.1: [8086:10ed] type 00 class 0x020000
[   25.919738] pci 0000:04:10.1: can't set Max Payload Size to 256; if
necessary, use "pci=pcie_bus_safe" and report a bug
[   25.919863] iommu: Adding device 0000:04:10.1 to group 88
[   25.919920] pci 0000:04:10.3: [8086:10ed] type 00 class 0x020000
[   25.919951] pci 0000:04:10.3: can't set Max Payload Size to 256; if
necessary, use "pci=pcie_bus_safe" and report a bug
[   25.920013] iommu: Adding device 0000:04:10.3 to group 89
[   25.920039] pci 0000:04:10.5: [8086:10ed] type 00 class 0x020000
[   25.920069] pci 0000:04:10.5: can't set Max Payload Size to 256; if
necessary, use "pci=pcie_bus_safe" and report a bug
[   25.920127] iommu: Adding device 0000:04:10.5 to group 90
[   25.920151] pci 0000:04:10.7: [8086:10ed] type 00 class 0x020000
[   25.920182] pci 0000:04:10.7: can't set Max Payload Size to 256; if
necessary, use "pci=pcie_bus_safe" and report a bug
[   25.920239] iommu: Adding device 0000:04:10.7 to group 91
[   25.920263] pci 0000:04:11.1: [8086:10ed] type 00 class 0x020000
[   25.920293] pci 0000:04:11.1: can't set Max Payload Size to 256; if
necessary, use "pci=pcie_bus_safe" and report a bug
[   25.920349] iommu: Adding device 0000:04:11.1 to group 92
[   25.920373] pci 0000:04:11.3: [8086:10ed] type 00 class 0x020000
[   25.920403] pci 0000:04:11.3: can't set Max Payload Size to 256; if
necessary, use "pci=pcie_bus_safe" and report a bug
[   25.920459] iommu: Adding device 0000:04:11.3 to group 93
[   25.920485] pci 0000:04:11.5: [8086:10ed] type 00 class 0x020000
[   25.920515] pci 0000:04:11.5: can't set Max Payload Size to 256; if
necessary, use "pci=pcie_bus_safe" and report a bug
[   25.920570] iommu: Adding device 0000:04:11.5 to group 94
[   25.920594] pci 0000:04:11.7: [8086:10ed] type 00 class 0x020000
[   25.920624] pci 0000:04:11.7: can't set Max Payload Size to 256; if
necessary, use "pci=pcie_bus_safe" and report a bug
[   25.920698] iommu: Adding device 0000:04:11.7 to group 95
[   25.921365] ixgbe 0000:04:00.1: removed PHC on enp4s0f1
[   26.020448] ixgbe 0000:04:00.1: registered PHC device on enp4s0f1
[   26.185674] ixgbe 0000:04:00.1 enp4s0f1: detected SFP+: 4
[   26.380954] i40e 0000:06:00.0 enp6s0f0: adding 68:05:ca:37:26:90 vid=0
[   26.392266] i40e 0000:06:00.0: Allocating 8 VFs.
[   26.492733] pci 0000:06:02.0: [8086:154c] type 00 class 0x020000
[   26.492785] pci 0000:06:02.0: Max Payload Size set to 256 (was 128, max
2048)
[   26.493016] iommu: Adding device 0000:06:02.0 to group 96
[   26.493114] pci 0000:06:02.1: [8086:154c] type 00 class 0x020000
[   26.493159] pci 0000:06:02.1: Max Payload Size set to 256 (was 128, max
2048)
[   26.493259] iommu: Adding device 0000:06:02.1 to group 97
[   26.493309] pci 0000:06:02.2: [8086:154c] type 00 class 0x020000
[   26.493352] pci 0000:06:02.2: Max Payload Size set to 256 (was 128, max
2048)
[   26.493452] iommu: Adding device 0000:06:02.2 to group 98
[   26.493501] pci 0000:06:02.3: [8086:154c] type 00 class 0x020000
[   26.493545] pci 0000:06:02.3: Max Payload Size set to 256 (was 128, max
2048)
[   26.493655] iommu: Adding device 0000:06:02.3 to group 99
[   26.493707] pci 0000:06:02.4: [8086:154c] type 00 class 0x020000
[   26.493751] pci 0000:06:02.4: Max Payload Size set to 256 (was 128, max
2048)
[   26.493856] iommu: Adding device 0000:06:02.4 to group 100
[   26.493902] pci 0000:06:02.5: [8086:154c] type 00 class 0x020000
[   26.493945] pci 0000:06:02.5: Max Payload Size set to 256 (was 128, max
2048)
[   26.494046] iommu: Adding device 0000:06:02.5 to group 101
[   26.494103] pci 0000:06:02.6: [8086:154c] type 00 class 0x020000
[   26.494147] pci 0000:06:02.6: Max Payload Size set to 256 (was 128, max
2048)
[   26.494247] iommu: Adding device 0000:06:02.6 to group 102
[   26.494295] pci 0000:06:02.7: [8086:154c] type 00 class 0x020000
[   26.494339] pci 0000:06:02.7: Max Payload Size set to 256 (was 128, max
2048)
[   26.494446] iommu: Adding device 0000:06:02.7 to group 103
[   26.977585] i40e 0000:06:00.1 enp6s0f1: adding 68:05:ca:37:26:91 vid=0
[   26.985175] i40e 0000:06:00.1: Allocating 8 VFs.
[   27.085659] pci 0000:06:0a.0: [8086:154c] type 00 class 0x020000
[   27.085704] pci 0000:06:0a.0: Max Payload Size set to 256 (was 128, max
2048)
[   27.085868] iommu: Adding device 0000:06:0a.0 to group 104
[   27.085938] pci 0000:06:0a.1: [8086:154c] type 00 class 0x020000
[   27.085977] pci 0000:06:0a.1: Max Payload Size set to 256 (was 128, max
2048)
[   27.086047] iommu: Adding device 0000:06:0a.1 to group 105
[   27.086076] pci 0000:06:0a.2: [8086:154c] type 00 class 0x020000
[   27.086114] pci 0000:06:0a.2: Max Payload Size set to 256 (was 128, max
2048)
[   27.086184] iommu: Adding device 0000:06:0a.2 to group 106
[   27.086213] pci 0000:06:0a.3: [8086:154c] type 00 class 0x020000
[   27.086251] pci 0000:06:0a.3: Max Payload Size set to 256 (was 128, max
2048)
[   27.086321] iommu: Adding device 0000:06:0a.3 to group 107
[   27.086349] pci 0000:06:0a.4: [8086:154c] type 00 class 0x020000
[   27.086386] pci 0000:06:0a.4: Max Payload Size set to 256 (was 128, max
2048)
[   27.086454] iommu: Adding device 0000:06:0a.4 to group 108
[   27.086485] pci 0000:06:0a.5: [8086:154c] type 00 class 0x020000
[   27.086533] pci 0000:06:0a.5: Max Payload Size set to 256 (was 128, max
2048)
[   27.086637] iommu: Adding device 0000:06:0a.5 to group 109
[   27.086674] pci 0000:06:0a.6: [8086:154c] type 00 class 0x020000
[   27.086732] pci 0000:06:0a.6: Max Payload Size set to 256 (was 128, max
2048)
[   27.086829] iommu: Adding device 0000:06:0a.6 to group 110
[   27.086860] pci 0000:06:0a.7: [8086:154c] type 00 class 0x020000
[   27.086908] pci 0000:06:0a.7: Max Payload Size set to 256 (was 128, max
2048)
[   27.087045] iommu: Adding device 0000:06:0a.7 to group 111
[   27.266965] device qg-3e44de10-3d left promiscuous mode
[   27.313043] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   27.545545] i40e 0000:83:00.0 enp131s0f0: adding 68:05:ca:3a:a3:60 vid=0
[   27.558666] i40e 0000:83:00.0: Allocating 8 VFs.
[   27.639645] device qr-912a3637-a9 left promiscuous mode
[   27.659650] pci 0000:83:02.0: [8086:154c] type 00 class 0x020000
[   27.659698] pci 0000:83:02.0: Max Payload Size set to 256 (was 128, max
2048)
[   27.659919] iommu: Adding device 0000:83:02.0 to group 112
[   27.660016] pci 0000:83:02.1: [8086:154c] type 00 class 0x020000
[   27.660055] pci 0000:83:02.1: Max Payload Size set to 256 (was 128, max
2048)
[   27.660146] iommu: Adding device 0000:83:02.1 to group 113
[   27.660191] pci 0000:83:02.2: [8086:154c] type 00 class 0x020000
[   27.660230] pci 0000:83:02.2: Max Payload Size set to 256 (was 128, max
2048)
[   27.660327] iommu: Adding device 0000:83:02.2 to group 114
[   27.660410] pci 0000:83:02.3: [8086:154c] type 00 class 0x020000
[   27.660449] pci 0000:83:02.3: Max Payload Size set to 256 (was 128, max
2048)
[   27.660537] iommu: Adding device 0000:83:02.3 to group 115
[   27.660584] pci 0000:83:02.4: [8086:154c] type 00 class 0x020000
[   27.660634] pci 0000:83:02.4: Max Payload Size set to 256 (was 128, max
2048)
[   27.660725] iommu: Adding device 0000:83:02.4 to group 116
[   27.660771] pci 0000:83:02.5: [8086:154c] type 00 class 0x020000
[   27.660809] pci 0000:83:02.5: Max Payload Size set to 256 (was 128, max
2048)
[   27.660901] iommu: Adding device 0000:83:02.5 to group 117
[   27.660950] pci 0000:83:02.6: [8086:154c] type 00 class 0x020000
[   27.660989] pci 0000:83:02.6: Max Payload Size set to 256 (was 128, max
2048)
[   27.661078] iommu: Adding device 0000:83:02.6 to group 118
[   27.661121] pci 0000:83:02.7: [8086:154c] type 00 class 0x020000
[   27.661160] pci 0000:83:02.7: Max Payload Size set to 256 (was 128, max
2048)
[   27.661246] iommu: Adding device 0000:83:02.7 to group 119
[   27.695063] Ebtables v2.0 registered
[   28.075814] i40e 0000:83:00.1 enp131s0f1: adding 68:05:ca:3a:a3:61 vid=0
[   28.086628] i40e 0000:83:00.1: Allocating 8 VFs.
[   28.108753] device qr-9cc0be6f-14 left promiscuous mode
[   28.187599] pci 0000:83:0a.0: [8086:154c] type 00 class 0x020000
[   28.187641] pci 0000:83:0a.0: Max Payload Size set to 256 (was 128, max
2048)
[   28.187813] iommu: Adding device 0000:83:0a.0 to group 120
[   28.187885] pci 0000:83:0a.1: [8086:154c] type 00 class 0x020000
[   28.187921] pci 0000:83:0a.1: Max Payload Size set to 256 (was 128, max
2048)
[   28.187993] iommu: Adding device 0000:83:0a.1 to group 121
[   28.188028] pci 0000:83:0a.2: [8086:154c] type 00 class 0x020000
[   28.188064] pci 0000:83:0a.2: Max Payload Size set to 256 (was 128, max
2048)
[   28.188136] iommu: Adding device 0000:83:0a.2 to group 122
[   28.188169] pci 0000:83:0a.3: [8086:154c] type 00 class 0x020000
[   28.188205] pci 0000:83:0a.3: Max Payload Size set to 256 (was 128, max
2048)
[   28.188272] iommu: Adding device 0000:83:0a.3 to group 123
[   28.188305] pci 0000:83:0a.4: [8086:154c] type 00 class 0x020000
[   28.188340] pci 0000:83:0a.4: Max Payload Size set to 256 (was 128, max
2048)
[   28.188425] iommu: Adding device 0000:83:0a.4 to group 124
[   28.188468] pci 0000:83:0a.5: [8086:154c] type 00 class 0x020000
[   28.188503] pci 0000:83:0a.5: Max Payload Size set to 256 (was 128, max
2048)
[   28.188620] iommu: Adding device 0000:83:0a.5 to group 125
[   28.188659] pci 0000:83:0a.6: [8086:154c] type 00 class 0x020000
[   28.188694] pci 0000:83:0a.6: Max Payload Size set to 256 (was 128, max
2048)
[   28.188838] iommu: Adding device 0000:83:0a.6 to group 126
[   28.188887] pci 0000:83:0a.7: [8086:154c] type 00 class 0x020000
[   28.188922] pci 0000:83:0a.7: Max Payload Size set to 256 (was 128, max
2048)
[   28.189083] iommu: Adding device 0000:83:0a.7 to group 127
[   28.282306] device qr-e1f33440-0c left promiscuous mode
[   28.360312] device tap502560f9-d8 left promiscuous mode
[   28.396800] device tap9b0fa827-27 left promiscuous mode
[   28.472534] device tapd10cc73d-3b left promiscuous mode
[   29.801012] ixgbe 0000:04:00.0 enp4s0f0: NIC Link is Up 10 Gbps, Flow
Control: RX/TX
[   41.221646] IPv6: ADDRCONF(NETDEV_UP): qvb7f4dce60-91: link is not ready
[   41.308303] device qvb7f4dce60-91 entered promiscuous mode
[   41.416683] IPv6: ADDRCONF(NETDEV_CHANGE): qvb7f4dce60-91: link becomes
ready
[   41.506396] device qvo7f4dce60-91 entered promiscuous mode
[   41.655044] qbr7f4dce60-91: port 1(qvb7f4dce60-91) entered forwarding state
[   41.655051] qbr7f4dce60-91: port 1(qvb7f4dce60-91) entered forwarding state
[   42.000932] Netfilter messages via NETLINK v0.30.
[   42.014636] ip_set: protocol 6
[   89.625075] device tap9b0fa827-27 entered promiscuous mode
[   89.633839] device tap502560f9-d8 entered promiscuous mode
[   89.635991] device tapd10cc73d-3b entered promiscuous mode
[   89.877049] device qr-912a3637-a9 entered promiscuous mode
[   90.138414] device qr-9cc0be6f-14 entered promiscuous mode
[   90.414338] device qr-e1f33440-0c entered promiscuous mode
[   90.702716] device qg-3e44de10-3d entered promiscuous mode
[  980.670259] Unable to load target_core_user
[  994.343776] scsi host7: iSCSI Initiator over TCP/IP
[  994.361276] scsi 7:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0 
PQ: 0 ANSI: 5
[  994.361705] sd 7:0:0:0: alua: supports implicit and explicit TPGS
[  994.361794] TARGET_CORE[iSCSI]: Expected Transfer Length: 264 does not match
SCSI CDB Length: 8 for SAM Opcode: 0x12
[  994.361830] sd 7:0:0:0: alua: No target port descriptors found
[  994.361833] sd 7:0:0:0: alua: Attach failed (-22)
[  994.361862] sd 7:0:0:0: [sdg] 115343360 512-byte logical blocks: (59.0
GB/55.0 GiB)
[  994.361868] sd 7:0:0:0: failed to add device handler: -22
[  994.361911] sd 7:0:0:0: [sdg] Write Protect is off
[  994.361914] sd 7:0:0:0: [sdg] Mode Sense: 00 00 00 00
[  994.361916] sd 7:0:0:0: [sdg] Asking for cache data failed
[  994.361937] sd 7:0:0:0: [sdg] Assuming drive cache: write through
[  994.363181] sd 7:0:0:0: [sdg] Attached SCSI disk
[  994.506461] scsi 7:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0 
PQ: 0 ANSI: 5
[  994.506822] ------------[ cut here ]------------
[  994.506828] WARNING: CPU: 1 PID: 10460 at fs/sysfs/dir.c:31
sysfs_warn_dup+0x64/0x80()
[  994.506829] sysfs: cannot create duplicate filename
'/bus/scsi/devices/7:0:0:0'
[  994.506830] Modules linked in: target_core_pscsi target_core_file
target_core_iblock xt_REDIRECT nf_nat_redirect xt_nat xt_mark xt_CHECKSUM
nf_conntrack_ipv6 xt_mac xt_physdev xt_set xt_conntrack iptable_raw
ip_set_hash_net ip_set nfnetlink veth ebtable_filter ebtables ip6table_filter
ip6_tables iscsi_tcp libiscsi_tcp 8021q garp mrp rpcrdma ib_isert
iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod
openvswitch bonding ib_srp scsi_transport_srp ib_ipoib nf_defrag_ipv6 rdma_ucm
ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_sa ib_mad usnic_verbs ib_core
xt_comment xt_multiport iptable_filter ib_addr iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 x86_pkg_temp_thermal nf_nat_ipv4 intel_powerclamp nf_nat
coretemp kvm_intel nf_conntrack kvm iptable_mangle irqbypass crct10dif_pclmul
[  994.506873]  crc32_pclmul nfsd aesni_intel lrw gf128mul glue_helper
ablk_helper cryptd ses enclosure sb_edac sg auth_rpcgss edac_core iTCO_wdt
ipmi_devintf iTCO_vendor_support nfs_acl lockd shpchp pcspkr lpc_ich ipmi_si
ipmi_msghandler mfd_core wmi acpi_power_meter grace sunrpc br_netfilter bridge
stp llc dm_multipath ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ixgbe(O) drm fnic i40e
libfcoe igb megaraid_sas enic libfc crc32c_intel vxlan ip6_udp_tunnel
udp_tunnel ptp scsi_transport_fc i2c_algo_bit dca i2c_core pps_core dm_mirror
dm_region_hash dm_log dm_mod
[  994.506906] CPU: 1 PID: 10460 Comm: iscsiadm Tainted: G        W  O    4.4.0
#1
[  994.506907] Hardware name: Cisco Systems Inc UCSC-C240-M3S/UCSC-C240-M3S,
BIOS C240M3.2.0.8.0.071620152208 07/16/2015
[  994.506909]  0000000000000000 00000000c99ac6bd ffff882d19f07948
ffffffff81329090
[  994.506910]  ffff882d19f07990 ffff882d19f07980 ffffffff810862c6
ffff882d4b39d000
[  994.506912]  ffff882fa039c858 ffff882fa50dee10 0000000000000001
ffffffffffffffef
[  994.506914] Call Trace:
[  994.506920]  [<ffffffff81329090>] dump_stack+0x44/0x64
[  994.506931]  [<ffffffff810862c6>] warn_slowpath_common+0x86/0xc0
[  994.506932]  [<ffffffff8108635c>] warn_slowpath_fmt+0x5c/0x80
[  994.506936]  [<ffffffff8127e9a8>] ? kernfs_path+0x48/0x60
[  994.506937]  [<ffffffff81282014>] sysfs_warn_dup+0x64/0x80
[  994.506939]  [<ffffffff812823aa>] sysfs_do_create_link_sd.isra.2+0xaa/0xb0
[  994.506940]  [<ffffffff812823d5>] sysfs_create_link+0x25/0x40
[  994.506944]  [<ffffffff81454a6b>] bus_add_device+0x10b/0x1f0
[  994.506946]  [<ffffffff81452815>] device_add+0x3b5/0x610
[  994.506949]  [<ffffffff81487df5>] scsi_sysfs_add_sdev+0xa5/0x290
[  994.506951]  [<ffffffff81485355>] scsi_probe_and_add_lun+0xb65/0xd80
[  994.506955]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[  994.506957]  [<ffffffff81485d67>] __scsi_scan_target+0xf7/0x260
[  994.506958]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[  994.506960]  [<ffffffff81485fa7>] scsi_scan_target+0xd7/0xf0
[  994.506967]  [<ffffffffa07529f5>]
iscsi_user_scan_session.part.14+0x105/0x140 [scsi_transport_iscsi]
[  994.506971]  [<ffffffffa0752a30>] ?
iscsi_user_scan_session.part.14+0x140/0x140 [scsi_transport_iscsi]
[  994.506975]  [<ffffffffa0752a4e>] iscsi_user_scan_session+0x1e/0x30
[scsi_transport_iscsi]
[  994.506976]  [<ffffffff81450b80>] device_for_each_child+0x50/0x90
[  994.506980]  [<ffffffffa075083d>] iscsi_user_scan+0x3d/0x60
[scsi_transport_iscsi]
[  994.506982]  [<ffffffff81487bb6>] store_scan+0xa6/0x100
[  994.506985]  [<ffffffff811e3158>] ? __kmalloc+0x1b8/0x250
[  994.506988]  [<ffffffff81450318>] dev_attr_store+0x18/0x30
[  994.506989]  [<ffffffff8128170a>] sysfs_kf_write+0x3a/0x50
[  994.506991]  [<ffffffff81280d90>] kernfs_fop_write+0x120/0x170
[  994.506993]  [<ffffffff81203f17>] __vfs_write+0x37/0x100
[  994.506995]  [<ffffffff812b6c03>] ? selinux_file_permission+0xc3/0x110
[  994.506999]  [<ffffffff812ae75d>] ? security_file_permission+0x3d/0xc0
[  994.507002]  [<ffffffff810cd95f>] ? percpu_down_read+0x1f/0x50
[  994.507003]  [<ffffffff812045f2>] vfs_write+0xa2/0x1a0
[  994.507006]  [<ffffffff81003176>] ? do_audit_syscall_entry+0x66/0x70
[  994.507008]  [<ffffffff812053b5>] SyS_write+0x55/0xc0
[  994.507011]  [<ffffffff816945ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[  994.507012] ---[ end trace 5d59079faf7d2511 ]---
[  994.507042] scsi 7:0:0:0: failed to add device: -17
[  994.986819] scsi host8: iSCSI Initiator over TCP/IP
[  995.001630] scsi 8:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0 
PQ: 0 ANSI: 5
[  995.001995] sd 8:0:0:0: alua: supports implicit and explicit TPGS
[  995.002076] TARGET_CORE[iSCSI]: Expected Transfer Length: 264 does not match
SCSI CDB Length: 8 for SAM Opcode: 0x12
[  995.002117] sd 8:0:0:0: alua: No target port descriptors found
[  995.002119] sd 8:0:0:0: alua: Attach failed (-22)
[  995.002141] sd 8:0:0:0: [sdh] 2097152 512-byte logical blocks: (1.07 GB/1.00
GiB)
[  995.002142] sd 8:0:0:0: failed to add device handler: -22
[  995.002187] sd 8:0:0:0: [sdh] Write Protect is off
[  995.002189] sd 8:0:0:0: [sdh] Mode Sense: 00 00 00 00
[  995.002191] sd 8:0:0:0: [sdh] Asking for cache data failed
[  995.002211] sd 8:0:0:0: [sdh] Assuming drive cache: write through
[  995.002612] sd 8:0:0:0: [sdh] Attached SCSI disk
[  995.150008] scsi 8:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0 
PQ: 0 ANSI: 5
[  995.150316] ------------[ cut here ]------------
[  995.150321] WARNING: CPU: 2 PID: 10504 at fs/sysfs/dir.c:31
sysfs_warn_dup+0x64/0x80()
[  995.150322] sysfs: cannot create duplicate filename
'/bus/scsi/devices/8:0:0:0'
[  995.150323] Modules linked in: target_core_pscsi target_core_file
target_core_iblock xt_REDIRECT nf_nat_redirect xt_nat xt_mark xt_CHECKSUM
nf_conntrack_ipv6 xt_mac xt_physdev xt_set xt_conntrack iptable_raw
ip_set_hash_net ip_set nfnetlink veth ebtable_filter ebtables ip6table_filter
ip6_tables iscsi_tcp libiscsi_tcp 8021q garp mrp rpcrdma ib_isert
iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod
openvswitch bonding ib_srp scsi_transport_srp ib_ipoib nf_defrag_ipv6 rdma_ucm
ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_sa ib_mad usnic_verbs ib_core
xt_comment xt_multiport iptable_filter ib_addr iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 x86_pkg_temp_thermal nf_nat_ipv4 intel_powerclamp nf_nat
coretemp kvm_intel nf_conntrack kvm iptable_mangle irqbypass crct10dif_pclmul
[  995.150367]  crc32_pclmul nfsd aesni_intel lrw gf128mul glue_helper
ablk_helper cryptd ses enclosure sb_edac sg auth_rpcgss edac_core iTCO_wdt
ipmi_devintf iTCO_vendor_support nfs_acl lockd shpchp pcspkr lpc_ich ipmi_si
ipmi_msghandler mfd_core wmi acpi_power_meter grace sunrpc br_netfilter bridge
stp llc dm_multipath ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ixgbe(O) drm fnic i40e
libfcoe igb megaraid_sas enic libfc crc32c_intel vxlan ip6_udp_tunnel
udp_tunnel ptp scsi_transport_fc i2c_algo_bit dca i2c_core pps_core dm_mirror
dm_region_hash dm_log dm_mod
[  995.150399] CPU: 2 PID: 10504 Comm: iscsiadm Tainted: G        W  O    4.4.0
#1
[  995.150400] Hardware name: Cisco Systems Inc UCSC-C240-M3S/UCSC-C240-M3S,
BIOS C240M3.2.0.8.0.071620152208 07/16/2015
[  995.150402]  0000000000000000 0000000000b57f59 ffff882d19ffb948
ffffffff81329090
[  995.150404]  ffff882d19ffb990 ffff882d19ffb980 ffffffff810862c6
ffff88007ac62000
[  995.150405]  ffff882f9f889900 ffff882fa50dee10 0000000000000001
ffffffffffffffef
[  995.150407] Call Trace:
[  995.150412]  [<ffffffff81329090>] dump_stack+0x44/0x64
[  995.150415]  [<ffffffff810862c6>] warn_slowpath_common+0x86/0xc0
[  995.150416]  [<ffffffff8108635c>] warn_slowpath_fmt+0x5c/0x80
[  995.150419]  [<ffffffff8127e9a8>] ? kernfs_path+0x48/0x60
[  995.150420]  [<ffffffff81282014>] sysfs_warn_dup+0x64/0x80
[  995.150435]  [<ffffffff812823aa>] sysfs_do_create_link_sd.isra.2+0xaa/0xb0
[  995.150437]  [<ffffffff812823d5>] sysfs_create_link+0x25/0x40
[  995.150440]  [<ffffffff81454a6b>] bus_add_device+0x10b/0x1f0
[  995.150442]  [<ffffffff81452815>] device_add+0x3b5/0x610
[  995.150445]  [<ffffffff81487df5>] scsi_sysfs_add_sdev+0xa5/0x290
[  995.150447]  [<ffffffff81485355>] scsi_probe_and_add_lun+0xb65/0xd80
[  995.150451]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[  995.150453]  [<ffffffff81485d67>] __scsi_scan_target+0xf7/0x260
[  995.150454]  [<ffffffff814608ac>] ? __pm_runtime_resume+0x5c/0x70
[  995.150456]  [<ffffffff81485fa7>] scsi_scan_target+0xd7/0xf0
[  995.150463]  [<ffffffffa07529f5>]
iscsi_user_scan_session.part.14+0x105/0x140 [scsi_transport_iscsi]
[  995.150467]  [<ffffffffa0752a30>] ?
iscsi_user_scan_session.part.14+0x140/0x140 [scsi_transport_iscsi]
[  995.150470]  [<ffffffffa0752a4e>] iscsi_user_scan_session+0x1e/0x30
[scsi_transport_iscsi]
[  995.150472]  [<ffffffff81450b80>] device_for_each_child+0x50/0x90
[  995.150475]  [<ffffffffa075083d>] iscsi_user_scan+0x3d/0x60
[scsi_transport_iscsi]
[  995.150477]  [<ffffffff81487bb6>] store_scan+0xa6/0x100
[  995.150494]  [<ffffffff811e3158>] ? __kmalloc+0x1b8/0x250
[  995.150498]  [<ffffffff81450318>] dev_attr_store+0x18/0x30
[  995.150499]  [<ffffffff8128170a>] sysfs_kf_write+0x3a/0x50
[  995.150500]  [<ffffffff81280d90>] kernfs_fop_write+0x120/0x170
[  995.150503]  [<ffffffff81203f17>] __vfs_write+0x37/0x100
[  995.150505]  [<ffffffff812b6c03>] ? selinux_file_permission+0xc3/0x110
[  995.150509]  [<ffffffff812ae75d>] ? security_file_permission+0x3d/0xc0
[  995.150512]  [<ffffffff810cd95f>] ? percpu_down_read+0x1f/0x50
[  995.150513]  [<ffffffff812045f2>] vfs_write+0xa2/0x1a0
[  995.150518]  [<ffffffff81003176>] ? do_audit_syscall_entry+0x66/0x70
[  995.150520]  [<ffffffff812053b5>] SyS_write+0x55/0xc0
[  995.150523]  [<ffffffff816945ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[  995.150525] ---[ end trace 5d59079faf7d2512 ]---
[  995.150556] scsi 8:0:0:0: failed to add device: -17

-- 
You are receiving this mail because:
You are the assignee for the bug.
