Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225BFC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jul 2022 03:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiGYDrz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Jul 2022 23:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiGYDry (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jul 2022 23:47:54 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FFADFD1
        for <linux-scsi@vger.kernel.org>; Sun, 24 Jul 2022 20:47:52 -0700 (PDT)
X-UUID: e9a3b1a706db4ffda7c82ed8777bff09-20220725
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:6ee81a69-4ecd-49b4-9954-f19bd3c756ff,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:5
X-CID-META: VersionHash:0f94e32,CLOUDID:c47fd4d3-912a-458b-a623-74f605a77e93,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: e9a3b1a706db4ffda7c82ed8777bff09-20220725
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1285701626; Mon, 25 Jul 2022 11:47:47 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 25 Jul 2022 11:47:46 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Mon, 25 Jul 2022 11:47:45 +0800
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
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <090da948-0fce-9a89-0e1c-a26b3e0b735f@mediatek.com>
Date:   Mon, 25 Jul 2022 11:47:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2f66f4ba-f0d5-6b8a-cc3b-fa896a302d60@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 7/23/22 5:12 AM, Bart Van Assche wrote:
> On 7/20/22 23:58, peter.wang@mediatek.com wrote:
>> Both ufshcd_shtdown and ufshcd_wl_shutdown could run concurrently.
>> And it have race condition when ufshcd_wl_shutdown on-going and
>> clock/power turn off by ufshcd_shutdown.
>>
>> The normal case:
>> ufshcd_wl_shutdown -> ufshcd_shtdown
>> ufshcd_shtdown should turn off clock/power.
>>
>> The abnormal case:
>> ufshcd_shtdown -> ufshcd_wl_shutdown
>
> How can this happen since device_shutdown() iterates over devices in 
> the opposite order in which these have been created?
>
> Thanks,
>
> Bart.

Hi Bart,

Because kernel_restart is export, and mediatek may call kernel_restart 
while shutdown is on going.
EXPORT_SYMBOL_GPL(kernel_restart);
kernel_restart -> kernel_restart_prepare -> device_shutdown

So, there may have two thread execute device_shutdown concurrently.
And the list_lock in device_shutdown function is not protect shutdown 
callback function,
caused two callback function(ufshcd_shutdown/ufshcd_wl_shutdown) could 
run concurrently.

Here is the error log that two thread in device_shutdown.
[37684.002227] [T1500641] platform +platform:112b0000.ufshci 
kpoc_charger: ufshcd-mtk 112b0000.ufshci: [name:core&]shutdown
[37684.002264] [T1600339] scsi +scsi:0:0:0:49488 charger_thread: 
ufs_device_wlun 0:0:0:49488: [name:core&]shutdown

Thanks.
BR
Peter


