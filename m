From: Laura Abbott <labbott@redhat.com>
Subject: [BISECTED] WARNING: CPU: 2 PID: 142 at block/genhd.c:626
 add_disk+0x480/0x4e0()
Date: Wed, 9 Dec 2015 20:00:08 -0800
Message-ID: <5668F8C8.6000601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbbLJEAL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Dec 2015 23:00:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, James Bottomley <JBottomley@Odin.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, awilliam@redhat.com

Hi,

We received a report (https://bugzilla.redhat.com/show_bug.cgi?id=1288687) that
live images with the rawhide kernel were failing to boot on USB sticks.
Similar issues were reported when just inserting a USB stick into a boot from a
CD instead of USB ("I see /dev/sdb, but no /dev/sdb1 etc." per the report)
I reduced the test scenario to:

1) insert scsi_dh_alua module
2) insert Live USB drive

which gives

[ 125.107185] sd 6:0:0:0: alua: supports implicit and explicit TPGS
[ 125.107778] sd 6:0:0:0: [sdb] 15634432 512-byte logical blocks: (8.00 GB/7.46 GiB)
[ 125.107973] sd 6:0:0:0: alua: No target port descriptors found
[ 125.107975] sd 6:0:0:0: alua: Attach failed (-22)
[ 125.107978] sd 6:0:0:0: failed to add device handler: -22
[ 125.108462] sd 6:0:0:0: [sdb] Write Protect is off
[ 125.108465] sd 6:0:0:0: [sdb] Mode Sense: 43 00 00 00
[ 125.108468] sd 6:0:0:0: [sdb] Asking for cache data failed
[ 125.108469] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[ 125.109122] ------------[ cut here ]------------
[ 125.109127] WARNING: CPU: 2 PID: 142 at block/genhd.c:626 add_disk+0x480/0x4e0()
[ 125.109128] Modules linked in: uas usb_storage scsi_dh_alua fuse xt_CHECKSUM
ipt_MASQUERADE nf_nat_masquerade_ipv4 ccm tun nf_conntrack_netbios_ns
nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack
ebtable_filter ebtable_nat ebtable_broute bridge stp llc ebtables ip6table_raw
ip6table_security ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
ip6table_mangle ip6table_filter ip6_tables iptable_raw iptable_security
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
iptable_mangle bnep snd_hda_codec_hdmi arc4 iwlmvm mac80211 i915 intel_rapl
iosf_mbi x86_pkg_temp_thermal coretemp iwlwifi kvm_intel kvm
snd_hda_codec_realtek uvcvideo snd_hda_codec_generic btusb snd_hda_intel btrtl
videobuf2_vmalloc cfg80211 snd_hda_codec btbcm iTCO_wdt videobuf2_v4l2
[ 125.109164] btintel iTCO_vendor_support videobuf2_core irqbypass
videobuf2_memops bluetooth v4l2_common snd_hda_core ghash_clmulni_intel
videodev snd_hwdep snd_seq media pcspkr joydev snd_seq_device rtsx_pci_ms
snd_pcm memstick thinkpad_acpi snd_timer mei_me snd i2c_algo_bit mei
drm_kms_helper ie31200_edac rfkill tpm_tis edac_core shpchp soundcore tpm
i2c_i801 lpc_ich wmi nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc
dm_crypt hid_microsoft rtsx_pci_sdmmc mmc_core crct10dif_pclmul crc32_pclmul
crc32c_intel serio_raw drm e1000e ptp rtsx_pci pps_core fjes video
[ 125.109197] CPU: 2 PID: 142 Comm: kworker/u16:6 Tainted: G W 4.4.0-rc4-usbbadness-next-20151209+ #3
[ 125.109198] Hardware name: LENOVO 20BFS0EC00/20BFS0EC00, BIOS GMET62WW (2.10 ) 03/19/2014
[ 125.109202] Workqueue: events_unbound async_run_entry_fn
[ 125.109204] 0000000000000000 00000000202f2ede ffff880402ccfc38 ffffffff81434509
[ 125.109206] 0000000000000000 ffff880402ccfc70 ffffffff810ad9c2 ffff880407a1e000
[ 125.109208] ffff880407a1e0b0 ffff880407a1e00c ffff880401e48ef0 ffff8800c90d0600
[ 125.109211] Call Trace:
[ 125.109214] [<ffffffff81434509>] dump_stack+0x4b/0x72
[ 125.109218] [<ffffffff810ad9c2>] warn_slowpath_common+0x82/0xc0
[ 125.109220] [<ffffffff810adb0a>] warn_slowpath_null+0x1a/0x20
[ 125.109222] [<ffffffff81414910>] add_disk+0x480/0x4e0
[ 125.109225] [<ffffffff815e2875>] sd_probe_async+0x115/0x1d0
[ 125.109227] [<ffffffff810d6cea>] async_run_entry_fn+0x4a/0x140
[ 125.109231] [<ffffffff810cbb99>] process_one_work+0x239/0x6b0
[ 125.109233] [<ffffffff810cbb02>] ? process_one_work+0x1a2/0x6b0
[ 125.109235] [<ffffffff810cc05e>] worker_thread+0x4e/0x490
[ 125.109237] [<ffffffff810cc010>] ? process_one_work+0x6b0/0x6b0
[ 125.109238] [<ffffffff810d3091>] kthread+0x101/0x120
[ 125.109242] [<ffffffff81108999>] ? trace_hardirqs_on_caller+0x129/0x1b0
[ 125.109243] [<ffffffff810d2f90>] ? kthread_create_on_node+0x250/0x250
[ 125.109247] [<ffffffff81888a5f>] ret_from_fork+0x3f/0x70
[ 125.109248] [<ffffffff810d2f90>] ? kthread_create_on_node+0x250/0x250
[ 125.109250] ---[ end trace d54b73ed8d1295d5 ]---
[ 125.109272] sd 6:0:0:0: [sdb] Attached SCSI removable disk

and no partitions so the drive can't be mounted. Note the alua -EINVAL
error is there even when the drive can be mounted so the warning and
lack of partitions is the real indication of the problem.

I did a bisect and came up with this as the first bad commit:

commit 086b91d052ebe4ead5d28021afe3bdfd70af15bf
Author: Christoph Hellwig <hch@lst.de>
Date: Thu Aug 27 14:16:57 2015 +0200

scsi_dh: integrate into the core SCSI code

Stop building scsi_dh as a separate module and integrate it fully into the
core SCSI code with explicit callouts at bus scan time. For now the
callouts are placed at the same point as the old bus notifiers were called,
but in the future we will be able to look at ALUA INQUIRY data earlier on.

Note that this also means that the device handler modules need to be loaded
by the time we scan the bus. The next patches will add support for
autoloading device handlers at bus scan time to make sure they are always
loaded if they are enabled in the kernel config.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: James Bottomley <JBottomley@Odin.com>

This was an involved commit so I didn't try to revert. Any ideas here?
Full bisect log is below

Thanks,
Laura

----
git bisect start 'v4.4-rc4' 'v4.2.6'
# good: [64291f7db5bd8150a74ad2036f1037e6a0428df2] Linux 4.2
git bisect good 64291f7db5bd8150a74ad2036f1037e6a0428df2
# bad: [fc2a263bb0604642703cda6cba5ac1ffb1935440] Merge branch 'ipv4_link_down'
git bisect bad fc2a263bb0604642703cda6cba5ac1ffb1935440
# good: [807249d3ada1ff28a47c4054ca4edd479421b671] Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
git bisect good 807249d3ada1ff28a47c4054ca4edd479421b671
# good: [6b0f68e32ea8749ff7d4a66cd5761e915e48e59d] mm: add utility for early copy from unmapped ram
git bisect good 6b0f68e32ea8749ff7d4a66cd5761e915e48e59d
# bad: [fadb97b089563da69ba326f9fea6399d071462b2] Merge branch 'irq-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad fadb97b089563da69ba326f9fea6399d071462b2
# good: [bdb4d100afe9818aebd1d98ced575c5ef143456c] procfs: always expose /proc/<pid>/map_files/ and make it readable
git bisect good bdb4d100afe9818aebd1d98ced575c5ef143456c
# good: [0ba13fd19d39b7cb672bcec052bc813389c079a4] Revert "writeback: plug writeback at a high level"
git bisect good 0ba13fd19d39b7cb672bcec052bc813389c079a4
# bad: [10fbd36e362a0f367e34a7cd876a81295d8fc5ca] blk: rq_data_dir() should not return a boolean
git bisect bad 10fbd36e362a0f367e34a7cd876a81295d8fc5ca
# bad: [8e78b7dc93c580c050435b0f88991c26e02166bc] Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
git bisect bad 8e78b7dc93c580c050435b0f88991c26e02166bc
# good: [06a660ada2064bbdcd09aeb8173f2ad128c71978] Merge tag 'media/v4.3-2' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
git bisect good 06a660ada2064bbdcd09aeb8173f2ad128c71978
# good: [566079c849cfe538e908c44ac11a9c4638db8f91] dm-mpath, scsi_dh: request scsi_dh modules in scsi_dh, not dm-mpath
git bisect good 566079c849cfe538e908c44ac11a9c4638db8f91
# bad: [58a8635d5a1b49c4b87fb48969319e1ce77d3f03] scsi_debug: make dump_sector static
git bisect bad 58a8635d5a1b49c4b87fb48969319e1ce77d3f03
# bad: [d44227749500d8b88a1c079bc04f69187eaf8747] scsi_dh: don't allow to detach device handlers at runtime
git bisect bad d44227749500d8b88a1c079bc04f69187eaf8747
# bad: [d95dbff2a41e934cd8789734b34dc591e78ba11c] scsi_dh: move device matching to the core code
git bisect bad d95dbff2a41e934cd8789734b34dc591e78ba11c
# bad: [086b91d052ebe4ead5d28021afe3bdfd70af15bf] scsi_dh: integrate into the core SCSI code
git bisect bad 086b91d052ebe4ead5d28021afe3bdfd70af15bf
# good: [daaa858b7a6bb497f11c2aae555053b9c047824b] scsi_dh: move to drivers/scsi
git bisect good daaa858b7a6bb497f11c2aae555053b9c047824b
# first bad commit: [086b91d052ebe4ead5d28021afe3bdfd70af15bf] scsi_dh: integrate into the core SCSI code
                                                    
