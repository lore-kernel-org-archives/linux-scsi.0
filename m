From: Herbert Schmid <sairia@phaidon.philo.at>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently
 on 2.6.8.1
Date: Sun, 31 Oct 2004 22:05:45 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0410312118170.23720@phaidon.philo.at>
References: <Pine.LNX.4.44.0409050434540.8779-100000@sasami.anime.net>
 <20041024144236.GA21793@suse.de>
Reply-To: Herbert Schmid <sairia@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailbox-lmtp.univie.ac.at ([131.130.1.27]:41903 "EHLO
	imap.univie.ac.at") by vger.kernel.org with ESMTP id S261456AbUJaVGW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Oct 2004 16:06:22 -0500
In-Reply-To: <20041024144236.GA21793@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: Dan Hollis <goemon@anime.net>, linux-scsi@vger.kernel.org, bcollins@debian.org, linux1394-devel@lists.sourceforge.net

Hi,

I've tested the scsi bugs with 2.6.9, 2.6.9 with ieee1392 svn-trunk 123=
3
from today and 2.6.10-rc1 with and without the patch from Olaf.

Results:
Removing a unused, unmounted hard disk from 1394 was no problem at all.
Removing a unused, unmounted cdrom drive from 1394 FAILS, if
	scsi-cdrom is compiled in and
	Olaf's patch is not used.
=46AIL meens, that cat /proc/scsi/scsi can't even be killed -9.

Using only scsi generic adding and removing was detected correctly.

Using the patch, you can even remove the cdrom drive while a disk is=20
mounted. (ls does give nothing, there haven't been even . and ..). You =
can=20
unmount the disk later. With linux 2.6.10-rc1 scsi is unstable after an=
d=20
may lock later, especially if you use usb additionally.

Removing any firewire device (disk or cd) during use, always kills=20
scsi. From my (user) point of view, this seems to be a different proble=
m,=20
which doesn't make the patch of Olaf useless.

USB
Removing a usb cdrom device without the patch will kill the whole kerne=
l.
Using the patch, the behavior is like with 1394, i.e. cat /proc/scsi/sc=
si=20
works.=20

dd if=3D/dev/scdX
(only tested with the patch)
On 2.6.9 with the trunk from today: dd gets unkillable, but=20
/proc/scsi/scsi still works.=20
	(2.6.10 /proc/scsi/scsi or whole kernel fails.)
USB stops this with an I/O error.

Overview:
test          2.6.9   2.6.9fw1233   2.6.10rc1

add/remove without patch
hd              +          +               +
cd=20
no scsicd       +          +               +
with scsicd     -          -               -

add/remove with patch
with scsicd     +          +               +
remove mounted  +          +               unstable=20

remove while access
hd		-          -               -
with patch and scsi-cd
cd              -          only dd locked  -

usb
add/remove without patch
cd             (untested)  (untested)      -
add/remove with patch  =20
               (untested)  +               unstable
remove while access
	       (untested)  i/o error       (untested)=20


Summary (only my opinion as user):
Comparing 2.6.10rc1 to 2.6.9, scsi lost stability.
The patch is good at least for 2.6.9.
Hot unplugging during use seems not to be managed well by scsi or 1394.

Yours,
Herbert

P.S.: 2.4.27 simply never removes the scsi drive object from memory and
passes all test. When removing a mounted device, it keeps wrong data in=
=20
the cache. Which is ok for cd-roms.



On Sun, 24 Oct 2004, Olaf Hering wrote:

>  On Sun, Sep 05, Dan Hollis wrote:
>=20
> >   Vendor: PIONEER   Model: DVD-RW  DVR-104   Rev: 1.31
> >   Type:   CD-ROM                             ANSI SCSI revision: 02
>=20
> > cat /proc/scsi/scsi, it shows up
> >=20
> > now turn drive off
> >=20
> > ieee1394: Node changed: 0-01:1023 -> 0-00:1023
> > ieee1394: Node suspended: ID:BUS[0-00:1023]  GUID[00309995505516f8]
> >=20
> > and now...
> > cat /proc/scsi/scsi
> >=20
> > entire firewire system is permanently out to lunch. the cat hangs a=
nd=20
> > can't be kill -9'd, no hotplug ever works again, the only solution =
is a=20
> > complete reboot.
>=20
> This is the backtrace:
>=20
> knodemgrd_0   D 00000000     0   296      1           307   293 (L-TL=
B)
> Call trace:
>  [c000a228] __switch_to+0x48/0x70
>  [c017736c] schedule+0x2b8/0x5e0
>  [c0177914] wait_for_completion+0x7c/0xec
>  [c5d2fb94] scsi_wait_req+0x64/0xac [scsi_mod]
>  [c54f7598] sr_do_ioctl+0x70/0x240 [sr_mod]
>  [c54f6a00] sr_packet+0x5c/0x9c [sr_mod]
>  [c5d11a34] cdrom_get_disc_info+0x60/0xc4 [cdrom]
>  [c5d121e4] cdrom_mrw_exit+0x1c/0x104 [cdrom]
>  [c5d10b6c] unregister_cdrom+0xd0/0x104 [cdrom]
>  [c54f61a8] sr_kref_release+0x54/0x80 [sr_mod]
>  [c00ad96c] kref_put+0x60/0x70
>  [c54f6924] sr_remove+0x50/0xd0 [sr_mod]
>  [c00eb100] device_release_driver+0x1b8/0x1bc
>  [c00eb2f0] bus_remove_device+0xc0/0x12c
>  [c00e9620] device_del+0xa4/0x114
>=20
>=20
> The trouble starts in register_cdrom(), it sets the ->exit() function=
 if
> the CD can do CDC_MRW_W.
> On unregister, it tries to send a packet to the device which is alrea=
dy
> gone.
>=20
> How about this patch?
>=20
>=20
> diff -purN linux-2.6.9.orig/drivers/scsi/sr.c linux-2.6.9-olh/drivers=
/scsi/sr.c
> --- linux-2.6.9.orig/drivers/scsi/sr.c	2004-10-22 19:02:43.545400072 =
+0200
> +++ linux-2.6.9-olh/drivers/scsi/sr.c	2004-10-24 16:32:10.765682704 +=
0200
> @@ -916,6 +918,7 @@ static void sr_kref_release(struct kref=20
>  	struct gendisk *disk =3D cd->disk;
> =20
>  	spin_lock(&sr_index_lock);
> +	cd->use =3D 0;
>  	clear_bit(disk->first_minor, sr_index_bits);
>  	spin_unlock(&sr_index_lock);
> =20
> diff -purN linux-2.6.9.orig/drivers/scsi/sr_ioctl.c linux-2.6.9-olh/d=
rivers/scsi/sr_ioctl.c
> --- linux-2.6.9.orig/drivers/scsi/sr_ioctl.c	2004-10-22 19:02:43.5473=
99768 +0200
> +++ linux-2.6.9-olh/drivers/scsi/sr_ioctl.c	2004-10-24 16:31:05.92154=
0512 +0200
> @@ -86,6 +86,11 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
>          struct request *req;
>  	int result, err =3D 0, retries =3D 0;
> =20
> +	if(!cd->use) {
> +		err =3D -ENODEV;
> +		goto out;
> +	}
> +
>  	SDev =3D cd->device;
>  	SRpnt =3D scsi_allocate_request(SDev, GFP_KERNEL);
>          if (!SRpnt) {
> --=20
> USB is for mice, FireWire is for men!
>=20
> sUse lINUX ag, n=DCRNBERG
>=20
>=20
> -------------------------------------------------------
> This SF.net email is sponsored by: IT Product Guide on ITManagersJour=
nal
> Use IT products in your business? Tell us what you think of them. Giv=
e us
> Your Opinions, Get Free ThinkGeek Gift Certificates! Click to find ou=
t more
> http://productguide.itmanagersjournal.com/guidepromo.tmpl
> _______________________________________________
> mailing list linux1394-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux1394-devel
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
