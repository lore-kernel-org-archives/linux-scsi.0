From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 1/3] hpsa: use correct DID_NO_CONNECT hostbyte
Date: Tue, 29 Nov 2016 02:02:47 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D193B0CCCFD@avsrvexchmbx1.microsemi.net>
References: <1479454369-100281-1-git-send-email-hare@suse.de>
 <1479454369-100281-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0063.outbound.protection.outlook.com ([104.47.41.63]:20768
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755132AbcK2CDQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Nov 2016 21:03:16 -0500
In-Reply-To: <1479454369-100281-2-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Martin Wilck <martin.wilck@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, November 18, 2016 1:33 AM
> To: Martin K. Petersen
> Cc: Christoph Hellwig; James Bottomley; Don Brace; Martin Wilck; linux-
> scsi@vger.kernel.org; Hannes Reinecke; Hannes Reinecke
> Subject: [PATCH 1/3] hpsa: use correct DID_NO_CONNECT hostbyte
>=20
> EXTERNAL EMAIL
>=20
>=20
> NOT_READY is a sense key, not a legit scsi hostbyte value.
> Use DID_NO_CONNECT instead.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/hpsa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index ea64c01..488e17c 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -5493,7 +5493,7 @@ static int hpsa_scsi_queue_command(struct
> Scsi_Host *sh, struct scsi_cmnd *cmd)
>=20
>         dev =3D cmd->device->hostdata;
>         if (!dev) {
> -               cmd->result =3D NOT_READY << 16; /* host byte */
> +               cmd->result =3D DID_NO_CONNECT << 16;
>                 cmd->scsi_done(cmd);
>                 return 0;
>         }
> --
> 1.8.5.6

Acked-by: Don Brace <don.brace@microsemi.com>
