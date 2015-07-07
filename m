From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] iscsi-target: Fix iscsit_start_kthreads failure OOPs
Date: Tue, 7 Jul 2015 15:04:24 +0300
Message-ID: <559BC048.703@dev.mellanox.co.il>
References: <1436259023-1561-1-git-send-email-nab@daterainc.com>
 <1436259702.23883.38.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436259702.23883.38.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 7/7/2015 12:01 PM, Nicholas A. Bellinger wrote:
> Hey Sagi,
>
> This addresses a regression with traditional iscsi-target that I noticed
> recently, but has not been tested with iser-target yet.
>
> Would you mind taking a quick spin with iser-target to verify, and try
> to intentionally fail iscsit_start_kthreads() into the two out_bitmap +
> out_tx error paths..?

Umm, I hit a BUG() statement while start to test this.

The easy reproducer is:
- create 20 iser targets (listen on any 0.0.0.0:3260)
- discover targets 2 initiator ports ports (40 target instances)
- run: for i in `seq 100`; do iscsiadm -m node -l && iscsiadm -m node 
-u; done

Note: I wasn't able to reproduce this with iscsi/tcp.

Stack dump:
kernel: isert: isert_wait4logout: conn ffff8803db5a9800
kernel: ------------[ cut here ]------------
kernel: isert: isert_wait4logout: conn ffff8803db5a9800 wait for 
conn_logout_comp
kernel: kernel BUG at drivers/target/iscsi/iscsi_target.c:4465!
kernel: invalid opcode: 0000 [#1] SMP
kernel: Modules linked in: ib_umad ib_ipoib mlx5_ib mlx5_core 
target_core_user uio tcm_loop vhost_scsi tcm_qla2xxx ib_srpt ib_isert 
iscsi_target_mod tcm_fc target_core_file target_core_iblock 
target_core_pscsi target_core_mod vhost rdma_cm ib_cm iw_cm ib_sa ib_mad 
ib_core ib_addr libfc netconsole configfs nfsd exportfs nfsv3 nfs_acl 
rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs fscache lockd grace autofs4 sunrpc 
cpufreq_ondemand ipv6 ext4 jbd2 dm_mirror dm_region_hash dm_log
kernel: isert: isert_wait_conn: Starting conn ffff8803df09c800
kernel: uinput
kernel: isert: isert_wait4cmds: iscsi_conn ffff8803db171000
kernel: iTCO_wdt
kernel: isert: isert_wait4flush: conn ffff8803df09c800
kernel: iTCO_vendor_support microcode serio_raw pcspkr
kernel: isert: isert_release_work: Starting release conn ffff8803db5a9800
kernel: sb_edac
kernel: isert: isert_release_work: Destroying conn ffff8803db5a9800
kernel: edac_core sg ipmi_si ipmi_msghandler acpi_cpufreq i2c_i801 
lpc_ich mfd_core shpchp ioatdma dm_mod igb dca i2c_algo_bit i2c_core ptp 
pps_core wmi ext3(E) jbd(E) mbcache(E) sd_mod(E) ahci(E) libahci(E) 
isci(E) libsas(E)
kernel: isert: isert_release_kref: conn ffff8803db5a9800 final kref 
iscsi_trx/30457
kernel: scsi_transport_sas(E)
kernel: isert: isert_conn_free_fastreg_pool: Freeing conn 
ffff8803db5a9800 fastreg pool
kernel: qla2xxx(E) scsi_transport_fc(E) [last unloaded: uio]
kernel: CPU: 14 PID: 30286 Comm: kworker/u52:6 Tainted: G            E 
  4.1.0-rc1+ #44
kernel: Hardware name: Supermicro SYS-1027R-WRF/X9DRW, BIOS 3.0a 08/08/2013
kernel: Workqueue: isert_comp_wq isert_do_control_comp [ib_isert]
kernel: task: ffff88046f618e50 ti: ffff8803e12f4000 task.ti: 
ffff8803e12f4000
kernel: RIP: 0010:[<ffffffffa05b36d8>]  [<ffffffffa05b36d8>] 
iscsit_close_session+0x1c8/0x230 [iscsi_target_mod]
kernel: RSP: 0018:ffff8803e12f7d38  EFLAGS: 00010296
kernel: RAX: 0000000000000053 RBX: ffff8803db173c00 RCX: 000000000000209c
kernel: RDX: 0000000000000001 RSI: 0000000000000282 RDI: ffffffff81a3b8f0
kernel: RBP: ffff8803e12f7d58 R08: 0000000000000000 R09: ffffffff81d1facb
kernel: R10: 000000000003fa34 R11: 0000000000000053 R12: ffff8803db171000
kernel: R13: ffff88046b99c000 R14: 0000000000000000 R15: ffff88046fad8e05
kernel: FS:  0000000000000000(0000) GS:ffff88047fd00000(0000) 
knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 0000003c8f66e940 CR3: 0000000001a0e000 CR4: 00000000000406e0
kernel: Stack:
kernel: ffff8803e12f7d88 ffff8803db173c00 ffff8803db171000 0000000000000000
kernel: ffff8803e12f7d68 ffffffffa05bdd8d ffff8803e12f7d78 ffffffffa04c014c
kernel: ffff8803e12f7d88 ffffffffa04c0a09 ffff8803e12f7db8 ffffffffa05b346d
kernel: Call Trace:
kernel: [<ffffffffa05bdd8d>] lio_tpg_close_session+0xd/0x10 
[iscsi_target_mod]
kernel: [<ffffffffa04c014c>] target_release_session+0x1c/0x20 
[target_core_mod]
kernel: [<ffffffffa04c0a09>] target_put_session+0x19/0x20 [target_core_mod]
kernel: [<ffffffffa05b346d>] iscsit_logout_post_handler+0x9d/0x140 
[iscsi_target_mod]
kernel: [<ffffffffa0545e5f>] isert_do_control_comp+0xcf/0x120 [ib_isert]
kernel: [<ffffffff8106a736>] process_one_work+0x136/0x3a0
kernel: [<ffffffff8106aab7>] worker_thread+0x117/0x3d0
kernel: [<ffffffff8106a9a0>] ? process_one_work+0x3a0/0x3a0
kernel: [<ffffffff8106a9a0>] ? process_one_work+0x3a0/0x3a0
kernel: [<ffffffff8106f5fe>] kthread+0xce/0xf0
kernel: [<ffffffff8106f530>] ? kthread_freezable_should_stop+0x70/0x70
kernel: [<ffffffff815515d2>] ret_from_fork+0x42/0x70
kernel: [<ffffffff8106f530>] ? kthread_freezable_should_stop+0x70/0x70
kernel: Code: 00 00 00 48 89 df e8 c8 3f ff ff e9 f7 fe ff ff 8b b7 b8 
00 00 00 48 8b 97 f0 01 00 00 31 c0 48 c7 c7 a8 a1 5c a0 e8 25 9b f9 e0 
<0f> 0b eb fe 48 c7 c6 08 a2 5c a0 48 c7 c7 20 15 5d a0 31 c0 e8
kernel: RIP  [<ffffffffa05b36d8>] iscsit_close_session+0x1c8/0x230 
[iscsi_target_mod]
kernel: RSP <ffff8803e12f7d38>
kernel: ---[ end trace a25d406905884052 ]---
kernel: qla2xxx(E) scsi_transport_fc(E) [last unloaded: uio]
kernel: CPU: 14 PID: 30286 Comm: kworker/u52:6 Tainted: G            E 
  4.1.0-rc1+ #44
kernel: Hardware name: Supermicro SYS-1027R-WRF/X9DRW, BIOS 3.0a 08/08/2013
kernel: Workqueue: isert_comp_wq isert_do_control_comp [ib_isert]
kernel: task: ffff88046f618e50 ti: ffff8803e12f4000 task.ti: 
ffff8803e12f4000
kernel: RIP: 0010:[<ffffffffa05b36d8>]  [<ffffffffa05b36d8>] 
iscsit_close_session+0x1c8/0x230 [iscsi_target_mod]
kernel: RSP: 0018:ffff8803e12f7d38  EFLAGS: 00010296
kernel: RAX: 0000000000000053 RBX: ffff8803db173c00 RCX: 000000000000209c
kernel: RDX: 0000000000000001 RSI: 0000000000000282 RDI: ffffffff81a3b8f0
kernel: RBP: ffff8803e12f7d58 R08: 0000000000000000 R09: ffffffff81d1facb
kernel: R10: 000000000003fa34 R11: 0000000000000053 R12: ffff8803db171000
kernel: R13: ffff88046b99c000 R14: 0000000000000000 R15: ffff88046fad8e05
kernel: FS:  0000000000000000(0000) GS:ffff88047fd00000(0000) 
knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 0000003c8f66e940 CR3: 0000000001a0e000 CR4: 00000000000406e0
kernel: Stack:
kernel: ffff8803e12f7d88 ffff8803db173c00 ffff8803db171000 0000000000000000
kernel: ffff8803e12f7d68 ffffffffa05bdd8d ffff8803e12f7d78 ffffffffa04c014c
kernel: ffff8803e12f7d88 ffffffffa04c0a09 ffff8803e12f7db8 ffffffffa05b346d
kernel: Call Trace:
kernel: [<ffffffffa05bdd8d>] lio_tpg_close_session+0xd/0x10 
[iscsi_target_mod]
kernel: [<ffffffffa04c014c>] target_release_session+0x1c/0x20 
[target_core_mod]
kernel: [<ffffffffa04c0a09>] target_put_session+0x19/0x20 [target_core_mod]
kernel: [<ffffffffa05b346d>] iscsit_logout_post_handler+0x9d/0x140 
[iscsi_target_mod]
kernel: [<ffffffffa0545e5f>] isert_do_control_comp+0xcf/0x120 [ib_isert]
kernel: [<ffffffff8106a736>] process_one_work+0x136/0x3a0
kernel: [<ffffffff8106aab7>] worker_thread+0x117/0x3d0
kernel: [<ffffffff8106a9a0>] ? process_one_work+0x3a0/0x3a0
kernel: [<ffffffff8106a9a0>] ? process_one_work+0x3a0/0x3a0
kernel: [<ffffffff8106f5fe>] kthread+0xce/0xf0
kernel: [<ffffffff8106f530>] ? kthread_freezable_should_stop+0x70/0x70
kernel: [<ffffffff815515d2>] ret_from_fork+0x42/0x70
kernel: [<ffffffff8106f530>] ? kthread_freezable_should_stop+0x70/0x70
kernel: Code: 00 00 00 48 89 df e8 c8 3f ff ff e9 f7 fe ff ff 8b b7 b8 
00 00 00 48 8b 97 f0 01 00 00 31 c0 48 c7 c7 a8 a1 5c a0 e8 25 9b f9 e0 
<0f> 0b eb fe 48 c7 c6 08 a2 5c a0 48 c7 c7 20 15 5d a0 31 c0 e8
kernel: RIP  [<ffffffffa05b36d8>] iscsit_close_session+0x1c8/0x230 
[iscsi_target_mod]
kernel: RSP <ffff8803e12f7d38>
kernel: ---[ end trace a25d406905884052 ]---
kernel: isert: isert_cq_comp_err: conn ffff8803df09c800 completing 
wait_comp_err
kernel: isert: isert_wait4logout: conn ffff8803df09c800
kernel: isert: isert_wait4logout: conn ffff8803df09c800 wait for 
conn_logout_comp
kernel: isert: isert_release_work: Starting release conn ffff8803df09c800
kernel: isert: isert_release_work: Destroying conn ffff8803df09c800
kernel: isert: isert_release_kref: conn ffff8803df09c800 final kref 
kworker/u50:3/30347
kernel: isert: isert_conn_free_fastreg_pool: Freeing conn 
ffff8803df09c800 fastreg pool
kernel: BUG: unable to handle kernel paging request at ffffffffffffffd8
kernel: IP: [<ffffffff8106ef5b>] kthread_data+0xb/0x20
kernel: PGD 1a0f067 PUD 1a11067 PMD 0
kernel: Oops: 0000 [#2] SMP
kernel: Modules linked in: ib_umad ib_ipoib mlx5_ib mlx5_core 
target_core_user uio tcm_loop vhost_scsi tcm_qla2xxx ib_srpt ib_isert 
iscsi_target_mod tcm_fc target_core_file target_core_iblock 
target_core_pscsi target_core_mod vhost rdma_cm ib_cm iw_cm ib_sa ib_mad 
ib_core ib_addr libfc netconsole configfs nfsd exportfs nfsv3 nfs_acl 
rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs fscache lockd grace autofs4 sunrpc 
cpufreq_ondemand ipv6 ext4 jbd2 dm_mirror dm_region_hash dm_log uinput 
iTCO_wdt iTCO_vendor_support microcode serio_raw pcspkr sb_edac 
edac_core sg ipmi_si ipmi_msghandler acpi_cpufreq i2c_i801 lpc_ich 
mfd_core shpchp ioatdma dm_mod igb dca i2c_algo_bit i2c_core ptp 
pps_core wmi ext3(E) jbd(E) mbcache(E) sd_mod(E) ahci(E) libahci(E) 
isci(E) libsas(E) scsi_transport_sas(E) qla2xxx(E) scsi_transport_fc(E) 
[last unloaded: uio]
kernel: CPU: 4 PID: 30286 Comm: kworker/u52:6 Tainted: G      D     E 
4.1.0-rc1+ #44
kernel: Hardware name: Supermicro SYS-1027R-WRF/X9DRW, BIOS 3.0a 08/08/2013
kernel: task: ffff88046f618e50 ti: ffff8803e12f4000 task.ti: 
ffff8803e12f4000
kernel: RIP: 0010:[<ffffffff8106ef5b>]  [<ffffffff8106ef5b>] 
kthread_data+0xb/0x20
kernel: RSP: 0018:ffff8803e12f79d8  EFLAGS: 00010096
kernel: RAX: 0000000000000000 RBX: 0000000000000004 RCX: ffffffff81cdcc60
kernel: RDX: ffff88046f618e50 RSI: 0000000000000004 RDI: ffff88046f618e50
kernel: RBP: ffff8803e12f79d8 R08: ffff88046f618ee0 R09: dead000000200200
kernel: R10: dead000000200200 R11: 0000000000000007 R12: 0000000000000004
kernel: R13: ffff88046f619798 R14: 0000000000000001 R15: 0000000000000004
kernel: FS:  0000000000000000(0000) GS:ffff88047fc80000(0000) 
knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 0000000000000028 CR3: 0000000001a0e000 CR4: 00000000000406e0
kernel: Stack:
kernel: ffff8803e12f79f8 ffffffff81068710 ffff8803e12f79f8 ffff88047fc94a80
kernel: ffff8803e12f7a48 ffffffff8154d973 ffff88046f618e50 ffff8803e12f7a38
kernel: ffff88046f6196c8 ffff8803e12f4008 000000000000000b ffff88046f6199a4
kernel: Call Trace:
kernel: [<ffffffff81068710>] wq_worker_sleeping+0x10/0xa0
kernel: [<ffffffff8154d973>] __schedule+0x503/0x710
kernel: [<ffffffff8154dcd9>] schedule+0x39/0x90
kernel: [<ffffffff8105721a>] do_exit+0x2ca/0x470
kernel: [<ffffffff8109e0ec>] ? kmsg_dump+0x9c/0xc0
kernel: [<ffffffff810071fb>] oops_end+0x9b/0xe0
kernel: [<ffffffff81007626>] die+0x56/0x90
kernel: [<ffffffff81004011>] do_trap+0x161/0x170
kernel: [<ffffffff8107020d>] ? __atomic_notifier_call_chain+0xd/0x10
kernel: [<ffffffff81004547>] do_error_trap+0xb7/0x100
kernel: [<ffffffffa05b36d8>] ? iscsit_close_session+0x1c8/0x230 
[iscsi_target_mod]
kernel: [<ffffffff810927d2>] ? down_trylock+0x32/0x50
kernel: [<ffffffff8109ea30>] ? console_trylock+0x10/0x50
kernel: [<ffffffff8100464b>] do_invalid_op+0x1b/0x20
kernel: [<ffffffff81552498>] invalid_op+0x18/0x20
kernel: [<ffffffffa05b36d8>] ? iscsit_close_session+0x1c8/0x230 
[iscsi_target_mod]
kernel: [<ffffffffa05b36d8>] ? iscsit_close_session+0x1c8/0x230 
[iscsi_target_mod]
kernel: [<ffffffffa05bdd8d>] lio_tpg_close_session+0xd/0x10 
[iscsi_target_mod]
kernel: [<ffffffffa04c014c>] target_release_session+0x1c/0x20 
[target_core_mod]
kernel: [<ffffffffa04c0a09>] target_put_session+0x19/0x20 [target_core_mod]
kernel: [<ffffffffa05b346d>] iscsit_logout_post_handler+0x9d/0x140 
[iscsi_target_mod]
kernel: [<ffffffffa0545e5f>] isert_do_control_comp+0xcf/0x120 [ib_isert]
kernel: [<ffffffff8106a736>] process_one_work+0x136/0x3a0
kernel: [<ffffffff8106aab7>] worker_thread+0x117/0x3d0
kernel: [<ffffffff8106a9a0>] ? process_one_work+0x3a0/0x3a0
kernel: [<ffffffff8106a9a0>] ? process_one_work+0x3a0/0x3a0
kernel: [<ffffffff8106f5fe>] kthread+0xce/0xf0
kernel: [<ffffffff8106f530>] ? kthread_freezable_should_stop+0x70/0x70
kernel: [<ffffffff815515d2>] ret_from_fork+0x42/0x70
kernel: [<ffffffff8106f530>] ? kthread_freezable_should_stop+0x70/0x70
kernel: Code: 00 48 89 e5 48 8b 40 c8 c9 48 c1 e8 02 83 e0 01 c3 66 66 
66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 87 f0 08 00 00 55 48 89 e5 
<48> 8b 40 d8 c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
kernel: RIP  [<ffffffff8106ef5b>] kthread_data+0xb/0x20
kernel: RSP <ffff8803e12f79d8>
kernel: CR2: ffffffffffffffd8
kernel: ---[ end trace a25d406905884053 ]---
kernel: Fixing recursive fault but reboot is needed!
