Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61304C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jul 2022 09:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbiGZJQk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 05:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiGZJQj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 05:16:39 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BFF24087
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 02:16:38 -0700 (PDT)
X-UUID: adbdb38f735b455d9552b88161b9721c-20220726
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:71665570-07d5-4dad-9601-437ab9620c4f,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:0
X-CID-META: VersionHash:0f94e32,CLOUDID:ed33f9d3-912a-458b-a623-74f605a77e93,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: adbdb38f735b455d9552b88161b9721c-20220726
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 931997404; Tue, 26 Jul 2022 17:16:33 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Tue, 26 Jul 2022 17:16:32 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Tue, 26 Jul 2022 17:16:31 +0800
Subject: Re: [PATCH v3] scsi: ufs: correct ufshcd_shutdown flow
To:     Bart Van Assche <bvanassche@acm.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>
References: <20220721065833.26887-1-peter.wang@mediatek.com>
 <2f66f4ba-f0d5-6b8a-cc3b-fa896a302d60@acm.org>
 <090da948-0fce-9a89-0e1c-a26b3e0b735f@mediatek.com>
 <2edfdadc-2a93-591f-c5ca-98dc02a30499@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <dcf7c68b-cfb8-e8ab-f023-f469903c05ce@mediatek.com>
Date:   Tue, 26 Jul 2022 17:16:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2edfdadc-2a93-591f-c5ca-98dc02a30499@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 7/26/22 1:07 AM, Bart Van Assche wrote:
> On 7/24/22 20:47, Peter Wang wrote:
>> Because kernel_restart is export, and mediatek may call kernel_restart 
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> Is this code upstream?
>
No, it not upstream.
And sorry that I correct mediatek usage, it is kernel_power_off, not 
kernel_restart.

>> while shutdown is on going.
>> EXPORT_SYMBOL_GPL(kernel_restart);
>> kernel_restart -> kernel_restart_prepare -> device_shutdown
>>
>> So, there may have two thread execute device_shutdown concurrently.
>> And the list_lock in device_shutdown function is not protect shutdown 
>> callback function,
>> caused two callback function(ufshcd_shutdown/ufshcd_wl_shutdown) 
>> could run concurrently.
>>
>> Here is the error log that two thread in device_shutdown.
>> [37684.002227] [T1500641] platform +platform:112b0000.ufshci 
>> kpoc_charger: ufshcd-mtk 112b0000.ufshci: [name:core&]shutdown
>> [37684.002264] [T1600339] scsi +scsi:0:0:0:49488 charger_thread: 
>> ufs_device_wlun 0:0:0:49488: [name:core&]shutdown
>
> Hi Peter,
>
> I had not yet taken a look at the kernel_restart() function. Now that 
> I have taken a look, it seems to me that kernel_restart() calls must 
> be serialized via the system_transition_mutex. Please make sure that 
> the kernel_restart() calls are serialized.
>
> Thanks,
>
> Bart.

I think kernel_power_off could use system_transition_mutex to protect 
shutdown racing.
We will try it, Thanks for the suggestion.
And if no need wait, it could more simple in this patch. I will upload 
next version again.

Thanks.
Peter






