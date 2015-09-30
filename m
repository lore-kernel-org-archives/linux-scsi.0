From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 30/32] cxlflash: Fix to avoid corrupting adapter fops
Date: Wed, 30 Sep 2015 10:18:00 +1000
Message-ID: <878u7ou5dz.fsf@gamma.ozlabs.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443223164-10077-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33104 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbbI3AST (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2015 20:18:19 -0400
Received: by pacex6 with SMTP id ex6so20673101pac.0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 17:18:19 -0700 (PDT)
In-Reply-To: <1443223164-10077-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

"Matthew R. Ochs" <mrochs@linux.vnet.ibm.com> writes:

> The corruption that this fix remedies is due to the fact that the fops
> is initially defaulted to values found within a static structure. When
> the fops is handed down to the CXL services later in the attach path,
> certain services are patched. The fops structure remains correct until
> the user count drops to 0 and the fops is reset, triggering the process
> to repeat again. The user counts are tightly coupled with the creation
> and deletion of the user context. If multiple users perform a disk
> attach at the same time, when the user count is currently 0, some users
> can be in the middle of obtaining a file descriptor and have not yet
> reached the context creation code that [in addition to creating the
> context] increments the user count. Subsequent users coming in to
> perform the attach see that the user count is still 0, and reinitialize
> the fops, temporarily removing the patched fops. The users that are in
> the middle obtaining their file descriptor may then receive an invalid
> descriptor.
>
> The fix simply removes the user count altogether and moves the fops
> initialization to probe time such that it is only performed one time
> for the life of the adapter. In the future, if the CXL services adopt
> a private member for their context, that could be used to store the
> adapter structure reference and cxlflash could revert to a model that
> does not require an embedded fops.

Yep, this looks good.

We have discussed adding a private data field to a cxl context, and will
no doubt revisit the question at some point in the future :)

Reviewed-by: Daniel Axtens <dja@axtens.net>

>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxlflash/common.h    |  3 +--
>  drivers/scsi/cxlflash/main.c      |  1 +
>  drivers/scsi/cxlflash/superpipe.c | 11 +----------
>  3 files changed, 3 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/commo=
n.h
> index bbfe711..c11cd19 100644
> --- a/drivers/scsi/cxlflash/common.h
> +++ b/drivers/scsi/cxlflash/common.h
> @@ -21,6 +21,7 @@
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_device.h>
>=20=20
> +extern const struct file_operations cxlflash_cxl_fops;
>=20=20
>  #define MAX_CONTEXT  CXLFLASH_MAX_CONTEXT       /* num contexts per afu =
*/
>=20=20
> @@ -115,8 +116,6 @@ struct cxlflash_cfg {
>  	struct list_head ctx_err_recovery; /* contexts w/ recovery pending */
>  	struct file_operations cxl_fops;
>=20=20
> -	atomic_t num_user_contexts;
> -
>  	/* Parameters that are LUN table related */
>  	int last_lun_index[CXLFLASH_NUM_FC_PORTS];
>  	int promote_lun_index;
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index be78906..38e7edc 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -2386,6 +2386,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
>=20=20
>  	cfg->init_state =3D INIT_STATE_NONE;
>  	cfg->dev =3D pdev;
> +	cfg->cxl_fops =3D cxlflash_cxl_fops;
>=20=20
>  	/*
>  	 * The promoted LUNs move to the top of the LUN table. The rest stay
> diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/su=
perpipe.c
> index 3cc8609..f625e07 100644
> --- a/drivers/scsi/cxlflash/superpipe.c
> +++ b/drivers/scsi/cxlflash/superpipe.c
> @@ -712,7 +712,6 @@ static void destroy_context(struct cxlflash_cfg *cfg,
>  	kfree(ctxi->rht_needs_ws);
>  	kfree(ctxi->rht_lun);
>  	kfree(ctxi);
> -	atomic_dec_if_positive(&cfg->num_user_contexts);
>  }
>=20=20
>  /**
> @@ -769,7 +768,6 @@ static struct ctx_info *create_context(struct cxlflas=
h_cfg *cfg,
>  	INIT_LIST_HEAD(&ctxi->luns);
>  	INIT_LIST_HEAD(&ctxi->list); /* initialize for list_empty() */
>=20=20
> -	atomic_inc(&cfg->num_user_contexts);
>  	mutex_lock(&ctxi->mutex);
>  out:
>  	return ctxi;
> @@ -1164,10 +1162,7 @@ out:
>  	return rc;
>  }
>=20=20
> -/*
> - * Local fops for adapter file descriptor
> - */
> -static const struct file_operations cxlflash_cxl_fops =3D {
> +const struct file_operations cxlflash_cxl_fops =3D {
>  	.owner =3D THIS_MODULE,
>  	.mmap =3D cxlflash_cxl_mmap,
>  	.release =3D cxlflash_cxl_release,
> @@ -1286,10 +1281,6 @@ static int cxlflash_disk_attach(struct scsi_device=
 *sdev,
>=20=20
>  	int fd =3D -1;
>=20=20
> -	/* On first attach set fileops */
> -	if (atomic_read(&cfg->num_user_contexts) =3D=3D 0)
> -		cfg->cxl_fops =3D cxlflash_cxl_fops;
> -
>  	if (attach->num_interrupts > 4) {
>  		dev_dbg(dev, "%s: Cannot support this many interrupts %llu\n",
>  			__func__, attach->num_interrupts);
> --=20
> 2.1.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJWCyo4AAoJEPC3R3P2I92FOocQAL/oCrGAuMhIfgn9D4SFTbNk
46b+do1Ax6hgRTRr9yMM8MSVxoI+8XlpCZJfAOARqyKuN82E+4M1R2zmVRsL7Nu5
ZJeBQLP7G1QEDQPXcogz36rNv63dI0kNsx8JStnrRaZmaiJf3ccZ5sXyx/zIHlw9
gvD1EwAnG9JZX/SmnwFtB/dJKWEv8nFiEob7Zg2YMMf5pX6C9woi3LOyNRli7hak
aX1uluFa9pvJmqkRsS9X9tvpJBvMv4dwFMkLy92onV7ZZRFjmwvHuAsGWvhfeigd
CHn3U1ko0QtkxGjFaXJUs4tdIB7ZNtFBt9kbdtJnO7X4ZhbNWy27mVd7GIRE8Z/T
dYhz9gifhp1dXXrNiECuuACR1d/QvUKgTZvfchvHmeQYKNhYAT2Zl1IGkSShixrJ
xzDs3D2iFp5opR0l6f2gEe1DtucX2J8SafwXx+NBevHLouRxqMsYyFFDI0ahkrKf
Utwg9jKWxV3C/mNFDXYw749A5hk+MmxNj+R8reLk1Fa54jpdcCgiig1yuWv5LLeB
vqe+ihJA8CL2YAjKxJxa3gSQdv/fEZUYisz5v6Og+0WQyM1v6/N9zrYQjGbwPCvz
R9LJvw5ObqMpl0IY/DQFScFW9TDcgPqvugqEF4Oxjk6eipuDgffoaREje9x145j+
70uEOrexGi2sdSPrc7oV
=I8zr
-----END PGP SIGNATURE-----
--=-=-=--
