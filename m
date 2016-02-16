From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/6] hisi_sas: add TMF_RESP_FUNC_SUCC check
Date: Tue, 16 Feb 2016 16:20:13 +0100
Message-ID: <56C33E2D.1060402@suse.de>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
 <1455625351-165881-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455625351-165881-2-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/16/2016 01:22 PM, John Garry wrote:
> When a tmf is issued, various response codes can be
> returned from the target. For a query tmf the
> response may be TMF_RESP_FUNC_COMPLETE or
> TMF_RESP_FUNC_SUCC.
> Add a condition for TMF_RESP_FUNC_SUCC.
> Also, check for SAM_STAT_GOOD is replaced with
> TMF_RESP_FUNC_COMPLETE, which is a genuine tmf
> response code. SAM_STAT_GOOD and
> TMF_RESP_FUNC_COMPLETE have the same value, so
> this is why it worked before.
>=20
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/his=
i_sas/hisi_sas_main.c
> index 2194917..c600f5e 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -661,12 +661,18 @@ static int hisi_sas_exec_internal_tmf_task(stru=
ct domain_device *device,
>  		}
> =20
>  		if (task->task_status.resp =3D=3D SAS_TASK_COMPLETE &&
> -		    task->task_status.stat =3D=3D SAM_STAT_GOOD) {
> +		     task->task_status.stat =3D=3D TMF_RESP_FUNC_COMPLETE) {
>  			res =3D TMF_RESP_FUNC_COMPLETE;
>  			break;
>  		}
> =20
>  		if (task->task_status.resp =3D=3D SAS_TASK_COMPLETE &&
> +		    task->task_status.stat =3D=3D TMF_RESP_FUNC_SUCC) {
> +			res =3D TMF_RESP_FUNC_SUCC;
> +			break;
> +		}
> +
> +		if (task->task_status.resp =3D=3D SAS_TASK_COMPLETE &&
>  		      task->task_status.stat =3D=3D SAS_DATA_UNDERRUN) {
>  			/* no error, but return the number of bytes of
>  			 * underrun
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
