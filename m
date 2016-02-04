From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 6/6] ibmvscsi: Add endian conversions to sysfs attribute
 show functions
Date: Thu, 4 Feb 2016 09:45:52 +0100
Message-ID: <20160204084552.GY27969@c203.arch.suse.de>
References: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <1454542114-1797-7-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454542114-1797-7-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 03, 2016 at 05:28:34PM -0600, Tyrel Datwyler wrote:
> The values returned by the show functions for the host os_type,
> mad_version, and partition_number attributes get their values
> directly from the madapter_info struct whose associated fields are
> __be32 typed. Added endian conversion to ensure these values are
> sane on LE platforms.
>=20
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi=
/ibmvscsi.c
> index a2b8db1..3621ac5 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -1983,7 +1983,7 @@ static ssize_t show_host_partition_number(struc=
t device *dev,
>  	int len;
> =20
>  	len =3D snprintf(buf, PAGE_SIZE, "%d\n",
> -		       hostdata->madapter_info.partition_number);
> +		       be32_to_cpu(hostdata->madapter_info.partition_number));
>  	return len;
>  }
> =20
> @@ -2003,7 +2003,7 @@ static ssize_t show_host_mad_version(struct dev=
ice *dev,
>  	int len;
> =20
>  	len =3D snprintf(buf, PAGE_SIZE, "%d\n",
> -		       hostdata->madapter_info.mad_version);
> +		       be32_to_cpu(hostdata->madapter_info.mad_version));
>  	return len;
>  }
> =20
> @@ -2022,7 +2022,8 @@ static ssize_t show_host_os_type(struct device =
*dev,
>  	struct ibmvscsi_host_data *hostdata =3D shost_priv(shost);
>  	int len;
> =20
> -	len =3D snprintf(buf, PAGE_SIZE, "%d\n", hostdata->madapter_info.os=
_type);
> +	len =3D snprintf(buf, PAGE_SIZE, "%d\n",
> +		       be32_to_cpu(hostdata->madapter_info.os_type));
>  	return len;
>  }
> =20
> --=20
> 2.5.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
