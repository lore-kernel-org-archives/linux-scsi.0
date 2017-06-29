From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 06/47] aacraid: add fib flag to mark scsi command
 callback
Date: Thu, 29 Jun 2017 20:07:26 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A81C2CCA9@avsrvexchmbx2.microsemi.net>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0089.outbound.protection.outlook.com ([104.47.37.89]:17536
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753161AbdF2UHi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jun 2017 16:07:38 -0400
In-Reply-To: <1498638793-44672-7-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Wednesday, June 28, 2017 1:33 AM
> To: Christoph Hellwig <hch@lst.de>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>; James Bottomley
> <james.bottomley@hansenpartnership.com>; linux-scsi@vger.kernel.org;
> Hannes Reinecke <hare@suse.de>; Hannes Reinecke <hare@suse.com>
> Subject: [PATCH 06/47] aacraid: add fib flag to mark scsi command callbac=
k
>=20
> EXTERNAL EMAIL
>=20
>=20
> To correctly identify which fib has a scsi command callback this
> patch implements a flag FIB_CONTEXT_FLAG_SCSI_CMD.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/aacraid/aacraid.h | 1 +
>  drivers/scsi/aacraid/commsup.c | 1 +
>  2 files changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacrai=
d.h
> index d31a9bc..6981299 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1723,6 +1723,7 @@ struct aac_dev
>  #define FIB_CONTEXT_FLAG_FASTRESP              (0x00000008)
>  #define FIB_CONTEXT_FLAG_NATIVE_HBA            (0x00000010)
>  #define FIB_CONTEXT_FLAG_NATIVE_HBA_TMF        (0x00000020)
> +#define FIB_CONTEXT_FLAG_SCSI_CMD      (0x00000040)
>=20
>  /*
>   *     Define the command values
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsu=
p.c
> index 348f0ea..dfe8e70 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -770,6 +770,7 @@ int aac_hba_send(u8 command, struct fib *fibptr,
> fib_callback callback,
>                 /* bit1 of request_id must be 0 */
>                 hbacmd->request_id =3D
>                         cpu_to_le32((((u32)(fibptr - dev->fibs)) << 2) + =
1);
> +               fibptr->flags |=3D FIB_CONTEXT_FLAG_SCSI_CMD;
>         } else if (command !=3D HBA_IU_TYPE_SCSI_TM_REQ)
>                 return -EINVAL;
>=20
> --
> 1.8.5.6

Reviewed-by: Raghava Aditya Renukunta  <RaghavaAditya.Renukunta@microsemi.c=
om>
