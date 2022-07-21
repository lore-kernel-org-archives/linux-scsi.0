Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F1FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jul 2022 04:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiGUEaj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jul 2022 00:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiGUEai (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2022 00:30:38 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3EC2ED63
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 21:30:30 -0700 (PDT)
X-UUID: 2749d2cb971443b6a594b38857b10383-20220721
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:3f3e8bad-3a22-4a23-9047-1a383f0d2c17,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:50
X-CID-INFO: VERSION:1.1.8,REQID:3f3e8bad-3a22-4a23-9047-1a383f0d2c17,OB:0,LOB:
        0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,RULE:Release_Ham,ACTIO
        N:release,TS:50
X-CID-META: VersionHash:0f94e32,CLOUDID:bdb8dc64-0b3f-4b2c-b3a6-ed5c044366a0,C
        OID:df1bd108d0ba,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: 2749d2cb971443b6a594b38857b10383-20220721
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 4856907; Thu, 21 Jul 2022 12:30:24 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Thu, 21 Jul 2022 12:30:22 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Thu, 21 Jul 2022 12:30:22 +0800
Subject: Re: [PATCH v1] scsi: ufs: correct ufshcd_shutdown flow
To:     Bart Van Assche <bvanassche@acm.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>
References: <20220719130208.29032-1-peter.wang@mediatek.com>
 <afb8d403-f8f5-5161-4680-ce2c3ae7787d@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <a71af42f-3b66-c0a1-c79d-a4573d0376fe@mediatek.com>
Date:   Thu, 21 Jul 2022 12:30:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <afb8d403-f8f5-5161-4680-ce2c3ae7787d@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart

On 7/21/22 5:40 AM, Bart Van Assche wrote:
> On 7/19/22 06:02, peter.wang@mediatek.com wrote:
>> From: Peter Wang <peter.wang@mediatek.com>
>>
>> After ufshcd_wl_shutdown set device poweroff and link off,
>> ufshcd_shutdown not turn off regulators/clocks.
>> Correct the flow to wait ufshcd_wl_shutdown done and turn off
>> regulators/clocks by polling ufs device/link state 500ms.
>> Also remove pm_runtime_get_sync because it is unnecessary.
>
> Please explain in the patch description why the pm_runtime_get_sync() 
> call is not necessary.

Because shutdown is focus on turn off clock/power, we don't need turn 
on(resume) and turn off, right?

>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index c7b337480e3e..1c11af48b584 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -9461,10 +9461,14 @@ EXPORT_SYMBOL(ufshcd_runtime_resume);
>>    */
>>   int ufshcd_shutdown(struct ufs_hba *hba)
>>   {
>> -    if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
>> -        goto out;
>> +    ktime_t timeout = ktime_add_ms(ktime_get(), 500);
>
> Where does the 500 ms timeout come from?

It is a time to wait device into power off, if the 500 ms is not 
suitable, could you suggess a value?

>
> Additionally, given the large timeout, please use jiffies instead of 
> ktime_get().

Okay, will change next version.

>
>> -    pm_runtime_get_sync(hba->dev);
>> +    /* Wait ufshcd_wl_shutdown clear ufs state, timeout 500 ms */
>> +    while (!ufshcd_is_ufs_dev_poweroff(hba) || 
>> !ufshcd_is_link_off(hba)) {
>> +        if (ktime_after(ktime_get(), timeout))
>> +            goto out;
>> +        msleep(1);
>> +    }
>
> Please explain why this wait loop has been introduced.

Both ufshcd_shtdown and ufshcd_wl_shutdown could run concurrently.

if ufshcd_wl_shutdown -> ufshcd_shtdown, clock/power off should ok.

If ufshcd_shtdown -> ufshcd_wl_shutdown, wait ufshcd_wl_shutdown set 
device to power off and turn off clock/power.

If timeout happen, means device still in active mode, cannot turn off 
clock/power directly. Skip and keep clock/power on in this case.


>
> Thanks,
>
> Bart.
