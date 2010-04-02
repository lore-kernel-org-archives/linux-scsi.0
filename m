From: Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 2 Apr 2010 15:09:02 +0200
Message-ID: <t2t59ca64281004020609sa0f67f0dj5c127e3f0b2e4db2@mail.gmail.com>
References: <4BB37454.8070808@interlog.com> <Pine.LNX.4.44L0.1003311229460.1739-100000@iolanthe.rowland.org>
	<n2r59ca64281004010632h9dec0e98pdc0bc9a923b43206@mail.gmail.com>
	<s2zac3eb2511004010642ic2e8f973h2e038d3c90c6ca75@mail.gmail.com>
	<r2k59ca64281004010655z93fedfa8rdeb447d82a848d9f@mail.gmail.com>
	<k2zac3eb2511004010705he844fff8wfa8e18626b8f3e45@mail.gmail.com>
	<m2l59ca64281004020540z7e502130g22dfc035f1ceda6a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <m2l59ca64281004020540z7e502130g22dfc035f1ceda6a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, David Zeuthen <david-o55+BOBDEFg@public.gmane.org>, linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Actually, you hit the nail on the head Kay. I moved the hdparm rule
out of the way and voil=E0, the drive mounts. I then manually ran hdpar=
m
on the device:

sudo hdparm --verbose /dev/sdb

/dev/sdb:
outgoing cdb:  85 08 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
SG_IO: ATA_16 status=3D0x0, host_status=3D0x7, driver_status=3D0x0
SG_IO: bad response (not CHECK_CONDITION)
outgoing cdb:  85 08 2e 00 00 00 00 00 00 00 00 00 00 40 a1 00
SG_IO: ATA_16 status=3D0x0, host_status=3D0x7, driver_status=3D0x0
SG_IO: bad response (not CHECK_CONDITION)
 HDIO_DRIVE_CMD(identify) failed: Invalid exchange
 readonly      =3D  0 (off)
 readahead     =3D 256 (on)
 geometry      =3D 36365/64/32, sectors =3D 0, start =3D 0

Does the command sent by hdparm look familiar? Exactly, it is the
third ATA command (IDENTIFY DEVICE) we discovered earlier and caused
the drive to stall.

Does anyone know why the drive would not be able to cope with this
command? And also, why does it not choke on it in USB 2.0 mode but
only in USB 3.0?

-Jonas
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
