Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A858C00140
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 02:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbiHCCor (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 22:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiHCCoq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 22:44:46 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523BB3337A
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 19:44:45 -0700 (PDT)
X-UUID: 79c0c435f7f842798d9703be762c0805-20220803
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:47c1a05f-d6f8-4439-a425-d2cd0f44fafe,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:5
X-CID-META: VersionHash:0f94e32,CLOUDID:b36620d0-a6cf-4fb6-be1b-c60094821ca2,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 79c0c435f7f842798d9703be762c0805-20220803
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1515010094; Wed, 03 Aug 2022 10:44:38 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 3 Aug 2022 10:44:38 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Wed, 3 Aug 2022 10:44:38 +0800
Subject: Re: [PATCH v3 1/2] ufs: core: introduce a choice of wb toggle during
 clock scaling
To:     Bart Van Assche <bvanassche@acm.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>
References: <20220802143223.1276-1-peter.wang@mediatek.com>
 <20220802143223.1276-2-peter.wang@mediatek.com>
 <06b8cb30-f308-63bd-b073-83c9add87cd3@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <c274594e-71e9-a795-0018-592c30c18a32@mediatek.com>
Date:   Wed, 3 Aug 2022 10:44:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <06b8cb30-f308-63bd-b073-83c9add87cd3@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 8/3/22 2:44 AM, Bart Van Assche wrote:
> On 8/2/22 07:32, peter.wang@mediatek.com wrote:
>> +    /* Allow WB with clk scaling */
>
> This comment is misleading. Consider changing this comment into 
> something like "Enable WB when scaling up the clock and disable WB 
> when scaling the clock down".

Will change comment next version, thanks.

>
>> + UFSHCD_CAP_WB_WITH_CLK_SCALING            = 1 << 12,
>
> Whether or not the WriteBooster is toggled when the clock is scaled is 
> not a host controller capability. It is a policy that is tied by this 
> patch to the host controller. So I think that using the "UFSHCD_CAP_" 
> prefix is misleading. Consider using e.g. the prefix UFSHCD_POLICY_.
>
The prefix UFSHCD_CAP_ is used in ufshcd_caps and not all of them is 
host capability.
Ex. UFSHCD_CAP_HIBERN8_WITH_CLK_GATING is a policy host send hiberb8 
with clk gating or not.
Ex. UFSHCD_CAP_WB_EN is a host policy to turn-on WriteBooster or not.
So, I think it is not suitable to break the naming rule in ufshcd_caps now.


> > +static inline bool ufshcd_can_wb_during_scaling(struct ufs_hba *hba)
> > +{
> > +    return hba->caps & UFSHCD_CAP_WB_WITH_CLK_SCALING;
> > +}
>
> The name of this function is misleading. Consider renaming this 
> function into e.g. ufshcd_enable_wb_if_scaling_up().
>
> Thanks,
>
> Bart.

Will change function name next version.


Thanks.
Peter



