From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Thu, 11 Jun 2009 19:38:47 +0200
Message-ID: <64bb37e0906111038h1a5b9f17oec6c6368d2fbd36d@mail.gmail.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
	 <20090605104132.GE24836@amd.com>
	 <64bb37e0906101341j341f5179o9abfa888a6b96fc3@mail.gmail.com>
	 <20090611081032.GN5139@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:36300 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZFKRiq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2009 13:38:46 -0400
In-Reply-To: <20090611081032.GN5139@amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu, lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jun 11, 2009 at 10:10 AM, Joerg Roedel<joerg.roedel@amd.com> wrote:
> On Wed, Jun 10, 2009 at 10:41:53PM +0200, Torsten Kaiser wrote:
>> I applied this patch to the just released 2.6.30, but it does not fix
>> the false warning on my System.
>>
>> Jun 10 21:10:14 treogen [ 2611.715341] ------------[ cut here ]------------
>> Jun 10 21:10:14 treogen [ 2611.715359] WARNING: at lib/dma-debug.c:565
>> check_unmap+0x536/0x620()
>> Jun 10 21:10:14 treogen [ 2611.715363] Hardware name: KFN5-D SLI
>> Jun 10 21:10:14 treogen [ 2611.715369] sata_sil24 0000:04:00.0:
>> DMA-API: device driver frees DMA sg list with different entry count [map count=2] [unmap count=1]
>
> Ok, thats because we need also to check for sg_call_ents in the best-fit
> checks. Can you please test if you can reproduce it with the attached
> patch?
>
> From 1e83c7eab546314ad9dbe08602d243bb83e93b50 Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Thu, 11 Jun 2009 10:03:42 +0200
> Subject: [PATCH] dma-debug: check for sg_call_ents in best-fit algorithm too
>
> If we don't check for sg_call_ents the hash_bucket_find function might
> still return the wrong dma_debug_entry for sg mappings.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  lib/dma-debug.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)

I tried this patch, but I still get a wrong warning from the DMA-API:
Jun 11 19:24:57 treogen [    9.451064] raid1: raid set md2 active with
2 out of 2 mirrors
Jun 11 19:24:57 treogen [    9.479278] md2: bitmap initialized from
disk: read 10/10 pages, set 0 bits
Jun 11 19:24:57 treogen [    9.479282] created bitmap (153 pages) for device md2
Jun 11 19:24:57 treogen [    9.513544] md: ... autorun DONE.
Jun 11 19:24:57 treogen [    9.517590]  md3: unknown partition table
Jun 11 19:24:57 treogen [   20.718608] XFS mounting filesystem dm-0
Jun 11 19:24:57 treogen [   21.220452] ------------[ cut here ]------------
Jun 11 19:24:57 treogen [   21.220477] WARNING: at lib/dma-debug.c:532
check_unmap+0x49e/0x620()
Jun 11 19:24:57 treogen [   21.220482] Hardware name: KFN5-D SLI
Jun 11 19:24:57 treogen [   21.220488] sata_sil24 0000:04:00.0:
DMA-API: device driver tries to free DM
A memory it has not allocated [device address=0x000000011e4c3000]
[size=4096 bytes]
Jun 11 19:24:57 treogen [   21.220494] Modules linked in:
Jun 11 19:24:57 treogen [   21.220502] Pid: 1301, comm: kcryptd Not
tainted 2.6.30 #3
Jun 11 19:24:57 treogen [   21.220507] Call Trace:
Jun 11 19:24:57 treogen [   21.220510]  <IRQ>  [<ffffffff8041753e>] ?
check_unmap+0x49e/0x620
Jun 11 19:24:57 treogen [   21.220528]  [<ffffffff80243308>]
warn_slowpath_common+0x78/0xd0
Jun 11 19:24:57 treogen [   21.220535]  [<ffffffff802433e4>]
warn_slowpath_fmt+0x64/0x70
Jun 11 19:24:57 treogen [   21.220545]  [<ffffffff802c10b4>] ?
kmem_cache_free+0xa4/0x130
Jun 11 19:24:57 treogen [   21.220555]  [<ffffffff8028ddc2>] ?
mempool_free_slab+0x12/0x20
Jun 11 19:24:57 treogen [   21.220562]  [<ffffffff8028de5a>] ?
mempool_free+0x8a/0xa0
Jun 11 19:24:57 treogen [   21.220573]  [<ffffffff8068e53d>] ?
_spin_lock_irqsave+0x1d/0x40
Jun 11 19:24:57 treogen [   21.220580]  [<ffffffff8041753e>]
check_unmap+0x49e/0x620
Jun 11 19:24:57 treogen [   21.220587]  [<ffffffff8028ddc2>] ?
mempool_free_slab+0x12/0x20
Jun 11 19:24:57 treogen [   21.220597]  [<ffffffff803f17bc>] ?
__freed_request+0x10c/0x160
Jun 11 19:24:57 treogen [   21.220605]  [<ffffffff804177cd>]
debug_dma_unmap_sg+0x10d/0x190
Jun 11 19:24:57 treogen [   21.220614]  [<ffffffff804c1131>] ?
__scsi_put_command+0x61/0xa0
Jun 11 19:24:57 treogen [   21.220624]  [<ffffffff804d4268>]
ata_sg_clean+0x78/0xf0
Jun 11 19:24:57 treogen [   21.220631]  [<ffffffff804d4315>]
__ata_qc_complete+0x35/0x110
Jun 11 19:24:57 treogen [   21.220640]  [<ffffffff804c7b98>] ?
scsi_io_completion+0x398/0x530
Jun 11 19:24:57 treogen [   21.220647]  [<ffffffff804d44ad>]
ata_qc_complete+0xbd/0x250
Jun 11 19:24:57 treogen [   21.220654]  [<ffffffff804d49eb>]
ata_qc_complete_multiple+0xab/0xf0
Jun 11 19:24:57 treogen [   21.220664]  [<ffffffff804ea299>]
sil24_interrupt+0xb9/0x5b0
Jun 11 19:24:57 treogen [   21.220673]  [<ffffffff802730b0>]
handle_IRQ_event+0x70/0x180
Jun 11 19:24:57 treogen [   21.220681]  [<ffffffff802753bd>]
handle_fasteoi_irq+0x6d/0xe0
Jun 11 19:24:57 treogen [   21.220689]  [<ffffffff8020e42f>]
handle_irq+0x1f/0x30
Jun 11 19:24:57 treogen [   21.220695]  [<ffffffff8020db7a>] do_IRQ+0x6a/0xf0
Jun 11 19:24:57 treogen [   21.220704]  [<ffffffff8020be53>]
ret_from_intr+0x0/0xf
Jun 11 19:24:57 treogen [   21.220707]  <EOI>  [<ffffffff80409aab>] ?
memcpy_c+0xb/0x20
Jun 11 19:24:57 treogen [   21.220722]  [<ffffffff803e5bc8>] ?
crypto_cbc_encrypt+0xd8/0x1b0
Jun 11 19:24:57 treogen [   21.220729]  [<ffffffff8022f320>] ?
twofish_encrypt+0x0/0x10
Jun 11 19:24:57 treogen [   21.220739]  [<ffffffff803dcd68>] ?
async_encrypt+0x38/0x40
Jun 11 19:24:57 treogen [   21.220749]  [<ffffffff8058447a>] ?
crypt_convert+0x20a/0x2a0
Jun 11 19:24:57 treogen [   21.220757]  [<ffffffff805847dd>] ?
kcryptd_crypt+0x2cd/0x500
Jun 11 19:24:57 treogen [   21.220765]  [<ffffffff80584510>] ?
kcryptd_crypt+0x0/0x500
Jun 11 19:24:57 treogen [   21.220774]  [<ffffffff80255cf7>] ?
worker_thread+0x137/0x1f0
Jun 11 19:24:57 treogen [   21.220782]  [<ffffffff80259d20>] ?
autoremove_wake_function+0x0/0x40
Jun 11 19:24:57 treogen [   21.220790]  [<ffffffff80255bc0>] ?
worker_thread+0x0/0x1f0
Jun 11 19:24:57 treogen [   21.220797]  [<ffffffff80255bc0>] ?
worker_thread+0x0/0x1f0
Jun 11 19:24:57 treogen [   21.220804]  [<ffffffff80259886>] ? kthread+0x56/0x90
Jun 11 19:24:57 treogen [   21.220812]  [<ffffffff8020c4aa>] ?
child_rip+0xa/0x20
Jun 11 19:24:57 treogen [   21.220819]  [<ffffffff8020bea9>] ?
restore_args+0x0/0x30
Jun 11 19:24:57 treogen [   21.220825]  [<ffffffff80259830>] ? kthread+0x0/0x90
Jun 11 19:24:57 treogen [   21.220832]  [<ffffffff8020c4a0>] ?
child_rip+0x0/0x20
Jun 11 19:24:57 treogen [   21.220836] ---[ end trace f020083379b5b162 ]---
Jun 11 19:24:57 treogen [   21.339740] Ending clean XFS mount for
filesystem: dm-0

Torsten
