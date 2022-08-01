Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0541EC00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 14:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiHAOco (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 10:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiHAOcl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 10:32:41 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AF724BF7
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 07:32:39 -0700 (PDT)
X-UUID: 3af1ea06c24b415da2234987f49c9050-20220801
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:ca11299a-27cb-4f5d-961a-497d0c608c59,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:5
X-CID-META: VersionHash:0f94e32,CLOUDID:f353ead0-841b-4e95-ad42-8f86e18f54fc,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 3af1ea06c24b415da2234987f49c9050-20220801
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 777971090; Mon, 01 Aug 2022 22:32:33 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Mon, 1 Aug 2022 22:32:32 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Mon, 1 Aug 2022 22:32:32 +0800
Subject: Re: [PATCH v1 2/2] ufs: host: support wb toggle with clock scaling
To:     Bean Huo <huobean@gmail.com>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>
References: <20220728071637.22364-1-peter.wang@mediatek.com>
 <20220728071637.22364-3-peter.wang@mediatek.com>
 <ea3b173cb2575dbb81cb416469880c50dd536bd0.camel@gmail.com>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <df7e2f8a-4f49-d1fa-7090-18b4f086b608@mediatek.com>
Date:   Mon, 1 Aug 2022 22:32:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ea3b173cb2575dbb81cb416469880c50dd536bd0.camel@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 7/29/22 5:57 AM, Bean Huo wrote:
> On Thu, 2022-07-28 at 15:16 +0800, peter.wang@mediatek.com wrote:
>> From: Peter Wang <peter.wang@mediatek.com>
>>
>> Set UFSHCD_CAP_WB_WITH_CLK_SCALING for qcom to compatible legacy
>> design.
>>
>> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
>> ---
>>   drivers/ufs/host/ufs-qcom.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-
>> qcom.c
>> index f10d4668814c..f8c9a78e7776 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -869,7 +869,7 @@ static void ufs_qcom_set_caps(struct ufs_hba
>> *hba)
>>          struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>>   
>>          hba->caps |= UFSHCD_CAP_CLK_GATING |
>> UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
>> -       hba->caps |= UFSHCD_CAP_CLK_SCALING;
>> +       hba->caps |= UFSHCD_CAP_CLK_SCALING |
>> UFSHCD_CAP_WB_WITH_CLK_SCALING;
>>          hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
>>          hba->caps |= UFSHCD_CAP_WB_EN;
>>          hba->caps |= UFSHCD_CAP_CRYPTO;
> Hi peter,
>
> If WB is on/off based on clk scaling up/down is legacy design, maybe
> you have a more advanced design. It is true there is an issue since we
> didn't differentiate the read or write. WB is only for write. How to
> know this time clk scaling is for write from driver level, not possible
> now.
>
> Kind regards,
> Bean

Hi Bean,

Yes, we don't know if clock scaling up/down is for write or read.
But we want to keep WB always on even clock scaling down.
This is why we need this patch, let different host can choose toggle wb 
or not.

Thanks.
Peter







