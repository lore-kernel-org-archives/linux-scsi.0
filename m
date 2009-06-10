From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Wed, 10 Jun 2009 22:41:53 +0200
Message-ID: <64bb37e0906101341j341f5179o9abfa888a6b96fc3@mail.gmail.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
	 <20090605104132.GE24836@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:34770 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZFJUlw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 16:41:52 -0400
In-Reply-To: <20090605104132.GE24836@amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu, lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jun 5, 2009 at 12:41 PM, Joerg Roedel<joerg.roedel@amd.com> wrote:
> From c0baa4d43a674c9cc321af3b23a6d5c9b46d65bd Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Fri, 5 Jun 2009 12:01:35 +0200
> Subject: [PATCH] dma-debug: change hash_bucket_find from first-fit to best-fit
>
> Some device drivers map the same physical address multiple times to a
> dma address. Without an IOMMU this results in the same dma address being
> put into the dma-debug hash multiple times. With a first-fit match in
> hash_bucket_find() this function may return the wrong dma_debug_entry.
> This can result in false positive warnings. This patch fixes it by
> changing the first-fit behavior of hash_bucket_find() into a best-fit
> algorithm.
>
> Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> Reported-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  lib/dma-debug.c |   43 +++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 39 insertions(+), 4 deletions(-)

I applied this patch to the just released 2.6.30, but it does not fix
the false warning on my System.

Jun 10 21:10:14 treogen [ 2611.715341] ------------[ cut here ]------------
Jun 10 21:10:14 treogen [ 2611.715359] WARNING: at lib/dma-debug.c:565
check_unmap+0x536/0x620()
Jun 10 21:10:14 treogen [ 2611.715363] Hardware name: KFN5-D SLI
Jun 10 21:10:14 treogen [ 2611.715369] sata_sil24 0000:04:00.0:
DMA-API: device driver frees DMA sg list with different entry count
[map count=2] [unmap count=1]
Jun 10 21:10:14 treogen [ 2611.715374] Modules linked in: msp3400
tuner tea5767 tda8290 tuner_xc2028 xc5000 tda9887 tuner_simple
tuner_types mt20xx tea5761 bttv ir_common v4l2_common videodev
v4l1_compat v4l2_compat_ioctl32 videobuf_dma_sg videobuf_core
btcx_risc sg pata_amd tveeprom
Jun 10 21:10:14 treogen [ 2611.715416] Pid: 0, comm: swapper Not
tainted 2.6.30 #1
Jun 10 21:10:14 treogen [ 2611.715420] Call Trace:
Jun 10 21:10:14 treogen [ 2611.715424]  <IRQ>  [<ffffffff804175c6>] ?
check_unmap+0x536/0x620
Jun 10 21:10:14 treogen [ 2611.715441]  [<ffffffff80243308>]
warn_slowpath_common+0x78/0xd0
Jun 10 21:10:14 treogen [ 2611.715448]  [<ffffffff802433e4>]
warn_slowpath_fmt+0x64/0x70
Jun 10 21:10:14 treogen [ 2611.715458]  [<ffffffff8057c5d8>] ?
dec_pending+0x88/0x170
Jun 10 21:10:14 treogen [ 2611.715465]  [<ffffffff8057c8bf>] ?
clone_endio+0x9f/0xd0
Jun 10 21:10:14 treogen [ 2611.715475]  [<ffffffff8068e52d>] ?
_spin_lock_irqsave+0x1d/0x40
Jun 10 21:10:14 treogen [ 2611.715482]  [<ffffffff804175c6>]
check_unmap+0x536/0x620
Jun 10 21:10:14 treogen [ 2611.715493]  [<ffffffff8028de5a>] ?
mempool_free+0x8a/0xa0
Jun 10 21:10:14 treogen [ 2611.715501]  [<ffffffff804177bd>]
debug_dma_unmap_sg+0x10d/0x190
Jun 10 21:10:14 treogen [ 2611.715510]  [<ffffffff802c0e55>] ?
__slab_free+0x185/0x340
Jun 10 21:10:14 treogen [ 2611.715519]  [<ffffffff804c1121>] ?
__scsi_put_command+0x61/0xa0
Jun 10 21:10:14 treogen [ 2611.715528]  [<ffffffff804d4258>]
ata_sg_clean+0x78/0xf0
Jun 10 21:10:14 treogen [ 2611.715535]  [<ffffffff804d4305>]
__ata_qc_complete+0x35/0x110
Jun 10 21:10:14 treogen [ 2611.715544]  [<ffffffff804c7b88>] ?
scsi_io_completion+0x398/0x530
Jun 10 21:10:14 treogen [ 2611.715551]  [<ffffffff804d449d>]
ata_qc_complete+0xbd/0x250
Jun 10 21:10:14 treogen [ 2611.715559]  [<ffffffff804d49db>]
ata_qc_complete_multiple+0xab/0xf0
Jun 10 21:10:14 treogen [ 2611.715568]  [<ffffffff804ea289>]
sil24_interrupt+0xb9/0x5b0
Jun 10 21:10:14 treogen [ 2611.715576]  [<ffffffff802614cc>] ?
getnstimeofday+0x5c/0xf0
Jun 10 21:10:14 treogen [ 2611.715584]  [<ffffffff8025d349>] ?
ktime_get_ts+0x59/0x60
Jun 10 21:10:14 treogen [ 2611.715593]  [<ffffffff802730b0>]
handle_IRQ_event+0x70/0x180
Jun 10 21:10:14 treogen [ 2611.715601]  [<ffffffff802753bd>]
handle_fasteoi_irq+0x6d/0xe0
Jun 10 21:10:14 treogen [ 2611.715609]  [<ffffffff8020e42f>]
handle_irq+0x1f/0x30
Jun 10 21:10:14 treogen [ 2611.715614]  [<ffffffff8020db7a>] do_IRQ+0x6a/0xf0
Jun 10 21:10:14 treogen [ 2611.715623]  [<ffffffff8020be53>]
ret_from_intr+0x0/0xf
Jun 10 21:10:14 treogen [ 2611.715627]  <EOI>  [<ffffffff80213657>] ?
default_idle+0x77/0xe0
Jun 10 21:10:14 treogen [ 2611.715640]  [<ffffffff80213655>] ?
default_idle+0x75/0xe0
Jun 10 21:10:14 treogen [ 2611.715648]  [<ffffffff8025e3bf>] ?
notifier_call_chain+0x3f/0x80
Jun 10 21:10:14 treogen [ 2611.715655]  [<ffffffff802136f8>] ?
c1e_idle+0x38/0x110
Jun 10 21:10:14 treogen [ 2611.715663]  [<ffffffff8020a71e>] ?
cpu_idle+0x6e/0xd0
Jun 10 21:10:14 treogen [ 2611.715672]  [<ffffffff8067bb8d>] ?
rest_init+0x6d/0x80
Jun 10 21:10:14 treogen [ 2611.715682]  [<ffffffff80929cc5>] ?
start_kernel+0x35a/0x422
Jun 10 21:10:14 treogen [ 2611.715690]  [<ffffffff80929289>] ?
x86_64_start_reservations+0x99/0xb9
Jun 10 21:10:14 treogen [ 2611.715697]  [<ffffffff80929389>] ?
x86_64_start_kernel+0xe0/0xf2
Jun 10 21:10:14 treogen [ 2611.715702] ---[ end trace db81115dbc8b11c5 ]---
Jun 10 21:10:14 treogen [ 2611.715706] Mapped at:
Jun 10 21:10:14 treogen [ 2611.715709]  [<ffffffff80416ef9>]
debug_dma_map_sg+0x159/0x180
Jun 10 21:10:14 treogen [ 2611.715717]  [<ffffffff804d47cc>]
ata_qc_issue+0x19c/0x300
Jun 10 21:10:14 treogen [ 2611.715724]  [<ffffffff804da6c8>]
ata_scsi_translate+0xa8/0x180
Jun 10 21:10:14 treogen [ 2611.715733]  [<ffffffff804dd261>]
ata_scsi_queuecmd+0xb1/0x2d0
Jun 10 21:10:14 treogen [ 2611.715739]  [<ffffffff804c0f23>]
scsi_dispatch_cmd+0xe3/0x220

So I implemented a check that would turn of the DMA-API debugging, if
such a double mapping was observed.
The resulting place where this was triggered also verified that is
seems to be the RAID1 that is causing these mappings:

Jun 10 21:39:30 treogen [    9.251818] md: Autodetecting RAID arrays.
Jun 10 21:39:30 treogen [    9.334044] md: Scanned 5 and added 5 devices.
Jun 10 21:39:30 treogen [    9.334048] md: autorun ...
Jun 10 21:39:30 treogen [    9.334052] md: considering sdb3 ...
Jun 10 21:39:30 treogen [    9.334065] md:  adding sdb3 ...
Jun 10 21:39:30 treogen [    9.334073] md: sdb1 has different UUID to sdb3
Jun 10 21:39:30 treogen [    9.334081] md: sdc2 has different UUID to sdb3
Jun 10 21:39:30 treogen [    9.334091] md:  adding sda3 ...
Jun 10 21:39:30 treogen [    9.334101] md: sda1 has different UUID to sdb3
Jun 10 21:39:30 treogen [    9.334111] md: created md3
Jun 10 21:39:30 treogen [    9.334115] md: bind<sda3>
Jun 10 21:39:30 treogen [    9.334149] md: bind<sdb3>
Jun 10 21:39:30 treogen [    9.334166] md: running: <sdb3><sda3>
Jun 10 21:39:30 treogen [    9.346111] raid1: raid set md3 active with
2 out of 2 mirrors
Jun 10 21:39:30 treogen [    9.354255] md3: bitmap initialized from
disk: read 10/10 pages, set 24 bits
Jun 10 21:39:30 treogen [    9.354260] created bitmap (145 pages) for device md3
Jun 10 21:39:30 treogen [    9.354399] DMA-API: device mapped same
address twice, this use case cannot be handled currently - disabling
debugging
Jun 10 21:39:30 treogen [    9.359858] md: considering sdb1 ...
Jun 10 21:39:30 treogen [    9.359874] md:  adding sdb1 ...
Jun 10 21:39:30 treogen [    9.359882] md: sdc2 has different UUID to sdb1

Here is the patch, I was using. I hope Gmail does mangle it to badly...

From: Torsten Kaiser <just.for.lkml@googlemail.com>

The DMA-API allowes a device to map the same addresse multiple times.
If this happens (for example with md-raid1) the DMA-API debugging code can no
longer associate the map and unmap request with 100% confidence, as the keys
collide.
If the wrong entry gets returned on unmap, this can trigger bogus warnings about
mismatching parameters. This was visible on my system.
As such double mappings seem to be rather uncommon, only disable the DMA-API
if such a mapping is observed. This way all wrong warnings can be
prevented without
removing this debugging tool.

Possible enhancement: If the returned entry is 100% identical to the
entry that needs
to be added, it would be irrelevant which entry will be returned on
unmap. So could
allow identical entries into the hash list without turning itself off.

Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com
---
--- lib/dma-debug.c.orig	2009-06-10 21:22:53.371813622 +0200
+++ lib/dma-debug.c	2009-06-10 21:26:40.892282983 +0200
@@ -253,6 +253,12 @@ static void add_dma_entry(struct dma_deb
 	unsigned long flags;

 	bucket = get_hash_bucket(entry, &flags);
+	if (hash_bucket_find(bucket, entry)) {
+		printk(KERN_ERR "DMA-API: device mapped same address twice, "
+			"this use case cannot be handled currently "
+			"- disabling debugging\n");
+		global_disable = true;
+	}
 	hash_bucket_add(bucket, entry);
 	put_hash_bucket(bucket, &flags);
 }
