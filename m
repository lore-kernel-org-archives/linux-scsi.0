From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71021] WARNING: CPU: 0 PID: 5517 at
 /build/buildd/linux-3.13.0/fs/sysfs/group.c:214
 sysfs_remove_group+0xc6/0xd0()
Date: Fri, 05 Feb 2016 17:01:26 +0000
Message-ID: <bug-71021-11613-8MiDp3SiDd@https.bugzilla.kernel.org/>
References: <bug-71021-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57655 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354AbcBERBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2016 12:01:32 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BDFE1203A1
	for <linux-scsi@vger.kernel.org>; Fri,  5 Feb 2016 17:01:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DF43920397
	for <linux-scsi@vger.kernel.org>; Fri,  5 Feb 2016 17:01:26 +0000 (UTC)
In-Reply-To: <bug-71021-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D71021

--- Comment #3 from D=C4=81vis <davispuh@gmail.com> ---
This still happens with 4.4.0
When removing disk

kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1913:phy3 Removed =
Device
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 3 PID: 16820 at /mnt/Linux/linux/fs/sysfs/group.c=
:237
sysfs_remove_group+0x8b/0x90()
kernel: sysfs group ffffffff818a3b60 not found for kobject 'end_device-=
7:7'
kernel: Modules linked in: fuse nf_conntrack_netbios_ns nf_conntrack_br=
oadcast
xt_tcpudp ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject=
_ipv4
xt_conntrack ip_set nfnetlink ebtable_bro
kernel:  snd_usbmidi_lib videobuf2_v4l2 snd_rawmidi snd_seq_device mous=
edev
gf128mul input_leds joydev led_class glue_helper snd_hda_codec_hdmi
snd_hda_codec_realtek videobuf2_core r8169 v4l2_commo
kernel:  libsas libahci scsi_transport_sas syscopyarea sysfillrect sysi=
mgblt
fb_sys_fops drm libata usbcore usb_common scsi_mod i2c_core wmi i8042 s=
erio
button ip_tables x_tables [last unloaded: dr
kernel: CPU: 3 PID: 16820 Comm: kworker/u16:8 Tainted: P        W  O  =20
4.4.0-ARCH-dirty #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 00000000ad666a1d ffff8801d3103c50 ffffffff812=
bf949
kernel:  ffff8801d3103c98 ffff8801d3103c88 ffffffff810764f2 00000000000=
00000
kernel:  ffffffff818a3b60 ffff88021cb30410 ffff8800cd642828 ffff8800cd6=
427f8
kernel: Call Trace:
kernel:  [<ffffffff812bf949>] dump_stack+0x4b/0x72
kernel:  [<ffffffff810764f2>] warn_slowpath_common+0x82/0xc0
kernel:  [<ffffffff8107658c>] warn_slowpath_fmt+0x5c/0x80
kernel:  [<ffffffff8124eeb8>] ? kernfs_find_and_get_ns+0x48/0x60
kernel:  [<ffffffff8125258b>] sysfs_remove_group+0x8b/0x90
kernel:  [<ffffffff813e8207>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813db6f8>] device_del+0x58/0x260
kernel:  [<ffffffff813db91e>] device_unregister+0x1e/0x60
kernel:  [<ffffffff812ab410>] bsg_unregister_queue+0x60/0xb0
kernel:  [<ffffffffa00e65f8>] sas_rphy_remove+0x48/0x70 [scsi_transport=
_sas]
kernel:  [<ffffffffa00e6632>] sas_rphy_delete+0x12/0x20 [scsi_transport=
_sas]
kernel:  [<ffffffffa0054823>] sas_destruct_devices+0x63/0x90 [libsas]
kernel:  [<ffffffff8108e15b>] process_one_work+0x14b/0x440
kernel:  [<ffffffff8108e498>] worker_thread+0x48/0x4a0
kernel:  [<ffffffff8108e450>] ? process_one_work+0x440/0x440
kernel:  [<ffffffff8108e450>] ? process_one_work+0x440/0x440
kernel:  [<ffffffff81093f38>] kthread+0xd8/0xf0
kernel:  [<ffffffff81093e60>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157cc0f>] ret_from_fork+0x3f/0x70
kernel:  [<ffffffff81093e60>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 640cb81c5c1e9aa7 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 4 PID: 16820 at /mnt/Linux/linux/fs/sysfs/group.c=
:237
sysfs_remove_group+0x8b/0x90()
kernel: sysfs group ffffffff818a3b60 not found for kobject 'end_device-=
7:7'
kernel: Modules linked in: fuse nf_conntrack_netbios_ns nf_conntrack_br=
oadcast
xt_tcpudp ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject=
_ipv4
xt_conntrack ip_set nfnetlink ebtable_bro
kernel:  snd_usbmidi_lib videobuf2_v4l2 snd_rawmidi snd_seq_device mous=
edev
gf128mul input_leds joydev led_class glue_helper snd_hda_codec_hdmi
snd_hda_codec_realtek videobuf2_core r8169 v4l2_commo
kernel:  libsas libahci scsi_transport_sas syscopyarea sysfillrect sysi=
mgblt
fb_sys_fops drm libata usbcore usb_common scsi_mod i2c_core wmi i8042 s=
erio
button ip_tables x_tables [last unloaded: dr
kernel: CPU: 4 PID: 16820 Comm: kworker/u16:8 Tainted: P        W  O  =20
4.4.0-ARCH-dirty #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 00000000ad666a1d ffff8801d3103bf8 ffffffff812=
bf949
kernel:  ffff8801d3103c40 ffff8801d3103c30 ffffffff810764f2 00000000000=
00000
kernel:  ffffffff818a3b60 ffff88021c6dd038 ffff8800cd642828 ffff8800cd6=
427f8
kernel: Call Trace:
kernel:  [<ffffffff812bf949>] dump_stack+0x4b/0x72
kernel:  [<ffffffff810764f2>] warn_slowpath_common+0x82/0xc0
kernel:  [<ffffffff8107658c>] warn_slowpath_fmt+0x5c/0x80
kernel:  [<ffffffff8124eeb8>] ? kernfs_find_and_get_ns+0x48/0x60
kernel:  [<ffffffff8117b4e2>] ? kfree_const+0x22/0x30
kernel:  [<ffffffff8125258b>] sysfs_remove_group+0x8b/0x90
kernel:  [<ffffffff813e8207>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813db6f8>] device_del+0x58/0x260
kernel:  [<ffffffff813dac79>] ? device_remove_file+0x19/0x20
kernel:  [<ffffffff813e507a>] attribute_container_class_device_del+0x1a=
/0x20
kernel:  [<ffffffff813e526e>] transport_remove_classdev+0x4e/0x60
kernel:  [<ffffffff813e5220>] ? transport_add_class_device+0x40/0x40
kernel:  [<ffffffff813e4c5e>] attribute_container_device_trigger+0xce/0=
xe0
kernel:  [<ffffffff813e51d5>] transport_remove_device+0x15/0x20
kernel:  [<ffffffffa00e6600>] sas_rphy_remove+0x50/0x70 [scsi_transport=
_sas]
kernel:  [<ffffffffa00e6632>] sas_rphy_delete+0x12/0x20 [scsi_transport=
_sas]
kernel:  [<ffffffffa0054823>] sas_destruct_devices+0x63/0x90 [libsas]
kernel:  [<ffffffff8108e15b>] process_one_work+0x14b/0x440
kernel:  [<ffffffff8108e498>] worker_thread+0x48/0x4a0
kernel:  [<ffffffff8108e450>] ? process_one_work+0x440/0x440
kernel:  [<ffffffff8108e450>] ? process_one_work+0x440/0x440
kernel:  [<ffffffff81093f38>] kthread+0xd8/0xf0
kernel:  [<ffffffff81093e60>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157cc0f>] ret_from_fork+0x3f/0x70
kernel:  [<ffffffff81093e60>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 640cb81c5c1e9aa8 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 4 PID: 16820 at /mnt/Linux/linux/fs/sysfs/group.c=
:237
sysfs_remove_group+0x8b/0x90()
kernel: sysfs group ffffffff818a3b60 not found for kobject 'end_device-=
7:7'
kernel: Modules linked in: fuse nf_conntrack_netbios_ns nf_conntrack_br=
oadcast
xt_tcpudp ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject=
_ipv4
xt_conntrack ip_set nfnetlink ebtable_bro
kernel:  snd_usbmidi_lib videobuf2_v4l2 snd_rawmidi snd_seq_device mous=
edev
gf128mul input_leds joydev led_class glue_helper snd_hda_codec_hdmi
snd_hda_codec_realtek videobuf2_core r8169 v4l2_commo
kernel:  libsas libahci scsi_transport_sas syscopyarea sysfillrect sysi=
mgblt
fb_sys_fops drm libata usbcore usb_common scsi_mod i2c_core wmi i8042 s=
erio
button ip_tables x_tables [last unloaded: dr
kernel: CPU: 4 PID: 16820 Comm: kworker/u16:8 Tainted: P        W  O  =20
4.4.0-ARCH-dirty #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 00000000ad666a1d ffff8801d3103c88 ffffffff812=
bf949
kernel:  ffff8801d3103cd0 ffff8801d3103cc0 ffffffff810764f2 00000000000=
00000
kernel:  ffffffff818a3b60 ffff88021c6dcc10 ffff8800cd642828 ffff8800cd6=
427f8
kernel: Call Trace:
kernel:  [<ffffffff812bf949>] dump_stack+0x4b/0x72
kernel:  [<ffffffff810764f2>] warn_slowpath_common+0x82/0xc0
kernel:  [<ffffffff8107658c>] warn_slowpath_fmt+0x5c/0x80
kernel:  [<ffffffff8124eeb8>] ? kernfs_find_and_get_ns+0x48/0x60
kernel:  [<ffffffff8117b4e2>] ? kfree_const+0x22/0x30
kernel:  [<ffffffff8125258b>] sysfs_remove_group+0x8b/0x90
kernel:  [<ffffffff813e8207>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813db6f8>] device_del+0x58/0x260
kernel:  [<ffffffffa00e6608>] sas_rphy_remove+0x58/0x70 [scsi_transport=
_sas]
kernel:  [<ffffffffa00e6632>] sas_rphy_delete+0x12/0x20 [scsi_transport=
_sas]
kernel:  [<ffffffffa0054823>] sas_destruct_devices+0x63/0x90 [libsas]
kernel:  [<ffffffff8108e15b>] process_one_work+0x14b/0x440
kernel:  [<ffffffff8108e498>] worker_thread+0x48/0x4a0
kernel:  [<ffffffff8108e450>] ? process_one_work+0x440/0x440
kernel:  [<ffffffff8108e450>] ? process_one_work+0x440/0x440
kernel:  [<ffffffff81093f38>] kthread+0xd8/0xf0
kernel:  [<ffffffff81093e60>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157cc0f>] ret_from_fork+0x3f/0x70
kernel:  [<ffffffff81093e60>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 640cb81c5c1e9aaa ]---
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1257:found dev[3:5=
] is
gone.
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 7 ctrl
sts=3D0x00111000.
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 7 irq sts=
 =3D
0x00000081
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1961:Get signature=
 time
out, reset phy 7
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 7 ctrl
sts=3D0x00000000.
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 7 irq sts=
 =3D
0x00001001
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 7 ctrl
sts=3D0x00111000.
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 7 irq sts=
 =3D
0x00000081
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_94xx.c 837:get all reg l=
ink rate
is 0x111000
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_94xx.c 842:get link rate=
 is 9
kernel: mvsas 0000:07:00.0: Phy3 : No sig fis
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1919:phy3 Attached=
 Device
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 7 ctrl
sts=3D0x00111000.
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 7 irq sts=
 =3D
0x00010000
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 2026:notify plug i=
n on
phy[3]
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_94xx.c 837:get all reg l=
ink rate
is 0x111000
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_94xx.c 842:get link rate=
 is 9
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1079:phy 7 attach =
dev info
is 20001
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 1081:phy 7 attach =
sas addr
is 7
kernel: /mnt/Linux/linux/drivers/scsi/mvsas/mv_sas.c 277:phy 7 byte dma=
ded.
kernel: sas: phy-7:7 added to port-7:7, phy_mask:0x8 ( 700000000000000)
kernel: sas: DOING DISCOVERY on port 7, pid:11432
kernel: sas: DONE DISCOVERY on port 7, pid:11432, result:0
kernel: sas: Enter sas_scsi_recover_host busy: 0 failed: 0
kernel: sas: ata7: end_device-7:0: dev error handler
kernel: sas: ata8: end_device-7:1: dev error handler
kernel: sas: ata9: end_device-7:2: dev error handler
kernel: sas: ata10: end_device-7:3: dev error handler
kernel: sas: ata11: end_device-7:4: dev error handler
kernel: sas: ata12: end_device-7:5: dev error handler
kernel: sas: ata13: end_device-7:6: dev error handler
kernel: sas: ata20: end_device-7:7: dev error handler
kernel: sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1

--=20
You are receiving this mail because:
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
