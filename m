From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] scsi/sd: fix suspend with USB-connected Android phone (one line)
Date: Thu, 12 May 2011 22:03:13 +0200
Message-ID: <201105122203.13671.rjw@sisk.pl>
References: <BANLkTi=XNyR8GD43GGnMag+=JmhUd_5HtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=XNyR8GD43GGnMag+=JmhUd_5HtA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Charles Hannum <root@ihack.net>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi <linux-scsi@vger.kernel.org>, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Added some CCs.

On Thursday, May 12, 2011, Charles Hannum wrote:
> Short version: My laptop doesn't suspend when my Android phone is
> connected and has been =E2=80=9Cejected=E2=80=9D.
>=20
> Long version:
>=20
> Android phones connect as USB mass storage devices.  After the =E2=80=
=9CTurn
> on USB storage=E2=80=9D button has been clicked, there are a few diff=
erent
> ways to detach the =E2=80=9Cdisk=E2=80=9D:
>=20
> 1) pull the cable
> 2) click =E2=80=9CTurn off USB storage=E2=80=9D
> 3) =E2=80=9Ceject=E2=80=9D the device
>=20
> In cases 2 & 3, the USB device is still attached to the system, but
> will now return MEDIUM NOT PRESENT for many commands, including
> SYNCHRONIZE CACHE=E2=80=94basically it acts like any device with remo=
vable
> media.  However, the act of the =E2=80=9Cmedia=E2=80=9D being removed=
 does not
> invalidate sdkp->WCE; therefore sd_shutdown() and sd_suspend() still
> call sd_sync_cache(), which *fails* because it gets a MEDIUM NOT
> PRESENT sense code.  In the sd_suspend() case, this causes the entire
> suspend to fail, and the laptop rewakes immediately.
>=20
> There are a few different ways to fix this; e.g. one could
> specifically test media_not_present() if a sense code is returned in
> sd_sync_cache().  However, the following patch seems simpler, and
> avoids calling sd_sync_cache() at all in this case.  sdkp->WCE will b=
e
> reset when new medium is recognized and sd_read_cache_type() is
> called.  Note this code always gets called=E2=80=94it's in the same p=
ath as
> sd_read_capacity(), which has to be called for the device to be usabl=
e
> again; thus the patch is inherently safe.
>=20
> Kernel tested: 2.6.38 (Ubuntu Natty)

Patch appended for completness.

I need someone from USB/SCSI camp to see if this approach makes sense.

Thanks,
Rafael


--- linux-2.6.38/drivers/scsi/sd.c.orig	2011-05-11 18:08:44.969497976 -=
0400
+++ linux-2.6.38/drivers/scsi/sd.c	2011-05-11 15:26:15.439610760 -0400
@@ -996,6 +996,7 @@
 	if (sdkp->device->removable) {
 		sdkp->media_present =3D 0;
 		sdkp->capacity =3D 0;
+		sdkp->WCE =3D 0;
 	}
 }
=20
