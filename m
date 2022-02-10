Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91035C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 12:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241393AbiBJMEi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 07:04:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241395AbiBJMEa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 07:04:30 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3D310D1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 04:04:30 -0800 (PST)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jvb5K6MjVz67M7f;
        Thu, 10 Feb 2022 20:04:21 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Thu, 10 Feb 2022 13:04:27 +0100
Received: from [10.47.24.182] (10.47.24.182) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 10 Feb
 2022 12:04:27 +0000
Message-ID: <47237ea4-4c86-d1f6-aec6-747bf305b2c2@huawei.com>
Date:   Thu, 10 Feb 2022 12:04:23 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 05/20] scsi: pm8001: Remove local variable in
 pm8001_pci_resume()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <20220210114218.632725-6-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220210114218.632725-6-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.24.182]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/02/2022 11:42, Damien Le Moal wrote:
> In pm8001_pci_resume(), the use of the u32 type for the local variable
> device_state causes a sparse warning:
> 
> warning: incorrect type in assignment (different base types)
>      expected unsigned int [usertype] device_state
>      got restricted pci_power_t [usertype] current_state
> 
> Since this variable is used only once in the function, remove it and
> use pdev->current_state directly. While at it, also add a blank line
> after the last local variable declaration.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Regardless of a couple of comments:
Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/pm8001/pm8001_init.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index d8a2121cb8d9..4b9a26f008a9 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1335,13 +1335,13 @@ static int __maybe_unused pm8001_pci_resume(struct device *dev)
>   	struct pm8001_hba_info *pm8001_ha;
>   	int rc;
>   	u8 i = 0, j;
> -	u32 device_state;
>   	DECLARE_COMPLETION_ONSTACK(completion);
> +
>   	pm8001_ha = sha->lldd_ha;
> -	device_state = pdev->current_state;
>   
> -	pm8001_info(pm8001_ha, "pdev=0x%p, slot=%s, resuming from previous operating state [D%d]\n",
> -		      pdev, pm8001_ha->name, device_state);
> +	pm8001_info(pm8001_ha,
> +		    "pdev=0x%p, slot=%s, resuming from previous operating state [D%d]\n",

I think that we may put this on the same line as pm8001_info

Feel free to ignore this: if we're ok with changing logs, I am not sure 
on the "slot" value - it is already printed with pm8001_info. And 
printing pdev is suspect, since we should really be using dev_info or 
pci_info() and friends - but that is a bigger job.

Thanks,
John

> +		    pdev, pm8001_ha->name, pdev->current_state);
>   
>   	rc = pci_go_44(pdev);
>   	if (rc)

