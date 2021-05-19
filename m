Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B151CC43461
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 03:36:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 934BE6135B
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 03:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237831AbhESDhp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 23:37:45 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4666 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235058AbhESDhn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 23:37:43 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FlJPF451wz1BP4J;
        Wed, 19 May 2021 11:33:37 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 11:36:23 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 11:36:22 +0800
Subject: Re: [PATCH -next] scsi: hisi_sas: drop free_irq of devm_request_irq
 allocated irq
To:     John Garry <john.garry@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        chenxiang <chenxiang66@hisilicon.com>,
        "luojiaxing@huawei.com" <luojiaxing@huawei.com>
References: <20210518130902.1307494-1-yangyingliang@huawei.com>
 <cf6a6fb8-e9e6-967e-a012-8e25a40922ec@huawei.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <30e9c7d4-75c6-8cbc-7a27-d406eae01dad@huawei.com>
Date:   Wed, 19 May 2021 11:36:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cf6a6fb8-e9e6-967e-a012-8e25a40922ec@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2021/5/18 23:34, John Garry wrote:
> On 18/05/2021 14:09, Yang Yingliang wrote:
>> irq allocated with devm_request_irq should not be freed using
>> free_irq, because doing so causes a dangling pointer, and a
>> subsequent double free.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c 
>> b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> index 499c770d405c..684f762bcfb3 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> @@ -4811,9 +4811,9 @@ hisi_sas_v3_destroy_irqs(struct pci_dev *pdev, 
>> struct hisi_hba *hisi_hba)
>>   {
>>       int i;
>>   -    free_irq(pci_irq_vector(pdev, 1), hisi_hba);
>> -    free_irq(pci_irq_vector(pdev, 2), hisi_hba);
>> -    free_irq(pci_irq_vector(pdev, 11), hisi_hba);
>> +    devm_free_irq(&pdev->dev, pci_irq_vector(pdev, 1), hisi_hba);
>> +    devm_free_irq(&pdev->dev, pci_irq_vector(pdev, 2), hisi_hba);
>> +    devm_free_irq(&pdev->dev, pci_irq_vector(pdev, 11), hisi_hba);
>>       for (i = 0; i < hisi_hba->cq_nvecs; i++) {
>>           struct hisi_sas_cq *cq = &hisi_hba->cq[i];
>>           int nr = hisi_sas_intr_conv ? 16 : 16 + i;
>>
>
> Does the free_irq(pci_irq_vector(pdev, nr, cq)) call also need to 
> change (not shown)?
Yes, I missed that, it should be changed too.
>
> Having said that, why have these at all if we use devm_request_irq()? 
> devm_irq_release() calls free_irq().
I keep the original logic here, only avoid double free.
>
> Thanks,
> John
>
> .
