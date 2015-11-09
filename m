From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 3/3] ibmvscsi: Allow to configure maximum LUN
Date: Mon, 09 Nov 2015 15:50:14 +0100
Message-ID: <5640B2A6.20401@suse.de>
References: <1447080465-17858-1-git-send-email-lvivier@redhat.com> <1447080465-17858-4-git-send-email-lvivier@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447080465-17858-4-git-send-email-lvivier@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <lvivier@redhat.com>, martin.petersen@oracle.com
Cc: brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/09/2015 03:47 PM, Laurent Vivier wrote:
> This patch allows to define the maximum LUN numbers.
> As defined in 4.6.9 of SAM-4, the encoding of LUN is
> on 5 bits (max_lun=3D32) and the current value is only 8.
>=20
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 9 ++++++++-
>  drivers/scsi/ibmvscsi/ibmvscsi.h | 1 +
>  2 files changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi=
/ibmvscsi.c
> index 04de287..adcd5e8 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -84,6 +84,7 @@
>   */
>  static int max_id =3D 64;
>  static int max_channel =3D 3;
> +static int max_lun =3D 8;
>  static int init_timeout =3D 300;
>  static int login_timeout =3D 60;
>  static int info_timeout =3D 30;
> @@ -117,6 +118,9 @@ module_param_named(fast_fail, fast_fail, int, S_I=
RUGO | S_IWUSR);
>  MODULE_PARM_DESC(fast_fail, "Enable fast fail. [Default=3D1]");
>  module_param_named(client_reserve, client_reserve, int, S_IRUGO );
>  MODULE_PARM_DESC(client_reserve, "Attempt client managed reserve/rel=
ease");
> +module_param(max_lun, int, S_IRUGO);
> +MODULE_PARM_DESC(max_lun, "Maximum allowed LUN "
> +                          "[Default=3D8,Max=3D"__stringify(IBMVSCSI_=
MAX_LUN)"]");
> =20
>  static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
>  				struct ibmvscsi_host_data *hostdata);
> @@ -2289,7 +2293,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev,=
 const struct vio_device_id *id)
>  		goto init_pool_failed;
>  	}
> =20
> -	host->max_lun =3D 8;
> +	host->max_lun =3D max_lun;
>  	host->max_id =3D max_id;
>  	host->max_channel =3D max_channel;
>  	host->max_cmd_len =3D 16;
> @@ -2414,6 +2418,9 @@ int __init ibmvscsi_module_init(void)
>  {
>  	int ret;
> =20
> +	if (max_lun > IBMVSCSI_MAX_LUN)
> +		return -EINVAL;
> +
>  	/* Ensure we have two requests to do error recovery */
>  	driver_template.can_queue =3D max_requests;
>  	max_events =3D max_requests + 2;
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.h b/drivers/scsi/ibmvscsi=
/ibmvscsi.h
> index 7d64867..1067367 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.h
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.h
> @@ -48,6 +48,7 @@ struct Scsi_Host;
>  #define IBMVSCSI_CMDS_PER_LUN_DEFAULT 16
>  #define IBMVSCSI_MAX_SECTORS_DEFAULT 256 /* 32 * 8 =3D default max I=
/O 32 pages */
>  #define IBMVSCSI_MAX_CMDS_PER_LUN 64
> +#define IBMVSCSI_MAX_LUN 32
> =20
>  /* ------------------------------------------------------------
>   * Data Structures
>=20
Please set max_lun to 31, and remove everything else.
As discussed, max_lun is the max number of LUNs supported by the
hardware/HBA. There is no point in restricting it further.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
