From: Stefan Voelkel <Stefan.Voelkel@millenux.com>
Subject: Re: LUN resizing
Date: Wed, 26 Nov 2003 10:45:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069839911.26091.443.camel@lt-sv>
References: <1069708054.26088.127.camel@lt-sv>
	 <1069774983.2061.28.camel@mulgrave>  <1069776713.1787.36.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-p2jHzG5KGNxhqLPHPOM5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pong.topalis.com ([195.243.109.5]:49415 "EHLO pong.topalis.com")
	by vger.kernel.org with ESMTP id S264110AbTKZJpj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2003 04:45:39 -0500
In-Reply-To: <1069776713.1787.36.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-p2jHzG5KGNxhqLPHPOM5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On Tue, 2003-11-25 at 17:11, James Bottomley wrote:
> On Tue, 2003-11-25 at 09:43, James Bottomley wrote:
> > You simply do
> >=20
> > echo 1 > /sys/bus/scsi/<device>/rescan
> >=20
> > It will re-read the capacity and partition table (as long as the device
> > is unmounted and none of the partitions open).
>
> OK, I actually tried this, you need two steps.  The one above will
> reread the capacity.  After that you send a BLKRRPART ioctl to the
> device to re-read the partition table. (but, obviously, something else
> will have to update the partition table to see the new device size)

Ok, that is a step in the right direction, as it will not disrupt
operations of other devices on the same bus.

But I want to be able to do it with a mounted partition, something like
"device size hotpluging". I don't know if that is the right term, but
think of the 2.7 memory hotplug plans.

      * in the SAN I add space to my LUN
      * then I hit my linux box on the head to get it to send a
        read_capacity and update the size of the device.
      * run a nifty tool that creates a new partition table and writes
        it to the device.
      * use newly gained space

so what we actually need is:

      * a way to force the scsi stack to send out a read_capacity and
        act on it (perhaps another /sys/ entry?), perhaps a hotplug
        event that creates a new partition table, eg add the new space
        as "unused" at the end of the device, write that table and
        ioctl() to reread it.
      * a way to fiddle around with live partitions,  a userspace tool
        with a way to tell the kernel supsend/reactivate io on that
        block device. it would have to take care of the filesystems
        residing on the device.

regards
	Stefan
--=20
--------------------------------------------------------------------
Stefan V=F6lkel                            stefan.voelkel@millenux.com
Millenux GmbH                              mobile: +49.170.79177.17
Lilienthalstra=DFe 2                          phone: +49.711.88770.300
70825 Stuttgart-Korntal                       fax: +49.711.88770.349
     -=3D linux without limits -=3D- http://linux.zSeries.org/ =3D-

--=-p2jHzG5KGNxhqLPHPOM5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/xHYmtWF28C4HGsQRAu4iAJ48LI1B/oAiNg47D4dfduzJyRi7aACfchvJ
B0G/GEPn24rWJ7se1hNSFZU=
=uquf
-----END PGP SIGNATURE-----

--=-p2jHzG5KGNxhqLPHPOM5--

