From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: aic7xxx strange code
Date: Thu, 1 Jan 2004 23:34:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040101223452.GA16369@devserv.devel.redhat.com>
References: <1072885576.10877.6.camel@laptop.fenrus.com> <960352704.1072895786@aslan.btc.adaptec.com> <20040101100809.GA1053@devserv.devel.redhat.com> <478922704.1072973783@aslan.scsiguy.com> <20040101161731.GB18742@devserv.devel.redhat.com> <482322704.1072974098@aslan.scsiguy.com> <20040101162823.GC18742@devserv.devel.redhat.com> <m3vfnvi9my.fsf@averell.firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:23952 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261270AbUAAWfE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jan 2004 17:35:04 -0500
Content-Disposition: inline
In-Reply-To: <m3vfnvi9my.fsf@averell.firstfloor.org>
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: linux-scsi@vger.kernel.org, gibbs@scsiguy.com


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 01, 2004 at 11:31:17PM +0100, Andi Kleen wrote:
> Arjan van de Ven <arjanv@redhat.com> writes:
> >
> > This is the first time I've seen this bug (thanks again for reporting i=
t)
> > and it's clearly an API violation of the ONE API in linux which is very=
 well
> > documented so no other platform will have copied this bad bug... Adapte=
ct
>=20
> It may be well documented, but ports do not follow the documentation
> very well in that area. In particular i386 handles the consistent dma mask
> completely different than all the 64bit ports. Small overview:
>=20
> Architecture                  pci_alloc_consistent uses
> i386                          normal dma mask
				.... but clipped to 32 bit

> most 64bit archs/old x86-64   hardcoded 0xffffffff
> newer IA64/some x86-64        consistent dma mask (2)=20
> newest x86-64                 normal dma mask & consistent dma mask (1) (=
2)
> old redhat IA64               hardcoded 0xffffffffffffffff (?)

not just old RH; At least one old SuSE too :0 (in fact I found a previous
report claiming this only affected SuSE but it seems we're in the same boat
now)

>=20
> (1) to be bug-to-bug compatible with i386, some drivers rely on that.
> (2) consistent dma mask is normally equivalent to hardcoded 0xffffffff
> because that is the default value
>                                    =20
> It's quite a mess unfortunately. Due to (2) the 64bit architectures
> are consistent, except for that old IA64. But i386 doing something
> different is quite a problem.

but i386 will *never* return > 32 bit at least.

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/9KCMxULwo51rQBIRAq0+AJ4gxt+wKxAmHQw0oNXi0adxgBgjpwCfcyt6
gZRBJDSSaO104WHLUGujKgA=
=t9E4
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
