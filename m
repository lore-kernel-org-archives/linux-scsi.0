From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 116771] New: NULL pointer dereference when 'cat
 /sys/class/fc_host/host1/fabric_name'
Date: Wed, 20 Apr 2016 01:06:18 +0000
Message-ID: <bug-116771-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50234 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbcDTBGW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2016 21:06:22 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 359FF2025A
	for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2016 01:06:21 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 86387201C0
	for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2016 01:06:18 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=116771

            Bug ID: 116771
           Summary: NULL pointer dereference when 'cat
                    /sys/class/fc_host/host1/fabric_name'
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.6-rc1 to 4.6-rc4
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: QLOGIC QLA2XXX
          Assignee: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
          Reporter: changlimin@h3c.com
        Regression: No

1. A HBA card installed in HP ProLiant DL560 Gen8, BIOS P77 08/03/2014.
07:00.0 Fibre Channel [0c04]: QLogic Corp. ISP2532-based 8Gb Fibre Channel to
PCI Express HBA [1077:2532] (rev 02)
07:00.1 Fibre Channel [0c04]: QLogic Corp. ISP2532-based 8Gb Fibre Channel to
PCI Express HBA [1077:2532] (rev 02)

2. After install 4.6-rc1 to 4.6-rc4 kernel, NULL pointer dereference when 'cat
/sys/class/fc_host/host1/fabric_name'.  Kernel 4.5.1 is good.

3. The reason is starget->dev.parent is NULL in qla2x00_get_starget_node_name
    qla2x00_get_starget_node_name(struct scsi_target *starget)
    {
    struct Scsi_Host *host = dev_to_shost(starget->dev.parent);

4. Detail log:
 BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
 IP: [<ffffffffa844df97>] scsi_is_host_device+0x7/0x20
 PGD 0
 Oops: 0000 [#4] SMP
 Modules linked in: target_core_user uio iscsi_target_mod tcm_loop vhost_scsi
vhost target_core_file target_core_iblock target_core_pscsi target_core_mod
iscsi_tcp ocfs2_dlmfs libiscsi_tcp libiscsi ocfs2_stack_o2cb
scsi_transport_iscsi ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs nbd
dm_round_robin bridge stp llc x86_pkg_temp_thermal intel_powerclamp kvm_intel
ipmi_ssif i2c_core kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
aesni_intel dm_multipath aes_x86_64 glue_helper irqbypass lrw gf128mul
ablk_helper cryptd ipmi_si serio_raw ipmi_msghandler hpilo nfsd auth_rpcgss
nfs_acl lockd grace sunrpc ext4 jbd2 mbcache hid_generic tg3 qla2xxx bnx2x
hwmon usbhid hpsa ptp mdio hid scsi_transport_sas scsi_transport_fc pps_core
libcrc32c
 CPU: 1 PID: 2666 Comm: libvirtd Tainted: G      D         4.6.0-rc1 #1
 Hardware name: HP ProLiant DL560 Gen8, BIOS P77 08/03/2014
 task: ffff881fea668000 ti: ffff881fea694000 task.ti: ffff881fea694000
 RIP: 0010:[<ffffffffa844df97>]  [<ffffffffa844df97>]
scsi_is_host_device+0x7/0x20
 RSP: 0018:ffff881fea697cf0  EFLAGS: 00010246
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff880ff8eef1d0
 RDX: ffff880ff8b9a000 RSI: ffff881ff8c82340 RDI: 0000000000000000
 RBP: ffff881fea697d08 R08: ffff880ff9a49c38 R09: ffff880ff2b0b980
 R10: ffff880ff8b9a000 R11: ffff880ff9f7dac0 R12: ffff880ff8353000
 R13: ffff881ff8545900 R14: ffff880ff06bc900 R15: 0000000000000001
 FS:  00007fcf43dee700(0000) GS:ffff880ffee40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000058 CR3: 0000001ff84bd000 CR4: 00000000000406e0
 Stack:
  ffffffffc053e125 ffff880ff8353000 ffff880ff8b9a000 ffff881fea697d10
  ffff881fea697d30 ffffffffc03801bb ffff881ff8c82340 ffffffffa8870cb0
  ffff881fea697d50 ffffffffa8432980 ffffffffa8625882 ffff880ff06bc900
 Call Trace:
  [<ffffffffc053e125>] ? qla2x00_get_starget_node_name+0x25/0x90 [qla2xxx]
  [<ffffffffc03801bb>] ? show_fc_host_fabric_name+0x4b/0x80 [scsi_transport_fc]
  [<ffffffffa8432980>] ? dev_attr_show+0x20/0x50
  [<ffffffffa8625882>] ? mutex_lock+0x12/0x30
  [<ffffffffa8264c0c>] ? sysfs_kf_seq_show+0xbc/0x130
  [<ffffffffa8263493>] ? kernfs_seq_show+0x23/0x30
  [<ffffffffa820c87a>] ? seq_read+0xca/0x360
  [<ffffffffa81f93e2>] ? do_filp_open+0x92/0xe0
  [<ffffffffa8263d8a>] ? kernfs_fop_read+0x10a/0x160
  [<ffffffffa81e7e78>] ? __vfs_read+0x28/0xe0
  [<ffffffffa8298170>] ? security_file_permission+0xa0/0xc0
  [<ffffffffa81e8d17>] ? rw_verify_area+0x57/0xd0
  [<ffffffffa81e8e12>] ? vfs_read+0x82/0x110
  [<ffffffffa81ea096>] ? SyS_read+0x46/0xa0
  [<ffffffffa8002c3e>] ? do_syscall_64+0x5e/0xc0
  [<ffffffffa86277e5>] ? entry_SYSCALL64_slow_path+0x25/0x25
 Code: 00 00 00 90 66 66 66 66 90 0f b7 06 55 39 87 b0 fc ff ff 48 89 e5 5d 0f
94 c0 0f b6 c0 c3 66 0f 1f 44 00 00 66 66 66 66 90 31 c0 <48> 81 7f 58 60 77 d3
a8 55 48 89 e5 5d 0f 94 c0 c3 0f 1f 84 00
 RIP  [<ffffffffa844df97>] scsi_is_host_device+0x7/0x20
  RSP <ffff881fea697cf0>
 CR2: 0000000000000058
 ---[ end trace 8d3e3efe3450a7ba ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
