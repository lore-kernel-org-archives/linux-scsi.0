Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B323EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 14:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243094AbiBJOmF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 09:42:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243081AbiBJOmE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 09:42:04 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53283D73
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 06:42:05 -0800 (PST)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JvfZP2WHkz67nGt;
        Thu, 10 Feb 2022 22:41:17 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 15:42:02 +0100
Received: from [10.202.227.197] (10.202.227.197) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 14:42:01 +0000
Message-ID: <be14a849-bdce-6c7f-d3cf-5ed4f6277fb9@huawei.com>
Date:   Thu, 10 Feb 2022 14:42:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
From:   John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 08/20] scsi: pm8001: Fix local variable declaration in
 pm80xx_pci_mem_copy()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <20220210114218.632725-9-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220210114218.632725-9-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.197]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/02/2022 11:42, Damien Le Moal wrote:
> Declare the local variable destination1 as a pointer to a __le32 value
> rather than a u32. This suppresses the sparse warning:
> 
> warning: incorrect type in assignment (different base types)
>      expected unsigned int [usertype]
>      got restricted __le32 [usertype]
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/pm8001/pm80xx_hwi.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index ec6b970e05a1..37ede7c79e85 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -71,14 +71,13 @@ static void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 soffset,
>   				u32 dw_count, u32 bus_base_number)
>   {
>   	u32 index, value, offset;
> -	u32 *destination1;
> -	destination1 = (u32 *)destination;
> +	__le32 *destination1 = (__le32 *)destination;
>   
>   	for (index = 0; index < dw_count; index += 4, destination1++) {
>   		offset = (soffset + index);
>   		if (offset < (64 * 1024)) {
>   			value = pm8001_cr32(pm8001_ha, bus_base_number, offset);
> -			*destination1 =  cpu_to_le32(value);
> +			*destination1 = cpu_to_le32(value);

I can't help but wonder if there is already something to do this, like 
memcpy_fromio()

>   		}
>   	}
>   	return;

