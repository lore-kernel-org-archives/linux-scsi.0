Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0455CC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 11:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D415E6135C
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 11:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241802AbhESLVn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 07:21:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3029 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346140AbhESLVj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 07:21:39 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FlVgd3wNRzQpYR;
        Wed, 19 May 2021 19:16:45 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 19:20:15 +0800
Received: from [10.47.87.246] (10.47.87.246) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 19 May
 2021 12:20:12 +0100
Subject: Re: [PATCH -next] scsi: hisi_sas: drop free_irq of devm_request_irq
 allocated irq
To:     Yang Yingliang <yangyingliang@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        chenxiang <chenxiang66@hisilicon.com>,
        "luojiaxing@huawei.com" <luojiaxing@huawei.com>
References: <20210518130902.1307494-1-yangyingliang@huawei.com>
 <cf6a6fb8-e9e6-967e-a012-8e25a40922ec@huawei.com>
 <30e9c7d4-75c6-8cbc-7a27-d406eae01dad@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <245d0847-bddd-2ea7-d4bc-9c4be2d26b45@huawei.com>
Date:   Wed, 19 May 2021 12:19:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <30e9c7d4-75c6-8cbc-7a27-d406eae01dad@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.87.246]
X-ClientProxiedBy: lhreml745-chm.china.huawei.com (10.201.108.195) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/05/2021 04:36, Yang Yingliang wrote:
> 
> On 2021/5/18 23:34, John Garry wrote:
>> On 18/05/2021 14:09, Yang Yingliang wrote:
>>> irq allocated with devm_request_irq should not be freed using
>>> free_irq, because doing so causes a dangling pointer, and a
>>> subsequent double free.
>>>
>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>>> ---
>>>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c 
>>> b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>>> index 499c770d405c..684f762bcfb3 100644
>>> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>>> @@ -4811,9 +4811,9 @@ hisi_sas_v3_destroy_irqs(struct pci_dev *pdev, 
>>> struct hisi_hba *hisi_hba)
>>>   {
>>>       int i;
>>>   -    free_irq(pci_irq_vector(pdev, 1), hisi_hba);
>>> -    free_irq(pci_irq_vector(pdev, 2), hisi_hba);
>>> -    free_irq(pci_irq_vector(pdev, 11), hisi_hba);
>>> +    devm_free_irq(&pdev->dev, pci_irq_vector(pdev, 1), hisi_hba);
>>> +    devm_free_irq(&pdev->dev, pci_irq_vector(pdev, 2), hisi_hba);
>>> +    devm_free_irq(&pdev->dev, pci_irq_vector(pdev, 11), hisi_hba);
>>>       for (i = 0; i < hisi_hba->cq_nvecs; i++) {
>>>           struct hisi_sas_cq *cq = &hisi_hba->cq[i];
>>>           int nr = hisi_sas_intr_conv ? 16 : 16 + i;
>>>
>>
>> Does the free_irq(pci_irq_vector(pdev, nr, cq)) call also need to 
>> change (not shown)?
> Yes, I missed that, it should be changed too.

So I think that we need this addition:
  devm_free_irq(&pdev->dev, pci_irq_vector(pdev, nr), cq);

>>
>> Having said that, why have these at all if we use devm_request_irq()? 
>> devm_irq_release() calls free_irq().
> I keep the original logic here, only avoid double free.

Kasan doesn't complain. Anyway, I think we can't rely on device-managed 
method (for calling free_irq()) as it conflicts with pci free vectors 
call. I thought that someone was developed a device-managed version of 
that (pci_alloc_irq_vectors()).

Anyway, please proceed with your change, but with the suggested addition.

Thanks
