From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 40532] New: Kernel oops on creative zen M300
 removal
Date: Tue, 23 Aug 2011 14:51:01 -0700
Message-ID: <20110823145101.c5a7a8f8.akpm@linux-foundation.org>
References: <bug-40532-10286@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886Ab1HWVvY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2011 17:51:24 -0400
In-Reply-To: <bug-40532-10286@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, kokoko3k@gmail.com


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 4 Aug 2011 10:18:30 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=40532
> 
>            Summary: Kernel oops on creative zen M300 removal
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 2.6.39.3 and 3.0

Is this a regression?  Were earlier kernels OK?

>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: io_other@kernel-bugs.osdl.org
>         ReportedBy: kokoko3k@gmail.com
>         Regression: No
> 
> 
> Everytime i *unmount* the creative zen M300 using kde device manager, i've
> kernel oops.
> After that udisk daemon and/or hal are unable to automount any usb device.
> Manual commands mount and umount still works.
> And even if the device has been mounted with kde and unmounted via "umount",
> the problem does NOT occours.
> 
> Attached the kernel log.
> 

Here:

[  217.223738] usb 2-2: USB disconnect, device number 3
[  218.020021] scsi: killing requests for dead queue
[  218.020041] BUG: unable to handle kernel NULL pointer dereference at 0000039c
[  218.020047] IP: [<f8043e9b>] scsi_prep_state_check+0xb/0x80 [scsi_mod]
[  218.020059] *pde = 00000000
[  218.020063] Oops: 0000 [#1] PREEMPT SMP
[  218.020068] Modules linked in: nls_cp437 vfat fat usb_storage uas
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss
snd_mixer_oss cpufreq_ondemand cpufreq_userspace acpi_cpufreq
freq_table mperf tun fuse snd_usb_audio snd_usbmidi_lib snd_rawmidi
snd_seq_device appletalk ipx p8022 psnap llc p8023 ext3 jbd nvidia(P)
usbhid hid snd_hda_codec_realtek sg snd_hda_intel snd_hda_codec
snd_hwdep uhci_hcd snd_pcm i2c_i801 ppdev sr_mod snd_timer ehci_hcd
cdrom intel_agp snd i2c_core intel_gtt parport_pc usbcore r8169
processor button asus_atk0110 agpgart parport evdev floppy iTCO_wdt
iTCO_vendor_support mii soundcore snd_page_alloc ext4 mbcache jbd2
crc16 pata_acpi pata_jmicron sd_mod ahci libahci libata scsi_mod [last
unloaded: pcspkr]
[  218.020132]
[  218.020136] Pid: 1677, comm: hald-addon-stor Tainted: P
3.0-ARCH #1 System manufacturer System Product Name/P5QL-ASUS-SE
[  218.020142] EIP: 0060:[<f8043e9b>] EFLAGS: 00010092 CPU: 1
[  218.020150] EIP is at scsi_prep_state_check+0xb/0x80 [scsi_mod]
[  218.020154] EAX: 00000000 EBX: eec33380 ECX: 00000001 EDX: eec33380
[  218.020157] ESI: f4f82100 EDI: 00000000 EBP: efb49b58 ESP: efb49b4c
[  218.020160]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  218.020163] Process hald-addon-stor (pid: 1677, ti=efb48000
task=efb2b9b0 task.ti=efb48000)
[  218.020166] Stack:
[  218.020168]  efb49b56 00000004 205b5c00 efb49b6c f804463d eec33380
f4f82100 f4f82100
[  218.020176]  efb49b7c f8044785 eec33380 f4f82100 efb49ba8 c02a9ea0
00000001 1fbfb097
[  218.020183]  00000000 f4f82100 eec33380 efb49ba8 00000000 f4f82100
eec33380 efb49bdc
[  218.020191] Call Trace:
[  218.020202]  [<f804463d>] scsi_setup_blk_pc_cmnd+0x1d/0x120 [scsi_mod]
[  218.020211]  [<f8044785>] scsi_prep_fn+0x45/0x50 [scsi_mod]
[  218.020218]  [<c02a9ea0>] blk_peek_request+0x90/0x210
[  218.020227]  [<f8044455>] scsi_request_fn+0x385/0x390 [scsi_mod]
[  218.020234]  [<c01d2323>] ? mempool_alloc_slab+0x13/0x20
[  218.020238]  [<c01d259b>] ? mempool_alloc+0x3b/0xf0
[  218.020243]  [<c02a3dd9>] __blk_run_queue+0x19/0x20
[  218.020248]  [<c02ad4a7>] blk_execute_rq_nowait+0x57/0x90
[  218.020252]  [<c02ad557>] blk_execute_rq+0x77/0x100
[  218.020256]  [<c02ad420>] ? blk_rq_map_user+0x220/0x220
[  218.020260]  [<c02a92e2>] ? get_request_wait+0x22/0x190
[  218.020265]  [<c0154b5b>] ? try_to_del_timer_sync+0x6b/0x100
[  218.020269]  [<c02a8e1b>] ? __freed_request+0xab/0x110
[  218.020273]  [<c0154c19>] ? del_timer_sync+0x29/0x50
[  218.020277]  [<c02a9aa3>] ? blk_get_request+0x63/0x90
[  218.020286]  [<f804349c>] scsi_execute+0xdc/0x120 [scsi_mod]
[  218.020296]  [<f8043569>] scsi_execute_req+0x89/0x100 [scsi_mod]
[  218.020303]  [<f8709fc6>] sd_revalidate_disk+0xe6/0x1cb0 [sd_mod]
[  218.020308]  [<c0140aa0>] ? try_to_wake_up+0x200/0x200
[  218.020313]  [<c021b4dc>] ? get_super+0x5c/0xb0
[  218.020318]  [<c02aff77>] ? __disk_unblock_events+0x47/0xd0
[  218.020322]  [<c02b0000>] ? __disk_unblock_events+0xd0/0xd0
[  218.020328]  [<c024668c>] check_disk_change+0x5c/0x70
[  218.020334]  [<f8707f53>] sd_open+0x83/0x160 [sd_mod]
[  218.020339]  [<c0247763>] __blkdev_get+0xa3/0x3b0
[  218.020343]  [<c0247abb>] blkdev_get+0x4b/0x2b0
[  218.020347]  [<c0247d73>] blkdev_open+0x53/0x70
[  218.020351]  [<c0217661>] __dentry_open+0x141/0x320
[  218.020355]  [<c0218a0e>] nameidata_to_filp+0x6e/0x80
[  218.020359]  [<c0247d20>] ? blkdev_get+0x2b0/0x2b0
[  218.020363]  [<c0225957>] do_last+0x2a7/0x810
[  218.020368]  [<c0226a7d>] path_openat+0x9d/0x350
[  218.020377]  [<f803f25d>] ?
ioctl_internal_command.constprop.4+0x4d/0x130 [scsi_mod]
[  218.020385]  [<f803d007>] ? scsi_device_put+0x47/0x50 [scsi_mod]
[  218.020390]  [<c0226d61>] do_filp_open+0x31/0x80
[  218.020395]  [<c0231bf3>] ? alloc_fd+0xa3/0xe0
[  218.020398]  [<c02234a5>] ? getname_flags+0xf5/0x130
[  218.020403]  [<c0218b06>] do_sys_open+0xe6/0x1b0
[  218.020407]  [<c016efd1>] ? ktime_get_ts+0xe1/0x110
[  218.020412]  [<c0218bfe>] sys_open+0x2e/0x40
[  218.020416]  [<c04543df>] sysenter_do_call+0x12/0x28
[  218.020419] Code: e7 89 f0 5b 5e 5d c3 89 f6 8d bc 27 00 00 00 00
55 89 e5 3e 8d 74 26 00 e8 a3 ff ff ff 5d c3 90 55 89 e5 83 ec 0c 3e
8d 74 26 00 <8b> 88 9c 03 00 00 83 f9 02 75 04 31 c0 c9 c3 83 e9 04 83
f9 04
[  218.020460] EIP: [<f8043e9b>] scsi_prep_state_check+0xb/0x80
[scsi_mod] SS:ESP 0068:efb49b4c
