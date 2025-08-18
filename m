Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 571FB30F7F0;
	Mon, 18 Aug 2025 09:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755510651; cv=none; b=GKzL7mdJWUlxMQyFqhAf+MS/ZQnJWxspEfT/rHwZEaSMC0P1jxnWl7ABNZny6h0ArBAMXBARwhaGKDZxN2PSDuN5ks+oMJuFzGn8nGe+adDyo0ogivkxueLaytP2J+FSDcap1I1wUaiGWdxnTgVn1PNdXI/yZzVsUMQJcOV8sgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755510651; c=relaxed/simple;
	bh=H84eiAraM41DK2JnCnv9EUuemVnoAHbaPQwwvu0/Zog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B9t0CL7lk9A9T2KEEzDvx7uZpuQklhSTQiffj3dQcAekaEN2E6O7waCVecu+d31xU0iaqLBCH8c3YvTt4X/QpYhhZKkyfRBYIvJH0Jo8mC7vsBDTPm1lSWC7/VBDOqzajqC1YJ1mnoFqfgVnKuiaBFSaDC6845oFhKOEGoV/Ap8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Bz24B1Sl; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Bz24B1Sl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=MV
	T1cY0EUo/p/pzzSG1IhoOoglOOePjguLh2CLUwazw=; b=Bz24B1Sl+wPQ4BID3S
	zoMRPUGilMFYgGbDaFZwjHWZTjRz62BMZgiyGiMHheXmO5ELd/8swURhierxVryx
	6ykvfj9sV7bp4ghZZzPjkzSspkBNeLN8dpisOWe34u/u0TLNDKy8g9ZsjPztZ+Vy
	MjKqSD2BsUSqxM5T1hu3i0iPA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD393lQ96JoTA8wCw--.43197S4;
	Mon, 18 Aug 2025 17:50:24 +0800 (CST)
From: David Wang <00107082@163.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] general protection fault when connecting an old mp3/usb device
Date: Mon, 18 Aug 2025 17:50:08 +0800
Message-ID: <20250818095008.6473-1-00107082@163.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID:_____wD393lQ96JoTA8wCw--.43197S4
X-Coremail-Antispam: 1Uf129KBjvAXoWfGFW8uw1UKr47Xw48AryxXwb_yoW8GF15to
	W7GF1rGr48Cr43Kr4vyr9IqrWDJ34qyFnFvryDA398Ga9FqF4UXr4UAr1kXw13Wa1UJr15
	Aan5tws3J3y5AF97n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUcPl1UUUUU
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/1tbiMwOtqmii83eOHgAAsp

Hi,

My loptop is running 6.16.0, once when I connect with an old mp3 via usb fo=
r file
transfer, the connection could not be established correctly, after I reconn=
ect it
several times, got following kernel error:
(The device is old, and maybe buggy, but it works. And eventually I can con=
nect it
for file transfers)

[Sat Aug 23 03:56:02 2025] usb 1-5: new high-speed USB device number 35 usi=
ng xhci_hcd
[Sat Aug 23 03:56:02 2025] usb 1-5: New USB device found, idVendor=3D12d1, =
idProduct=3D1082, bcdDevice=3D 3.18
[Sat Aug 23 03:56:02 2025] usb 1-5: New USB device strings: Mfr=3D1, Produc=
t=3D2, SerialNumber=3D3
[Sat Aug 23 03:56:02 2025] usb 1-5: Product: ATU-AL10
[Sat Aug 23 03:56:02 2025] usb 1-5: Manufacturer: HUAWEI
[Sat Aug 23 03:56:02 2025] usb 1-5: SerialNumber: TPE9X18915C02308
[Sat Aug 23 03:56:02 2025] usb-storage 1-5:1.1: USB Mass Storage device det=
ected
[Sat Aug 23 03:56:02 2025] scsi host2: usb-storage 1-5:1.1
[Sat Aug 23 03:56:03 2025] scsi 2:0:0:0: CD-ROM            Linux    File-CD=
 Gadget   0318 PQ: 0 ANSI: 2
[Sat Aug 23 03:56:03 2025] sr 2:0:0:0: Power-on or device reset occurred
[Sat Aug 23 03:56:03 2025] sr 2:0:0:0: [sr0] scsi3-mmc drive: 0x/0x caddy
[Sat Aug 23 03:56:03 2025] sr 2:0:0:0: Attached scsi CD-ROM sr0
[Sat Aug 23 03:56:03 2025] sr 2:0:0:0: Attached scsi generic sg0 type 5
[Sat Aug 23 03:56:03 2025] /dev/sr0: Can't open blockdev
[Sat Aug 23 03:56:03 2025] ISO 9660 Extensions: Microsoft Joliet Level 1
[Sat Aug 23 03:56:03 2025] ISOFS: changing to secondary root
[Sat Aug 23 03:56:07 2025] usb 1-5: reset high-speed USB device number 35 u=
sing xhci_hcd
[Sat Aug 23 03:56:07 2025] sr 2:0:0:0: Power-on or device reset occurred
[Sat Aug 23 03:56:07 2025] usb 1-5: reset high-speed USB device number 35 u=
sing xhci_hcd
[Sat Aug 23 03:56:08 2025] sr 2:0:0:0: Power-on or device reset occurred
[Sat Aug 23 03:56:09 2025] usb 1-5: USB disconnect, device number 35
[Sat Aug 23 03:56:09 2025] Oops: general protection fault, probably for non=
-canonical address 0x2e2e2f2e2e2f308e: 0000 [#1] SMP NOPTI
[Sat Aug 23 03:56:09 2025] CPU: 6 UID: 0 PID: 355615 Comm: umount Not taint=
ed 6.16.0-linan-0 #50 PREEMPT(voluntary)=20
[Sat Aug 23 03:56:09 2025] Hardware name: Acer S40-53/Lily_TL, BIOS V1.01 0=
8/28/2020
[Sat Aug 23 03:56:09 2025] RIP: 0010:scsi_block_when_processing_errors+0x27=
/0xf0 [scsi_mod]
[Sat Aug 23 03:56:09 2025] Code: 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 55 53 =
48 83 ec 30 65 48 8b 1d 61 b1 13 f0 48 89 5c 24 28 48 89 fb e8 2c 73 cd ee =
48 8b 13 <8b> 82 60 02 00 00 83 e8 05 83 f8 02 76 09 f6 82 20 02 00 00 10 74
[Sat Aug 23 03:56:09 2025] RSP: 0018:ffffaff30f777c70 EFLAGS: 00010246
[Sat Aug 23 03:56:09 2025] RAX: 0000000000000000 RBX: ffff920700e06000 RCX:=
 0000000000000000
[Sat Aug 23 03:56:09 2025] RDX: 2e2e2f2e2e2f2e2e RSI: ffffaff30f777d40 RDI:=
 ffff920700e06000
[Sat Aug 23 03:56:09 2025] RBP: ffff920700e06000 R08: ffffaff30f777db4 R09:=
 0000000000000004
[Sat Aug 23 03:56:09 2025] R10: ffffaff30f777db4 R11: ffffffffb06dff80 R12:=
 ffffaff30f777cc0
[Sat Aug 23 03:56:09 2025] R13: ffff9206360b2c00 R14: 0000000000000000 R15:=
 ffffaff30f777d40
[Sat Aug 23 03:56:09 2025] FS:  00007f28311db840(0000) GS:ffff92092fe60000(=
0000) knlGS:0000000000000000
[Sat Aug 23 03:56:09 2025] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Sat Aug 23 03:56:09 2025] CR2: 000055c1ad2b1058 CR3: 000000011eaae002 CR4:=
 0000000000f72ef0
[Sat Aug 23 03:56:09 2025] PKRU: 55555554
[Sat Aug 23 03:56:09 2025] Call Trace:
[Sat Aug 23 03:56:09 2025]  <TASK>
[Sat Aug 23 03:56:09 2025]  sr_do_ioctl+0x5b/0x1c0 [sr_mod]
[Sat Aug 23 03:56:09 2025]  sr_packet+0x2c/0x50 [sr_mod]
[Sat Aug 23 03:56:09 2025]  cdrom_get_disc_info+0x60/0xe0 [cdrom]
[Sat Aug 23 03:56:09 2025]  cdrom_mrw_exit+0x29/0xb0 [cdrom]
[Sat Aug 23 03:56:09 2025]  ? xa_destroy+0xaa/0x120
[Sat Aug 23 03:56:09 2025]  unregister_cdrom+0x76/0xc0 [cdrom]
[Sat Aug 23 03:56:09 2025]  sr_free_disk+0x44/0x50 [sr_mod]
[Sat Aug 23 03:56:09 2025]  disk_release+0xb0/0xe0
[Sat Aug 23 03:56:09 2025]  device_release+0x37/0x90
[Sat Aug 23 03:56:09 2025]  kobject_put+0x8e/0x1d0
[Sat Aug 23 03:56:09 2025]  blkdev_release+0x11/0x20
[Sat Aug 23 03:56:09 2025]  __fput+0xe3/0x2a0
[Sat Aug 23 03:56:09 2025]  task_work_run+0x59/0x90
[Sat Aug 23 03:56:09 2025]  exit_to_user_mode_loop+0xd6/0xe0
[Sat Aug 23 03:56:09 2025]  do_syscall_64+0x1c1/0x1e0
[Sat Aug 23 03:56:09 2025]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[Sat Aug 23 03:56:09 2025] RIP: 0033:0x7f2831407b37
[Sat Aug 23 03:56:09 2025] Code: cf 92 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 =
0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 =
00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 99 92 0c 00 f7 d8 64 89 02 b8
[Sat Aug 23 03:56:09 2025] RSP: 002b:00007ffd4805c858 EFLAGS: 00000202 ORIG=
_RAX: 00000000000000a6
[Sat Aug 23 03:56:09 2025] RAX: 0000000000000000 RBX: 00005590f636c0f8 RCX:=
 00007f2831407b37
[Sat Aug 23 03:56:09 2025] RDX: 0000000000000000 RSI: 0000000000000002 RDI:=
 00005590f636c210
[Sat Aug 23 03:56:09 2025] RBP: 0000000000000002 R08: 00007f28314d1cc0 R09:=
 0000000000000040
[Sat Aug 23 03:56:09 2025] R10: 0000000000000000 R11: 0000000000000202 R12:=
 00007f2831542264
[Sat Aug 23 03:56:09 2025] R13: 00005590f636c210 R14: 00005590f63716f0 R15:=
 00005590f636bfe0
[Sat Aug 23 03:56:09 2025]  </TASK>
[Sat Aug 23 03:56:09 2025] Modules linked in: sd_mod isofs sr_mod cdrom sg =
uas usb_storage snd_usb_audio snd_usbmidi_lib snd_rawmidi hid_generic usbhi=
d hid ccm rfcomm snd_seq_dummy snd_hrtimer snd_seq snd_seq_device xt_CHECKS=
UM ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_compa=
t x_tables nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 =
nf_tables nfnetlink bridge stp llc cmac algif_hash algif_skcipher af_alg qr=
tr bnep binfmt_misc nls_ascii nls_cp437 vfat fat snd_ctl_led snd_soc_skl_hd=
a_dsp snd_soc_intel_sof_board_helpers snd_soc_intel_hda_dsp_common snd_sof_=
probes snd_hda_codec_realtek snd_hda_codec_generic snd_hda_scodec_component=
 snd_soc_dmic snd_sof_pci_intel_tgl snd_sof_pci_intel_cnl snd_sof_intel_hda=
_generic soundwire_intel soundwire_generic_allocation snd_sof_intel_hda_sdw=
_bpt snd_sof_intel_hda_common snd_soc_hdac_hda snd_sof_intel_hda_mlink snd_=
sof_intel_hda snd_hda_codec_hdmi snd_hda_ext_core soundwire_cadence snd_sof=
_pci intel_rapl_msr snd_sof_xtensa_dsp intel_rapl_common snd_sof
[Sat Aug 23 03:56:09 2025]  x86_pkg_temp_thermal snd_sof_utils snd_soc_acpi=
_intel_match intel_powerclamp snd_soc_acpi_intel_sdca_quirks coretemp snd_s=
oc_acpi crc8 iwlmvm soundwire_bus kvm_intel snd_soc_sdca snd_soc_core mac80=
211 snd_compress kvm libarc4 snd_hda_intel ptp btusb snd_intel_dspcfg uvcvi=
deo pps_core mei_hdcp irqbypass btrtl snd_intel_sdw_acpi ghash_clmulni_inte=
l videobuf2_vmalloc aesni_intel btintel uvc snd_hda_codec videobuf2_memops =
btbcm videobuf2_v4l2 rapl snd_hda_core iwlwifi snd_hwdep intel_cstate snd_p=
csp videodev bluetooth iTCO_wdt snd_pcm videobuf2_common ecdh_generic acer_=
wmi mc intel_uncore snd_timer intel_pmc_bxt ecc platform_profile wmi_bmof s=
nd cfg80211 iTCO_vendor_support ee1004 mei_me soundcore watchdog mei rfkill=
 ac intel_hid sparse_keymap acpi_pad joydev acer_wireless evdev serio_raw m=
sr parport_pc ppdev lp parport fuse loop efi_pstore dm_mod configfs autofs4=
 ext4 crc16 mbcache jbd2 btrfs blake2b_generic efivarfs raid10 raid456 asyn=
c_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1
[Sat Aug 23 03:56:09 2025]  raid0 md_mod ahci libahci libata nvme scsi_mod =
nvme_core scsi_common i915 cec drm_buddy ttm i2c_algo_bit r8169 drm_display=
_helper xhci_pci drm_client_lib realtek xhci_hcd mdio_devres drm_kms_helper=
 psmouse libphy usbcore intel_lpss_pci drm mdio_bus i2c_i801 intel_lpss i2c=
_smbus usb_common idma64 vmd fan video button battery wmi
[Sat Aug 23 03:56:09 2025] ---[ end trace 0000000000000000 ]---
[Sat Aug 23 03:56:10 2025] pstore: backend (efi_pstore) writing error (-28)
[Sat Aug 23 03:56:10 2025] RIP: 0010:scsi_block_when_processing_errors+0x27=
/0xf0 [scsi_mod]
[Sat Aug 23 03:56:10 2025] Code: 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 55 53 =
48 83 ec 30 65 48 8b 1d 61 b1 13 f0 48 89 5c 24 28 48 89 fb e8 2c 73 cd ee =
48 8b 13 <8b> 82 60 02 00 00 83 e8 05 83 f8 02 76 09 f6 82 20 02 00 00 10 74
[Sat Aug 23 03:56:10 2025] RSP: 0018:ffffaff30f777c70 EFLAGS: 00010246
[Sat Aug 23 03:56:10 2025] RAX: 0000000000000000 RBX: ffff920700e06000 RCX:=
 0000000000000000
[Sat Aug 23 03:56:10 2025] RDX: 2e2e2f2e2e2f2e2e RSI: ffffaff30f777d40 RDI:=
 ffff920700e06000
[Sat Aug 23 03:56:10 2025] RBP: ffff920700e06000 R08: ffffaff30f777db4 R09:=
 0000000000000004
[Sat Aug 23 03:56:10 2025] R10: ffffaff30f777db4 R11: ffffffffb06dff80 R12:=
 ffffaff30f777cc0
[Sat Aug 23 03:56:10 2025] R13: ffff9206360b2c00 R14: 0000000000000000 R15:=
 ffffaff30f777d40
[Sat Aug 23 03:56:10 2025] FS:  00007f28311db840(0000) GS:ffff92092fe60000(=
0000) knlGS:0000000000000000
[Sat Aug 23 03:56:10 2025] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Sat Aug 23 03:56:10 2025] CR2: 000055c1ad2b1058 CR3: 000000011eaae002 CR4:=
 0000000000f72ef0
[Sat Aug 23 03:56:10 2025] PKRU: 55555554



Parsing with a vmlinux image build with DEBUG_INFO:
=20
[Sat Aug 23 03:56:09 2025] Oops: general protection fault, probably for non=
-canonical address 0x2e2e2f2e2e2f308e: 0000 [#1] SMP NOPTI
[Sat Aug 23 03:56:09 2025] CPU: 6 UID: 0 PID: 355615 Comm: umount Not taint=
ed 6.16.0-linan-0 #50 PREEMPT(voluntary)
[Sat Aug 23 03:56:09 2025] Hardware name: Acer S40-53/Lily_TL, BIOS V1.01 0=
8/28/2020
[Sat Aug 23 03:56:09 2025] RIP: 0010:scsi_block_when_processing_errors (./i=
nclude/scsi/scsi_host.h:755 drivers/scsi/scsi_error.c:388) scsi_mod=20
[Sat Aug 23 03:56:09 2025] Code: 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 55 53 =
48 83 ec 30 65 48 8b 1d 61 b1 13 f0 48 89 5c 24 28 48 89 fb e8 2c 73 cd ee =
48 8b 13 <8b> 82 60 02 00 00 83 e8 05 83 f8 02 76 09 f6 82 20 02 00 00 10 74
All code
=3D=3D=3D=3D=3D=3D=3D=3D
   0:	90                   	nop
   1:	90                   	nop
   2:	90                   	nop
   3:	f3 0f 1e fa          	endbr64
   7:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   c:	55                   	push   %rbp
   d:	53                   	push   %rbx
   e:	48 83 ec 30          	sub    $0x30,%rsp
  12:	65 48 8b 1d 61 b1 13 	mov    %gs:-0xfec4e9f(%rip),%rbx        # 0xfff=
ffffff013b17b
  19:	f0=20
  1a:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
  1f:	48 89 fb             	mov    %rdi,%rbx
  22:	e8 2c 73 cd ee       	call   0xffffffffeecd7353
  27:	48 8b 13             	mov    (%rbx),%rdx
  2a:*	8b 82 60 02 00 00    	mov    0x260(%rdx),%eax		<-- trapping instruct=
ion
  30:	83 e8 05             	sub    $0x5,%eax
  33:	83 f8 02             	cmp    $0x2,%eax
  36:	76 09                	jbe    0x41
  38:	f6 82 20 02 00 00 10 	testb  $0x10,0x220(%rdx)
  3f:	74                   	.byte 0x74

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0:	8b 82 60 02 00 00    	mov    0x260(%rdx),%eax
   6:	83 e8 05             	sub    $0x5,%eax
   9:	83 f8 02             	cmp    $0x2,%eax
   c:	76 09                	jbe    0x17
   e:	f6 82 20 02 00 00 10 	testb  $0x10,0x220(%rdx)
  15:	74                   	.byte 0x74
[Sat Aug 23 03:56:09 2025] RSP: 0018:ffffaff30f777c70 EFLAGS: 00010246
[Sat Aug 23 03:56:09 2025] RAX: 0000000000000000 RBX: ffff920700e06000 RCX:=
 0000000000000000
[Sat Aug 23 03:56:09 2025] RDX: 2e2e2f2e2e2f2e2e RSI: ffffaff30f777d40 RDI:=
 ffff920700e06000
[Sat Aug 23 03:56:09 2025] RBP: ffff920700e06000 R08: ffffaff30f777db4 R09:=
 0000000000000004
[Sat Aug 23 03:56:09 2025] R10: ffffaff30f777db4 R11: ffffffffb06dff80 R12:=
 ffffaff30f777cc0
[Sat Aug 23 03:56:09 2025] R13: ffff9206360b2c00 R14: 0000000000000000 R15:=
 ffffaff30f777d40
[Sat Aug 23 03:56:09 2025] FS:  00007f28311db840(0000) GS:ffff92092fe60000(=
0000) knlGS:0000000000000000
[Sat Aug 23 03:56:09 2025] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Sat Aug 23 03:56:09 2025] CR2: 000055c1ad2b1058 CR3: 000000011eaae002 CR4:=
 0000000000f72ef0
[Sat Aug 23 03:56:09 2025] PKRU: 55555554
[Sat Aug 23 03:56:09 2025] Call Trace:
[Sat Aug 23 03:56:09 2025]  <TASK>
[Sat Aug 23 03:56:09 2025] sr_do_ioctl (drivers/scsi/sr_ioctl.c:202 (discri=
minator 1)) sr_mod=20
[Sat Aug 23 03:56:09 2025] sr_packet (drivers/scsi/sr.c:928) sr_mod=20
[Sat Aug 23 03:56:09 2025] cdrom_get_disc_info (drivers/cdrom/cdrom.c:385) =
cdrom=20
[Sat Aug 23 03:56:09 2025] cdrom_mrw_exit (drivers/cdrom/cdrom.c:538) cdrom=
=20
[Sat Aug 23 03:56:09 2025] ? xa_destroy (lib/xarray.c:956 lib/xarray.c:2390=
)=20
[Sat Aug 23 03:56:09 2025] unregister_cdrom (drivers/cdrom/cdrom.c:657) cdr=
om=20
[Sat Aug 23 03:56:09 2025] sr_free_disk (drivers/scsi/sr.c:578) sr_mod=20
[Sat Aug 23 03:56:09 2025] disk_release (block/genhd.c:1312)=20
[Sat Aug 23 03:56:09 2025] device_release (drivers/base/core.c:2572)=20
[Sat Aug 23 03:56:09 2025] kobject_put (lib/kobject.c:693 lib/kobject.c:720=
 ./include/linux/kref.h:65 lib/kobject.c:737)=20
[Sat Aug 23 03:56:09 2025] blkdev_release (block/fops.c:686)=20
[Sat Aug 23 03:56:09 2025] __fput (fs/file_table.c:465)=20
[Sat Aug 23 03:56:09 2025] task_work_run (kernel/task_work.c:227)=20
[Sat Aug 23 03:56:09 2025] exit_to_user_mode_loop (./include/linux/resume_u=
ser_mode.h:50 kernel/entry/common.c:114)=20
[Sat Aug 23 03:56:09 2025] do_syscall_64 (./include/linux/entry-common.h:33=
0 ./include/linux/entry-common.h:414 ./include/linux/entry-common.h:449 arc=
h/x86/entry/syscall_64.c:100)=20
[Sat Aug 23 03:56:09 2025] entry_SYSCALL_64_after_hwframe (arch/x86/entry/e=
ntry_64.S:130)=20
[Sat Aug 23 03:56:09 2025] RIP: 0033:0x7f2831407b37



The offending address 0x2e2e2f2e2e2f308e seems interesting:
	0x2e2e2f2e2e2f308e =3D 0x2e2e2f2e2e2f2e2e+0x260
as in:
   2a:*  8b 82 60 02 00 00       mov    0x260(%rdx),%eax         <-- trappi=
ng instruction

It seems part of the device structure has been erased with 0x2e2e2f2e2e2f2e=
2e, when=20
scsi_block_when_processing_errors tried to access it.


Thanks
David

=20

