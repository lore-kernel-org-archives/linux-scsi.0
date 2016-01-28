From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111441] New: iscsi fails to attach to targets
Date: Thu, 28 Jan 2016 22:51:08 +0000
Message-ID: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44406 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbcA1WvN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 17:51:13 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 45ABB20340
	for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 22:51:12 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A2D83202F8
	for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 22:51:09 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111441

            Bug ID: 111441
           Summary: iscsi fails to attach to targets
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.4.0-1
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: sbezverk@cisco.com
        Regression: No

The issue is whenever iscsi tries to attach remote iscsi target, there is this
traceback generated in dmesg buffer and it fails to attach.  Here is the
traceback and it is 100% reproducible. I would appreciate if you let me know if
it is a known issue and if there is a patch to address it.

[ 4693.175319] WARNING: CPU: 27 PID: 17353 at fs/sysfs/dir.c:31
sysfs_warn_dup+0x64/0x80()
[ 4693.175320] sysfs: cannot create duplicate filename
'/bus/scsi/devices/8:0:0:0'
[ 4693.175321] Modules linked in: target_core_user target_core_pscsi
target_core_file target_core_iblock binfmt_misc xt_REDIRECT nf_nat_redirect
xt_nat xt_mark xt_conntrack xt_CHECKSUM iptable_raw ebtable_filter ebtables
ip6table_filter ip6_tables iscsi_tcp libiscsi_tcp bnx2fc cnic uio fcoe 8021q
garp mrp openvswitch nf_defrag_ipv6 bonding rpcrdma ib_isert iscsi_target_mod
ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp
scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm
iw_cm ib_sa ib_mad usnic_verbs ib_core ib_addr xt_comment xt_multiport
iptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_conntrack iptable_mangle x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul aesni_intel
[ 4693.175362]  lrw gf128mul glue_helper ablk_helper cryptd ipmi_devintf ses
enclosure sg ipmi_si 8250_fintek ipmi_msghandler joydev input_leds sb_edac
iTCO_wdt iTCO_vendor_support pcspkr shpchp lpc_ich edac_core mfd_core wmi
acpi_power_meter nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath
ip_tables xfs libcrc32c sd_mod crc32c_intel mgag200 megaraid_sas drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm libfcoe libfc
scsi_transport_fc enic ixgbe(O) i40e vxlan ip6_udp_tunnel igb udp_tunnel ptp
pps_core dca i2c_algo_bit fjes dm_mirror dm_region_hash dm_log dm_mod [last
unloaded: fnic]
[ 4693.175391] CPU: 27 PID: 17353 Comm: iscsiadm Tainted: G        W  O   
4.4.0-1.el7.elrepo.x86_64 #1
[ 4693.175392] Hardware name: Cisco Systems Inc UCSC-C240-M3S/UCSC-C240-M3S,
BIOS C240M3.2.0.8.0.071620152208 07/16/2015
[ 4693.175393]  0000000000000000 00000000e6fae80d ffff885cff49b948
ffffffff813273f0
[ 4693.175395]  ffff885cff49b990 ffff885cff49b980 ffffffff8107c816
ffff882c2b7e5000
[ 4693.175396]  ffff882fa36885d0 ffff885fa53b8d98 0000000000000001
ffffffffffffffef
[ 4693.175398] Call Trace:
[ 4693.175402]  [<ffffffff813273f0>] dump_stack+0x44/0x64
[ 4693.175405]  [<ffffffff8107c816>] warn_slowpath_common+0x86/0xc0
[ 4693.175407]  [<ffffffff8107c8ac>] warn_slowpath_fmt+0x5c/0x80
[ 4693.175409]  [<ffffffff81272d68>] ? kernfs_path+0x48/0x60
[ 4693.175410]  [<ffffffff812763d4>] sysfs_warn_dup+0x64/0x80
[ 4693.175412]  [<ffffffff8127676a>] sysfs_do_create_link_sd.isra.2+0xaa/0xb0
[ 4693.175414]  [<ffffffff81276795>] sysfs_create_link+0x25/0x40
[ 4693.175417]  [<ffffffff8146db9b>] bus_add_device+0x10b/0x1f0
[ 4693.175419]  [<ffffffff8146b945>] device_add+0x3b5/0x610
[ 4693.175422]  [<ffffffff814acd85>] scsi_sysfs_add_sdev+0xa5/0x290
[ 4693.175424]  [<ffffffff814aa2e5>] scsi_probe_and_add_lun+0xb65/0xd80
[ 4693.175427]  [<ffffffff814799dc>] ? __pm_runtime_resume+0x5c/0x70
[ 4693.175429]  [<ffffffff814aacf7>] __scsi_scan_target+0xf7/0x260
[ 4693.175430]  [<ffffffff814799dc>] ? __pm_runtime_resume+0x5c/0x70
[ 4693.175432]  [<ffffffff814aaf37>] scsi_scan_target+0xd7/0xf0
[ 4693.175440]  [<ffffffffa06b49f5>]
iscsi_user_scan_session.part.14+0x105/0x140 [scsi_transport_iscsi]
[ 4693.175443]  [<ffffffffa06b4a30>] ?
iscsi_user_scan_session.part.14+0x140/0x140 [scsi_transport_iscsi]
[ 4693.175446]  [<ffffffffa06b4a4e>] iscsi_user_scan_session+0x1e/0x30
[scsi_transport_iscsi]
[ 4693.175448]  [<ffffffff81469cb0>] device_for_each_child+0x50/0x90
[ 4693.175451]  [<ffffffffa06b283d>] iscsi_user_scan+0x3d/0x60
[scsi_transport_iscsi]
[ 4693.175453]  [<ffffffff814acb46>] store_scan+0xa6/0x100
[ 4693.175456]  [<ffffffff811da078>] ? __kmalloc+0x1b8/0x250
[ 4693.175458]  [<ffffffff81469448>] dev_attr_store+0x18/0x30
[ 4693.175459]  [<ffffffff81275aca>] sysfs_kf_write+0x3a/0x50
[ 4693.175461]  [<ffffffff81275150>] kernfs_fop_write+0x120/0x170
[ 4693.175464]  [<ffffffff811f98d7>] __vfs_write+0x37/0x100
[ 4693.175467]  [<ffffffff812ab4b3>] ? selinux_file_permission+0xc3/0x110
[ 4693.175469]  [<ffffffff812a300d>] ? security_file_permission+0x3d/0xc0
[ 4693.175485]  [<ffffffff810c5f2f>] ? percpu_down_read+0x1f/0x50
[ 4693.175486]  [<ffffffff811f9fb2>] vfs_write+0xa2/0x1a0
[ 4693.175489]  [<ffffffff81003176>] ? do_audit_syscall_entry+0x66/0x70
[ 4693.175491]  [<ffffffff811fad75>] SyS_write+0x55/0xc0
[ 4693.175493]  [<ffffffff816e406e>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 4693.175495] ---[ end trace 67e92c68518cd764 ]---
[ 4693.175516] scsi 8:0:0:0: failed to add device: -17
[ 4702.252060] scsi 8:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0 
PQ: 0 ANSI: 5
[ 4702.252482] ------------[ cut here ]------------
[ 4702.252488] WARNING: CPU: 2 PID: 17390 at fs/sysfs/dir.c:31
sysfs_warn_dup+0x64/0x80()
[ 4702.252489] sysfs: cannot create duplicate filename
'/bus/scsi/devices/8:0:0:0'
[ 4702.252490] Modules linked in: target_core_user target_core_pscsi
target_core_file target_core_iblock binfmt_misc xt_REDIRECT nf_nat_redirect
xt_nat xt_mark xt_conntrack xt_CHECKSUM iptable_raw ebtable_filter ebtables
ip6table_filter ip6_tables iscsi_tcp libiscsi_tcp bnx2fc cnic uio fcoe 8021q
garp mrp openvswitch nf_defrag_ipv6 bonding rpcrdma ib_isert iscsi_target_mod
ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp
scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm
iw_cm ib_sa ib_mad usnic_verbs ib_core ib_addr xt_comment xt_multiport
iptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_conntrack iptable_mangle x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul aesni_intel
[ 4702.252523]  lrw gf128mul glue_helper ablk_helper cryptd ipmi_devintf ses
enclosure sg ipmi_si 8250_fintek ipmi_msghandler joydev input_leds sb_edac
iTCO_wdt iTCO_vendor_support pcspkr shpchp lpc_ich edac_core mfd_core wmi
acpi_power_meter nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath
ip_tables xfs libcrc32c sd_mod crc32c_intel mgag200 megaraid_sas drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm libfcoe libfc
scsi_transport_fc enic ixgbe(O) i40e vxlan ip6_udp_tunnel igb udp_tunnel ptp
pps_core dca i2c_algo_bit fjes dm_mirror dm_region_hash dm_log dm_mod [last
unloaded: fnic]
[ 4702.252553] CPU: 2 PID: 17390 Comm: iscsiadm Tainted: G        W  O   
4.4.0-1.el7.elrepo.x86_64 #1
[ 4702.252554] Hardware name: Cisco Systems Inc UCSC-C240-M3S/UCSC-C240-M3S,
BIOS C240M3.2.0.8.0.071620152208 07/16/2015
[ 4702.252556]  0000000000000000 0000000043b94d0c ffff882c2fb77948
ffffffff813273f0
[ 4702.252557]  ffff882c2fb77990 ffff882c2fb77980 ffffffff8107c816
ffff882fa32a9000
[ 4702.252559]  ffff882fa4a34b80 ffff885fa53b8d98 0000000000000001
ffffffffffffffef
[ 4702.252561] Call Trace:
[ 4702.252565]  [<ffffffff813273f0>] dump_stack+0x44/0x64
[ 4702.252568]  [<ffffffff8107c816>] warn_slowpath_common+0x86/0xc0
[ 4702.252570]  [<ffffffff8107c8ac>] warn_slowpath_fmt+0x5c/0x80
[ 4702.252572]  [<ffffffff81272d68>] ? kernfs_path+0x48/0x60
[ 4702.252573]  [<ffffffff812763d4>] sysfs_warn_dup+0x64/0x80
[ 4702.252576]  [<ffffffff8127676a>] sysfs_do_create_link_sd.isra.2+0xaa/0xb0
[ 4702.252577]  [<ffffffff81276795>] sysfs_create_link+0x25/0x40
[ 4702.252581]  [<ffffffff8146db9b>] bus_add_device+0x10b/0x1f0
[ 4702.252583]  [<ffffffff8146b945>] device_add+0x3b5/0x610
[ 4702.252585]  [<ffffffff814acd85>] scsi_sysfs_add_sdev+0xa5/0x290
[ 4702.252588]  [<ffffffff814aa2e5>] scsi_probe_and_add_lun+0xb65/0xd80
[ 4702.252591]  [<ffffffff814799dc>] ? __pm_runtime_resume+0x5c/0x70
[ 4702.252594]  [<ffffffff814aacf7>] __scsi_scan_target+0xf7/0x260
[ 4702.252596]  [<ffffffff814799dc>] ? __pm_runtime_resume+0x5c/0x70
[ 4702.252597]  [<ffffffff814aaf37>] scsi_scan_target+0xd7/0xf0
[ 4702.252606]  [<ffffffffa06b49f5>]
iscsi_user_scan_session.part.14+0x105/0x140 [scsi_transport_iscsi]
[ 4702.252609]  [<ffffffffa06b4a30>] ?
iscsi_user_scan_session.part.14+0x140/0x140 [scsi_transport_iscsi]
[ 4702.252612]  [<ffffffffa06b4a4e>] iscsi_user_scan_session+0x1e/0x30
[scsi_transport_iscsi]
[ 4702.252615]  [<ffffffff81469cb0>] device_for_each_child+0x50/0x90
[ 4702.252619]  [<ffffffffa06b283d>] iscsi_user_scan+0x3d/0x60
[scsi_transport_iscsi]
[ 4702.252620]  [<ffffffff814acb46>] store_scan+0xa6/0x100
[ 4702.252623]  [<ffffffff811da078>] ? __kmalloc+0x1b8/0x250
[ 4702.252625]  [<ffffffff81469448>] dev_attr_store+0x18/0x30
[ 4702.252627]  [<ffffffff81275aca>] sysfs_kf_write+0x3a/0x50
[ 4702.252628]  [<ffffffff81275150>] kernfs_fop_write+0x120/0x170
[ 4702.252631]  [<ffffffff811f98d7>] __vfs_write+0x37/0x100
[ 4702.252635]  [<ffffffff812ab4b3>] ? selinux_file_permission+0xc3/0x110
[ 4702.252638]  [<ffffffff812a300d>] ? security_file_permission+0x3d/0xc0
[ 4702.252641]  [<ffffffff810c5f2f>] ? percpu_down_read+0x1f/0x50
[ 4702.252643]  [<ffffffff811f9fb2>] vfs_write+0xa2/0x1a0
[ 4702.252646]  [<ffffffff81003176>] ? do_audit_syscall_entry+0x66/0x70
[ 4702.252649]  [<ffffffff811fad75>] SyS_write+0x55/0xc0
[ 4702.252652]  [<ffffffff816e406e>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 4702.252653] ---[ end trace 67e92c68518cd765 ]---
[ 4702.252673] scsi 8:0:0:0: failed to add device: -17
[ 4718.329596] scsi 8:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0 
PQ: 0 ANSI: 5
[ 4718.329884] ------------[ cut here ]------------

-- 
You are receiving this mail because:
You are the assignee for the bug.
