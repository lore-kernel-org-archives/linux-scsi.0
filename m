From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 08/31] target: Fix demo-mode MappedLUN shutdown UA/PR breakage
Date: Wed,  9 Feb 2011 15:34:43 -0800
Message-ID: <1297294506-23579-9-git-send-email-nab@linux-iscsi.org>
References: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm10.bullet.mail.sp2.yahoo.com ([98.139.91.80]:46522 "HELO
	nm10.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755755Ab1BIXfS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 18:35:18 -0500
In-Reply-To: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in core_update_device_list_for_node() where individual
demo-mode generated MappedLUN's UA + Persistent Reservations metadata where being
leaked, instead of falling through and calling existing core_scsi3_ua_release_all()
and core_scsi3_free_pr_reg_from_nacl() at the end of core_update_device_list_for_node().

This bug would manifest itself with the following OOPs w/ TPG demo-mode endpoints
(tfo->tpg_check_demo_mode()=1), and PROUT REGISTER+RESERVE -> explict struct se_session
logout -> struct se_device shutdown:

[  697.021139] LIO_iblock used greatest stack depth: 2704 bytes left
[  702.235017] general protection fault: 0000 [#1] SMP
[  702.235074] last sysfs file: /sys/devices/virtual/net/lo/operstate
[  704.372695] CPU 0
[  704.372725] Modules linked in: crc32c target_core_stgt scsi_tgt target_core_pscsi target_core_file target_core_iblock target_core_mod configfs sr_mod cdrom sd_mod ata_piix mptspi mptscsih libata mptbase [last unloaded: iscsi_target_mod]
[  704.375442]
[  704.375563] Pid: 4964, comm: tcm_node Not tainted 2.6.37+ #1 440BX Desktop Reference Platform/VMware Virtual Platform
[  704.375912] RIP: 0010:[<ffffffffa00aaa16>]  [<ffffffffa00aaa16>] __core_scsi3_complete_pro_release+0x31/0x133 [target_core_mod]
[  704.376017] RSP: 0018:ffff88001e5ffcb8  EFLAGS: 00010296
[  704.376017] RAX: 6d32335b1b0a0d0a RBX: ffff88001d952cb0 RCX: 0000000000000015
[  704.376017] RDX: ffff88001b428000 RSI: ffff88001da5a4c0 RDI: ffff88001e5ffcd8
[  704.376017] RBP: ffff88001e5ffd28 R08: ffff88001e5ffcd8 R09: ffff88001d952080
[  704.377116] R10: ffff88001dfc5480 R11: ffff88001df8abb0 R12: ffff88001d952cb0
[  704.377319] R13: 0000000000000000 R14: ffff88001df8abb0 R15: ffff88001b428000
[  704.377521] FS:  00007f033d15c6e0(0000) GS:ffff88001fa00000(0000) knlGS:0000000000000000
[  704.377861] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  704.378043] CR2: 00007fff09281510 CR3: 000000001e5db000 CR4: 00000000000006f0
[  704.378110] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  704.378110] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  704.378110] Process tcm_node (pid: 4964, threadinfo ffff88001e5fe000, task ffff88001d99c260)
[  704.378110] Stack:
[  704.378110]  ffffea0000678980 ffff88001da5a4c0 ffffea0000678980 ffff88001f402b00
[  704.378110]  ffff88001e5ffd08 ffffffff810ea236 ffff88001e5ffd18 0000000000000282
[  704.379772]  ffff88001d952080 ffff88001d952cb0 ffff88001d952cb0 ffff88001dc79010
[  704.380082] Call Trace:
[  704.380220]  [<ffffffff810ea236>] ? __slab_free+0x89/0x11c
[  704.380403]  [<ffffffffa00ab781>] core_scsi3_free_all_registrations+0x3e/0x157 [target_core_mod]
[  704.380479]  [<ffffffffa00a752b>] se_release_device_for_hba+0xa6/0xd8 [target_core_mod]
[  704.380479]  [<ffffffffa00a7598>] se_free_virtual_device+0x3b/0x45 [target_core_mod]
[  704.383750]  [<ffffffffa00a3177>] target_core_drop_subdev+0x13a/0x18d [target_core_mod]
[  704.384068]  [<ffffffffa00960db>] client_drop_item+0x25/0x31 [configfs]
[  704.384263]  [<ffffffffa00967b5>] configfs_rmdir+0x1a1/0x223 [configfs]
[  704.384459]  [<ffffffff810fa8cd>] vfs_rmdir+0x7e/0xd3
[  704.384631]  [<ffffffff810fc3be>] do_rmdir+0xa3/0xf4
[  704.384895]  [<ffffffff810eed15>] ? filp_close+0x67/0x72
[  704.386485]  [<ffffffff810fc446>] sys_rmdir+0x11/0x13
[  704.387893]  [<ffffffff81002a92>] system_call_fastpath+0x16/0x1b
[  704.388083] Code: 4c 8d 45 b0 41 56 49 89 d7 41 55 41 89 cd 41 54 b9 15 00 00 00 53 48 89 fb 48 83 ec 48 4c 89 c7 48 89 75 98 48 8b 86 28 01 00 00 <48> 8b 80 90 01 00 00 48 89 45 a0 31 c0 f3 aa c7 45 ac 00 00 00
[  704.388763] RIP  [<ffffffffa00aaa16>] __core_scsi3_complete_pro_release+0x31/0x133 [target_core_mod]
[  704.389142]  RSP <ffff88001e5ffcb8>
[  704.389572] ---[ end trace 2a3614f3cd6261a5 ]---

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 317ce58..969d727 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -373,11 +373,11 @@ int core_update_device_list_for_node(
 		/*
 		 * deve->se_lun_acl will be NULL for demo-mode created LUNs
 		 * that have not been explictly concerted to MappedLUNs ->
-		 * struct se_lun_acl.
+		 * struct se_lun_acl, but we remove deve->alua_port_list from
+		 * port->sep_alua_list. This also means that active UAs and
+		 * NodeACL context specific PR metadata for demo-mode
+		 * MappedLUN *deve will be released below..
 		 */
-		if (!(deve->se_lun_acl))
-			return 0;
-
 		spin_lock_bh(&port->sep_alua_lock);
 		list_del(&deve->alua_port_list);
 		spin_unlock_bh(&port->sep_alua_lock);
-- 
1.7.4

