From: Kurt Garloff <garloff@suse.de>
Subject: Re: lots and lots of disks again
Date: Mon, 16 Feb 2004 13:40:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040216124047.GG4011@tpkurt.garloff.de>
References: <20040210102603.0c835212.akpm@osdl.org> <20040211145614.GA4010@tpkurt.garloff.de> <20040211132848.49eece0d.akpm@osdl.org> <20040211220918.GJ4010@tpkurt.garloff.de> <20040211142933.484ca978.akpm@osdl.org> <20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk> <20040212150035.GN1780@tpkurt.garloff.de> <20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk> <20040212161800.GU1780@tpkurt.garloff.de> <1076604183.2576.89.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0z5c7mBtSy1wdr4F"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:19853 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264419AbUBPMkv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Feb 2004 07:40:51 -0500
Content-Disposition: inline
In-Reply-To: <1076604183.2576.89.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org


--0z5c7mBtSy1wdr4F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Thu, Feb 12, 2004 at 11:43:03AM -0500, James Bottomley wrote:
> Well, I've had my ear bent about gendisk aliasing not being feasible, so
> to use the new major scheme, we'd have to have something like a boot
> time switch in the kernel and only register either the old majors or the
> new major.

This could be done. So we register one new major, with the 6bit
partitions, allowing for 1<<14 disks with 1<<6 partitions each with
one major.

It looks like in 2.7, we'll have /dev/disk anyway, it would fit in there
perfectly. Until then, the world has hopefully stepped over to udev, so
we don't need to maintain the compatibility with the old device node
numbering any more.

If we wait with this untili /dev/disk is there, we can save to register a=
=20
major for SCSI now and avoid the boot parameter.=20

 From a distributor's perspective, I currently see demand to have many
(>1000) SCSI disks supported (*), but no serious demand for > 16 partitions,
so we would not have trouble to wait with this until 2.7/2.8.

(*) This includes needs that arise because of multipathing, most people=20
 don't have 1000 really different LUNs exported by their SAN RAID
 system.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--0z5c7mBtSy1wdr4F
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAMLpOxmLh6hyYd04RAjNzAKCz+tKA2zp9Uffanv8/iqtzFL6jqwCeJrYu
cgGkt9t/JMKZ+fT+XYoGl8E=
=/tXJ
-----END PGP SIGNATURE-----

--0z5c7mBtSy1wdr4F--
