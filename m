From: zhangfei <zhangfei.gao@linaro.org>
Subject: Re: [PATCH 1/8] hisi_sas: add internal abort core code
Date: Sun, 21 Aug 2016 08:44:33 +0800
Message-ID: <7a5a91f3-51bc-52ff-ded4-418133a67b4b@linaro.org>
References: <1470835205-65684-1-git-send-email-john.garry@huawei.com>
 <1470835205-65684-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470835205-65684-2-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 2016年08月10日 21:19, John Garry wrote:
> Add core code for internal abort functionality.
>
> The internal abort features allows the host controller
> to abort commands which are still active in the
> controller but have not yet been sent to the slave
> device.
>
> Typically a command only spends a relatively
> short time in the controller when compared to the
> amount of the time after it is sent to the slave
> device.
> Two modes of internal abort are supported:
> - device
> - individual command
>
> For device, when the internal abort is issued all
> commands in the host for that device are aborted.
> For a single command, only that command is aborted
> if it is still in the host.
>
> In HW the internal abort command is executed
> similar to any other sort of command, like SSP.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   drivers/scsi/hisi_sas/hisi_sas.h      |   3 +
>   drivers/scsi/hisi_sas/hisi_sas_main.c | 154 ++++++++++++++++++++++++++++++++++
>   2 files changed, 157 insertions(+)
>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
> index 4731d32..4ae864d 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas.h
> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
> @@ -146,6 +146,9 @@ struct hisi_sas_hw {
>   			struct hisi_sas_slot *slot);
>   	int (*prep_stp)(struct hisi_hba *hisi_hba,
>   			struct hisi_sas_slot *slot);
> +	int (*prep_abort)(struct hisi_hba *hisi_hba,
> +			  struct hisi_sas_slot *slot,
> +			  int device_id, int abort_flag, int tag_to_abort);

How about add comments to abort_flag and tag_to_abort.
As a result, not sure why differently calling in hisi_sas_abort_task
hisi_sas_internal_task_abort(hisi_hba, device, 1, tag);
hisi_sas_internal_task_abort(hisi_hba, device, 0, tag);

Thanks
