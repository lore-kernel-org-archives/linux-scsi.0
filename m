From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
Date: Mon, 15 May 2017 22:48:13 +0000
Message-ID: <MWHPR03MB3136FC54E76FBFD54A178159CEE10@MWHPR03MB3136.namprd03.prod.outlook.com>
References: <1494450443-2921-1-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1494450443-2921-1-git-send-email-longli@exchange.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@microsoft.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: KY Srinivasan <kys@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Long Li [mailto:longli@exchange.microsoft.com]
> Sent: Wednesday, May 10, 2017 2:07 PM
> To: James E.J. Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: Long Li <longli@microsoft.com>
> Subject: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
>=20
> From: Long Li <longli@microsoft.com>
>=20
> Lower layer driver may not initialize private data before use. Zero them =
out
> to prevent use of stale data.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Can someone help review this patch?

> ---
>  drivers/scsi/scsi_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c index
> 19125d7..a821593 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1850,7 +1850,7 @@ static int scsi_mq_prep_fn(struct request *req)
>=20
>         /* zero out the cmd, except for the embedded scsi_request */
>         memset((char *)cmd + sizeof(cmd->req), 0,
> -               sizeof(*cmd) - sizeof(cmd->req));
> +               sizeof(*cmd) - sizeof(cmd->req) +
> + shost->hostt->cmd_size);
>=20
>         req->special =3D cmd;
>=20
> --
> 2.7.4
