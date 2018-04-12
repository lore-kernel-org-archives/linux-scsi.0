From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH] target: Fix Fortify_panic kernel exception
Date: Thu, 12 Apr 2018 15:58:42 -0500
Message-ID: <1523566722-24667-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: hch@lst.de, nab@linux-iscsi.org, martin.petersen@oracle.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-block@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[  496.212783] ------------[ cut here ]------------
[  496.212784] kernel BUG at /build/linux-hwe-edge-ojNirv/linux-hwe-edge-4.15.0/lib/string.c:1052!
[  496.212789] Oops: Exception in kernel mode, sig: 5 [#1]
[  496.212791] LE SMP NR_CPUS=2048 NUMA pSeries
[  496.212795] Modules linked in: hvcs(OE) hvcserver dm_snapshot dm_bufio rpadlpar_io rpaphp ip6table_raw xt_CT xt_mac xt_tcpudp xt_comment xt_physdev xt_set ip_set_hash_net ip_set iptable_raw dccp_diag dccp tcp_diag udp_diag inet_diag unix_diag af_packet_diag netlink_diag target_core_pscsi(OE) target_core_file(OE) target_core_iblock(OE) iscsi_target_mod(OE) vxlan ip6_udp_tunnel udp_tunnel openvswitch nsh nf_nat_ipv6 target_core_user(OE) uio binfmt_misc xt_conntrack nf_conntrack_netlink nfnetlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv6 nf_defrag_ipv6 nbd ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 pseries_rng nf_nat ibmvmc(OE) nf_conntrack libcrc32c vmx_crypto crct10dif_vpmsum iptable_mang
 le iptable_filter
[  496.212854]  ip_tables ip6table_filter ip6_tables ebtables x_tables br_netfilter bridge stp llc ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 mlx4_en ses enclosure scsi_transport_sas uas usb_storage ibmvscsis(OE) target_core_mod(OE) ibmveth(OE) mlx5_core mlx4_core mlxfw crc32c_vpmsum be2net tg3 ipr devlink
[  496.212888] CPU: 1 PID: 2587 Comm: kworker/1:2 Tainted: G           OE    4.15.0-15-generic #16~16.04.1-Ubuntu
[  496.212897] Workqueue: ibmvscsis3000000f ibmvscsis_scheduler [ibmvscsis]
[  496.212900] NIP:  c000000000cbbf00 LR: c000000000cbbefc CTR: 0000000000655170
[  496.212903] REGS: c0000007e58e3580 TRAP: 0700   Tainted: G           OE     (4.15.0-15-generic)
[  496.212906] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 286c2222  XER: 20000003
[  496.212915] CFAR: c00000000018d634 SOFTE: 1
               GPR00: c000000000cbbefc c0000007e58e3800 c0000000016bae00 0000000000000022
               GPR04: c0000007fe94ce18 c0000007fe964368 0000000000000003 ffffffffffffffff
               GPR08: 0000000000000007 c000000001193a74 00000007fd7c0000 0000000000003986
               GPR12: 0000000000002200 c00000000fa80b00 c00000000013a308 c0000007f48adb00
               GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
               GPR20: 0000000000000000 0000000000000000 fffffffffffffef7 0000000000000402
               GPR24: 0000000000000000 f000000001a8cb40 00000000000003f0 0000000000648010
               GPR28: c0000005a360a570 c0000007f4095880 c0000000fc9e7e00 c0000007f1f56000
[  496.212952] NIP [c000000000cbbf00] fortify_panic+0x28/0x38
[  496.212956] LR [c000000000cbbefc] fortify_panic+0x24/0x38
[  496.212958] Call Trace:
[  496.212960] [c0000007e58e3800] [c000000000cbbefc] fortify_panic+0x24/0x38 (unreliable)
[  496.212965] [c0000007e58e3860] [d00000000f150c28] iblock_execute_write_same+0x3b8/0x3c0 [target_core_iblock]
[  496.212976] [c0000007e58e3910] [d000000006c737d4] __target_execute_cmd+0x54/0x150 [target_core_mod]
[  496.212982] [c0000007e58e3940] [d000000006d32ce4] ibmvscsis_write_pending+0x74/0xe0 [ibmvscsis]
[  496.212991] [c0000007e58e39b0] [d000000006c74fc8] transport_generic_new_cmd+0x318/0x370 [target_core_mod]
[  496.213001] [c0000007e58e3a30] [d000000006c75084] transport_handle_cdb_direct+0x64/0xd0 [target_core_mod]
[  496.213011] [c0000007e58e3aa0] [d000000006c75298] target_submit_cmd_map_sgls+0x1a8/0x320 [target_core_mod]
[  496.213021] [c0000007e58e3b30] [d000000006c75458] target_submit_cmd+0x48/0x60 [target_core_mod]
[  496.213026] [c0000007e58e3bd0] [d000000006d34c20] ibmvscsis_scheduler+0x370/0x600 [ibmvscsis]
[  496.213031] [c0000007e58e3c90] [c00000000013135c] process_one_work+0x1ec/0x580
[  496.213035] [c0000007e58e3d20] [c000000000131798] worker_thread+0xa8/0x600
[  496.213039] [c0000007e58e3dc0] [c00000000013a468] kthread+0x168/0x1b0
[  496.213044] [c0000007e58e3e30] [c00000000000b528] ret_from_kernel_thread+0x5c/0xb4
[  496.213047] Instruction dump:
[  496.213049] 7c0803a6 4e800020 3c4c00a0 3842ef28 7c0802a6 f8010010 f821ffa1 7c641b78
[  496.213055] 3c62ff94 3863dc00 4b4d16f1 60000000 <0fe00000> 00000000 00000000 00000000
[  496.213062] ---[ end trace 4c7e8c92043f3868 ]---
[  654.577815] ibmvscsis 3000000f: connection lost with outstanding work

The patch fixes the above trace where the size passed into
memcmp is greater than the size of the data passed in from
ptr1 or ptr2 then a fortify_panic is posted.

Fixes: 2237498f0b5c ("target/iblock: Convert WRITE_SAME to blkdev_issue_zeroout")
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Reviewed-by: Steven Royer <seroyer@linux.vnet.ibm.com>
Tested-by: Taylor Jakobson <tjakobs@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: <stable@vger.kernel.org>
---
 drivers/target/target_core_iblock.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 07c814c..6042901 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -427,8 +427,8 @@ iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct scatterlist *sg = &cmd->t_data_sg[0];
-	unsigned char *buf, zero = 0x00, *p = &zero;
-	int rc, ret;
+	unsigned char *buf, *not_zero;
+	int ret;
 
 	buf = kmap(sg_page(sg)) + sg->offset;
 	if (!buf)
@@ -437,10 +437,10 @@ iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
 	 * Fall back to block_execute_write_same() slow-path if
 	 * incoming WRITE_SAME payload does not contain zeros.
 	 */
-	rc = memcmp(buf, p, cmd->data_length);
+	not_zero = memchr_inv(buf, 0x00, cmd->data_length);
 	kunmap(sg_page(sg));
 
-	if (rc)
+	if (not_zero)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	ret = blkdev_issue_zeroout(bdev,
-- 
2.7.2
