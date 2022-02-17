Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9E3C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 17:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240241AbiBQRmS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 12:42:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241845AbiBQRmR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 12:42:17 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FBE6929A
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 09:42:03 -0800 (PST)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K02Df2byFz67ycL;
        Fri, 18 Feb 2022 01:41:06 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Feb 2022 18:42:01 +0100
Received: from [10.47.86.67] (10.47.86.67) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 17 Feb
 2022 17:42:00 +0000
Message-ID: <98e8fc1f-ef84-f4a4-076d-0424108b5fe1@huawei.com>
Date:   Thu, 17 Feb 2022 17:41:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v4 22/31] scsi: pm8001: Fix tag leaks on error
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
CC:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
 <20220217132956.484818-23-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220217132956.484818-23-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.86.67]
X-ClientProxiedBy: lhreml714-chm.china.huawei.com (10.201.108.65) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/02/2022 13:29, Damien Le Moal wrote:
> In pm8001_chip_set_dev_state_req(), pm8001_chip_fw_flash_update_req()
> and pm8001_chip_reg_dev_req() add missing calls to pm8001_tag_free() to
> free the allocated tag when pm8001_mpi_build_cmd() fails.
> 
> Similarly, in pm8001_exec_internal_task_abort(), if the chip
> ->task_abort method fails, the tag allocated for the abort request task
> must be freed. Add the missing call to pm8001_tag_free(). Also remove
> the useless ex_err label and use "break" instead of "goto" statements
> in the retry loop.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

This looks ok, but I think pm80xx_chip_phy_ctl_req() might be missed.

Apart from that and a nit, below:

Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/pm8001/pm8001_hwi.c |  9 +++++++++
>   drivers/scsi/pm8001/pm8001_sas.c | 33 +++++++++++++++++---------------
>   2 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index cc96e58454c8..431fc9160637 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -4458,6 +4458,9 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
>   		SAS_ADDR_SIZE);
>   	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
>   			sizeof(payload), 0);
> +	if (rc)
> +		pm8001_tag_free(pm8001_ha, tag);
> +
>   	return rc;
>   }
>   
> @@ -4870,6 +4873,9 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
>   	ccb->ccb_tag = tag;
>   	rc = pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
>   		tag);
> +	if (rc)
> +		pm8001_tag_free(pm8001_ha, tag);
> +
>   	return rc;
>   }
>   
> @@ -4974,6 +4980,9 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_info *pm8001_ha,
>   	payload.nds = cpu_to_le32(state);
>   	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
>   			sizeof(payload), 0);
> +	if (rc)
> +		pm8001_tag_free(pm8001_ha, tag);
> +
>   	return rc;
>   
>   }
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index d0f5feb4f2d3..0440777a9135 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -834,7 +834,8 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
>   
>   		res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
>   		if (res)
> -			goto ex_err;
> +			break;
> +
>   		ccb = &pm8001_ha->ccb_info[ccb_tag];
>   		ccb->device = pm8001_dev;
>   		ccb->ccb_tag = ccb_tag;
> @@ -843,36 +844,38 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
>   
>   		res = PM8001_CHIP_DISP->task_abort(pm8001_ha,
>   			pm8001_dev, flag, task_tag, ccb_tag);
> -
>   		if (res) {
>   			del_timer(&task->slow_task->timer);
> -			pm8001_dbg(pm8001_ha, FAIL, "Executing internal task failed\n");
> -			goto ex_err;
> +			pm8001_dbg(pm8001_ha, FAIL,
> +				   "Executing internal task failed\n");
> +			pm8001_tag_free(pm8001_ha, ccb_tag);
> +			break;
>   		}
> +
>   		wait_for_completion(&task->slow_task->completion);
>   		res = TMF_RESP_FUNC_FAILED;
> +
>   		/* Even TMF timed out, return direct. */
>   		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
>   			pm8001_dbg(pm8001_ha, FAIL, "TMF task timeout.\n");
> -			goto ex_err;
> +			break;
>   		}

nit: these are really separate changes, but this series is so long 
already :)

>   
>   		if (task->task_status.resp == SAS_TASK_COMPLETE &&
>   			task->task_status.stat == SAS_SAM_STAT_GOOD) {
>   			res = TMF_RESP_FUNC_COMPLETE;
>   			break;
> -
> -		} else {
> -			pm8001_dbg(pm8001_ha, EH,
> -				   " Task to dev %016llx response: 0x%x status 0x%x\n",
> -				   SAS_ADDR(dev->sas_addr),
> -				   task->task_status.resp,
> -				   task->task_status.stat);
> -			sas_free_task(task);
> -			task = NULL;
>   		}
> +
> +		pm8001_dbg(pm8001_ha, EH,
> +			   " Task to dev %016llx response: 0x%x status 0x%x\n",
> +			   SAS_ADDR(dev->sas_addr),
> +			   task->task_status.resp,
> +			   task->task_status.stat);
> +		sas_free_task(task);
> +		task = NULL;
>   	}
> -ex_err:
> +
>   	BUG_ON(retry == 3 && task != NULL);
>   	sas_free_task(task);
>   	return res;

