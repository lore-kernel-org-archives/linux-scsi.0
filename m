From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/6] RFC: beiscsi : handles core routines
Date: Thu, 13 Aug 2009 12:09:38 +0200
Message-ID: <200908131209.43643.eike-kernel@sf-tec.de>
References: <20090813070833.GA28512@serverengines.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4899701.0j0oh43MpH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:37156 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbZHMKJw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Aug 2009 06:09:52 -0400
In-Reply-To: <20090813070833.GA28512@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org

--nextPart4899701.0j0oh43MpH
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Jayamohan Kallickal wrote:
> This file handles initiallization/teardown, allocation/free as well
> as IO/Management flows.
>
> Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>

> +struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
> +{
[...]
> +	phba =3D iscsi_host_priv(shost);
> +	memset(phba, 0x0, sizeof(*phba));
> +	phba->shost =3D shost;
> +	pci_dev_get(pcidev);
> +
> +	phba->shost =3D shost;
> +	phba->pcidev =3D pcidev;

You initialized shost 3 lines before. Additionally you can simply say

phba->pcidev =3D pci_dev_get(pcidev);

> +int beiscsi_enable_pci(struct pci_dev *pcidev)
> +{
> +	if (pci_enable_device(pcidev)) {
> +		dev_err(&pcidev->dev, "beiscsi_enable_pci - enable device "
> +			"failed. Returning -ENODEV\n");
> +		return -ENODEV;
> +	}

You should forward the error code of pci_enable_device() here.

> +	if (pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64))) {
> +		if (pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(32))) {
> +			dev_err(&pcidev->dev, "Could not set PCI DMA Mask\n");
> +			return -ENODEV;
> +		}
> +	}
> +	return 0;
> +}

This function is only called from one place. You should move it before that=
 =20
caller, remove it from the header file and mark it static.

> +static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
> +{
> +	struct be_mem_descriptor *mem_descr;
> +	dma_addr_t bus_add;
> +	unsigned int num_size, i, j;
> +	phba->phwi_ctrlr =3D kmalloc(phba->params.hwi_ws_sz, GFP_KERNEL);
> +	if (!phba->phwi_ctrlr)
> +		return -ENOMEM;
> +	phba->init_mem =3D
> +	    kzalloc(sizeof(struct be_mem_descriptor) * SE_MEM_MAX, GFP_KERNEL);

kcalloc()

There is also a typo (found at least 5 places): Initiallize has one 'l' too=
=20
much.

Greetings,

Eike

--nextPart4899701.0j0oh43MpH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkqD5mcACgkQXKSJPmm5/E6k3gCfcKwosgldtdh1fqse5xmwJNVK
AtEAoJSdLM0dHQ36Fx7eI09ZhFHnZMLX
=KnOW
-----END PGP SIGNATURE-----

--nextPart4899701.0j0oh43MpH--
