Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B1BBC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 01:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbiGMBoR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 21:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbiGMBoO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 21:44:14 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBD42872E;
        Tue, 12 Jul 2022 18:44:13 -0700 (PDT)
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LjL0s3cYyzVfc3;
        Wed, 13 Jul 2022 09:40:29 +0800 (CST)
Received: from dggpeml500008.china.huawei.com (7.185.36.147) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Jul 2022 09:44:11 +0800
Received: from [127.0.0.1] (10.67.111.83) by dggpeml500008.china.huawei.com
 (7.185.36.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 13 Jul
 2022 09:44:10 +0800
Message-ID: <df9909dc-3303-808e-575a-47190f636279@huawei.com>
Date:   Wed, 13 Jul 2022 09:44:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH -next] scsi: ufs: ufs-mediatek: Fix build error
To:     Arnd Bergmann <arnd@arndb.de>
CC:     <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
References: <20220704025632.235968-1-renzhijie2@huawei.com>
 <CAK8P3a07jGCuAVQAZgpENRP_xFLiogU9W1Uze+n21h7TdOZhog@mail.gmail.com>
From:   Ren Zhijie <renzhijie2@huawei.com>
In-Reply-To: <CAK8P3a07jGCuAVQAZgpENRP_xFLiogU9W1Uze+n21h7TdOZhog@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.83]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500008.china.huawei.com (7.185.36.147)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

在 2022/7/12 16:27, Arnd Bergmann 写道:
> On Mon, Jul 4, 2022 at 4:56 AM Ren Zhijie <renzhijie2@huawei.com> wrote:
>> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
>> index c958279bdd8f..e006c2528a3a 100644
>> --- a/drivers/ufs/host/ufs-mediatek.c
>> +++ b/drivers/ufs/host/ufs-mediatek.c
>> @@ -1427,6 +1427,7 @@ static int ufs_mtk_system_resume(struct device *dev)
>>   }
>>   #endif
>>
>> +#ifdef CONFIG_PM
>>   static int ufs_mtk_runtime_suspend(struct device *dev)
>>   {
>>          struct ufs_hba *hba = dev_get_drvdata(dev);
>> @@ -1449,6 +1450,7 @@ static int ufs_mtk_runtime_resume(struct device *dev)
>>
>>          return ufshcd_runtime_resume(dev);
>>   }
>> +#endif
>>
>>   static const struct dev_pm_ops ufs_mtk_pm_ops = {
>>          SET_SYSTEM_SLEEP_PM_OPS(ufs_mtk_system_suspend,
> This change works, but it's not great. It's better to change the
> SET_SYSTEM_SLEEP_PM_OPS() to the new SYSTEM_SLEEP_PM_OPS()
> that works without the #ifdef.
>
>           Arnd

Hi Arnd,

Thanks for your suggestion.

How does it to fix the implicit-function-declaration error?

Thanks,

Ren Zhijie

> .

