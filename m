From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] bnx2fc: Set no_async_abort to 1 in SCSI host template.
Date: Tue, 5 Aug 2014 17:02:46 -0400
Message-ID: <alpine.OSX.2.00.1408051656410.2178@administrators-macbook-pro.local>
References: <1407267953-26618-1-git-send-email-chad.dupuis@qlogic.com> <CAHdzE-8o94d4d-tJ2j3iUbR7oCO9QYioAqbtRLbGKonR5UK9ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:60625 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbaHEVC6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2014 17:02:58 -0400
In-Reply-To: <CAHdzE-8o94d4d-tJ2j3iUbR7oCO9QYioAqbtRLbGKonR5UK9ZQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, giridhar.malavali@qlogic.com



On Tue, 5 Aug 2014, Venkatesh Srinivas wrote:

> On Tue, Aug 5, 2014 at 12:45 PM, Chad Dupuis <chad.dupuis@qlogic.com> wrote:
>> Set this to 1 for now as we've observed crashes when this is set to the default
>> value of 0.
>
> What sorts of crashes have you seen with no_async_abort=0 (default)?
> At which kernel versions?

We've seen a crash where we use a request that has already been used else 
where when requeuing a SCSI command:

May  1 15:50:48 sl-b109 kernel: ------------[ cut here ]------------
May  1 15:50:48 sl-b109 kernel: kernel BUG at block/blk-core.c:1217!
May  1 15:50:48 sl-b109 kernel: invalid opcode: 0000 [#1] SMP
May  1 15:50:48 sl-b109 kernel: Modules linked in: sg ebtable_nat ebtables 
nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache ipt_REJECT 
ip6t_REJECT nf_conntrack_ipv4 nf_conntrack_ipv6 nf_defrag_ipv4 
nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter iptable_filter 
ip_tables ip6_tables dm_round_robin iTCO_wdt iTCO_vendor_support coretemp 
kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel 
ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper 
cryptd pcspkr serio_raw sb_edac edac_core lpc_ich mfd_core hpilo hpwdt 
ioatdma ntb ipmi_si ipmi_msghandler video acpi_power_meter shpchp 
pcc_cpufreq mperf nfsd auth_rpcgss nfs_acl lockd sunrpc uinput xfs 
dm_service_time 8021q garp stp llc mrp sd_mod crc_t10dif crct10dif_common 
mgag200 syscopyarea sysfillrect sysimgblt drm_kms_helper ttm igb drm bnx2x
May  1 15:50:48 sl-b109 kernel: ptp pps_core dca i2c_algo_bit i2c_core 
hpsa mdio libcrc32c dm_mirror dm_region_hash dm_log bnx2fc cnic uio fcoe 
libfcoe libfc scsi_transport_fc scsi_tgt dm_multipath dm_mod
May  1 15:50:48 sl-b109 kernel: CPU: 3 PID: 515 Comm: bnx2fc_thread/3 Not 
tainted 3.10.0-121.el7.x86_64 #1
May  1 15:50:48 sl-b109 kernel: Hardware name: HP ProLiant BL460c Gen8, 
BIOS I31 12/20/2013
May  1 15:50:48 sl-b109 kernel: task: ffff880232345b00 ti: 
ffff880036b20000 task.ti: ffff880036b20000
May  1 15:50:48 sl-b109 kernel: RIP: 0010:[<ffffffff8129007d>] 
[<ffffffff8129007d>] blk_requeue_request+0x8d/0x90
May  1 15:50:48 sl-b109 kernel: RSP: 0018:ffff880237a63e68  EFLAGS: 
00010097
May  1 15:50:48 sl-b109 kernel: RAX: ffff880432d9c660 RBX: 
ffff88043142c800 RCX: dead000000200200
May  1 15:50:48 sl-b109 kernel: RDX: ffff880432d9c660 RSI: 
ffff880432d9c510 RDI: ffff880432d9c660
May  1 15:50:48 sl-b109 kernel: RBP: ffff880237a63e80 R08: 
ffff880432d9c660 R09: 0000000000000001
May  1 15:50:48 sl-b109 kernel: R10: ffffffff819f4560 R11: 
0000000000001000 R12: ffff880432d9c510
May  1 15:50:48 sl-b109 kernel: R13: ffff880432b9ad00 R14: 
ffff88021222cc40 R15: ffff880410ba0c28
May  1 15:50:48 sl-b109 kernel: FS:  0000000000000000(0000) 
GS:ffff880237a60000(0000) knlGS:0000000000000000
May  1 15:50:48 sl-b109 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
May  1 15:50:48 sl-b109 kernel: CR2: 00000000020ad4c0 CR3: 
000000042b166000 CR4: 00000000000407e0
May  1 15:50:48 sl-b109 kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
May  1 15:50:48 sl-b109 kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
May  1 15:50:48 sl-b109 kernel: Stack:
May  1 15:50:48 sl-b109 kernel: ffff88043142c800 ffff880432b9ad00 
0000000000000202 ffff880237a63ec8
May  1 15:50:48 sl-b109 kernel: ffffffff813e73c8 ffff880237a63ea0 
ffffffff8128f85c ffff88021222cc40
May  1 15:50:48 sl-b109 kernel: 0000000000002001 000000000002bf20 
0000000000000006 0000000000000001
May  1 15:50:48 sl-b109 kernel: Call Trace:
May  1 15:50:48 sl-b109 kernel: <IRQ>
May  1 15:50:48 sl-b109 kernel:
May  1 15:50:48 sl-b109 kernel: [<ffffffff813e73c8>] 
__scsi_queue_insert+0x98/0x120
May  1 15:50:48 sl-b109 kernel: [<ffffffff8128f85c>] ? 
blk_run_queue_async+0x3c/0x40
May  1 15:50:48 sl-b109 kernel: [<ffffffff813e7542>] 
scsi_softirq_done+0xd2/0x160
May  1 15:50:48 sl-b109 kernel: [<ffffffff81299b80>] 
blk_done_softirq+0x90/0xc0
May  1 15:50:48 sl-b109 kernel: [<ffffffff81067047>] 
__do_softirq+0xf7/0x290
May  1 15:50:48 sl-b109 kernel: [<ffffffff815fe15c>] 
call_softirq+0x1c/0x30
May  1 15:50:48 sl-b109 kernel: <EOI>
May  1 15:50:48 sl-b109 kernel:
May  1 15:50:48 sl-b109 kernel: [<ffffffff81014d25>] do_softirq+0x55/0x90
May  1 15:50:48 sl-b109 kernel: [<ffffffff81066564>] 
local_bh_enable_ip+0x94/0xa0
May  1 15:50:48 sl-b109 kernel: [<ffffffff815f378b>] 
_raw_spin_unlock_bh+0x1b/0x40
May  1 15:50:48 sl-b109 kernel: [<ffffffffa0097f58>] 
bnx2fc_process_cq_compl+0xf8/0x280 [bnx2fc]
May  1 15:50:48 sl-b109 kernel: [<ffffffffa0092e16>] 
bnx2fc_percpu_io_thread+0x116/0x1a0 [bnx2fc]
May  1 15:50:48 sl-b109 kernel: [<ffffffffa0092d00>] ? 
bnx2fc_get_src_mac+0x20/0x20 [bnx2fc]

It's possible that this is related to:
http://marc.info/?l=linux-scsi&m=140266091913551&w=2

however we observed no crashes when setting no_async to '1' so for now we 
wanted to set this in our host template.

> > Thanks, > 
-- vs; >
