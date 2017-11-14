From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/8] target: remove iblock WRITE_SAME passthrough support
Date: Tue, 14 Nov 2017 12:05:13 -0600
Message-ID: <8317f360-2852-047f-b60c-2012ed578950@linux.vnet.ibm.com>
References: <20170410160807.23674-1-hch@lst.de>
 <20170410160807.23674-3-hch@lst.de>
 <1491975041.8231.131.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1491975041.8231.131.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, target-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 4/12/17 12:30 AM, Nicholas A. Bellinger wrote:

> On Mon, 2017-04-10 at 18:08 +0200, Christoph Hellwig wrote:
>> Use the pscsi driver to support arbitrary command passthrough
>> instead.
>>
> The people who are actively using iblock_execute_write_same_direct() are
> doing so in the context of ESX VAAI BlockZero, together with
> EXTENDED_COPY and COMPARE_AND_WRITE primitives.  Just using PSCSI is not
> an option for them.
>
> In practice though I've not seen any users of IBLOCK WRITE_SAME for
> anything other than VAAI BlockZero, so just using blkdev_issue_zeroout()
> when available, and falling back to iblock_execute_write_same() if the
> WRITE_SAME buffer contains anything other than zeros should be OK.
>
> How about something like the following below..?
>
> This would bring parity to how blkdev_issue_write_same() works atm wrt
> to synchronous bio completions.  However, most folks with a raw
> make_request or blk-mq backend driver that supports multiple GB/sec of
> zero bandwidth end up changing IBLOCK to support asynchronous
> REQ_WRITE_SAME completions anyways.
>
> I'd be happy to add support for that using __blkdev_issue_zeroout() once
> the basic conversion is in place.
>
> From ff74012eaff38f9fa0d74aca60507b9964f484ce Mon Sep 17 00:00:00 2001
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> Date: Tue, 11 Apr 2017 22:21:47 -0700
> Subject: [PATCH] target/iblock: Convert WRITE_SAME to blkdev_issue_zeroout
>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_iblock.c | 44 +++++++++++++++++++++++--------------
>  1 file changed, 27 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index d316ed5..5bfde20 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -86,6 +86,7 @@ static int iblock_configure_device(struct se_device *dev)
>  	struct block_device *bd = NULL;
>  	struct blk_integrity *bi;
>  	fmode_t mode;
> +	unsigned int max_write_zeroes_sectors;
>  	int ret = -ENOMEM;
>
>  	if (!(ib_dev->ibd_flags & IBDF_HAS_UDEV_PATH)) {
> @@ -129,7 +130,11 @@ static int iblock_configure_device(struct se_device *dev)
>  	 * Enable write same emulation for IBLOCK and use 0xFFFF as
>  	 * the smaller WRITE_SAME(10) only has a two-byte block count.
>  	 */
> -	dev->dev_attrib.max_write_same_len = 0xFFFF;
> +	max_write_zeroes_sectors = bdev_write_zeroes_sectors(bd);
> +	if (max_write_zeroes_sectors)
> +		dev->dev_attrib.max_write_same_len = max_write_zeroes_sectors;
> +	else
> +		dev->dev_attrib.max_write_same_len = 0xFFFF;
>
>  	if (blk_queue_nonrot(q))
>  		dev->dev_attrib.is_nonrot = 1;
> @@ -415,28 +420,31 @@ static void iblock_end_io_flush(struct bio *bio)
>  }
>
>  static sense_reason_t
> -iblock_execute_write_same_direct(struct block_device *bdev, struct se_cmd *cmd)
> +iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
>  {
>  	struct se_device *dev = cmd->se_dev;
>  	struct scatterlist *sg = &cmd->t_data_sg[0];
> -	struct page *page = NULL;
> -	int ret;
> +	unsigned char *buf, zero = 0x00, *p = &zero;
> +	int rc, ret;
>
> -	if (sg->offset) {
> -		page = alloc_page(GFP_KERNEL);
> -		if (!page)
> -			return TCM_OUT_OF_RESOURCES;
> -		sg_copy_to_buffer(sg, cmd->t_data_nents, page_address(page),
> -				  dev->dev_attrib.block_size);
> -	}
> +	buf = kmap(sg_page(sg)) + sg->offset;
> +	if (!buf)
> +		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +	/*
> +	 * Fall back to block_execute_write_same() slow-path if
> +	 * incoming WRITE_SAME payload does not contain zeros.
> +	 */
> +	rc = memcmp(buf, p, cmd->data_length);
> +	kunmap(sg_page(sg));
> +

I recently pulled in this patch and I am getting:

[  716.756756] ------------[ cut here ]------------
[  716.756757] kernel BUG at /build/linux-hwe-edge-F6_Smd/linux-hwe-edge-4.13.0/lib/string.c:985!
[  716.756762] Oops: Exception in kernel mode, sig: 5 [#1]
[  716.756764] SMP NR_CPUS=2048 
[  716.756765] NUMA 
[  716.756767] pSeries
[  716.756769] Modules linked in: hvcs(OE) hvcserver dm_snapshot dm_bufio ip6table_raw xt_CT xt_mac xt_tcpudp xt_comment xt_physdev xt_set ip_set_hash_net ip_set rpadlpar_io rpaphp iptable_raw target_core_pscsi(OE) target_core_file(OE) target_core_iblock(OE) iscsi_target_mod(OE) dccp_diag dccp tcp_diag udp_diag inet_diag unix_diag af_packet_diag netlink_diag vport_vxlan vxlan ip6_udp_tunnel udp_tunnel openvswitch nf_nat_ipv6 target_core_user(OE) uio binfmt_misc ibmvmc(OE) pseries_rng vmx_crypto crct10dif_vpmsum xt_conntrack nf_nat_ftp nf_conntrack_ftp nf_conntrack_netlink nfnetlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv6 nf_defrag_ipv6 nbd ipt_REJECT nf_reject_ipv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
  nf_conntrack
[  716.756825]  iptable_mangle iptable_filter ip_tables ip6table_filter ip6_tables ebtables x_tables br_netfilter bridge stp llc ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 multipath linear mlx4_en dm_round_robin ses enclosure scsi_transport_sas ibmvscsis(OE) target_core_mod(OE) ibmveth(OE) mlx5_core mlx4_core bnx2x mdio libcrc32c crc32c_vpmsum mlxfw ipr devlink tg3 scsi_dh_emc scsi_dh_rdac scsi_dh_alua dm_multipath
[  716.756872] CPU: 1 PID: 3685 Comm: kworker/1:2 Tainted: G           OE   4.13.0-16-generic #19~16.04.3-Ubuntu
[  716.756880] Workqueue: ibmvscsis30000008 ibmvscsis_scheduler [ibmvscsis]
[  716.756883] task: c0000001ee076a00 task.stack: c0000001b536c000
[  716.756885] NIP: c000000000c26620 LR: c000000000c2661c CTR: 0000000000655170
[  716.756888] REGS: c0000001b536f590 TRAP: 0700   Tainted: G           OE    (4.13.0-16-generic)
[  716.756891] MSR: 800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>
[  716.756896]   CR: 28482222  XER: 20000003
[  716.756899] CFAR: c000000000179740 SOFTE: 1 
               GPR00: c000000000c2661c c0000001b536f810 c0000000015c2b00 0000000000000022 
               GPR04: c0000001f704ade8 c0000001f7062068 0000000000000003 ffffffffffffffff 
               GPR08: 0000000000000007 c0000000010d1a74 00000001f5f80000 0000000000000066 
               GPR12: 0000000000002200 c00000000fac0a80 c000000000129158 c0000001f2b5bb00 
               GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
               GPR20: 0000000000000000 0000000000000000 0000000000000000 fffffffffffffef7 
               GPR24: 0000000000000000 f0000000007a82c0 00000000000003f0 0000000000648010 
               GPR28: c00000004394fbd0 c0000001f36c2780 c0000001ddb0e700 c0000001e391a000 
[  716.756932] NIP [c000000000c26620] fortify_panic+0x28/0x38
[  716.756935] LR [c000000000c2661c] fortify_panic+0x24/0x38
[  716.756937] Call Trace:
[  716.756939] [c0000001b536f810] [c000000000c2661c] fortify_panic+0x24/0x38 (unreliable)
[  716.756944] [c0000001b536f870] [d000000013c30bf8] iblock_execute_write_same+0x3b8/0x3c0 [target_core_iblock]
[  716.756955] [c0000001b536f920] [d00000000b6537b4] __target_execute_cmd+0x54/0x150 [target_core_mod]
[  716.756960] [c0000001b536f950] [d00000000b822c90] ibmvscsis_write_pending+0x70/0xc0 [ibmvscsis]
[  716.756969] [c0000001b536f9c0] [d00000000b654f28] transport_generic_new_cmd+0x318/0x370 [target_core_mod]
[  716.756979] [c0000001b536fa40] [d00000000b654fe4] transport_handle_cdb_direct+0x64/0xd0 [target_core_mod]
[  716.756988] [c0000001b536fab0] [d00000000b6551f8] target_submit_cmd_map_sgls+0x1a8/0x320 [target_core_mod]
[  716.756998] [c0000001b536fb40] [d00000000b6553b8] target_submit_cmd+0x48/0x60 [target_core_mod]
[  716.757002] [c0000001b536fbe0] [d00000000b824bb0] ibmvscsis_scheduler+0x370/0x600 [ibmvscsis]
[  716.757007] [c0000001b536fca0] [c0000000001200fc] process_one_work+0x1ec/0x580
[  716.757010] [c0000001b536fd30] [c000000000120528] worker_thread+0x98/0x5d0
[  716.757013] [c0000001b536fdc0] [c0000000001292bc] kthread+0x16c/0x1b0
[  716.757017] [c0000001b536fe30] [c00000000000b4e8] ret_from_kernel_thread+0x5c/0x74
[  716.757020] Instruction dump:
[  716.757022] 7c0803a6 4e800020 3c4c009a 3842c508 7c0802a6 f8010010 f821ffa1 7c641b78 
[  716.757027] 3c62ff98 3863e8b8 4b5530dd 60000000 <0fe00000> 00000000 00000000 00000000 
[  716.757033] ---[ end trace 1f1264fedf09f0b7 ]---

It looks like memcmp is throwing the fortify panic due to size of ptrs being incorrectly
determined at compile time. 

-Bryant 
