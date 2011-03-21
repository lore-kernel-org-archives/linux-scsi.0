From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 21 Mar 2011 17:31:15 -0500
Message-ID: <4D87D1B3.2030106@linux.vnet.ibm.com>
References: <20110307134033K.fujita.tomonori@lab.ntt.co.jp> <1299508803.12730.1.camel@mulgrave.site> <4D83C78D.5040908@linux.vnet.ibm.com> <20110321100909E.fujita.tomonori@lab.ntt.co.jp> <4D87CF99.7040008@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39350 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304Ab1CUWbS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 18:31:18 -0400
Received: from d01dlp01.pok.ibm.com (d01dlp01.pok.ibm.com [9.56.224.56])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2LM63RU028895
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 18:06:03 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id C739138C803B
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 18:31:12 -0400 (EDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2LMVHEJ466182
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 18:31:17 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2LMVGkJ009914
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 16:31:16 -0600
In-Reply-To: <4D87CF99.7040008@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, nab@linux-iscsi.org, linux-scsi@vger.kernel.org

Just hit another potential issue. I was mapping / unmapping disks a couple times,
so that might have helped trigger the issue. I had a file backed disk mapped
to a vscsi lun, then unmapped it, mapped a ramdisk lun, then switched back to
the filebacked lun after running into issues with the ramdisk lun and saw this:


Mar 21 16:25:57 jn30a-lp4 kernel: unexpected fifo state
Mar 21 16:25:57 jn30a-lp4 kernel: ------------[ cut here ]------------
Mar 21 16:25:57 jn30a-lp4 kernel: WARNING: at drivers/scsi/libsrp.c:162
Mar 21 16:25:57 jn30a-lp4 kernel: Modules linked in: target_core_pscsi target_core_file target_core_iblock ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6table_filter ip6_tables x_tables ipv6 fuse loop dm_mod ibmvscsis libsrp scsi_tgt target_core_mod ses enclosure sg ibmveth configfs ext3 jbd mbcache sd_mod crc_t10dif ipr libata scsi_mod
Mar 21 16:25:57 jn30a-lp4 kernel: NIP: d0000000047e0b38 LR: d0000000047e0b34 CTR: 0000000000000000
Mar 21 16:25:57 jn30a-lp4 kernel: REGS: c00000033f4ef860 TRAP: 0700   Not tainted  (2.6.38-0.7-ppc64-06439-g5bab188-dirty)
Mar 21 16:25:57 jn30a-lp4 kernel: MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24002024  XER: 20000001
Mar 21 16:25:57 jn30a-lp4 kernel: TASK = c00000033f2b39e0[58] 'kworker/4:1' THREAD: c00000033f4ec000 CPU: 4
Mar 21 16:25:57 jn30a-lp4 kernel: GPR00: d0000000047e0b34 c00000033f4efae0 d0000000047e9768 0000000000000018
Mar 21 16:25:57 jn30a-lp4 kernel: GPR04: 0000000000000000 0000000000000004 0000000000000000 c000000000f86610
Mar 21 16:25:57 jn30a-lp4 kernel: GPR08: c000000000f86b20 c0000000008b38b8 000000000007ffff 0000000000000001
Mar 21 16:25:57 jn30a-lp4 kernel: GPR12: 0000000028002082 c00000000f190a00 0000000000000000 0000000002b80610
Mar 21 16:25:57 jn30a-lp4 kernel: GPR16: 0000000001a3fc60 0000000002b80d08 0000000001a3fc70 0000000002c81870
Mar 21 16:25:57 jn30a-lp4 kernel: GPR20: 0000000002b805c8 0000000002c81888 0000000002c81910 0000000000000000
Mar 21 16:25:57 jn30a-lp4 kernel: GPR24: 0000000000000000 0000000000000000 0000000000000000 c00000033f1bacc0
Mar 21 16:25:57 jn30a-lp4 kernel: GPR28: 0000000000000001 0000000000000000 d0000000047e9778 d0000000047e1ba8
Mar 21 16:25:57 jn30a-lp4 kernel: NIP [d0000000047e0b38] .srp_iu_get+0x118/0x130 [libsrp]
Mar 21 16:25:57 jn30a-lp4 kernel: LR [d0000000047e0b34] .srp_iu_get+0x114/0x130 [libsrp]
Mar 21 16:25:57 jn30a-lp4 kernel: Call Trace:
Mar 21 16:25:57 jn30a-lp4 kernel: [c00000033f4efae0] [d0000000047e0b34] .srp_iu_get+0x114/0x130 [libsrp] (unreliable)
Mar 21 16:25:57 jn30a-lp4 kernel: [c00000033f4efb90] [d0000000048f0d6c] .process_crq+0xcc/0x5b8 [ibmvscsis]
Mar 21 16:25:57 jn30a-lp4 kernel: [c00000033f4efc50] [d0000000048f183c] .handle_crq+0x224/0xa60 [ibmvscsis]
Mar 21 16:25:57 jn30a-lp4 kernel: [c00000033f4efd60] [c0000000000c2120] .process_one_work+0x198/0x518
Mar 21 16:25:57 jn30a-lp4 kernel: [c00000033f4efe10] [c0000000000c297c] .worker_thread+0x1f4/0x518
Mar 21 16:25:57 jn30a-lp4 kernel: [c00000033f4efed0] [c0000000000cb4c4] .kthread+0xb4/0xc0
Mar 21 16:25:57 jn30a-lp4 kernel: [c00000033f4eff90] [c00000000001e864] .kernel_thread+0x54/0x70
Mar 21 16:25:57 jn30a-lp4 kernel: Instruction dump:
Mar 21 16:25:57 jn30a-lp4 kernel: e8010010 eb41ffd0 7c0803a6 eb61ffd8 eb81ffe0 eba1ffe8 ebc1fff0 ebe1fff8
Mar 21 16:25:57 jn30a-lp4 kernel: 4e800020 e87e8058 48000739 e8410028 <0fe00000> 38000001 38600000 981f0000
Mar 21 16:25:57 jn30a-lp4 kernel: ---[ end trace ec6b6139d888a732 ]---
Mar 21 16:25:57 jn30a-lp4 kernel: Error getting IU from pool
Mar 21 16:25:57 jn30a-lp4 kernel: Error getting IU from pool
Mar 21 16:25:57 jn30a-lp4 kernel: Error getting IU from pool
Mar 21 16:25:57 jn30a-lp4 kernel: Error getting IU from pool

I'm also seeing disktest complain on the client about commands taking longer than 120 seconds
on occasion, which may play into the performance issue I mentioned in my previous mail.

-Brian


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


