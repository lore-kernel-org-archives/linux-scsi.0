Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16CFC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 12:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349911AbiDZMVF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 08:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349983AbiDZMTr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 08:19:47 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0182D6384
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 05:16:35 -0700 (PDT)
X-UUID: 885ca9df70dc4a738728e56d5bd78eed-20220426
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.4,REQID:0ad0a0a2-2b53-429a-bbca-e9b9630b4fa1,OB:0,LO
        B:0,IP:0,URL:8,TC:0,Content:0,EDM:0,RT:0,SF:50,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:58
X-CID-INFO: VERSION:1.1.4,REQID:0ad0a0a2-2b53-429a-bbca-e9b9630b4fa1,OB:0,LOB:
        0,IP:0,URL:8,TC:0,Content:0,EDM:0,RT:0,SF:50,FILE:0,RULE:Release_Ham,ACTIO
        N:release,TS:58
X-CID-META: VersionHash:faefae9,CLOUDID:4d5fc22e-6199-437e-8ab4-9920b4bc5b76,C
        OID:10581e1f1abb,Recheck:0,SF:13|15|28|17|19|48,TC:nil,Content:0,EDM:-3,Fi
        le:nil,QS:0,BEC:nil
X-UUID: 885ca9df70dc4a738728e56d5bd78eed-20220426
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 566345750; Tue, 26 Apr 2022 20:16:30 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 26 Apr 2022 20:16:29 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 26 Apr 2022 20:16:29 +0800
Subject: Re: [PATCH v1] scsi: ufs: fix rpm racing issue
To:     Avri Altman <Avri.Altman@wdc.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "powen.kao@mediatek.com" <powen.kao@mediatek.com>,
        "qilin.tan@mediatek.com" <qilin.tan@mediatek.com>,
        "lin.gui@mediatek.com" <lin.gui@mediatek.com>,
        "mikebi@micron.com" <mikebi@micron.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>
References: <20220421144152.23888-1-peter.wang@mediatek.com>
 <DM6PR04MB657564C8412643B2D2F5E40DFCF89@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <6542cd8c-675e-c229-215d-c7c47d85a7db@mediatek.com>
Date:   Tue, 26 Apr 2022 20:16:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB657564C8412643B2D2F5E40DFCF89@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 4/25/22 4:35 PM, Avri Altman wrote:
>   
>> From: Peter Wang <peter.wang@mediatek.com>
>>
>> Device WLun may enter RPM_SUSPENDED and the consumer is RPM_ACTIVE.
>>
>> The error state is
>> Device Wlun RPM: status:2, usage_count:0
>> Consumer: 0:0:0:49476 Link: rpm_active:1, RPM: status:2, usage_count:0
>> Consumer: 0:0:0:49456 Link: rpm_active:1, RPM: status:2, usage_count:0
>> Consumer: 0:0:0:0 Link: rpm_active:1, RPM: status:2, usage_count:0
>> Consumer: 0:0:0:1 Link: rpm_active:1, RPM: status:2, usage_count:0
>> Consumer: 0:0:0:2 Link: rpm_active:1, RPM: status:0, usage_count:0
>>
>> Because rpm enable before rpm delay set, scsi_autopm_put_device
>> invoke by scsi_sysfs_add_sdev may cause consumer enter suspend
>> immediately.
>> Thas will always set rpm_active to 1.
>> If driver_probe_device invoke pm_runtime_get_suppliers just befor
>> previous scsi_autopm_put_device, the rpm_active will change to 1
>> after pm_runtime_put_suppliers.
>> Set this delay to avoid scsi_autopm_put_device enter suspend immediately.
>>
>> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
>> ---
>>   drivers/scsi/ufs/ufshcd.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 3f9caafa91bf..1250792d16be 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -5024,10 +5024,14 @@ static int ufshcd_slave_configure(struct
>> scsi_device *sdev)
>>           * Block runtime-pm until all consumers are added.
>>           * Refer ufshcd_setup_links().
>>           */
>> -       if (is_device_wlun(sdev))
>> +       if (is_device_wlun(sdev)) {
>>                  pm_runtime_get_noresume(&sdev->sdev_gendev);
>> -       else if (ufshcd_is_rpm_autosuspend_allowed(hba))
>> +       } else if (ufshcd_is_rpm_autosuspend_allowed(hba)) {
>>                  sdev->rpm_autosuspend = 1;
>> +               pm_runtime_set_autosuspend_delay(&sdev->sdev_gendev,
>> +                       RPM_AUTOSUSPEND_DELAY_MS);
>> +       }
> Maybe remove ufshcd_blk_pm_runtime_init from ufshcd_scsi_add_wlus,
> And call here ufshcd_blk_pm_runtime_init() ?
>
> Thanks,
> Avri

Hi Arvi,


Thanks review, but I need discard this patch because it is not correct.

Sorry for inconvenient.


Thanks

Peter

>
>> +
>>          /*
>>           * Do not print messages during runtime PM to avoid never-ending cycles
>>           * of messages written back to storage by user space causing runtime
>> --
>> 2.18.0
