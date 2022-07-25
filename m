Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB928C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jul 2022 03:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiGYD4d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Jul 2022 23:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGYD4c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jul 2022 23:56:32 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B65C5F67
        for <linux-scsi@vger.kernel.org>; Sun, 24 Jul 2022 20:56:31 -0700 (PDT)
X-UUID: 58380a3f9e364fe6834aeb7d79a3b510-20220725
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:ccf55e85-f7aa-42a8-bf57-8f8533ea86dd,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:5
X-CID-META: VersionHash:0f94e32,CLOUDID:d6ac62b3-06d2-48ef-b2dd-540836705165,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 58380a3f9e364fe6834aeb7d79a3b510-20220725
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1309832442; Mon, 25 Jul 2022 11:56:28 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 25 Jul 2022 11:56:28 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Mon, 25 Jul 2022 11:56:28 +0800
Subject: Re: [PATCH v1] ufs: core: fix lockdep warning of clk_scaling_lock
To:     Bart Van Assche <bvanassche@acm.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>
References: <20220722095308.10112-1-peter.wang@mediatek.com>
 <c9138aae-db78-7163-e207-3fb134db226c@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <727cdd7e-dd5a-f926-13d7-e93729c96903@mediatek.com>
Date:   Mon, 25 Jul 2022 11:56:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c9138aae-db78-7163-e207-3fb134db226c@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 7/23/22 5:00 AM, Bart Van Assche wrote:
> On 7/22/22 02:53, peter.wang@mediatek.com wrote:
>> This patch only release write lock of clk_scaling_lock before
>> ufshcd_wb_toggle.
>
> The above is not clear to me. Please make the above more clear.
>
> Additionally, patches must be signed before these can be merged 
> upstream. Where is your Signed-off-by?
>
>> -    /* Enable Write Booster if we have scaled up else disable it */
>> -    downgrade_write(&hba->clk_scaling_lock);
>> -    is_writelock = false;
>> -    ufshcd_wb_toggle(hba, scale_up);
>> +    wb_toggle = true;
>>     out_unprepare:
>> -    ufshcd_clock_scaling_unprepare(hba, is_writelock);
>> +    ufshcd_clock_scaling_unprepare(hba);
>> +
>> +    /* Enable Write Booster if we have scaled up else disable it */
>> +    if (wb_toggle)
>> +        ufshcd_wb_toggle(hba, scale_up);
>> +
>>       return ret;
>>   }
>
> The patch description should mention that this patch changes the 
> ufshcd_wb_toggle() call: before this patch clk_scaling_lock was held 
> in reader mode during the ufshcd_wb_toggle() call and with this patch 
> applied clk_scaling_lock is not held while ufshcd_wb_toggle() is 
> called. I'm missing an explanation of why this change is safe.
>
> Thanks,
>
> Bart.
>

Hi Bart,

okay, I will make this path more clear and add Signed-off-by
Thanks for review.

Peter




