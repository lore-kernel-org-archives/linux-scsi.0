From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Tue, 22 Mar 2011 15:06:47 -0700
Message-ID: <1300831607.21880.365.camel@haakon2.linux-iscsi.org>
References: <20110307134033K.fujita.tomonori@lab.ntt.co.jp>
	 <1299508803.12730.1.camel@mulgrave.site>
	 <4D83C78D.5040908@linux.vnet.ibm.com>
	 <20110321100909E.fujita.tomonori@lab.ntt.co.jp>
	 <4D87CF99.7040008@linux.vnet.ibm.com> <4D87D1B3.2030106@linux.vnet.ibm.com>
	 <1300747720.21880.95.camel@haakon2.linux-iscsi.org>
	 <4D889BB4.4010102@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50162 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1CVWN7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2011 18:13:59 -0400
In-Reply-To: <4D889BB4.4010102@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Tue, 2011-03-22 at 07:53 -0500, Brian King wrote:
> On 03/21/2011 05:48 PM, Nicholas A. Bellinger wrote:
> > On Mon, 2011-03-21 at 17:31 -0500, Brian King wrote:
> >> Just hit another potential issue. I was mapping / unmapping disks a couple times,
> >> so that might have helped trigger the issue. I had a file backed disk mapped
> >> to a vscsi lun, then unmapped it, mapped a ramdisk lun, then switched back to
> >> the filebacked lun after running into issues with the ramdisk lun and saw this:
> >>
> >>
> > 
> > By mapping/unmapping here do you mean unlinking+linking the Port/LUNs
> > w/o removing the active VIO I_T Nexus, or actually rmdir'ing the whole
> > $VIO_TARGET_FULLPATH/tpgt_1/ struct config_group..?
> 
> I just did an rm -r $VIO_TARGET_FULLPATH/tpgt_1/lun/lun_0
> 

Ok, thanks for the clarification here..

I am pretty certain this backtrace is related to active I/O LUN shutdown
with TPG demo mode operation and ibmvscsis.  I will need to take a
deeper look to determine that this is working as expected w/o explict
MappedLUN ACLs provided by target_core_fabric_configfs.c make_nodeacl
and drop_nodeacl() struct target_core_fabric_ops vectors, or if there is
some additional ibmvscsis / libsrp specific logic that needs to be made
to address the active I/O TCM backend Port/LUN unlink.

If the latter ends up being the case, this would most likely be using
the optional target_core_fabric_ops ->port_link() and ->port_unlink()
vectors.  These are used today by the tcm_loop LLD to call Linux/SCSI
code via scsi_device_lookup() -> scsi_remove_device() ->
scsi_device_put() to handle fabric level shutdown.   This could be used
for something similar quiesce I/O for a particular TPG LUN symlink dest
to target core /sys/kernel/config/target/core/$HBA/$DEV symlink src.

> > 
> >> Mar 21 16:25:57 jn30a-lp4 kernel: unexpected fifo state
> >> Mar 21 16:25:57 jn30a-lp4 kernel: ------------[ cut here ]------------
> >> Mar 21 16:25:57 jn30a-lp4 kernel: WARNING: at drivers/scsi/libsrp.c:162
> >> Mar 21 16:25:57 jn30a-lp4 kernel: Modules linked in: target_core_pscsi target_core_file target_core_iblock ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6table_filter ip6_tables x_tables ipv6 fuse loop dm_mod ibmvscsis libsrp scsi_tgt target_core_mod ses enclosure sg ibmveth configfs ext3 jbd mbcache sd_mod crc_t10dif ipr libata scsi_mod
> >> Mar 21 16:25:57 jn30a-lp4 kernel: NIP: d0000000047e0b38 LR: d0000000047e0b34 CTR: 0000000000000000
> >> Mar 21 16:25:57 jn30a-lp4 kernel: REGS: c00000033f4ef860 TRAP: 0700   Not tainted  (2.6.38-0.7-ppc64-06439-g5bab188-dirty)
> >> Mar 21 16:25:57 jn30a-lp4 kernel: MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24002024  XER: 20000001
> >> Mar 21 16:25:57 jn30a-lp4 kernel: TASK = c00000033f2b39e0[58] 'kworker/4:1' THREAD: c00000033f4ec000 CPU: 4
> >> Mar 21 16:25:57 jn30a-lp4 kernel: GPR00: d0000000047e0b34 c00000033f4efae0 d0000000047e9768 0000000000000018
> >> Mar 21 16:25:57 jn30a-lp4 kernel: GPR04: 0000000000000000 0000000000000004 0000000000000000 c000000000f86610
> >> Mar 21 16:25:57 jn30a-lp4 kernel: GPR08: c000000000f86b20 c0000000008b38b8 000000000007ffff 0000000000000001
> >> Mar 21 16:25:57 jn30a-lp4 kernel: GPR12: 0000000028002082 c00000000f190a00 0000000000000000 0000000002b80610
> >> Mar 21 16:25:57 jn30a-lp4 kernel: GPR16: 0000000001a3fc60 0000000002b80d08 0000000001a3fc70 0000000002c81870
> >> Mar 21 16:25:57 jn30a-lp4 kernel: GPR20: 0000000002b805c8 0000000002c81888 0000000002c81910 0000000000000000
> >> Mar 21 16:25:57 jn30a-lp4 kernel: GPR24: 0000000000000000 0000000000000000 0000000000000000 c00000033f1bacc0
> >> Mar 21 16:25:57 jn30a-lp4 kernel: GPR28: 0000000000000001 0000000000000000 d0000000047e9778 d0000000047e1ba8
> >> Mar 21 16:25:57 jn30a-lp4 kernel: NIP [d0000000047e0b38] .srp_iu_get+0x118/0x130 [libsrp]
> >> Mar 21 16:25:57 jn30a-lp4 kernel: LR [d0000000047e0b34] .srp_iu_get+0x114/0x130 [libsrp]
> >> Mar 21 16:25:57 jn30a-lp4 kernel: Call Trace:
> >> Mar 21 16:25:57 jn30a-lp4 kernel: [c00000033f4efae0] [d0000000047e0b34] .srp_iu_get+0x114/0x130 [libsrp] (unreliable)
> >> Mar 21 16:25:57 jn30a-lp4 kernel: [c00000033f4efb90] [d0000000048f0d6c] .process_crq+0xcc/0x5b8 [ibmvscsis]
> >> Mar 21 16:25:57 jn30a-lp4 kernel: [c00000033f4efc50] [d0000000048f183c] .handle_crq+0x224/0xa60 [ibmvscsis]
> >> Mar 21 16:25:57 jn30a-lp4 kernel: [c00000033f4efd60] [c0000000000c2120] .process_one_work+0x198/0x518
> >> Mar 21 16:25:57 jn30a-lp4 kernel: [c00000033f4efe10] [c0000000000c297c] .worker_thread+0x1f4/0x518
> >> Mar 21 16:25:57 jn30a-lp4 kernel: [c00000033f4efed0] [c0000000000cb4c4] .kthread+0xb4/0xc0
> >> Mar 21 16:25:57 jn30a-lp4 kernel: [c00000033f4eff90] [c00000000001e864] .kernel_thread+0x54/0x70
> >> Mar 21 16:25:57 jn30a-lp4 kernel: Instruction dump:
> >> Mar 21 16:25:57 jn30a-lp4 kernel: e8010010 eb41ffd0 7c0803a6 eb61ffd8 eb81ffe0 eba1ffe8 ebc1fff0 ebe1fff8
> >> Mar 21 16:25:57 jn30a-lp4 kernel: 4e800020 e87e8058 48000739 e8410028 <0fe00000> 38000001 38600000 981f0000
> >> Mar 21 16:25:57 jn30a-lp4 kernel: ---[ end trace ec6b6139d888a732 ]---
> >> Mar 21 16:25:57 jn30a-lp4 kernel: Error getting IU from pool
> >> Mar 21 16:25:57 jn30a-lp4 kernel: Error getting IU from pool
> >> Mar 21 16:25:57 jn30a-lp4 kernel: Error getting IU from pool
> >> Mar 21 16:25:57 jn30a-lp4 kernel: Error getting IU from pool
> >>
> > 
> > If we are talking about the latter case I think my last patch should
> > address this with active I_T Nexus I/O and ibmvscsis_drop_tpg(), but I
> > will followup a bit more and send out a proper patch this evening for
> > Tomo to comment..
> > 
> >> I'm also seeing disktest complain on the client about commands taking longer than 120 seconds
> >> on occasion, which may play into the performance issue I mentioned in my previous mail.
> >>
> > 
> > Mmmm, please verify with RAMDISK_MCP backends as well, as by default
> > FILEIO has O_SYNC enabled..  This does seem strange for LTP disktest
> > however..
> 
> How do I specify RAMDISK_MCP? I don't see an option in tcm_node.
> 

RAMDISK_DR and RAMDISK_MCP backend are configured with 'rd_dr_0/ramdisk'
and 'rd_mcp_0/ramdisk' for /sys/kernel/config/target/$HBA/$DEV/.  This
is the same with tcm_node --ramdisk $HBA/$DEV usage.

--nab


