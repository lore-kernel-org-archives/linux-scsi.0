From: Olaf Hering <olh@suse.de>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently on 2.6.8.1
Date: Sun, 24 Oct 2004 16:42:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041024144236.GA21793@suse.de>
References: <Pine.LNX.4.44.0409050434540.8779-100000@sasami.anime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:6031 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261505AbUJXOpd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 10:45:33 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0409050434540.8779-100000@sasami.anime.net>
List-Id: linux-scsi@vger.kernel.org
To: Dan Hollis <goemon@anime.net>, linux-scsi@vger.kernel.org
Cc: bcollins@debian.org, linux1394-devel@lists.sourceforge.net

 On Sun, Sep 05, Dan Hollis wrote:

>   Vendor: PIONEER   Model: DVD-RW  DVR-104   Rev: 1.31
>   Type:   CD-ROM                             ANSI SCSI revision: 02

> cat /proc/scsi/scsi, it shows up
>=20
> now turn drive off
>=20
> ieee1394: Node changed: 0-01:1023 -> 0-00:1023
> ieee1394: Node suspended: ID:BUS[0-00:1023]  GUID[00309995505516f8]
>=20
> and now...
> cat /proc/scsi/scsi
>=20
> entire firewire system is permanently out to lunch. the cat hangs and=
=20
> can't be kill -9'd, no hotplug ever works again, the only solution is=
 a=20
> complete reboot.

This is the backtrace:

knodemgrd_0   D 00000000     0   296      1           307   293 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c017736c] schedule+0x2b8/0x5e0
 [c0177914] wait_for_completion+0x7c/0xec
 [c5d2fb94] scsi_wait_req+0x64/0xac [scsi_mod]
 [c54f7598] sr_do_ioctl+0x70/0x240 [sr_mod]
 [c54f6a00] sr_packet+0x5c/0x9c [sr_mod]
 [c5d11a34] cdrom_get_disc_info+0x60/0xc4 [cdrom]
 [c5d121e4] cdrom_mrw_exit+0x1c/0x104 [cdrom]
 [c5d10b6c] unregister_cdrom+0xd0/0x104 [cdrom]
 [c54f61a8] sr_kref_release+0x54/0x80 [sr_mod]
 [c00ad96c] kref_put+0x60/0x70
 [c54f6924] sr_remove+0x50/0xd0 [sr_mod]
 [c00eb100] device_release_driver+0x1b8/0x1bc
 [c00eb2f0] bus_remove_device+0xc0/0x12c
 [c00e9620] device_del+0xa4/0x114


The trouble starts in register_cdrom(), it sets the ->exit() function i=
f
the CD can do CDC_MRW_W.
On unregister, it tries to send a packet to the device which is already
gone.

How about this patch?


diff -purN linux-2.6.9.orig/drivers/scsi/sr.c linux-2.6.9-olh/drivers/s=
csi/sr.c
--- linux-2.6.9.orig/drivers/scsi/sr.c	2004-10-22 19:02:43.545400072 +0=
200
+++ linux-2.6.9-olh/drivers/scsi/sr.c	2004-10-24 16:32:10.765682704 +02=
00
@@ -916,6 +918,7 @@ static void sr_kref_release(struct kref=20
 	struct gendisk *disk =3D cd->disk;
=20
 	spin_lock(&sr_index_lock);
+	cd->use =3D 0;
 	clear_bit(disk->first_minor, sr_index_bits);
 	spin_unlock(&sr_index_lock);
=20
diff -purN linux-2.6.9.orig/drivers/scsi/sr_ioctl.c linux-2.6.9-olh/dri=
vers/scsi/sr_ioctl.c
--- linux-2.6.9.orig/drivers/scsi/sr_ioctl.c	2004-10-22 19:02:43.547399=
768 +0200
+++ linux-2.6.9-olh/drivers/scsi/sr_ioctl.c	2004-10-24 16:31:05.9215405=
12 +0200
@@ -86,6 +86,11 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
         struct request *req;
 	int result, err =3D 0, retries =3D 0;
=20
+	if(!cd->use) {
+		err =3D -ENODEV;
+		goto out;
+	}
+
 	SDev =3D cd->device;
 	SRpnt =3D scsi_allocate_request(SDev, GFP_KERNEL);
         if (!SRpnt) {
--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
