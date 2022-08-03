Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 774E8C00140
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 02:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbiHCCms (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 22:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiHCCmr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 22:42:47 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBF333348
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 19:42:40 -0700 (PDT)
X-UUID: 19f76439737d41e496b1e2bfb18b5f09-20220803
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:9f061b9f-4e02-4f6b-8b40-443f49ec43ee,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:5
X-CID-META: VersionHash:0f94e32,CLOUDID:a65720d0-a6cf-4fb6-be1b-c60094821ca2,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 19f76439737d41e496b1e2bfb18b5f09-20220803
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1777091183; Wed, 03 Aug 2022 10:42:36 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 3 Aug 2022 10:42:36 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Wed, 3 Aug 2022 10:42:36 +0800
Subject: Re: [PATCH v3 2/2] ufs: host: support wb toggle with clock scaling
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
 <20220802143223.1276-3-peter.wang@mediatek.com>
 <517895b7-95ed-5e83-fb6d-98e155b896d4@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <39d082c1-88fe-3feb-0654-9ea562b542ac@mediatek.com>
Date:   Wed, 3 Aug 2022 10:42:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <517895b7-95ed-5e83-fb6d-98e155b896d4@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 8/3/22 2:46 AM, Bart Van Assche wrote:
> On 8/2/22 07:32, peter.wang@mediatek.com wrote:
>> From: Peter Wang <peter.wang@mediatek.com>
>>
>> Set UFSHCD_CAP_WB_WITH_CLK_SCALING for qcom to compatible legacy design.
>>
>> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
>> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
>> ---
>>   drivers/ufs/host/ufs-qcom.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index f10d4668814c..f8c9a78e7776 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -869,7 +869,7 @@ static void ufs_qcom_set_caps(struct ufs_hba *hba)
>>       struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>>         hba->caps |= UFSHCD_CAP_CLK_GATING | 
>> UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
>> -    hba->caps |= UFSHCD_CAP_CLK_SCALING;
>> +    hba->caps |= UFSHCD_CAP_CLK_SCALING | 
>> UFSHCD_CAP_WB_WITH_CLK_SCALING;
>>       hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
>>       hba->caps |= UFSHCD_CAP_WB_EN;
>>       hba->caps |= UFSHCD_CAP_CRYPTO;
>
> A patch series should be bisectable. Without this patch the previous 
> patch in this series introduces a regression for Qualcomm controllers. 
> So I think that the two patches should be combined into a single patch.
>
> Thanks,
>
> Bart.

Hi Bart,

Will combine into a single patch next version.

Thanks.
Peter



