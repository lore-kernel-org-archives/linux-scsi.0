From: Ben Hutchings <ben@decadent.org.uk>
Subject: Bug#634023: linux-source-2.6.32: Kernel panic when inserting usb stick
Date: Fri, 22 Jul 2011 02:21:14 +0200
Message-ID: <1311294074.28569.129.camel@localhost>
References: <20110715195209.4718.84365.reportbug@rosa.luebb24>
	 <1310806363.3397.6.camel@localhost>  <1310811731.4342.0@zora>
Reply-To: Ben Hutchings <ben@decadent.org.uk>, 634023@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-2qliagBdIJ3V4Tg77MNx"
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.634023.B634023.13112940894061@bugs.debian.org>
In-Reply-To: <1310811731.4342.0@zora>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: James Bottomley <James.Bottomley@suse.de>
Cc: 634023@bugs.debian.org, Simon Brandmair <sbrandmair@gmx.net>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--=-2qliagBdIJ3V4Tg77MNx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This oops (and consequent panic) was reported as occurring when a USB
stick is inserted, and as being a regression between Debian's package
version 2.6.32-34squeeze1 (longterm 2.6.32.39) and 2.6.32-35 (longterm
2.6.32.41).

On Sat, 2011-07-16 at 12:22 +0200, Simon Brandmair wrote:
> Netconsole output:
>=20
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> IP: [<ffffffff81128b5b>] elv_queue_empty+0x1b/0x30
> PGD 12a8cc067 PUD 12ae62067 PMD 0
> Oops: 0000 [#1]
> sd 6:0:0:0: [sdb] 1994752 512-byte logical blocks: (1.02 GB/974 MiB)
> SMP
> last sysfs file: =20
> /sys/devices/pci0000:00/0000:00:13.5/usb1/1-10/1-10:1.0/host6/scsi_host/h=
ost6/uevent
> CPU 1
> Modules linked in: usb_storage uvcvideo videodev v4l1_compat
> sd 6:0:0:0: [sdb] Write Protect is off
> sd 6:0:0:0: [sdb] Mode Sense: 43 00 00 00
> sd 6:0:0:0: [sdb] Assuming drive cache: write through
> usb-storage: device scan complete
>   v4l2_compat_ioctl32 netconsole powernow_k8 fuse nfsd exportfs nfs lockd=
 =20
> auth_rpcgss sunrpc psmouse sha256_generic ansi_cprng krng eseqiv rng =20
> aes_x86_64 aes_generic cbc cryptomgr crypto_hash aead pcompress dm_crypt =
=20
> crypto_blkcipher crypto_algapi crypto dm_mod usbhid snd_hda_codec_realtek=
 =20
> snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dum=
my =20
> snd_seq_oss snd_seq_midi_event snd_seq sg
> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>   sdb: snd_timer snd_seq_device sr_mod firewire_ohci firewire_core snd cd=
rom =20
> r8169 bitrev soundcore crc_itu_t crc32 sdb1
>   ohci_hcd ehci_hcd rtc_cmos snd_page_alloc usbcore pata_atiixp evdev =
=20
> rtc_core mii ide_pci_generic rtc_lib k10temp hwmon button processor sd_mo=
d =20
> thermal thermal_sys [last unloaded: nvidia]
> Pid: 7, comm: ksoftirqd/1 Tainted: P           2.6.32-20110716 #1 MS-7388

This was built from a custom configuration; Simon can presumably provide
the configuration if required.

The proprietary module is presumably 'nvidia' and hopefully not
responsible for messing with block devices.

> RIP: 0010:[<ffffffff81128b5b>]  [<ffffffff81128b5b>] elv_queue_empty+0x1b=
/0x30
> RSP: 0018:ffff880028283e18  EFLAGS: 00010046
> RAX: 0000000000000000 RBX: ffff88012ccf71c0 RCX: ffff88012aafd6d0
> RDX: ffff88012a8e1900 RSI: 0000000000000246 RDI: ffff88012ccf71c0
> RBP: 0000000000000292 R08: ffff88012aafd6e0 R09: ffff88012f8c4c50
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88012ccf71c0
> R13: ffff880028283e68 R14: ffff88012fbbe900 R15: ffff88012fa33840
> FS:  00007f429e058700(0000) GS:ffff880028280000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000040 CR3: 000000012e83e000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process ksoftirqd/1 (pid: 7, threadinfo ffff88012f892000, task =20
> ffff88012f88f1d0)
> Stack:
>   ffff88012ccf71c0 ffffffff8112c22a ffff88012ccf71c0 ffffffff8112c438
> <0> ffff88012fa33840 ffff88012fa33800 ffff880028283e68 ffffffff811d5e6a
> <0> ffff88012fa33828 0000000000000246 ffff880028283e68 ffff880028283e68
> Call Trace:
>   <IRQ>
>   [<ffffffff8112c22a>] ? __blk_run_queue+0x1a/0x150
>   [<ffffffff8112c438>] ? blk_run_queue+0x28/0x50
>   [<ffffffff811d5e6a>] ? scsi_run_queue+0xda/0x360
>   [<ffffffff811d6e0b>] ? scsi_next_command+0x3b/0x60
>   [<ffffffff811d79cf>] ? scsi_io_completion+0x32f/0x510
>   [<ffffffff8113110d>] ? blk_done_softirq+0x6d/0x80
>   [<ffffffff8104238d>] ? __do_softirq+0x9d/0x130
>   [<ffffffff8100c27c>] ? call_softirq+0x1c/0x30
>   <EOI>
>   [<ffffffff8100e15d>] ? do_softirq+0x4d/0x80
>   [<ffffffff81041f8f>] ? ksoftirqd+0x6f/0xf0
>   [<ffffffff81041f20>] ? ksoftirqd+0x0/0xf0
>   [<ffffffff8105245e>] ? kthread+0x8e/0xa0
>   [<ffffffff8100c17a>] ? child_rip+0xa/0x20
>   [<ffffffff810523d0>] ? kthread+0x0/0xa0
>   [<ffffffff8100c170>] ? child_rip+0x0/0x20
> Code: eb 94 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 08 31 c0 4=
8 3b =20
> 3f 48 8b 57 18 74 09 48 83 c4 08 c3 0f 1f 40 00 48 8b 02 <48> 8b 50 40 b8=
 01 =20
> 00 00 00 48 85 d2 74 e6 48 83 c4 08 ff e2 90
> RIP  [<ffffffff81128b5b>] elv_queue_empty+0x1b/0x30
>   RSP <ffff880028283e18>
> CR2: 0000000000000040
> ---[ end trace dd18fad6b2c0435a ]---
[...]

I would guess this is related to one of:

commit 3b4b7c75885a0acde5ff2e3f66eebe98471c3675
Author: James Bottomley <James.Bottomley@suse.de>
Date:   Sun May 1 09:42:07 2011 -0500

    fix oops in scsi_run_queue()
   =20
    commit c055f5b2614b4f758ae6cc86733f31fa4c2c5844 upstream.

commit 0ccd644ce6a803b4f7ae5b3b4da614b8a51037cc
Author: James Bottomley <James.Bottomley@suse.de>
Date:   Fri Apr 22 10:39:59 2011 -0500

    put stricter guards on queue dead checks
   =20
    commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b upstream.

Ben.

--=20
Ben Hutchings
Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer

--=-2qliagBdIJ3V4Tg77MNx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATijCdee/yOyVhhEJAQr54hAAnQyM70ME+k3t1teNTZXiyjvPOpVwxblo
ckoPwRALNtWZH8Ism9giAbn8Dz3udKmobs9ByVysnpVrXz2Q17m6XecSFlq2UG65
7LJBG77D2BdfvUoLxWOisMqGjgSvG1Mh7XtRet8vtVVM7o/ns/z1qpYVnkTgUvlp
0ZQ/X19XGw7iJHM270wApWevu9e/luaF/E7KkVID7nsXKW8wmvPEuoDw4H37JhYa
H+Xm+em+rLaFvjYStT8DZlqmcNflnyD/MYDByzNYrgDHZXnRU5AC7fZnW0SzoyrO
8xcD0PgLtyqwrS0WCtKKc+CpKXC/wJzuXTmyaGxA6B0ff0wsRid3MscZ4DmC8/wH
7ZWtz000xSFDQXLUBrU1n/FGj9+dqYGhPJmVrvT6Z3H2DKQD03RqVT9Pru6w0pBY
FFnmLw87iOU/OVgtoGXw112FutUA8pF2BAX6l4me0G66Mfk9ve8eJthpIwWqcZ4j
osAGVQqron9biS8DNfSFbvSWLHBwmjiONUarWrf9+oBZFOI1r4Uv/B++TzybomBi
boEHIGT+/ifk7z0MrIthek+L64aybhKiVTXMQFEQIXZQh9aH9ZKw3gBPq5hDXCqa
bo26YRF8KFfF1Dh9ASU3AxcWurvcEbnJlT1bvFdBp9al8pWmAxCzhpVnOH9mtqvy
gdm+l569PYo=
=DUrY
-----END PGP SIGNATURE-----

--=-2qliagBdIJ3V4Tg77MNx--
