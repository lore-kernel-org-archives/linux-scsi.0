From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [Possible Phish Fraud][PATCH] scsi: zero per-cmd driver data for
 each MQ I/O
Date: Mon, 15 May 2017 23:02:56 +0000
Message-ID: <1494889376.2567.8.camel@sandisk.com>
References: <1494450443-2921-1-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1494450443-2921-1-git-send-email-longli@exchange.microsoft.com>
Content-Language: en-US
Content-ID: <2E207506188CB24D8C60A378765D2749@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "longli@exchange.microsoft.com" <longli@exchange.microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "longli@microsoft.com" <longli@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-05-10 at 14:07 -0700, Long Li wrote:
> From: Long Li <longli@microsoft.com>
>=20
> Lower layer driver may not initialize private data before use. Zero them
> out to prevent use of stale data.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  drivers/scsi/scsi_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 19125d7..a821593 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1850,7 +1850,7 @@ static int scsi_mq_prep_fn(struct request *req)
> =20
>  	/* zero out the cmd, except for the embedded scsi_request */
>  	memset((char *)cmd + sizeof(cmd->req), 0,
> -		sizeof(*cmd) - sizeof(cmd->req));
> +		sizeof(*cmd) - sizeof(cmd->req) + shost->hostt->cmd_size);
> =20
>  	req->special =3D cmd;

Hello Long,

Sorry but this patch looks wrong to me. Since scsi_mq_prep_fn() is called
after scsi_req_init(), erasing struct scsi_request from scsi_mq_prep_fn()
will erase the values that were set by scsi_req_init(). That includes
information like the pointer to the SCSI CDB and the CDB itself. See e.g.
scsi_execute().

Did you come up with this patch after source reading or did you come up
with this patch while chasing a bug?

Thanks,

Bart.=20
