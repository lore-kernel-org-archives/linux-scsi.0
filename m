From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/6] ibmvscsi: Replace magic values in set_adpater_info()
 with defines
Date: Thu, 4 Feb 2016 09:44:59 +0100
Message-ID: <20160204084459.GW27969@c203.arch.suse.de>
References: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <1454542114-1797-4-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964852AbcBDIpC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Feb 2016 03:45:02 -0500
Content-Disposition: inline
In-Reply-To: <1454542114-1797-4-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, hare@suse.de

On Wed, Feb 03, 2016 at 05:28:31PM -0600, Tyrel Datwyler wrote:
> Add defines for mad version and mad os_type, and replace the magic
> numbers in set_adapter_info() accordingly.
>=20
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 4 ++--
>  drivers/scsi/ibmvscsi/viosrp.h   | 2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi=
/ibmvscsi.c
> index 176260d..7e51615 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -283,8 +283,8 @@ static void set_adapter_info(struct ibmvscsi_host=
_data *hostdata)
>  	hostdata->madapter_info.partition_number =3D
>  					cpu_to_be32(partition_number);
> =20
> -	hostdata->madapter_info.mad_version =3D cpu_to_be32(1);
> -	hostdata->madapter_info.os_type =3D cpu_to_be32(2);
> +	hostdata->madapter_info.mad_version =3D cpu_to_be32(SRP_MAD_VERSION=
_1);
> +	hostdata->madapter_info.os_type =3D cpu_to_be32(SRP_MAD_OS_LINUX);
>  }
> =20
>  /**
> diff --git a/drivers/scsi/ibmvscsi/viosrp.h b/drivers/scsi/ibmvscsi/v=
iosrp.h
> index 17f2de0..da9bb29 100644
> --- a/drivers/scsi/ibmvscsi/viosrp.h
> +++ b/drivers/scsi/ibmvscsi/viosrp.h
> @@ -38,6 +38,8 @@
>  #define SRP_VERSION "16.a"
>  #define SRP_MAX_IU_LEN	256
>  #define SRP_MAX_LOC_LEN 32
> +#define SRP_MAD_VERSION_1 1
> +#define SRP_MAD_OS_LINUX 2
> =20
>  union srp_iu {
>  	struct srp_login_req login_req;
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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
