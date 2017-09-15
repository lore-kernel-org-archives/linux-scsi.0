From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH RESEND] aacraid: Fix 2T+ drives on SmartIOC-2000
Date: Fri, 15 Sep 2017 19:20:31 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A8D5B88DF@avsrvexchmbx1.microsemi.net>
References: <20170915170428.15237-1-david.carroll@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170915170428.15237-1-david.carroll@microsemi.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Dave Carroll <david.carroll@microsemi.com>, linux-scsi <linux-scsi@vger.kernel.org>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Brian King <brking@linux.vnet.ibm.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Dave Carroll [mailto:david.carroll@microsemi.com]
> Sent: Friday, September 15, 2017 10:04 AM
> To: Martin K . Petersen <martin.petersen@oracle.com>; James Bottomley
> <jejb@linux.vnet.ibm.com>
> Cc: Dave Carroll <david.carroll@microsemi.com>; linux-scsi <linux-
> scsi@vger.kernel.org>; dl-esc-Aacraid Linux Driver
> <aacraid@microsemi.com>; Scott Benesh <scott.benesh@microsemi.com>;
> Brian King <brking@linux.vnet.ibm.com>; stable@vger.kernel.org
> Subject: [PATCH RESEND] aacraid: Fix 2T+ drives on SmartIOC-2000
>=20
> The logic for supporting large drives was previously tied to 4Kn support
> for SmartIOC-2000. As SmartIOC-2000 does not support volumes using 4Kn
> drives, use the intended option flag AAC_OPT_NEW_COMM_64 to
> determine
> support for volumes greater than 2T.
>=20
> cc: stable@vger.kernel.org
> Signed-off-by: Dave Carroll <david.carroll@microsemi.com>
>=20
> ---
>  drivers/scsi/aacraid/aachba.c  | 12 ++++++------
>  drivers/scsi/aacraid/aacraid.h |  5 +++++
>  2 files changed, 11 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.=
c
> index 4591113..18a1a1f 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -695,13 +695,13 @@ static void _aac_probe_container1(void * context,
> struct fib * fibptr)
>  	int status;
>=20
>  	dresp =3D (struct aac_mount *) fib_data(fibptr);
> -	if (!(fibptr->dev->supplement_adapter_info.supported_options2 &
> -	    AAC_OPTION_VARIABLE_BLOCK_SIZE))
> +	if (!aac_supports_2T(fibptr->dev)) {
>  		dresp->mnt[0].capacityhigh =3D 0;
> -	if ((le32_to_cpu(dresp->status) !=3D ST_OK) ||
> -	    (le32_to_cpu(dresp->mnt[0].vol) !=3D CT_NONE)) {
> -		_aac_probe_container2(context, fibptr);
> -		return;
> +		if ((le32_to_cpu(dresp->status) =3D=3D ST_OK) &&
> +			(le32_to_cpu(dresp->mnt[0].vol) !=3D CT_NONE)) {
> +			_aac_probe_container2(context, fibptr);
> +			return;
> +		}
>  	}
>  	scsicmd =3D (struct scsi_cmnd *) context;
>=20
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacrai=
d.h
> index 6981299..998fbad 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -2701,6 +2701,11 @@ static inline int aac_is_src(struct aac_dev *dev)
>  	return 0;
>  }
>=20
> +static inline int aac_supports_2T(struct aac_dev *dev)
> +{
> +	return (dev->adapter_info.options & AAC_OPT_NEW_COMM_64);
> +}
> +
>  char * get_container_type(unsigned type);
>  extern int numacb;
>  extern char aac_driver_version[];
> --
> 2.8.4

Reviewed-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.co=
m>
