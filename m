From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Sat, 13 Jun 2009 19:08:01 +0200
Message-ID: <64bb37e0906131008x59b25b94u501fc2192cc28be0@mail.gmail.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
	 <20090605104132.GE24836@amd.com>
	 <64bb37e0906101341j341f5179o9abfa888a6b96fc3@mail.gmail.com>
	 <20090611081032.GN5139@amd.com>
	 <64bb37e0906111038h1a5b9f17oec6c6368d2fbd36d@mail.gmail.com>
	 <20090612141346.GY5139@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56121 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbZFMRIA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Jun 2009 13:08:00 -0400
In-Reply-To: <20090612141346.GY5139@amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu, lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jun 12, 2009 at 4:13 PM, Joerg Roedel<joerg.roedel@amd.com> wrote:
> On Thu, Jun 11, 2009 at 07:38:47PM +0200, Torsten Kaiser wrote:
>> DMA-API: device driver tries to free DM
>> A memory it has not allocated [device address=0x000000011e4c3000]
>> [size=4096 bytes]
>
> Hmm, looking again over the code I've seen that the ref
> dma_debug_entries are not alway filled with all necessary information
> for best-fit. Can you please try if you still get false warnings when
> you apply the two patches attached instead of the one I sent yesterday?

I tested these patches
(0001-dma-debug-check-for-sg_call_ents-in-best-fit-algorit.patch and
0002-dma-debug-be-more-careful-when-building-reference-en.patch)
against 2.6.30-git6 and did not see any warnings.

I can't be 100% sure about the fix, because I do not have a reliable
trigger, but it looks quite good.

Torsten


Just for reference, with an unpatched 2.6.30-git6 the warning was still there:
Jun 13 16:54:56 treogen [  168.201493] ------------[ cut here ]------------
Jun 13 16:54:56 treogen [  168.201512] WARNING: at lib/dma-debug.c:827
check_unmap+0x593/0x670()
Jun 13 16:54:56 treogen [  168.201517] Hardware name: KFN5-D SLI
Jun 13 16:54:56 treogen [  168.201522] sata_sil24 0000:04:00.0:
DMA-API: device driver frees DMA sg lis
t with different entry count [map count=1] [unmap count=2]
Jun 13 16:54:56 treogen [  168.201526] Modules linked in: msp3400
tuner tea5767 tda8290 tuner_xc2028 xc
5000 tda9887 tuner_simple tuner_types mt20xx tea5761 bttv ir_common
v4l2_common videodev v4l1_compat v4
l2_compat_ioctl32 videobuf_dma_sg videobuf_core pata_amd btcx_risc tveeprom sg
Jun 13 16:54:56 treogen [  168.201562] Pid: 0, comm: swapper Not
tainted 2.6.30-git6 #1
Jun 13 16:54:56 treogen [  168.201566] Call Trace:
Jun 13 16:54:56 treogen [  168.201569]  <IRQ>  [<ffffffff8120bb63>] ?
check_unmap+0x593/0x670
Jun 13 16:54:56 treogen [  168.201585]  [<ffffffff81044138>]
warn_slowpath_common+0x78/0xd0
Jun 13 16:54:56 treogen [  168.201591]  [<ffffffff81044214>]
warn_slowpath_fmt+0x64/0x70
Jun 13 16:54:56 treogen [  168.201599]  [<ffffffff810b3bf5>] ?
__slab_free+0x185/0x340
Jun 13 16:54:56 treogen [  168.201606]  [<ffffffff8120bb63>]
check_unmap+0x593/0x670
Jun 13 16:54:56 treogen [  168.201615]  [<ffffffff810e532d>] ?
bio_free+0x4d/0x60
Jun 13 16:54:56 treogen [  168.201622]  [<ffffffff810e5350>] ?
bio_fs_destructor+0x10/0x20
Jun 13 16:54:56 treogen [  168.201628]  [<ffffffff8120bd3e>]
debug_dma_unmap_sg+0xfe/0x140
Jun 13 16:54:56 treogen [  168.201636]  [<ffffffff812ab102>] ?
put_device+0x12/0x20
Jun 13 16:54:56 treogen [  168.201645]  [<ffffffff812c9248>]
ata_sg_clean+0x78/0xf0
Jun 13 16:54:56 treogen [  168.201651]  [<ffffffff812c92f5>]
__ata_qc_complete+0x35/0x110
Jun 13 16:54:56 treogen [  168.201658]  [<ffffffff812c948d>]
ata_qc_complete+0xbd/0x250
Jun 13 16:54:56 treogen [  168.201665]  [<ffffffff812c99bc>]
ata_qc_complete_multiple+0x9c/0xf0
Jun 13 16:54:56 treogen [  168.201674]  [<ffffffff812df219>]
sil24_interrupt+0xb9/0x5b0
Jun 13 16:54:56 treogen [  168.201681]  [<ffffffff81061c5c>] ?
getnstimeofday+0x5c/0xf0
Jun 13 16:54:56 treogen [  168.201688]  [<ffffffff8105dba9>] ?
ktime_get_ts+0x59/0x60
Jun 13 16:54:56 treogen [  168.201696]  [<ffffffff81074598>]
handle_IRQ_event+0x68/0x160
Jun 13 16:54:56 treogen [  168.201703]  [<ffffffff8107663d>]
handle_fasteoi_irq+0x6d/0xe0
Jun 13 16:54:56 treogen [  168.201710]  [<ffffffff8100e33f>]
handle_irq+0x1f/0x30
Jun 13 16:54:56 treogen [  168.201715]  [<ffffffff8100d9ba>] do_IRQ+0x6a/0xe0
Jun 13 16:54:56 treogen [  168.201722]  [<ffffffff8100bd53>]
ret_from_intr+0x0/0xa
Jun 13 16:54:56 treogen [  168.201725]  <EOI>  [<ffffffff8101340a>] ?
default_idle+0x6a/0xd0
Jun 13 16:54:56 treogen [  168.201738]  [<ffffffff8105ebff>] ?
notifier_call_chain+0x3f/0x80
Jun 13 16:54:56 treogen [  168.201744]  [<ffffffff810134a8>] ?
c1e_idle+0x38/0x100
Jun 13 16:54:56 treogen [  168.201751]  [<ffffffff8105ec65>] ?
atomic_notifier_call_chain+0x15/0x20
Jun 13 16:54:56 treogen [  168.201757]  [<ffffffff8100a662>] ?
cpu_idle+0x62/0xb0
Jun 13 16:54:56 treogen [  168.201766]  [<ffffffff8147190d>] ?
rest_init+0x6d/0x80
Jun 13 16:54:56 treogen [  168.201774]  [<ffffffff8171dcad>] ?
start_kernel+0x342/0x405
Jun 13 16:54:56 treogen [  168.201781]  [<ffffffff8171d289>] ?
x86_64_start_reservations+0x99/0xb9
Jun 13 16:54:56 treogen [  168.201787]  [<ffffffff8171d389>] ?
x86_64_start_kernel+0xe0/0xf2
Jun 13 16:54:56 treogen [  168.201792] ---[ end trace 7ab4a9443c6c6e69 ]---
Jun 13 16:54:56 treogen [  168.201795] Mapped at:
Jun 13 16:54:56 treogen [  168.201797]  [<ffffffff8120c609>]
debug_dma_map_sg+0x159/0x180
Jun 13 16:54:56 treogen [  168.201805]  [<ffffffff812c97bc>]
ata_qc_issue+0x19c/0x300
Jun 13 16:54:56 treogen [  168.201812]  [<ffffffff812cf6b8>]
ata_scsi_translate+0xa8/0x180
Jun 13 16:54:56 treogen [  168.201818]  [<ffffffff812d2251>]
ata_scsi_queuecmd+0xb1/0x2d0
Jun 13 16:54:56 treogen [  168.201823]  [<ffffffff812b5fb3>]
scsi_dispatch_cmd+0xe3/0x220
