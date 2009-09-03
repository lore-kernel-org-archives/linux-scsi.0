From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V3.
Date: Thu, 3 Sep 2009 23:18:53 +0200
Message-ID: <200909032318.54298.eike-kernel@sf-tec.de>
References: <1252006675.18725.20.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1484166.GprT2Q3Gkn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:46997 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163AbZICVS4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 17:18:56 -0400
In-Reply-To: <1252006675.18725.20.camel@ank32.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akataria@vmware.com
Cc: James Bottomley <James.Bottomley@suse.de>, Matthew Wilcox <matthew@wil.cx>, Roland Dreier <rdreier@cisco.com>, Bart Van Assche <bvanassche@acm.org>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, pv-drivers@vmware.com

--nextPart1484166.GprT2Q3Gkn
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Alok Kataria wrote:
> VMware PVSCSI driver - v3.
>=20
> +static void pvscsi_write_cmd_desc(const struct pvscsi_adapter *adapter,
> +				  u32 cmd, const void *desc, size_t len)
> +{
> +	const u32 *ptr =3D desc;
> +	unsigned i;
> +
> +	len /=3D sizeof(*ptr);
> +	pvscsi_reg_write(adapter, PVSCSI_REG_OFFSET_COMMAND, cmd);
> +	for (i =3D 0; i < len; i++)

This would limit len to 16 GiB as "unsigned" (looks like "unsigned int" is=
=20
preferred in kernel) is only 32 bit long. Instead i should probably be size=
_t,=20
too.

> +static int __devinit pvscsi_allocate_rings(struct pvscsi_adapter *adapte=
r)
> +{

=2E..

> +	BUG_ON(adapter->ringStatePA & ~PAGE_MASK);
> +	BUG_ON(adapter->reqRingPA   & ~PAGE_MASK);
> +	BUG_ON(adapter->cmpRingPA   & ~PAGE_MASK);

Ok, that took me a moment. How about BUG_ON(!IS_ALIGNED(foo, PAGE_SIZE))?

> +static const char *pvscsi_info(struct Scsi_Host *host)
> +{
> +	struct pvscsi_adapter *adapter =3D shost_priv(host);
> +	static char buf[512];
> +
> +	sprintf(buf, "VMware PVSCSI storage adapter rev %d, req/cmp/msg rings: "
> +		"%u/%u/%u pages, cmd_per_lun=3D%u", adapter->rev,
> +		adapter->req_pages, adapter->cmp_pages, adapter->msg_pages,
> +		pvscsi_template.cmd_per_lun);

The buffer looks rather huge here. I'm too lazy to calculate an exact size =
but=20
256 should still be more than enough, no?

> +static void pvscsi_shutdown_intr(struct pvscsi_adapter *adapter)
> +{
> +	if (adapter->irq) {
> +		free_irq(adapter->irq, adapter);
> +		adapter->irq =3D 0;
> +	}
> +	if (adapter->use_msi) {
> +		pci_disable_msi(adapter->dev);
> +		adapter->use_msi =3D 0;
> +	}
> +
> +	if (adapter->use_msix) {
> +		pci_disable_msix(adapter->dev);
> +		adapter->use_msix =3D 0;
> +	}
> +}

If MSI and MSI-X are exclusive the last one could be "else if".

Greetings,

Eike

--nextPart1484166.GprT2Q3Gkn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkqgMr4ACgkQXKSJPmm5/E5PzgCdFVuR1DnawvWV73/WZQAq/2jN
LR4An1gdsf98gv1ykenCsHqF8EV5dulH
=teET
-----END PGP SIGNATURE-----

--nextPart1484166.GprT2Q3Gkn--
