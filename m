From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: sata_sil24 0000:04:00.0: DMA-API: device driver frees DMA sg list
	with different entry count [map count=13] [unmap count=10]
Date: Tue, 26 May 2009 21:14:29 +0200
Message-ID: <64bb37e0905261214g2957924ar837339367f320d4c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:47015 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZEZTOa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2009 15:14:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On upgrading to 2.6.30-rc1 I enable the DMA-Debugging option
CONFIG_DMA_API_DEBUG=y
Since then I get the following or similar errors on each boot:

May 26 06:50:31 treogen [  231.082923] ------------[ cut here ]------------
May 26 06:50:31 treogen [  231.082942] WARNING: at lib/dma-debug.c:530
check_unmap+0x65e/0x6a0()
May 26 06:50:31 treogen [  231.082947] Hardware name: KFN5-D SLI
May 26 06:50:31 treogen [  231.082952] sata_sil24 0000:04:00.0:
DMA-API: device driver frees DMA sg list with different entry count
[map count=13] [unmap count=10]
May 26 06:50:31 treogen [  231.082958] Modules linked in: msp3400
tuner tea5767 tda8290 tuner_xc2028 xc5000 tda9887 tuner_simple
tuner_types mt20xx tea5761 bttv ir_common v4l2_common videodev
v4l1_compat v4l2_compat_ioctl32 videobuf_dma_sg videobuf_core sg
pata_amd btcx_risc tveeprom
May 26 06:50:31 treogen [  231.083000] Pid: 3575, comm: logger Not
tainted 2.6.30-rc7 #1
May 26 06:50:31 treogen [  231.083005] Call Trace:
May 26 06:50:31 treogen [  231.083009]  <IRQ>  [<ffffffff8041755e>] ?
check_unmap+0x65e/0x6a0
May 26 06:50:31 treogen [  231.083026]  [<ffffffff802432d8>]
warn_slowpath_common+0x78/0xd0
May 26 06:50:31 treogen [  231.083033]  [<ffffffff802433b4>]
warn_slowpath_fmt+0x64/0x70
May 26 06:50:31 treogen [  231.083043]  [<ffffffff8028dd42>] ?
mempool_free_slab+0x12/0x20
May 26 06:50:31 treogen [  231.083054]  [<ffffffff8068d74d>] ?
_spin_lock_irqsave+0x1d/0x40
May 26 06:50:31 treogen [  231.083061]  [<ffffffff8041755e>]
check_unmap+0x65e/0x6a0
May 26 06:50:31 treogen [  231.083068]  [<ffffffff804176ae>]
debug_dma_unmap_sg+0x10e/0x1b0
May 26 06:50:31 treogen [  231.083077]  [<ffffffff804bfe31>] ?
__scsi_put_command+0x61/0xa0
May 26 06:50:31 treogen [  231.083086]  [<ffffffff804d2f68>]
ata_sg_clean+0x78/0xf0
May 26 06:50:31 treogen [  231.083093]  [<ffffffff804d3015>]
__ata_qc_complete+0x35/0x110
May 26 06:50:31 treogen [  231.083101]  [<ffffffff804c6898>] ?
scsi_io_completion+0x398/0x530
May 26 06:50:31 treogen [  231.083108]  [<ffffffff804d31ad>]
ata_qc_complete+0xbd/0x250
May 26 06:50:31 treogen [  231.083116]  [<ffffffff804d36eb>]
ata_qc_complete_multiple+0xab/0xf0
May 26 06:50:31 treogen [  231.083125]  [<ffffffff804e8f99>]
sil24_interrupt+0xb9/0x5b0
May 26 06:50:31 treogen [  231.083133]  [<ffffffff80273030>]
handle_IRQ_event+0x70/0x180
May 26 06:50:31 treogen [  231.083140]  [<ffffffff8027533d>]
handle_fasteoi_irq+0x6d/0xe0
May 26 06:50:31 treogen [  231.083147]  [<ffffffff8020e42f>]
handle_irq+0x1f/0x30
May 26 06:50:31 treogen [  231.083153]  [<ffffffff8020db7a>] do_IRQ+0x6a/0xf0
May 26 06:50:31 treogen [  231.083162]  [<ffffffff8020be53>]
ret_from_intr+0x0/0xf
May 26 06:50:31 treogen [  231.083166]  <EOI>  [<ffffffff8068d5fa>] ?
_spin_unlock_irqrestore+0x1a/0x40
May 26 06:50:31 treogen [  231.083179]  [<ffffffff80405981>] ?
__up_read+0x91/0xb0
May 26 06:50:31 treogen [  231.083188]  [<ffffffff8025da89>] ? up_read+0x9/0x10
May 26 06:50:31 treogen [  231.083196]  [<ffffffff80229477>] ?
do_page_fault+0x147/0x280
May 26 06:50:31 treogen [  231.083204]  [<ffffffff8068d9df>] ?
page_fault+0x1f/0x30
May 26 06:50:31 treogen [  231.083209] ---[ end trace 9d69801031c35329 ]---
May 26 06:50:31 treogen [  231.083213] Mapped at:
May 26 06:50:31 treogen [  231.083215]  [<ffffffff80416d69>]
debug_dma_map_sg+0x159/0x180
May 26 06:50:31 treogen [  231.083224]  [<ffffffff804d34dc>]
ata_qc_issue+0x19c/0x300
May 26 06:50:31 treogen [  231.083231]  [<ffffffff804d93d8>]
ata_scsi_translate+0xa8/0x180
May 26 06:50:31 treogen [  231.083239]  [<ffffffff804dbf71>]
ata_scsi_queuecmd+0xb1/0x2d0
May 26 06:50:31 treogen [  231.083245]  [<ffffffff804bfc33>]
scsi_dispatch_cmd+0xe3/0x220

Other traces:
One with a size mismatch instead of the wrong map count:
May 26 19:16:55 treogen [  131.688242] ------------[ cut here ]------------
May 26 19:16:55 treogen [  131.688262] WARNING: at lib/dma-debug.c:505
check_unmap+0x455/0x6a0()
May 26 19:16:55 treogen [  131.688267] Hardware name: KFN5-D SLI
May 26 19:16:55 treogen [  131.688273] sata_sil24 0000:04:00.0:
DMA-API: device driver frees DMA memory
 with different size [device address=0x0000000078886000] [map
size=8192 bytes] [unmap size=16384 bytes]
May 26 19:16:55 treogen [  131.688280] Modules linked in: msp3400
tuner tea5767 tda8290 tuner_xc2028 xc
5000 tda9887 tuner_simple tuner_types mt20xx tea5761 bttv ir_common
v4l2_common videodev v4l1_compat v4
l2_compat_ioctl32 videobuf_dma_sg videobuf_core btcx_risc tveeprom sg pata_amd
May 26 19:16:55 treogen [  131.688322] Pid: 0, comm: swapper Not
tainted 2.6.30-rc7 #1
May 26 19:16:55 treogen [  131.688327] Call Trace:
May 26 19:16:55 treogen [  131.688331]  <IRQ>  [<ffffffff80417355>] ?
check_unmap+0x455/0x6a0
May 26 19:16:55 treogen [  131.688348]  [<ffffffff802432d8>]
warn_slowpath_common+0x78/0xd0
May 26 19:16:55 treogen [  131.688355]  [<ffffffff802433b4>]
warn_slowpath_fmt+0x64/0x70
May 26 19:16:55 treogen [  131.688366]  [<ffffffff8028dd42>] ?
mempool_free_slab+0x12/0x20
May 26 19:16:55 treogen [  131.688376]  [<ffffffff8068d74d>] ?
_spin_lock_irqsave+0x1d/0x40
May 26 19:16:55 treogen [  131.688384]  [<ffffffff80417355>]
check_unmap+0x455/0x6a0
May 26 19:16:55 treogen [  131.688391]  [<ffffffff804176ae>]
debug_dma_unmap_sg+0x10e/0x1b0
May 26 19:16:55 treogen [  131.688400]  [<ffffffff804bfe31>] ?
__scsi_put_command+0x61/0xa0
May 26 19:16:55 treogen [  131.688410]  [<ffffffff804d2f68>]
ata_sg_clean+0x78/0xf0
May 26 19:16:55 treogen [  131.688417]  [<ffffffff804d3015>]
__ata_qc_complete+0x35/0x110
May 26 19:16:55 treogen [  131.688426]  [<ffffffff804c6898>] ?
scsi_io_completion+0x398/0x530
May 26 19:16:55 treogen [  131.688433]  [<ffffffff804d31ad>]
ata_qc_complete+0xbd/0x250
May 26 19:16:55 treogen [  131.688441]  [<ffffffff804d36eb>]
ata_qc_complete_multiple+0xab/0xf0
May 26 19:16:55 treogen [  131.688450]  [<ffffffff804e8f99>]
sil24_interrupt+0xb9/0x5b0
May 26 19:16:55 treogen [  131.688457]  [<ffffffff8026147c>] ?
getnstimeofday+0x5c/0xf0
May 26 19:16:55 treogen [  131.688466]  [<ffffffff8025d309>] ?
ktime_get_ts+0x59/0x60
May 26 19:16:55 treogen [  131.688474]  [<ffffffff80273030>]
handle_IRQ_event+0x70/0x180
May 26 19:16:55 treogen [  131.688482]  [<ffffffff8027533d>]
handle_fasteoi_irq+0x6d/0xe0
May 26 19:16:55 treogen [  131.688489]  [<ffffffff8020e42f>]
handle_irq+0x1f/0x30
May 26 19:16:55 treogen [  131.688495]  [<ffffffff8020db7a>] do_IRQ+0x6a/0xf0
May 26 19:16:55 treogen [  131.688504]  [<ffffffff8020be53>]
ret_from_intr+0x0/0xf
May 26 19:16:55 treogen [  131.688508]  <EOI>  [<ffffffff80213657>] ?
default_idle+0x77/0xe0
May 26 19:16:55 treogen [  131.688522]  [<ffffffff80213655>] ?
default_idle+0x75/0xe0
May 26 19:16:55 treogen [  131.688529]  [<ffffffff8025e37f>] ?
notifier_call_chain+0x3f/0x80
May 26 19:16:55 treogen [  131.688536]  [<ffffffff802136f8>] ?
c1e_idle+0x38/0x110
May 26 19:16:55 treogen [  131.688544]  [<ffffffff8020a71e>] ?
cpu_idle+0x6e/0xd0
May 26 19:16:55 treogen [  131.688553]  [<ffffffff8067adbd>] ?
rest_init+0x6d/0x80
May 26 19:16:55 treogen [  131.688562]  [<ffffffff80929cc5>] ?
start_kernel+0x35a/0x422
May 26 19:16:55 treogen [  131.688570]  [<ffffffff80929289>] ?
x86_64_start_reservations+0x99/0xb9
May 26 19:16:55 treogen [  131.688577]  [<ffffffff80929389>] ?
x86_64_start_kernel+0xe0/0xf2
May 26 19:16:55 treogen [  131.688582] ---[ end trace cff6b5339db27b54 ]---
May 26 19:16:55 treogen [  131.688585] Mapped at:
May 26 19:16:55 treogen [  131.688588]  [<ffffffff80416d69>]
debug_dma_map_sg+0x159/0x180
May 26 19:16:55 treogen [  131.688597]  [<ffffffff804d34dc>]
ata_qc_issue+0x19c/0x300
May 26 19:16:55 treogen [  131.688604]  [<ffffffff804d93d8>]
ata_scsi_translate+0xa8/0x180
May 26 19:16:55 treogen [  131.688613]  [<ffffffff804dbf71>]
ata_scsi_queuecmd+0xb1/0x2d0
May 26 19:16:55 treogen [  131.688619]  [<ffffffff804bfc33>]
scsi_dispatch_cmd+0xe3/0x220

sometimes the "Mapped at" info is missing:
May 23 03:57:55 treogen [   70.774289] ------------[ cut here ]------------
May 23 03:57:55 treogen [   70.774297] WARNING: at lib/dma-debug.c:530
check_unmap+0x65e/0x6a0()
May 23 03:57:55 treogen [   70.774302] Hardware name: KFN5-D SLI
May 23 03:57:55 treogen [   70.774307] sata_sil24 0000:04:00.0:
DMA-API: device driver frees DMA sg lis
t with different entry count [map count=4] [unmap count=2]
May 23 03:57:55 treogen [   70.774313] Modules linked in: msp3400
tuner tea5767 tda8290 tuner_xc2028 xc
5000 tda9887 tuner_simple tuner_types mt20xx tea5761 bttv ir_common
v4l2_common videodev v4l1_compat v4
l2_compat_ioctl32 videobuf_dma_sg videobuf_core btcx_risc tveeprom pata_amd sg
May 23 03:57:55 treogen [   70.774355] Pid: 458, comm: xfslogd/3 Not
tainted 2.6.30-rc6 #1
May 23 03:57:55 treogen [   70.774359] Call Trace:
May 23 03:57:55 treogen [   70.774363]  <IRQ>  [<ffffffff80243330>]
warn_slowpath_fmt+0xd0/0x120
May 23 03:57:55 treogen [   70.774383]  [<ffffffff8020e966>] ?
dump_trace+0x116/0x2c0
May 23 03:57:55 treogen [   70.774395]  [<ffffffff8068d4bf>] ?
_spin_unlock_irqrestore+0x2f/0x40
May 23 03:57:55 treogen [   70.774402]  [<ffffffff804163c4>] ?
add_dma_entry+0x64/0x80
May 23 03:57:55 treogen [   70.774413]  [<ffffffff804e8c90>] ?
sil24_qc_prep+0xb0/0x150
May 23 03:57:55 treogen [   70.774422]  [<ffffffff804d33f5>] ?
ata_qc_issue+0x1e5/0x300
May 23 03:57:55 treogen [   70.774430]  [<ffffffff804bf9f0>] ?
scsi_done+0x0/0x20
May 23 03:57:55 treogen [   70.774438]  [<ffffffff804d8ff0>] ?
ata_scsi_rw_xlat+0x0/0x210
May 23 03:57:55 treogen [   70.774445]  [<ffffffff804d92a8>] ?
ata_scsi_translate+0xa8/0x180
May 23 03:57:55 treogen [   70.774452]  [<ffffffff804174de>]
check_unmap+0x65e/0x6a0
May 23 03:57:55 treogen [   70.774459]  [<ffffffff8041762e>]
debug_dma_unmap_sg+0x10e/0x1b0
May 23 03:57:55 treogen [   70.774467]  [<ffffffff804bfcf1>] ?
__scsi_put_command+0x61/0xa0
May 23 03:57:55 treogen [   70.774474]  [<ffffffff804d2e38>]
ata_sg_clean+0x78/0xf0
May 23 03:57:55 treogen [   70.774480]  [<ffffffff804d2ee5>]
__ata_qc_complete+0x35/0x110
May 23 03:57:55 treogen [   70.774489]  [<ffffffff804c6758>] ?
scsi_io_completion+0x398/0x530
May 23 03:57:55 treogen [   70.774496]  [<ffffffff804d307d>]
ata_qc_complete+0xbd/0x250
May 23 03:57:55 treogen [   70.774503]  [<ffffffff804d35bb>]
ata_qc_complete_multiple+0xab/0xf0
May 23 03:57:55 treogen [   70.774510]  [<ffffffff804e8e69>]
sil24_interrupt+0xb9/0x5a0
May 23 03:57:55 treogen [   70.774520]  [<ffffffff80272ff0>]
handle_IRQ_event+0x70/0x180
May 23 03:57:55 treogen [   70.774527]  [<ffffffff802752fd>]
handle_fasteoi_irq+0x6d/0xe0
May 23 03:57:55 treogen [   70.774533]  [<ffffffff8020e42f>]
handle_irq+0x1f/0x30
May 23 03:57:55 treogen [   70.774538]  [<ffffffff8020db7a>] do_IRQ+0x6a/0xf0
May 23 03:57:55 treogen [   70.774547]  [<ffffffff8020be53>]
ret_from_intr+0x0/0xf
May 23 03:57:55 treogen [   70.774551]  <EOI>  [<ffffffff8023c544>] ?
finish_task_switch+0x54/0x100
May 23 03:57:55 treogen [   70.774566]  [<ffffffff803fbc00>] ?
cfq_kick_queue+0x0/0x40
May 23 03:57:55 treogen [   70.774573]  [<ffffffff8068aad7>] ?
thread_return+0x3e/0x6f7
May 23 03:57:55 treogen [   70.774582]  [<ffffffff803bcb00>] ?
xfs_buf_iodone_work+0x0/0xa0
May 23 03:57:55 treogen [   70.774589]  [<ffffffff803bcb00>] ?
xfs_buf_iodone_work+0x0/0xa0
May 23 03:57:55 treogen [   70.774595]  [<ffffffff8068b199>] ? schedule+0x9/0x20
May 23 03:57:55 treogen [   70.774604]  [<ffffffff80255d45>] ?
worker_thread+0x1e5/0x1f0
May 23 03:57:55 treogen [   70.774612]  [<ffffffff80259cc0>] ?
autoremove_wake_function+0x0/0x40
May 23 03:57:55 treogen [   70.774620]  [<ffffffff80255b60>] ?
worker_thread+0x0/0x1f0
May 23 03:57:55 treogen [   70.774627]  [<ffffffff80255b60>] ?
worker_thread+0x0/0x1f0
May 23 03:57:55 treogen [   70.774633]  [<ffffffff80259826>] ? kthread+0x56/0x90
May 23 03:57:55 treogen [   70.774641]  [<ffffffff8020c4aa>] ?
child_rip+0xa/0x20
May 23 03:57:55 treogen [   70.774648]  [<ffffffff8020bea9>] ?
restore_args+0x0/0x30
May 23 03:57:55 treogen [   70.774654]  [<ffffffff802597d0>] ? kthread+0x0/0x90
May 23 03:57:55 treogen [   70.774661]  [<ffffffff8020c4a0>] ?
child_rip+0x0/0x20
May 23 03:57:55 treogen [   70.774665] ---[ end trace 65ea6e90ae7ed767 ]---
May 23 03:57:55 treogen [   70.774669] Mapped at:
May 23 03:57:55 treogen [   70.774672]  [<ffffffffffffffff>] 0xffffffffffffffff

It is also not at the same time of each boot, once it took really long
to show up:
May 24 15:50:24 treogen [25330.655309] ------------[ cut here ]------------
May 24 15:50:24 treogen [25330.655327] WARNING: at lib/dma-debug.c:530
check_unmap+0x65e/0x6a0()
May 24 15:50:24 treogen [25330.655331] Hardware name: KFN5-D SLI
May 24 15:50:24 treogen [25330.655337] sata_sil24 0000:04:00.0:
DMA-API: device driver frees DMA sg lis
t with different entry count [map count=2] [unmap count=1]
May 24 15:50:24 treogen [25330.655342] Modules linked in: msp3400
tuner tea5767 tda8290 tuner_xc2028 xc
5000 tda9887 tuner_simple tuner_types mt20xx tea5761 bttv ir_common
v4l2_common videodev v4l1_compat v4
l2_compat_ioctl32 videobuf_dma_sg videobuf_core btcx_risc sg tveeprom pata_amd
May 24 15:50:24 treogen [25330.655384] Pid: 0, comm: swapper Not
tainted 2.6.30-rc7 #1
May 24 15:50:24 treogen [25330.655388] Call Trace:
May 24 15:50:24 treogen [25330.655392]  <IRQ>  [<ffffffff8041755e>] ?
check_unmap+0x65e/0x6a0
May 24 15:50:24 treogen [25330.655408]  [<ffffffff802432d8>]
warn_slowpath_common+0x78/0xd0
May 24 15:50:24 treogen [25330.655415]  [<ffffffff802433b4>]
warn_slowpath_fmt+0x64/0x70
May 24 15:50:24 treogen [25330.655425]  [<ffffffff8028ddda>] ?
mempool_free+0x8a/0xa0
May 24 15:50:24 treogen [25330.655432]  [<ffffffff8028dd42>] ?
mempool_free_slab+0x12/0x20
May 24 15:50:24 treogen [25330.655442]  [<ffffffff8068d74d>] ?
_spin_lock_irqsave+0x1d/0x40
May 24 15:50:24 treogen [25330.655449]  [<ffffffff8041755e>]
check_unmap+0x65e/0x6a0
May 24 15:50:24 treogen [25330.655457]  [<ffffffff804176ae>]
debug_dma_unmap_sg+0x10e/0x1b0
May 24 15:50:24 treogen [25330.655465]  [<ffffffff802c0de5>] ?
__slab_free+0x185/0x340
May 24 15:50:24 treogen [25330.655474]  [<ffffffff804bfe31>] ?
__scsi_put_command+0x61/0xa0
May 24 15:50:24 treogen [25330.655483]  [<ffffffff804d2f68>]
ata_sg_clean+0x78/0xf0
May 24 15:50:24 treogen [25330.655490]  [<ffffffff804d3015>]
__ata_qc_complete+0x35/0x110
May 24 15:50:24 treogen [25330.655499]  [<ffffffff804c6898>] ?
scsi_io_completion+0x398/0x530
May 24 15:50:24 treogen [25330.655506]  [<ffffffff804d31ad>]
ata_qc_complete+0xbd/0x250
May 24 15:50:24 treogen [25330.655513]  [<ffffffff804d36eb>]
ata_qc_complete_multiple+0xab/0xf0
May 24 15:50:24 treogen [25330.655522]  [<ffffffff804e8f99>]
sil24_interrupt+0xb9/0x5b0
May 24 15:50:24 treogen [25330.655529]  [<ffffffff8026147c>] ?
getnstimeofday+0x5c/0xf0
May 24 15:50:24 treogen [25330.655538]  [<ffffffff8025d309>] ?
ktime_get_ts+0x59/0x60
May 24 15:50:24 treogen [25330.655546]  [<ffffffff80273030>]
handle_IRQ_event+0x70/0x180
May 24 15:50:24 treogen [25330.655553]  [<ffffffff8027533d>]
handle_fasteoi_irq+0x6d/0xe0
May 24 15:50:24 treogen [25330.655561]  [<ffffffff8020e42f>]
handle_irq+0x1f/0x30
May 24 15:50:24 treogen [25330.655566]  [<ffffffff8020db7a>] do_IRQ+0x6a/0xf0
May 24 15:50:24 treogen [25330.655575]  [<ffffffff8020be53>]
ret_from_intr+0x0/0xf
May 24 15:50:24 treogen [25330.655579]  <EOI>  [<ffffffff80213657>] ?
default_idle+0x77/0xe0
May 24 15:50:24 treogen [25330.655592]  [<ffffffff80213655>] ?
default_idle+0x75/0xe0
May 24 15:50:24 treogen [25330.655600]  [<ffffffff8025e37f>] ?
notifier_call_chain+0x3f/0x80
May 24 15:50:24 treogen [25330.655607]  [<ffffffff802136f8>] ?
c1e_idle+0x38/0x110
May 24 15:50:24 treogen [25330.655614]  [<ffffffff8020a71e>] ?
cpu_idle+0x6e/0xd0
May 24 15:50:24 treogen [25330.655623]  [<ffffffff8067adbd>] ?
rest_init+0x6d/0x80
May 24 15:50:24 treogen [25330.655632]  [<ffffffff80929cc5>] ?
start_kernel+0x35a/0x422
May 24 15:50:24 treogen [25330.655639]  [<ffffffff80929289>] ?
x86_64_start_reservations+0x99/0xb9
May 24 15:50:24 treogen [25330.655646]  [<ffffffff80929389>] ?
x86_64_start_kernel+0xe0/0xf2
May 24 15:50:24 treogen [25330.655651] ---[ end trace 513a0b087125ae17 ]---
May 24 15:50:24 treogen [25330.655655] Mapped at:
May 24 15:50:24 treogen [25330.655658]  [<ffffffff80416d69>]
debug_dma_map_sg+0x159/0x180
May 24 15:50:24 treogen [25330.655666]  [<ffffffff804d34dc>]
ata_qc_issue+0x19c/0x300
May 24 15:50:24 treogen [25330.655674]  [<ffffffff804d93d8>]
ata_scsi_translate+0xa8/0x180
May 24 15:50:24 treogen [25330.655682]  [<ffffffff804dbf71>]
ata_scsi_queuecmd+0xb1/0x2d0
May 24 15:50:24 treogen [25330.655688]  [<ffffffff804bfc33>]
scsi_dispatch_cmd+0xe3/0x220

The system in an AMD x86_64 with 4GB of RAM, some of it remapped to
above the 32bit address limit.
lspci from the controller in question:
04:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial
ATA Raid II Controller (rev 01)
        Subsystem: ASUSTeK Computer Inc. Device 819f
        Flags: bus master, fast devsel, latency 0, IRQ 19
        Memory at efeffc00 (64-bit, non-prefetchable) [size=128]
        Memory at efef8000 (64-bit, non-prefetchable) [size=16K]
        I/O ports at ec00 [size=128]
        Expansion ROM at efe00000 [disabled] [size=512K]
        Capabilities: [54] Power Management version 2
        Capabilities: [5c] MSI: Mask- 64bit+ Count=1/1 Enable-
        Capabilities: [70] Express Legacy Endpoint, MSI 00
        Kernel driver in use: sata_sil24

Looking at the code in libata I can't see any problems with
qc->orig_n_elem, so I have no clue what goes wrong here.

If you need more information, please ask.

Torsten
