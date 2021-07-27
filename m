Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D170BC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 02:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5AEE60FED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 02:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbhG0CQ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 22:16:57 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16002 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbhG0CQ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 22:16:56 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GYhFb3Y0xzZst3;
        Tue, 27 Jul 2021 10:53:55 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 27 Jul 2021 10:57:22 +0800
Received: from [10.174.179.215] (10.174.179.215) by
 dggema769-chm.china.huawei.com (10.1.198.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 27 Jul 2021 10:57:21 +0800
Subject: Re: [PATCH -next] scsi: ufs: fix build warning without CONFIG_PM
To:     Bart Van Assche <bvanassche@acm.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210611130601.34336-1-yuehaibing@huawei.com>
 <99c99d97-5849-cf40-709b-aebe53b80ce3@acm.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <cf956e7d-27b2-43c9-5c65-9d9e62919f40@huawei.com>
Date:   Tue, 27 Jul 2021 10:57:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <99c99d97-5849-cf40-709b-aebe53b80ce3@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2021/7/27 1:59, Bart Van Assche wrote:
> On 6/11/21 6:06 AM, YueHaibing wrote:
>> drivers/scsi/ufs/ufshcd.c:9770:12: warning: ‘ufshcd_rpmb_resume’ defined but not used [-Wunused-function]
>>   static int ufshcd_rpmb_resume(struct device *dev)
>>              ^~~~~~~~~~~~~~~~~~
>> drivers/scsi/ufs/ufshcd.c:9037:12: warning: ‘ufshcd_wl_runtime_resume’ defined but not used [-Wunused-function]
>>   static int ufshcd_wl_runtime_resume(struct device *dev)
>>              ^~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/scsi/ufs/ufshcd.c:9017:12: warning: ‘ufshcd_wl_runtime_suspend’ defined but not used [-Wunused-function]
>>   static int ufshcd_wl_runtime_suspend(struct device *dev)
>>              ^~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Move it into #ifdef block to fix this.
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>   drivers/scsi/ufs/ufshcd.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index b87ff68aa9aa..0c54589e186a 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -8926,6 +8926,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>>       return ret;
>>   }
>>   +#ifdef CONFIG_PM_SLEEP
>>   static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>>   {
>>       int ret;
>> @@ -9053,7 +9054,6 @@ static int ufshcd_wl_runtime_resume(struct device *dev)
>>       return ret;
>>   }
>>   -#ifdef CONFIG_PM_SLEEP
>>   static int ufshcd_wl_suspend(struct device *dev)
>>   {
>>       struct scsi_device *sdev = to_scsi_device(dev);
>> @@ -9766,6 +9766,7 @@ static inline int ufshcd_clear_rpmb_uac(struct ufs_hba *hba)
>>       return ret;
>>   }
>>   +#ifdef CONFIG_PM_SLEEP
>>   static int ufshcd_rpmb_resume(struct device *dev)
>>   {
>>       struct ufs_hba *hba = wlun_dev_to_hba(dev);
>> @@ -9774,6 +9775,7 @@ static int ufshcd_rpmb_resume(struct device *dev)
>>           ufshcd_clear_rpmb_uac(hba);
>>       return 0;
>>   }
>> +#endif
>>     static const struct dev_pm_ops ufs_rpmb_pm_ops = {
>>       SET_RUNTIME_PM_OPS(NULL, ufshcd_rpmb_resume, NULL)
> 
> Hi YueHaibing,
> 
> Can you take a look at https://lore.kernel.org/linux-scsi/20210722033439.26550-1-bvanassche@acm.org/T/#m6e7a02fc79634b5b77cfb77849253ac41d021389? I let the kernel robot verify that patch before I posted it on the linux-scsi mailing list.

__ufshcd_wl_resume() is needed while CONFIG_PM is enabled, and my patch v2 has been Applied. See:

https://lore.kernel.org/r/20210617031326.36908-1-yuehaibing@huawei.com

I will let Hulk Robot test your patch serials, and report if any.

> 
> Thanks,
> 
> Bart.
> .
