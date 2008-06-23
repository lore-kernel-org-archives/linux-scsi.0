From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc7-git1: usb-storage breakage with non-functional disk
Date: Mon, 23 Jun 2008 23:58:32 +0200
Message-ID: <200806232358.33602.rjw@sisk.pl>
References: <200806232345.54047.rjw@sisk.pl> <200806232350.09597.Rafal.Wysocki@fuw.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:43033 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbYFWV47 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2008 17:56:59 -0400
In-Reply-To: <200806232350.09597.Rafal.Wysocki@fuw.edu.pl>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: USB development list <linux-usb@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Monday, 23 of June 2008, R. J. Wysocki wrote:
> [sorry for the broken USB list address in the original post.]

[and now my univeristy address instead of the usual one ...]

> On Monday, 23 of June 2008, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > This has just happened to me with -rc7-git1 while trying to use a not
> > sufficiently powered external disk (we should survive that IMO):
> > 
> > usb 6-3: new high speed USB device using ehci_hcd and address 9
> > usb 6-3: device descriptor read/64, error -110
> > usb 6-3: device descriptor read/64, error -110
> > usb 6-3: new high speed USB device using ehci_hcd and address 10
> > usb 6-3: device descriptor read/64, error -110
> > usb 6-3: device descriptor read/64, error -110
> > usb 6-3: new high speed USB device using ehci_hcd and address 11
> > usb 6-3: device not accepting address 11, error -110
> > usb 6-3: new high speed USB device using ehci_hcd and address 12
> > usb 6-3: device not accepting address 12, error -110
> > hub 6-0:1.0: unable to enumerate USB device on port 3
> > usb 2-1: new full speed USB device using ohci_hcd and address 2
> > usb 2-1: not running at top speed; connect to a high speed hub
> > usb 2-1: configuration #1 chosen from 1 choice
> > usb 2-1: New USB device found, idVendor=04cf, idProduct=8818
> > usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> > usb 2-1: Product: USB Mass Storage Device
> > usb 2-1: Manufacturer: Myson Century, Inc.
> > usb 2-1: SerialNumber: 100
> > Initializing USB Mass Storage driver...
> > scsi12 : SCSI emulation for USB Mass Storage devices
> > usb-storage: device found at 2
> > usb-storage: waiting for device to settle before scanning
> > usbcore: registered new interface driver usb-storage
> > USB Mass Storage support registered.
> > scsi 12:0:0:0: Direct-Access     IC25N060 ATMR04-0         MO3O PQ: 0 ANSI: 0 CCS
> > sd 12:0:0:0: [sdc] 117210240 512-byte hardware sectors (60012 MB)
> > sd 12:0:0:0: [sdc] Write Protect is off
> > sd 12:0:0:0: [sdc] Mode Sense: 00 14 00 00
> > sd 12:0:0:0: [sdc] Assuming drive cache: write through
> > sd 12:0:0:0: [sdc] 117210240 512-byte hardware sectors (60012 MB)
> > sd 12:0:0:0: [sdc] Write Protect is off
> > sd 12:0:0:0: [sdc] Mode Sense: 00 14 00 00
> > sd 12:0:0:0: [sdc] Assuming drive cache: write through
> >  sdc:<6>usb 2-1: USB disconnect, address 2
> > sd 12:0:0:0: [sdc] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
> > end_request: I/O error, dev sdc, sector 0
> > Buffer I/O error on device sdc, logical block 0
> > sd 12:0:0:0: [sdc] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
> > end_request: I/O error, dev sdc, sector 0
> > Buffer I/O error on device sdc, logical block 0
> >  unable to read partition table
> > sd 12:0:0:0: [sdc] Attached SCSI disk
> > sd 12:0:0:0: Attached scsi generic sg3 type 0
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> > IP: [<ffffffffa038e6f1>] :usb_storage:slave_alloc+0x41/0x80
> > PGD 1260ff067 PUD 119076067 PMD 0 
> > Oops: 0000 [1] SMP 
> > CPU 3 
> > Modules linked in: usb_storage parport_pc lp parport usblp nfsd lockd auth_rpcgss sunrpc exportfs iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device reiserfs dm_mod ohci1394 sr_mod cdrom floppy ieee1394 serio_raw rtc_cmos sky2 wmi snd_hda_intel rtc_core sg rtc_lib joydev snd_pcm snd_timer snd_page_alloc snd_hwdep snd evdev button soundcore raid456 async_xor async_memcpy async_tx xor raid0 usbhid ff_memless ehci_hcd ohci_hcd sd_mod edd raid1 ext3 jbd fan pata_marvell pata_atiixp thermal processor
> > Pid: 9319, comm: usb-stor-scan Not tainted 2.6.26-rc7 #196
> > RIP: 0010:[<ffffffffa038e6f1>]  [<ffffffffa038e6f1>] :usb_storage:slave_alloc+0x41/0x80
> > RSP: 0018:ffff8100a20cdb60  EFLAGS: 00010202
> > RAX: 0000000000000000 RBX: ffff810087d828d0 RCX: 0000000000000003
> > RDX: ffff8101275f08e0 RSI: ffff810086cc49d0 RDI: ffff810124144b90
> > RBP: ffff8100a20cdb70 R08: 0000000000000001 R09: 0000000000000000
> > R10: ffffffff807fe7e0 R11: 0000000000000000 R12: ffff810087499000
> > R13: ffff810124953678 R14: ffff810087d82000 R15: 0000000000000000
> > FS:  00007f22f6561700(0000) GS:ffff810127c997c0(0000) knlGS:00000000eeb1db90
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: 0000000000000004 CR3: 0000000122089000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process usb-stor-scan (pid: 9319, threadinfo ffff8100a20cc000, task ffff810086cc4300)
> > Stack:  ffff810087499000 ffff810124953650 ffff8100a20cdbb0 ffffffff803ea940
> >  ffff8100a20cdbb0 ffff810087d82000 0000000000000000 0000000000000000
> >  ffff810124953678 0000000000000000 ffff8100a20cdcf0 ffffffff803eac9a
> > Call Trace:
> >  [<ffffffff803ea940>] scsi_alloc_sdev+0x1e0/0x250
> >  [<ffffffff803eac9a>] scsi_probe_and_add_lun+0x12a/0xc20
> >  [<ffffffff803ebd4f>] __scsi_scan_target+0x3bf/0x6c0
> >  [<ffffffff8025db46>] ? mark_held_locks+0x56/0xa0
> >  [<ffffffff804ebbe9>] ? mutex_lock_nested+0x1b9/0x290
> >  [<ffffffff8025dcdf>] ? trace_hardirqs_on+0xbf/0x150
> >  [<ffffffff803ec0da>] scsi_scan_channel+0x8a/0xa0
> >  [<ffffffff803ec1e8>] scsi_scan_host_selected+0xf8/0x160
> >  [<ffffffff803ec2ce>] do_scsi_scan_host+0x7e/0x80
> >  [<ffffffff803ec850>] scsi_scan_host+0x190/0x1d0
> >  [<ffffffffa0390f3d>] :usb_storage:usb_stor_scan_thread+0x6d/0x1c0
> >  [<ffffffff8024f790>] ? autoremove_wake_function+0x0/0x40
> >  [<ffffffffa0390ed0>] ? :usb_storage:usb_stor_scan_thread+0x0/0x1c0
> >  [<ffffffff8024f33d>] kthread+0x4d/0x80
> >  [<ffffffff8020c608>] child_rip+0xa/0x12
> >  [<ffffffff8020bd1f>] ? restore_args+0x0/0x30
> >  [<ffffffff8024f2f0>] ? kthread+0x0/0x80
> >  [<ffffffff8020c5fe>] ? child_rip+0x0/0x12
> > 
> > 
> > Code: 1f c6 87 c3 00 00 00 24 48 8b 7f 08 48 81 c3 d0 08 00 00 8b 83 9c 00 00 00 48 8b 53 78 c1 e8 0f 83 e0 0f 48 8b 84 c2 e8 03 00 00 <0f> b7 70 04 ff ce e8 44 d9 fb df 80 bb c4 00 00 00 04 75 12 49 
> > RIP  [<ffffffffa038e6f1>] :usb_storage:slave_alloc+0x41/0x80
> >  RSP <ffff8100a20cdb60>
> > CR2: 0000000000000004
> > ---[ end trace 2077f860f94c5bf3 ]---
> > sd 12:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> > end_request: I/O error, dev sdc, sector 0
> > Buffer I/O error on device sdc, logical block 0
> > Buffer I/O error on device sdc, logical block 1
> > Buffer I/O error on device sdc, logical block 2
> > Buffer I/O error on device sdc, logical block 3
> > sd 12:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> > end_request: I/O error, dev sdc, sector 0
> > Buffer I/O error on device sdc, logical block 0
> > sd 12:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> > end_request: I/O error, dev sdc, sector 117210112
> > Buffer I/O error on device sdc, logical block 14651264
> > sd 12:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> > end_request: I/O error, dev sdc, sector 117210112
> > Buffer I/O error on device sdc, logical block 14651264
> > sd 12:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> > end_request: I/O error, dev sdc, sector 117210112
> > Buffer I/O error on device sdc, logical block 14651264
> > sd 12:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> > end_request: I/O error, dev sdc, sector 0
> > sd 12:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> > end_request: I/O error, dev sdc, sector 0
> > sd 12:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> > end_request: I/O error, dev sdc, sector 0
> > sd 12:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> > end_request: I/O error, dev sdc, sector 117210232
> > 
> > It resulted in usb-storage being unusable and a system reboot.
> > 
> > Thanks,
> > Rafael
