Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1BBC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jul 2022 03:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiGYDqG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Jul 2022 23:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiGYDqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jul 2022 23:46:05 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316CFDFAE
        for <linux-scsi@vger.kernel.org>; Sun, 24 Jul 2022 20:46:00 -0700 (PDT)
X-UUID: 6bd1b4e30590445e81a86f5f524a6759-20220725
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:e7cf49c7-1547-4ab1-9a05-732e8adc215a,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:5
X-CID-META: VersionHash:0f94e32,CLOUDID:746362b3-06d2-48ef-b2dd-540836705165,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 6bd1b4e30590445e81a86f5f524a6759-20220725
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 793621049; Mon, 25 Jul 2022 11:45:53 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 25 Jul 2022 11:45:52 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Mon, 25 Jul 2022 11:45:52 +0800
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
 <a71af42f-3b66-c0a1-c79d-a4573d0376fe@mediatek.com>
 <54727af0-dc4b-fadb-5193-13ff4ecc48ef@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <f14ea4b1-819a-2549-9f26-7fae592ad5f5@mediatek.com>
Date:   Mon, 25 Jul 2022 11:45:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <54727af0-dc4b-fadb-5193-13ff4ecc48ef@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 7/23/22 2:04 AM, Bart Van Assche wrote:
> On 7/20/22 21:30, Peter Wang wrote:
>> On 7/21/22 5:40 AM, Bart Van Assche wrote:
>>> On 7/19/22 06:02, peter.wang@mediatek.com wrote:
>>>> From: Peter Wang <peter.wang@mediatek.com>
>>>> Also remove pm_runtime_get_sync because it is unnecessary.
>>>
>>> Please explain in the patch description why the 
>>> pm_runtime_get_sync() call is not necessary.
>>
>> Because shutdown is focus on turn off clock/power, we don't need turn 
>> on(resume) and turn off, right?
> Hi Peter,
>
> I think that removing the pm_runtime_get_sync() call is safe because 
> the device driver core already performs a runtime resume before the 
> UFS driver shutdown callback function is called. From 
> drivers/base/core.c:
>
>         /* Don't allow any more runtime suspends */
>         pm_runtime_get_noresume(dev);
>         pm_runtime_barrier(dev);
>
> Thanks,
>
> Bart.

Hi Bart,

No, in drivers/base/core.c:
pm_runtime_get_noresume(dev); => No guarantee device will resume
pm_runtime_barrier(dev);      => Only flush pending pm request like 
RPM_SUSPENDING/RPM_RESUMING

So, If below two condition is meet.
(1) device is already in RPM_SUSPENDED
(2) device resume is required.
Then driver still need call pm_runtime_get_sync just like 
ufshcd_wl_shutdown.

The reason why here can remove pm_runtime_get_sync is because,
(1) ufshcd_wl_shutdown -> pm_runtime_get_sync, will resume hba->dev too.
(2) device resume(turn on clk/power) is not required, even if device is 
in RPM_SUSPENDED.

Thanks.
Peter


