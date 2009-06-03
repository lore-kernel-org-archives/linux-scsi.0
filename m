From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: sata_sil24 0000:04:00.0: DMA-API: device driver frees DMA sg list
	with different entry count [map count=13] [unmap count=10]
Date: Wed, 3 Jun 2009 21:30:32 +0200
Message-ID: <64bb37e0906031230m22234268k9fdcd43dc1d35f18@mail.gmail.com>
References: <64bb37e0905261214g2957924ar837339367f320d4c@mail.gmail.com>
	 <4A1C7DDB.9010605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58417 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbZFCT7C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 15:59:02 -0400
In-Reply-To: <4A1C7DDB.9010605@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, May 27, 2009 at 1:40 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> Torsten Kaiser wrote:
>>
>> On upgrading to 2.6.30-rc1 I enable the DMA-Debugging option
>> CONFIG_DMA_API_DEBUG=y
>> Since then I get the following or similar errors on each boot:
>
> Please retest with a newer -rc, this patch likely fixes it:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5825627c9463581fd9e70f8285685889ae5bb9bb
>

Still happens with 2.6.30-rc8 (see trace at the end of the email)

As orig_n_elem is only used two times in libata-core.c I suspected a
corruption of the qc->sg, but adding checks for this did not trigger.
So I looked into lib/dma-debug.c.
It seems add_dma_entry() does not protect against adding the same
entry twice. That could explain these warnings, if the hash_bucket
returns a different entry that then has the wrong map/unmap count.

So I added WARN_ON(hash_bucket_find(bucket, entry)); before the
hash_bucket_add(bucket, entry); in add_dma_entry();

That WARN_ON() triggered more then 1500 times until the KDE desktop
was loaded...

This is the first full stackdump, I dont have the real first one,
because the dmesg buffer overflowed.
Jun  3 21:14:07 treogen [   30.094954] ------------[ cut here ]------------
Jun  3 21:14:07 treogen [   30.094960] WARNING: at lib/dma-debug.c:256
add_dma_entry+0x7b/0xb0()
Jun  3 21:14:07 treogen [   30.094964] Hardware name: KFN5-D SLI
Jun  3 21:14:07 treogen [   30.094966] Modules linked in: msp3400
tuner tea5767 tda8290 tuner_xc2028 xc
5000 tda9887 tuner_simple tuner_types mt20xx tea5761 bttv ir_common
v4l2_common videodev v4l1_compat v4
l2_compat_ioctl32 videobuf_dma_sg videobuf_core sg btcx_risc pata_amd tveeprom
Jun  3 21:14:07 treogen [   30.094996] Pid: 1156, comm: md3_raid1
Tainted: G        W  2.6.30-rc8 #3
Jun  3 21:14:07 treogen [   30.094999] Call Trace:
Jun  3 21:14:07 treogen [   30.095005]  [<ffffffff8041667b>] ?
add_dma_entry+0x7b/0xb0
Jun  3 21:14:07 treogen [   30.095012]  [<ffffffff802432e8>]
warn_slowpath_common+0x78/0xd0
Jun  3 21:14:07 treogen [   30.095018]  [<ffffffff8024334f>]
warn_slowpath_null+0xf/0x20
Jun  3 21:14:07 treogen [   30.095025]  [<ffffffff8041667b>]
add_dma_entry+0x7b/0xb0
Jun  3 21:14:07 treogen [   30.095031]  [<ffffffff80416db4>]
debug_dma_map_sg+0x144/0x180
Jun  3 21:14:07 treogen [   30.095038]  [<ffffffff804d367c>]
ata_qc_issue+0x19c/0x310
Jun  3 21:14:07 treogen [   30.095044]  [<ffffffff804bfca0>] ?
scsi_done+0x0/0x20
Jun  3 21:14:07 treogen [   30.095051]  [<ffffffff804d92a0>] ?
ata_scsi_rw_xlat+0x0/0x210
Jun  3 21:14:07 treogen [   30.095058]  [<ffffffff804d9558>]
ata_scsi_translate+0xa8/0x180
Jun  3 21:14:07 treogen [   30.095065]  [<ffffffff804bfca0>] ?
scsi_done+0x0/0x20
Jun  3 21:14:07 treogen [   30.095070]  [<ffffffff804dc0f1>]
ata_scsi_queuecmd+0xb1/0x2d0
Jun  3 21:14:07 treogen [   30.095077]  [<ffffffff804bfda3>]
scsi_dispatch_cmd+0xe3/0x220
Jun  3 21:14:07 treogen [   30.095084]  [<ffffffff804c5a0e>]
scsi_request_fn+0x38e/0x480
Jun  3 21:14:07 treogen [   30.095091]  [<ffffffff803f0ae3>]
__generic_unplug_device+0x33/0x40
Jun  3 21:14:07 treogen [   30.095098]  [<ffffffff803f0c09>]
generic_unplug_device+0x29/0x40
Jun  3 21:14:07 treogen [   30.095105]  [<ffffffff803ef92e>]
blk_unplug+0x4e/0x60
Jun  3 21:14:07 treogen [   30.095111]  [<ffffffff80566c7b>]
unplug_slaves+0x9b/0xe0
Jun  3 21:14:07 treogen [   30.095118]  [<ffffffff80569418>] raid1d+0xd68/0x1070
Jun  3 21:14:07 treogen [   30.095124]  [<ffffffff8024dcea>] ?
try_to_del_timer_sync+0x5a/0x70
Jun  3 21:14:07 treogen [   30.095130]  [<ffffffff8024dd1a>] ?
del_timer_sync+0x1a/0x30
Jun  3 21:14:07 treogen [   30.095138]  [<ffffffff805708d4>]
md_thread+0x54/0x140
Jun  3 21:14:07 treogen [   30.095144]  [<ffffffff80259cf0>] ?
autoremove_wake_function+0x0/0x40
Jun  3 21:14:07 treogen [   30.095151]  [<ffffffff80570880>] ?
md_thread+0x0/0x140
Jun  3 21:14:07 treogen [   30.095158]  [<ffffffff80570880>] ?
md_thread+0x0/0x140
Jun  3 21:14:07 treogen [   30.095164]  [<ffffffff80259856>] kthread+0x56/0x90
Jun  3 21:14:07 treogen [   30.095171]  [<ffffffff8020c4aa>] child_rip+0xa/0x20
Jun  3 21:14:07 treogen [   30.095178]  [<ffffffff8020bea9>] ?
restore_args+0x0/0x30
Jun  3 21:14:07 treogen [   30.095184]  [<ffffffff80259800>] ? kthread+0x0/0x90
Jun  3 21:14:07 treogen [   30.095190]  [<ffffffff8020c4a0>] ?
child_rip+0x0/0x20
Jun  3 21:14:07 treogen [   30.095194] ---[ end trace f87165562db78e9a ]---

Is this a bug in the DMA-API debuging or in libata / sata_sil24?

Torsten


DMA-API-Warning from vanilla 2.6.30-rc8:
Jun  3 18:52:31 treogen [  486.447661] ------------[ cut here ]------------
Jun  3 18:52:31 treogen [  486.447684] WARNING: at lib/dma-debug.c:530
check_unmap+0x65e/0x6a0()
Jun  3 18:52:31 treogen [  486.447689] Hardware name: KFN5-D SLI
Jun  3 18:52:31 treogen [  486.447694] sata_sil24 0000:04:00.0:
DMA-API: device driver frees DMA sg lis
t with different entry count [map count=1] [unmap count=2]
Jun  3 18:52:31 treogen [  486.447699] Modules linked in: msp3400
tuner tea5767 tda8290 tuner_xc2028 xc
5000 tda9887 tuner_simple tuner_types mt20xx tea5761 bttv ir_common
v4l2_common videodev v4l1_compat v4
l2_compat_ioctl32 videobuf_dma_sg videobuf_core pata_amd sg btcx_risc tveeprom
Jun  3 18:52:31 treogen [  486.447740] Pid: 3328, comm: nxproxy Not
tainted 2.6.30-rc8 #1
Jun  3 18:52:31 treogen [  486.447744] Call Trace:
Jun  3 18:52:31 treogen [  486.447748]  <IRQ>  [<ffffffff8041758e>] ?
check_unmap+0x65e/0x6a0
Jun  3 18:52:31 treogen [  486.447766]  [<ffffffff802432e8>]
warn_slowpath_common+0x78/0xd0
Jun  3 18:52:31 treogen [  486.447773]  [<ffffffff802433c4>]
warn_slowpath_fmt+0x64/0x70
Jun  3 18:52:31 treogen [  486.447783]  [<ffffffff804d3665>] ?
ata_qc_issue+0x1e5/0x300
Jun  3 18:52:31 treogen [  486.447791]  [<ffffffff804bfc70>] ?
scsi_done+0x0/0x20
Jun  3 18:52:31 treogen [  486.447799]  [<ffffffff804d9260>] ?
ata_scsi_rw_xlat+0x0/0x210
Jun  3 18:52:31 treogen [  486.447807]  [<ffffffff804d9518>] ?
ata_scsi_translate+0xa8/0x180
Jun  3 18:52:31 treogen [  486.447817]  [<ffffffff8068d33d>] ?
_spin_lock_irqsave+0x1d/0x40
Jun  3 18:52:31 treogen [  486.447824]  [<ffffffff8041758e>]
check_unmap+0x65e/0x6a0
Jun  3 18:52:31 treogen [  486.447831]  [<ffffffff804176de>]
debug_dma_unmap_sg+0x10e/0x1b0
Jun  3 18:52:31 treogen [  486.447838]  [<ffffffff804bff71>] ?
__scsi_put_command+0x61/0xa0
Jun  3 18:52:31 treogen [  486.447845]  [<ffffffff804d30a8>]
ata_sg_clean+0x78/0xf0
Jun  3 18:52:31 treogen [  486.447852]  [<ffffffff804d3155>]
__ata_qc_complete+0x35/0x110
Jun  3 18:52:31 treogen [  486.447862]  [<ffffffff804c69d8>] ?
scsi_io_completion+0x398/0x530
Jun  3 18:52:31 treogen [  486.447869]  [<ffffffff804d32ed>]
ata_qc_complete+0xbd/0x250
Jun  3 18:52:31 treogen [  486.447876]  [<ffffffff804d382b>]
ata_qc_complete_multiple+0xab/0xf0
Jun  3 18:52:31 treogen [  486.447885]  [<ffffffff804e90d9>]
sil24_interrupt+0xb9/0x5b0
Jun  3 18:52:31 treogen [  486.447894]  [<ffffffff80273060>]
handle_IRQ_event+0x70/0x180
Jun  3 18:52:31 treogen [  486.447902]  [<ffffffff8027536d>]
handle_fasteoi_irq+0x6d/0xe0
Jun  3 18:52:31 treogen [  486.447909]  [<ffffffff8020e42f>]
handle_irq+0x1f/0x30
Jun  3 18:52:31 treogen [  486.447915]  [<ffffffff8020db7a>] do_IRQ+0x6a/0xf0
Jun  3 18:52:31 treogen [  486.447924]  [<ffffffff8020be53>]
ret_from_intr+0x0/0xf
Jun  3 18:52:31 treogen [  486.447927]  <EOI>  [<ffffffff802c967a>] ?
file_move+0x3a/0x60
Jun  3 18:52:31 treogen [  486.447939]  [<ffffffff802c9668>] ?
file_move+0x28/0x60
Jun  3 18:52:31 treogen [  486.447949]  [<ffffffff802c682f>] ?
__dentry_open+0xbf/0x2e0
Jun  3 18:52:31 treogen [  486.447957]  [<ffffffff802c6b57>] ?
nameidata_to_filp+0x57/0x70
Jun  3 18:52:31 treogen [  486.447963]  [<ffffffff802d51f2>] ?
do_filp_open+0x292/0x990
Jun  3 18:52:31 treogen [  486.447972]  [<ffffffff8064915d>] ?
unix_ioctl+0xad/0xf0
Jun  3 18:52:31 treogen [  486.447979]  [<ffffffff802bde9c>] ?
get_partial_node+0x2c/0xa0
Jun  3 18:52:31 treogen [  486.447986]  [<ffffffff802c1705>] ?
__slab_alloc+0x95/0x480
Jun  3 18:52:31 treogen [  486.447992]  [<ffffffff802d6b91>] ?
vfs_ioctl+0x31/0xa0
Jun  3 18:52:31 treogen [  486.447999]  [<ffffffff8068a817>] ?
thread_return+0x3e/0x6f7
Jun  3 18:52:31 treogen [  486.448007]  [<ffffffff802d25d6>] ?
getname+0x36/0x200
Jun  3 18:52:31 treogen [  486.448015]  [<ffffffff802df56a>] ?
alloc_fd+0x4a/0x140
Jun  3 18:52:31 treogen [  486.448023]  [<ffffffff802c668b>] ?
do_sys_open+0x7b/0x110
Jun  3 18:52:31 treogen [  486.448030]  [<ffffffff802c674b>] ?
sys_open+0x1b/0x20
Jun  3 18:52:31 treogen [  486.448037]  [<ffffffff8020b4eb>] ?
system_call_fastpath+0x16/0x1b
Jun  3 18:52:31 treogen [  486.448042] ---[ end trace 9e90cc92d8410ab6 ]---
Jun  3 18:52:31 treogen [  486.448045] Mapped at:
Jun  3 18:52:31 treogen [  486.448048]  [<ffffffffffffffff>] 0xffffffffffffffff
