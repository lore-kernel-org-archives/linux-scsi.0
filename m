Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F1C3C19F29
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 02:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237100AbiHDCuH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 22:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiHDCuH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 22:50:07 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710C21EC7D
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 19:50:05 -0700 (PDT)
X-UUID: 76a5242ec1b740ed90d0a3fb3ed89932-20220804
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:CC:To:Subject; bh=nZNz3ndGuUJjbvH6dWvp3hMM7FBdisSKstCOJKWBSB4=;
        b=f6gWWyDvN4CU8r9B8hBJ4zjGJITKj8kqT4Nnhs7unqjhOwZHsOfnRRKdP3B2sK4hudgPIkQeOZO/zES903k9PoC3ZbrVL35qflyKH2RPutfq/7UZCXZelXks5q8GRRPYxBCBEF/AinGsFyspRe2qIXzyoqXa7JuPGUYdP+B2lkQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:5e1c394a-bfdd-4b3c-9fe3-33cdc2d1e1d7,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:5
X-CID-META: VersionHash:0f94e32,CLOUDID:077a3625-a982-4824-82d2-9da3b6056c2a,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 76a5242ec1b740ed90d0a3fb3ed89932-20220804
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 277556207; Thu, 04 Aug 2022 10:49:59 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 4 Aug 2022 10:49:58 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Thu, 4 Aug 2022 10:49:57 +0800
Subject: Re: [PATCH v4] ufs: allow host driver disable wb toggle druing clock
 scaling
To:     Bart Van Assche <bvanassche@acm.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>
References: <20220803030329.5897-1-peter.wang@mediatek.com>
 <2070dd08-371b-a660-388e-ec2481781db9@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <86e03b02-b8d9-cd16-dbc3-55efa10bda80@mediatek.com>
Date:   Thu, 4 Aug 2022 10:49:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2070dd08-371b-a660-388e-ec2481781db9@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 8/4/22 3:28 AM, Bart Van Assche wrote:
> On 8/2/22 20:03, peter.wang@mediatek.com wrote:
>>
>
> disable -> to disable?
>
> toggle -> toggling?
>
> druing -> during?
>
>> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
>> index 0a088b47d557..7f41f2a69b04 100644
>> --- a/drivers/ufs/core/ufs-sysfs.c
>> +++ b/drivers/ufs/core/ufs-sysfs.c
>> @@ -225,7 +225,8 @@ static ssize_t wb_on_store(struct device *dev, 
>> struct device_attribute *attr,
>>       unsigned int wb_enable;
>>       ssize_t res;
>>   -    if (!ufshcd_is_wb_allowed(hba) || 
>> ufshcd_is_clkscaling_supported(hba)) {
>> +    if (!ufshcd_is_wb_allowed(hba) || 
>> (ufshcd_is_clkscaling_supported(hba)
>> +        && ufshcd_enable_wb_if_scaling_up(hba))) {
>
> The "&&" is misplaced - it should occur at the end of the previous 
> line. Isn't this something that checkpatch complains about?
>
>>       /* Enable Write Booster if we have scaled up else disable it
 */
>> -    downgrade_write(&hba->clk_scaling_lock);
>> -    is_writelock = false;
>> -    ufshcd_wb_toggle(hba, scale_up);
>> +    if (ufshcd_enable_wb_if_scaling_up(hba)) {
>> +        downgrade_write(&hba->clk_scaling_lock);
>> +        is_writelock = false;
>> +        ufshcd_wb_toggle(hba, scale_up);
>> +    }
>
> Since this code is being modified, please move the "/* Enable" comment 
> to where it should occur (just above the ufshcd_wb_toggle() call).
>
>> @@ -1004,6 +1010,10 @@ static inline bool ufshcd_is_wb_allowed(struct 
>> ufs_hba *hba)
>>   {
>>       return hba->caps & UFSHCD_CAP_WB_EN;
>>   }
>> +static inline bool ufshcd_enable_wb_if_scaling_up(struct ufs_hba *hba)
>> +{
>> +    return hba->caps & UFSHCD_CAP_WB_WITH_CLK_SCALING;
>> +}
>
> It seems like a blank line is missing above the new function definition?
>
> Otherwise this patch looks good to me.
>
> Thanks,

Hi Bart,


Will fix next version.


Thanks

Peter

>
> Bart.
