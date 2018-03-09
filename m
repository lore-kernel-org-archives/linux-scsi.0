From: Stephen Kitt <steve@sk2.org>
Subject: Re: [PATCH] bfa: remove VLA
Date: Fri, 9 Mar 2018 23:15:42 +0100
Message-ID: <20180309231542.3eb53b87@heffalump.sk2.org>
References: <20180308213841.13807-1-steve@sk2.org>
        <CAGXu5j+_DvU4jNESxO2zBvP_VrTxOwVzh_NXqdw+S5amQukNjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/jOtjcHV197POdtlrpWmTaxu"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+_DvU4jNESxO2zBvP_VrTxOwVzh_NXqdw+S5amQukNjg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Sig_/jOtjcHV197POdtlrpWmTaxu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I sent this to the wrong maintainers, sorry =E2=80=94 you=E2=80=99ll find t=
he original patch
on https://patchwork.kernel.org/patch/10269257/

Regards,

Stephen


On Thu, 8 Mar 2018 13:43:07 -0800, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Mar 8, 2018 at 1:38 PM, Stephen Kitt <steve@sk2.org> wrote:
> > In preparation to enabling -Wvla, remove VLAs and replace them with
> > fixed-length arrays instead.
> >
> > bfad_bsg.c uses a variable-length array declaration to measure the
> > size of a putative array; this can be replaced by the product of the
> > size of an element and the number of elements, avoiding the VLA
> > altogether.
> >
> > This was prompted by https://lkml.org/lkml/2018/3/7/621
> >
> > Signed-off-by: Stephen Kitt <steve@sk2.org> =20
>=20
> Reviewed-by: Kees Cook <keescook@chromium.org>
>=20
> -Kees
>=20
> > ---
> >  drivers/scsi/bfa/bfad_bsg.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
> > index 3976e787ba64..7c884f881180 100644
> > --- a/drivers/scsi/bfa/bfad_bsg.c
> > +++ b/drivers/scsi/bfa/bfad_bsg.c
> > @@ -891,7 +891,7 @@ bfad_iocmd_fabric_get_lports(struct bfad_s *bfad,
> > void *cmd,
> >
> >         if (bfad_chk_iocmd_sz(payload_len,
> >                 sizeof(struct bfa_bsg_fabric_get_lports_s),
> > -               sizeof(wwn_t[iocmd->nports])) !=3D BFA_STATUS_OK) {
> > +               sizeof(wwn_t) * iocmd->nports) !=3D BFA_STATUS_OK) {
> >                 iocmd->status =3D BFA_STATUS_VERSION_FAIL;
> >                 goto out;
> >         }
> > --
> > 2.11.0
> > =20
>=20
>=20
>=20
> --=20
> Kees Cook
> Pixel Security

--Sig_/jOtjcHV197POdtlrpWmTaxu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAlqjB48ACgkQgNMC9Yht
g5wCVg//UcQ24fCOOWQ5szsHoH5YyR1bybfaTFF7kioyZbs8Y81CvCAHDrPG4e/L
amizlXarNLtjYRGGCilsR8G7ZVa0PzaZiVE4H+r4feFZ4YARFgZH2Hu2qyySwTRK
yu0tchLBE3/QlGgNC/0zd7pPWMXcNeB88OZCbcIGjy/GG5SO1XRjiPaAKsHfe6b3
9AFyr4bHKwqzuZaLLMZSJgb9J1RIFH0ZF4KPc+bc4tHMlNryU4VWJzuucZQzS5AI
tzFbuwi7V+7R9qj7o7TdrDKw64HrBgFci+f1xRkGKoOrPTXpXMSWt0zMjaKI47ft
FNvFoftDHNRNs+4v7b3mczLW0UAFiLA9gGSwWqv4ra/Ot0BcevILYdc2RQrIIcZ0
FBWugDaSnexs/IcTkaooInaR0mDGZig9NcWd0mzmcszg/b6hqqtcuSXrQX0W9TAH
St5ObogNFnBIrqHNROyCtKhZBxsKqTlAMOhvQziTtUoCG4jmVt4OpJ/J6K+SJ6zw
BCRn7FkKb5fbnd7RsUOKn6RiP87OXie2f/lGn1JpaOZq47ndHw01xh2b0u6aAq/j
fVMqK5ODTNYYogt/GQrxIGQ5bjt5rWa/147XMZW1NGWJ896eq/nkv9Cb33PhC0si
wPAvk2D7+fdMYeeXdkWWU1YvljrI6s1FWO8blFVY00rvNgJXEeg=
=jztF
-----END PGP SIGNATURE-----

--Sig_/jOtjcHV197POdtlrpWmTaxu--
