Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B993C43219
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 23:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344742AbiA0XJQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 18:09:16 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:8172 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343934AbiA0XIz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2022 18:08:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643324935; x=1674860935;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sIQFZUU2YtYKz8AVEUJwYWDyx6QIOXw3eZJaDURUMqM=;
  b=F5JrP9ebaJQciCawm6BbEgxvdSv/PfTsbecx9zmAPtGoLfDEv+zAr5zU
   SGXU1SQljrKvwWKbvjQPREAugHdC/aDkE9MikLQr3Yz1E8UqRUGO5HX/T
   N1Yd0X3USNUBtwMLWSpFSx5cTHHQLIcMwvlSPGwCqZgLPk+SFbmp3iLiH
   whGMo1IJHyDGkF1hSaBaxucY+7Ujg3iHDhOxOaijjmsHqHaVDifIerCda
   bYQYZeinla5O46PbCrw6qHwwAOwk1RFSLSZPYX5rFwk3UMWef0fgjUsNO
   PGF7nzPSZfqElqp+aSte1wFv1cYZ8HjhjgYhGjCFShGAD92jSg8ft0JR1
   g==;
X-IronPort-AV: E=Sophos;i="5.88,321,1635177600"; 
   d="scan'208";a="303450890"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2022 07:08:50 +0800
IronPort-SDR: wnrWJr5qpQyn0DzE5B+Nm4kUSJWB83jPQM5iLnvPXoOw0bUAApaN4RFWNSnxq0tmMVHn9ae5d4
 u+/BiQFn09ZnrJ5RsxTkWIDw1dH5Zf9pUfsJeqqHmv1IAXzLEMLm7qRCdfrgiVB/y0f5QKnssO
 Dz/rr9IihpqQOPq9K3YPHSs5ka4TaXZQvCC1PZ17MCWq6lTFu4nNAv3Xfy6RMlCAb0uo7wd3vh
 xiNo137O+s6BLYrXRxwS2S5QXPXixOpjNHYAhz+2gZAeg7K/KZjEIpGuEIkHcDpqWB0jX5oS27
 pgPS1zbal4lXcle7DzKZGBsf
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 14:40:53 -0800
IronPort-SDR: PWZkFPe+jazd9eIzF6CY1XgcZRet/N8i5GpMtz8DF/5VJFXwoGBeuojpydyCBECtrGrySRTtsA
 8AOzaDRjla1Vgbo92oSojP3eDdX/Lf6OZCY7zr1DneDPdO331VY5Ypt8pn55ScPXwtJtX28wu5
 KZh9P7oPk+LBLa/p5aAw/ueueMaT1sUYtrJqVUg5UjY1xSlbfTZSM80lOX6MDk/UaoSeyrtBxH
 9gyzXZVhs4sYNqJmGpLgR7zWGimbVBwg/n7Mb6wRjmghGWtJvI8sresgloRMZRyB/yek0f2NoA
 5lI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 15:08:50 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JlGVT3WPRz1SVp5
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 15:08:49 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643324928; x=1645916929; bh=sIQFZUU2YtYKz8AVEUJwYWDyx6QIOXw3eZJ
        aDURUMqM=; b=r/zy/W7ckZnVRMM3jvoBp/4D6npgXj3O/z+pF5uUJ7sAfz0vQcs
        V4HcSmvhSb6Oq7pGCysGglhogFn7qup6m9CJDfec6hC7zN3hHZ+HtMU29LbI9A5+
        q0gBAOFqXJg+KjdYXlUQZ8SFJsT/I1yR4yfkMnFPHvnYAjpl4WDG+icYBSShJxc8
        0i34GgHY/ieyCdDL1kJlCs0a1unP3tfXDy5g9QTmkU+B6jNJhSbdsO/+2pnTXjNw
        MPDBFgF2+Tj4XTMtrq5GugxKj1Y2a+th1mwRCckd3MxJDLWx/7+rPG56J3+oTW4k
        SsJ3pG+uWjlbvOgCbq3Evw1oY2v9w/Oj86Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id WtKbkw7Qp7-Z for <linux-scsi@vger.kernel.org>;
        Thu, 27 Jan 2022 15:08:48 -0800 (PST)
Received: from [10.225.163.58] (unknown [10.225.163.58])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JlGVR3tzfz1RvlN;
        Thu, 27 Jan 2022 15:08:47 -0800 (PST)
Message-ID: <ab547eb4-d97d-45e0-207a-8b660c6e96bd@opensource.wdc.com>
Date:   Fri, 28 Jan 2022 08:08:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 3/3] scsi: pm8001: Fix use-after-free for aborted SSP/STP
 sas_task
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Ajish.Koshy@microchip.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viswas.G@microchip.com, chenxiang66@hisilicon.com
References: <1643289172-165636-1-git-send-email-john.garry@huawei.com>
 <1643289172-165636-4-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1643289172-165636-4-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/22 22:12, John Garry wrote:
> Currently a use-after-free may occur if a sas_task is aborted by the upper
> layer before we handle the IO completion in mpi_ssp_completion() or
> mpi_sata_completion().
> 
> In this case, the following are the two steps in handling those IO
> completions:
> - call complete() to inform the upper layer handler of completion of
>   the IO
> - release driver resources associated with the sas_task in
>   pm8001_ccb_task_free() call
> 
> When complete() is called, the upper layer may free the sas_task. As such,
> we should not touch the associated sas_task afterwards, but we do so in
> the pm8001_ccb_task_free() call.
> 
> Fix by swapping the complete() and pm8001_ccb_task_free() calls ordering.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index ce38a2298e75..1134e86ac928 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -2185,9 +2185,9 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  		pm8001_dbg(pm8001_ha, FAIL,
>  			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
>  			   t, status, ts->resp, ts->stat);
> +		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>  		if (t->slow_task)
>  			complete(&t->slow_task->completion);
> -		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>  	} else {
>  		spin_unlock_irqrestore(&t->task_state_lock, flags);
>  		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> @@ -2794,9 +2794,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
>  		pm8001_dbg(pm8001_ha, FAIL,
>  			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
>  			   t, status, ts->resp, ts->stat);
> +		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>  		if (t->slow_task)
>  			complete(&t->slow_task->completion);
> -		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>  	} else {
>  		spin_unlock_irqrestore(&t->task_state_lock, flags);
>  		spin_unlock_irqrestore(&circularQ->oq_lock,

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
