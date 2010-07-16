From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
Subject: Re: mvsas still has problems with 2.6.34
Date: Fri, 16 Jul 2010 01:23:27 -0600
Message-ID: <201007160123.27540.tfjellstrom@strangesoft.net>
References: <201007160010.58000.tfjellstrom@strangesoft.net> <201007160053.01673.tfjellstrom@strangesoft.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from troy.hostgo.com ([64.62.143.130]:51738 "EHLO troy.hostgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935713Ab0GPHXb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jul 2010 03:23:31 -0400
In-Reply-To: <201007160053.01673.tfjellstrom@strangesoft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, ayan@marvell.com, andy yan <andyysj@gmail.com>, linux-raid <linux-raid@vger.kernel.org>

On July 16, 2010, Thomas Fjellstrom wrote:
> On July 16, 2010, Thomas Fjellstrom wrote:
> > I've recently updated my server, and the mvsas driver included in
> > 2.6.34.1 still causes my AOC-SASLP-MV8 card to completely lock up after
> > mdraid starts up on the devices. The machine is essentially in
> > "production" so I can't do a heck of a lot of testing on it anymore.
> > The mvsas driver I got from Andy Yan seems to be a little outdated, it
> > fails to compile due to a missing argument to sas_change_queue_depth,
> > which I managed to fix, and I will try testing. I hope it works.
> 
> It seems to work with the change I made.

Sorry for the noise, I forgot to post the following in my last couple messages:

It works, but I do get a kernel warning:

Jul 16 00:38:05 boris kernel: [   20.104295] ------------[ cut here ]------------
Jul 16 00:38:05 boris kernel: [   20.104315] WARNING: at drivers/ata/libata-core.c:5216 ata_qc_issue+0x31b/0x330 [libata]()
Jul 16 00:38:05 boris kernel: [   20.104323] Hardware name: GA-MA790FXT-UD5P
Jul 16 00:38:05 boris kernel: [   20.104327] Modules linked in: snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss nouveau ttm snd_pcm drm_kms_helper snd_seq_midi k10temp drm agpgart i2c_algo_bit snd_rawmidi snd_seq_midi_event i2c_piix4 i2c_core evdev edac_core edac_mce_amd tpm_tis snd_seq pcspkr tpm button tpm_bios wmi snd_timer snd_seq_device processor snd soundcore snd_page_alloc ext3 jbd mbcache dm_mod raid1 md_mod sg sr_mod sd_mod crc_t10dif cdrom ata_generic ohci_hcd ide_pci_generic ahci mvsas libsas libata atiixp scsi_transport_sas firewire_ohci firewire_core crc_itu_t thermal skge thermal_sys ide_core ehci_hcd r8169 mii usbcore scsi_mod nls_base [last unloaded: scsi_wait_scan]
Jul 16 00:38:05 boris kernel: [   20.104448] Pid: 6091, comm: ata_id Not tainted 2.6.34.1 #2
Jul 16 00:38:05 boris kernel: [   20.104453] Call Trace:
Jul 16 00:38:05 boris kernel: [   20.104462]  [<ffffffff81049bb3>] ? warn_slowpath_common+0x73/0xb0
Jul 16 00:38:05 boris kernel: [   20.104472]  [<ffffffffa011686b>] ? ata_qc_issue+0x31b/0x330 [libata]
Jul 16 00:38:05 boris kernel: [   20.104482]  [<ffffffffa000ef7f>] ? scsi_init_io+0x2f/0x190 [scsi_mod]
Jul 16 00:38:05 boris kernel: [   20.104492]  [<ffffffffa011e020>] ? ata_scsi_pass_thru+0x0/0x2e0 [libata]
Jul 16 00:38:05 boris kernel: [   20.104500]  [<ffffffffa0007990>] ? scsi_done+0x0/0x20 [scsi_mod]
Jul 16 00:38:05 boris kernel: [   20.104509]  [<ffffffffa011bfae>] ? ata_scsi_translate+0x9e/0x180 [libata]
Jul 16 00:38:05 boris kernel: [   20.104517]  [<ffffffffa0007990>] ? scsi_done+0x0/0x20 [scsi_mod]
Jul 16 00:38:05 boris kernel: [   20.104525]  [<ffffffffa015522b>] ? sas_queuecommand+0x9b/0x330 [libsas]
Jul 16 00:38:05 boris kernel: [   20.104533]  [<ffffffffa0007c7e>] ? scsi_dispatch_cmd+0x17e/0x2b0 [scsi_mod]
Jul 16 00:38:05 boris kernel: [   20.104542]  [<ffffffffa000e830>] ? scsi_request_fn+0x3e0/0x570 [scsi_mod]
Jul 16 00:38:05 boris kernel: [   20.104549]  [<ffffffff81058161>] ? del_timer+0x71/0xd0
Jul 16 00:38:05 boris kernel: [   20.104556]  [<ffffffff811baed3>] ? __blk_run_queue+0x63/0x130
Jul 16 00:38:05 boris kernel: [   20.104563]  [<ffffffff811b43a2>] ? elv_insert+0x132/0x1f0
Jul 16 00:38:05 boris kernel: [   20.104570]  [<ffffffff811bf1c9>] ? blk_execute_rq_nowait+0x59/0xb0
Jul 16 00:38:05 boris kernel: [   20.104576]  [<ffffffff811bf292>] ? blk_execute_rq+0x72/0xe0
Jul 16 00:38:05 boris kernel: [   20.104582]  [<ffffffff811bf05b>] ? blk_rq_map_user+0x1ab/0x290
Jul 16 00:38:05 boris kernel: [   20.104588]  [<ffffffff811c32f1>] ? sg_io+0x241/0x3f0
Jul 16 00:38:05 boris kernel: [   20.104594]  [<ffffffff811c38fc>] ? scsi_cmd_ioctl+0x45c/0x4b0
Jul 16 00:38:05 boris kernel: [   20.104601]  [<ffffffff8110e02f>] ? __dentry_open+0x22f/0x340
Jul 16 00:38:05 boris kernel: [   20.104607]  [<ffffffff811195b3>] ? inode_permission+0x93/0xd0
Jul 16 00:38:05 boris kernel: [   20.104614]  [<ffffffffa013cdc4>] ? sd_ioctl+0xa4/0x120 [sd_mod]
Jul 16 00:38:05 boris kernel: [   20.105009]  [<ffffffff811c0798>] ? __blkdev_driver_ioctl+0x98/0xe0
Jul 16 00:38:05 boris kernel: [   20.105410]  [<ffffffff811c0c75>] ? blkdev_ioctl+0x1f5/0x7b0
Jul 16 00:38:05 boris kernel: [   20.105815]  [<ffffffff81113d30>] ? cp_new_stat+0xe0/0x100
Jul 16 00:38:05 boris kernel: [   20.106230]  [<ffffffff8113b4f7>] ? block_ioctl+0x37/0x40
Jul 16 00:38:05 boris kernel: [   20.106647]  [<ffffffff8111e985>] ? vfs_ioctl+0x35/0xd0
Jul 16 00:38:05 boris kernel: [   20.107064]  [<ffffffff8111ef08>] ? do_vfs_ioctl+0x88/0x560
Jul 16 00:38:05 boris kernel: [   20.107490]  [<ffffffff8111402e>] ? sys_newfstat+0x2e/0x50
Jul 16 00:38:05 boris kernel: [   20.107919]  [<ffffffff8111f460>] ? sys_ioctl+0x80/0xa0
Jul 16 00:38:05 boris kernel: [   20.108003]  [<ffffffff81002e2b>] ? system_call_fastpath+0x16/0x1b
Jul 16 00:38:05 boris kernel: [   20.108003] ---[ end trace e8ea9c22d6b28439 ]---

Other than this stack trace, it seems to work fine.

> > At some point though I really hope this gets fixed. I'm still willing
> > to help test any new versions, just that I can't keep my box down for
> > an extended period.
> > 
> > Thanks.

I forgot to post, but here are the kernel messages I get when trying to use the kernel's included mvsas driver:

Jul 15 22:42:41 boris kernel: [  208.816129] sd 0:0:3:0: [sdf] Unhandled error code
Jul 15 22:42:41 boris kernel: [  208.816809] sd 0:0:3:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul 15 22:42:41 boris kernel: [  208.817470] sd 0:0:3:0: [sdf] CDB: Read(10): 28 00 3a 45 c1 08 00 04 00 00
Jul 15 22:42:41 boris kernel: [  208.818853] sd 0:0:1:0: [sdd] Unhandled error code
Jul 15 22:42:41 boris kernel: [  208.819508] sd 0:0:1:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul 15 22:42:41 boris kernel: [  208.820179] sd 0:0:1:0: [sdd] CDB: Read(10): 28 00 3a 45 be 58 00 02 b0 00
Jul 15 22:42:41 boris kernel: [  208.821558] sd 0:0:2:0: [sde] Unhandled error code
Jul 15 22:42:41 boris kernel: [  208.822201] sd 0:0:2:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul 15 22:42:41 boris kernel: [  208.822836] sd 0:0:2:0: [sde] CDB: Read(10): 28 00 3a 45 c1 08 00 04 00 00
Jul 15 22:42:41 boris kernel: [  208.824157] sd 0:0:4:0: [sdg] Unhandled error code
Jul 15 22:42:41 boris kernel: [  208.824784] sd 0:0:4:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul 15 22:42:41 boris kernel: [  208.825407] sd 0:0:4:0: [sdg] CDB: Read(10): 28 00 3a 45 c1 08 00 04 00 00
Jul 15 22:43:13 boris kernel: [  240.737334] md1_raid5     D 0000000000000001     0  6120      2 0x00000000
Jul 15 22:43:13 boris kernel: [  240.737948]  ffff88012c94c420 0000000000000046 ffff880100000000 ffff88012f65b680
Jul 15 22:43:13 boris kernel: [  240.738570]  00000000000134c0 ffff88012e6effd8 00000000000134c0 ffff88012c94c420
Jul 15 22:43:13 boris kernel: [  240.739196]  ffff88012e6effd8 ffff88012e6effd8 00000000000134c0 00000000000134c0
Jul 15 22:43:13 boris kernel: [  240.739821] Call Trace:
Jul 15 22:43:13 boris kernel: [  240.740458]  [<ffffffffa018d17e>] ? md_super_wait+0xae/0xd0 [md_mod]
Jul 15 22:43:13 boris kernel: [  240.741100]  [<ffffffff810671b0>] ? autoremove_wake_function+0x0/0x30
Jul 15 22:43:13 boris kernel: [  240.741729]  [<ffffffffa018d748>] ? md_update_sb+0x268/0x3d0 [md_mod]
Jul 15 22:43:13 boris kernel: [  240.742361]  [<ffffffffa018fcd2>] ? md_check_recovery+0x232/0x520 [md_mod]
Jul 15 22:43:13 boris kernel: [  240.742982]  [<ffffffffa0421833>] ? raid5d+0x23/0x4f0 [raid456]
Jul 15 22:43:13 boris kernel: [  240.743602]  [<ffffffff8137883d>] ? schedule_timeout+0x23d/0x310
Jul 15 22:43:13 boris kernel: [  240.744221]  [<ffffffff8103aee4>] ? finish_task_switch+0x34/0xb0
Jul 15 22:43:13 boris kernel: [  240.744861]  [<ffffffffa018ce43>] ? md_thread+0x53/0x120 [md_mod]
Jul 15 22:43:13 boris kernel: [  240.745489]  [<ffffffff810671b0>] ? autoremove_wake_function+0x0/0x30
Jul 15 22:43:13 boris kernel: [  240.746121]  [<ffffffffa018cdf0>] ? md_thread+0x0/0x120 [md_mod]
Jul 15 22:43:13 boris kernel: [  240.746743]  [<ffffffff81066c9e>] ? kthread+0x8e/0xa0
Jul 15 22:43:13 boris kernel: [  240.747367]  [<ffffffff81003bd4>] ? kernel_thread_helper+0x4/0x10
Jul 15 22:43:13 boris kernel: [  240.748000]  [<ffffffff81066c10>] ? kthread+0x0/0xa0
Jul 15 22:43:13 boris kernel: [  240.748639]  [<ffffffff81003bd0>] ? kernel_thread_helper+0x0/0x10
Jul 15 22:43:13 boris kernel: [  240.750521] mount         D 0000000000000001     0  6405   6403 0x00000000
Jul 15 22:43:13 boris kernel: [  240.751158]  ffff88012eb8f3d0 0000000000000082 ffff88012e50c600 ffff88012f65d1c0
Jul 15 22:43:13 boris kernel: [  240.751805]  00000000000134c0 ffff88012dc0bfd8 00000000000134c0 ffff88012eb8f3d0
Jul 15 22:43:13 boris kernel: [  240.752452]  ffff88012dc0bfd8 ffff88012dc0bfd8 00000000000134c0 00000000000134c0
Jul 15 22:43:13 boris kernel: [  240.753108] Call Trace:
Jul 15 22:43:13 boris kernel: [  240.753761]  [<ffffffffa0020990>] ? scsi_done+0x0/0x20 [scsi_mod]
Jul 15 22:43:13 boris kernel: [  240.754409]  [<ffffffff8137883d>] ? schedule_timeout+0x23d/0x310
Jul 15 22:43:13 boris kernel: [  240.755053]  [<ffffffff811ba097>] ? blk_peek_request+0x127/0x1e0
Jul 15 22:43:13 boris kernel: [  240.755708]  [<ffffffffa0020c8d>] ? scsi_dispatch_cmd+0x18d/0x2b0 [scsi_mod]
Jul 15 22:43:13 boris kernel: [  240.756358]  [<ffffffff81377af2>] ? wait_for_common+0xd2/0x180
Jul 15 22:43:13 boris kernel: [  240.757023]  [<ffffffff8103da50>] ? default_wake_function+0x0/0x20
Jul 15 22:43:13 boris kernel: [  240.757672]  [<ffffffffa041f486>] ? unplug_slaves+0x86/0xc0 [raid456]
Jul 15 22:43:13 boris kernel: [  240.758363]  [<ffffffffa048ed8d>] ? xlog_bread_noalign+0xbd/0xf0 [xfs]
Jul 15 22:43:13 boris kernel: [  240.759046]  [<ffffffffa04a38c0>] ? xfs_buf_iowait+0x40/0xf0 [xfs]
Jul 15 22:43:13 boris kernel: [  240.759730]  [<ffffffffa048ed8d>] ? xlog_bread_noalign+0xbd/0xf0 [xfs]
Jul 15 22:43:13 boris kernel: [  240.760423]  [<ffffffffa048edf5>] ? xlog_bread+0x35/0x80 [xfs]
Jul 15 22:43:13 boris kernel: [  240.761124]  [<ffffffffa0491b9f>] ? xlog_find_verify_cycle+0xbf/0x170 [xfs]
Jul 15 22:43:13 boris kernel: [  240.761813]  [<ffffffffa0492558>] ? xlog_find_head+0x168/0x3a0 [xfs]
Jul 15 22:43:13 boris kernel: [  240.762495]  [<ffffffffa04927b7>] ? xlog_find_tail+0x27/0x3d0 [xfs]
Jul 15 22:43:13 boris kernel: [  240.763178]  [<ffffffffa0492b75>] ? xlog_recover+0x15/0x90 [xfs]
Jul 15 22:43:13 boris kernel: [  240.763858]  [<ffffffffa048b9c4>] ? xfs_log_mount+0x134/0x170 [xfs]
Jul 15 22:43:13 boris kernel: [  240.764528]  [<ffffffffa0495b8f>] ? xfs_mountfs+0x38f/0x720 [xfs]
Jul 15 22:43:13 boris kernel: [  240.765214]  [<ffffffffa04a090b>] ? kmem_alloc+0x7b/0xc0 [xfs]
Jul 15 22:43:13 boris kernel: [  240.765888]  [<ffffffffa04a09fb>] ? kmem_zalloc+0x2b/0x40 [xfs]
Jul 15 22:43:13 boris kernel: [  240.766559]  [<ffffffffa04ad985>] ? xfs_fs_fill_super+0x225/0x3b0 [xfs]
Jul 15 22:43:13 boris kernel: [  240.767203]  [<ffffffff81112c03>] ? get_sb_bdev+0x1a3/0x1e0
Jul 15 22:43:13 boris kernel: [  240.767877]  [<ffffffffa04ad760>] ? xfs_fs_fill_super+0x0/0x3b0 [xfs]
Jul 15 22:43:13 boris kernel: [  240.768533]  [<ffffffff81112633>] ? vfs_kern_mount+0x83/0x1f0
Jul 15 22:43:13 boris kernel: [  240.769174]  [<ffffffff81112813>] ? do_kern_mount+0x53/0x120
Jul 15 22:43:13 boris kernel: [  240.769806]  [<ffffffff8112abfa>] ? do_mount+0x28a/0x8a0
Jul 15 22:43:13 boris kernel: [  240.770441]  [<ffffffff81128960>] ? copy_mount_options+0xe0/0x180
Jul 15 22:43:13 boris kernel: [  240.771073]  [<ffffffff8112b2aa>] ? sys_mount+0x9a/0xf0
Jul 15 22:43:13 boris kernel: [  240.771695]  [<ffffffff81002e2b>] ? system_call_fastpath+0x16/0x1b
Jul 15 22:45:13 boris kernel: [  360.769363] md1_raid5     D 0000000000000001     0  6120      2 0x00000000
Jul 15 22:45:13 boris kernel: [  360.770006]  ffff88012c94c420 0000000000000046 ffff880100000000 ffff88012f65b680
Jul 15 22:45:13 boris kernel: [  360.770648]  00000000000134c0 ffff88012e6effd8 00000000000134c0 ffff88012c94c420
Jul 15 22:45:13 boris kernel: [  360.771298]  ffff88012e6effd8 ffff88012e6effd8 00000000000134c0 00000000000134c0
Jul 15 22:45:13 boris kernel: [  360.771946] Call Trace:
Jul 15 22:45:13 boris kernel: [  360.772620]  [<ffffffffa018d17e>] ? md_super_wait+0xae/0xd0 [md_mod]
Jul 15 22:45:13 boris kernel: [  360.773265]  [<ffffffff810671b0>] ? autoremove_wake_function+0x0/0x30
Jul 15 22:45:13 boris kernel: [  360.773911]  [<ffffffffa018d748>] ? md_update_sb+0x268/0x3d0 [md_mod]
Jul 15 22:45:13 boris kernel: [  360.774550]  [<ffffffffa018fcd2>] ? md_check_recovery+0x232/0x520 [md_mod]
Jul 15 22:45:13 boris kernel: [  360.775180]  [<ffffffffa0421833>] ? raid5d+0x23/0x4f0 [raid456]
Jul 15 22:45:13 boris kernel: [  360.775804]  [<ffffffff8137883d>] ? schedule_timeout+0x23d/0x310
Jul 15 22:45:13 boris kernel: [  360.776424]  [<ffffffff8103aee4>] ? finish_task_switch+0x34/0xb0
Jul 15 22:45:13 boris kernel: [  360.777064]  [<ffffffffa018ce43>] ? md_thread+0x53/0x120 [md_mod]
Jul 15 22:45:13 boris kernel: [  360.777679]  [<ffffffff810671b0>] ? autoremove_wake_function+0x0/0x30
Jul 15 22:45:13 boris kernel: [  360.778302]  [<ffffffffa018cdf0>] ? md_thread+0x0/0x120 [md_mod]
Jul 15 22:45:13 boris kernel: [  360.778919]  [<ffffffff81066c9e>] ? kthread+0x8e/0xa0
Jul 15 22:45:13 boris kernel: [  360.779534]  [<ffffffff81003bd4>] ? kernel_thread_helper+0x4/0x10
Jul 15 22:45:13 boris kernel: [  360.780148]  [<ffffffff81066c10>] ? kthread+0x0/0xa0
Jul 15 22:45:13 boris kernel: [  360.780776]  [<ffffffff81003bd0>] ? kernel_thread_helper+0x0/0x10
Jul 15 22:45:13 boris kernel: [  360.782623] mount         D 0000000000000001     0  6405   6403 0x00000000
Jul 15 22:45:13 boris kernel: [  360.783248]  ffff88012eb8f3d0 0000000000000082 ffff88012e50c600 ffff88012f65d1c0
Jul 15 22:45:13 boris kernel: [  360.783883]  00000000000134c0 ffff88012dc0bfd8 00000000000134c0 ffff88012eb8f3d0
Jul 15 22:45:13 boris kernel: [  360.784536]  ffff88012dc0bfd8 ffff88012dc0bfd8 00000000000134c0 00000000000134c0
Jul 15 22:45:13 boris kernel: [  360.785184] Call Trace:
Jul 15 22:45:13 boris kernel: [  360.785829]  [<ffffffffa0020990>] ? scsi_done+0x0/0x20 [scsi_mod]
Jul 15 22:45:13 boris kernel: [  360.786465]  [<ffffffff8137883d>] ? schedule_timeout+0x23d/0x310
Jul 15 22:45:13 boris kernel: [  360.787098]  [<ffffffff811ba097>] ? blk_peek_request+0x127/0x1e0
Jul 15 22:45:13 boris kernel: [  360.787740]  [<ffffffffa0020c8d>] ? scsi_dispatch_cmd+0x18d/0x2b0 [scsi_mod]
Jul 15 22:45:13 boris kernel: [  360.788361]  [<ffffffff81377af2>] ? wait_for_common+0xd2/0x180
Jul 15 22:45:13 boris kernel: [  360.788988]  [<ffffffff8103da50>] ? default_wake_function+0x0/0x20
Jul 15 22:45:13 boris kernel: [  360.789612]  [<ffffffffa041f486>] ? unplug_slaves+0x86/0xc0 [raid456]
Jul 15 22:45:13 boris kernel: [  360.790277]  [<ffffffffa048ed8d>] ? xlog_bread_noalign+0xbd/0xf0 [xfs]
Jul 15 22:45:13 boris kernel: [  360.790933]  [<ffffffffa04a38c0>] ? xfs_buf_iowait+0x40/0xf0 [xfs]
Jul 15 22:45:13 boris kernel: [  360.791597]  [<ffffffffa048ed8d>] ? xlog_bread_noalign+0xbd/0xf0 [xfs]
Jul 15 22:45:13 boris kernel: [  360.792258]  [<ffffffffa048edf5>] ? xlog_bread+0x35/0x80 [xfs]
Jul 15 22:45:13 boris kernel: [  360.792935]  [<ffffffffa0491b9f>] ? xlog_find_verify_cycle+0xbf/0x170 [xfs]
Jul 15 22:45:13 boris kernel: [  360.793598]  [<ffffffffa0492558>] ? xlog_find_head+0x168/0x3a0 [xfs]
Jul 15 22:45:13 boris kernel: [  360.794258]  [<ffffffffa04927b7>] ? xlog_find_tail+0x27/0x3d0 [xfs]
Jul 15 22:45:13 boris kernel: [  360.794910]  [<ffffffffa0492b75>] ? xlog_recover+0x15/0x90 [xfs]
Jul 15 22:45:13 boris kernel: [  360.795565]  [<ffffffffa048b9c4>] ? xfs_log_mount+0x134/0x170 [xfs]
Jul 15 22:45:13 boris kernel: [  360.796216]  [<ffffffffa0495b8f>] ? xfs_mountfs+0x38f/0x720 [xfs]
Jul 15 22:45:13 boris kernel: [  360.796879]  [<ffffffffa04a090b>] ? kmem_alloc+0x7b/0xc0 [xfs]
Jul 15 22:45:13 boris kernel: [  360.797527]  [<ffffffffa04a09fb>] ? kmem_zalloc+0x2b/0x40 [xfs]
Jul 15 22:45:13 boris kernel: [  360.798171]  [<ffffffffa04ad985>] ? xfs_fs_fill_super+0x225/0x3b0 [xfs]
Jul 15 22:45:13 boris kernel: [  360.798785]  [<ffffffff81112c03>] ? get_sb_bdev+0x1a3/0x1e0
Jul 15 22:45:13 boris kernel: [  360.799429]  [<ffffffffa04ad760>] ? xfs_fs_fill_super+0x0/0x3b0 [xfs]
Jul 15 22:45:13 boris kernel: [  360.800046]  [<ffffffff81112633>] ? vfs_kern_mount+0x83/0x1f0
Jul 15 22:45:13 boris kernel: [  360.800678]  [<ffffffff81112813>] ? do_kern_mount+0x53/0x120
Jul 15 22:45:13 boris kernel: [  360.801292]  [<ffffffff8112abfa>] ? do_mount+0x28a/0x8a0
Jul 15 22:45:13 boris kernel: [  360.801910]  [<ffffffff81128960>] ? copy_mount_options+0xe0/0x180
Jul 15 22:45:13 boris kernel: [  360.802531]  [<ffffffff8112b2aa>] ? sys_mount+0x9a/0xf0
Jul 15 22:45:13 boris kernel: [  360.803152]  [<ffffffff81002e2b>] ? system_call_fastpath+0x16/0x1b

I'm pretty sure most of that is due to the driver not responding for 4 of the drives (the first few messages)

Thanks again.

-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net
