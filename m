From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] tmscsim: 64-bit cleanup
Date: Sat, 22 May 2004 20:10:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040522181035.GC4623@tpkurt.garloff.de>
References: <Pine.LNX.4.44.0405192135160.6790-200000@poirot.grange> <1085152512.2258.21.camel@mulgrave> <20040522080924.GP4623@tpkurt.garloff.de> <1085240593.2006.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iBipwI8N6cjWJAiJ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:8646 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261745AbUEVSLW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 May 2004 14:11:22 -0400
Content-Disposition: inline
In-Reply-To: <1085240593.2006.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>


--iBipwI8N6cjWJAiJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 22, 2004 at 10:43:12AM -0500, James Bottomley wrote:
> On Sat, 2004-05-22 at 03:09, Kurt Garloff wrote:
> > The AM53C974 hardware does not have hardware support for scatter-gather.
> > (Yes, this is sad, you get an IRQ after every segment ...)
>=20
> But then you should set sg_tablesize to one.  There's little point the
> elevator wasting time to coalesce if you can't process the request in a
> single go.  Doing that would also allow for a simpler driver design,
> because now you know you can complete individual requests since they
> only yield a single sg element.  You no longer have to track multiple
> card completions to the request completion.

It's still cheaper to send down one command for a large transfer, let
the card interrupt the CPU to get a new DMA address every segment.
(When we're lucky, we might even have segments with contiguous bus
 addresses -- this is certainly the case if there's a IOMMU in the
 system)=20

The per-command overhead in SCSI is significant, so I would hate to
restrict the driver to process 4k commands.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG / Novell, Nuernberg, DE               Director SUSE Labs

--iBipwI8N6cjWJAiJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAr5eaxmLh6hyYd04RAuTiAJ450vJ0seyDS/ejoAoNuFfuSnwPdgCfeaZr
dlV4RPEFOVGsnq1P5TmF6SE=
=UntV
-----END PGP SIGNATURE-----

--iBipwI8N6cjWJAiJ--
