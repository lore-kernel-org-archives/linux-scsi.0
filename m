From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1.1 1/1]  arcmsr: Notify has sense data report
Date: Fri, 28 Nov 2014 11:14:53 +0100
Message-ID: <54784B1D.6030308@suse.de>
References: <1417169252.25477.11.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaK1KO4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2014 05:14:56 -0500
In-Reply-To: <1417169252.25477.11.camel@Centos6.3-64>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/28/2014 11:07 AM, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>=20
> Setting command status with 'DRIVER_SENSE' except 'CHECK_CONDITION' i=
f we have sense data.
>=20
> Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> ---
>=20
> This patch is relative to http://git.infradead.org/users/hch/scsi-que=
ue.git/tree/refs/heads/drivers-for-3.18:/drivers/scsi/arcmsr
>=20
>=20
> diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcms=
r.h
> --- a/drivers/scsi/arcmsr/arcmsr.h	2014-09-19 11:04:41.845100000 +080=
0
> +++ b/drivers/scsi/arcmsr/arcmsr.h	2014-11-28 10:54:30.000000000 +080=
0
> @@ -52,7 +52,7 @@ struct device_attribute;
>  	#define ARCMSR_MAX_FREECCB_NUM	320
>  #define ARCMSR_MAX_OUTSTANDING_CMD	255
>  #endif
> -#define ARCMSR_DRIVER_VERSION		"v1.30.00.04-20140919"
> +#define ARCMSR_DRIVER_VERSION		"v1.30.00.05-20141128"
>  #define ARCMSR_SCSI_INITIATOR_ID						255
>  #define ARCMSR_MAX_XFER_SECTORS							512
>  #define ARCMSR_MAX_XFER_SECTORS_B						4096
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/a=
rcmsr_hba.c
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-09-19 11:01:26.990090000 =
+0800
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-11-28 17:51:04.000000000 =
+0800
> @@ -989,16 +989,15 @@ static void arcmsr_report_sense_info(str
> =20
>  	struct scsi_cmnd *pcmd =3D ccb->pcmd;
>  	struct SENSE_DATA *sensebuffer =3D (struct SENSE_DATA *)pcmd->sense=
_buffer;
> -	pcmd->result =3D DID_OK << 16;
> -	if (sensebuffer) {
> -		int sense_data_length =3D
> +
> +	pcmd->result =3D (DRIVER_SENSE << 24) | (DID_OK << 16) | (CHECK_CON=
DITION << 1);
> +	int sense_data_length =3D
>  			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
>  			? sizeof(struct SENSE_DATA) : SCSI_SENSE_BUFFERSIZE;
> -		memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);
> -		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
> -		sensebuffer->ErrorCode =3D SCSI_SENSE_CURRENT_ERRORS;
> -		sensebuffer->Valid =3D 1;
> -	}
> +	memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);
> +	memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
> +	sensebuffer->ErrorCode =3D SCSI_SENSE_CURRENT_ERRORS;
> +	sensebuffer->Valid =3D 1;
>  }
> =20
>  static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *=
acb)
>=20
>=20
Hmm. Sorry to be picky, but:

Is there a chance the _no_ sense data will be provided?
If so we'd end up starting the error handler, calling REQUEST SENSE
(which will fail, too), and finally offlining the device.
I'd rather provide a default sense code for these cases.

Plus please use SAM_STAT_CHECK_CONDITION instead of
CHECK_CONDITION << 1.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 21284 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
