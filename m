From: Dave Jones <davej@redhat.com>
Subject: WARNING: at drivers/scsi/scsi_lib.c:1196 scsi_setup_fs_cmnd during
 RAID5 startup.
Date: Wed, 12 Jun 2013 15:43:46 -0400
Message-ID: <20130612194346.GD15200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

3.10 seems to have a problem with dirty RAID5 sets.

I've got a machine that panics on boot during RAID5 activation.
After switching the BUG_ON to a WARN_ON, I was able to get this over serial console..

md/raid:md0: not clean -- starting background reconstruction
md/raid:md0: device sdd1 operational as raid disk 2
md/raid:md0: device sdc1 operational as raid disk 1
md/raid:md0: device sdb1 operational as raid disk 0
md/raid:md0: allocated 3300kB
md/raid:md0: raid level 5 active with 3 out of 3 devices, algorithm 2
md0: detected capacity change from 0 to 499847790592
md: resync of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
md: using 128k window, over a total of 244066304k.
md: resuming resync of md0 from checkpoint.
WARNING: at drivers/scsi/scsi_lib.c:1196 scsi_setup_fs_cmnd+0xa3/0xb0()
Modules linked in: raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx kvm_amd xor kvm snd_hda_codec_realtek raid6_pq snd_hda_intel snd_hda_codec btusb microcode snd_pcm bluetooth edac_core pcspkr serio_raw snd_page_alloc snd_timer snd soundcore rfkill r8169 mii sr_mod cdrom pata_atiixp radeon backlight drm_kms_helper ttm
CPU: 1 PID: 160 Comm: kworker/1:1H Not tainted 3.10.0-rc5+ #2
Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F12a 04/23/2010
Workqueue: kblockd blk_delay_work
 ffffffff81a4499d ffff8801225f5bb8 ffffffff816aeb63 ffff8801225f5bf0
 ffffffff810432b0 ffff880123039148 ffff8801233e8b00 ffff8801225f5fd8
 ffff880123039148 ffff880123071290 ffff8801225f5c00 ffffffff8104339a
Call Trace:
 [<ffffffff816aeb63>] dump_stack+0x19/0x1b
 [<ffffffff810432b0>] warn_slowpath_common+0x70/0xa0
 [<ffffffff8104339a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8145d7f3>] scsi_setup_fs_cmnd+0xa3/0xb0
 [<ffffffff8146bb80>] sd_prep_fn+0x330/0xf60
 [<ffffffff813059cc>] blk_peek_request+0x13c/0x320
 [<ffffffff8145db12>] scsi_request_fn+0x52/0x540
 [<ffffffff81301ae9>] ? blk_delay_work+0x19/0x40
 [<ffffffff813018f2>] __blk_run_queue+0x32/0x40
 [<ffffffff81301af5>] blk_delay_work+0x25/0x40
 [<ffffffff810690f1>] process_one_work+0x211/0x6f0
 [<ffffffff81069085>] ? process_one_work+0x1a5/0x6f0
 [<ffffffff810696ec>] worker_thread+0x11c/0x390
 [<ffffffff810695d0>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff81071c8d>] kthread+0xed/0x100
 [<ffffffff81071ba0>] ? insert_kthread_work+0x80/0x80
 [<ffffffff816bee5c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81071ba0>] ? insert_kthread_work+0x80/0x80
---[ end trace 22d5bd5ee9fceb9e ]---


3.9 boots fine, and puts it into recovery mode..

$ cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 sdd1[2] sdb1[0] sdc1[1]
      488132608 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
      [>....................]  resync =  0.7% (1762712/244066304) finish=73.3min speed=55084K/sec
      
unused devices: <none>
