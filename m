From: Florian Westphal <fw@strlen.de>
Subject: "WRITE SAME failed. Manually zeroing" with mptsas driver
Date: Mon, 26 Aug 2013 17:05:07 +0200
Message-ID: <20130826150507.GE32493@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58791 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796Ab3HZPFI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Aug 2013 11:05:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fw@strlen.de

Hi.

I get repeated "WRITE SAME" failed errors with
"SAS1064ET" Controller (mptsas driver).  Excerpt:

[ 5898.784829] Sense Key : 0x5 [current]
[ 5898.784833] sd 6:1:0:0: [sda]
[ 5898.784835] ASC=0x0 ASCQ=0x0
[ 5898.784837] sd 6:1:0:0: [sda] CDB:
[ 5898.784838] cdb[0]=0x41: 41 00 07 4f db 12 00 00 08 00
[ 5898.784858] sda6: WRITE SAME failed. Manually zeroing.
[ 5898.788884] sd 6:1:0:0: [sda]
[ 5898.788888] Result: hostbyte=0x00 driverbyte=0x08
[ 5898.788891] sd 6:1:0:0: [sda]
[ 5898.788893] Sense Key : 0x5 [current]
[ 5898.788896] sd 6:1:0:0: [sda]
[ 5898.788898] ASC=0x0 ASCQ=0x0
[ 5898.788900] sd 6:1:0:0: [sda] CDB:
[ 5898.788902] cdb[0]=0x41: 41 00 07 4f db 1a 00 00 10 00
[ 5898.788922] sda6: WRITE SAME failed. Manually zeroing.
[ 5898.792943] sd 6:1:0:0: [sda]

I tested with commit 66c28f97120e8a ("[SCSI] sd: Update WRITE SAME
heuristics") but that had no effect.

I would be grateful for any other ideas/fixes to try.

For the time being, I applied following hack which suppresses
the message spew:

--- linux-3.8.6.orig/block/blk-lib.c
+++ linux-3.8.6/block/blk-lib.c
@@ -285,7 +285,9 @@ int __blkdev_issue_zeroout(struct block_
 int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			 sector_t nr_sects, gfp_t gfp_mask)
 {
-	if (bdev_write_same(bdev)) {
+	static int failcnt;
+
+	if (failcnt < 16 && bdev_write_same(bdev)) {
 		unsigned char bdn[BDEVNAME_SIZE];
 
 		if (!blkdev_issue_write_same(bdev, sector, nr_sects, gfp_mask,
@@ -294,6 +296,7 @@ int blkdev_issue_zeroout(struct block_de
 
 		bdevname(bdev, bdn);
 		pr_err("%s: WRITE SAME failed. Manually zeroing.\n", bdn);
+		WARN_ON(++failcnt == 16);
 	}
 
 	return __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);

In case it helps, the WARN yiels following backtrace:

[  641.039233] WARNING: at block/blk-lib.c:299 blkdev_issue_zeroout+0xc4/0xe6()
[  641.039234] Hardware name: PRIMERGY RX100 S7p
[  641.039236] Modules linked in: ifb xt_TCPMSS xt_REDIRECT ipt_MASQUERADE xt_policy xt_nat xt_length2(O) xt_CLASSIFY xt_hashlimit
xt_TPROXY nf_tproxy_core xt_socket xt_NFQUEUE xt_connmark xt_limit xt_mark xt_set xt_addrtype xt_tcpudp ip_set_hash_ip nfnetlink_queue nf_nat_ftp nf_conntrack_ftp
af_packet iptable_mangle iptable_nat nf_nat_ipv4 nf_nat xt_NFLOG xt_condition(O) xt_logmark xt_owner ipt_REJECT xt_state ip_set ip_scheduler nfnetlink_log
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack iptable_filter iptable_raw xt_CT nf_conntrack_netlink nfnetlink nf_conntrack ip_tables x_tables acpi_cpufreq mperf
crc32c_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 aes_generic xts gf128mul ehci_pci coretemp rtc_cmos ehci_hcd sg i2c_i801 evdev ac sr_mod cdrom
microcode button acpi_power_meter e1000e(O) container sd_mod fan thermal processor thermal_sys hwmon mptsas mptscsih mptbase scsi_transport_sas
ahci libahci libata scsi_mod edd [last unloaded: ifb]
[  641.039321] Pid: 2425, comm: flush-8:0 Tainted: G           O 3.8.6-22.geaf5f75-smp64 #1
[  641.039322] Call Trace:
[  641.039327]  [<ffffffff8115c985>] ? blkdev_issue_zeroout+0xc4/0xe6
[  641.039331]  [<ffffffff810346e5>] ? warn_slowpath_common+0x78/0x8d
[  641.039334]  [<ffffffff8115c985>] ? blkdev_issue_zeroout+0xc4/0xe6
[  641.039339]  [<ffffffff81124327>] ? ext4_ext_zeroout+0x4a/0x55
[  641.039343]  [<ffffffff811283c2>] ? ext4_ext_map_blocks+0x78a/0x1660
[  641.039348]  [<ffffffff8115b543>] ? blk_recount_segments+0x1b/0x2c
[  641.039353]  [<ffffffff81083b46>] ? mempool_alloc+0x54/0x132
[  641.039358]  [<ffffffff8115bce2>] ? __blk_segment_map_sg+0x115/0x153
[  641.039362]  [<ffffffff81112f6f>] ? ext4_map_blocks+0x149/0x23c
[  641.039366]  [<ffffffff8111356d>] ? mpage_da_map_and_submit+0x9c/0x79d
[  641.039376]  [<ffffffffa006a386>] ? mptscsih_qcmd+0x4e4/0x513 [mptscsih]
[  641.039387]  [<ffffffffa00087f1>] ? scsi_finish_command+0xb4/0xb4 [scsi_mod]
[  641.039391]  [<ffffffff811571ef>] ? blk_peek_request+0x17c/0x18e
[  641.039395]  [<ffffffff8113bebe>] ? start_this_handle+0x418/0x429
[  641.039399]  [<ffffffff81081deb>] ? find_get_pages_tag+0xf5/0x136
[  641.039404]  [<ffffffff8111453f>] ? ext4_da_writepages+0x7f4/0x932
[  641.039409]  [<ffffffff810d6ef4>] ? __writeback_single_inode+0x39/0xd1
[  641.039412]  [<ffffffff810d7d04>] ? writeback_sb_inodes+0x22e/0x3af
[  641.039416]  [<ffffffff810d7eea>] ? __writeback_inodes_wb+0x65/0xa1
[  641.039419]  [<ffffffff810d8094>] ? wb_writeback+0x108/0x18c
[  641.039423]  [<ffffffff8103ec1b>] ? lock_timer_base+0x26/0x4c
[  641.039426]  [<ffffffff810d8259>] ? wb_do_writeback+0x141/0x1ac
[  641.039429]  [<ffffffff8103ef29>] ? del_timer+0x7c/0x7c
[  641.039433]  [<ffffffff810d8346>] ? bdi_writeback_thread+0x82/0x140
[  641.039436]  [<ffffffff810d82c4>] ? wb_do_writeback+0x1ac/0x1ac
[  641.039440]  [<ffffffff8104bb05>] ? kthread+0xad/0xb7
[  641.039444]  [<ffffffff8104ba58>] ? kthread_freezable_should_stop+0x51/0x51
[  641.039450]  [<ffffffff812fd7bc>] ? ret_from_fork+0x7c/0xb0
[  641.039453]  [<ffffffff8104ba58>] ? kthread_freezable_should_stop+0x51/0x51
[  641.039456] ---[ end trace d195e97e48c008d0 ]---

Thanks, Florian
