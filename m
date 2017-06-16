From: Will Simoneau <simoneau@hangar16.net>
Subject: mptsas crash on expander hot-remove
Date: Fri, 16 Jun 2017 19:57:08 -0400
Message-ID: <20170616235708.GA19825@hangar16.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dreadnought.hangar16.net ([97.107.138.131]:50582 "EHLO
        dreadnought.hangar16.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752371AbdFQACM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2017 20:02:12 -0400
Received: from mira ([172.16.0.2] helo=mira.hangar16.net)
        by dreadnought.hangar16.net with esmtp (Exim 4.84)
        (envelope-from <simoneau@hangar16.net>)
        id 1dM16z-0005uv-Eo
        for linux-scsi@vger.kernel.org; Fri, 16 Jun 2017 19:57:09 -0400
Received: from marauder (marauder [192.168.1.66])
        by mira.hangar16.net (Postfix) with SMTP id 3D6B6C3DCAA3
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jun 2017 19:57:08 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I've got a disk box with a SAS expander connected to a card based on the=20
LSI SAS1068E chip. I recently upgraded the machine from 4.5.7 to 4.11.5,=20
and now disconnecting (i.e. hot removing) the SAS expander from the HBA=20
results in fireworks like this:

[ 4738.044119]  end_device-6:0:0: mptsas: ioc2: removing sata device: fw_ch=
annel 0, fw_id 8, phy 0,sas_addr 0x5001940000752200
[ 4738.044126]  phy-6:0:8: mptsas: ioc2: delete phy 0, phy-obj (0xffff883f2=
1a80c00)
[ 4738.044143]  port-6:0:0: mptsas: ioc2: delete port 0, sas_addr (0x500194=
0000752200)
[ 4738.051435]  end_device-6:0:3: mptsas: ioc2: removing ssp device: fw_cha=
nnel 0, fw_id 13, phy 5,sas_addr 0x5000c5000184240d
[ 4738.051442]  phy-6:0:13: mptsas: ioc2: delete phy 5, phy-obj (0xffff883f=
21a86c00)
[ 4738.051456]  port-6:0:3: mptsas: ioc2: delete port 3, sas_addr (0x5000c5=
000184240d)
[ 4738.054796]  end_device-6:0:2: mptsas: ioc2: removing sata device: fw_ch=
annel 0, fw_id 12, phy 4,sas_addr 0x5001940000752204
[ 4738.054801]  phy-6:0:12: mptsas: ioc2: delete phy 4, phy-obj (0xffff883f=
21a85400)
[ 4738.054814]  port-6:0:2: mptsas: ioc2: delete port 2, sas_addr (0x500194=
0000752204)
[ 4738.062425]  end_device-6:0:1: mptsas: ioc2: removing ssp device: fw_cha=
nnel 0, fw_id 9, phy 1,sas_addr 0x5000c5000182d58d
[ 4738.062432]  phy-6:0:9: mptsas: ioc2: delete phy 1, phy-obj (0xffff883f2=
1a82400)
[ 4738.062446]  port-6:0:1: mptsas: ioc2: delete port 1, sas_addr (0x5000c5=
000182d58d)
[ 4738.062558]  end_device-6:0:0: mptsas: ioc2: removing sata device: fw_ch=
annel 0, fw_id 8, phy 0,sas_addr 0x5001940000752200
[ 4738.062560]  phy-6:0:8: mptsas: ioc2: delete phy 0, phy-obj (0xffff883f2=
1a80c00)
[ 4738.062564]  port-6:0:0: mptsas: ioc2: delete port 0, sas_addr (0x500194=
0000752200)
[ 4738.062937]  end_device-6:0:7: mptsas: ioc2: removing ssp device: fw_cha=
nnel 0, fw_id 32, phy 24,sas_addr 0x500194000075223e
[ 4738.062939]  phy-6:0:32: mptsas: ioc2: delete phy 24, phy-obj (0xffff883=
f21a78800)
[ 4738.062946]  port-6:0:7: mptsas: ioc2: delete port 7, sas_addr (0x500194=
000075223e)
[ 4738.065679]  end_device-6:0:5: mptsas: ioc2: removing sata device: fw_ch=
annel 0, fw_id 20, phy 12,sas_addr 0x500194000075220c
[ 4738.065683]  phy-6:0:20: mptsas: ioc2: delete phy 12, phy-obj (0xffff883=
f21a9a000)
[ 4738.065698]  port-6:0:5: mptsas: ioc2: delete port 5, sas_addr (0x500194=
000075220c)
[ 4738.074843]  end_device-6:0:4: mptsas: ioc2: removing sata device: fw_ch=
annel 0, fw_id 16, phy 8,sas_addr 0x5001940000752208
[ 4738.074856]  phy-6:0:16: mptsas: ioc2: delete phy 8, phy-obj (0xffff883f=
21a82000)
[ 4738.074883]  port-6:0:4: mptsas: ioc2: delete port 4, sas_addr (0x500194=
0000752208)
[ 4738.136115] sd 6:0:3:0: [sdl] Synchronizing SCSI cache
[ 4738.136192] sd 6:0:3:0: [sdl] Synchronize Cache(10) failed: Result: host=
byte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
[ 4738.225172] ------------[ cut here ]------------
[ 4738.225188] WARNING: CPU: 0 PID: 19546 at fs/sysfs/group.c:237 sysfs_rem=
ove_group+0x89/0x90
[ 4738.225189] sysfs group 'power' not found for kobject 'target6:0:0'
[ 4738.225191] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_tran=
sport_iscsi serpent_sse2_x86_64 serpent_generic ablk_helper algif_skcipher =
af_alg vmnet(O) vmblock(O) vmmon(O) vmw_vsock_vmci_transport vsock vmw_vmci=
 nfsd rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 nfs lockd grace sunrpc=
 bonding cachefiles fscache binfmt_misc usb_storage ipmi_ssif pl2303 amdgpu=
 usbserial snd_oxygen dcdbas i2c_algo_bit snd_oxygen_lib drm_kms_helper snd=
_hda_codec_hdmi coretemp snd_mpu401_uart cfbfillrect syscopyarea snd_rawmid=
i cfbimgblt sr_mod sysfillrect snd_seq_device sysimgblt cdrom snd_hda_intel=
 fb_sys_fops mptsas cfbcopyarea snd_hda_codec ttm snd_hda_core drm snd_hwde=
p snd_pcm snd_timer snd soundcore i7300_edac bnx2 edac_core mptspi mptscsih=
 ipmi_si mptbase ipmi_devintf xhci_pci ipmi_msghandler xhci_hcd
[ 4738.225270] CPU: 0 PID: 19546 Comm: kworker/0:9 Tainted: G           O  =
  4.11.5+ #8
[ 4738.225272] Hardware name: Dell Inc. PowerEdge R900/0TT975, BIOS 1.2.0 1=
1/11/2010
[ 4738.225283] Workqueue: mpt/2 mptsas_firmware_event_work [mptsas]
[ 4738.225285] Call Trace:
[ 4738.225297]  dump_stack+0x4d/0x65
[ 4738.225303]  __warn+0xc7/0xf0
[ 4738.225304]  warn_slowpath_fmt+0x46/0x50
[ 4738.225306]  sysfs_remove_group+0x89/0x90
[ 4738.225310]  dpm_sysfs_remove+0x52/0x60
[ 4738.225313]  device_del+0x119/0x320
[ 4738.225315]  ? kobject_release+0x4c/0x80
[ 4738.225319]  scsi_target_reap_ref_release+0x28/0x40
[ 4738.225320]  scsi_target_reap+0x29/0x30
[ 4738.225322]  scsi_remove_target+0x189/0x1a0
[ 4738.225325]  sas_rphy_remove+0x5b/0x70
[ 4738.225328]  sas_port_delete+0x28/0x160
[ 4738.225331]  ? sysfs_remove_link+0x14/0x30
[ 4738.225334]  mptsas_del_end_device+0x16c/0x1a0 [mptsas]
[ 4738.225336]  mptsas_expander_delete+0x129/0x310 [mptsas]
[ 4738.225338]  mptsas_firmware_event_work+0x69f/0xcda [mptsas]
[ 4738.225340]  ? mptsas_firmware_event_work+0x69f/0xcda [mptsas]
[ 4738.225346]  ? pick_next_task_fair+0x455/0x4f0
[ 4738.225347]  ? pick_next_task_fair+0x455/0x4f0
[ 4738.225354]  process_one_work+0x13a/0x350
[ 4738.225355]  ? process_one_work+0x13a/0x350
[ 4738.225356]  worker_thread+0x46/0x470
[ 4738.225359]  kthread+0xfe/0x140
[ 4738.225361]  ? max_active_store+0x60/0x60
[ 4738.225362]  ? kthread_park+0x90/0x90
[ 4738.225369]  ret_from_fork+0x29/0x40
[ 4738.225371] ---[ end trace 484be07bfa4dae74 ]---
[ 4738.226080] BUG: unable to handle kernel NULL pointer dereference at 000=
00000000000a0
[ 4738.226163] IP: sas_rphy_match+0x4b/0x80
[ 4738.226178] PGD 0=20

[ 4738.226192] Oops: 0000 [#1] SMP
[ 4738.226210] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_tran=
sport_iscsi serpent_sse2_x86_64 serpent_generic ablk_helper algif_skcipher =
af_alg vmnet(O) vmblock(O) vmmon(O) vmw_vsock_vmci_transport vsock vmw_vmci=
 nfsd rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 nfs lockd grace sunrpc=
 bonding cachefiles fscache binfmt_misc usb_storage ipmi_ssif pl2303 amdgpu=
 usbserial snd_oxygen dcdbas i2c_algo_bit snd_oxygen_lib drm_kms_helper snd=
_hda_codec_hdmi coretemp snd_mpu401_uart cfbfillrect syscopyarea snd_rawmid=
i cfbimgblt sr_mod sysfillrect snd_seq_device sysimgblt cdrom snd_hda_intel=
 fb_sys_fops mptsas cfbcopyarea snd_hda_codec ttm snd_hda_core drm snd_hwde=
p snd_pcm snd_timer snd soundcore i7300_edac bnx2 edac_core mptspi mptscsih=
 ipmi_si mptbase ipmi_devintf xhci_pci ipmi_msghandler xhci_hcd
[ 4738.226559] CPU: 0 PID: 19546 Comm: kworker/0:9 Tainted: G        W  O  =
  4.11.5+ #8
[ 4738.226590] Hardware name: Dell Inc. PowerEdge R900/0TT975, BIOS 1.2.0 1=
1/11/2010
[ 4738.226639] Workqueue: mpt/2 mptsas_firmware_event_work [mptsas]
[ 4738.226665] task: ffff883f20ab3580 task.stack: ffffc9000de2c000
[ 4738.226708] RIP: 0010:sas_rphy_match+0x4b/0x80
[ 4738.226725] RSP: 0018:ffffc9000de2fbf0 EFLAGS: 00010246
[ 4738.226757] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000001810=
000f1
[ 4738.226806] RDX: ffff883f444db000 RSI: ffff883f21a7a000 RDI: ffff883f21a=
7f000
[ 4738.226856] RBP: ffffc9000de2fc00 R08: 000000002a4e3001 R09: 00000001810=
000f1
[ 4738.226907] R10: ffffc9000de2fb28 R11: ffff883f3d593580 R12: ffff883f433=
7b700
[ 4738.226953] R13: ffffffff814317f0 R14: 5001940000752200 R15: ffff883f21a=
81800
[ 4738.227001] FS:  0000000000000000(0000) GS:ffff883f5ee00000(0000) knlGS:=
0000000000000000
[ 4738.227036] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4738.227071] CR2: 00000000000000a0 CR3: 0000003f324bb000 CR4: 00000000000=
006f0
[ 4738.227116] Call Trace:
[ 4738.227128]  attribute_container_device_trigger+0x38/0xb0
[ 4738.227160]  transport_remove_device+0x10/0x20
[ 4738.227178]  sas_rphy_remove+0x4b/0x70
[ 4738.227192]  sas_port_delete+0x28/0x160
[ 4738.227213]  ? sysfs_remove_link+0x14/0x30
[ 4738.227228]  mptsas_del_end_device+0x16c/0x1a0 [mptsas]
[ 4738.227260]  mptsas_expander_delete+0x129/0x310 [mptsas]
[ 4738.227282]  mptsas_firmware_event_work+0x69f/0xcda [mptsas]
[ 4738.227306]  ? mptsas_firmware_event_work+0x69f/0xcda [mptsas]
[ 4738.227329]  ? pick_next_task_fair+0x455/0x4f0
[ 4738.227346]  ? pick_next_task_fair+0x455/0x4f0
[ 4738.227364]  process_one_work+0x13a/0x350
[ 4738.227383]  ? process_one_work+0x13a/0x350
[ 4738.227409]  worker_thread+0x46/0x470
[ 4738.227431]  kthread+0xfe/0x140
[ 4738.227449]  ? max_active_store+0x60/0x60
[ 4738.227470]  ? kthread_park+0x90/0x90
[ 4738.227489]  ret_from_fork+0x29/0x40
[ 4738.227503] Code: 5b 41 5c 5d c3 48 8b 06 49 89 fc 48 8b 18 eb 08 48 8b =
1b 48 85 db 74 3a 48 89 df e8 f0 b1 fe ff 85 c0 74 ec 48 81 eb e0 01 00 00 =
<48> 8b 83 a0 00 00 00 48 85 c0 74 c7 48 81 78 38 c0 ec c6 81 75=20
[ 4738.227607] RIP: sas_rphy_match+0x4b/0x80 RSP: ffffc9000de2fbf0
[ 4738.227643] CR2: 00000000000000a0
[ 4738.239890] ---[ end trace 484be07bfa4dae75 ]---

Is this is a known / obvious issue, or should I try to bisect it?

Please CC replies, I'm not subscribed to linux-scsi.

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQSjUXCEZ5KgtswVFBYtgFpfxUMstQUCWURwUQAKCRAtgFpfxUMs
tSSBAJ9Audy1Gk3poMZdkweb1OF1PMFKgwCgjpglSElTfQTDjUVfNt3m7Hd14fY=
=N0dM
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
