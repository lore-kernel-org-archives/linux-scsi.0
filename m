From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/4] scsi: bnx2fc: convert per-CPU thread to kworker
Date: Wed, 20 Jul 2016 13:04:21 +0200
Message-ID: <20160720110421.5ocuquyqki2uggg4@c203.arch.suse.de>
References: <1467734929-24442-1-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbcGTLE0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2016 07:04:26 -0400
Content-Disposition: inline
In-Reply-To: <1467734929-24442-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-scsi@vger.kernel.org, jth@kernel.org, rt@linutronix.de, jejb@linux.vnet.ibm.com, "Martin K . Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>

On Tue, Jul 05, 2016 at 06:08:46PM +0200, Sebastian Andrzej Siewior wrote:
> The driver creates its own per-CPU threads which are updated based on CPU
> hotplug events. It is also possible to use kworkers and remove some of the
> infrastructure get the same job done while saving a few lines of code.
> 
> bnx2fc_percpu_io_thread() becomes bnx2fc_percpu_io_work() which is
> mostly the same code. The outer loop (kthread_should_stop()) gets
> removed and the remaining code is shifted to the left.
> In bnx2fc_process_new_cqes() the code checked for ->iothread to
> decide if there is an active per-CPU thread. With the kworkers this
> is no longer possible nor required. The allocation of a new work item
> (via bnx2fc_alloc_work()) does no longer happen with the ->fp_work_lock
> lock held. It performs only a memory allocation + initialization which
> does not require any kind of serialization. The lock is held while
> adding the new member to fps->work_list list.
> 
> The remaining part is the removal CPU hotplug notifier since it is taken
> care by the kworker code.
> 
> This patch was only compile-tested due to -ENODEV.
> 
> Cc: QLogic-Storage-Upstream@qlogic.com
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Hi Sebastian,

I've tried to test your series and unfortunately I encountered the following
oops.

[  113.969654] Modules linked in: af_packet(E) 8021q(E) garp(E) stp(E) llc(E) mrp(E) mgag200(E) i2c_algo_bit(E) bnx2x(E) drm_kms_helper(E) syscopyarea(E) mdio(E) sysfillrect(E) libcrc32c(E) sysimgblt(E) dm_service_time(E) bnx2fc(E) fb_sys_fops(E) geneve(E) xhci_pci(E) uhci_hcd(E) ttm(E) sd_mod(E) ehci_hcd(E) xhci_hcd(E) cnic(E) vxlan(E) uio(E) ip6_udp_tunnel(E) udp_tunnel(E) crc32c_intel(E) hpsa(E) ptp(E) usbcore(E) drm(E) scsi_transport_sas(E) usb_common(E) pps_core(E) fjes(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) dm_mirror(E) dm_region_hash(E) dm_log(E) fcoe(E) libfcoe(E) libfc(E) scsi_transport_fc(E) sg(E) dm_multipath(E) dm_mod(E) scsi_mod(E) efivarfs(E) autofs4(E)
[  113.969669] Supported: Yes
[  113.969671] CPU: 11 PID: 398 Comm: kworker/11:1 Tainted: G            EL     4.4.15-0.g6f92308-default #1
[  113.969672] Hardware name: HP ProLiant BL460c Gen9, BIOS I36 12/24/2014
[  113.969674] Workqueue: events bnx2fc_percpu_io_work [bnx2fc]
[  113.969675] task: ffff880667a38600 ti: ffff880667a3c000 task.ti: ffff880667a3c000
[  113.969676] RIP: 0010:[<ffffffff810c4c2f>]  [<ffffffff810c4c2f>] native_queued_spin_lock_slowpath+0x16f/0x190
[  113.969677] RSP: 0018:ffff880667a3fde8  EFLAGS: 00000202
[  113.969678] RAX: 0000000000000101 RBX: ffff88065553cd20 RCX: 0000000000000001
[  113.969678] RDX: 0000000000000101 RSI: 0000000000000001 RDI: ffff8806676d80d0
[  113.969679] RBP: ffff880667a3fdf8 R08: 0000000000000101 R09: 0000000000000001
[  113.969679] R10: ffffffff81d46fc0 R11: 0000000000000000 R12: ffff880667a3fdf8
[  113.969680] R13: ffff8806676d80a0 R14: ffff8806676d80c0 R15: ffff8806676d80d0
[  113.969681] FS:  0000000000000000(0000) GS:ffff8806676c0000(0000) knlGS:0000000000000000
[  113.969681] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  113.969682] CR2: 00007fee621724a0 CR3: 0000000001c0a000 CR4: 00000000001406e0
[  113.969682] Stack:
[  113.969683]  ffffffff81181a17 ffffffffa026a1dc ffff880667a3fdf8 ffff880667a3fdf8
[  113.969684]  ffff8806676d80a0 ffff88017c303b80 ffff8806676d5400 ffffe8fa068c1200
[  113.969685]  0000000000000000 00000000000002c0 ffffffff8109394e 0000000067a38600
[  113.969685] Call Trace:
[  113.969688]  [<ffffffff81181a17>] queued_spin_lock_slowpath+0x7/0xa
[  113.969690]  [<ffffffffa026a1dc>] bnx2fc_percpu_io_work+0xac/0xd0 [bnx2fc]
[  113.969693]  [<ffffffff8109394e>] process_one_work+0x14e/0x410
[  113.969695]  [<ffffffff810941a6>] worker_thread+0x116/0x490
[  113.969697]  [<ffffffff8109964d>] kthread+0xbd/0xe0
[  113.969699]  [<ffffffff815debbf>] ret_from_fork+0x3f/0x70
[  113.970696] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[  113.970696] 
[  113.970696] Leftover inexact backtrace:
[  113.970696] 
[  113.970698]  [<ffffffff81099590>] ? kthread_park+0x50/0x50
[  113.970705] Code: 89 d0 66 31 c0 39 c1 74 e7 4d 85 c9 c6 07 01 74 2d 41 c7 41 08 01 00 00 00 e9 52 ff ff ff 83 fa 01 74 17 8b 07 84 c0 74 08 f3 90 <8b> 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 c3 f3 c3 f3 90 4d 8b 

I'll try to narrow it down to the specific patch, but currently I'm a bit
busy, sorry.

Johannes

