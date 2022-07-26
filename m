Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE717C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jul 2022 08:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiGZImt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 04:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiGZIms (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 04:42:48 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF0B112D
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 01:42:47 -0700 (PDT)
X-UUID: c6bb4bed7c6c42f69d67aec59044d0d4-20220726
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:24556798-1fda-4f93-8789-3f18908ee737,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:5
X-CID-META: VersionHash:0f94e32,CLOUDID:5718f8d3-912a-458b-a623-74f605a77e93,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: c6bb4bed7c6c42f69d67aec59044d0d4-20220726
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1069186743; Tue, 26 Jul 2022 16:42:43 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 26 Jul 2022 16:42:40 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Tue, 26 Jul 2022 16:42:40 +0800
Subject: Re: [PATCH v2] ufs: core: fix lockdep warning of clk_scaling_lock
To:     Bart Van Assche <bvanassche@acm.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>
References: <20220725043000.5086-1-peter.wang@mediatek.com>
 <bde55edf-8009-863d-b96d-8d3d937444e9@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <3bf7b2d1-496c-22a8-3016-420979b8ac1e@mediatek.com>
Date:   Tue, 26 Jul 2022 16:42:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bde55edf-8009-863d-b96d-8d3d937444e9@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 7/26/22 12:56 AM, Bart Van Assche wrote:
> On 7/24/22 21:30, peter.wang@mediatek.com wrote:
>> From: Peter Wang <peter.wang@mediatek.com>
>>
>> There have a lockdep warning like below in current flow.
>> kworker/u16:0:  Possible unsafe locking scenario:
>>
>> kworker/u16:0:        CPU0                    CPU1
>> kworker/u16:0:        ----                    ----
>> kworker/u16:0:   lock(&hba->clk_scaling_lock);
>> kworker/u16:0: lock(&hba->dev_cmd.lock);
>> kworker/u16:0: lock(&hba->clk_scaling_lock);
>> kworker/u16:0:   lock(&hba->dev_cmd.lock);
>> kworker/u16:0:
>>
>> Before this patch clk_scaling_lock was held in reader mode during the 
>> ufshcd_wb_toggle() call.
>> With this patch applied clk_scaling_lock is not held while 
>> ufshcd_wb_toggle() is called.
>>
>> This is safe because ufshcd_wb_toggle will held clk_scaling_lock in 
>> reader mode "again" in flow
>> ufshcd_wb_toggle -> __ufshcd_wb_toggle -> ufshcd_query_flag_retry -> 
>> ufshcd_query_flag ->
>> ufshcd_exec_dev_cmd -> down_read(&hba->clk_scaling_lock);
>> The protect should enough and make sure clock is not change while 
>> send command.
>
> Since this is a bug fix, please add a Fixes: tag.

Will add Fixes: tag in next version.

>
>>   out_unprepare:
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
> Can the above patch can have the following unwanted effect?
> * ufshcd_devfreq_scale() calls ufshcd_clock_scaling_unprepare().
> * Clock scaling to a lower frequency happens.
> * ufshcd_wb_toggle() enables the write booster.
>
> Shouldn't the above ufshcd_wb_toggle() call be surrounded by 
> down_read() and up_read() calls in addition to a check whether the 
> WriteBooster really should be enabled instead of using 'scale_up'?
>
> Thanks,
>
> Bart.
>
>
You means ufshcd_devfreq_scale may have racing in two thread, right?
Then yes, it may have this unwanted effect in this condition.
But ufshcd_wb_toggle should not hold clk_scaling_lock, or the deadlock 
may happen.
I will change this patch to protect ufshcd_devfreq_scale racing and 
ufshcd_wb_toggle in next version.

Thanks.
Peter




