From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2] scsi: zero per-cmd driver data before each I/O
Date: Tue, 21 Feb 2017 15:33:29 +0000
Message-ID: <1D08B61A9CF0974AA09887BE32D889DA0AB2E1@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
References: <20170221090455.4633-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "decui@microsoft.com" <decui@microsoft.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/21/2017 01:29 AM, Christoph Hellwig wrote:=0A=
> Without this drivers that don't clear the state themselves can see off=0A=
> effects.  For example Hyper-V VMs using the storvsc driver will often=0A=
> hang during boot due to uncleared Test Unit Ready failures.=0A=
> =0A=
> Fixes: e9c787e6 ("scsi: allocate scsi_cmnd structures as part of struct r=
equest")=0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> Reported-by: Dexuan Cui <decui@microsoft.com>=0A=
> Tested-by: Dexuan Cui <decui@microsoft.com>=0A=
> ---=0A=
> =0A=
> Changes since V1:=0A=
>  - use a single memset as suggested by Bart=0A=
> =0A=
>  drivers/scsi/scsi_lib.c | 2 +-=0A=
>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c=0A=
> index 90f65c8f487a..1d87a809944d 100644=0A=
> --- a/drivers/scsi/scsi_lib.c=0A=
> +++ b/drivers/scsi/scsi_lib.c=0A=
> @@ -1166,7 +1166,7 @@ void scsi_init_command(struct scsi_device *dev, str=
uct scsi_cmnd *cmd)=0A=
>  =0A=
>  	/* zero out the cmd, except for the embedded scsi_request */=0A=
>  	memset((char *)cmd + sizeof(cmd->req), 0,=0A=
> -		sizeof(*cmd) - sizeof(cmd->req));=0A=
> +		sizeof(*cmd) - sizeof(cmd->req) + dev->host->hostt->cmd_size);=0A=
>  =0A=
>  	cmd->device =3D dev;=0A=
>  	cmd->sense_buffer =3D buf;=0A=
=0A=
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=0A=
=0A=
=0A=
