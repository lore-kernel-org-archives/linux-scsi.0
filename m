From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH] lsscsi: Fix truncation of 128-bit wwn
Date: Fri, 17 Mar 2017 18:28:49 +0800
Message-ID: <20170317102849.GA2719@redhat.com>
References: <20170317043840.26560-1-vaibhav@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54716 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750899AbdCQK24 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Mar 2017 06:28:56 -0400
Content-Disposition: inline
In-Reply-To: <20170317043840.26560-1-vaibhav@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vaibhav Jain <vaibhav@linux.vnet.ibm.com>
Cc: Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Jon Grimm <jon.grimm@canonical.com>, Vipin K Parashar <vipin@linux.vnet.ibm.com>, Ping Tian Han <pthan@cn.ibm.com>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 17, 2017 at 10:08:40AM +0530, Vaibhav Jain wrote:
> ---
>  src/lsscsi.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/src/lsscsi.c b/src/lsscsi.c
> index 974b3f1..f20adcf 100644
> --- a/src/lsscsi.c
> +++ b/src/lsscsi.c
> @@ -210,8 +210,8 @@ struct dev_node_list {
>  static struct dev_node_list* dev_node_listhead =3D NULL;
> =20
>  struct disk_wwn_node_entry {
> -       char wwn[32];
> -       char disk_bname[12];
> +	char wwn[35]; /* '0x' + wwn<128-bit> + <null-terminator> */
Please consider to define a constant instead of using a magic number
everywhere. Like:
#define _DISK_WWN_MAX_LEN           35
/* ^ WWN here is extracted from /dev/disk/by-id/wwn-<WWN> which is
 *   created by udev 60-persistent-storage.rules using ID_WWN_WITH_EXTENSIO=
N.
 *   The udev ID_WWN_WITH_EXTENSION is the combination of char wwn[17] and
 *   char wwn_vendor_extension[17] from struct scsi_id_device.
 */
> +	char disk_bname[12];
Please use space instead of \t for indention.
>  };
> =20
>  #define DISK_WWN_NODE_LIST_ENTRIES 16
> @@ -2939,14 +2939,14 @@ one_sdev_entry(const char * dir_name, const char =
* devname,
>                  }
>                  if (wd[0]) {
>                          char dev_node[LMAX_NAME] =3D "";
> -                        char wwn_str[34];
> +			char wwn_str[35];
Please use space instead of \t for indention.
>                          enum dev_type typ;
> =20
>                          typ =3D (FT_BLOCK =3D=3D non_sg.ft) ? BLK_DEV : =
CHR_DEV;
>                          if (get_wwn) {
>                                  if ((BLK_DEV =3D=3D typ) &&
>                                      get_disk_wwn(wd, wwn_str, sizeof(wwn=
_str)))
> -                                        printf("%-30s  ", wwn_str);
> +					printf("%-34s  ", wwn_str);
Please use constant instead of magic number:
    printf("%-*s  ", _DISK_WWN_MAX_LEN - 1, wwn_str);
>                                  else
>                                          printf("                        =
  "
>                                                 "      ");
> --=20
> 2.9.3
>=20

--=20
Gris Ge

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8f1XsqXpyNthgIbGbM3lj+QeKP8FAljLul4ACgkQbM3lj+Qe
KP/AdQ/+NTAjJjX3ULTdcv/Fx0IZn2sOVyW6mr7UKs1sxeE+k/s+OZugNJ0Seil6
BgS86uXfMuuTREJmBiF8+cs3yBLdV7rfBxf/nfLWB89pPmeboRSHcB2HKvdN8aTR
nn992uq45QNQGXfyE3CLR2ygp5wyO0H6Zik0kQswpXUteY8yEm7QK6Boh422JDEW
qzBgI23ux26PaP7XT0ixDUVhAv0G59iqF18BUYMz5FQ73ZVvH48lN8Lb3VuHv6a4
LAGXUOYpqZcmgT+0y1uK+cJ0A4ZDCgyMaHoi6cKt0fMv70yUetf/Qnk0vyTpR/H+
MggH3JGk0cjL+Q0mlZEoIVTllWAGHxcC41jYsBD+EMbogRLwcsewFB6x+gNoJBws
5ZDoGqJvQ6eLCHPkLeN34C2iMfYcEhye9cjFb2J5GBpeY5yiiMiB9hwYNOlJDWpt
jB2/5GftLisSMCElU7R/KwdiNVO8I4YskdNVfq3ppyY6a7z9St/9u3OK9fk72fcv
XwcsQ0JrGHCguzyNE0+/W2NrGCqdmF7EPx34HCQAlLkahm2aYQejMr6VxSmZvgEe
VTB2i935FxP3FyXakwndgyvllJWnWwBt+IJaBM8FMgvst/HGV8xlFzTE1Z/eumtm
2+fM7gHMiBb7tsre5lfpCzVoNzlCsMKrh3G6It6TiolvvMfP6HI=
=EkPp
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
