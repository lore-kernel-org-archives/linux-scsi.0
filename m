From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 21172] OOPS in disk_replace_part_tbl.
Date: Thu, 25 Nov 2010 10:16:20 GMT
Message-ID: <201011251016.oAPAGKj9026679@demeter2.kernel.org>
References: <bug-21172-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:41482 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab0KYKQV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2010 05:16:21 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oAPAGKbH026680
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 25 Nov 2010 10:16:21 GMT
In-Reply-To: <bug-21172-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=21172


kakaouete <kaouete@crazydwarves.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kaouete@crazydwarves.org




--- Comment #2 from kakaouete <kaouete@crazydwarves.org>  2010-11-25 10:16:15 ---
Hi, I noticed the same problem, it appeared between 2.6.36 and 2.6.36.1.

Every time I unplug a usb device storage (my phone as well my usb key), I get
the oops:

usb 8-5: new high speed USB device using ehci_hcd and address 2
Initializing USB Mass Storage driver...
scsi6 : usb-storage 8-5:1.0
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
scsi 6:0:0:0: Direct-Access     Lexar    JD Secure II +   1100 PQ: 0 ANSI: 0
CCS
sd 6:0:0:0: Attached scsi generic sg2 type 0
sd 6:0:0:0: [sdb] 15663104 512-byte logical blocks: (8.01 GB/7.46 GiB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 43 00 00 00
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] Attached SCSI removable disk
usb 8-5: USB disconnect, address 2
BUG: unable to handle kernel NULL pointer dereference at 00000000000003a0
IP: [<ffffffff811dca07>] disk_replace_part_tbl.clone.15+0x27/0x70
PGD 13ac78067 PUD 13937e067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb8/8-5/speed
CPU 0 
Modules linked in: nls_cp437 vfat fat usb_storage fuse ipv6 rfcomm sco bnep
coretemp l2cap crc16 ext2 loop pata_pcmcia usbhid hid usblp tpm_infineon
snd_hda_codec_analog ide_cs ide_core btusb bluetooth uvcvideo videodev
v4l1_compat v4l2_compat_ioctl32 snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq snd_seq_device snd_hda_intel fan parport_pc uinput arc4 snd_hda_codec
snd_hwdep ecb snd_pcm sdhci_pci sdhci snd_timer joydev hp_wmi tpm_tis snd
mmc_core soundcore snd_page_alloc tpm tpm_bios video firewire_ohci hp_accel
cpufreq_powersave output container lis3lv02d input_polldev led_class
firewire_core crc_itu_t cpufreq_ondemand wmi pcmcia acpi_cpufreq thermal ac
battery button yenta_socket pcmcia_rsrc freq_table pcmcia_core iwlagn iwlcore
mac80211 cfg80211 rfkill uhci_hcd ppdev ehci_hcd iTCO_wdt iTCO_vendor_support
usbcore pcspkr psmouse intel_agp processor e1000e sg lp parport evdev serio_raw
mperf ext3 jbd mbcache sr_mod cdrom sd_mod ahci libahci libata scsi_mod radeon
ttm drm_kms_helper drm i2c_algo_bit i2c_core

Pid: 1713, comm: khubd Not tainted 2.6.36-ARCH #1 30DC/HP EliteBook 6930p
RIP: 0010:[<ffffffff811dca07>]  [<ffffffff811dca07>]
disk_replace_part_tbl.clone.15+0x27/0x70
RSP: 0018:ffff8801381559a0  EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88005a24dd40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88013b74ec38
RBP: ffff8801381559b0 R08: ffff88013fc380a8 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff8800ad56ab68 R15: 0000000000000246
FS:  0000000000000000(0000) GS:ffff880001a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000003a0 CR3: 000000013afdf000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khubd (pid: 1713, threadinfo ffff880138154000, task ffff8801383f6120)
Stack:
 ffff88013b74ec00 ffffffff81585160 ffff8801381559d0 ffffffff811dca7b
<0> ffff8800ad56ab68 0000000000000000 ffff8801381559f0 ffffffff812a0df2
<0> ffff8800ad56ab68 ffff88013b74ec70 ffff880138155a20 ffffffff811eaf15
Call Trace:
 [<ffffffff811dca7b>] disk_release+0x2b/0x50
 [<ffffffff812a0df2>] device_release+0x22/0x90
 [<ffffffff811eaf15>] kobject_release+0x45/0x90
 [<ffffffff811eaed0>] ? kobject_release+0x0/0x90
 [<ffffffff811ec737>] kref_put+0x37/0x70
 [<ffffffff811eadf7>] kobject_put+0x27/0x60
 [<ffffffff811db9b2>] put_disk+0x12/0x20
 [<ffffffffa022a3d1>] sg_device_destroy+0x51/0x70 [sg]
 [<ffffffffa022a380>] ? sg_device_destroy+0x0/0x70 [sg]
 [<ffffffff811ec737>] kref_put+0x37/0x70
 [<ffffffffa022a274>] sg_put_dev+0x14/0x20 [sg]
 [<ffffffffa022a376>] sg_remove+0xf6/0x100 [sg]
 [<ffffffff812a1ad1>] device_del+0xc1/0x1b0
 [<ffffffff812a1bd1>] device_unregister+0x11/0x20
 [<ffffffffa017adb5>] __scsi_remove_device+0xa5/0xc0 [scsi_mod]
 [<ffffffffa01798bc>] scsi_forget_host+0x5c/0x80 [scsi_mod]
 [<ffffffffa017047a>] scsi_remove_host+0x6a/0x120 [scsi_mod]
 [<ffffffffa04de332>] quiesce_and_remove_host+0x62/0xb0 [usb_storage]
 [<ffffffffa04de43d>] usb_stor_disconnect+0x1d/0x30 [usb_storage]
 [<ffffffffa0306bb5>] usb_unbind_interface+0x55/0x1a0 [usbcore]
 [<ffffffff812a4a60>] __device_release_driver+0x70/0xe0
 [<ffffffff812a4af8>] device_release_driver+0x28/0x40
 [<ffffffff812a4556>] bus_remove_device+0x76/0xa0
 [<ffffffff812a1b37>] device_del+0x127/0x1b0
 [<ffffffffa030474c>] usb_disable_device+0x6c/0x130 [usbcore]
 [<ffffffffa02fd0f5>] usb_disconnect+0x95/0x120 [usbcore]
 [<ffffffffa02fef5d>] hub_thread+0xaad/0x1200 [usbcore]
 [<ffffffff813931ed>] ? schedule+0x87d/0x9c0
 [<ffffffff81075af0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa02fe4b0>] ? hub_thread+0x0/0x1200 [usbcore]
 [<ffffffff81075546>] kthread+0x96/0xa0
 [<ffffffff8100bd64>] kernel_thread_helper+0x4/0x10
 [<ffffffff810754b0>] ? kthread+0x0/0xa0
 [<ffffffff8100bd60>] ? kernel_thread_helper+0x0/0x10
Code: 1f 44 00 00 55 48 89 e5 48 83 ec 10 4c 89 64 24 08 48 89 1c 24 49 89 f4
48 8b 1f 48 85 db 48 89 17 74 38 48 c7 43 18 00 00 00 00 <48> 8b be a0 03 00 00
e8 8d 8e 1b 00 4c 89 e7 e8 b5 18 ff ff 49 
RIP  [<ffffffff811dca07>] disk_replace_part_tbl.clone.15+0x27/0x70
 RSP <ffff8801381559a0>
CR2: 00000000000003a0
---[ end trace 308505f4649cb883 ]---
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: configured for UDMA/100
ata1: EH complete

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
