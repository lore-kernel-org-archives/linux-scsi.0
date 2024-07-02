Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6647115689B
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 10:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719916087; cv=none; b=MHwryr3SfHP4zsDAv4D5Fw2qjHF3NsLYwhQOguqJAIPP3L5NbGVMwLKgzTyyHx7cuDjSEv+UjcsF0FCD5T0pcoc5gHvfmLCjWSZexI9ey+n1khU5CFqQrvo/d6kzEhjdw35unyTU/mEMgCzyMFHeIaxKRpdfNc0VprasspXPang=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719916087; c=relaxed/simple;
	bh=RlSJSm+t2m7f5+ajBASnvEe754EZeWNVMayM6KZZBbM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=D5v8dRWCPFPABN/Zz+7a7ULUQ7fJmvxwkA8i/zRn+Gz+Ge82RgRvNiIbmxTRdfJkJ5TpsoKj4C+2zPuOR4p3OckNK/qLOt3yZlBOzAR5Gly5k7g6Ya4M3xoiiPx4PvoHooiojpg1CtOSPqP/MBfXvabuWikj/wQp+ln5IFr2tVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lucidpixels.com; spf=pass smtp.mailfrom=lucidpixels.com; dkim=pass (1024-bit key) header.d=lucidpixels.com header.i=@lucidpixels.com header.b=AzMTCB3a; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lucidpixels.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lucidpixels.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lucidpixels.com header.i=@lucidpixels.com header.b="AzMTCB3a"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5c2011716a3so1502122eaf.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jul 2024 03:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lucidpixels.com; s=google; t=1719916084; x=1720520884; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rHm2MjeDvkZ/vV0viuFJ136c+mZ2IFJxGFu8s9EMccs=;
        b=AzMTCB3aolH2hWjARYtPy8n/+x+rqsN7U3f+Xy2LH9pdEsbr5B3nqbTOw5m6sI5Ofj
         Ode2Nwj+ECMAJyI1eKV52Qo8ANrBk6+kgRn+FJNuoqnPw5dKMRD9tDv2LDDdeKvNyGaw
         uGnAMggLa+mFfnaqWwmq7OOpCtZhcyEU7lChc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719916084; x=1720520884;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rHm2MjeDvkZ/vV0viuFJ136c+mZ2IFJxGFu8s9EMccs=;
        b=vJ11uwDxuF1vA1eML+h9/RLTQrGQA+T2UXd+3KRIPwmeoPWT9CvhCVTwx2XUeZcqAS
         iIKT867cIrSJnHJxadQill+E2D+Di9xic6s3GRgt15jLUpUOWWa2dKkQMh+CdPwobDlh
         e6sNNblQg8Abz/qhTXtpBTnpjzVHQCApvZKFzwaAXdA6kJiCfllYf6jaHl0/dlKj750a
         rtF2CM9jA2KnTrkUbiJTXHMbEOPLwgZm+hC98MJyiNk9sH7YwWk79RFgL4CC92qF/Fvj
         ynBu5WYf8zoyslV2DnR/k3m424hgD52zf+sE2vTD4bYJngIZVnfINWcyCL1hM/Ebqteg
         2bJw==
X-Gm-Message-State: AOJu0YzbdCj2EQaCvUFYBcyCqXWcGtPdbQT1twFCqunt59fSV9xVdqng
	zHPc7/SvsFML3y2fcrnbnlLuslp9fWv+p9TMucCvpvvF65GLKTS1sv4SPKwIK9FFqDVBCz7wEbN
	4AcALyYotJGPqxnJNoOjnrW4tzoqXZoPI7pefkb10e2tUH48VQeOM1w==
X-Google-Smtp-Source: AGHT+IFhrGjvAzsCTcDApONuW8Ngn2jVvYLSRZgKpoBwNsEYFOzxqEUqihxP0QpjUKODBFF8jmFD47IVut0cjpoh22Q=
X-Received: by 2002:a05:6871:24e0:b0:25d:f2f6:bfe7 with SMTP id
 586e51a60fabf-25df2f6cd15mr771928fac.1.1719916084296; Tue, 02 Jul 2024
 03:28:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Date: Tue, 2 Jul 2024 06:27:51 -0400
Message-ID: <CAO9zADw0ghDTYP98JBN-RqgUi3hKcv7S-20GVzHR884i348mcw@mail.gmail.com>
Subject: 6.9.7: kernel panic: RIP: 0010:btrfs_clone_write_end_io+0x1e/0x60
 [btrfs] (dmesg included)
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

Note: dmesg from the crash is included at the bottom of this email.

Arch: x86_64
Kernel: 6.9.7

Latest BIOS from Manufacturer:3603 (as of 7/2/2024)
Latest NVME Firmware available from Manufacturer: 4B2QJXD7 (as of 7/2/2024)

When not using the following kernel options:
nvme_core.default_ps_max_latency_us=0 pcie_aspm=off

With 6.1.x, the kernel still panics even with the above options.
I am testing 6.9.7 to see if the same happens with this version.

Does anyone know why this issue continues to occur?

I did find a summary of this issue here from Claudio Luck:
https://bugzilla.proxmox.com/show_bug.cgi?id=5306

--------------

My summary:

Points not debunked:

 - Some People have success changing PSU
 - Some People see the problem disappear after NVMe firmware update
 - Different NVMe brands affected, both with/without DRAM

Uncertain points:

 - A proposed patch for Linux to change amount/size of buffers towards
NVMe drive
 - Some People get stability switching to FreeBSD (TrueNAS etc.) [a]

Notable observations:

 - Different NVMe vendors / controller brands (though, many reports
about WD products)
 - People get RMA-returns with newer firmware
 - Reproducible across batches of the same product
 - Most offen large reads/writes (e.g. ZFS resilver) just precede the crash
 - Some People have thermal imaging footage showing heat buildup before crash


I remain with my gut feeling that internal housekeeping in the NVMe
firmware controller produces either thermal overload or power
regulator overload, locking up the controller. The shutdown sometimes
doesn't seem to work as engineered, as in some instances we've had the
NVMe not return online after a soft-reboot but then after a cold-boot.

--------------


dmesg from the latest crash with 6.9.7 when the following options are NOT used:
nvme_core.default_ps_max_latency_us=0 pcie_aspm=off

[ 3718.137313] #PF: supervisor read access in kernel mode
[ 3718.137321] #PF: error_code(0x0000) - not-present page
[ 3718.137328] PGD 0 P4D 0
[ 3718.137333] Oops: 0000 [#1] PREEMPT SMP NOPTI
[ 3718.137364] CPU: 8 PID: 0 Comm: swapper/8 Not tainted 6.9.7 #2
[ 3718.137372] Hardware name: ASUSTeK COMPUTER INC. System Product
Name/Pro WS W680-ACE IPMI
[ 3718.137293] BUG: kernel NULL pointer dereference
[ 3718.137382] RIP: 0010:btrfs_clone_write_end_io+0x1e/0x60 [btrfs]
[ 3718.137474] RBP: ffff93a9766f8598 R08: ffff93a925547000 R09: 0000000080080007
[ 3718.137497] FS:  0000000000000000(0000) GS:ffff93c37f400000(0000)
knlGS:0000000000000000
[ 3718.137531]  <IRQ>
[ 3718.137549]  ? __slab_free+0xdf/0x2f0
[ 3718.137434] Code: 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00
00 55 53 48 8b 6f 40 48 89 fb 80 7f 19 00 48 8b 45 20 75 27 80 7f 10
07 74 13 <48> 8b 78 18 e8 a9 0d 39 d4 48 89 df 5b 5d e9 4f 09 39 d4 48
8b 57
[ 3718.137466] RDX: ffff93a480df4d40 RSI: ffff93a999c31900 RDI: ffff93a999c31900
[ 3718.137482] R10: 0000000080080007 R11: ffffa7ce00360ff8 R12: 0000000000000000
[ 3718.137506] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3718.137513] CR2: 0000000000000018 CR3: 00000001bddfc005 CR4: 0000000000770ef0
[ 3718.137521] PKRU: 55555554
[ 3718.137525] Call Trace:
[ 3718.137536]  ? __die+0x1f/0x60
[ 3718.137451] RSP: 0018:ffffa7ce00360e80 EFLAGS: 00010097
[ 3718.137458] RAX: 0000000000000000 RBX: ffff93a999c31900 RCX: ffff93a4a50c03b0
[ 3718.137489] R13: ffff93a999c31900 R14: 0000000000004000 R15: 0000000000004000
[ 3718.137543]  ? page_fault_oops+0x179/0x560
[ 3718.137557]  ? exc_page_fault+0x72/0x170
[ 3718.137564]  ? asm_exc_page_fault+0x22/0x30
[ 3718.137620]  ? kfree+0x24f/0x290
[ 3718.137642]  nvme_irq+0x3e/0x80 [nvme]
[ 3718.137572]  ? btrfs_clone_write_end_io+0x1e/0x60 [btrfs]
[ 3718.137626]  blk_mq_end_request+0x18/0x30
[ 3718.137649]  __handle_irq_event_percpu+0x43/0x1a0
[ 3718.137613]  blk_update_request+0x110/0x470
[ 3718.137633]  nvme_poll_cq+0x18f/0x360 [nvme]
[ 3718.137657]  handle_irq_event+0x34/0x70
[ 3718.137663]  handle_edge_irq+0x87/0x220
[ 3718.137673]  common_interrupt+0x7c/0xa0
[ 3718.137683]  <TASK>
[ 3718.137693] RIP: 0010:cpuidle_enter_state+0xc8/0x430
[ 3718.137668]  __common_interrupt+0x38/0xa0
[ 3718.137680]  </IRQ>
[ 3718.137687]  asm_common_interrupt+0x22/0x40
[ 3718.137700] Code: 4e 44 54 ff e8 a9 f1 ff ff 8b 53 04 49 89 c5 0f
1f 44 00 00 31 ff e8 27 53 53 ff 45 84 ff 0f 85 50 02 00 00 fb 0f 1f
44 00 00 <45> 85 f6 0f 88 81 01 00 00 49 63 d6 48 8d 04 52 48 8d 04 82
49 8d
[ 3718.137724] RAX: ffff93c37f400000 RBX: ffff93c37f43f4a0 RCX: 000000000000001f
[ 3718.137748] R10: 0000000000000018 R11: ffff93c37f433ce4 R12: ffffffff965a2c80
[ 3718.137771]  do_idle+0x1e7/0x240
[ 3718.137783]  start_secondary+0x118/0x140
[ 3718.137732] RDX: 0000000000000008 RSI: 0000000028291fdf RDI: 0000000000000000
[ 3718.137764]  cpuidle_enter+0x29/0x40
[ 3718.137790]  common_startup_64+0x13e/0x141
[ 3718.137718] RSP: 0018:ffffa7ce001d3e90 EFLAGS: 00000246
[ 3718.137740] RBP: 0000000000000002 R08: 0000000000000000 R09: 000000000000004e
[ 3718.137755] R13: 00000361b240a0fa R14: 0000000000000002 R15: 0000000000000000
[ 3718.137777]  cpu_startup_entry+0x25/0x30
[ 3718.137797]  </TASK>
[ 3718.137800] Modules linked in: tls bluetooth sha3_generic
jitterentropy_rng drbg ansi_cprng ecdh_generic ecc crc16 xt_nat
xt_tcpudp veth xt_conntrack xt_MASQUERADE nf_conntrack_netlink
xfrm_user xt_addrtype nft_compat br_netfilter bridge nfsv3 nfs netfs
tcp_bbr sch_fq tun netconsole nvme_fabrics overlay pps_ldisc cfg80211
8021q garp stp mrp llc lz4 lz4_compress zram zsmalloc binfmt_misc xfs
nls_ascii nls_cp437 vfat fat nft_masq nft_redir nft_chain_nat nf_nat
intel_rapl_msr intel_rapl_common intel_uncore_frequency
intel_uncore_frequency_common x86_pkg_temp_thermal intel_powerclamp
coretemp nft_ct nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 kvm_intel
kvm ghash_clmulni_intel sha512_ssse3 sha512_generic sha256_ssse3
sha1_ssse3 snd_sof_pci_intel_tgl snd_sof_intel_hda_common
soundwire_intel soundwire_generic_allocation snd_sof_intel_hda_mlink
soundwire_cadence snd_sof_intel_hda snd_sof_pci snd_sof_xtensa_dsp
snd_sof aesni_intel snd_sof_utils crypto_simd snd_soc_hdac_hda cryptd
snd_hda_ext_

[ 3718.137839]  snd_soc_acpi snd_soc_core snd_hda_codec_realtek
snd_hda_codec_generic nfnetlink_log snd_compress rapl
snd_hda_scodec_component nft_log soundwire_bus snd_hda_intel mei_wdt
snd_intel_dspcfg mei_hdcp intel_cstate snd_intel_sdw_acpi
snd_hda_codec snd_hda_core snd_hwdep snd_pcm_oss eeepc_wmi
snd_mixer_oss asus_wmi snd_pcm iTCO_wdt intel_pmc_bxt snd_timer
battery sd_mod sparse_keymap iTCO_vendor_support snd mei_me
platform_profile ipmi_ssif rfkill pcspkr soundcore intel_uncore
wmi_bmof mei watchdog acpi_ipmi cdc_acm ipmi_si ipmi_devintf joydev
ipmi_msghandler intel_pmc_core intel_vsec pmt_telemetry pmt_class
acpi_pad acpi_tad sg evdev nfsd parport_pc nf_tables auth_rpcgss
nfs_acl ppdev lockd grace lp nfnetlink parport fuse loop efi_pstore
dm_mod sunrpc configfs ip_tables x_tables autofs4 cdc_ether usbnet mii
btrfs blake2b_generic efivarfs raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor uas usb_storage raid6_pq
libcrc32c crc32c_generic raid1 raid0
 md_mod hid_generic usbhid hid
[ 3718.137957]  sr_mod cdrom nvme nvme_core t10_pi ast ahci ixgbe
i2c_algo_bit libahci drm_shmem_helper xhci_pci crc64_rocksoft
xfrm_algo libata drm_kms_helper crc64 xhci_hcd dca mdio_devres
crc_t10dif scsi_mod intel_lpss_pci crct10dif_generic i2c_i801
crc32_pclmul video usbcore libphy drm crct10dif_pclmul intel_lpss igc
crc32c_intel i2c_smbus scsi_common mdio usb_common vmd wmi fan
crct10dif_common idma64 pinctrl_alderlake button
[ 3718.138083] CR2: 0000000000000018
[ 3718.138089] ---[ end trace 0000000000000000 ]---
[ 3741.360694] rcu: #011(detected by 25
[ 3741.360672] rcu: #0118-...!: (0 ticks this GP)
idle=0d94/1/0x4000000000000004 softirq=106413/106413 fqs=11
[ 3741.360712] Sending NMI from CPU 25 to CPUs 8:
[ 3741.360631] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 3741.360743] Hardware name: ASUSTeK COMPUTER INC. System Product
Name/Pro WS W680-ACE IPMI
[ 3741.360737] NMI backtrace for cpu 8
[ 3741.360744] RIP: 0010:memchr+0x5/0x30
[ 3741.360756] RSP: 0018:ffffa7ce003609d0 EFLAGS: 00000097
[ 3741.360739] CPU: 8 PID: 0 Comm: swapper/8 Tainted: G      D
   6.9.7 #2
[ 3741.360754] Code: cc cc cc cc 48 89 fb 48 89 d8 5b 5d 41 5c 41 5d
c3 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 48 01
fa eb 0c <48> 8d 47 01 40 38 37 74 0f 48 89 c7 48 39 d7 75 ef 31 c0 c3
cc cc
[ 3741.360764] FS:  0000000000000000(0000) GS:ffff93c37f400000(0000)
knlGS:0000000000000000
[ 3741.360760] RDX: ffff93c3fff6eb0c RSI: 000000000000000a RDI: ffff93c3fff6eae9
[ 3741.360762] R10: 00003fffffffffff R11: ffff93c3fff3c8a0 R12: 0000000000000024
[ 3741.360765] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3741.360767] PKRU: 55555554
[ 3741.360759] RAX: ffff93c3fff6eae9 RBX: 0000000000000001 RCX: 0000000000000000
[ 3741.360761] RBP: 00000000ffffe0b4 R08: fffffffffffc3320 R09: ffffa7ce00360a08
[ 3741.360763] R13: 00000000000000b4 R14: ffffffff96f0bd20 R15: ffff93c3fff6eae8
[ 3741.360766] CR2: 0000000000000018 CR3: 00000001bddfc005 CR4: 0000000000770ef0
[ 3741.360768] Call Trace:
[ 3741.360770]  <NMI>
[ 3741.360774]  ? nmi_cpu_backtrace+0x95/0x110
[ 3741.360778]  ? nmi_cpu_backtrace_handler+0xd/0x20
[ 3741.360783]  ? nmi_handle+0x5a/0x150
[ 3741.360787]  ? default_do_nmi+0x40/0x100
[ 3741.360792]  ? exc_nmi+0x11e/0x1a0
[ 3741.360794]  ? end_repeat_nmi+0xf/0x53
[ 3741.360799]  ? memchr+0x5/0x30
[ 3741.360801]  ? memchr+0x5/0x30
[ 3741.360803]  ? memchr+0x5/0x30
[ 3741.360804]  </NMI>
[ 3741.360805]  <IRQ>
[ 3741.360805]  _prb_read_valid+0x1d8/0x310
[ 3741.360810]  prb_read_valid_info+0x41/0x60
[ 3741.360811]  find_first_fitting_seq+0xd5/0x1b0
[ 3741.360815]  kmsg_dump_get_buffer+0xe8/0x1d0
[ 3741.360818]  pstore_dump+0x171/0x370
[ 3741.360825]  kmsg_dump+0x43/0x60
[ 3741.360827]  oops_end+0x68/0xe0
[ 3741.360829]  page_fault_oops+0x19d/0x560
[ 3741.360832]  ? __slab_free+0xdf/0x2f0
[ 3741.360840]  exc_page_fault+0x72/0x170
[ 3741.360845]  asm_exc_page_fault+0x22/0x30
[ 3741.360848] RIP: 0010:btrfs_clone_write_end_io+0x1e/0x60 [btrfs]
[ 3741.360952] Code: 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00
00 55 53 48 8b 6f 40 48 89 fb 80 7f 19 00 48 8b 45 20 75 27 80 7f 10
07 74 13 <48> 8b 78 18 e8 a9 0d 39 d4 48 89 df 5b 5d e9 4f 09 39 d4 48
8b 57
[ 3741.360953] RSP: 0018:ffffa7ce00360e80 EFLAGS: 00010097
[ 3741.360954] RAX: 0000000000000000 RBX: ffff93a999c31900 RCX: ffff93a4a50c03b0
[ 3741.360954] RDX: ffff93a480df4d40 RSI: ffff93a999c31900 RDI: ffff93a999c31900
[ 3741.360955] RBP: ffff93a9766f8598 R08: ffff93a925547000 R09: 0000000080080007
[ 3741.360956] R10: 0000000080080007 R11: ffffa7ce00360ff8 R12: 0000000000000000
[ 3741.360957] R13: ffff93a999c31900 R14: 0000000000004000 R15: 0000000000004000
[ 3741.360960]  blk_update_request+0x110/0x470
[ 3741.360965]  ? kfree+0x24f/0x290
[ 3741.360967]  blk_mq_end_request+0x18/0x30
[ 3741.360969]  nvme_poll_cq+0x18f/0x360 [nvme]
[ 3741.360976]  nvme_irq+0x3e/0x80 [nvme]
[ 3741.360980]  __handle_irq_event_percpu+0x43/0x1a0
[ 3741.360983]  handle_irq_event+0x34/0x70
[ 3741.360985]  handle_edge_irq+0x87/0x220
[ 3741.360990]  __common_interrupt+0x38/0xa0
[ 3741.360992]  common_interrupt+0x7c/0xa0
[ 3741.360996]  </IRQ>
[ 3741.360996]  <TASK>
[ 3741.360997]  asm_common_interrupt+0x22/0x40
[ 3741.360999] RIP: 0010:cpuidle_enter_state+0xc8/0x430
[ 3741.361000] Code: 4e 44 54 ff e8 a9 f1 ff ff 8b 53 04 49 89 c5 0f
1f 44 00 00 31 ff e8 27 53 53 ff 45 84 ff 0f 85 50 02 00 00 fb 0f 1f
44 00 00 <45> 85 f6 0f 88 81 01 00 00 49 63 d6 48 8d 04 52 48 8d 04 82
49 8d
[ 3741.361002] RSP: 0018:ffffa7ce001d3e90 EFLAGS: 00000246
[ 3741.361003] RAX: ffff93c37f400000 RBX: ffff93c37f43f4a0 RCX: 000000000000001f
[ 3741.361003] RDX: 0000000000000008 RSI: 0000000028291fdf RDI: 0000000000000000
[ 3741.361004] RBP: 0000000000000002 R08: 0000000000000000 R09: 000000000000004e
[ 3741.361005] R10: 0000000000000018 R11: ffff93c37f433ce4 R12: ffffffff965a2c80
[ 3741.361005] R13: 00000361b240a0fa R14: 0000000000000002 R15: 0000000000000000
[ 3741.361007]  cpuidle_enter+0x29/0x40
[ 3741.361012]  do_idle+0x1e7/0x240
[ 3741.361016]  cpu_startup_entry+0x25/0x30
[ 3741.361018]  start_secondary+0x118/0x140
[ 3741.361021]  common_startup_64+0x13e/0x141
[ 3741.361025]  </TASK>
[ 3742.257557] RIP: 0010:btrfs_clone_write_end_io+0x1e/0x60 [btrfs]
[ 3742.279785] Code: 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00
00 55 53 48 8b 6f 40 48 89 fb 80 7f 19 00 48 8b 45 20 75 27 80 7f 10
07 74 13 <48> 8b 78 18 e8 a9 0d 39 d4 48 89 df 5b 5d e9 4f 09 39 d4 48
8b 57
[ 3742.280179] RSP: 0018:ffffa7ce00360e80 EFLAGS: 00010097
[ 3742.280565] RAX: 0000000000000000 RBX: ffff93a999c31900 RCX: ffff93a4a50c03b0
[ 3742.280954] RDX: ffff93a480df4d40 RSI: ffff93a999c31900 RDI: ffff93a999c31900
[ 3742.281344] RBP: ffff93a9766f8598 R08: ffff93a925547000 R09: 0000000080080007
[ 3742.281744] R10: 0000000080080007 R11: ffffa7ce00360ff8 R12: 0000000000000000
[ 3742.282135] R13: ffff93a999c31900 R14: 0000000000004000 R15: 0000000000004000
[ 3742.282517] FS:  0000000000000000(0000) GS:ffff93c37f400000(0000)
knlGS:0000000000000000
[ 3742.282898] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3742.283268] CR2: 0000000000000018 CR3: 00000001bddfc005 CR4: 0000000000770ef0
[ 3742.283635] PKRU: 55555554
[ 3742.283995] Kernel panic - not syncing: Fatal exception in interrupt
[ 3742.284361] Kernel Offset: 0x13800000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[ 3745.782698] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---
[   15.181985] netconsole-setup: Test log message to verify netconsole
configuration.
[   15.467680] NFSD: Using nfsdcld client tracking operations.
[   15.468142] NFSD: no clients to reclaim
