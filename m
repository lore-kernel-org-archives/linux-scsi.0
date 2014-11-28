From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] arcmsr: Notify has sense data report
Date: Fri, 28 Nov 2014 09:57:15 +0100
Message-ID: <547838EB.1000506@suse.de>
References: <1417148444.16588.56.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417148444.16588.56.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/28/2014 05:20 AM, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>=20
> This patch is relative to http://git.infradead.org/users/hch/scsi-que=
ue.git/tree/refs/heads/drivers-for-3.18:/drivers/scsi/arcmsr
>=20
> Setting command status with 'DRIVER_SENSE' except 'CHECK_CONDITION' i=
f we have sense data.
>=20
> Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> ---
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
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-11-28 10:55:54.000000000 =
+0800
> @@ -989,7 +989,8 @@ static void arcmsr_report_sense_info(str
> =20
>  	struct scsi_cmnd *pcmd =3D ccb->pcmd;
>  	struct SENSE_DATA *sensebuffer =3D (struct SENSE_DATA *)pcmd->sense=
_buffer;
> -	pcmd->result =3D DID_OK << 16;
> +
> +	pcmd->result =3D (DID_OK << 16) | (CHECK_CONDITION << 1);
>  	if (sensebuffer) {
>  		int sense_data_length =3D
>  			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
> @@ -998,6 +999,7 @@ static void arcmsr_report_sense_info(str
>  		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
>  		sensebuffer->ErrorCode =3D SCSI_SENSE_CURRENT_ERRORS;
>  		sensebuffer->Valid =3D 1;
> +		pcmd->result |=3D (DRIVER_SENSE << 24);
>  	}
>  }
>=20
Hmm; we actually _always_ attach a sense buffer to the command.
So the check for 'if (sensebuffer)' will always return true.

I'd rather use a 'WARN_ON' here and get rid of the 'if' clause.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 21284 (AG N=C3=BCrnberg=
)
