Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A334C00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 14:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbiHAOaj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 10:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiHAOac (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 10:30:32 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9908A2B252
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 07:30:30 -0700 (PDT)
X-UUID: 0bed1a22c3314888bb8d2158b674b9e7-20220801
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:6ab8c46a-e3b6-4d25-9549-71f7666369db,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:50
X-CID-INFO: VERSION:1.1.8,REQID:6ab8c46a-e3b6-4d25-9549-71f7666369db,OB:0,LOB:
        0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,RULE:Release_Ham,ACTIO
        N:release,TS:50
X-CID-META: VersionHash:0f94e32,CLOUDID:5a4cead0-841b-4e95-ad42-8f86e18f54fc,C
        OID:2fbe9991d6b6,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: 0bed1a22c3314888bb8d2158b674b9e7-20220801
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1577839384; Mon, 01 Aug 2022 22:30:22 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 1 Aug 2022 22:30:20 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Mon, 1 Aug 2022 22:30:20 +0800
Subject: Re: [PATCH v1 0/2] ufs: allow vendor disable wb toggle in clock
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
References: <20220728071637.22364-1-peter.wang@mediatek.com>
 <968f5255-f7b9-e011-2bd3-aa711bdd142a@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <ca760b93-e6e9-abea-f2b2-dbb0c592690b@mediatek.com>
Date:   Mon, 1 Aug 2022 22:30:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <968f5255-f7b9-e011-2bd3-aa711bdd142a@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 7/29/22 5:09 AM, Bart Van Assche wrote:
> On 7/28/22 00:16, peter.wang@mediatek.com wrote:
>> Mediatek ufs do not want to toggle write booster when clock scaling.
>> This patch set allow vendor disable wb toggle in clock scaling.
>
> I don't like this approach. Whether or not to toggle the write booster 
> when scaling the clock is not dependent on the host controller and 
> hence should not depend on the host controller driver.
>
> Has it been considered to add a sysfs attribute in the UFS driver core 
> to control this behavior?
>
> Thanks,
>
> Bart.

Hi Bart,

Write booster binding with clock scaling is not make sense.
Clock scaling should always do clock scaling related things, and write 
bootster is not related to clock, right?
So Mediatek don't want to toggle wb with clock scaling.
Consider legacy design is binding, so we provide a flag to decouple them 
instead remove ufshcd_wb_toggle directly.
Or, do you think we can direct remove ufshcd_wb_toggle in clock scaling 
and only let sysfs to control wb behavior?

Thanks.
Peter


