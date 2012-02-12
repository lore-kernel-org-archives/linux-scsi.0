From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Kernel crashing on eject SD card
Date: Sun, 12 Feb 2012 22:08:36 +0100
Message-ID: <20120212220836.6aa7fa4d@stein>
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36889 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab2BLVIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2012 16:08:47 -0500
In-Reply-To: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Naveen Goswamy <naveen.goswamy@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Feb 07 Naveen Goswamy wrote:
> The details are here:
> 
> 
> https://bugs.gentoo.org/show_bug.cgi?id=402433
> 
> Any ideas?  Is this a known issue?

It has been reported repeatedly, AFAICT without any progress so far.
http://marc.info/?l=linux-scsi&m=132388619710052

It's the old story; an udev helper opens a block device while it is being
torn down apparently.  Block subsystem soils itself.

Here is the kernel log from Naveen's report at the Gentoo bug tracker, for
the convenience of the list subscribers:

Feb  6 10:51:09 speedy kernel: ieee80211 phy0: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 130/256 dur 1546/1504
Feb  6 10:54:39 speedy kernel: usb 1-1.6: new high-speed USB device number 4 using ehci_hcd
Feb  6 10:54:39 speedy kernel: usb 1-1.6: New USB device found, idVendor=0bda, idProduct=0159
Feb  6 10:54:39 speedy kernel: usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Feb  6 10:54:39 speedy kernel: usb 1-1.6: Product: USB2.0-CRW
Feb  6 10:54:39 speedy kernel: usb 1-1.6: Manufacturer: Generic
Feb  6 10:54:39 speedy kernel: usb 1-1.6: SerialNumber: 20071114173400000
Feb  6 10:54:39 speedy kernel: scsi7 : usb-storage 1-1.6:1.0
Feb  6 10:54:40 speedy kernel: scsi 7:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
Feb  6 10:54:40 speedy kernel: sd 7:0:0:0: Attached scsi generic sg2 type 0
Feb  6 10:54:41 speedy kernel: sd 7:0:0:0: [sdb] 3862528 512-byte logical blocks: (1.97 GB/1.84 GiB)
Feb  6 10:54:41 speedy kernel: sd 7:0:0:0: [sdb] Write Protect is off
Feb  6 10:54:41 speedy kernel: sd 7:0:0:0: [sdb] Mode Sense: 03 00 00 00
Feb  6 10:54:41 speedy kernel: sd 7:0:0:0: [sdb] No Caching mode page present
Feb  6 10:54:41 speedy kernel: sd 7:0:0:0: [sdb] Assuming drive cache: write through
Feb  6 10:54:41 speedy kernel: sd 7:0:0:0: [sdb] No Caching mode page present
Feb  6 10:54:41 speedy kernel: sd 7:0:0:0: [sdb] Assuming drive cache: write through
Feb  6 10:54:41 speedy kernel: sdb: sdb1
Feb  6 10:54:41 speedy kernel: sd 7:0:0:0: [sdb] No Caching mode page present
Feb  6 10:54:41 speedy kernel: sd 7:0:0:0: [sdb] Assuming drive cache: write through
Feb  6 10:54:41 speedy kernel: sd 7:0:0:0: [sdb] Attached SCSI removable disk
Feb  6 10:58:08 speedy kernel: usb 1-1.6: USB disconnect, device number 4
Feb  6 10:58:08 speedy kernel: scsi 7:0:0:0: killing request
Feb  6 10:58:08 speedy kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
Feb  6 10:58:08 speedy kernel: IP: [<ffffffff8135b1c7>] sd_revalidate_disk+0x1a/0x16ee
Feb  6 10:58:08 speedy kernel: PGD 2209b0067 PUD 2209b1067 PMD 0 
Feb  6 10:58:08 speedy kernel: Oops: 0000 [#1] SMP 
Feb  6 10:58:08 speedy kernel: CPU 3 
Feb  6 10:58:08 speedy kernel: Modules linked in: aes_x86_64 aes_generic ipt_REJECT iptable_mangle iptable_nat nf_nat iptable_filter ip_tables ipv6 dm_mod vboxnetadp(O) vboxnetflt(O) vboxdrv(O) uvcvideo videodev v4l2_compat_ioctl32 usb_storage arc4 brcmsmac snd_hda_codec_hdmi snd_hda_codec_idt mac80211 snd_hda_intel brcmutil snd_hda_codec dell_wmi ehci_hcd r8169 usbcore snd_pcm cfg80211 snd_timer dcdbas firmware_class snd usb_common sparse_keymap soundcore rtc rfkill sg wmi snd_page_alloc crc8 cordic
Feb  6 10:58:08 speedy kernel: 
Feb  6 10:58:08 speedy kernel: Pid: 2434, comm: udisks-daemon Tainted: G           O 3.2.1-gentoo-r2_MINE_V01 #1 Dell Inc. Vostro 3400/07MJFM
Feb  6 10:58:08 speedy kernel: RIP: 0010:[<ffffffff8135b1c7>]  [<ffffffff8135b1c7>] sd_revalidate_disk+0x1a/0x16ee
Feb  6 10:58:08 speedy kernel: RSP: 0018:ffff8802209cfb08  EFLAGS: 00010292
Feb  6 10:58:08 speedy kernel: RAX: ffffffff8135b1ad RBX: 0000000000000000 RCX: 0000000000000002
Feb  6 10:58:08 speedy kernel: RDX: 0000000000000002 RSI: 0000000800000000 RDI: ffff880231668800
Feb  6 10:58:08 speedy kernel: RBP: ffff880231668800 R08: ffff8802315447a0 R09: ffffffff81852e48
Feb  6 10:58:08 speedy kernel: R10: 0000000000000000 R11: 0000000000011e00 R12: ffff880231668800
Feb  6 10:58:08 speedy kernel: R13: ffff88021746acd8 R14: 0000000000000000 R15: ffff88021746acc0
Feb  6 10:58:08 speedy kernel: FS:  00007fc6dd3ab700(0000) GS:ffff88023bd80000(0000) knlGS:0000000000000000
Feb  6 10:58:08 speedy kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb  6 10:58:08 speedy kernel: CR2: 0000000000000008 CR3: 00000002209af000 CR4: 00000000000006e0
Feb  6 10:58:08 speedy kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  6 10:58:08 speedy kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  6 10:58:08 speedy kernel: Process udisks-daemon (pid: 2434, threadinfo ffff8802209ce000, task ffff88023aac4110)
Feb  6 10:58:08 speedy kernel: Stack:
Feb  6 10:58:08 speedy kernel: ffffffff8103461a ffff880231668848 0000000000000000 ffff880231668800
Feb  6 10:58:08 speedy kernel: ffff88021746acd8 000000000000001d ffff88021746acc0 ffffffff810a0ec9
Feb  6 10:58:08 speedy kernel: ffff88021746acc0 ffff880231668800 0000000000000000 ffff88021746ad98
Feb  6 10:58:08 speedy kernel: Call Trace:
Feb  6 10:58:08 speedy kernel: [<ffffffff8103461a>] ? try_to_wake_up+0x200/0x200
Feb  6 10:58:08 speedy kernel: [<ffffffff810a0ec9>] ? get_super+0x1a/0x95
Feb  6 10:58:08 speedy kernel: [<ffffffff810b23d8>] ? iput+0x2b/0x17e
Feb  6 10:58:08 speedy kernel: [<ffffffff810eb3ce>] ? rescan_partitions+0xac/0x446
Feb  6 10:58:08 speedy kernel: [<ffffffff810c5410>] ? __blkdev_get+0x162/0x33f
Feb  6 10:58:08 speedy kernel: [<ffffffff810c588b>] ? blkdev_get+0x29e/0x29e
Feb  6 10:58:08 speedy kernel: [<ffffffff810c57ad>] ? blkdev_get+0x1c0/0x29e
Feb  6 10:58:08 speedy kernel: [<ffffffff810c588b>] ? blkdev_get+0x29e/0x29e
Feb  6 10:58:08 speedy kernel: [<ffffffff8109e03b>] ? __dentry_open.clone.14+0x16b/0x294
Feb  6 10:58:08 speedy kernel: [<ffffffff810aaacb>] ? do_last.clone.34+0x64e/0x662
Feb  6 10:58:08 speedy kernel: [<ffffffff810aabe1>] ? path_openat+0xcb/0x354
Feb  6 10:58:08 speedy kernel: [<ffffffff8133e3fc>] ? scsi_set_medium_removal+0x46/0x6b
Feb  6 10:58:08 speedy kernel: [<ffffffff8102c3b7>] ? ttwu_do_wakeup+0x11/0x86
Feb  6 10:58:08 speedy kernel: [<ffffffff810aaf45>] ? do_filp_open+0x2c/0x72
Feb  6 10:58:08 speedy kernel: [<ffffffff810b3fde>] ? alloc_fd+0x69/0x10f
Feb  6 10:58:08 speedy kernel: [<ffffffff8109ed2e>] ? do_sys_open+0x101/0x18f
Feb  6 10:58:08 speedy kernel: [<ffffffff81482b52>] ? system_call_fastpath+0x16/0x1b
Feb  6 10:58:08 speedy kernel: Code: ff ff 48 83 c4 68 5b 5d 41 5c 41 5d 41 5e 41 5f c3 41 57 41 56 41 55 41 54 55 53 48 83 ec 78 48 8b 9f 50 02 00 00 48 89 7c 24 48 <48> 8b 43 08 48 89 44 24 28 8b 05 1a e2 7e 00 c1 e8 15 83 e0 07 
Feb  6 10:58:08 speedy kernel: RIP  [<ffffffff8135b1c7>] sd_revalidate_disk+0x1a/0x16ee
Feb  6 10:58:08 speedy kernel: RSP <ffff8802209cfb08>
Feb  6 10:58:08 speedy kernel: CR2: 0000000000000008
Feb  6 10:58:09 speedy kernel: ---[ end trace 2cb4da56c38cb030 ]---

-- 
Stefan Richter
-=====-===-- --=- -==--
http://arcgraph.de/sr/
