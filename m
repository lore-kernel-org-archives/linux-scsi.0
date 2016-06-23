From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 120921] New: target: Unconfiguring ib_srpt triggers kernel
 crash
Date: Thu, 23 Jun 2016 11:26:24 +0000
Message-ID: <bug-120921-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36876 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbcFWL02 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2016 07:26:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DD554201B4
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2016 11:26:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8BF26201BC
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2016 11:26:24 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=120921

            Bug ID: 120921
           Summary: target: Unconfiguring ib_srpt triggers kernel crash
           Product: IO/Storage
           Version: 2.5
    Kernel Version: v4.6.2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: bvanassche@acm.org
        Regression: No

The following command triggered the kernel crash:

# rmdir /sys/kernel/config/target/srpt/*/*/acls/*
Segmentation fault

>From the console:

[  957.515524] general protection fault: 0000 [#1] SMP 
[  957.515638] Modules linked in: target_core_file ib_srpt target_core_iblock
target_core_mod brd dm_service_time fuse dm_multipath scsi_dh_rdac scsi_dh_emc
scsi_dh_alua netconsole xt_CHECKSUM iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT xt_tcpudp tun
ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables
x_tables af_packet bridge stp llc iscsi_ibft iscsi_boot_sysfs ib_ipoib rdma_ucm
ib_ucm ib_uverbs msr ib_umad rdma_cm configfs ib_cm iw_cm mlx4_ib ib_sa ib_mad
ib_core ib_addr x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
dm_mod irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
tg3 ipmi_ssif ipmi_devintf iTCO_wdt aesni_intel iTCO_vendor_support aes_x86_64
lrw ptp sb_edac mei_me gf128mul dcdbas pps_core glue_helper ablk_helper
mlx4_core pcspkr mei edac_core libphy cryptd fjes lpc_ich ipmi_si mfd_core
8250_fintek ipmi_msghandler tpm_tis tpm wmi shpchp acpi_power_meter button
hid_generic usbhid mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect
sysimgblt fb_sys_fops ttm sr_mod drm cdrom ehci_pci ehci_hcd usbcore usb_common
sg [last unloaded: scsi_transport_srp]
[  957.519948] CPU: 3 PID: 22754 Comm: rmdir Not tainted 4.6.2-dbg+ #1
[  957.519989] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2
11/17/2014
[  957.520032] task: ffff88006c82b140 ti: ffff88033eb8c000 task.ti:
ffff88033eb8c000
[  957.520073] RIP: 0010:[<ffffffff812dbad9>]  [<ffffffff812dbad9>]
__list_del_entry+0x29/0xc0
[  957.520154] RSP: 0018:ffff88033eb8fd88  EFLAGS: 00010a83
[  957.520194] RAX: 6b6b6b6b6b6b6b6b RBX: ffff880372948780 RCX:
dead000000000200
[  957.520234] RDX: 6b6b6b6b6b6b6b6b RSI: ffff88006c82b980 RDI:
ffff880372948780
[  957.520276] RBP: ffff88033eb8fd88 R08: ffff88033eb8fc88 R09:
0000000000000000
[  957.520316] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff880340dc8958
[  957.520540] R13: 0000000000000001 R14: ffff88046db301b8 R15:
ffff880372948740
[  957.520582] FS:  00007f4e4a1f7700(0000) GS:ffff88046f260000(0000)
knlGS:0000000000000000
[  957.520623] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  957.520662] CR2: 00007fefadbca728 CR3: 00000003752ee000 CR4:
00000000001406e0
[  957.520701] Stack:
[  957.520739]  ffff88033eb8fda0 ffffffff812dbb7d 6b6b6b6b6b6b6b2b
ffff88033eb8fe00
[  957.520924]  ffffffffa061f044 ffff88033eb8fdd0 ffff880340dc8b28
ffff880340dc8dd8
[  957.521106]  ffff880372948780 ffff880372948780 ffff880340dc8958
0000000000000000
[  957.521283] Call Trace:
[  957.521323]  [<ffffffff812dbb7d>] list_del+0xd/0x30
[  957.521379]  [<ffffffffa061f044>]
core_tpg_del_initiator_node_acl+0x134/0x210 [target_core_mod]
[  957.521434]  [<ffffffffa06121b0>] target_fabric_nacl_base_release+0x20/0x30
[target_core_mod]
[  957.521484]  [<ffffffffa0317ef2>] config_item_release+0x62/0xd0 [configfs]
[  957.521532]  [<ffffffffa0317f7d>] config_item_put+0x1d/0x1f [configfs]
[  957.521870]  [<ffffffffa03163c7>] configfs_rmdir+0x1e7/0x300 [configfs]
[  957.521918]  [<ffffffff811a414c>] vfs_rmdir+0x6c/0x110
[  957.521963]  [<ffffffff811a8f68>] do_rmdir+0x158/0x1c0
[  957.522006]  [<ffffffff811a9b51>] SyS_rmdir+0x11/0x20
[  957.522049]  [<ffffffff8159d8a9>] entry_SYSCALL_64_fastpath+0x1c/0xac
[  957.522093] Code: 66 90 48 b9 00 01 00 00 00

Note: this crash does not occur with kernel v4.7-rc4.

-- 
You are receiving this mail because:
You are the assignee for the bug.
