From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 7/8] hisi_sas: add TMF success check
Date: Wed, 24 Aug 2016 15:00:38 +0200
Message-ID: <b2433a28-b208-f396-6630-cc7d2f52fdde@suse.de>
References: <1472036754-156813-1-git-send-email-john.garry@huawei.com>
 <1472036754-156813-8-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472036754-156813-8-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/24/2016 01:05 PM, John Garry wrote:
> When a tmf is issued, various response codes can be
> returned from the target. For a query tmf the
> response may be TMF_RESP_FUNC_COMPLETE or
> TMF_RESP_FUNC_SUCC.
> Add a condition for TMF_RESP_FUNC_SUCC to
> hisi_sas_exec_internal_tmf_task().
> This affects query tmf, as the result is success
> the returned value was for failure.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index 73f581f..85c73d3 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -744,6 +744,12 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
>  		}
>  
>  		if (task->task_status.resp == SAS_TASK_COMPLETE &&
> +			task->task_status.stat == TMF_RESP_FUNC_SUCC) {
> +			res = TMF_RESP_FUNC_SUCC;
> +			break;
> +		}
> +
> +		if (task->task_status.resp == SAS_TASK_COMPLETE &&
>  		      task->task_status.stat == SAS_DATA_UNDERRUN) {
>  			/* no error, but return the number of bytes of
>  			 * underrun
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
