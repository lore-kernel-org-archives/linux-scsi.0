From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 91711] New: 3w-9xxx: DMA-API: device driver tries to free DMA
 memory it has not allocated
Date: Wed, 21 Jan 2015 19:17:25 +0000
Message-ID: <bug-91711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60042 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297AbbAUTR3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2015 14:17:29 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7E4DD204A0
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2015 19:17:28 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B548E204CF
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2015 19:17:25 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=91711

            Bug ID: 91711
           Summary: 3w-9xxx: DMA-API: device driver tries to free DMA
                    memory it has not allocated
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.18.3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: admin@e-blokos.com
        Regression: No

3w-9xxx 0000:03:03.0: DMA-API: device driver tries to free DMA memory it has
not allocated [device address=0x0000000000000000] [size=0 bytes]
can cause randomly a kernel panic...

here is the bug trace

[10205.263190] ------------[ cut here ]------------
[10205.271182] WARNING: CPU: 3 PID: 0 at lib/dma-debug.c:1080
check_unmap+0x8ea/0x9e0()
[10205.273087] 3w-9xxx 0000:03:03.0: DMA-API: device driver tries to free DMA
memory it has not allocated [device address=0x0000000000000000] [size=0 bytes]
[10205.273087] Modules linked in: rpcsec_gss_krb5 nfsv4 dns_resolver nfs
fscache nfnetlink_queue nfnetlink_log nfnetlink tun bridge stp llc bonding
ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat
iptable_mangle ts_kmp xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT
nf_reject_ipv6 xt_hashlimit nf_conntrack_ipv6 nf_defrag_ipv6 xt_string
xt_multiport xt_conntrack nf_conntrack ip6table_filter ip6_tables iTCO_wdt
ppdev iTCO_vendor_support lpc_ich mfd_core serio_raw pcspkr e752x_edac
parport_pc i2c_i801 edac_core parport shpchp nfsd auth_rpcgss nfs_acl lockd
grace sunrpc ata_generic pata_acpi tg3 e1000 3w_9xxx
[10205.273087] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.18.3 #1
[10205.273087] Hardware name: Supermicro X6DH8/X6DH8, BIOS 6.00 08/16/2007
[10205.273087]  0000000000000000 fa5e96fc2665aa72 ffff88022fd83b68
ffffffff817a573e
[10205.273087]  0000000000000000 ffff88022fd83bc0 ffff88022fd83ba8
ffffffff81093601
[10205.273087]  ffff88022fd83ba8 ffff880223d47a60 ffff88022fd83cb8
0000000000000000
[10205.273087] Call Trace:
[10205.273087]  <IRQ>  [<ffffffff817a573e>] dump_stack+0x4f/0x7c
[10205.273087]  [<ffffffff81093601>] warn_slowpath_common+0x81/0xa0
[10205.273087]  [<ffffffff81093675>] warn_slowpath_fmt+0x55/0x70
[10205.273087]  [<ffffffff813c68db>] ? debug_dma_mapping_error+0x7b/0x90
[10205.273087]  [<ffffffff813c8a9a>] check_unmap+0x8ea/0x9e0
[10205.273087]  [<ffffffff817ac021>] ? _raw_spin_unlock_irqrestore+0x21/0x40
[10205.273087]  [<ffffffff813c8d45>] debug_dma_unmap_sg+0x75/0x150
[10205.273087]  [<ffffffff814f73d3>] scsi_dma_unmap+0x73/0xc0
[10205.273087]  [<ffffffffa00016a5>] twa_interrupt+0x585/0x770 [3w_9xxx]
[10205.273087]  [<ffffffff810fea9b>] ? __hrtimer_start_range_ns+0x1eb/0x480
[10205.273087]  [<ffffffff810eba7e>] handle_irq_event_percpu+0x3e/0x1f0
[10205.273087]  [<ffffffff810ebc71>] handle_irq_event+0x41/0x70
[10205.273087]  [<ffffffff810eecc3>] handle_fasteoi_irq+0xc3/0x170
[10205.273087]  [<ffffffff81018752>] handle_irq+0xb2/0x1a0
[10205.273087]  [<ffffffff810b42ce>] ? atomic_notifier_call_chain+0x3e/0x50
[10205.273087]  [<ffffffff817af86d>] do_IRQ+0x5d/0x100
[10205.273087]  [<ffffffff817ad6ed>] common_interrupt+0x6d/0x6d
[10205.273087]  <EOI>  [<ffffffff8110e6b0>] ?
tick_nohz_stop_sched_tick+0x2b0/0x300
[10205.273087]  [<ffffffff8105aae6>] ? native_safe_halt+0x6/0x10
[10205.273087]  [<ffffffff813b6137>] ? debug_smp_processor_id+0x17/0x20
[10205.273087]  [<ffffffff810212cb>] default_idle+0x1b/0xf0
[10205.273087]  [<ffffffff81021dcf>] arch_cpu_idle+0xf/0x20
[10205.273087]  [<ffffffff810d6d26>] cpu_startup_entry+0x456/0x510
[10205.273087]  [<ffffffff817ac021>] ? _raw_spin_unlock_irqrestore+0x21/0x40
[10205.273087]  [<ffffffff8110b44c>] ? clockevents_register_device+0xbc/0x130
[10205.273087]  [<ffffffff81049281>] start_secondary+0x1b1/0x200
[10205.273087] ---[ end trace f8b7f072834e5aba ]---

-- 
You are receiving this mail because:
You are the assignee for the bug.
