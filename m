From: Naveen Goswamy <naveen.goswamy@polymtl.ca>
Subject: Re: Kernel crashing on eject SD card
Date: Mon, 13 Feb 2012 12:40:31 -0500
Message-ID: <1329154831.4f394b0f3c69c@www.imp.polymtl.ca>
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca> <20120212220836.6aa7fa4d@stein> <20120212222027.71651e8b@stein> <20120213021813.GA589@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120213021813.GA589@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Quoting Dave Jones <davej@redhat.com>:


> Some of them are using vbox/vmware, but there's a few in there that
> haven't used either, so I think that might be a red herring.


You are correct Dave.  There was a red-herring.  I managed to experience the
same crash and burn again today, without vbox drivers.  Here are the logs.


Feb 13 08:50:53 speedy kernel: scsi 6:0:0:0: killing request
Feb 13 08:50:53 speedy kernel: BUG: unable to handle kernel NULL pointer
dereference at 0000000000000008
Feb 13 08:50:53 speedy kernel: IP: [<ffffffff8135b798>]
sd_revalidate_disk+0x1a/0x16ee
Feb 13 08:50:53 speedy kernel: PGD 223493067 PUD 2234de067 PMD 0
Feb 13 08:50:53 speedy kernel: Oops: 0000 [#1] SMP
Feb 13 08:50:53 speedy kernel: CPU 2
Feb 13 08:50:53 speedy kernel: Modules linked in: aes_x86_64 aes_generic
ipt_REJECT iptable_mangle iptable_nat nf_nat iptable_filter ip_tables ipv6
dm_mod uvcvideo videodev v4l2_compat_ioctl32 usb_storage arc4 brcmsmac
snd_hda_codec_hdmi snd_hda_codec_idt mac80211 brcmutil snd_hda_intel
snd_hda_codec cfg80211 r8169 rfkill snd_pcm snd_timer dell_wmi snd
sparse_keymap ehci_hcd wmi firmware_class dcdbas crc8 soundcore rtc usbcore
snd_page_alloc sg cordic usb_common
Feb 13 08:50:53 speedy kernel:
Feb 13 08:50:53 speedy kernel: Pid: 2721, comm: udisks-daemon Not tainted
3.2.5-gentoo_MINE_V00 #1 Dell Inc. Vostro 3400/07MJFM
Feb 13 08:50:53 speedy kernel: RIP: 0010:[<ffffffff8135b798>]
[<ffffffff8135b798>] sd_revalidate_disk+0x1a/0x16ee
Feb 13 08:50:53 speedy kernel: RSP: 0018:ffff8802234ddb08  EFLAGS: 00010292
Feb 13 08:50:53 speedy kernel: RAX: ffffffff8135b77e RBX: 0000000000000000 RCX:
0000000000000002
Feb 13 08:50:53 speedy kernel: RDX: 0000000000000002 RSI: 0000000800000000 RDI:
ffff880231599000
Feb 13 08:50:53 speedy kernel: RBP: ffff880231599000 R08: ffff88023ab4f9a0 R09:
ffffffff81852ec8
Feb 13 08:50:53 speedy kernel: R10: 0000000000000002 R11: 0000000000011e00 R12:
ffff880231599000
Feb 13 08:50:53 speedy kernel: R13: ffff880232322698 R14: 0000000000000000 R15:
ffff880232322680
Feb 13 08:50:53 speedy kernel: FS:  00007f7666c6b700(0000)
GS:ffff88023bd00000(0000) knlGS:0000000000000000
Feb 13 08:50:53 speedy kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Feb 13 08:50:53 speedy kernel: CR2: 0000000000000008 CR3: 0000000223492000 CR4:
00000000000006e0
Feb 13 08:50:53 speedy kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
Feb 13 08:50:53 speedy kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
Feb 13 08:50:53 speedy kernel: Process udisks-daemon (pid: 2721, threadinfo
ffff8802234dc000, task ffff880230f76920)
Feb 13 08:50:53 speedy kernel: Stack:
Feb 13 08:50:53 speedy kernel: ffffffff8103468a ffff880231599048
0000000000000000 ffff880231599000
Feb 13 08:50:53 speedy kernel: ffff880232322698 000000000000001d
ffff880232322680 ffffffff810a0f35
Feb 13 08:50:53 speedy kernel: ffff880232322680 ffff880231599000
0000000000000000 ffff880232322758
Feb 13 08:50:53 speedy kernel: Call Trace:
Feb 13 08:50:53 speedy kernel: [<ffffffff8103468a>] ? try_to_wake_up+0x200/0x200
Feb 13 08:50:53 speedy kernel: [<ffffffff810a0f35>] ? get_super+0x1a/0x95
Feb 13 08:50:53 speedy kernel: [<ffffffff810b2460>] ? iput+0x2b/0x17e
Feb 13 08:50:53 speedy kernel: [<ffffffff810eb4b6>] ?
rescan_partitions+0xac/0x446
Feb 13 08:50:53 speedy kernel: [<ffffffff810c5498>] ? __blkdev_get+0x162/0x33f
Feb 13 08:50:53 speedy kernel: [<ffffffff810c5913>] ? blkdev_get+0x29e/0x29e
Feb 13 08:50:53 speedy kernel: [<ffffffff810c5835>] ? blkdev_get+0x1c0/0x29e
Feb 13 08:50:53 speedy kernel: [<ffffffff810c5913>] ? blkdev_get+0x29e/0x29e
Feb 13 08:50:53 speedy kernel: [<ffffffff8109e0a7>] ?
__dentry_open.clone.14+0x16b/0x294
Feb 13 08:50:53 speedy kernel: [<ffffffff810aab37>] ?
do_last.clone.34+0x64e/0x662
Feb 13 08:50:53 speedy kernel: [<ffffffff810aac4d>] ? path_openat+0xcb/0x354
Feb 13 08:50:53 speedy kernel: [<ffffffff8133e9b0>] ?
scsi_set_medium_removal+0x46/0x6b
Feb 13 08:50:53 speedy kernel: [<ffffffff810aafb1>] ? do_filp_open+0x2c/0x72
Feb 13 08:50:53 speedy kernel: [<ffffffff810b4066>] ? alloc_fd+0x69/0x10f
Feb 13 08:50:53 speedy kernel: [<ffffffff8109ed9a>] ? do_sys_open+0x101/0x18f
Feb 13 08:50:53 speedy kernel: [<ffffffff81483292>] ?
system_call_fastpath+0x16/0x1b
Feb 13 08:50:53 speedy kernel: Code: ff ff 48 83 c4 68 5b 5d 41 5c 41 5d 41 5e
41 5f c3 41 57 41 56 41 55 41 54 55 53 48 83 ec 78 48 8b 9f 50 02 00 00 48 89
7c 24 48 <48> 8b 43 08 48 89 44 24 28 8b 05 49 dc 7e 00 c1 e8 15 83 e0 07
Feb 13 08:50:53 speedy kernel: RIP  [<ffffffff8135b798>]
sd_revalidate_disk+0x1a/0x16ee
Feb 13 08:50:53 speedy kernel: RSP <ffff8802234ddb08>
Feb 13 08:50:53 speedy kernel: CR2: 0000000000000008
Feb 13 08:50:53 speedy kernel: ---[ end trace 0370d79d444e26e5 ]---
