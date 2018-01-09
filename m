From: Yves-Alexis Perez <corsac@debian.org>
Subject: Re: [PATCHv2] libsas: Check for completed commands before calling
 lldd_abort_task()
Date: Tue, 09 Jan 2018 15:13:47 +0100
Message-ID: <1515507227.3305.91.camel@debian.org>
References: <1515413086-34256-1-git-send-email-hare@suse.de>
         <1515431496.3305.62.camel@debian.org>
         <b1935687-4d39-3aca-1ee5-01dc513a8735@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-FV7YQWe2y4vpb2wk+mSh"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pic75-3-78-194-244-226.fbxo.proxad.net ([78.194.244.226]:41388
        "EHLO mail.corsac.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1757594AbeAION4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jan 2018 09:13:56 -0500
Received: from scapa.corsac.net (unknown [IPv6:2a01:e34:ec2f:4e21::1])
        by mail.corsac.net (Postfix) with ESMTPS id 6F07A94
        for <linux-scsi@vger.kernel.org>; Tue,  9 Jan 2018 15:13:53 +0100 (CET)
In-Reply-To: <b1935687-4d39-3aca-1ee5-01dc513a8735@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org


--=-FV7YQWe2y4vpb2wk+mSh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-09 at 10:30 +0100, Hannes Reinecke wrote:
> Can you try to boot the stock 4.15 kernel (without any patches) with
> scsi_mod.scsi_logging_level=3D9411
> on the kernel commandline and send me tha output?
> I really would like to see which command fails.
> THX.

Here it is:

[  204.960508] sd 0:0:1:0: [sdb] tag#0 Send: scmd 0x000000006f2d047e
[  204.960510] sd 0:0:0:0: [sda] tag#1 Send: scmd 0x000000009840a325
[  204.960511] sd 0:0:1:0: [sdb] tag#0 CDB: ATA command pass through(16) 85=
 06 20 00 05 00 fe 00 00 00 00 00 00 40 ef 00
[  204.960512] sd 0:0:0:0: [sda] tag#1 CDB: ATA command pass through(16) 85=
 06 20 00 05 00 fe 00 00 00 00 00 00 40 ef 00
[  204.960583] sd 0:0:1:0: [sdb] tag#0 Done: TIMEOUT_ERROR Result: hostbyte=
=3DDID_OK driverbyte=3DDRIVER_OK
[  204.960586] sd 0:0:1:0: [sdb] tag#0 CDB: ATA command pass through(16) 85=
 06 20 00 05 00 fe 00 00 00 00 00 00 40 ef 00
[  204.983681] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[  204.983690] IP: isci_task_abort_task+0x30/0x4b0 [isci]
[  204.983691] PGD 0 P4D 0=20
[  204.983693] Oops: 0000 [#1] SMP PTI
[  204.983695] Modules linked in: snd_hwdep(+) snd_hda_core snd_pcm_oss snd=
_mixer_oss iTCO_wdt snd_pcm iTCO_vendor_support mei_me snd_timer snd lpc_ic=
h shpchp sg mei joydev evdev mfd_core soundcore dcdbas serio_raw intel_rapl=
_perf(+) iptable_filter(+) nls_cp437 nls_utf8 vfat fat coretemp dell_smm_hw=
mon parport_pc ppdev lp parport ip_tables x_tables autofs4 ext4 crc16 mbcac=
he jbd2 fscrypto algif_skcipher af_alg dm_crypt dm_mod tpm_rng rng_core uhc=
i_hcd pcrypt sr_mod cdrom sd_mod hid_lenovo usbhid hid nouveau crct10dif_pc=
lmul crc32_pclmul video isci crc32c_intel mxm_wmi ahci xhci_pci libsas ehci=
_pci ghash_clmulni_intel wmi libahci scsi_transport_sas xhci_hcd ehci_hcd i=
2c_algo_bit pcbc drm_kms_helper libata e1000e ttm aesni_intel aes_x86_64 cr=
ypto_simd cryptd psmouse ptp glue_helper i2c_i801 usbcore scsi_mod
[  204.983738]  pps_core drm button
[  204.983741] CPU: 11 PID: 262 Comm: kworker/u64:5 Not tainted 4.15.0-rc7 =
#2
[  204.983742] Hardware name: Dell Inc. Precision T5600/0Y56T3, BIOS A09 05=
/03/2013
[  204.983750] Workqueue: scsi_tmf_0 scmd_eh_abort_handler [scsi_mod]
[  204.983755] RIP: 0010:isci_task_abort_task+0x30/0x4b0 [isci]
[  204.983756] RSP: 0018:ffffb0504152fcd8 EFLAGS: 00010246
[  204.983757] RAX: 0000000000000000 RBX: ffff8a8f842d79a8 RCX: 00000000fff=
fffff
[  204.983758] RDX: ffff8a8f80f7f800 RSI: 0000000000000000 RDI: 00000000000=
00000
[  204.983759] RBP: ffff8a8f842d7948 R08: ffff8a8f870e1f60 R09: 00000000000=
00000
[  204.983759] R10: 0000000000000000 R11: 0000000000000f27 R12: 00000000000=
00008
[  204.983760] R13: 0000000000000000 R14: ffff8a8f80b51540 R15: 00000000000=
00000
[  204.983761] FS:  0000000000000000(0000) GS:ffff8a8f870c0000(0000) knlGS:=
0000000000000000
[  204.983774] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  204.983775] CR2: 0000000000000000 CR3: 0000000200a0a005 CR4: 00000000000=
606e0
[  204.983775] Call Trace:
[  204.983781]  ? sched_clock+0x5/0x10
[  204.983784]  ? sched_clock_cpu+0xc/0xb0
[  204.983787]  ? sched_clock+0x5/0x10
[  204.983788]  ? sched_clock+0x5/0x10
[  204.983790]  ? sched_clock_cpu+0xc/0xb0
[  204.983791]  ? pick_next_task_fair+0x4de/0x5f0
[  204.983794]  ? __switch_to+0xa2/0x450
[  204.983795]  ? put_prev_entity+0x1e/0xe0
[  204.983799]  sas_eh_abort_handler+0x2f/0x50 [libsas]
[  204.983805]  scmd_eh_abort_handler+0x56/0x210 [scsi_mod]
[  204.983809]  process_one_work+0x188/0x380
[  204.983811]  worker_thread+0x2e/0x390
[  204.983812]  ? process_one_work+0x380/0x380
[  204.983814]  kthread+0x111/0x130
[  204.983815]  ? kthread_create_worker_on_cpu+0x70/0x70
[  204.983819]  ret_from_fork+0x1f/0x30
[  204.983820] Code: 41 57 41 56 49 89 ff 41 55 41 54 4d 8d 67 08 55 53 48 =
81 ec 68 01 00 00 65 48 8b 04 25 28 00 00 00 48 89 84 24 60 01 00 00 31 c0 =
<48> 8b 07 c7 44 24 08 00 00 00 00 c7 44 24 10 00 00 00 00 48 8b=20
[  204.983843] RIP: isci_task_abort_task+0x30/0x4b0 [isci] RSP: ffffb050415=
2fcd8
[  204.983843] CR2: 0000000000000000
[  204.983845] ---[ end trace c55806a9bed49dc4 ]---

I have the full log from boot (2.2M) but I'm unsure how much private data
appears in it so I'd rather not send it to a mailing list. If you need it I=
'll
send it privately.

Regards,
--=20
Yves-Alexis
--=-FV7YQWe2y4vpb2wk+mSh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEE8vi34Qgfo83x35gF3rYcyPpXRFsFAlpUzhsACgkQ3rYcyPpX
RFskmggAugsyA+LAeK/+D9BOrGEJIqnjAywbdRmuWmvUlen/GhP0xfidbzdFKwmh
67zm4nKJHUaf3rCoZJG8gQgmfvp+2lD/8lgBBhZd4oL2hqEWFeE+jbEPAnH3L+Kz
tIcofUE6wTgZ21Qv19/Fd27F7NV+XtlxjHC2k2xLtO9Y3FXS0J4n0xW5m+tqtbRX
HevfFObtkmy1KZOU44G505FWUmf9gg1NBqPV0qMokgMFYe7VWkyfC7fqlqhvv8xq
Im0D+4G1hLfV0NNwwaCfpgTCNxCC/u0CdBEKixMTFV9pBgKJm/ZElE+TwmrVt4K5
JJmOKFN8OrU4h8Qcov8VgT1PUUDRkg==
=RJlB
-----END PGP SIGNATURE-----

--=-FV7YQWe2y4vpb2wk+mSh--
