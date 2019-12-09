Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B59AC43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 01:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B091206DB
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 01:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfLIBtQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Dec 2019 20:49:16 -0500
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:10133 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726801AbfLIBtP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Dec 2019 20:49:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AzAABO3/JbAAm6qXwNVRwBAQEEAQEHB?=
 =?us-ascii?q?AEBgVIGAQELAYFVBYEPgSmDeIJekx6SRCCEd4F6KIRRAoQPNQgNAQMBAQIBAQI?=
 =?us-ascii?q?QATREhUkCAQMjFUEQCxoCHwcCAlcGDQgBAYJSSwGoVnCBL4NBgX+EXIELjFE/g?=
 =?us-ascii?q?TgMgl+IAoJXAokchXNDkB0HAoIaBIRciicekH0smTIDgggzGi6DMQmCHhcSiEy?=
 =?us-ascii?q?FUV+OXAEB?=
Received: from 124-169-186-9.dyn.iinet.net.au (HELO [192.168.1.104]) ([124.169.186.9])
  by ipmail03.adl2.internode.on.net with ESMTP; 09 Dec 2019 12:19:11 +1030
Subject: Re: refcount_t: underflow; use-after-free with CIFS umount after
 scsi-misc commit ef2cc88e2a205b8a11a19e78db63a70d3728cdf5
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cifs@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <30808b0b-367a-266a-7ef4-de69c08e1319@internode.on.net>
From:   Arthur Marsh <arthur.marsh@internode.on.net>
Message-ID: <09396dca-3643-9a4b-070a-e7db2a07235e@internode.on.net>
Date:   Mon, 9 Dec 2019 12:19:03 +1030
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <30808b0b-367a-266a-7ef4-de69c08e1319@internode.on.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Arthur Marsh wrote on 12/5/19 2:14 PM:
> Hi, I came across a problem when un-mounting CIFS mounts that bisected 
> back to the commit "[ef2cc88e2a205b8a11a19e78db63a70d3728cdf5] Merge tag 
> 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi".


This still happens with 5.5.0-rc1:

[  301.679819] ------------[ cut here ]------------
[  301.680095] refcount_t: underflow; use-after-free.
[  301.680192] WARNING: CPU: 1 PID: 3569 at lib/refcount.c:28 
refcount_warn_saturate+0xb4/0xf3
[  301.680298] Modules linked in: md4 sha512_generic cmac hmac cifs 
libdes dns_resolver fscache libarc4 nfc rfkill cpufreq_conservative 
cpufreq_userspace cpufreq_powersave binfmt_misc nls_utf8 nls_cp437 vfat 
fat lm75 it87 hwmon_vid tun cuse fuse ib_iser rdma_cm iw_cm ib_cm 
ib_core configfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi 
parport_pc ppdev lp parport radeon ttm snd_hda_codec_realtek 
snd_hda_codec_generic snd_hda_codec_hdmi ledtrig_audio snd_hda_intel 
snd_intel_dspcfg drm_kms_helper snd_hda_codec drm i2c_algo_bit 
snd_hda_core fb_sys_fops iTCO_wdt iTCO_vendor_support intel_powerclamp 
syscopyarea sysfillrect snd_hwdep sysimgblt snd_pcm evdev snd_timer 
pcspkr snd serio_raw rng_core soundcore button acpi_cpufreq ext4 crc16 
mbcache jbd2 sr_mod cdrom sg sd_mod ata_generic psmouse ata_piix tg3 
pata_it821x firewire_ohci uhci_hcd i2c_i801 lpc_ich firewire_core 
mfd_core crc_itu_t libata ehci_pci scsi_mod ehci_hcd usbcore usb_common 
ptp pps_core libphy
[  301.681361] CPU: 1 PID: 3569 Comm: umount Not tainted 5.5.0-rc1 #1692
[  301.681444] Hardware name:  /8I945P Pro, BIOS F10 04/06/2006
[  301.681521] EIP: refcount_warn_saturate+0xb4/0xf3
[  301.681586] Code: 24 f8 58 8b c1 e8 ab 91 d0 ff 0f 0b c9 c3 80 3d c3 
be 9d c1 00 75 91 c6 05 c3 be 9d c1 01 c7 04 24 4c 59 8b c1 e8 8b 91 d0 
ff <0f> 0b c9 c3 80 3d c1 be 9d c1 00 0f 85 6d ff ff ff c6 05 c1 be 9d
[  301.681807] EAX: 00000026 EBX: ed5ae6d8 ECX: 00000007 EDX: f62950cc
[  301.681889] ESI: ed5ae6e4 EDI: ed5d7000 EBP: ed503e2c ESP: ed503e28
[  301.681971] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010292
[  301.682057] CR0: 80050033 CR2: 0058f00c CR3: 2a20a000 CR4: 000006d0
[  301.682139] Call Trace:
[  301.682240]  close_shroot+0x97/0xda [cifs]
[  301.682351]  SMB2_tdis+0x7c/0x176 [cifs]
[  301.682456]  ? _get_xid+0x58/0x91 [cifs]
[  301.682563]  cifs_put_tcon.part.0+0x99/0x202 [cifs]
[  301.682637]  ? ida_free+0x99/0x10a
[  301.682727]  ? cifs_umount+0x3d/0x9d [cifs]
[  301.682829]  cifs_put_tlink+0x3a/0x50 [cifs]
[  301.682929]  cifs_umount+0x44/0x9d [cifs]
[  301.683023]  cifs_kill_sb+0x16/0x19 [cifs]
[  301.683084]  deactivate_locked_super+0x28/0x5c
[  301.683147]  deactivate_super+0x30/0x33
[  301.683204]  cleanup_mnt+0x8a/0x103
[  301.683256]  __cleanup_mnt+0xb/0xd
[  301.683308]  task_work_run+0x6c/0x8b
[  301.683364]  exit_to_usermode_loop+0xbe/0xc0
[  301.683427]  do_fast_syscall_32+0x291/0x364
[  301.683493]  entry_SYSENTER_32+0xaa/0x102
[  301.683549] EIP: 0xb7fa9af1
[  301.683592] Code: 00 89 d3 5b 5e 5f 5d c3 b8 00 09 3d 00 eb c4 8b 04 
24 c3 8b 14 24 c3 8b 1c 24 c3 8b 34 24 c3 90 90 51 52 55 89 e5 0f 34 cd 
80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90 8d 76
[  301.683811] EAX: 00000000 EBX: 0058ccf0 ECX: 00000000 EDX: b7f12000
[  301.683892] ESI: bfe75280 EDI: b7f12000 EBP: bfe74168 ESP: bfe740fc
[  301.683973] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000286
[  301.687861] irq event stamp: 8202
[  301.691737] hardirqs last  enabled at (8201): [<c10c741c>] 
console_unlock+0x45a/0x598
[  301.695687] hardirqs last disabled at (8202): [<c100171f>] 
trace_hardirqs_off_thunk+0xc/0x1d
[  301.699620] softirqs last  enabled at (8132): [<c14f9770>] 
peernet2id+0x3c/0x56
[  301.703583] softirqs last disabled at (8130): [<c14f9756>] 
peernet2id+0x22/0x56
[  301.707502] ---[ end trace fbe0ba2a50b93358 ]---
