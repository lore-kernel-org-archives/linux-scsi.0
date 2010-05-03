From: Ramya Desai <ramya.desai@gmail.com>
Subject: sysfs: cannot create duplicate filename '/class/uas_host'
Date: Mon, 3 May 2010 19:12:51 +0530
Message-ID: <h2m3e7aae31005030642t1014c3e5ke7edbab2a95775c1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42794 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab0ECNmz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2010 09:42:55 -0400
Received: by vws19 with SMTP id 19so1666976vws.19
        for <linux-scsi@vger.kernel.org>; Mon, 03 May 2010 06:42:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Dear Experts,

When I attach two UAS devices to linux box, I got the following system
trace when I use my driver. I used the following snippet for
registering my device to the transport layer.

static DECLARE_TRANSPORT_CLASS(uas_host_class,
		"uas_host", NULL, NULL, NULL);

error = transport_class_register(&uas_host_class);

The transport_class_register() API fails and shows the following trace
when I connect the second device

Here, I can declare the transport class with different names by
changing the second parameter in the DECLARE_TRANSPORT_CLASS. However,
is there any other way to handle this? Is there any way to declare
unique name for each device?

Any ideas greatly helpful.

Thanks and Regards,
Ramya.

System Trace:

[  131.547243] WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0xd6/0x100()
[  131.547246] Hardware name: System Product Name
[  131.547247] sysfs: cannot create duplicate filename '/class/uas_host'
[  131.547249] Modules linked in: usb_storage usb_libusual binfmt_misc
ppdev bridge stp bnep video output lp parport snd_hda_codec_analog
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
snd_seq snd_timer snd_seq_device psmouse snd serio_raw usbhid
soundcore iTCO_wdt xhci_hcd iTCO_vendor_support snd_page_alloc pcspkr
ohci1394 ieee1394 ehci_hcd uhci_hcd sky2 usbcore floppy
[  131.547276] Pid: 672, comm: khubd Not tainted 2.6.34-rc4 #1
[  131.547278] Call Trace:
[  131.547282]  [<c024a0f6>] ? sysfs_add_one+0xd6/0x100
[  131.547284]  [<c024a0f6>] ? sysfs_add_one+0xd6/0x100
[  131.547288]  [<c014288c>] warn_slowpath_common+0x6c/0xc0
[  131.547291]  [<c024a0f6>] ? sysfs_add_one+0xd6/0x100
[  131.547293]  [<c0142926>] warn_slowpath_fmt+0x26/0x30
[  131.547296]  [<c024a0f6>] sysfs_add_one+0xd6/0x100
[  131.547299]  [<c024aa99>] create_dir+0x49/0x90
[  131.547302]  [<c024ab0b>] sysfs_create_dir+0x2b/0x50
[  131.547306]  [<c031deb2>] ? kobject_get+0x12/0x20
[  131.547309]  [<c031dfee>] kobject_add_internal+0xbe/0x1b0
[  131.547312]  [<c03273e3>] ? kvasprintf+0x43/0x60
[  131.547316]  [<c031e107>] kset_register+0x27/0x50
[  131.547320]  [<c03b62ac>] __class_register+0xfc/0x200
[  131.547326]  [<f8104ffe>] ? usb_stor_probe1+0x8fe/0x9c0 [usb_storage]
[  131.547330]  [<c03b8b5d>] transport_class_register+0xd/0x10
[  131.547334]  [<f8104c9a>] usb_stor_probe1+0x59a/0x9c0 [usb_storage]
[  131.547339]  [<c024a5a5>] ? sysfs_addrm_finish+0x15/0xc0
[  131.547345]  [<f8105124>] storage_probe+0x64/0x80 [usb_storage]
[  131.547358]  [<f8319a24>] usb_probe_interface+0xe4/0x170 [usbcore]
[  131.547365]  [<c03b54b9>] driver_probe_device+0x69/0x170
[  131.547374]  [<f8319071>] ? usb_match_id+0x41/0x60 [usbcore]
[  131.547378]  [<c03b5691>] __device_attach+0x41/0x50
[  131.547381]  [<c03b4a4b>] bus_for_each_drv+0x5b/0x80
[  131.547384]  [<c03b573b>] device_attach+0x6b/0x70
[  131.547387]  [<c03b5650>] ? __device_attach+0x0/0x50
[  131.547390]  [<c03b4845>] bus_probe_device+0x25/0x40
[  131.547393]  [<c03b2f47>] device_add+0x367/0x590
[  131.547396]  [<c03273e3>] ? kvasprintf+0x43/0x60
[  131.547403]  [<f8318a53>] usb_set_configuration+0x4a3/0x6e0 [usbcore]
[  131.547412]  [<f8321489>] generic_probe+0x39/0xb0 [usbcore]
[  131.547419]  [<f8319483>] usb_probe_device+0x43/0x50 [usbcore]
[  131.547427]  [<c03b54b9>] driver_probe_device+0x69/0x170
[  131.547431]  [<c03b5691>] __device_attach+0x41/0x50
[  131.547433]  [<c03b4a4b>] bus_for_each_drv+0x5b/0x80
[  131.547437]  [<c03b573b>] device_attach+0x6b/0x70
[  131.547440]  [<c03b5650>] ? __device_attach+0x0/0x50
[  131.547443]  [<c03b4845>] bus_probe_device+0x25/0x40
[  131.547445]  [<c03b2f47>] device_add+0x367/0x590
[  131.547450]  [<c0564c02>] ? printk+0x18/0x1e
[  131.547456]  [<f830dd4b>] ? show_string+0x4b/0x50 [usbcore]
[  131.547463]  [<f8320036>] ? usbdev_do_ioctl+0x5c6/0x1620 [usbcore]
[  131.547470]  [<f8310d9c>] usb_new_device+0x18c/0x1e0 [usbcore]
[  131.547477]  [<f8312b37>] hub_thread+0xd27/0x14a0 [usbcore]
[  131.547481]  [<c0560009>] ? init_centaur+0x13f/0x400
[  131.547485]  [<c012c7f0>] ? __wake_up_common+0x40/0x70
[  131.547488]  [<c015dd30>] ? autoremove_wake_function+0x0/0x50
[  131.547494]  [<f8311e10>] ? hub_thread+0x0/0x14a0 [usbcore]
[  131.547497]  [<c015d914>] kthread+0x74/0x80
[  131.547500]  [<c015d8a0>] ? kthread+0x0/0x80
[  131.547503]  [<c01033b6>] kernel_thread_helper+0x6/0x10
[  131.547506] ---[ end trace 27622b3e9393b1d6 ]---
[  131.547509] kobject_add_internal failed for uas_host with -EEXIST,
don't try to register things with the same name in the same directory.
[  131.547514] Pid: 672, comm: khubd Tainted: G        W  2.6.34-rc4 #1
[  131.547516] Call Trace:
[  131.547518]  [<c0564c02>] ? printk+0x18/0x1e
[  131.547521]  [<c031e032>] kobject_add_internal+0x102/0x1b0
[  131.547525]  [<c031e107>] kset_register+0x27/0x50
[  131.547528]  [<c03b62ac>] __class_register+0xfc/0x200
[  131.547532]  [<f8104ffe>] ? usb_stor_probe1+0x8fe/0x9c0 [usb_storage]
[  131.547536]  [<c03b8b5d>] transport_class_register+0xd/0x10
[  131.547540]  [<f8104c9a>] usb_stor_probe1+0x59a/0x9c0 [usb_storage]
[  131.547544]  [<c024a5a5>] ? sysfs_addrm_finish+0x15/0xc0
[  131.547548]  [<f8105124>] storage_probe+0x64/0x80 [usb_storage]
[  131.547556]  [<f8319a24>] usb_probe_interface+0xe4/0x170 [usbcore]
[  131.547561]  [<c03b54b9>] driver_probe_device+0x69/0x170
[  131.547567]  [<f8319071>] ? usb_match_id+0x41/0x60 [usbcore]
[  131.547571]  [<c03b5691>] __device_attach+0x41/0x50
[  131.547574]  [<c03b4a4b>] bus_for_each_drv+0x5b/0x80
[  131.547577]  [<c03b573b>] device_attach+0x6b/0x70
[  131.547580]  [<c03b5650>] ? __device_attach+0x0/0x50
[  131.547583]  [<c03b4845>] bus_probe_device+0x25/0x40
[  131.547585]  [<c03b2f47>] device_add+0x367/0x590
[  131.547588]  [<c03273e3>] ? kvasprintf+0x43/0x60
[  131.547595]  [<f8318a53>] usb_set_configuration+0x4a3/0x6e0 [usbcore]
[  131.547603]  [<f8321489>] generic_probe+0x39/0xb0 [usbcore]
[  131.547611]  [<f8319483>] usb_probe_device+0x43/0x50 [usbcore]
[  131.547615]  [<c03b54b9>] driver_probe_device+0x69/0x170
[  131.547619]  [<c03b5691>] __device_attach+0x41/0x50
[  131.547622]  [<c03b4a4b>] bus_for_each_drv+0x5b/0x80
[  131.547625]  [<c03b573b>] device_attach+0x6b/0x70
[  131.547629]  [<c03b5650>] ? __device_attach+0x0/0x50
[  131.547633]  [<c03b4845>] bus_probe_device+0x25/0x40
[  131.547637]  [<c03b2f47>] device_add+0x367/0x590
[  131.547641]  [<c0564c02>] ? printk+0x18/0x1e
[  131.547650]  [<f830dd4b>] ? show_string+0x4b/0x50 [usbcore]
[  131.547660]  [<f8320036>] ? usbdev_do_ioctl+0x5c6/0x1620 [usbcore]
[  131.547668]  [<f8310d9c>] usb_new_device+0x18c/0x1e0 [usbcore]
[  131.547675]  [<f8312b37>] hub_thread+0xd27/0x14a0 [usbcore]
[  131.547679]  [<c0560009>] ? init_centaur+0x13f/0x400
[  131.547682]  [<c012c7f0>] ? __wake_up_common+0x40/0x70
[  131.547685]  [<c015dd30>] ? autoremove_wake_function+0x0/0x50
[  131.547691]  [<f8311e10>] ? hub_thread+0x0/0x14a0 [usbcore]
[  131.547694]  [<c015d914>] kthread+0x74/0x80
[  131.547696]  [<c015d8a0>] ? kthread+0x0/0x80
[  131.547699]  [<c01033b6>] kernel_thread_helper+0x6/0x10
[  131.547701] usb-storage: storage_probe() failed
[  131.547703] usb-storage: -- usb_stor_release_resources
[  131.547706] BUG: unable to handle kernel NULL pointer dereference at 00000004
[  131.547709] IP: [<f8103e4b>] release_everything+0x12b/0x390 [usb_storage]
[  131.547714] *pde = 00000000
[  131.547716] Oops: 0000 [#1] SMP
[  131.547718] last sysfs file:
/sys/devices/pci0000:00/0000:00:09.0/0000:04:00.0/0000:05:01.0/0000:06:00.0/usb9/9-1/product
[  131.547722] Modules linked in: usb_storage usb_libusual binfmt_misc
ppdev bridge stp bnep video output lp parport snd_hda_codec_analog
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
snd_seq snd_timer snd_seq_device psmouse snd serio_raw usbhid
soundcore iTCO_wdt xhci_hcd iTCO_vendor_support snd_page_alloc pcspkr
ohci1394 ieee1394 ehci_hcd uhci_hcd sky2 usbcore floppy
[  131.547746]
[  131.547748] Pid: 672, comm: khubd Tainted: G        W  2.6.34-rc4
#1 P6T DELUXE V2/System Product Name
[  131.547751] EIP: 0060:[<f8103e4b>] EFLAGS: 00010246 CPU: 4
[  131.547754] EIP is at release_everything+0x12b/0x390 [usb_storage]
[  131.547757] EAX: 00000000 EBX: f71ae284 ECX: 00009999 EDX: 00000096
[  131.547759] ESI: f71ae000 EDI: f71ae284 EBP: c3505b98 ESP: c3505b74
[  131.547761]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  131.547764] Process khubd (pid: 672, ti=c3504000 task=c3466600
task.ti=c3504000)
[  131.547766] Stack:
[  131.547767]  f810cbd0 f810c0a4 00000000 f71ae000 f71ae284 c3505b98
00000000 f71ae000
[  131.547771] <0> f71ae284 c3505bf0 f8104cb4 f810f654 f810c0f1
0000000f c3206c84 0000000f
[  131.547776] <0> 00000047 205b5bc8 31333120 f6aed400 5d313637
c3500020 f807bbf8 f71ae284
[  131.547781] Call Trace:
[  131.547785]  [<f8104cb4>] ? usb_stor_probe1+0x5b4/0x9c0 [usb_storage]
[  131.547789]  [<c024a5a5>] ? sysfs_addrm_finish+0x15/0xc0
[  131.547793]  [<f8105124>] ? storage_probe+0x64/0x80 [usb_storage]
[  131.547801]  [<f8319a24>] ? usb_probe_interface+0xe4/0x170 [usbcore]
[  131.547805]  [<c03b54b9>] ? driver_probe_device+0x69/0x170
[  131.547812]  [<f8319071>] ? usb_match_id+0x41/0x60 [usbcore]
[  131.547815]  [<c03b5691>] ? __device_attach+0x41/0x50
[  131.547819]  [<c03b4a4b>] ? bus_for_each_drv+0x5b/0x80
[  131.547822]  [<c03b573b>] ? device_attach+0x6b/0x70
[  131.547825]  [<c03b5650>] ? __device_attach+0x0/0x50
[  131.547828]  [<c03b4845>] ? bus_probe_device+0x25/0x40
[  131.547830]  [<c03b2f47>] ? device_add+0x367/0x590
[  131.547833]  [<c03273e3>] ? kvasprintf+0x43/0x60
[  131.547841]  [<f8318a53>] ? usb_set_configuration+0x4a3/0x6e0 [usbcore]
[  131.547850]  [<f8321489>] ? generic_probe+0x39/0xb0 [usbcore]
[  131.547861]  [<f8319483>] ? usb_probe_device+0x43/0x50 [usbcore]
[  131.547867]  [<c03b54b9>] ? driver_probe_device+0x69/0x170
[  131.547872]  [<c03b5691>] ? __device_attach+0x41/0x50
[  131.547876]  [<c03b4a4b>] ? bus_for_each_drv+0x5b/0x80
[  131.547881]  [<c03b573b>] ? device_attach+0x6b/0x70
[  131.547885]  [<c03b5650>] ? __device_attach+0x0/0x50
[  131.547889]  [<c03b4845>] ? bus_probe_device+0x25/0x40
[  131.547892]  [<c03b2f47>] ? device_add+0x367/0x590
[  131.547895]  [<c0564c02>] ? printk+0x18/0x1e
[  131.547902]  [<f830dd4b>] ? show_string+0x4b/0x50 [usbcore]
[  131.547909]  [<f8320036>] ? usbdev_do_ioctl+0x5c6/0x1620 [usbcore]
[  131.547916]  [<f8310d9c>] ? usb_new_device+0x18c/0x1e0 [usbcore]
[  131.547923]  [<f8312b37>] ? hub_thread+0xd27/0x14a0 [usbcore]
[  131.547927]  [<c0560009>] ? init_centaur+0x13f/0x400
[  131.547930]  [<c012c7f0>] ? __wake_up_common+0x40/0x70
[  131.547934]  [<c015dd30>] ? autoremove_wake_function+0x0/0x50
[  131.547940]  [<f8311e10>] ? hub_thread+0x0/0x14a0 [usbcore]
[  131.547943]  [<c015d914>] ? kthread+0x74/0x80
[  131.547946]  [<c015d8a0>] ? kthread+0x0/0x80
[  131.547948]  [<c01033b6>] ? kernel_thread_helper+0x6/0x10
[  131.547950] Code: 00 00 00 e8 38 97 20 00 8b 43 18 31 d2 83 c0 1c
e8 5b 13 2b c8 8d 83 7c fd ff ff e8 b0 20 2c c8 83 c4 18 5b 5e 5f 5d
c3 8b 43 18 <8b> 40 04 0f b6 50 04 8b 40 0c 83 ea 01 e8 f3 f9 ff ff 85
c0 89
[  131.547975] EIP: [<f8103e4b>] release_everything+0x12b/0x390
[usb_storage] SS:ESP 0068:c3505b74
[  131.547980] CR2: 0000000000000004
[  131.547982] ---[ end trace 27622b3e9393b1d7 ]---
