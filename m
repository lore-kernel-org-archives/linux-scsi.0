From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: kernel BUG at block/bio.c:1787! while initializing scsi_debug
 on ppc64 host
Date: Tue, 15 Dec 2015 23:38:41 +0800
Message-ID: <20151215233841.522d4bf0@tom-T450>
References: <20151211115340.GB19209@eguan.usersys.redhat.com>
	<20151215112057.GC19209@eguan.usersys.redhat.com>
	<CACVXFVOPgONuXjGhBnFVxuRVr+=LFe36QR-VTGVvTkEK+V0JLw@mail.gmail.com>
	<20151215130631.GD19209@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38185 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933590AbbLOPi6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2015 10:38:58 -0500
Received: by mail-wm0-f48.google.com with SMTP id p66so31501970wmp.1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 07:38:57 -0800 (PST)
In-Reply-To: <20151215130631.GD19209@eguan.usersys.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Tue, 15 Dec 2015 21:06:31 +0800
Eryu Guan <guaneryu@gmail.com> wrote:

> On Tue, Dec 15, 2015 at 08:06:47PM +0800, Ming Lei wrote:
> > On Tue, Dec 15, 2015 at 7:20 PM, Eryu Guan <guaneryu@gmail.com> wrote:
> > > On Fri, Dec 11, 2015 at 07:53:40PM +0800, Eryu Guan wrote:
> > >> Hi,
> > >>
> > >> I saw this kernel BUG_ON on 4.4-rc4 kernel, and this can be reproduced
> > >> easily on ppc64 host by:
> > >
> > > This is still reproducible with 4.4-rc5 kernel.
> > 
> > Could you capture the debug log after appyling the attached patch and
> > the reproduction?
> 
> Thanks for looking into this! dmesg shows:
> 
> [  686.217682] bio_split: sectors 0, bio_sectors 128, bi_rw 0

I guess the following patch should fix the issue, and ca369d51b3
uses OPTIMAL TRANSFER LENGTH to set limits->max_sectors, which
may be less than one page size.

I don't understand the idea behind this change, Martin, could
you explain it a bit?

---
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3d22fc3..d66d362 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2889,10 +2889,11 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	if (sdkp->opt_xfer_blocks && sdkp->opt_xfer_blocks <= dev_max &&
 	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS)
-		rw_max = q->limits.io_opt =
+		q->limits.io_opt =
 			logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
-	else
-		rw_max = BLK_DEF_MAX_SECTORS;
+
+	rw_max = min_t(unsigned, BLK_DEF_MAX_SECTORS,
+		       q->limits.max_dev_sectors);
 
 	/* Combine with controller limits */
 	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
-- 
1.9.1





> 
> Thanks,
> Eryu
> 
> P.S. full call trace
> 
> [  686.065692] scsi_debug:sdebug_driver_probe: host protection
> [  686.065710] scsi host1: scsi_debug, version 1.85 [20141022], dev_size_mb=256, opts=0x0
> [  686.065981] scsi 1:0:0:0: Direct-Access     Linux    scsi_debug       0184 PQ: 0 ANSI: 6
> [  686.066873] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [  686.077683] sd 1:0:0:0: [sdb] 524288 512-byte logical blocks: (268 MB/256 MiB)
> [  686.077694] sd 1:0:0:0: [sdb] 4096-byte physical blocks
> [  686.087670] sd 1:0:0:0: [sdb] Write Protect is off
> [  686.107671] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [  686.217682] bio_split: sectors 0, bio_sectors 128, bi_rw 0
> [  686.217695] ------------[ cut here ]------------
> [  686.217698] kernel BUG at block/bio.c:1793!
> [  686.217702] Oops: Exception in kernel mode, sig: 5 [#1]
> [  686.217704] SMP NR_CPUS=2048 NUMA pSeries
> [  686.217707] Modules linked in: scsi_debug sg pseries_rng nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod ibmvscsi ibmveth scsi_transport_srp
> [  686.217727] CPU: 8 PID: 9515 Comm: kworker/u32:0 Not tainted 4.4.0-rc5+ #33
> [  686.217733] Workqueue: events_unbound async_run_entry_fn
> [  686.217737] task: c0000005edb23cc0 ti: c0000005f016c000 task.ti: c0000005f016c000
> [  686.217740] NIP: c0000000003c45c4 LR: c0000000003c46b8 CTR: 00000000013abb8c
> [  686.217743] REGS: c0000005f016ea20 TRAP: 0700   Not tainted  (4.4.0-rc5+)
> [  686.217746] MSR: 8000000100029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 22bb2322  XER: 0000000f
> [  686.217756] CFAR: c0000000003c46cc SOFTE: 1 
> GPR00: c0000000003c46b8 c0000005f016eca0 c000000001068300 000000000000002e 
> GPR04: c0000005ffd09c50 c0000005ffd1b4a0 0000000000010000 0000000000000000 
> GPR08: 0000000000000001 c000000000bab284 00000005ff160000 0000000000000130 
> GPR12: 0000000000003f30 c00000000e7e4c00 0000000000000000 f0000000015d0e40 
> GPR16: c0000005f3c3b7a0 c000000574390000 0000000000000001 0000000000000000 
> GPR20: 0000000000000000 0000000000000080 0000000000000000 c0000005f5093200 
> GPR24: c0000005edb0efa0 c0000005f016ee60 c0000005f5093288 0000000000000000 
> GPR28: 0000000002400000 c0000005f5093200 0000000000000000 c0000005efd67600 
> [  686.217797] NIP [c0000000003c45c4] bio_split+0x54/0x160
> [  686.217800] LR [c0000000003c46b8] bio_split+0x148/0x160
> [  686.217803] Call Trace:
> [  686.217805] [c0000005f016eca0] [c0000000003c46b8] bio_split+0x148/0x160 (unreliable)
> [  686.217810] [c0000005f016ed30] [c0000000003d75e0] blk_queue_split+0x3c0/0x570
> [  686.217814] [c0000005f016ee30] [c0000000003d10a8] blk_queue_bio+0x48/0x440
> [  686.217818] [c0000005f016ee90] [c0000000003cec9c] generic_make_request+0x15c/0x220
> [  686.217822] [c0000005f016eef0] [c0000000003cee24] submit_bio+0xc4/0x1d0
> [  686.217826] [c0000005f016efa0] [c0000000002db204] submit_bh_wbc+0x1a4/0x200
> [  686.217830] [c0000005f016eff0] [c0000000002db6f0] block_read_full_page+0x320/0x420
> [  686.217835] [c0000005f016f4a0] [c0000000002dedb4] blkdev_readpage+0x24/0x40
> [  686.217839] [c0000005f016f4c0] [c0000000001f06fc] do_read_cache_page+0xbc/0x290
> [  686.217844] [c0000005f016f530] [c0000000003e8e00] read_dev_sector+0x40/0xc0
> [  686.217848] [c0000005f016f560] [c0000000003ec6bc] read_lba+0xdc/0x200
> [  686.217851] [c0000005f016f5c0] [c0000000003ece4c] find_valid_gpt+0xec/0x740
> [  686.217855] [c0000005f016f6a0] [c0000000003ed894] efi_partition+0x3f4/0x450
> [  686.217859] [c0000005f016f820] [c0000000003ea428] check_partition+0x158/0x2f0
> [  686.217863] [c0000005f016f8a0] [c0000000003e9694] rescan_partitions+0xd4/0x390
> [  686.217867] [c0000005f016f970] [c0000000002e0938] __blkdev_get+0x3a8/0x4d0
> [  686.217871] [c0000005f016f9e0] [c0000000002e0c90] blkdev_get+0x230/0x4a0
> [  686.217875] [c0000005f016fa90] [c0000000003e65b8] add_disk+0x478/0x500
> [  686.217880] [c0000005f016fb40] [d000000003fa66a8] sd_probe_async+0xf8/0x240 [sd_mod]
> [  686.217884] [c0000005f016fbc0] [c0000000000d7db8] async_run_entry_fn+0x98/0x1f0
> [  686.217888] [c0000005f016fc50] [c0000000000cc1a0] process_one_work+0x190/0x470
> [  686.217892] [c0000005f016fce0] [c0000000000cc5fc] worker_thread+0x17c/0x5a0
> [  686.217896] [c0000005f016fd80] [c0000000000d3da8] kthread+0x108/0x130
> [  686.217901] [c0000005f016fe30] [c000000000009538] ret_from_kernel_thread+0x5c/0xa4
> [  686.217904] Instruction dump:
> [  686.217906] 7cdf3378 7c9e2378 7c7d1b78 f8010010 7cbc2b78 f821ff71 80c30028 40dd00e8
> [  686.217912] 54caba7e 39000000 7f8a2040 40dd00d8 <0b080000> 54c9ba7e 7bdb0020 7f89d840
> [  686.217921] ---[ end trace 80d38b6aaec5b2ff ]---

