From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [Stable-review] [28/55] [SCSI] fix crash in scsi_dispatch_cmd()
Date: Thu, 25 Aug 2011 02:14:27 +0100
Message-ID: <1314234872.27179.69.camel@deadeye>
References: <20110806000251.682788533@clark.kroah.org>
	 <1312739411.2591.1026.camel@deadeye> <1312739484.2591.1027.camel@deadeye>
	 <20110808170424.GB27419@suse.de> <20110808181011.GE29924@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-XOcncfSwRMYLOReG4QZz"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53953 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791Ab1HYBOd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 21:14:33 -0400
In-Reply-To: <20110808181011.GE29924@decadent.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, 639122@bugs.debian.org


--=-XOcncfSwRMYLOReG4QZz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-08-08 at 19:10 +0100, Ben Hutchings wrote:
> On Mon, Aug 08, 2011 at 10:04:24AM -0700, Greg KH wrote:
> > On Sun, Aug 07, 2011 at 06:51:24PM +0100, Ben Hutchings wrote:
> > > On Sun, 2011-08-07 at 18:50 +0100, Ben Hutchings wrote:
> > > > On Fri, 2011-08-05 at 17:01 -0700, Greg KH wrote:
> > > > > 2.6.32-longterm review patch.  If anyone has any objections, plea=
se let us know.
> > > > >=20
> > > > > ------------------
> > > > >=20
> > > > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > > >=20
> > > > > commit bfe159a51203c15d23cb3158fffdc25ec4b4dda1 upstream.
> > > > >=20
> > > > > USB surprise removal of sr is triggering an oops in
> > > > > scsi_dispatch_command().  What seems to be happening is that USB =
is
> > > > > hanging on to a queue reference until the last close of the upper
> > > > > device, so the crash is caused by surprise remove of a mounted CD
> > > > > followed by attempted unmount.
> > > > [...]
> > > >=20
> > > > This has been reported in 2.6.39.y and 3.0, but not in 2.6.32.y.
> > >=20
> > > That is, AFAIK.
> >=20
> > Oops, good catch, I've dropped this from the .32 and .33 queue now, it'=
s
> > not needed there at all.
> =20
> Well, it is entirely possible that I am confusing multiple bugs (I
> actualy attempted to delete this message from my outgoing mail queue
> as I was becoming less confident about it).  I assume James can
> confirm one way or the other.

Well it appears there is *a* bug in handling device removal in 2.6.32.
Does this look like the same one you were fixing, or something
different?  The following log is from Debian's package version 2.6.32-35
which has longterm updates up to 2.6.32.41.

Ben.

[11229.532132] usb 1-3.1.2: new high speed USB device using ehci_hcd and ad=
dress 10
[11229.625008] usb 1-3.1.2: New USB device found, idVendor=3D1058, idProduc=
t=3D070a
[11229.625012] usb 1-3.1.2: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D3
[11229.625015] usb 1-3.1.2: Product: My Passport 070A
[11229.625017] usb 1-3.1.2: Manufacturer: Western Digital
[11229.625019] usb 1-3.1.2: SerialNumber: 57584630453739454E4A3034
[11229.625122] usb 1-3.1.2: configuration #1 chosen from 1 choice
...
[12729.505801] usb 1-3.1.2: USB disconnect, address 10
[12729.586599] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000087
[12729.586605] IP: [<ffffffff8117654d>] elv_may_queue+0x7/0x17
[12729.586613] PGD bce71067 PUD bcd94067 PMD 0=20
[12729.586616] Oops: 0000 [#1] SMP=20
[12729.586619] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1=
-3/1-3.1/1-3.1.1/1-3.1.1:1.0/host5/target5:0:0/5:0:0:0/block/sdb/uevent
[12729.586622] CPU 2=20
[12729.586624] Modules linked in: udf crc_itu_t ses enclosure drbd lru_cach=
e cn ppdev lp nls_utf8 sco cifs bridge stp bnep acpi_cpufreq rfcomm l2cap b=
luetooth rfkill cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_c=
onservative nouveau ttm drm_kms_helper drm i2c_algo_bit nfsd lockd nfs_acl =
auth_rpcgss sunrpc exportfs binfmt_misc fuse xt_tcpudp nf_conntrack_ipv4 nf=
_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables loop u=
sb_storage usbhid hid snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd=
_hwdep snd_pcm snd_seq snd_timer snd_seq_device snd uhci_hcd soundcore ehci=
_hcd nvidia(P) broadcom usbcore tg3 i2c_i801 libphy snd_page_alloc nls_base=
 i2c_core rng_core sg dcdbas sr_mod cdrom parport_pc parport button process=
or wmi evdev pcspkr psmouse serio_raw ext4 mbcache jbd2 crc16 raid10 raid45=
6 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx r=
aid1 raid0 multipath linear md_mod sd_mod crc_t10dif ata_generic ata_piix l=
ibata thermal thermal_sys scsi_mod
[12729.586684] Pid: 4655, comm: umount Tainted: P        W  2.6.32-5-amd64 =
#1 OptiPlex 380                =20
[12729.586686] RIP: 0010:[<ffffffff8117654d>]  [<ffffffff8117654d>] elv_may=
_queue+0x7/0x17
[12729.586690] RSP: 0018:ffff8800bcd4bbc0  EFLAGS: 00010096
[12729.586692] RAX: 0000000000000017 RBX: ffff8800cf9ac240 RCX: 00000000000=
00010
[12729.586694] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880127e=
31a70
[12729.586696] RBP: ffff880127e31a70 R08: 0000000000000000 R09: ffff8800cf9=
ac240
[12729.586697] R10: 0000000000000002 R11: ffff8800a511f0e0 R12: 00000000000=
00000
[12729.586699] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8800cf9=
ac240
[12729.586701] FS:  00007fc8fb0ec740(0000) GS:ffff880005480000(0000) knlGS:=
0000000000000000
[12729.586703] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[12729.586705] CR2: 0000000000000087 CR3: 00000000cfb2d000 CR4: 00000000000=
406e0
[12729.586707] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[12729.586709] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[12729.586711] Process umount (pid: 4655, threadinfo ffff8800bcd4a000, task=
 ffff880129a18710)
[12729.586713] Stack:
[12729.586714]  ffffffff8117f7f1 0000001000000002 0000000000000000 ffff8801=
2b669d01
[12729.586717] <0> 0000000000000000 ffff880129bad0e0 ffff8800cf9ac240 ffff8=
80127e31a70
[12729.586720] <0> 0000000000000000 0000000000000000 0000000000000000 ffff8=
800cf9ac240
[12729.586723] Call Trace:
[12729.586727]  [<ffffffff8117f7f1>] ? get_request+0x30/0x2ba
[12729.586730]  [<ffffffff8117fa9c>] ? get_request_wait+0x21/0x188
[12729.586737]  [<ffffffffa0007274>] ? scsi_execute+0x3b/0x12f [scsi_mod]
[12729.586744]  [<ffffffffa00073a8>] ? scsi_execute_req+0x40/0xb9 [scsi_mod=
]
[12729.586750]  [<ffffffffa00073ef>] ? scsi_execute_req+0x87/0xb9 [scsi_mod=
]
[12729.586756]  [<ffffffffa0001d20>] ? ioctl_internal_command+0x64/0x16a [s=
csi_mod]
[12729.586760]  [<ffffffff810bc0e0>] ? pagevec_lookup+0x17/0x1e
[12729.586766]  [<ffffffffa0001e80>] ? scsi_set_medium_removal+0x5a/0x98 [s=
csi_mod]
[12729.586771]  [<ffffffffa0226eae>] ? cdrom_release+0x18f/0x1fe [cdrom]
[12729.586776]  [<ffffffff810754ba>] ? smp_call_function_many+0x1ce/0x1ec
[12729.586779]  [<ffffffff8110d561>] ? invalidate_bh_lru+0x0/0x42
[12729.586784]  [<ffffffffa02333d2>] ? sr_block_release+0x11/0x1d [sr_mod]
[12729.586787]  [<ffffffff811126a2>] ? __blkdev_put+0x94/0x14c
[12729.586791]  [<ffffffff810f128d>] ? deactivate_super+0x60/0x77
[12729.586794]  [<ffffffff81103c08>] ? sys_umount+0x2dc/0x30b
[12729.586798]  [<ffffffff812fe9f6>] ? do_page_fault+0x2e0/0x2fc
[12729.586801]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[12729.586803] Code: 00 00 00 00 00 00 00 31 c0 c3 48 8b 47 18 48 8b 00 48 =
8b 40 68 48 85 c0 74 09 48 89 f7 49 89 c3 41 ff e3 c3 48 8b 47 18 48 8b 00 =
<48> 8b 40 70 48 85 c0 75 01 c3 49 89 c3 41 ff e3 48 8d be 88 00=20
[12729.586826] RIP  [<ffffffff8117654d>] elv_may_queue+0x7/0x17
[12729.586829]  RSP <ffff8800bcd4bbc0>
[12729.586831] CR2: 0000000000000087
[12729.586833] ---[ end trace a7919e7f17c0a727 ]---



--=-XOcncfSwRMYLOReG4QZz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATlWh8+e/yOyVhhEJAQoykxAA1fSAaiF258mcmzZK1P38c85NpZ9qbPnm
kTjg+BtlmfMfnMf/OT0wGLtjuhHS1UoCwPEnC4360dQSdY9my9bm8YfCsCxhyi3r
WtRcLuCDRfv3EvM9bIEshkGoHNg3fLUGh3+DqYeZkHdu2UJihjWY45U4yMasCNGS
szCIOpExCzNr0pzGr4ZdB7fZWuu0PbgIA1fIZs3KjxyGoWihKbpdeHeqBdl5yKd2
X6TptPO3t25qaP/fV7zqx9bqn/7B6MwpkEYNtKiwIs6npR7S6g2UwY+SSrtynLns
AyJ9LBlPQV/PUckI+wtdM7IxjImpHg+SPz4EPwFj+FMhfKr9mJAdwxQTpaG4mifF
PFfenCpoH3bn0cRyNeMyrGWIDzbII0XumqW9eumYU23pZHunHayO1hrcB0jIfLx/
P30FRBgx8dWM4wzMGkgLJjw3KcKiwluPHMRXYQ+7puBEirhwD9ql5p3XXnDdwg6u
+wYQKpNffEpaunoiapo/dexShPuTLHXIzyM43wZ8qKplFPeqfOmPMfqkMZXp698E
JkYiDOVgL5U9Hp6EWiqCKB3riDqZhSNLhzJJV4yeptHQLvQlfaK9fw4Gr/hO/gd4
zhK+JX+SvzPn9Y7S7VLeIgh939dXODqZFfu9/0/b4/bp0DwkVY3n/7feBvr6HIaA
gHv5/WKt6hM=
=Xcxe
-----END PGP SIGNATURE-----

--=-XOcncfSwRMYLOReG4QZz--
