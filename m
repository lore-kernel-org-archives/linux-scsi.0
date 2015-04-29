From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z:
 dev error handler -> general protection fault, RIP:
 mvs_task_prep_ata+0x80/0x3a0
Date: Wed, 29 Apr 2015 08:41:42 -0700
Message-ID: <1430322102.2189.14.camel@HansenPartnership.com>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
	 <bug-81861-11613-zXvwHJt3aC@https.bugzilla.kernel.org/>
	 <1430317204.2189.2.camel@HansenPartnership.com>
	 <CAC2CY-2YAy8GfjCHO+PrFWAuBnhfnMvK33KJ3YCVRZXJMEHykQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36957 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966341AbbD2Plo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2015 11:41:44 -0400
In-Reply-To: <CAC2CY-2YAy8GfjCHO+PrFWAuBnhfnMvK33KJ3YCVRZXJMEHykQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nathan Rennie-Waldock <nathan.renniewaldock@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2015-04-29 at 16:27 +0100, Nathan Rennie-Waldock wrote:
> There's nothing before that, that log starts when I loaded mvsas. I'm using
> an Areca ARC-1320ix-16 which has an onboard expander.

Please keep linux-scsi in the cc ... there are other mvsas people who
may have better ideas.

The log should have something like this preceding what you sent:

[    9.642953] scsi host1: mvsas
[    9.646971] sas: phy-1:2 added to port-1:0, phy_mask:0x4
( 200000000000000)
[    9.647078] sas: phy-1:3 added to port-1:1, phy_mask:0x8
(500605b000001110)
[    9.647084] drivers/scsi/mvsas/mv_sas.c 1114:set wide port phy map 8
[    9.686904] sas: DOING DISCOVERY on port 0, pid:100
[    9.686912] sas: DONE DISCOVERY on port 0, pid:100, result:0
[    9.686928] sas: DOING DISCOVERY on port 1, pid:100
[    9.687529] sas: ex 500605b000001110 phy00:S:9 attached:
5005043011ab0000 (host)
[    9.687663] sas: ex 500605b000001110 phy01:S:0 attached:
0000000000000000 (no device)
[    9.687833] sas: ex 500605b000001110 phy02:S:0 attached:
0000000000000000 (no device)
[    9.687966] sas: ex 500605b000001110 phy03:S:0 attached:
0000000000000000 (no device)
[    9.688101] sas: ex 500605b000001110 phy04:T:0 attached:
0000000000000000 (no device)
[    9.688234] sas: ex 500605b000001110 phy05:T:9 attached:
500000e010decc32 (ssp)
[    9.688431] sas: ex 500605b000001110 phy06:T:0 attached:
0000000000000000 (no device)
[    9.688563] sas: ex 500605b000001110 phy07:T:0 attached:
0000000000000000 (no device)
[    9.688697] sas: ex 500605b000001110 phy08:T:0 attached:
0000000000000000 (no device)
[    9.688831] sas: ex 500605b000001110 phy09:T:0 attached:
0000000000000000 (no device)
[    9.689005] sas: ex 500605b000001110 phy10:T:0 attached:
0000000000000000 (no device)
[    9.689141] sas: ex 500605b000001110 phy11:T:0 attached:
0000000000000000 (no device)
[    9.689296] sas: DONE DISCOVERY on port 1, pid:100, result:0

That's the bit I need.

James

> On 29 Apr 2015 15:20, "James Bottomley" <
> James.Bottomley@hansenpartnership.com> wrote:
> 
> > On Wed, 2015-04-29 at 13:40 +0000, bugzilla-daemon@bugzilla.kernel.org
> > wrote:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=81861
> > >
> > > --- Comment #24 from Nathan R <nathan.renniewaldock+kernelbugs@gmail.com>
> > ---
> > > Created attachment 175261
> > >   --> https://bugzilla.kernel.org/attachment.cgi?id=175261&action=edit
> > > dmesg output after loading module
> > >
> > > Just tested the driver from linux-stable since that patch has been
> > merged.
> > > After loading, I get a bunch of "failed to IDENTIFY" errors, then an
> > oops and
> > > insmod never returned (so far been 15mins and nothing new in dmesg).
> >
> > OK, need the bit before this log showing the expander configuration.
> >
> > > [51444.152442] ata9.00: qc timeout (cmd 0xec)
> > > [51444.152471] ata7.00: qc timeout (cmd 0xec)
> > > [51444.152483] ata7.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51444.152509] ata8.00: qc timeout (cmd 0xec)
> > > [51444.152513] ata8.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51444.160408] ata11.00: qc timeout (cmd 0xec)
> > > [51444.160411] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51444.187351] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51444.187375] ata10.00: qc timeout (cmd 0xec)
> > > [51444.187382] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51444.187409] ata12.00: qc timeout (cmd 0xec)
> > > [51444.187412] ata12.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51444.187423] ata14.00: qc timeout (cmd 0xec)
> > > [51444.187428] ata14.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51444.187437] ata13.00: qc timeout (cmd 0xec)
> > > [51444.187442] ata13.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51446.366477] ata13.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> > err_mask=0x80)
> > > [51456.340357] ata7.00: qc timeout (cmd 0xec)
> > > [51456.344479] ata7.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51456.344484] ata8.00: qc timeout (cmd 0xec)
> > > [51456.344490] ata8.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51456.350631] ata11.00: qc timeout (cmd 0xec)
> > > [51456.350636] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51456.354770] ata10.00: qc timeout (cmd 0xec)
> > > [51456.354775] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51456.360889] ata12.00: qc timeout (cmd 0xec)
> > > [51456.360894] ata12.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51456.360917] ata14.00: qc timeout (cmd 0xec)
> > > [51456.360922] ata14.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51456.384242] ata9.00: qc timeout (cmd 0xec)
> > > [51456.384246] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51458.510399] ata8.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> > err_mask=0x80)
> > > [51458.522389] ata14.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> > err_mask=0x80)
> > > [51461.507228] ata13.00: qc timeout (cmd 0xec)
> > > [51461.511440] ata13.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51488.484548] ata10.00: qc timeout (cmd 0xec)
> > > [51488.488756] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51488.496535] ata12.00: qc timeout (cmd 0xec)
> > > [51488.500752] ata12.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51488.500753] ata11.00: qc timeout (cmd 0xec)
> > > [51488.500763] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51488.516435] ata9.00: qc timeout (cmd 0xec)
> > > [51488.516440] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51488.540445] ata7.00: qc timeout (cmd 0xec)
> > > [51488.544565] ata7.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > > [51554.171645] BUG: unable to handle kernel paging request at
> > 000000030000007e
> > > [51554.178745] IP: [<ffffffffc0d782b6>] mvs_lu_reset+0x76/0xc0 [mvsas]
> >
> > Definitely a different problem ... this one is in error recovery
> >
> > James
> >
> > > [51554.185100] PGD 1f41b4067 PUD 0
> > > [51554.188405] Oops: 0000 [#1] SMP
> > > [51554.191706] Modules linked in: mvsas(OE) libsas scsi_transport_sas
> > ses enclosure xt_multiport xt_TCPMSS xt_DSCP ipt_MASQUERADE
> > nf_nat_masquerade_ipv4 xt_mark ipt_REJECT nf_reject_ipv4 xt_nat xt_tcpudp
> > xt_state iptable_filter iptable_mangle iptable_nat nf_conntrack_ipv4
> > nf_defrag_ipv4 nf_nat_ipv4 ip_tables x_tables autofs4 nfsd nfs_acl
> > auth_rpcgss nfs lockd sunrpc binfmt_misc grace xfs libcrc32c
> > snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel amdkfd
> > snd_hda_controller snd_hda_codec amd_iommu_v2 radeon snd_hwdep snd_pcm_oss
> > snd_mixer_oss bridge snd_pcm stp llc snd_seq_midi snd_rawmidi
> > snd_seq_midi_event snd_seq snd_timer snd_seq_device ttm snd drm_kms_helper
> > crct10dif_pclmul crc32_pclmul joydev sha1_ssse3 ghash_clmulni_intel
> > sha256_ssse3 sha512_ssse3 psmouse drm soundcore aesni_intel kvm_amd
> > edac_core ablk_helper cryptd i2c_algo_bit edac_mce_amd 8250_fintek lrw
> > ppdev i2c_piix4 shpchp serio_raw asus_atk0110 gf128mul mac_hid glue_helper
> > fam15h_power k10temp aes_x86_64 wmi kvm softdog tcp_vegas nf_nat_ftp nf_nat
> > nf_conntrack_ftp nf_conntrack cifs fscache lp parport pata_acpi
> > hid_logitech ff_memless usbhid r8169 mii hid raid10 raid456
> > async_raid6_recov async_pq raid6_pq async_xor e1000e xor ptp async_memcpy
> > pps_core async_tx ahci libahci raid1 pata_atiixp raid0 multipath linear
> > [last unloaded: arcsas]
> > > [51554.311462] CPU: 1 PID: 1696 Comm: scsi_eh_7 Tainted: G           OE
> > 3.19.0-15-generic #15-Ubuntu
> > > [51554.320566] Hardware name: System manufacturer System Product
> > Name/M5A78L-M LX, BIOS 1603    11/05/2013
> > > [51554.330063] task: ffff8801a9a89d70 ti: ffff880121338000 task.ti:
> > ffff880121338000
> > > [51554.337622] RIP: 0010:[<ffffffffc0d782b6>]  [<ffffffffc0d782b6>]
> > mvs_lu_reset+0x76/0xc0 [mvsas]
> > > [51554.346431] RSP: 0018:ffff88012133bc58  EFLAGS: 00010246
> > > [51554.351807] RAX: 0000000000000246 RBX: 0000000100000000 RCX:
> > ffff8801776020b0
> > > [51554.359039] RDX: 00000000000000a6 RSI: 0000000000000246 RDI:
> > 0000000000000246
> > > [51554.366260] RBP: ffff88012133bca8 R08: 0000000000000004 R09:
> > 0000000000000000
> > > [51554.373479] R10: 2e8ba2e8ba2e8ba3 R11: ffff88009ba88800 R12:
> > 0000000300000002
> > > [51554.380710] R13: ffff88009ba8bc00 R14: ffff880177600000 R15:
> > ffff880177600008
> > > [51554.387946] FS:  00007f0ae89b7700(0000) GS:ffff88021ec40000(0000)
> > knlGS:0000000000000000
> > > [51554.396133] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > [51554.401956] CR2: 000000030000007e CR3: 00000001772c0000 CR4:
> > 00000000000407e0
> > > [51554.409180] Stack:
> > > [51554.411230]  ffff88012133bc98 0000000000000246 0000000100000000
> > 0000000800000002
> > > [51554.418826]  0000000100000000 ffff88009ba8bc00 ffff880206047000
> > ffff880206047000
> > > [51554.426409]  ffff880206047000 ffff8802144c6c00 ffff88012133bcd8
> > ffffffffc0d5e3df
> > > [51554.433995] Call Trace:
> > > [51554.436478]  [<ffffffffc0d5e3df>]
> > sas_eh_device_reset_handler+0xaf/0xd0 [libsas]
> > > [51554.443972]  [<ffffffffc0d5d69e>]
> > sas_eh_handle_sas_errors+0x1ce/0x850 [libsas]
> > > [51554.451363]  [<ffffffff81559060>] ? scsi_eh_get_sense+0x360/0x360
> > > [51554.457530]  [<ffffffffc0d5e8c2>] sas_scsi_recover_host+0x112/0x490
> > [libsas]
> > > [51554.464657]  [<ffffffff8151143c>] ? __pm_runtime_resume+0x5c/0x80
> > > [51554.470818]  [<ffffffff81559060>] ? scsi_eh_get_sense+0x360/0x360
> > > [51554.476989]  [<ffffffff81559060>] ? scsi_eh_get_sense+0x360/0x360
> > > [51554.483171]  [<ffffffff81559172>] scsi_error_handler+0x112/0xa00
> > > [51554.489251]  [<ffffffff81559060>] ? scsi_eh_get_sense+0x360/0x360
> > > [51554.495407]  [<ffffffff81094759>] kthread+0xc9/0xe0
> > > [51554.500343]  [<ffffffff81094690>] ? kthread_create_on_node+0x1c0/0x1c0
> > > [51554.506945]  [<ffffffff817c9298>] ret_from_fork+0x58/0x90
> > > [51554.512420]  [<ffffffff81094690>] ? kthread_create_on_node+0x1c0/0x1c0
> > > [51554.519028] Code: 2a 4d 8d 7e 08 4c 89 ff e8 48 09 a5 c0 4c 89 ee 4c
> > 89 f7 48 89 45 b8 e8 39 fe ff ff 48 8b 45 b8 4c 89 ff 48 89 c6 e8 0a 08 a5
> > c0 <45> 8b 44 24 7c 41 89 d9 48 c7 c1 40 d2 d7 c0 ba 83 05 00 00 48
> > > [51554.539551] RIP  [<ffffffffc0d782b6>] mvs_lu_reset+0x76/0xc0 [mvsas]
> > > [51554.546003]  RSP <ffff88012133bc58>
> > > [51554.549554] CR2: 000000030000007e
> > > [51554.573509] ---[ end trace 19ccb1d36e80fcf3 ]---
> >
> >
> >
> >



