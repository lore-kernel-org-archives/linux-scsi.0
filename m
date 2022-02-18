Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12960C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 02:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiBRCIp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 21:08:45 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiBRCIn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 21:08:43 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E2510DC
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 18:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645150106; x=1676686106;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OLxrZjuW8Qhnm3ktwlDLFitbMj4RJtOfmIPNg5Mcjy0=;
  b=dYcO6eUT7Jr9IB1Mn7xOI9ZU07pF7hd9AWptSWXS7PjxjlRlCNqLX0/N
   vUVKTqxWRkJeLeM1EkNjGIFELwQNz0cwQnNWe8rLioa8UxDftPNOaLwG2
   f+cTYmKNx543gICaGZ1aY/iSoOUsKB7CF71uKtslCIujziY01IndBUqS2
   nKukUAuJxqnSb6lYRFiLOMQUuKheatVWnWnd3UgNUu/4nXZHgrGDXMsOw
   4v3Tj59OiP3R8xqKxe2zvvCMnohWhpcX+vd3j5floR4U6fmRAhfyIBLtj
   Aghnv90tnTVBqZ0htmKkJcK88eItWNPjqKIoKq3x7oyBhLHtfNgOYWug4
   A==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="297358071"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 10:08:25 +0800
IronPort-SDR: s/oGO8TMBkJ7An/OsAF7qoRVBpYad6P9UlWzt7lboBztyqcXuT8NYX3hs5S5RWD4Jfx7FAHu5y
 p30UwR0r36/dx+iU1QmNMpcTCKBKywuFVSdsf6kR+fhk3XJpx8RWonvSUvis3axbaoAZypo0fA
 v6bcoEZDmDrqwIgfUT7JEr4KrSGzGQauk6MVPmupHyFlgxQ7HnuoQhLWtOpJGHCUHRz7SKG3wu
 Bl4kbdQboz74NFqJCrKTr9eJ7B3sCTF0YCIpwQhs4Ig1gHpN5D14oAVYkzVy7ih/6ap/leIa77
 6q7fOPIirKYQ+a0/JOYpREad
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 17:41:10 -0800
IronPort-SDR: Q98PpxWAmI2a8tkWv3Uq0+DEg0vqNeo+aI2oTJgrbgsnGGXLm7y5E7EyptOt8TZxaYICcIVEQf
 Inwx6Ascz5wq5T14QNbiduoyxTZEJr2QaFZBAxqll+FNLiSHINQzhOCR4LkTnzetRu4p3CRkEx
 t3R6It+i/yXIsCR4LlqnuTeWahjDoLtCfVPQssqPyk1T9n9Ny3JrlEmhSOjH8euYiaW+CyXl3h
 Mfi+DcIw5PE1dBt6onPp+LKvOjluxD/ASt7yytwCu4pMYQDfyTEXUCS/0rQlv5ddiSnaRsYJ7R
 WDA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:08:25 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0FV10HJxz1SVnx
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 18:08:25 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645150104; x=1647742105; bh=OLxrZjuW8Qhnm3ktwlDLFitbMj4RJtOfmIP
        Ng5Mcjy0=; b=W4idj1kpPZfxkhPQkoDheHww/uF4mryDZfOaC2czfsxeNRhV62k
        YOqHK+yr8k5bDXjSN3nZ8HlWdgbuMyWVnu7N4s/FoSc1O7ay2r7JSnE7CA/aPmU0
        tu1w8CraA/4rS6qWoDN6f/y5QXF/lWeNPJ35/ivZva0JMn9n6NU2aIiDa4OEozTQ
        f+lxEJluAFPZaZNeOo1nnpFwx27KJPuy2OeVtx4Sd0fP2bNupgRNLNLrUC15z3ot
        QRUrb3EpiNszpY2QXcuesnkPSNnIl1rLpw7LmQ40I9RY+gFMsWMr+OGeIXwoTgFg
        wNayRl34sXh+DxzFiUXeYSGicGfvlDlG/0Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Qs1NrvSCMSDs for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 18:08:24 -0800 (PST)
Received: from [10.225.163.78] (unknown [10.225.163.78])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0FTz0cCLz1Rwrw;
        Thu, 17 Feb 2022 18:08:22 -0800 (PST)
Message-ID: <69107c01-7189-0734-ca8f-bde4c3005c88@opensource.wdc.com>
Date:   Fri, 18 Feb 2022 11:08:21 +0900
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
> 
> Apart from that and a nit, below:

[...]

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

As it is better to have fixes and cleanups separated, I moved these
style changes to another patch and squashed the
pm80xx_chip_phy_ctl_req() tag leak patch into this one. So patch count
remains the same.

Sending v5. All but 2 patches are reviewed now.

Thanks !

-- 
Damien Le Moal
Western Digital Research
