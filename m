From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] sysfs host name support
Date: Mon, 9 Feb 2004 17:16:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040209161644.GT3944@tpkurt.garloff.de>
References: <20040209155046.GP3944@tpkurt.garloff.de> <20040209160526.A23604@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HACzHn9G0kmbdSJa"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:27577 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S265211AbUBIQUP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 11:20:15 -0500
Content-Disposition: inline
In-Reply-To: <20040209160526.A23604@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>


--HACzHn9G0kmbdSJa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Mon, Feb 09, 2004 at 04:05:27PM +0000, Christoph Hellwig wrote:
> On Mon, Feb 09, 2004 at 04:50:46PM +0100, Kurt Garloff wrote:
> > Please apply the attached patch.
> > It exports the 3 names to sysfs under /sys/classes/scsi_hosts/hostX/
> > name, proc_name, module_name.
>=20
> name is optional (you can use ->info instead), so please don't export it.

Hmm, I think it's still mandatory, except that it will be overridden
by info(). It's still useful info in any case, I'd still like to export it.

> As for proc_name vs module_name - I think we should just export one of th=
em,
> I'm pretty open which one.  proc_name probably makes more sense.

I can do with just one name.=20

Normally, the module name would look most useful, as it can be used by
installers etc. who need to figure what modules are needed.
I would prefer if proc_name would be identical to module name, and
then export the proc_name, which would even work for statically compiled
in drivers.

> > +shost_rd_attr2(module_name, hostt->module->name, "%s\n");
>=20
> How does this work for builtin modules?  Last time I checked hostt->module
> was NULL for those.

Nice null-ptr deref Oops. Looks like we need to handcode a function=20
for this one. Maybe with fallback to proc_name ...

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--HACzHn9G0kmbdSJa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAJ7JrxmLh6hyYd04RAvPgAJ98BkZ384pC4iGrruiaJHmRBt4AmQCfYGwq
/Mng5QAQsnevdOshE0jJsfE=
=f8t+
-----END PGP SIGNATURE-----

--HACzHn9G0kmbdSJa--
