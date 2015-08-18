From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103061] New: kernel BUG at drivers/scsi/qla2xxx/qla_isr.c:2242
Date: Tue, 18 Aug 2015 10:06:20 +0000
Message-ID: <bug-103061-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49823 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbbHRKGY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2015 06:06:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2DFDC206D6
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2015 10:06:23 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0AE5C206B8
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2015 10:06:21 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=103061

            Bug ID: 103061
           Summary: kernel BUG at drivers/scsi/qla2xxx/qla_isr.c:2242
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.10.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: QLOGIC QLA2XXX
          Assignee: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
          Reporter: gaofeng.guo@memblaze.com
        Regression: No

one  initiator
one  target
set /sys/module/qla2xxx/parameters/ql2xmaxqdepth 512
while do io test, we meet the issue

syslog
[10343.908025] qla2xxx [0000:01:00.0]-801c:12: Abort command issued
nexus=12:0:0 --  1 2002.
[10344.907437] qla2xxx [0000:01:00.0]-801c:12: Abort command issued
nexus=12:0:0 --  1 2002.
[10345.906840] qla2xxx [0000:01:00.0]-801c:12: Abort command issued
nexus=12:0:0 --  1 2002.
[10346.906245] qla2xxx [0000:01:00.0]-801c:12: Abort command issued
nexus=12:0:0 --  1 2002.
[10399.853793] qla2xxx [0000:01:00.0]-801c:12: Abort command issued
nexus=12:0:0 --  1 2002.
[10406.796828] BUG: unable to handle kernel NULL pointer dereference at
0000000000000084
[10406.796953] IP: [<ffffffffa0989871>] qla2x00_status_entry+0x3d1/0x1150
[qla2xxx]
[10406.797071] PGD 0 
[10406.797184] Oops: 0000 [#1] SMP 
[10406.797293] Modules linked in: qla2xxx scsi_transport_fc scsi_tgt fuse btrfs
zlib_deflate raid6_pq xor msdos ext4 mbcache jbd2 binfmt_misc ipt_MASQUERADE
xt_CHECKSUM ip6t_rpfilter ip6t_REJECT ipt_REJECT xt_conntrack ebtable_nat
ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security
ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security
iptable_raw iptable_filter ip_tables sg vfat fat snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep
snd_seq snd_seq_device mxm_wmi coretemp mei_me mei snd_pcm kvm_intel kvm
crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
[10406.799038]  aesni_intel lrw gf128mul glue_helper ablk_helper cryptd
snd_page_alloc snd_timer snd soundcore wmi shpchp pcspkr serio_raw mperf
acpi_pad nfsd auth_rpcgss nfs_acl lockd uinput sunrpc xfs libcrc32c sd_mod
crc_t10dif crct10dif_common i915 ahci i2c_algo_bit libahci e1000e
drm_kms_helper libata drm ptp pps_core i2c_core video dm_mirror dm_region_hash
dm_log dm_mod [last unloaded: scsi_tgt]
[10406.800987] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 3.10.0-123.el7.x86_64
#1
[10406.801523] Hardware name: MSI MS-7915/Z97 MPOWER (MS-7915), BIOS V1.6
09/19/2014
[10406.802080] task: ffff880418c25b00 ti: ffff880418c3a000 task.ti:
ffff880418c3a000
[10406.802657] RIP: 0010:[<ffffffffa0989871>]  [<ffffffffa0989871>]
qla2x00_status_entry+0x3d1/0x1150 [qla2xxx]
[10406.803278] RSP: 0018:ffff88042fb43ce0  EFLAGS: 00010046
[10406.803903] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffffffa09d0780
[10406.804553] RDX: 0000000000000000 RSI: ffff880415176740 RDI:
0000000008000000
[10406.805211] RBP: ffff88042fb43de0 R08: 0000000000000029 R09:
0000000000000000
[10406.805882] R10: ffff8803bcd7a140 R11: ffff8803bd103100 R12:
ffff880412c08000
[10406.806567] R13: ffff880415176740 R14: 0000000000000029 R15:
00000000000e0000
[10406.807265] FS:  0000000000000000(0000) GS:ffff88042fb40000(0000)
knlGS:0000000000000000
[10406.807987] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10406.808719] CR2: 0000000000000084 CR3: 00000000018ce000 CR4:
00000000001407e0
[10406.809474] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[10406.810235] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[10406.811001] Stack:
[10406.811768]  00000000000000ef ffffffffa09db6cf ffff880400000000
ffffffff00000000
[10406.812579]  0000000000000000 ffff880400000000 00000000000000ef
ffffffff00000000
[10406.813399]  0000000000000000 0000000000000000 0000000000000000
ffff880400000000
[10406.814223] Call Trace:
[10406.815047]  <IRQ> 
[10406.815056] 
[10406.815887]  [<ffffffffa09c64e2>] ? qlt_async_event+0x72/0x310 [qla2xxx]
[10406.816746]  [<ffffffffa098b37e>] qla24xx_process_response_queue+0x32e/0x5c0
[qla2xxx]
[10406.817629]  [<ffffffff81089535>] ? enqueue_hrtimer+0x25/0x80
[10406.818522]  [<ffffffff81089e8a>] ? __hrtimer_start_range_ns+0x1ca/0x410
[10406.819433]  [<ffffffffa098d49b>] qla24xx_msix_rsp_q+0x4b/0xc0 [qla2xxx]
[10406.820356]  [<ffffffff810f717e>] handle_irq_event_percpu+0x3e/0x1e0
[10406.821290]  [<ffffffff810f735d>] handle_irq_event+0x3d/0x60
[10406.822229]  [<ffffffff810f9fe7>] handle_edge_irq+0x77/0x130
[10406.823177]  [<ffffffff81014c3f>] handle_irq+0xbf/0x150
[10406.824130]  [<ffffffff815ed78a>] ? atomic_notifier_call_chain+0x1a/0x20
[10406.825101]  [<ffffffff815f434f>] do_IRQ+0x4f/0xf0
[10406.826078]  [<ffffffff815e94ad>] common_interrupt+0x6d/0x6d
[10406.827068]  <EOI> 
[10406.827076] 
[10406.828044]  [<ffffffff814834e2>] ? cpuidle_enter_state+0x52/0xc0
[10406.829015]  [<ffffffff81483615>] cpuidle_idle_call+0xc5/0x200
[10406.829980]  [<ffffffff8101bc7e>] arch_cpu_idle+0xe/0x30
[10406.830949]  [<ffffffff810b4725>] cpu_startup_entry+0xf5/0x290
[10406.831901]  [<ffffffff815cfee1>] start_secondary+0x265/0x27b
[10406.832799] Code: 00 48 89 54 24 40 0f b7 55 c2 89 54 24 38 0f b6 57 28 89
54 24 30 0f b6 57 29 89 54 24 28 0f b6 57 2a bf 00 00 00 08 89 54 24 20 <8b> 90
84 00 00 00 89 54 24 18 8b 80 80 00 00 00 ba 22 30 00 00 
[10406.834676] RIP  [<ffffffffa0989871>] qla2x00_status_entry+0x3d1/0x1150
[qla2xxx]
[10406.835563]  RSP <ffff88042fb43ce0>
[10406.836417] CR2: 0000000000000084

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
