From: Daniel Gryniewicz <dang@linuxbox.com>
Subject: Re: scsi: add support for a blk-mq based I/O path.
Date: Tue, 16 Sep 2014 10:41:13 -0400
Message-ID: <54184C09.70800@linuxbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aa.linuxbox.com ([69.128.83.226]:1133 "EHLO aa.linuxbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbaIPOlS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2014 10:41:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Hi, Chris.

I'm working with the OSD Initiator, which does bi-directional requests, 
and this commit (d285203 scsi: add support for a blk-mq based I/O path.) 
causes a use-after free panic for me.  The panic itself follows, but the 
cause is that scsi_end_request() calls blk_finish_request(), which frees 
the request, and then it calls scsi_release_bidi_buffers() which tries 
to indirect through the request to find it's own buffers.  This only 
affects bi-directional requests, so it's unlikely to be hit very often. 
The following patch fixes it for me, but it may not be the correct fix.

Daniel


 From af61bb1f014bb1d034f4e7c3a18067ff3c9acedf Mon Sep 17 00:00:00 2001
From: Daniel Gryniewicz <dang@linuxbox.com>
Date: Tue, 16 Sep 2014 09:44:35 -0400
Subject: [PATCH] Panic accesing freed memory during bidi SCSI

When ending a bi-directionional SCSI request, blk_finish_request()
cleans up and frees the request, but scsi_release_bidi_buffers() tries
to indirect through the request to find it's data buffers.  This causes
a panic due to a null pointer dereference.

Move the call to scsi_release_bidi_buffers() before the call to
blk_finish_request().

Signed-off-by: Daniel Gryniewicz <dang@linuxbox.com>
---
  drivers/scsi/scsi_lib.c | 5 +++--
  1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d837dc1..aaea4b9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -733,12 +733,13 @@ static bool scsi_end_request(struct request *req, 
int error,
  	} else {
  		unsigned long flags;

+		if (bidi_bytes)
+			scsi_release_bidi_buffers(cmd);
+
  		spin_lock_irqsave(q->queue_lock, flags);
  		blk_finish_request(req, error);
  		spin_unlock_irqrestore(q->queue_lock, flags);

-		if (bidi_bytes)
-			scsi_release_bidi_buffers(cmd);
  		scsi_release_buffers(cmd);
  		scsi_next_command(cmd);
  	}
-- 
2.0.3

[  748.403847] NULL pointer dereference at 00000000000000f8
[  748.403847] IP: [<ffffffff814f7c30>] scsi_end_request+0x1b0/0x1f0
[  748.403847] PGD 36bb9067 PUD 36878067 PMD 0
[  748.403847] Oops: 0000 [#1] SMP
[  748.403847] Modules linked in: rpcsec_gss_krb5(E) objlayoutdriver(E) 
nfsv4(E) libore(E) osd(E) libosd(E) nf_conntrack_ipv4(E) 
nf_defrag_ipv4(E) xt_conntrack(E) nf_conntrack(E) ipt_REJECT(E) 
xt_CHECKSUM(E) iptable_mangle(E) xt_tcpudp(E) bridge(E) stp(E) llc(E) 
ip6table_filter(E) ip6_tables(E) iptable_filter(E) ip_tables(E) 
ebtable_nat(E) ebtables(E) x_tables(E) ib_iser(E) rdma_cm(E) iw_cm(E) 
ib_cm(E) ib_sa(E) ib_mad(E) ib_core(E) ib_addr(E) iscsi_tcp(E) 
libiscsi_tcp(E) libiscsi(E) scsi_transport_iscsi(E) ppdev(E) 
kvm_intel(E) kvm(E) snd_intel8x0(E) snd_ac97_codec(E) ac97_bus(E) 
parport_pc(E) snd_pcm(E) snd_timer(E) snd(E) soundcore(E) i2c_piix4(E) 
serio_raw(E) mac_hid(E) lp(E) parport(E) nfsd(E) auth_rpcgss(E) 
nfs_acl(E) nfs(E) lockd(E) sunrpc(E) fscache(E) raid10(E) raid456(E) 
async_raid6_recov(E) async_memcpy(E) async_pq(E) async_xor(E) 
async_tx(E) xor(E) raid6_pq(E) raid1(E) 8139too(E) raid0(E) psmouse(E) 
multipath(E) 8139cp(E) mii(E) linear(E) floppy(E)
[  748.403847] CPU: 0 PID: 3 Comm: ksoftirqd/0 Tainted: G            E 
3.17.0-rc5-pnfs #8
[  748.403847] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  748.403847] task: ffff880214143200 ti: ffff880214164000 task.ti: 
ffff880214164000
[  748.403847] RIP: 0010:[<ffffffff814f7c30>]  [<ffffffff814f7c30>] 
scsi_end_request+0x1b0/0x1f0
[  748.403847] RSP: 0018:ffff880214167cf0  EFLAGS: 00010246
[  748.403847] RAX: 0000000000000000 RBX: ffff880036a192b0 RCX: 
00000000000069a6
[  748.403847] RDX: 000000000000dd86 RSI: 0000000000000000 RDI: 
0000000000000246
[  748.403847] RBP: ffff880214167d20 R08: 0000000000000096 R09: 
0000000000000000
[  748.403847] R10: 000000000000092f R11: ffff880214167a0e R12: 
0000000000000246
[  748.403847] R13: ffff880036a1b380 R14: 0000000000000000 R15: 
ffff880211fad598
[  748.403847] FS:  0000000000000000(0000) GS:ffff88021fc00000(0000) 
knlGS:0000000000000000
[  748.403847] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  748.403847] CR2: 00000000000000f8 CR3: 0000000036902000 CR4: 
00000000000006f0
[  748.403847] Stack:
[  748.403847]  00000020810a00d4 ffff880036a1b380 ffff880036a192b0 
0000000000000000
[  748.403847]  ffff880211fad598 0000000000000000 ffff880214167d78 
ffffffff814f8043
[  748.403847]  ffff880214167d40 00003a9800000000 0000000000000001 
ffffffff81099ebd
[  748.403847] Call Trace:
[  748.403847]  [<ffffffff814f8043>] scsi_io_completion+0x373/0x690
[  748.403847]  [<ffffffff81099ebd>] ? sched_clock_local+0x1d/0x80
[  748.403847]  [<ffffffff814ed7ef>] scsi_finish_command+0xcf/0x130
[  748.403847]  [<ffffffff814f7226>] scsi_softirq_done+0x136/0x160
[  748.403847]  [<ffffffff8134aff3>] blk_done_softirq+0x83/0xa0
[  748.403847]  [<ffffffff810708e5>] __do_softirq+0xf5/0x2e0
[  748.403847]  [<ffffffff81070b00>] run_ksoftirqd+0x30/0x50
[  748.403847]  [<ffffffff8108df3f>] smpboot_thread_fn+0xff/0x1b0
[  748.403847]  [<ffffffff8108de40>] ? SyS_setgroups+0x1a0/0x1a0
[  748.403847]  [<ffffffff8108a3e2>] kthread+0xd2/0xf0
[  748.403847]  [<ffffffff8108a310>] ? kthread_create_on_node+0x180/0x180
[  748.403847]  [<ffffffff81749bfc>] ret_from_fork+0x7c/0xb0
[  748.403847]  [<ffffffff8108a310>] ? kthread_create_on_node+0x180/0x180
[  748.403847] Code: 8b 93 68 01 00 00 48 c7 c6 90 54 89 81 48 c7 c7 05 
b4 ad 81 31 c0 e8 c3 55 24 00 49 8b 85 00 01 00 00 31 f6 48 8b 80 68 01 
00 00 <48> 8b 98 f8 00 00 00 48 89 df e8 31 ce ff ff 48 8b 3d 12 de ab
[  748.403847] RIP  [<ffffffff814f7c30>] scsi_end_request+0x1b0/0x1f0
[  748.403847]  RSP <ffff880214167cf0>
[  748.403847] CR2: 00000000000000f8
[  748.403847] ---[ end trace fffb124c84fcc08e ]---
[  748.403847] Kernel panic - not syncing: Fatal exception in interrupt
[  748.403847] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation 
range: 0xffffffff80000000-0xffffffff9fffffff)
[  748.403847] ---[ end Kernel panic - not syncing: Fatal exception in 
interrupt
