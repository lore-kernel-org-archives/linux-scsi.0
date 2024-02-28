Received: from outgoing.selfhost.de (mordac.selfhost.de [82.98.82.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302AD70030
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 21:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.98.82.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709156146; cv=none; b=SQLlv+jejNanX5BwZxb1LniKVp9S5eLv3sfj85sFXOOyOB5hf4yuipKh42s5Hcj0Buo1wB5BNCXk38S9PZSieXhQdK9XxdWOilLzjrQSMJs80vAc8yoWeNFI7kK5+6+VAAlK32UXTJPXUY6fpFCdO2YL/THrylXiSjhyJIGfwGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709156146; c=relaxed/simple;
	bh=y5TkRUVAyH+4mYbfT+itC8UOcPzYmoCQvzYxK+mCI8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aVKB07umcOOoPa/NlPo43bqjIFxKukKRmu67mMy/6AbDoxFUXlJtub93XYZPjcnrVvwg2jXi//vDf+4c0kqFjoeRQth23atvpV0WtI35JN/hCzvCgr8topU1D6WbHccojwXGAY+nzzjxeU9vvcIlKxgMXs6Rb5stGZ0GGc7WRs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=afaics.de; spf=none smtp.mailfrom=afaics.de; arc=none smtp.client-ip=82.98.82.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=afaics.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=afaics.de
Received: (qmail 26816 invoked from network); 28 Feb 2024 21:29:02 -0000
Received: from unknown (HELO mailhost.afaics.de) (postmaster@xqrsonfo.mail.selfhost.de@79.192.199.18)
  by mailout.selfhost.de with ESMTPA; 28 Feb 2024 21:29:02 -0000
X-Spam-Level: ****
X-Spam-Report: 
	*  4.0 RCVD_IN_PBL RBL: Last ext relay in Spamhaus PBL (Non-MTA IPs)
	*      [2003:e3:1f31:6503:68fd:ffff:fe6f:e76 listed in]
	[zen.spamhaus.org]
	*  0.0 RCVD_IN_DNSWL_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to DNSWL
	*      was blocked.  See
	*      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block for
	*      more information.
	*      [2003:e3:1f31:6503:68fd:ffff:fe6f:e76 listed in]
	[list.dnswl.org]
	*  0.0 HELO_NO_DOMAIN Relay reports its domain incorrectly
	*  0.0 DMARC_MISSING Missing DMARC policy
Received: from [IPV6:2003:e3:1f31:6503:68fd:ffff:fe6f:e76] (p200300e31f31650368fdfffffe6f0e76.dip0.t-ipconnect.de [2003:e3:1f31:6503:68fd:ffff:fe6f:e76])
	by marvin.afaics.de (OpenSMTPD) with ESMTP id cb728ad1;
	Wed, 28 Feb 2024 22:28:56 +0100 (CET)
Message-ID: <81499610-bbac-4957-a2ab-331db68455f0@afaics.de>
Date: Wed, 28 Feb 2024 22:28:54 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Subject: Re: RIP on discard, JMicron USB adaptor
To: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>,
 Keith Busch <kbusch@kernel.org>
Cc: Harald Dunkel <harald.dunkel@aixigo.com>, Jens Axboe <axboe@kernel.dk>,
 Bart Van Assche <bvanassche@acm.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-block@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org
References: <70bc51d7-c8a2-4b06-ab7a-e321d20db49a@aixigo.com>
 <62296d89-f7e6-4f54-add8-35b531dc657c@rowland.harvard.edu>
 <Zd9Xbz3L6JEvBHHT@kbusch-mbp>
 <76fcb1b1-cdf2-45d0-aeab-c712ee517b34@rowland.harvard.edu>
 <4111f9ba-e1dc-4158-af6f-c048bcf8ccd2@suse.com>
From: Harald Dunkel <harri@afaics.de>
Content-Language: en-US
Autocrypt: addr=harri@afaics.de; keydata=
 xsBNBFIHbdABCACYHRLHGdFRk7bWkgdPhDLin6jLIS0ppegsx0Vc9STFyiHFUW+6HU9ZYTpO
 f2qbcWlE3YJYacy6zOiiTjYX31quhvGrP3UJXKjXsAp7CFsMxRJUhm20Ph0nCl/Oed9SDNXN
 HQJwHoOVWrsu/sGxNTfjCWRJleBE11P+TuuLOAP9dbqFbWhmkTsE9Lp9d16Ak77MWmWWxBvD
 cBsUuC2GOYDfFOPM3j16w7aw4Y9GI2B5QzFiHvOR/hCazfDEMQAlaHMm6sH8uzrjNEtB5dvm
 vxF8j/IpvsuvWGhZ68rej2gPwoVrRTEBaYslW8/5dm8o1HuTkuLqxhNTcvYWyV8uKRtTABEB
 AAHNH0hhcmFsZCBEdW5rZWwgPGhhcnJpQGFmYWljcy5kZT7CwHoEEwEIACQCGwMCHgECF4AC
 GQEFAlQYLhUFCwkIBwMFFQoJCAsFFgIDAQAACgkQCp4qnmbTgcu7Fwf/RoWwNDxJPD96vBFb
 Jzfta9qVA0JpbKoMAnNY0tDWiF5Ur8UY/tv/RDVV44Vx3Ef0fzQZN0CtHsNfAKO+KXBMUiuT
 AP4AadpaIwYMo8v+SmPzJSUxWgBm6IsHwn1udXRdEgdR9guWkLPRGCK3x84sorAOUnUHJHkq
 UrDFQUNfNA9lqM7ttunfVtG4SaqcLEOpJ1s/aMUsEODlP/lws42VjubIVg403cMIgvqs5cT8
 EjLDNqCwEoWZRhfpg5x3D5uNDNWSW70Z+6Knicbi129QIu4HtSnfrxiuvHz2LLPFOVQuj8h4
 TPT6tkfIURKipFXoIC3YiK8f94rFO3q86oNJUs7ATQRSB23QAQgA27gQiXZ96pbJkGoz1RWX
 T8WSQJ5TWVJyf4eswoVI8Ffk5vLE+xPpAYEDkL7JYGCvBN1BKrcaZzDy8Irfys6bHI3JmVVi
 ZloSkVS8QL7pQGfp74VT3NvDjK6LDe9QMv8Rb45laSRD5XCGRMTxz9pwu3vNcOPCfV5nmbyB
 /6h4/bguFH1+6aGz6HyC8v/tjhL6+cY329inJ+vWVJYssweMIIYpssUtDaPKZO0080toLLrt
 KuVgiUb9llbmZgKGElRjwgGT8AUXDRFCzn0ws/nuGNw0L+EdCI3VdZSK5KMEO34vZq7iNeM1
 ZVnPVZAbHheR30NFKTgrwvlt8G7blHJPWwARAQABwsBfBBgBCAAJBQJSB23QAhsMAAoJEAqe
 Kp5m04HLiiEH/jlKumVyQrOxH58iQFzVDthDfJdBLmnDlfVx2Dzn60vc5To6yJ3fwO21s3xC
 /LW9aZSfDueV0nWU4/Wow/X5GEH90Vc1sFoeSZb/GW03vsO1n/OFIVlv9GQv+RviWMDEwKKx
 CMvdqUlVblWf1iT/ngPN0YawKGF0Dgn8TRzfL/Tq9muwNUaONzz8PWBUIm1+8JDZszYLzLoz
 YiY0usL4GH9BCeW6XG2Q6j4cpyOQZ0VKiBs1Rh+dmswn+iXLfi08Q0IxYAD6wjHdJTBD9pE9
 5Uj8/1spt51FBAAIP+7sd2mpAvsNnojatuOgjBmBxFwiOKeyDNe1wvKr4dsRheOLV8M=
In-Reply-To: <4111f9ba-e1dc-4158-af6f-c048bcf8ccd2@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-02-28 17:11:16, Oliver Neukum wrote:
> 
> Hi,
> 
> that seems to be conditional on READ_CAPACITY_16 being used.
>   From the cropped dmesg we cannot tell. We need more.
> 
> 	Regards
> 		Oliver

Hope this helps:

```
[1399898.541790] usb 2-2: new SuperSpeed Plus Gen 2x1 USB device number 77 using xhci_hcd
[1399898.562427] usb 2-2: New USB device found, idVendor=152d, idProduct=0583, bcdDevice=31.08
[1399898.562439] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[1399898.562444] usb 2-2: Product: USB Storage Device
[1399898.562447] usb 2-2: Manufacturer: JMicron
[1399898.562449] usb 2-2: SerialNumber: DD56419885A7C
[1399898.584864] scsi host9: uas
[1399898.585396] scsi 9:0:0:0: Direct-Access     CT500P2S SD8              3108 PQ: 0 ANSI: 6
[1399898.587031] sd 9:0:0:0: Attached scsi generic sg5 type 0
[1399902.581473] usb 2-2: USB disconnect, device number 77
[1399902.581684] sd 9:0:0:0: [sdf] tag#26 uas_zap_pending 0 uas-tag 1 inflight: CMD
[1399902.581692] sd 9:0:0:0: [sdf] tag#26 CDB: Test Unit Ready 00 00 00 00 00 00
[1399902.581827] sd 9:0:0:0: [sdf] Test Unit Ready failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[1399902.581859] sd 9:0:0:0: [sdf] Read Capacity(16) failed: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[1399902.581864] sd 9:0:0:0: [sdf] Sense not available.
[1399902.581874] sd 9:0:0:0: [sdf] Read Capacity(10) failed: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[1399902.581877] sd 9:0:0:0: [sdf] Sense not available.
[1399902.581884] sd 9:0:0:0: [sdf] 0 512-byte logical blocks: (0 B/0 B)
[1399902.581888] sd 9:0:0:0: [sdf] 0-byte physical blocks
[1399902.581894] sd 9:0:0:0: [sdf] Write Protect is off
[1399902.581897] sd 9:0:0:0: [sdf] Mode Sense: 00 00 00 00
[1399902.581902] sd 9:0:0:0: [sdf] Asking for cache data failed
[1399902.581905] sd 9:0:0:0: [sdf] Assuming drive cache: write through
[1399902.581910] sd 9:0:0:0: [sdf] Preferred minimum I/O size 4096 bytes not a multiple of physical block size (0 bytes)
[1399902.581914] sd 9:0:0:0: [sdf] Optimal transfer size 33553920 bytes not a multiple of physical block size (0 bytes)
[1399902.582741] sd 9:0:0:0: [sdf] Attached SCSI disk
[1399903.684404] usb usb2-port2: config error
[1399904.133524] usb 2-2: new SuperSpeed Plus Gen 2x1 USB device number 78 using xhci_hcd
[1399904.154230] usb 2-2: New USB device found, idVendor=152d, idProduct=0583, bcdDevice=31.08
[1399904.154241] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[1399904.154246] usb 2-2: Product: USB Storage Device
[1399904.154249] usb 2-2: Manufacturer: JMicron
[1399904.154251] usb 2-2: SerialNumber: DD56419885A7C
[1399904.161183] scsi host9: uas
[1399904.162037] scsi 9:0:0:0: Direct-Access     SAMSUNG  MZVLB1T0HALR     3108 PQ: 0 ANSI: 6
[1399904.164156] sd 9:0:0:0: Attached scsi generic sg5 type 0
[1399904.164524] sd 9:0:0:0: [sdf] 2000409264 512-byte logical blocks: (1.02 TB/954 GiB)
[1399904.164534] sd 9:0:0:0: [sdf] 4096-byte physical blocks
[1399904.164685] sd 9:0:0:0: [sdf] Write Protect is off
[1399904.164689] sd 9:0:0:0: [sdf] Mode Sense: 5f 00 00 08
[1399904.164952] sd 9:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[1399904.164957] sd 9:0:0:0: [sdf] Preferred minimum I/O size 4096 bytes
[1399904.164960] sd 9:0:0:0: [sdf] Optimal transfer size 33553920 bytes not a multiple of preferred minimum block size (4096 bytes)
[1399904.169442]  sdf: sdf1 sdf2
[1399904.169884] sd 9:0:0:0: [sdf] Attached SCSI disk
[1399976.536628]  sdf: sdf1 sdf2
[1400046.913154]  sdf: sdf1
[1400783.346828] usb 2-2: USB disconnect, device number 78
[1400783.410736] sd 9:0:0:0: [sdf] Synchronizing SCSI cache
[1400783.650712] sd 9:0:0:0: [sdf] Synchronize Cache(10) failed: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[1400804.017811] usb 1-12.2: new high-speed USB device number 5 using xhci_hcd
[1400804.166350] usb 1-12.2: New USB device found, idVendor=152d, idProduct=0583, bcdDevice=31.08
[1400804.166362] usb 1-12.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[1400804.166366] usb 1-12.2: Product: USB Storage Device
[1400804.166369] usb 1-12.2: Manufacturer: JMicron
[1400804.166372] usb 1-12.2: SerialNumber: DD56419885A7C
[1400804.171592] scsi host9: uas
[1400804.172318] scsi 9:0:0:0: Direct-Access     SAMSUNG  MZVLB1T0HALR     3108 PQ: 0 ANSI: 6
[1400804.174579] sd 9:0:0:0: Attached scsi generic sg5 type 0
[1400806.348784] sd 9:0:0:0: [sdf] 2000409264 512-byte logical blocks: (1.02 TB/954 GiB)
[1400806.348791] sd 9:0:0:0: [sdf] 4096-byte physical blocks
[1400806.348991] sd 9:0:0:0: [sdf] Write Protect is off
[1400806.348994] sd 9:0:0:0: [sdf] Mode Sense: 6b 00 00 08
[1400806.349351] sd 9:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[1400806.349354] sd 9:0:0:0: [sdf] Preferred minimum I/O size 4096 bytes
[1400806.349355] sd 9:0:0:0: [sdf] Optimal transfer size 33553920 bytes not a multiple of preferred minimum block size (4096 bytes)
[1400806.353357]  sdf: sdf1
[1400806.353638] sd 9:0:0:0: [sdf] Attached SCSI disk
[1400821.811585] ------------[ cut here ]------------
[1400821.811594] WARNING: CPU: 0 PID: 614303 at block/blk-lib.c:50 __blkdev_issue_discard+0x14b/0x180
[1400821.811612] Modules linked in: cdc_mbim cdc_wdm tcp_diag udp_diag inet_diag exfat snd_seq_dummy snd_hrtimer snd_seq_midi snd_seq_midi_event snd_seq cpufreq_userspace cpufreq_conservative cpufreq_powersave cpufreq_ondemand cts rpcsec_gss_krb5 nfsv4 dns_resolver nfs lockd grace fscache netfs 
scsi_transport_iscsi nvme_fabrics dell_rbu rfkill qrtr dcdbas uinput binfmt_misc nls_ascii nls_cp437 vfat fat nvidia_drm(POE) nvidia_modeset(POE) intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal snd_hda_codec_realtek intel_powerclamp xt_recent snd_hda_codec_generic ledtrig_audio coretemp 
snd_sof_pci_intel_tgl snd_sof_intel_hda_common soundwire_intel soundwire_generic_allocation soundwire_cadence snd_sof_intel_hda snd_sof_pci snd_sof_xtensa_dsp snd_sof snd_sof_utils snd_soc_hdac_hda snd_hda_codec_hdmi snd_hda_ext_core snd_soc_acpi_intel_match snd_soc_acpi snd_soc_core snd_compress 
soundwire_bus snd_hda_intel snd_usb_audio snd_intel_dspcfg br_netfilter snd_intel_sdw_acpi kvm_intel overlay
[1400821.811692]  snd_usbmidi_lib i915 xt_comment snd_hda_codec uvcvideo xt_CHECKSUM snd_rawmidi snd_hda_core videobuf2_vmalloc kvm drm_buddy snd_seq_device nf_tables snd_hwdep videobuf2_memops drm_display_helper videobuf2_v4l2 nfnetlink snd_pcm_oss irqbypass videobuf2_common bridge snd_mixer_oss 
cec 8021q videodev rapl garp rc_core intel_cstate mei_hdcp nvidia(POE) snd_pcm evdev stp mc wmi_bmof gigabyte_wmi mrp intel_uncore ttm iTCO_wdt llc snd_timer intel_pmc_bxt bonding pcspkr drm_kms_helper macvlan snd iTCO_vendor_support intel_hid tls watchdog soundcore veth i2c_algo_bit sg 
sparse_keymap acpi_pad intel_pmc_core acpi_tad button mei_me mei iptable_nat iptable_mangle iptable_filter ip6table_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 auth_rpcgss ip6table_mangle ip6table_filter ip6_tables drm fuse loop efi_pstore sunrpc configfs ip_tables x_tables autofs4 ext4 
crc16 mbcache jbd2 btrfs blake2b_generic zstd_compress efivarfs raid10 raid456 async_raid6_recov async_memcpy async_pq
[1400821.811799]  async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid0 multipath linear hid_logitech_hidpp hid_logitech_dj uas usb_storage hid_generic usbhid hid cdc_ncm cdc_ether usbnet raid1 md_mod r8152 mii sd_mod dm_mod crc32_pclmul crc32c_intel ghash_clmulni_intel sha512_ssse3 
sha512_generic sha256_ssse3 sha1_ssse3 nvme nvme_core ahci xhci_pci t10_pi libahci crc64_rocksoft_generic xhci_hcd libata aesni_intel r8169 realtek crc64_rocksoft crc_t10dif mdio_devres usbcore scsi_mod crypto_simd libphy cryptd crct10dif_generic intel_lpss_pci i2c_i801 crct10dif_pclmul crc64 
crct10dif_common intel_lpss i2c_smbus idma64 usb_common scsi_common fan video wmi pinctrl_alderlake
[1400821.811868] CPU: 0 PID: 614303 Comm: blkdiscard Tainted: P           OE      6.1.0-18-amd64 #1  Debian 6.1.76-1
[1400821.811875] Hardware name: Gigabyte Technology Co., Ltd. Z790 GAMING X/Z790 GAMING X, BIOS F9b 11/10/2023
[1400821.811878] RIP: 0010:__blkdev_issue_discard+0x14b/0x180
[1400821.811887] Code: 48 39 d8 75 8b f7 da 89 d3 c1 eb 09 eb 85 48 8b 04 24 4c 89 20 48 83 c4 08 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc <0f> 0b 48 c7 c6 80 fd 0a a9 48 c7 c7 40 2c b9 a9 e8 60 45 4f 00 85
[1400821.811891] RSP: 0018:ffffb3d7a50d7d50 EFLAGS: 00010246
[1400821.811896] RAX: ffff9fb0cb248750 RBX: ffff9fbb794612c0 RCX: ffff9fb60167be80
[1400821.811899] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9fbb794612c0
[1400821.811902] RBP: 0000000000000cc0 R08: ffffb3d7a50d7d90 R09: fffff5f4d6f7efc0
[1400821.811904] R10: 000000000ee778ff R11: 0000000000000000 R12: 0000000000000000
[1400821.811907] R13: 00000000773bc800 R14: 000000ee77900000 R15: ffff9fbb794612c0
[1400821.811910] FS:  00007f2af0e95740(0000) GS:ffff9fbb7f200000(0000) knlGS:0000000000000000
[1400821.811914] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1400821.811917] CR2: 00007ffc65eec170 CR3: 00000002dcf78000 CR4: 0000000000750ef0
[1400821.811920] PKRU: 55555554
[1400821.811923] Call Trace:
[1400821.811926]  <TASK>
[1400821.811931]  ? __warn+0x7d/0xc0
[1400821.811938]  ? __blkdev_issue_discard+0x14b/0x180
[1400821.811945]  ? report_bug+0xe2/0x150
[1400821.811955]  ? handle_bug+0x41/0x70
[1400821.811959]  ? exc_invalid_op+0x13/0x60
[1400821.811963]  ? asm_exc_invalid_op+0x16/0x20
[1400821.811974]  ? __blkdev_issue_discard+0x14b/0x180
[1400821.811982]  blkdev_issue_discard+0x7e/0xe0
[1400821.811990]  blkdev_common_ioctl+0x61f/0xa30
[1400821.811999]  blkdev_ioctl+0x104/0x270
[1400821.812006]  __x64_sys_ioctl+0x8d/0xd0
[1400821.812013]  do_syscall_64+0x58/0xc0
[1400821.812017]  ? do_user_addr_fault+0x1b0/0x580
[1400821.812023]  ? exit_to_user_mode_prepare+0x40/0x1e0
[1400821.812030]  entry_SYSCALL_64_after_hwframe+0x64/0xce
[1400821.812038] RIP: 0033:0x7f2af0f95c5b
[1400821.812042] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[1400821.812046] RSP: 002b:00007ffc65ecec40 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[1400821.812051] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2af0f95c5b
[1400821.812054] RDX: 00007ffc65eced00 RSI: 0000000000001277 RDI: 0000000000000003
[1400821.812056] RBP: 0000000000000000 R08: 0000000000000007 R09: 0000563c2300a2f0
[1400821.812058] R10: 00007ffc65eec170 R11: 0000000000000246 R12: 000000ee77900000
[1400821.812061] R13: 0000000000000003 R14: 0000563c2300a2f0 R15: 0000000000000000
[1400821.812065]  </TASK>
[1400821.812067] ---[ end trace 0000000000000000 ]---
[1400821.812070] sdf1: Error: discard_granularity is 0.
[1401126.140729] pcieport 0000:00:06.0: AER: Corrected error received: 0000:00:06.0
[1401126.140746] pcieport 0000:00:06.0: PCIe Bus Error: severity=Corrected, type=Physical Layer, (Receiver ID)
[1401126.140750] pcieport 0000:00:06.0:   device [8086:a74d] error status/mask=00000001/00002000
[1401126.140755] pcieport 0000:00:06.0:    [ 0] RxErr                  (First)
[1402010.765351] sdf1: Error: discard_granularity is 0.
[1402075.882687] EXT4-fs (sdf1): mounted filesystem with ordered data mode. Quota mode: none.
[1403520.146976] pcieport 0000:00:06.0: AER: Corrected error received: 0000:00:06.0
[1403520.146992] pcieport 0000:00:06.0: PCIe Bus Error: severity=Corrected, type=Physical Layer, (Receiver ID)
[1403520.146996] pcieport 0000:00:06.0:   device [8086:a74d] error status/mask=00000001/00002000
[1403520.147001] pcieport 0000:00:06.0:    [ 0] RxErr                  (First)
[1405438.512551] pcieport 0000:00:06.0: AER: Corrected error received: 0000:00:06.0
[1405438.512567] pcieport 0000:00:06.0: PCIe Bus Error: severity=Corrected, type=Physical Layer, (Receiver ID)
[1405438.512572] pcieport 0000:00:06.0:   device [8086:a74d] error status/mask=00000001/00002000
[1405438.512577] pcieport 0000:00:06.0:    [ 0] RxErr                  (First)
[1405970.427563] tun: Universal TUN/TAP device driver, 1.6
[1405970.427818] br0: port 2(vnet0) entered blocking state
[1405970.427820] br0: port 2(vnet0) entered disabled state
[1405970.427841] device vnet0 entered promiscuous mode
[1405970.427947] br0: port 2(vnet0) entered blocking state
[1405970.427948] br0: port 2(vnet0) entered forwarding state
[1406317.336783] EXT4-fs (sdf1): unmounting filesystem.
[1406372.516061] usb 1-12.2: USB disconnect, device number 5
[1406372.575968] sd 9:0:0:0: [sdf] Synchronizing SCSI cache
[1406372.815945] sd 9:0:0:0: [sdf] Synchronize Cache(10) failed: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
```

Sorry, I should have included this right from the start.


Regards
Harri
