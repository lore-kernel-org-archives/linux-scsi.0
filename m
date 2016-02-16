From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/6] hisi_sas: use slot abort in v1 hw
Date: Tue, 16 Feb 2016 16:31:53 +0100
Message-ID: <56C340E9.1030503@suse.de>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
 <1455625351-165881-4-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbcBPPbz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2016 10:31:55 -0500
In-Reply-To: <1455625351-165881-4-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 02/16/2016 01:22 PM, John Garry wrote:
> When TRANS_TX_CREDIT_TIMEOUT_ERR or
> TRANS_TX_CLOSE_NORMAL_ERR errors occur for a
> command, the command should be re-attempted.
>=20
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hi=
si_sas/hisi_sas_v1_hw.c
> index ce5f65d..34f71a1c 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> @@ -1118,9 +1118,8 @@ static int prep_ssp_v1_hw(struct hisi_hba *hisi=
_hba,
>  }
> =20
>  /* by default, task resp is complete */
> -static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
> -			   struct sas_task *task,
> -			   struct hisi_sas_slot *slot)
> +static void slot_err_v1_hw(struct hisi_hba *hisi_hba, struct sas_tas=
k *task,
> +			   struct hisi_sas_slot *slot, int *abort_slot)
>  {
>  	struct task_status_struct *ts =3D &task->task_status;
>  	struct hisi_sas_err_record_v1 *err_record =3D slot->status_buffer;
> @@ -1212,6 +1211,14 @@ static void slot_err_v1_hw(struct hisi_hba *hi=
si_hba,
>  			ts->stat =3D SAS_NAK_R_ERR;
>  			break;
>  		}
> +		case TRANS_TX_CREDIT_TIMEOUT_ERR:
> +		case TRANS_TX_CLOSE_NORMAL_ERR:
> +		{
> +			/* This will request a retry */
> +			ts->stat =3D SAS_QUEUE_FULL;
> +			++(*abort_slot);
> +			break;
> +		}
>  		default:
>  		{
>  			ts->stat =3D SAM_STAT_CHECK_CONDITION;
> @@ -1317,8 +1324,14 @@ static int slot_complete_v1_hw(struct hisi_hba=
 *hisi_hba,
> =20
>  	if (cmplt_hdr_data & CMPLT_HDR_ERR_RCRD_XFRD_MSK &&
>  		!(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK)) {
> +		int abort_slot =3D 0;
> =20
> -		slot_err_v1_hw(hisi_hba, task, slot);
> +		slot_err_v1_hw(hisi_hba, task, slot,  &abort_slot);
> +		if (unlikely(abort_slot)) {
> +			queue_work(hisi_hba->wq, &slot->abort_slot);
> +			sts =3D ts->stat;
> +			goto out_1;
> +		}
>  		goto out;
>  	}
> =20
What is the 'abort_slot' variable for?
Currently it's just a counter, no?
So why the weird pointer passing?

And it does feel weird. Apparently the driver does get a message,
but still has to abort the command. Why?
Isn't the message an indicator that the command has been aborted?

Cheers,

Hannes

--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
