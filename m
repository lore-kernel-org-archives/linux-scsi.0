From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v3 2/4] cxlflash: Base error recovery support
Date: Fri, 07 Aug 2015 15:12:27 +1000
Message-ID: <1438924347.6796.22.camel@axtens.net>
References: <1438576402-32935-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RQFUbz+8oyqGpCUhUBOH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35403 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbbHGFOn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2015 01:14:43 -0400
Received: by pabxd6 with SMTP id xd6so61310428pab.2
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2015 22:14:42 -0700 (PDT)
In-Reply-To: <1438576402-32935-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>


--=-RQFUbz+8oyqGpCUhUBOH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,=20

> @@ -1857,9 +1884,18 @@ static int cxlflash_eh_device_reset_handler(struct=
 scsi_cmnd *scp)
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
> =20
> -	rcr =3D send_tmf(afu, scp, TMF_LUN_RESET);
> -	if (unlikely(rcr))
> -		rc =3D FAILED;
> +	switch (cfg->eeh_active) {
> +	case EEH_STATE_NONE:
> +		rcr =3D send_tmf(afu, scp, TMF_LUN_RESET);
> +		if (unlikely(rcr))
> +			rc =3D FAILED;
> +		break;
> +	case EEH_STATE_ACTIVE:
> +		wait_event(cfg->eeh_waitq, cfg->eeh_active !=3D EEH_STATE_ACTIVE);
> +		break;
> +	case EEH_STATE_FAILED:
> +		break;
> +	}
> =20

Looking at the context here, it looks like rc gets initalised to
SUCCESS. In that case, in the EEH failed case, you'll return SUCCESS.
I'm not particularly clear on the semantics here: does that make sense?

Likewise, in the EEH active state, when you finish the wait_event,
should you check if the EEH state went to NONE or FAILED before you
break?

There's a similar case below in host_reset.

>  	pr_debug("%s: returning rc=3D%d\n", __func__, rc);
>  	return rc;
> @@ -1889,11 +1925,23 @@ static int cxlflash_eh_host_reset_handler(struct =
scsi_cmnd *scp)
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
> =20
> -	rcr =3D afu_reset(cfg);
> -	if (rcr =3D=3D 0)
> -		rc =3D SUCCESS;
> -	else
> -		rc =3D FAILED;
> +	switch (cfg->eeh_active) {
> +	case EEH_STATE_NONE:
> +		cfg->eeh_active =3D EEH_STATE_FAILED;
> +		rcr =3D afu_reset(cfg);
> +		if (rcr =3D=3D 0)
> +			rc =3D SUCCESS;
> +		else
> +			rc =3D FAILED;
> +		cfg->eeh_active =3D EEH_STATE_NONE;
> +		wake_up_all(&cfg->eeh_waitq);
> +		break;
> +	case EEH_STATE_ACTIVE:
> +		wait_event(cfg->eeh_waitq, cfg->eeh_active !=3D EEH_STATE_ACTIVE);
> +		break;
> +	case EEH_STATE_FAILED:
> +		break;
> +	}
> =20
>  	pr_debug("%s: returning rc=3D%d\n", __func__, rc);
>  	return rc;
> @@ -2145,6 +2193,11 @@ static void cxlflash_worker_thread(struct work_str=
uct *work)
>  	int port;
>  	ulong lock_flags;
> =20
> +	/* Avoid MMIO if the device has failed */
> +
> +	if (cfg->eeh_active =3D=3D EEH_STATE_FAILED)
> +		return;
> +
Should this check be !=3D EEH_STATE_NONE? Or is this called within the
error recovery process?

>  	spin_lock_irqsave(cfg->host->host_lock, lock_flags);
> =20
>  	if (cfg->lr_state =3D=3D LINK_RESET_REQUIRED) {
> @@ -2226,6 +2279,8 @@ static int cxlflash_probe(struct pci_dev *pdev,
> =20
>  	cfg->init_state =3D INIT_STATE_NONE;
>  	cfg->dev =3D pdev;
> +
> +	cfg->eeh_active =3D EEH_STATE_NONE;
>  	cfg->dev_id =3D (struct pci_device_id *)dev_id;
> =20
>=20
> @@ -2286,6 +2341,85 @@ out_remove:
>  	goto out;
>  }
> =20
> +/**
> + * cxlflash_pci_error_detected() - called when a PCI error is detected
> + * @pdev:	PCI device struct.
> + * @state:	PCI channel state.
> + *
> + * Return: PCI_ERS_RESULT_NEED_RESET or PCI_ERS_RESULT_DISCONNECT
> + */
> +static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev=
,
> +						    pci_channel_state_t state)
> +{
> +	struct cxlflash_cfg *cfg =3D pci_get_drvdata(pdev);
> +
> +	pr_debug("%s: pdev=3D%p state=3D%u\n", __func__, pdev, state);
> +
> +	switch (state) {
> +	case pci_channel_io_frozen:
> +		cfg->eeh_active =3D EEH_STATE_ACTIVE;
> +		udelay(100);
> +
> +		term_mc(cfg, UNDO_START);
> +		stop_afu(cfg);
> +
> +		return PCI_ERS_RESULT_CAN_RECOVER;

I think that should PCI_ERS_RESULT_NEED_RESET.

Apart from that, it's looking pretty good from an EEH perspective.

--=20
Regards,
Daniel

--=-RQFUbz+8oyqGpCUhUBOH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: GPGTools - https://gpgtools.org

iQIcBAABCgAGBQJVxD47AAoJEPC3R3P2I92FDBkQANRNJ1a+gphkRGhVzgvqDCGf
POuzmNGSEN9sSw3MSOVNYl4nevb6iQjVPGVx3rk629E8bq834gDRY6UlNCCyojI2
6BkGfjSqSwUnF9o5VJEYNn+stqIKuVnWTCeBpxILnDIFxiCHipl7EOraTBBXgarO
kg7r8YyNoLRwzDZRx+Awc7RH6zzHSOWd1wcFZHyVy9CEL8YwMii9oNnkMIjWZFgN
c/GhVZeJwZYag9C82UppHmGZcU7qFCrktOldN0ByZE/O8rAqgQvlccRoyU4t57k5
ZNAsv6aBAgb+fws4Y4WgF/E1Gffn/+Q6xuhT/XYdaro2Q/3uQEkUZU0LtpHg/699
ealc2dtPlBFnM6pog9eUIl6zgZx+69M8O19vucKlUnhppPbvYKCzpnLkSwkYeJwz
5Uk9lwf/jkQjbBW2WMHlQZPcoMzzPuuMBX/ZMHyW9F90Vplk2qxVGB957VmwxZck
/STxQXkSY4c2GE4I8f9RYPeAW2/6tLO4zbH2gnXt5Uk3RreSjXxTimC0RaLx1rI7
LLssbQIvSmGBYV0bf72HzTbmCw43kVc48Fm89qCEFQ6Oim9oG0YFn9LySHnVK8e1
+6uwkfhFiWET9jNoxZ/Td6B0Fid4YX02Jznv1zXcD+mTHAA/dv/xJH8M/oFj01XA
hIwNg+qHfZt0+nH21pCS
=qcGH
-----END PGP SIGNATURE-----

--=-RQFUbz+8oyqGpCUhUBOH--

