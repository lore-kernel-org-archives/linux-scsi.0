Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93217C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 22:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343951AbiBQWm0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 17:42:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343899AbiBQWmX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 17:42:23 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EE91704C
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 14:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645137727; x=1676673727;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=z1tyak9oVvGOc24fc+pyjK5WhzCfOngKzZ7v481vWlk=;
  b=B15ZDtLo68Lby7jdNvqW5s3gsL+G+DIfALU7gfBxrh1GKJQNtKJU4bSG
   64gehHPyn6CI3+4IgI/VH48vfadzerwA1/ghmMXUZdpf0ZCNtDF9IiNzP
   ZLSKdDqktCfpbTWlXu6W/Vrz1VO8RCsf4rZclmgGEmKAQvdyj25m4nLzv
   Js6rswSykKU5ftmca8B2cX5kZSGs0w7w/53fxi247q/svYbYLo74QeCTr
   v8vKfVYSOTpz+Q7IhZlzqh9Sxu/hLgosaTBtCf+ljq2Oo/yWV093G8k4P
   4K9xcCjjx1eDHFKHgqNsN/+fJLMFipKKJLsRxr8zFLKACldLkdgruyIIP
   g==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="297343023"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 06:42:07 +0800
IronPort-SDR: ajN14TiH1gq08W3GW9K+4oBfi1qYAiJABpbedUJfaGzmL3sYmvF4/h+kFdSUsln3xQvJ6u7m7m
 pfdOiRUWCurZR++s5KapgRx+bRChAY4aOBf3jMVm/rZqifscE1LR6LLXqPhiYQ5Z4SxzUVhKaZ
 5n/ypLP9bdn7ahil98G5F7dwQywfOMdyuNLOeMgPUiJM1mClNM36pE4towjk5c9l22aBHVRMZM
 4MAW1w4uL1/TsN1YHrjJxMN8g+G8xB4nwZO4YX5NzuzYNGrw2qIkVS7EvRWY5SkI7TYHVFRlNJ
 vRVuad2BZJ54fAA/ERZD57cq
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 14:14:53 -0800
IronPort-SDR: fD6e9/wD2eRgj8grkMgzoF+yBFeQgw0L81CfT0Y87wT/Q0lhQZ35y78CrvXGdMt1rSpGfSHZU8
 aA5NJHNJ2m/D6k7Gn8Ylb6kZNBjD7f6ARVu5Xt8s6ei/+9fKRebAeMiZZqGNt9WebGzdUX1NFw
 ESXfWVJtwG2bARncQyKCWhqGzqrDTVB2QeC3FpAihgLIVyccg2r8vmxntLRZ6aD2Ca8NRoOiKo
 3QRsNFq5QUA4xnSIkVE6xURpat/lf9QJyT6D+iIZva5VgRWnRKUDslJufnTBgmV/r8D2oL2Naf
 Qks=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 14:42:08 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K08vz1BfLz1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 14:42:07 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645137726; x=1647729727; bh=z1tyak9oVvGOc24fc+pyjK5WhzCfOngKzZ7
        v481vWlk=; b=FAQVa8UUf4XjNMfPbgWcDfP/PNvJQhkrktFIhFW+SDEa+vKepgI
        Zh90iCAvWx5s6dDq99FaQo3RQM6Xt5lUxBi0Tap7QN446CZp8sbUrLOBpzM8lSVF
        3YZvdHFG1gyyQcf/FPe+2JXSAhVFhr77/5JXHsAZAcJYqJHLuTwbKY/EwSrH75Hc
        N8DsG8BkNyV4i4Er12rFr47b66Gcp0jWqk3OnJYjBwaeQxAXyBG+j85/isXE0w6C
        k7Tu1tmNG/kArCCKOZeZALJVqbAL6cMvrvoshPhaGLReKwHtkJhsOEWxDCs0/ImL
        L/12wSAlYzLaR8vSOiN9eRoWSBmh68Jmy9g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id PpGLQYR_NJtM for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 14:42:06 -0800 (PST)
Received: from [10.225.163.78] (unknown [10.225.163.78])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K08vw6xnXz1Rwrw;
        Thu, 17 Feb 2022 14:42:04 -0800 (PST)
Message-ID: <0224d503-729e-078a-45f3-a7db6e22060c@opensource.wdc.com>
Date:   Fri, 18 Feb 2022 07:42:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 22/31] scsi: pm8001: Fix tag leaks on error
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
 <20220217132956.484818-23-damien.lemoal@opensource.wdc.com>
 <98e8fc1f-ef84-f4a4-076d-0424108b5fe1@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <98e8fc1f-ef84-f4a4-076d-0424108b5fe1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/18/22 02:41, John Garry wrote:
> On 17/02/2022 13:29, Damien Le Moal wrote:
>> In pm8001_chip_set_dev_state_req(), pm8001_chip_fw_flash_update_req()
>> and pm8001_chip_reg_dev_req() add missing calls to pm8001_tag_free() to
>> free the allocated tag when pm8001_mpi_build_cmd() fails.
>>
>> Similarly, in pm8001_exec_internal_task_abort(), if the chip
>> ->task_abort method fails, the tag allocated for the abort request task
>> must be freed. Add the missing call to pm8001_tag_free(). Also remove
>> the useless ex_err label and use "break" instead of "goto" statements
>> in the retry loop.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> This looks ok, but I think pm80xx_chip_phy_ctl_req() might be missed.

It is fixed separately in patch 18. I should have squashed it into this
one. forgot :)

> 
> Apart from that and a nit, below:
> 
> Reviewed-by: John Garry <john.garry@huawei.com>
> 
>> ---
>>   drivers/scsi/pm8001/pm8001_hwi.c |  9 +++++++++
>>   drivers/scsi/pm8001/pm8001_sas.c | 33 +++++++++++++++++---------------
>>   2 files changed, 27 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
>> index cc96e58454c8..431fc9160637 100644
>> --- a/drivers/scsi/pm8001/pm8001_hwi.c
>> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
>> @@ -4458,6 +4458,9 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
>>   		SAS_ADDR_SIZE);
>>   	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
>>   			sizeof(payload), 0);
>> +	if (rc)
>> +		pm8001_tag_free(pm8001_ha, tag);
>> +
>>   	return rc;
>>   }
>>   
>> @@ -4870,6 +4873,9 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
>>   	ccb->ccb_tag = tag;
>>   	rc = pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
>>   		tag);
>> +	if (rc)
>> +		pm8001_tag_free(pm8001_ha, tag);
>> +
>>   	return rc;
>>   }
>>   
>> @@ -4974,6 +4980,9 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_info *pm8001_ha,
>>   	payload.nds = cpu_to_le32(state);
>>   	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
>>   			sizeof(payload), 0);
>> +	if (rc)
>> +		pm8001_tag_free(pm8001_ha, tag);
>> +
>>   	return rc;
>>   
>>   }
>> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
>> index d0f5feb4f2d3..0440777a9135 100644
>> --- a/drivers/scsi/pm8001/pm8001_sas.c
>> +++ b/drivers/scsi/pm8001/pm8001_sas.c
>> @@ -834,7 +834,8 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
>>   
>>   		res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
>>   		if (res)
>> -			goto ex_err;
>> +			break;
>> +
>>   		ccb = &pm8001_ha->ccb_info[ccb_tag];
>>   		ccb->device = pm8001_dev;
>>   		ccb->ccb_tag = ccb_tag;
>> @@ -843,36 +844,38 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
>>   
>>   		res = PM8001_CHIP_DISP->task_abort(pm8001_ha,
>>   			pm8001_dev, flag, task_tag, ccb_tag);
>> -
>>   		if (res) {
>>   			del_timer(&task->slow_task->timer);
>> -			pm8001_dbg(pm8001_ha, FAIL, "Executing internal task failed\n");
>> -			goto ex_err;
>> +			pm8001_dbg(pm8001_ha, FAIL,
>> +				   "Executing internal task failed\n");
>> +			pm8001_tag_free(pm8001_ha, ccb_tag);
>> +			break;
>>   		}
>> +
>>   		wait_for_completion(&task->slow_task->completion);
>>   		res = TMF_RESP_FUNC_FAILED;
>> +
>>   		/* Even TMF timed out, return direct. */
>>   		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
>>   			pm8001_dbg(pm8001_ha, FAIL, "TMF task timeout.\n");
>> -			goto ex_err;
>> +			break;
>>   		}
> 
> nit: these are really separate changes, but this series is so long 
> already :)
> 
>>   
>>   		if (task->task_status.resp == SAS_TASK_COMPLETE &&
>>   			task->task_status.stat == SAS_SAM_STAT_GOOD) {
>>   			res = TMF_RESP_FUNC_COMPLETE;
>>   			break;
>> -
>> -		} else {
>> -			pm8001_dbg(pm8001_ha, EH,
>> -				   " Task to dev %016llx response: 0x%x status 0x%x\n",
>> -				   SAS_ADDR(dev->sas_addr),
>> -				   task->task_status.resp,
>> -				   task->task_status.stat);
>> -			sas_free_task(task);
>> -			task = NULL;
>>   		}
>> +
>> +		pm8001_dbg(pm8001_ha, EH,
>> +			   " Task to dev %016llx response: 0x%x status 0x%x\n",
>> +			   SAS_ADDR(dev->sas_addr),
>> +			   task->task_status.resp,
>> +			   task->task_status.stat);
>> +		sas_free_task(task);
>> +		task = NULL;
>>   	}
>> -ex_err:
>> +
>>   	BUG_ON(retry == 3 && task != NULL);
>>   	sas_free_task(task);
>>   	return res;
> 


-- 
Damien Le Moal
Western Digital Research
