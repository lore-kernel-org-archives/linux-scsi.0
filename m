From: Hans de Goede <hdegoede@redhat.com>
Subject: uas: kernel BUG at block/blk-tag.c:89 is back again :|
Date: Tue, 01 Jul 2014 15:16:34 +0200
Message-ID: <53B2B4B2.8050100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbaGANQr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jul 2014 09:16:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-scsi@vger.kernel.org

Hi James, Sarah,

When preparing the uas patches for 3.15 they got delayed to
3.16 because of a scsi subsys issue triggering $subject.

James did a fix which went into 3.15 iirc, but at that time
it was too late for the uas patches to go in so they went
into 3.16.

So I was surprised to see this bug rear its ugly head again
with 3.16-rc2, with which I've been doing some uas testing :|

To reproduce, take an uas disk, mount an fs on a partition on
it somewhere, then unplug it.

Here is the backtrace I'm getting:

[   84.870813] ------------[ cut here ]------------
[   84.870847] kernel BUG at block/blk-tag.c:89!
[   84.870871] invalid opcode: 0000 [#1] SMP
[   84.870900] Modules linked in: fuse xt_CHECKSUM ipt_MASQUERADE tun ip6t_rpfilter ip6t_REJECT xt_conntrack cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw sch5636 sch56xx_common snd_usb_audio snd_usbmidi_lib snd_rawmidi iTCO_wdt iTCO_vendor_support gpio_ich ppdev tuner_simple tuner_types tuner
snd_hda_codec_hdmi x86_pkg_temp_thermal msp3400 coretemp kvm_intel kvm snd_hda_codec_conexant snd_hda_codec_generic crct10dif_pclmul crc32_pclmul ghash_clmulni_intel microcode bttv btcx_risc tveeprom serio_raw videobuf_dma_sg
[   84.871382]  snd_hda_intel videobuf_core snd_hda_controller rc_core v4l2_common i2c_i801 snd_hda_codec snd_bt87x snd_hwdep videodev snd_seq snd_seq_device media snd_pcm lpc_ich mfd_core e1000e snd_timer snd ptp soundcore shpchp pps_core parport_pc parport tpm_infineon tpm_tis tpm binfmt_misc uas usb_storage i915 crc32c_intel video i2c_algo_bit drm_kms_helper drm i2c_core
[   84.871634] CPU: 3 PID: 3321 Comm: systemd-udevd Not tainted 3.16.0-0.rc2.git4.1.fc21.x86_64 #1
[   84.871676] Hardware name: FUJITSU D3071-S1/D3071-S1, BIOS V4.6.4.0 R1.12.0.S
[   84.871723] task: ffff880204ce19d0 ti: ffff8801eed1c000 task.ti: ffff8801eed1c000
[   84.871760] RIP: 0010:[<ffffffff813b69d8>]  [<ffffffff813b69d8>] blk_free_tags+0x18/0x20
[   84.871807] RSP: 0018:ffff8801eed1fb90  EFLAGS: 00010246
[   84.871835] RAX: 0000000000000000 RBX: ffff8801eedde000 RCX: 0000000000000015
[   84.871870] RDX: ffffffff8180dd9e RSI: 0000000000000001 RDI: ffff88022137a2c0
[   84.871905] RBP: ffff8801eed1fb90 R08: 0000000000000000 R09: 0000000000000000
[   84.871940] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880230082030
[   84.871975] R13: ffff8800ade81000 R14: ffff8801eedde2e0 R15: ffff8800adc44168
[   84.872010] FS:  00007f16a4581880(0000) GS:ffff880235a00000(0000) knlGS:0000000000000000
[   84.872049] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   84.872078] CR2: 00007ffca000bb88 CR3: 00000001f70c7000 CR4: 00000000000407e0
[   84.872113] Stack:
[   84.872126]  ffff8801eed1fbb8 ffffffff81544a00 ffff8801eedde2e0 ffff8801eedde2d0
[   84.872171]  ffff8800ade81000 ffff8801eed1fbe0 ffffffff8151a6d2 ffff8801eedde318
[   84.872217]  ffffffff81f5f040 ffff88022d10d850 ffff8801eed1fc10 ffffffff813e7efa
[   84.872262] Call Trace:
[   84.872282]  [<ffffffff81544a00>] scsi_host_dev_release+0xb0/0xf0
[   84.872315]  [<ffffffff8151a6d2>] device_release+0x32/0xa0
[   84.872345]  [<ffffffff813e7efa>] kobject_release+0x7a/0x1c0
[   84.872376]  [<ffffffff813e7dad>] kobject_put+0x2d/0x60
[   84.872405]  [<ffffffff8151aa47>] put_device+0x17/0x20
[   84.872433]  [<ffffffff8154e53f>] scsi_target_dev_release+0x1f/0x30
[   84.872466]  [<ffffffff8151a6d2>] device_release+0x32/0xa0
[   84.872496]  [<ffffffff813e7efa>] kobject_release+0x7a/0x1c0
[   84.872526]  [<ffffffff813e7dad>] kobject_put+0x2d/0x60
[   84.872554]  [<ffffffff8151aa47>] put_device+0x17/0x20
[   84.872583]  [<ffffffff81551d02>] scsi_device_dev_release_usercontext+0x112/0x130
[   84.872624]  [<ffffffff81551bf0>] ? scsi_device_dev_release+0x20/0x20
[   84.872660]  [<ffffffff810bef19>] execute_in_process_context+0x99/0xb0
[   84.872694]  [<ffffffff81551bec>] scsi_device_dev_release+0x1c/0x20
[   84.872727]  [<ffffffff8151a6d2>] device_release+0x32/0xa0
[   84.872758]  [<ffffffff813e7efa>] kobject_release+0x7a/0x1c0
[   84.872793]  [<ffffffff813e7dad>] kobject_put+0x2d/0x60
[   84.872823]  [<ffffffff8151aa47>] put_device+0x17/0x20
[   84.872854]  [<ffffffff8154246a>] scsi_device_put+0x3a/0x50
[   84.872885]  [<ffffffff81556b12>] scsi_disk_put+0x32/0x50
[   84.872914]  [<ffffffff81556e02>] sd_release+0x42/0xe0
[   84.872945]  [<ffffffff8128dbd5>] __blkdev_put+0x185/0x1c0
[   84.872977]  [<ffffffff8128e61e>] blkdev_put+0x4e/0x180
[   84.873006]  [<ffffffff8128e808>] blkdev_close+0x28/0x30
[   84.873036]  [<ffffffff8124d895>] __fput+0xf5/0x210
[   84.873063]  [<ffffffff8124d9fe>] ____fput+0xe/0x10
[   84.873092]  [<ffffffff810c5534>] task_work_run+0xc4/0xf0
[   84.873124]  [<ffffffff81019d41>] do_notify_resume+0x61/0x90
[   84.873156]  [<ffffffff818119a2>] int_signal+0x12/0x17
[   84.873182] Code: c3 66 90 0f 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 e8 82 ff ff ff 85 c0 74 06 5d c3 0f 1f 40 00 <0f> 0b 66 0f 1f 44 00 00 66 66 66 66 90 55 48 85 ff 48 89 e5 41
[   84.873446] RIP  [<ffffffff813b69d8>] blk_free_tags+0x18/0x20
[   84.873478]  RSP <ffff8801eed1fb90>
[   84.882872] ---[ end trace ec5b6567aa8bf013 ]---

Regards,

Hans
