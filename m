From: Matthieu CASTET <matthieu.castet-ITF29qwbsa/QT0dZR+AlfA@public.gmane.org>
Subject: Re: Buffer I/O error after s2ram with usb storage
Date: Fri, 29 Aug 2014 18:12:01 +0200
Message-ID: <20140829181201.277e699d@parrot.com>
References: <20140827104059.3a4bed94@parrot.com>
	<Pine.LNX.4.44L0.1408271051160.1460-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1408271051160.1460-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, TARUISI Hiroaki <taruishi.hiroak-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Le Wed, 27 Aug 2014 10:54:53 -0400,
Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> a =E9crit :

> On Wed, 27 Aug 2014, Matthieu CASTET wrote:
>=20
> > Ping
> >=20
> > I have got also a problem with a usb sdcard reader (without power c=
ut
> > during suspend)
>=20
> > > > The usb storage driver call scsi_report_bus_reset after device =
reset,
> > > > but because of commit dfcf7775 <4>, we don't ignore unit attent=
ion if
> > > > "sshdr.asc =3D=3D 0x28 && sshdr.ascq =3D=3D 0x00" ("Not-ready t=
o ready").
> > > >=20
> > > > If dfcf7775 is reverted there is no more Buffer I/O error.
> > > >=20
> > > > Is that possible to find a way to restore the behavior before d=
fcf7775
> > > > commit (no Buffer I/O error after device reset) after a suspend=
 to ram ?
>=20
> Since that commit was written to fix a problem with certain cdrom
> drives, maybe we would work around the issue by modifying the commit.=
 =20
> Have it go back to the original behavior if the device isn't a cdrom=20
> drive.
>=20
> That's not a complete fix (it won't help when a CD drive is attached=20
> via USB), but maybe it's better than nothing.
>=20
Ok,

note to handle all case we need also to filter unit_attention in
scsi_test_unit_ready. Otherwise DISK_EVENT_MEDIA_CHANGE event is set an=
d check_disk_change will invalidate vfs cache.


Matthieu

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2bc0362..e994061 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2030,8 +2030,12 @@ scsi_test_unit_ready(struct scsi_device *sdev, i=
nt timeout, int retries,
 		result =3D scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
 					  timeout, retries, NULL);
 		if (sdev->removable && scsi_sense_valid(sshdr) &&
-		    sshdr->sense_key =3D=3D UNIT_ATTENTION)
-			sdev->changed =3D 1;
+		    sshdr->sense_key =3D=3D UNIT_ATTENTION) {
+			if (sdev->expecting_cc_ua)
+				sdev->expecting_cc_ua =3D 0;
+			else
+				sdev->changed =3D 1;
+		}
 	} while (scsi_sense_valid(sshdr) &&
 		 sshdr->sense_key =3D=3D UNIT_ATTENTION && --retries);
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
