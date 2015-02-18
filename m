From: Tomas Winkler <tomasw@gmail.com>
Subject: BUG v3.19: reference count warning when removing scsi_debug device
Date: Wed, 18 Feb 2015 15:22:28 +0200
Message-ID: <CA+i0qc4TL8XiFCE0Gkk8NScQnko_yi60t+wGdp2oSR99ni6Kwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:33124 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbbBRNWa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Feb 2015 08:22:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>

reference count warning when removing scsi_debug device

ARNING: CPU: 2 PID: 16732 at kernel/module.c:954 module_put+0xc9/0xd0()
[150550.918033] Modules linked in: scsi_debug(-) pci_stub vboxpci(O)
vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nfsv3 rfcomm bnep bluetooth
rpcsec_gss_krb5 nfsv4 hid_generic usbhid pl2303 hid usbserial
snd_hda_codec_hdmi i915 x86_pkg_temp_thermal coretemp kvm_intel
drm_kms_helper kvm drm nfsd snd_hda_codec_realtek
snd_hda_codec_generic ghash_clmulni_intel snd_hda_intel aesni_intel
aes_x86_64 ablk_helper cryptd snd_hda_controller snd_hda_codec
auth_rpcgss snd_hwdep snd_pcm oid_registry nfs_acl nfs snd_seq_midi
snd_seq_midi_event snd_rawmidi snd_seq lrw gf128mul snd_seq_device
snd_timer snd glue_helper microcode mei_me psmouse i2c_algo_bit mei
video tpm_infineon tpm_tis r8169 soundcore serio_raw mii lockd lpc_ich
mac_hid grace sunrpc fscache binfmt_misc nls_iso8859_1 parport_pc
ppdev lp parport [last unloaded: scsi_debug]
[150550.918069] CPU: 2 PID: 16732 Comm: modprobe Tainted: G        W
IO   3.19.0-rc5+ #1
[150550.918070] Hardware name: Gigabyte Technology Co., Ltd.
H87M-D3H/H87M-D3H, BIOS F6 08/03/2013
[150550.918071]  ffffffff81a85373 ffff880229f9bb88 ffffffff8175a6cb
0000000000000000
[150550.918072]  0000000000000000 ffff880229f9bbc8 ffffffff8105382a
ffffffff81ccf320
[150550.918074]  ffffffffa070fba0 ffffffffa070fba0 ffff88022a136010
0000000000800010
[150550.918076] Call Trace:
[150550.918081]  [<ffffffff8175a6cb>] dump_stack+0x4c/0x65
[150550.918084]  [<ffffffff8105382a>] warn_slowpath_common+0x8a/0xc0
[150550.918086]  [<ffffffff8105391a>] warn_slowpath_null+0x1a/0x20
[150550.918088]  [<ffffffff810d6879>] module_put+0xc9/0xd0
[150550.918090]  [<ffffffff814f6e18>] scsi_device_put+0x48/0x50
[150550.918092]  [<ffffffff8150e5c2>] scsi_disk_put+0x32/0x50
[150550.918093]  [<ffffffff8150f8cc>] sd_shutdown+0x8c/0x150
[150550.918095]  [<ffffffff8150f9f9>] sd_remove+0x69/0xc0
[150550.918097]  [<ffffffff814b83ff>] __device_release_driver+0x7f/0xf0
[150550.918099]  [<ffffffff814b8495>] device_release_driver+0x25/0x40
[150550.918101]  [<ffffffff814b7d34>] bus_remove_device+0x124/0x1b0
[150550.918103]  [<ffffffff814b43de>] device_del+0x13e/0x250
[150550.918105]  [<ffffffff8150796d>] __scsi_remove_device+0xcd/0xe0
[150550.918107]  [<ffffffff81505f4f>] scsi_forget_host+0x6f/0x80
[150550.918108]  [<ffffffff814f85a6>] scsi_remove_host+0x86/0x140
[150550.918112]  [<ffffffffa0706a29>] sdebug_driver_remove+0x29/0x90
[scsi_debug]
[150550.918113]  [<ffffffff814b83ff>] __device_release_driver+0x7f/0xf0
[150550.918114]  [<ffffffff814b8495>] device_release_driver+0x25/0x40
[150550.918116]  [<ffffffff814b7d34>] bus_remove_device+0x124/0x1b0
[150550.918117]  [<ffffffff814b43de>] device_del+0x13e/0x250
[150550.918119]  [<ffffffff814b4512>] device_unregister+0x22/0x70
[150550.918121]  [<ffffffffa0706390>] sdebug_remove_adapter+0x50/0x80
[scsi_debug]
[150550.918123]  [<ffffffffa070b825>] scsi_debug_exit+0x84/0x85f [scsi_debug]
[150550.918125]  [<ffffffff810d8bac>] SyS_delete_module+0x18c/0x210
[150550.918129]  [<ffffffff81763fa7>] ? int_with_check+0x27/0x69
[150550.918131]  [<ffffffff81763d92>] system_call_fastpath+0x12/0x17
[150550.918132] ---[ end trace 1f300c62b0658728 ]---
[150550.935994] sd 7:0:0:1: [sdc] Synchronizing SCSI cache
[150550.936017] ------------[ cut here ]------------
