From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 05/47] aacraid: enable sending of TMFs from
 aac_hba_send()
Date: Thu, 29 Jun 2017 20:07:11 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A81C2CCA2@avsrvexchmbx2.microsemi.net>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0083.outbound.protection.outlook.com ([104.47.33.83]:30688
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752770AbdF2UHY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jun 2017 16:07:24 -0400
In-Reply-To: <1498638793-44672-6-git-send-email-hare@suse.de>
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
> Subject: [PATCH 05/47] aacraid: enable sending of TMFs from
> aac_hba_send()
>=20
> EXTERNAL EMAIL
>=20
>=20
> aac_hba_send() will return FAILED for any non-SCSI command requests,
> failing any TMFs. This patch updates the check to allow TMFs.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/aacraid/commsup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsu=
p.c
> index 1c617cc..348f0ea 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -770,7 +770,7 @@ int aac_hba_send(u8 command, struct fib *fibptr,
> fib_callback callback,
>                 /* bit1 of request_id must be 0 */
>                 hbacmd->request_id =3D
>                         cpu_to_le32((((u32)(fibptr - dev->fibs)) << 2) + =
1);
> -       } else
> +       } else if (command !=3D HBA_IU_TYPE_SCSI_TM_REQ)
>                 return -EINVAL;
>=20
>=20
> --
> 1.8.5.6

Reviewed-by: Raghava Aditya Renukunta  <RaghavaAditya.Renukunta@microsemi.c=
om>
