From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71021] WARNING: CPU: 0 PID: 5517 at
 /build/buildd/linux-3.13.0/fs/sysfs/group.c:214
 sysfs_remove_group+0xc6/0xd0()
Date: Sat, 04 Jul 2015 00:14:12 +0000
Message-ID: <bug-71021-11613-RBU25lipdM@https.bugzilla.kernel.org/>
References: <bug-71021-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51802 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683AbbGDAOX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2015 20:14:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1975520827
	for <linux-scsi@vger.kernel.org>; Sat,  4 Jul 2015 00:14:20 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A799220829
	for <linux-scsi@vger.kernel.org>; Sat,  4 Jul 2015 00:14:12 +0000 (UTC)
In-Reply-To: <bug-71021-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D71021

D=C4=81vis <davispuh@gmail.com> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |davispuh@gmail.com

--- Comment #2 from D=C4=81vis <davispuh@gmail.com> ---
I've similar call trace on 4.0.7. I did "echo 1 >
/sys/block/sde/device/delete", removed that disk and removed another di=
sk
without it. Then saw this in journal:


kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 3 PID: 7857 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81893860 not found for kobject 'end_device-=
7:3'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_c=
onntrack
ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables
ip6table_mangle ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ip=
v6
ip6table_raw ip6table_security ip6table_filter ip6_tables iptable_mangl=
e
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conn=
track
iptable_raw iptable_security iptable_filter nls_utf8 nls_cp775 vfat fat
saa7134_alsa tuner_simple tuner_types tda8290 tuner nvidia(PO) saa7134
videobuf2_dma_sg tveeprom rc_core videobuf2_memops videobuf2_core edac_=
core
edac_mce_amd joydev mousedev mxm_wmi snd_usb_audio snd_usbmidi_lib snd_=
rawmidi
v4l2_common videodev snd_seq_device kvm_amd evdev kvm serio_raw
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd r8169 mac_hid pc=
spkr
fam15h_power tpm_infineon mii k10temp tpm_tis wmi snd_hda_codec_hdmi dr=
m tpm
snd_hda_codec_realtek sp5100_tco snd_hda_codec_generic acpi_cpufreq
snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_ti=
mer snd
soundcore button shpchp processor i2c_piix4 i2c_core sch_fq_codel ip_ta=
bles
x_tables btrfs xor raid6_pq hid_generic usbhid hid sd_mod atkbd libps2
crc32c_intel firewire_ohci firewire_core crc_itu_t ohci_pci ahci ehci_p=
ci
ohci_hcd libahci ehci_hcd mvsas libsas scsi_transport_sas xhci_pci liba=
ta
xhci_hcd usbcore scsi_mod usb_common i8042 serio
kernel: CPU: 3 PID: 7857 Comm: kworker/u16:4 Tainted: P           O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000001fac2762 ffff880167ccbbf8 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880167ccbc50 ffff880167ccbc38 ffffffff810=
74e7a
kernel:  ffff880167ccbc38 0000000000000000 ffffffff81893860 ffff880222e=
77810
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813ef747>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813e2d58>] device_del+0x58/0x270
kernel:  [<ffffffff813e2f92>] device_unregister+0x22/0x80
kernel:  [<ffffffff812abd60>] bsg_unregister_queue+0x60/0xc0
kernel:  [<ffffffffa00587dc>] sas_rphy_remove+0x4c/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff81576a87>] ? schedule+0x37/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041c8 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 3 PID: 7857 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81893860 not found for kobject 'end_device-=
7:3'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT ...
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ...
kernel: CPU: 3 PID: 7857 Comm: kworker/u16:4 Tainted: P        W  O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000001fac2762 ffff880167ccbb88 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880167ccbbe0 ffff880167ccbbc8 ffffffff810=
74e7a
kernel:  ffff880167ccbbc8 0000000000000000 ffffffff81893860 ffff880222e=
c6838
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813ef747>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813e2d58>] device_del+0x58/0x270
kernel:  [<ffffffff813e2319>] ? device_remove_file+0x19/0x20
kernel:  [<ffffffff813ec67e>] attribute_container_class_device_del+0x1e=
/0x30
kernel:  [<ffffffff813ec892>] transport_remove_classdev+0x52/0x60
kernel:  [<ffffffff813ec840>] ? transport_add_class_device+0x40/0x40
kernel:  [<ffffffff813ec1ec>] attribute_container_device_trigger+0xdc/0=
xf0
kernel:  [<ffffffff813ec7f5>] transport_remove_device+0x15/0x20
kernel:  [<ffffffffa00587e4>] sas_rphy_remove+0x54/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff81576a87>] ? schedule+0x37/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041c9 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 3 PID: 7857 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81893860 not found for kobject 'end_device-=
7:3'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT ...
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ...
kernel: CPU: 3 PID: 7857 Comm: kworker/u16:4 Tainted: P        W  O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000001fac2762 ffff880167ccbb88 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880167ccbbe0 ffff880167ccbbc8 ffffffff810=
74e7a
kernel:  ffff880167ccbbc8 0000000000000000 ffffffff81893860 ffff880222e=
c6c38
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813ef747>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813e2d58>] device_del+0x58/0x270
kernel:  [<ffffffff813e2319>] ? device_remove_file+0x19/0x20
kernel:  [<ffffffff813ec67e>] attribute_container_class_device_del+0x1e=
/0x30
kernel:  [<ffffffff813ec892>] transport_remove_classdev+0x52/0x60
kernel:  [<ffffffff813ec840>] ? transport_add_class_device+0x40/0x40
kernel:  [<ffffffff813ec1ec>] attribute_container_device_trigger+0xdc/0=
xf0
kernel:  [<ffffffff813ec7f5>] transport_remove_device+0x15/0x20
kernel:  [<ffffffffa00587e4>] sas_rphy_remove+0x54/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff81576a87>] ? schedule+0x37/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041ca ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 3 PID: 7857 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81893860 not found for kobject 'end_device-=
7:3'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT ...
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ...
kernel: CPU: 3 PID: 7857 Comm: kworker/u16:4 Tainted: P        W  O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000001fac2762 ffff880167ccbc38 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880167ccbc90 ffff880167ccbc78 ffffffff810=
74e7a
kernel:  ffff880167ccbc78 0000000000000000 ffffffff81893860 ffff880222e=
c6410
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813ef747>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813e2d58>] device_del+0x58/0x270
kernel:  [<ffffffffa00587ec>] sas_rphy_remove+0x5c/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff81576a87>] ? schedule+0x37/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041cb ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 4 PID: 8386 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81893860 not found for kobject '7:0:5:0'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT ...
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ...
kernel: CPU: 4 PID: 8386 Comm: kworker/u16:9 Tainted: P        W  O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000008e53c616 ffff880080d67b68 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880080d67bc0 ffff880080d67ba8 ffffffff810=
74e7a
kernel:  ffff880080d67ba8 0000000000000000 ffffffff81893860 ffff880222e=
f0010
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813ef747>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813e2d58>] device_del+0x58/0x270
kernel:  [<ffffffff813e2f92>] device_unregister+0x22/0x80
kernel:  [<ffffffff812abd60>] bsg_unregister_queue+0x60/0xc0
kernel:  [<ffffffffa008b461>] __scsi_remove_device+0xb1/0xe0 [scsi_mod]
kernel:  [<ffffffffa008b4b6>] scsi_remove_device+0x26/0x40 [scsi_mod]
kernel:  [<ffffffffa008b66c>] scsi_remove_target+0x16c/0x240 [scsi_mod]
kernel:  [<ffffffffa00587fd>] sas_rphy_remove+0x6d/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041cc ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 1 PID: 8386 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81893860 not found for kobject '7:0:5:0'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT ...
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ...
kernel: CPU: 1 PID: 8386 Comm: kworker/u16:9 Tainted: P        W  O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000008e53c616 ffff880080d67b88 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880080d67be0 ffff880080d67bc8 ffffffff810=
74e7a
kernel:  ffff880080d67bc8 0000000000000000 ffffffff81893860 ffff880222c=
fe428
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813ef747>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813e2d58>] device_del+0x58/0x270
kernel:  [<ffffffff813e2f92>] device_unregister+0x22/0x80
kernel:  [<ffffffffa008b46d>] __scsi_remove_device+0xbd/0xe0 [scsi_mod]
kernel:  [<ffffffffa008b4b6>] scsi_remove_device+0x26/0x40 [scsi_mod]
kernel:  [<ffffffffa008b66c>] scsi_remove_target+0x16c/0x240 [scsi_mod]
kernel:  [<ffffffffa00587fd>] sas_rphy_remove+0x6d/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041cd ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 1 PID: 8386 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81893860 not found for kobject '7:0:5:0'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT ...
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ...
kernel: CPU: 1 PID: 8386 Comm: kworker/u16:9 Tainted: P        W  O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000008e53c616 ffff880080d67ba8 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880080d67c00 ffff880080d67be8 ffffffff810=
74e7a
kernel:  ffff880080d67be8 0000000000000000 ffffffff81893860 ffff880222c=
fe178
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813ef747>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813e2d58>] device_del+0x58/0x270
kernel:  [<ffffffffa008b47d>] __scsi_remove_device+0xcd/0xe0 [scsi_mod]
kernel:  [<ffffffffa008b4b6>] scsi_remove_device+0x26/0x40 [scsi_mod]
kernel:  [<ffffffffa008b66c>] scsi_remove_target+0x16c/0x240 [scsi_mod]
kernel:  [<ffffffffa00587fd>] sas_rphy_remove+0x6d/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041ce ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 1 PID: 8386 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81893860 not found for kobject '7:0:5:0'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT ...
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ...
kernel: CPU: 1 PID: 8386 Comm: kworker/u16:9 Tainted: P        W  O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000008e53c616 ffff880080d67ab8 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880080d67b10 ffff880080d67af8 ffffffff810=
74e7a
kernel:  ffff880080d67af8 0000000000000000 ffffffff81893860 ffff8802232=
30c20
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813ef747>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813e2d58>] device_del+0x58/0x270
kernel:  [<ffffffffa0104e25>] sd_remove+0x55/0xc0 [sd_mod]
kernel:  [<ffffffff813e725f>] __device_release_driver+0x7f/0xf0
kernel:  [<ffffffff813e72f3>] device_release_driver+0x23/0x30
kernel:  [<ffffffff813e6ba8>] bus_remove_device+0x108/0x180
kernel:  [<ffffffff813e2e41>] device_del+0x141/0x270
kernel:  [<ffffffffa008b47d>] __scsi_remove_device+0xcd/0xe0 [scsi_mod]
kernel:  [<ffffffffa008b4b6>] scsi_remove_device+0x26/0x40 [scsi_mod]
kernel:  [<ffffffffa008b66c>] scsi_remove_target+0x16c/0x240 [scsi_mod]
kernel:  [<ffffffffa00587fd>] sas_rphy_remove+0x6d/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041cf ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 1 PID: 8386 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff818561a0 not found for kobject 'sdg'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT ...
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ...
kernel: CPU: 1 PID: 8386 Comm: kworker/u16:9 Tainted: P        W  O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000008e53c616 ffff880080d67aa8 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880080d67b00 ffff880080d67ae8 ffffffff810=
74e7a
kernel:  ffff880080d67ae8 0000000000000000 ffffffff818561a0 ffff8802232=
30880
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff81137144>] blk_trace_remove_sysfs+0x14/0x20
kernel:  [<ffffffff812952a5>] blk_unregister_queue+0x65/0xa0
kernel:  [<ffffffff812a34be>] del_gendisk+0x12e/0x240
kernel:  [<ffffffffa0104e31>] sd_remove+0x61/0xc0 [sd_mod]
kernel:  [<ffffffff813e725f>] __device_release_driver+0x7f/0xf0
kernel:  [<ffffffff813e72f3>] device_release_driver+0x23/0x30
kernel:  [<ffffffff813e6ba8>] bus_remove_device+0x108/0x180
kernel:  [<ffffffff813e2e41>] device_del+0x141/0x270
kernel:  [<ffffffffa008b47d>] __scsi_remove_device+0xcd/0xe0 [scsi_mod]
kernel:  [<ffffffffa008b4b6>] scsi_remove_device+0x26/0x40 [scsi_mod]
kernel:  [<ffffffffa008b66c>] scsi_remove_target+0x16c/0x240 [scsi_mod]
kernel:  [<ffffffffa00587fd>] sas_rphy_remove+0x6d/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041d0 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 1 PID: 8386 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81893860 not found for kobject 'sdg'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT ...
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ...
kernel: CPU: 1 PID: 8386 Comm: kworker/u16:9 Tainted: P        W  O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000008e53c616 ffff880080d67a68 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880080d67ac0 ffff880080d67aa8 ffffffff810=
74e7a
kernel:  ffff880080d67aa8 0000000000000000 ffffffff81893860 ffff8802232=
30880
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813ef747>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813e2d58>] device_del+0x58/0x270
kernel:  [<ffffffff813f1406>] ? pm_runtime_set_memalloc_noio+0xa6/0xc0
kernel:  [<ffffffff812a3598>] del_gendisk+0x208/0x240
kernel:  [<ffffffffa0104e31>] sd_remove+0x61/0xc0 [sd_mod]
kernel:  [<ffffffff813e725f>] __device_release_driver+0x7f/0xf0
kernel:  [<ffffffff813e72f3>] device_release_driver+0x23/0x30
kernel:  [<ffffffff813e6ba8>] bus_remove_device+0x108/0x180
kernel:  [<ffffffff813e2e41>] device_del+0x141/0x270
kernel:  [<ffffffffa008b47d>] __scsi_remove_device+0xcd/0xe0 [scsi_mod]
kernel:  [<ffffffffa008b4b6>] scsi_remove_device+0x26/0x40 [scsi_mod]
kernel:  [<ffffffffa008b66c>] scsi_remove_target+0x16c/0x240 [scsi_mod]
kernel:  [<ffffffffa00587fd>] sas_rphy_remove+0x6d/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041d1 ]---
kernel: sd 7:0:5:0: [sdg] Synchronizing SCSI cache
kernel: sd 7:0:5:0: [sdg] Synchronize Cache(10) failed: Result: hostbyt=
e=3D0x04
driverbyte=3D0x00
kernel: sd 7:0:5:0: [sdg] Stopping disk
kernel: sd 7:0:5:0: [sdg] Start/Stop Unit failed: Result: hostbyte=3D0x=
04
driverbyte=3D0x00
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 4 PID: 8386 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81893860 not found for kobject 'target7:0:5=
'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT ...
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ...
kernel: CPU: 4 PID: 8386 Comm: kworker/u16:9 Tainted: P        W  O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000008e53c616 ffff880080d67bb8 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880080d67c10 ffff880080d67bf8 ffffffff810=
74e7a
kernel:  ffff880080d67bf8 0000000000000000 ffffffff81893860 ffff8800c9b=
b1438
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813ef747>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813e2d58>] device_del+0x58/0x270
kernel:  [<ffffffffa00874b7>] scsi_target_reap_ref_put+0x37/0x50 [scsi_=
mod]
kernel:  [<ffffffffa0089337>] scsi_target_reap+0x17/0x30 [scsi_mod]
kernel:  [<ffffffffa008b6d1>] scsi_remove_target+0x1d1/0x240 [scsi_mod]
kernel:  [<ffffffffa00587fd>] sas_rphy_remove+0x6d/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041d2 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 4 PID: 8386 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81893860 not found for kobject 'end_device-=
7:5'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT ...
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ...
kernel: CPU: 4 PID: 8386 Comm: kworker/u16:9 Tainted: P        W  O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000008e53c616 ffff880080d67bf8 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880080d67c50 ffff880080d67c38 ffffffff810=
74e7a
kernel:  ffff880080d67c38 0000000000000000 ffffffff81893860 ffff8800c9b=
b2410
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813ef747>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813e2d58>] device_del+0x58/0x270
kernel:  [<ffffffffa00874bf>] ? scsi_target_reap_ref_put+0x3f/0x50 [scs=
i_mod]
kernel:  [<ffffffff813e2f92>] device_unregister+0x22/0x80
kernel:  [<ffffffff812abd60>] bsg_unregister_queue+0x60/0xc0
kernel:  [<ffffffffa00587dc>] sas_rphy_remove+0x4c/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041d3 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 4 PID: 8386 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81893860 not found for kobject 'end_device-=
7:5'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT ...
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ...
kernel: CPU: 4 PID: 8386 Comm: kworker/u16:9 Tainted: P        W  O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000008e53c616 ffff880080d67b88 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880080d67be0 ffff880080d67bc8 ffffffff810=
74e7a
kernel:  ffff880080d67bc8 0000000000000000 ffffffff81893860 ffff880222f=
a8038
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813ef747>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813e2d58>] device_del+0x58/0x270
kernel:  [<ffffffff813e2319>] ? device_remove_file+0x19/0x20
kernel:  [<ffffffff813ec67e>] attribute_container_class_device_del+0x1e=
/0x30
kernel:  [<ffffffff813ec892>] transport_remove_classdev+0x52/0x60
kernel:  [<ffffffff813ec840>] ? transport_add_class_device+0x40/0x40
kernel:  [<ffffffff813ec1ec>] attribute_container_device_trigger+0xdc/0=
xf0
kernel:  [<ffffffff813ec7f5>] transport_remove_device+0x15/0x20
kernel:  [<ffffffffa00587e4>] sas_rphy_remove+0x54/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041d4 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 4 PID: 8386 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81893860 not found for kobject 'end_device-=
7:5'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT ...
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ...
kernel: CPU: 4 PID: 8386 Comm: kworker/u16:9 Tainted: P        W  O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000008e53c616 ffff880080d67b88 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880080d67be0 ffff880080d67bc8 ffffffff810=
74e7a
kernel:  ffff880080d67bc8 0000000000000000 ffffffff81893860 ffff880222f=
a8438
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813ef747>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813e2d58>] device_del+0x58/0x270
kernel:  [<ffffffff813e2319>] ? device_remove_file+0x19/0x20
kernel:  [<ffffffff813ec67e>] attribute_container_class_device_del+0x1e=
/0x30
kernel:  [<ffffffff813ec892>] transport_remove_classdev+0x52/0x60
kernel:  [<ffffffff813ec840>] ? transport_add_class_device+0x40/0x40
kernel:  [<ffffffff813ec1ec>] attribute_container_device_trigger+0xdc/0=
xf0
kernel:  [<ffffffff813ec7f5>] transport_remove_device+0x15/0x20
kernel:  [<ffffffffa00587e4>] sas_rphy_remove+0x54/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041d5 ]---
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 4 PID: 8386 at fs/sysfs/group.c:219
sysfs_remove_group+0xa1/0xb0()
kernel: sysfs group ffffffff81893860 not found for kobject 'end_device-=
7:5'
kernel: Modules linked in: nls_iso8859_4 nls_iso8859_1 nls_cp437 xt_tcp=
udp
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT ...
kernel:  media crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_=
intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ...
kernel: CPU: 4 PID: 8386 Comm: kworker/u16:9 Tainted: P        W  O  =20
4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 000000008e53c616 ffff880080d67c38 ffffffff815=
74ec3
kernel:  0000000000000000 ffff880080d67c90 ffff880080d67c78 ffffffff810=
74e7a
kernel:  ffff880080d67c78 0000000000000000 ffffffff81893860 ffff880222e=
c7c10
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124fc0c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff812533c1>] sysfs_remove_group+0xa1/0xb0
kernel:  [<ffffffff813ef747>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813e2d58>] device_del+0x58/0x270
kernel:  [<ffffffffa00587ec>] sas_rphy_remove+0x5c/0x80 [scsi_transport=
_sas]
kernel:  [<ffffffffa0058826>] sas_rphy_delete+0x16/0x30 [scsi_transport=
_sas]
kernel:  [<ffffffffa00a3a95>] sas_destruct_devices+0x65/0x90 [libsas]
kernel:  [<ffffffff8108dadb>] process_one_work+0x14b/0x470
kernel:  [<ffffffff8108e228>] worker_thread+0x48/0x4b0
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff8108e1e0>] ? init_pwq.part.7+0x10/0x10
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 82d1791291d041d6 ]---




Those disks were removed from HighPoint RocketRAID 2760 controller usin=
g mvsas
driver
06:00.0 RAID bus controller [0104]: HighPoint Technologies, Inc. Device
[1103:2760] (rev c2)

--=20
You are receiving this mail because:
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
