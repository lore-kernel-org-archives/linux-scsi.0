From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 30762] New: Oops when plugging in an usb stick
Date: Tue, 8 Mar 2011 13:32:34 GMT
Message-ID: <bug-30762-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:35372 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab1CHNcf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2011 08:32:35 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p28DWYAh026847
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 8 Mar 2011 13:32:34 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=30762

           Summary: Oops when plugging in an usb stick
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.37.1-ARCH
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: mrshpot@gmail.com
        Regression: Yes


Created an attachment (id=50302)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=50302)
lspci -v output

After updating to 2.6.37.1, the kernel started to Oops on USB stick insertion.
I rolled back to 2.6.37, the Oops did not happen. It still happens on 2.6.37.2.
The relevant kernel log part:
Feb 22 16:51:50 mariachi kernel: usb 2-1.2: new high speed USB device using
ehci_hcd and address 3
Feb 22 16:51:51 mariachi kernel: Initializing USB Mass Storage driver...
Feb 22 16:51:51 mariachi kernel: scsi4 : usb-storage 2-1.2:1.0
Feb 22 16:51:51 mariachi kernel: usbcore: registered new interface driver
usb-storage
Feb 22 16:51:51 mariachi kernel: USB Mass Storage support registered.
Feb 22 16:51:51 mariachi kernel: usbcore: registered new interface driver uas
Feb 22 16:51:52 mariachi kernel: scsi 4:0:0:0: Direct-Access     JetFlash
Transcend 8GB    8.07 PQ: 0 ANSI: 2
Feb 22 16:51:52 mariachi kernel: sd 4:0:0:0: Attached scsi generic sg1 type 0
Feb 22 16:51:52 mariachi kernel: sd 4:0:0:0: [sdb] 15687680 512-byte logical
blocks: (8.03 GB/7.48 GiB)
Feb 22 16:51:52 mariachi kernel: sd 4:0:0:0: [sdb] Write Protect is off
Feb 22 16:51:52 mariachi kernel: sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
Feb 22 16:51:52 mariachi kernel: sd 4:0:0:0: [sdb] Assuming drive cache: write
through
Feb 22 16:51:52 mariachi kernel: sd 4:0:0:0: [sdb] Assuming drive cache: write
through
Feb 22 16:51:52 mariachi kernel: BUG: unable to handle kernel NULL pointer
dereference at 000001b9
Feb 22 16:51:52 mariachi kernel: IP: [<fd291603>]
last_sector_hacks.clone.1+0x73/0x130 [usb_storage]
Feb 22 16:51:52 mariachi kernel: *pde = 00000000 
Feb 22 16:51:52 mariachi kernel: Oops: 0000 [#1] PREEMPT SMP 
Feb 22 16:51:52 mariachi kernel: last sysfs file:
/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/host4/target4:0:0/4:0:0:0/block/sdb/uevent
Feb 22 16:51:52 mariachi kernel: Modules linked in: uas usb_storage rfcomm sco
bnep l2cap fuse ipv6 uvcvideo videodev v4l1_compat btusb bluetooth
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device joydev arc4
ecb ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 snd_hda_codec_hdmi
asus_laptop sparse_keymap rfkill thermal snd_hda_codec_realtek ac i915
processor drm_kms_helper ehci_hcd drm snd_hda_intel usbcore i2c_algo_bit
snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc sg
battery video output button atl1c serio_raw i2c_i801 i2c_core intel_agp
intel_gtt iTCO_wdt agpgart iTCO_vendor_support psmouse intel_ips evdev pcspkr
shpchp pci_hotplug vboxdrv sd_mod ahci libahci libata scsi_mod ext4 mbcache
jbd2 crc16
Feb 22 16:51:52 mariachi kernel: 
Feb 22 16:51:52 mariachi kernel: Pid: 4649, comm: usb-storage Not tainted
2.6.37-ARCH #1 UL20FT/UL20FT
Feb 22 16:51:52 mariachi kernel: EIP: 0060:[<fd291603>] EFLAGS: 00010202 CPU: 0
Feb 22 16:51:52 mariachi kernel: EIP is at last_sector_hacks.clone.1+0x73/0x130
[usb_storage]
Feb 22 16:51:52 mariachi kernel: EAX: f259ecd4 EBX: 00000051 ECX: f27cc480 EDX:
f259ecd8
Feb 22 16:51:52 mariachi kernel: ESI: 00000001 EDI: 00000000 EBP: f0eadee0 ESP:
f0eadec8
Feb 22 16:51:52 mariachi kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Feb 22 16:51:52 mariachi kernel: Process usb-storage (pid: 4649, ti=f0eac000
task=f0e38450 task.ti=f0eac000)
Feb 22 16:51:52 mariachi kernel: Stack:
Feb 22 16:51:52 mariachi kernel: 28000000 00000000 00000051 f259ebbc f27cc480
f259ebe8 f0eadf64 fd291c82
Feb 22 16:51:52 mariachi kernel: 00000000 00000000 00000000 319fc6cb 0159ebe8
00000000 00000001 00000001
Feb 22 16:51:52 mariachi kernel: 00000003 00000082 f0c2c7e0 00000004 319fc6cb
00000001 7fffffff f259ec90
Feb 22 16:51:52 mariachi kernel: Call Trace:
Feb 22 16:51:52 mariachi kernel: [<fd291c82>] ?
usb_stor_invoke_transport+0xa2/0x3a0 [usb_storage]
Feb 22 16:51:52 mariachi kernel: [<c13126f7>] ? wait_for_common+0xe7/0x120
Feb 22 16:51:52 mariachi kernel: [<c131447b>] ?
__mutex_lock_slowpath+0x1eb/0x2b0
Feb 22 16:51:52 mariachi kernel: [<fd290c08>] ?
usb_stor_transparent_scsi_command+0x8/0x10 [usb_storage]
Feb 22 16:51:52 mariachi kernel: [<fd2927f1>] ?
usb_stor_control_thread+0x121/0x1f0 [usb_storage]
Feb 22 16:51:52 mariachi kernel: [<c10331d9>] ? complete+0x49/0x60
Feb 22 16:51:52 mariachi kernel: [<fd2926d0>] ?
usb_stor_control_thread+0x0/0x1f0 [usb_storage]
Feb 22 16:51:52 mariachi kernel: [<c1061734>] ? kthread+0x74/0x80
Feb 22 16:51:52 mariachi kernel: [<c10616c0>] ? kthread+0x0/0x80
Feb 22 16:51:52 mariachi kernel: [<c1003ebe>] ? kernel_thread_helper+0x6/0x18
Feb 22 16:51:52 mariachi kernel: Code: dc 01 00 00 85 ff 89 7d f0 74 2e 0f b6
7d ef c1 e6 18 c1 e7 10 09 fe 0f b6 fb 8b 5d f0 09 fe 0f b6 7d ee c1 e7 08 09
fe 83 c6 01 <33> b3 68 01 00 00 0b b3 6c 01 00 00 74 2f 80 7d eb 00 74 06 c7 
Feb 22 16:51:52 mariachi kernel: EIP: [<fd291603>]
last_sector_hacks.clone.1+0x73/0x130 [usb_storage] SS:ESP 0068:f0eadec8
Feb 22 16:51:52 mariachi kernel: CR2: 00000000000001b9
Feb 22 16:51:52 mariachi kernel: ---[ end trace c2b10b333a26bed5 ]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
