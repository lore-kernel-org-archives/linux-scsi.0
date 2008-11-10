From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] qla2xxx: Fix for build warning
Date: Tue, 11 Nov 2008 10:22:39 +1100
Message-ID: <20081111102239.abf05c65.sfr@canb.auug.org.au>
References: <200811071744.mA7HiJaf012195@hera.kernel.org>
	<alpine.OSX.1.00.0811101211050.1560@n4012av5rky081.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__11_Nov_2008_10_22_39_+1100_P1_LIMdq537f1yHs"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.1.00.0811101211050.1560@n4012av5rky081.qlogic.org>
Sender: linux-next-owner@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-next@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Signature=_Tue__11_Nov_2008_10_22_39_+1100_P1_LIMdq537f1yHs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anirban,

On Mon, 10 Nov 2008 12:26:23 -0800 (PST) Anirban Chakraborty <anirban.chakr=
aborty@qlogic.com> wrote:
>
> Here is the patch that takes care of the build warning due to a=20
> missing initializer for a local variable in qla probe function.
> Please apply.
>=20
> Thanks,
> Anirban
>=20
> Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
>=20
> ---
>  drivers/scsi/qla2xxx/qla_os.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 05db166..9aa24a4 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1563,7 +1563,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struc=
t pci_device_id *id)
>  	char pci_info[30];
>  	char fw_str[30];
>  	struct scsi_host_template *sht;
> -	int bars, mem_only, max_id =3D 0;
> +	int bars, mem_only =3D 0, max_id =3D 0;

Except that max_id does not need to be initialised (its is assigned
unconditionally before being used).  I suspect what happened is that in
the origin patch, the ", max_id" was inserted before the " =3D 0" instead
of after it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Nov_2008_10_22_39_+1100_P1_LIMdq537f1yHs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkYwj8ACgkQjjKRsyhoI8wUiQCfct0yaNbgl3oZTpmxN/CqF6no
2IMAoKzLWf5AQWavbh0dgRbnkXpnEd1j
=1UE1
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Nov_2008_10_22_39_+1100_P1_LIMdq537f1yHs--
