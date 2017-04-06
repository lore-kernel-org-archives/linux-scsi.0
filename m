From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: 4.11.0-rc5-00011-g08e4e0d oops in mpt3sas driver
Date: Thu, 6 Apr 2017 09:47:00 +0800
Message-ID: <ef9a8840-0d2c-900e-3ee6-fe0ddd78c5b3@fnarfbargle.com>
References: <3ae35eb5-568c-07c1-d73c-301893ced68d@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns3.fnarfbargle.com ([43.245.164.105]:58244 "EHLO
        ns3.fnarfbargle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756315AbdDFBrG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 21:47:06 -0400
In-Reply-To: <3ae35eb5-568c-07c1-d73c-301893ced68d@fnarfbargle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open list <linux-kernel@vger.kernel.org>

On 06/04/17 08:30, Brad Campbell wrote:
> G'day All,
>
> This is a vaguely current git head kernel compiled yesterday.
>
> Oopsed and rebooted itself, and then oopsed and rebooted again. There
> was no sign of a raid rebuild in the kernel logs, and it's a staging
> machine so there is nothing running after a reboot that goes near these
> disks. They should have been completely idle the second time around.
>
> This box suffered from bad rcu stalls on 4.10.x stable kernels, so I
> upgraded to git head. It's all new hardware (the CPU, Chipset and
> board), so I expected some issues with the board, but the LSI cards have
> been around for a while now.

Further investigation indicates it might be a deeper problem. This is 
the first oops captured and it has nothing to do with the mpt3 driver.

[49580.533852] BUG: unable to handle kernel paging request at 
ffffffff817cddfe
[49580.533875] IP: queued_spin_lock_slowpath+0xe7/0x170
[49580.533879] PGD 180a067
[49580.533879] PUD 180b063
[49580.533882] PMD 80000000016001e1
[49580.533885]
[49580.533890] Oops: 0003 [#1] SMP
[49580.533894] Modules linked in: it87(O) deflate zlib_deflate ctr 
des_generic cbc cmac sha1_generic md5 hmac af_key xfrm_algo nfsd 
auth_rpcgss oid_registry nfs_acl nfs lockd grace sunrpc bonding 
sha256_generic dm_crypt aesni_intel aes_x86_64 crypto_simd cryptd 
glue_helper hwmon_vid netconsole configfs vhost_net vhost kvm_amd kvm 
irqbypass usbhid usb_storage nouveau video drm_kms_helper cfbfillrect 
syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea ttm 
drm mxm_wmi xhci_pci i2c_piix4 xhci_hcd usbcore usb_common wmi 
acpi_cpufreq mpt3sas igb i2c_algo_bit raid_class scsi_transport_sas ahci 
libahci
[49580.533929] CPU: 6 PID: 114 Comm: kswapd0 Tainted: G           O 
4.11.0-rc5-00011-g08e4e0d-dirty #39
[49580.533933] Hardware name: System manufacturer System Product 
Name/PRIME X370-PRO, BIOS 0515 03/30/2017
[49580.534045] task: ffff8807f9ad0000 task.stack: ffffc90000430000
[49580.534049] RIP: 0010:queued_spin_lock_slowpath+0xe7/0x170
[49580.534052] RSP: 0018:ffffc90000433a50 EFLAGS: 00010082
[49580.534056] RAX: 00000000000034e1 RBX: 0000000000000292 RCX: 
00000000001c0000
[49580.534059] RDX: ffffffff817cddfe RSI: ffff88081ed99900 RDI: 
ffff8806ddb860e0
[49580.534063] RBP: ffff8806ddb860e0 R08: 0000000000000101 R09: 
dead000000000200
[49580.534119] R10: ffffea001c000700 R11: ffff880006b457b9 R12: 
ffff8806ddb860c8
[49580.534122] R13: 0000000000000001 R14: ffffc90000433b40 R15: 
ffff8806ddb860c8
[49580.534179] FS:  0000000000000000(0000) GS:ffff88081ed80000(0000) 
knlGS:0000000000000000
[49580.534183] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[49580.534186] CR2: ffffffff817cddfe CR3: 0000000001809000 CR4: 
00000000003406e0
[49580.534190] Call Trace:
[49580.534247]  ? _raw_spin_lock_irqsave+0x1f/0x30
[49580.534253]  ? __remove_mapping+0x65/0x1b0
[49580.534258]  ? page_mkclean_one+0x100/0x100
[49580.534313]  ? page_get_anon_vma+0xa0/0xa0
[49580.534317]  ? shrink_page_list+0x6aa/0xda0
[49580.534321]  ? shrink_inactive_list+0x1f6/0x4b0
[49580.534325]  ? es_reclaim_extents+0x55/0xe0
[49580.534328]  ? inactive_list_is_low.isra.70+0x10e/0x1c0
[49580.534332]  ? shrink_node_memcg.isra.75+0x58c/0x6b0
[49580.534531]  ? shrink_node+0x4a/0x190
[49580.534705]  ? kswapd+0x2b7/0x5d0
[49580.535076]  ? kthread+0xf1/0x130
[49580.535477]  ? shrink_node+0x190/0x190
[49580.535869]  ? __kthread_init_worker+0xa0/0xa0
[49580.536257]  ? ret_from_fork+0x23/0x30
[49580.536666] Code: 47 02 c1 e0 10 0f 84 93 00 00 00 48 89 c2 c1 e8 12 
48 c1 ea 0c ff c8 83 e2 30 48 98 48 81 c2 00 99 01 00 48 03 14 c5 20 54 
77 81 <48> 89 32 8b 46 08 85 c0 75 09 f3 90 8b 46 08 85 c0 74 f7 4c 8b
[49580.537489] RIP: queued_spin_lock_slowpath+0xe7/0x170 RSP: 
ffffc90000433a50
[49580.537904] CR2: ffffffff817cddfe
[49580.540107] ---[ end trace f58d3bdd0830f2bf ]---
[49580.540642] Kernel panic - not syncing: Fatal exception
[49580.541212] Kernel Offset: disabled
[49580.541493] Rebooting in 10 seconds..
[49590.501026] ACPI MEMORY or I/O RESET_REG.


This box survives days of memtest, but I'm not above suspecting the 
underlying hardware if it points to that.
