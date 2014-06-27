From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [usb-storage] Re: External USB3 disk fails with "Invalid field
 in cdb"
Date: Fri, 27 Jun 2014 15:23:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1406271521350.875-100000@iolanthe.rowland.org>
References: <20140627205153.6a8ac916@wiggum>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140627205153.6a8ac916@wiggum>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 27 Jun 2014, Michael B=C3=BCsch wrote:

> On Fri, 27 Jun 2014 14:42:01 -0400 (EDT)
> Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
>=20
> > Michael, can you post the "lsusb -v" output for this device?  I see=
 it=20
> > is made by JMicron; they are notorious for buggy USB-ATA bridges.
>=20
> Of course. Here you go:
>=20
> Bus 004 Device 009: ID 152d:0567 JMicron Technology Corp. / JMicron U=
SA Technology Corp.=20
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               3.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0=20
>   bDeviceProtocol         0=20
>   bMaxPacketSize0         9
>   idVendor           0x152d JMicron Technology Corp. / JMicron USA Te=
chnology Corp.
>   idProduct          0x0567=20
>   bcdDevice            1.14
>   iManufacturer           1 JMicron
>   iProduct                2 USB to ATA/ATAPI Bridge
>   iSerial                 3 xxx
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength          121
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          4 USB Mass Storage
>     bmAttributes         0xc0
>       Self Powered
>     MaxPower                2mA
=2E..

> MaxPower=3D2mA is a nice guess for a hard disk. ;)

That refers to the amount of power the device draws from the USB bus. =20
Since the disk drive is self-powered, it doesn't use much bus power.

Does the patch below do what you and James want?

Alan Stern



Index: usb-3.16/include/linux/usb_usual.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-3.16.orig/include/linux/usb_usual.h
+++ usb-3.16/include/linux/usb_usual.h
@@ -70,7 +70,9 @@
 	US_FLAG(NEEDS_CAP16,	0x00400000)			\
 		/* cannot handle READ_CAPACITY_10 */		\
 	US_FLAG(IGNORE_UAS,	0x00800000)			\
-		/* Device advertises UAS but it is broken */
+		/* Device advertises UAS but it is broken */	\
+	US_FLAG(BROKEN_FUA,	0x01000000)			\
+		/* Cannot handle FUA in WRITE CDBs */		\
=20
 #define US_FLAG(name, value)	US_FL_##name =3D value ,
 enum { US_DO_ALL_FLAGS };
Index: usb-3.16/include/scsi/scsi_device.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-3.16.orig/include/scsi/scsi_device.h
+++ usb-3.16/include/scsi/scsi_device.h
@@ -173,6 +173,7 @@ struct scsi_device {
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
+	unsigned broken_fua:1;		/* Don't set FUA bit */
=20
 	atomic_t disk_events_disable_depth; /* disable depth for disk events =
*/
=20
Index: usb-3.16/drivers/usb/storage/unusual_devs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-3.16.orig/drivers/usb/storage/unusual_devs.h
+++ usb-3.16/drivers/usb/storage/unusual_devs.h
@@ -1936,6 +1936,13 @@ UNUSUAL_DEV(  0x14cd, 0x6600, 0x0201, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
=20
+/* Reported by Michael B=C3=BCsch <m@bues.ch> */
+UNUSUAL_DEV(  0x152d, 0x0567, 0x0114, 0x0114,
+		"JMicron",
+		"USB to ATA/ATAPI Bridge",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_BROKEN_FUA ),
+
 /* Reported by Alexandre Oliva <oliva-RGTiaf7OHS4mmTcpzmvVSFAUjnlXr6A1@public.gmane.org>
  * JMicron responds to USN and several other SCSI ioctls with a
  * residue that causes subsequent I/O requests to fail.  */
Index: usb-3.16/drivers/usb/storage/scsiglue.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-3.16.orig/drivers/usb/storage/scsiglue.c
+++ usb-3.16/drivers/usb/storage/scsiglue.c
@@ -256,6 +256,10 @@ static int slave_configure(struct scsi_d
 		if (us->fflags & US_FL_WRITE_CACHE)
 			sdev->wce_default_on =3D 1;
=20
+		/* A few buggy USB-ATA bridges don't understand FUA */
+		if (us->fflags & US_FL_BROKEN_FUA)
+			sdev->broken_fua =3D 1;
+
 	} else {
=20
 		/* Non-disk-type devices don't need to blacklist any pages
Index: usb-3.16/drivers/scsi/sd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-3.16.orig/drivers/scsi/sd.c
+++ usb-3.16/drivers/scsi/sd.c
@@ -2441,7 +2441,10 @@ sd_read_cache_type(struct scsi_disk *sdk
 		}
=20
 		sdkp->DPOFUA =3D (data.device_specific & 0x10) !=3D 0;
-		if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw) {
+		if (sdp->broken_fua) {
+			sd_first_printk(KERN_NOTICE, sdkp, "Disabling FUA\n");
+			sdkp->DPOFUA =3D 0;
+		} else if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw) {
 			sd_first_printk(KERN_NOTICE, sdkp,
 				  "Uses READ/WRITE(6), disabling FUA\n");
 			sdkp->DPOFUA =3D 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
