From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [RESEND][PATCH][SCSI] mpt2sas: Fix for issue - Unable to boot from the SAS drive connected to HBA
Date: Tue, 21 Aug 2012 19:48:35 +0200
Message-ID: <1554075.4PqkcQvS1x@eto>
References: <20120821162315.GA5135@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1746846.1rdkakQSz9"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:59255 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164Ab2HURsj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Aug 2012 13:48:39 -0400
In-Reply-To: <20120821162315.GA5135@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sreekanth.reddy@lsi.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, jejb@kernel.org, stable@vger.kernel.org


--nextPart1746846.1rdkakQSz9
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Dienstag 21 August 2012, 21:53:15 schrieb sreekanth.reddy@lsi.com:
> Fix for issue - Unable to boot from the SAS drive connected to HBA
> 
> This patch checks whether HBA is SAS2008 B0 controller.
> if it is a SAS2008 B0 controller then it use IO-APIC interrupt instead of
> MSIX, as SAS2008 B0 controller doesn't support MSIX interrupts.
> 
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
> Cc: <stable@kernel.org>
> ---
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
> b/drivers/scsi/mpt2sas/mpt2sas_base.c index 6102ef2..fd2f4ad 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -1207,6 +1207,15 @@ _base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
>  {
>  	int base;
>  	u16 message_control;
> +	u8 revision;
> +
> +	/* Check whether controller SAS2008 B0 controller,
> +	   if it is a SAS2008 B0 controller use IO-APIC instead of MSIX */
> +	pci_read_config_byte(ioc->pdev, PCI_CLASS_REVISION, &revision);

Nope. Just use ioc->pdev->revision here.

> +	if (ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2008 &&
> +	    revision == 0x01) {
> +		return -EINVAL;
> +	}
> 
> 
>  	base = pci_find_capability(ioc->pdev, PCI_CAP_ID_MSIX);

Eike
--nextPart1746846.1rdkakQSz9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlAzyfMACgkQXKSJPmm5/E4s7wCglxn6hqR+uOwfThoIy/ti0wJ3
76oAni0atxK/8nzFM9JA9RP/btrN9xOh
=R8nd
-----END PGP SIGNATURE-----

--nextPart1746846.1rdkakQSz9--

