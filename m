From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Kernel BUG after removing USB device
Date: Sat, 28 May 2011 11:54:06 -0500
Message-ID: <1306601646.5630.22.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1105271419170.2014-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56388 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312Ab1E1QyK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 May 2011 12:54:10 -0400
In-Reply-To: <Pine.LNX.4.44L0.1105271419170.2014-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bruce Guenter <bruce@untroubled.org>, Jens Axboe <jaxboe@fusionio.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

On Fri, 2011-05-27 at 14:26 -0400, Alan Stern wrote:
> Added a few entries to the CC: list.

Yes, it's a SCSI issue.  There's a fix already in play, although not
actually applied upstream yet:

http://marc.info/?l=linux-scsi&m=130635674521428

It also relies on a couple of block patches (mentioned in the thread).

James

> On Fri, 27 May 2011, Bruce Guenter wrote:
> 
> > Hi.
> > 
> > I have a repeatable kernel BUG happening after I remove either of my two
> > different Philips GoGear MP3 players.  I have also seen what appeared to
> > be a similar BUG on insertion once, but the problem is definitely
> > repeatable on removal.  After the BUG happens, the USB system is
> > generally unusable
> > 
> > I'm running an unmodified 2.6.38.7 kernel on Gentoo Linux, amd64 mode.
> > The host controller is EHCI (ATI SB870).
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
> > IP: [<ffffffff811d33c0>] elv_may_queue+0x10/0x20
> > PGD 217164067 PUD 217221067 PMD 0 
> > Oops: 0000 [#1] SMP 
> > last sysfs file: /sys/devices/pci0000:00/0000:00:13.2/class
> > CPU 1 
> > Modules linked in: nls_iso8859_1 nls_cp437 vfat fat f71882fg ipv6 snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss btrfs zlib_deflate lzo_compress crc32c libcrc32c cryptd aes_x86_64 aes_generic xts gf128mul kvm_amd kvm oprofile cachefiles nfs lockd fscache auth_rpcgss sunrpc usbhid hid usblp usb_storage ohci_hcd snd_hda_codec_via ehci_hcd snd_hda_intel sg usbcore e1000 snd_hda_codec sr_mod snd_hwdep snd_pcm atl1c snd_timer evdev i2c_piix4 k10temp snd soundcore snd_page_alloc
> > 
> > Pid: 4660, comm: blkid Not tainted 2.6.38.7 #40 MSI MS-7599/870-G45 (MS-7599)
> > RIP: 0010:[<ffffffff811d33c0>]  [<ffffffff811d33c0>] elv_may_queue+0x10/0x20
> > RSP: 0018:ffff88021461f818  EFLAGS: 00010097
> > RAX: 0000000000000000 RBX: ffff88022d521ea0 RCX: 0000000000000010
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88022d521ea0
> > RBP: ffff88021461f818 R08: 0000000000000008 R09: ffff880228006ea0
> > R10: ffff88021461fa58 R11: ffff88022bbd6000 R12: 0000000000000000
> > R13: 0000000000000001 R14: ffff88021461fa58 R15: ffff880228006ea0
> > FS:  00007fc5246ae740(0000) GS:ffff8800cfc80000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 0000000000000078 CR3: 0000000216ca1000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process blkid (pid: 4660, threadinfo ffff88021461e000, task ffff88022bbbc100)
> > Stack:
> >  ffff88021461f878 ffffffff811da17f ffff8800cfd11440 0000000000000082
> >  0000000000000000 ffffffff00000010 0000000000000001 ffff88022d521ea0
> >  0000000000000000 0000000000000010 ffff88021461fa58 ffff880228006ea0
> > Call Trace:
> >  [<ffffffff811da17f>] get_request+0x3f/0x3c0
> >  [<ffffffff811dae3a>] get_request_wait+0x2a/0x190
> >  [<ffffffff8149b644>] ? schedule+0x364/0xae0
> >  [<ffffffff811db00d>] blk_get_request+0x6d/0x80
> >  [<ffffffff81385f38>] scsi_execute+0x48/0x160
> >  [<ffffffff81386105>] scsi_execute_req+0xb5/0x130
> >  [<ffffffff8138d6ee>] read_capacity_10+0x8e/0x240
> >  [<ffffffff8138ec4f>] sd_revalidate_disk+0x5af/0x1a10
> >  [<ffffffff8110f6a8>] ? get_super+0x28/0xd0
> >  [<ffffffff8113ea31>] ? flush_disk+0x21/0xb0
> >  [<ffffffff8113eb2d>] check_disk_change+0x6d/0x80
> >  [<ffffffff8138e0e9>] sd_open+0xb9/0x190
> >  [<ffffffff8113fbd1>] __blkdev_get+0x91/0x380
> >  [<ffffffff811401c0>] ? blkdev_open+0x0/0x80
> >  [<ffffffff8113ff14>] blkdev_get+0x54/0x300
> >  [<ffffffff81117f79>] ? do_lookup+0xa9/0x2d0
> >  [<ffffffff811401c0>] ? blkdev_open+0x0/0x80
> >  [<ffffffff81140225>] blkdev_open+0x65/0x80
> >  [<ffffffff8110b7bd>] __dentry_open+0xcd/0x2e0
> >  [<ffffffff81117543>] ? generic_permission+0x23/0xb0
> >  [<ffffffff8110baf1>] nameidata_to_filp+0x71/0x80
> >  [<ffffffff811199f8>] finish_open+0xc8/0x1a0
> >  [<ffffffff8111b136>] ? do_path_lookup+0x66/0x140
> >  [<ffffffff8111c278>] do_filp_open+0x268/0x7e0
> >  [<ffffffff810eaba1>] ? handle_mm_fault+0x161/0x320
> >  [<ffffffff810eff04>] ? __vm_enough_memory+0x34/0x160
> >  [<ffffffff81127ae3>] ? alloc_fd+0x53/0x140
> >  [<ffffffff8110b5d9>] do_sys_open+0x69/0x110
> >  [<ffffffff8110b6c0>] sys_open+0x20/0x30
> >  [<ffffffff810025eb>] system_call_fastpath+0x16/0x1b
> > Code: 66 66 66 90 48 8b 47 18 48 8b 00 48 8b 40 70 48 85 c0 74 05 48 89 f7 ff d0 c9 c3 55 48 89 e5 66 66 66 66 90 48 8b 47 18 48 8b 00 <48> 8b 50 78 31 c0 48 85 d2 74 02 ff d2 c9 c3 90 55 48 89 e5 66 
> > RIP  [<ffffffff811d33c0>] elv_may_queue+0x10/0x20
> >  RSP <ffff88021461f818>
> > CR2: 0000000000000078
> > ---[ end trace 8e4bdfb146cdec93 ]---
> 
> This is not a USB problem (as can be seen from the fact that the stack
> dump doesn't include any USB-related functions).  You just happened to
> trigger it by removing a USB device, but any hot-unpluggable block
> device would give the same result.
> 
> It looks a lot like the sort of problem dealt with in this somewhat
> confusing thread (Re: [PATCH] SCSI IOCTL: Check for device deletion):
> 	
> 	http://marc.info/?l=linux-kernel&m=130628769605253&w=2
> 
> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


