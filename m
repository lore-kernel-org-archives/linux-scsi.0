Received: from outgoing.selfhost.de (mordac.selfhost.de [82.98.82.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C369A4F1F9
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 08:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.98.82.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709194877; cv=none; b=CAM7w0+KLcaP+10wuuqofTaR1te4xdLzKZfVHt9m7kMwd3NKcUPs5l3swJWCsaaNkFMvb4byM4Iisw7na+uUZqHOyd0/GtmB5OwJ3xc/Ft3qzIn8WwX+9xmTZ+hzwSxlj1O2Sgscdm8fC9bOC9hlhhic2SJEi5yBDFUaeGwaQhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709194877; c=relaxed/simple;
	bh=c3/1KWXdvm/MBju6h/jrIHxJ8idnwvwGpTR00gWFSzg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=hTx/rz3Fj04+PMEOlZC6fk0eWgCIoSUa7kb/2PS0ec/Lm+LYQzfbiKNobEyNwRzOzBwIKifmilzEEUDHupLCjLf4tn3ZgaVBs1QWtVV1Bie32otpzhOe4zmCG27FBuZkCpmdEFDfdVRQ0yqnu6qOrUb5P5c9iNmuJcTQyBZsuMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=afaics.de; spf=none smtp.mailfrom=afaics.de; arc=none smtp.client-ip=82.98.82.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=afaics.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=afaics.de
Received: (qmail 15066 invoked from network); 29 Feb 2024 08:21:12 -0000
Received: from unknown (HELO mailhost.afaics.de) (postmaster@xqrsonfo.mail.selfhost.de@79.192.199.18)
  by mailout.selfhost.de with ESMTPA; 29 Feb 2024 08:21:12 -0000
X-Spam-Level: ****
X-Spam-Report: 
	*  4.0 RCVD_IN_PBL RBL: Last ext relay in Spamhaus PBL (Non-MTA IPs)
	*      [2003:e3:1f31:6503:8865:8fff:feb7:694d listed in]
	[zen.spamhaus.org]
	*  0.0 HELO_NO_DOMAIN Relay reports its domain incorrectly
	*  0.0 KHOP_HELO_FCRDNS Relay HELO differs from its IP's reverse DNS
	*  0.0 DMARC_MISSING Missing DMARC policy
Received: from [IPV6:2003:e3:1f31:6503:8865:8fff:feb7:694d] (p200300e31f31650388658ffffeb7694d.dip0.t-ipconnect.de [2003:e3:1f31:6503:8865:8fff:feb7:694d])
	by marvin.afaics.de (OpenSMTPD) with ESMTP id db5b7ac1;
	Thu, 29 Feb 2024 09:21:08 +0100 (CET)
Message-ID: <633b4ae2-408c-469a-8df1-7530de9f7a97@afaics.de>
Date: Thu, 29 Feb 2024 09:21:08 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Subject: Re: RIP on discard, JMicron USB adaptor
From: Harald Dunkel <harri@afaics.de>
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
 <81499610-bbac-4957-a2ab-331db68455f0@afaics.de>
 <5baf28bd-b89e-49aa-ad66-6725ba9a87f9@afaics.de>
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
In-Reply-To: <5baf28bd-b89e-49aa-ad66-6725ba9a87f9@afaics.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-02-29 08:31:51, Harald Dunkel wrote:
> Good news (sort of): I was able to reproduce the problem after a
> power cycle. Full dmesg output is attached. Hope this helps.
> 

And for 6.7.6:

```
[Thu Feb 29 09:11:05 2024] usb 1-4: reset high-speed USB device number 3 using xhci_hcd
[Thu Feb 29 09:11:10 2024] logitech-hidpp-device 0003:046D:4082.0007: HID++ 4.5 device connected.
[Thu Feb 29 09:11:37 2024] usb 1-12.1: new high-speed USB device number 13 using xhci_hcd
[Thu Feb 29 09:11:38 2024] usb 1-12.1: New USB device found, idVendor=152d, idProduct=0583, bcdDevice=31.08
[Thu Feb 29 09:11:38 2024] usb 1-12.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[Thu Feb 29 09:11:38 2024] usb 1-12.1: Product: USB Storage Device
[Thu Feb 29 09:11:38 2024] usb 1-12.1: Manufacturer: JMicron
[Thu Feb 29 09:11:38 2024] usb 1-12.1: SerialNumber: DD56419885A7C
[Thu Feb 29 09:11:38 2024] scsi host9: uas
[Thu Feb 29 09:11:38 2024] scsi 9:0:0:0: Direct-Access     SAMSUNG  MZVLB1T0HALR     3108 PQ: 0 ANSI: 6
[Thu Feb 29 09:11:38 2024] sd 9:0:0:0: Attached scsi generic sg5 type 0
[Thu Feb 29 09:11:40 2024] sd 9:0:0:0: [sdf] 2000409264 512-byte logical blocks: (1.02 TB/954 GiB)
[Thu Feb 29 09:11:40 2024] sd 9:0:0:0: [sdf] 4096-byte physical blocks
[Thu Feb 29 09:11:40 2024] sd 9:0:0:0: [sdf] Write Protect is off
[Thu Feb 29 09:11:40 2024] sd 9:0:0:0: [sdf] Mode Sense: 6b 00 00 08
[Thu Feb 29 09:11:40 2024] sd 9:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[Thu Feb 29 09:11:40 2024] sd 9:0:0:0: [sdf] Preferred minimum I/O size 4096 bytes
[Thu Feb 29 09:11:40 2024] sd 9:0:0:0: [sdf] Optimal transfer size 33553920 bytes not a multiple of preferred minimum block size (4096 bytes)
[Thu Feb 29 09:11:40 2024]  sdf: sdf1
[Thu Feb 29 09:11:40 2024] sd 9:0:0:0: [sdf] Attached SCSI disk
[Thu Feb 29 09:12:53 2024] ------------[ cut here ]------------
[Thu Feb 29 09:12:53 2024] WARNING: CPU: 0 PID: 3290 at block/blk-lib.c:50 __blkdev_issue_discard+0x13e/0x180
[Thu Feb 29 09:12:53 2024] Modules linked in: snd_seq_dummy snd_hrtimer snd_seq_midi snd_seq_midi_event snd_seq cpufreq_userspace cpufreq_conservative cpufreq_powersave cpufreq_ondemand cbc cts rpcsec_gss_krb5 nfsv4 dns_resolver nfs lockd grace fscache netfs scsi_transport_iscsi nvme_fabrics 
dell_rbu rfkill qrtr dcdbas uinput binfmt_misc nls_utf8 nls_cp437 vfat fat nvidia_drm(PO) nvidia_modeset(PO) intel_rapl_msr intel_rapl_common snd_hda_codec_realtek intel_uncore_frequency snd_hda_codec_generic ledtrig_audio intel_uncore_frequency_common x86_pkg_temp_thermal intel_powerclamp coretemp 
kvm_intel kvm snd_hda_codec_hdmi irqbypass mei_pxp mei_hdcp i915 snd_hda_intel rapl snd_intel_dspcfg snd_usb_audio cec snd_hda_codec snd_usbmidi_lib drm_buddy intel_cstate uvcvideo snd_hda_core snd_rawmidi videobuf2_vmalloc drm_display_helper snd_hwdep snd_seq_device uvc snd_pcm_oss videobuf2_memops 
ttm snd_mixer_oss videobuf2_v4l2 snd_pcm tpm_crb videodev drm_kms_helper tpm_tis snd_timer videobuf2_common evdev tpm_tis_core snd intel_gtt intel_uncore
[Thu Feb 29 09:12:53 2024]  wmi_bmof input_leds gigabyte_wmi pcspkr mc soundcore i2c_algo_bit tpm intel_hid rng_core sparse_keymap acpi_tad acpi_pad sg button mei_me mei nvidia(PO) bonding tls xt_recent br_netfilter overlay xt_comment xt_CHECKSUM nf_tables nfnetlink bridge 8021q garp stp mrp llc 
macvlan veth iptable_nat iptable_mangle iptable_filter ip6table_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6table_mangle ip6table_filter ip6_tables auth_rpcgss loop drm fuse efi_pstore agpgart configfs sunrpc ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 btrfs blake2b_generic 
efivarfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid0 multipath linear hid_logitech_hidpp hid_logitech_dj uas usb_storage hid_generic usbhid hid cdc_ncm cdc_ether usbnet r8152 mii raid1 md_mod sd_mod dm_mod crct10dif_pclmul 
crc32_pclmul crc32c_intel polyval_clmulni polyval_generic gf128mul ghash_clmulni_intel sha512_ssse3 sha512_generic sha256_ssse3 sha1_ssse3
[Thu Feb 29 09:12:53 2024]  i2c_designware_platform i2c_designware_core nvme nvme_core t10_pi ahci xhci_pci crc64_rocksoft_generic aesni_intel crypto_simd r8169 libahci cryptd i2c_i801 crc64_rocksoft xhci_hcd i2c_smbus realtek crc64 libata intel_lpss_pci usbcore intel_lpss scsi_mod idma64 
scsi_common virt_dma usb_common fan video pinctrl_alderlake pinctrl_intel wmi pwm_lpss
[Thu Feb 29 09:12:53 2024] CPU: 0 PID: 3290 Comm: blkdiscard Tainted: P           O       6.7.6-raw #1
[Thu Feb 29 09:12:53 2024] Hardware name: Gigabyte Technology Co., Ltd. Z790 GAMING X/Z790 GAMING X, BIOS F9b 11/10/2023
[Thu Feb 29 09:12:53 2024] RIP: 0010:__blkdev_issue_discard+0x13e/0x180
[Thu Feb 29 09:12:53 2024] Code: 48 39 d8 75 91 f7 da 89 d3 c1 eb 09 eb 8b 48 8b 04 24 4c 89 20 48 83 c4 08 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc <0f> 0b 48 c7 c6 00 26 e8 93 48 c7 c7 60 91 50 94 e8 3d 7a 5b 00 85
[Thu Feb 29 09:12:53 2024] RSP: 0018:ffffa7654119bd08 EFLAGS: 00010246
[Thu Feb 29 09:12:53 2024] RAX: ffff8d8f4c5be0b0 RBX: ffff8d8f4add3e80 RCX: ffff8d8f4add12c0
[Thu Feb 29 09:12:53 2024] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8d8f4add3e80
[Thu Feb 29 09:12:53 2024] RBP: 0000000000000cc0 R08: ffffa7654119bd48 R09: 0000000000000000
[Thu Feb 29 09:12:53 2024] R10: 000000000000081c R11: 0000000000000000 R12: 0000000000000000
[Thu Feb 29 09:12:53 2024] R13: 00000000773bc800 R14: 000000ee77900000 R15: ffff8d8f4add3e80
[Thu Feb 29 09:12:53 2024] FS:  00007fb69dc57740(0000) GS:ffff8d9ebf400000(0000) knlGS:0000000000000000
[Thu Feb 29 09:12:53 2024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Thu Feb 29 09:12:53 2024] CR2: 00007ffefb8c6170 CR3: 000000017d8da000 CR4: 0000000000f50ef0
[Thu Feb 29 09:12:53 2024] PKRU: 55555554
[Thu Feb 29 09:12:53 2024] Call Trace:
[Thu Feb 29 09:12:53 2024]  <TASK>
[Thu Feb 29 09:12:53 2024]  ? __blkdev_issue_discard+0x13e/0x180
[Thu Feb 29 09:12:53 2024]  ? __warn+0x7c/0x130
[Thu Feb 29 09:12:53 2024]  ? __blkdev_issue_discard+0x13e/0x180
[Thu Feb 29 09:12:53 2024]  ? report_bug+0x191/0x1c0
[Thu Feb 29 09:12:53 2024]  ? handle_bug+0x3a/0x70
[Thu Feb 29 09:12:53 2024]  ? exc_invalid_op+0x17/0x70
[Thu Feb 29 09:12:53 2024]  ? asm_exc_invalid_op+0x1a/0x20
[Thu Feb 29 09:12:53 2024]  ? __blkdev_issue_discard+0x13e/0x180
[Thu Feb 29 09:12:53 2024]  blkdev_issue_discard+0x50/0xb0
[Thu Feb 29 09:12:53 2024]  blkdev_common_ioctl+0x820/0x970
[Thu Feb 29 09:12:53 2024]  ? do_fault+0x27c/0x690
[Thu Feb 29 09:12:53 2024]  blkdev_ioctl+0xc7/0x260
[Thu Feb 29 09:12:53 2024]  __x64_sys_ioctl+0x8f/0xd0
[Thu Feb 29 09:12:53 2024]  do_syscall_64+0x61/0x120
[Thu Feb 29 09:12:53 2024]  ? __count_memcg_events+0x6e/0xc0
[Thu Feb 29 09:12:53 2024]  ? handle_mm_fault+0xb0/0x370
[Thu Feb 29 09:12:53 2024]  ? __ct_user_enter+0x8d/0x100
[Thu Feb 29 09:12:53 2024]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[Thu Feb 29 09:12:53 2024] RIP: 0033:0x7fb69dd57c5b
[Thu Feb 29 09:12:53 2024] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[Thu Feb 29 09:12:53 2024] RSP: 002b:00007ffefb889d70 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Thu Feb 29 09:12:53 2024] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb69dd57c5b
[Thu Feb 29 09:12:53 2024] RDX: 00007ffefb889e30 RSI: 0000000000001277 RDI: 0000000000000003
[Thu Feb 29 09:12:53 2024] RBP: 0000000000000000 R08: 0000000000000007 R09: 000055b80fbd32f0
[Thu Feb 29 09:12:53 2024] R10: 00007ffefb889da0 R11: 0000000000000246 R12: 000000ee77900000
[Thu Feb 29 09:12:53 2024] R13: 0000000000000003 R14: 000055b80fbd32f0 R15: 0000000000000000
[Thu Feb 29 09:12:53 2024]  </TASK>
[Thu Feb 29 09:12:53 2024] ---[ end trace 0000000000000000 ]---
[Thu Feb 29 09:12:53 2024] sdf1: Error: discard_granularity is 0.
```
