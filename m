Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BEEC47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 09:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F4FE61407
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 09:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhFJJUj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 05:20:39 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3938 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhFJJUh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 05:20:37 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G0yxg3rtTz6xFV;
        Thu, 10 Jun 2021 17:15:35 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 17:18:39 +0800
Received: from [127.0.0.1] (10.174.177.72) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 10 Jun
 2021 17:18:38 +0800
Subject: Re: [PATCH 1/1] scsi: pm8001: remove unnecessary oom message
To:     Jinpu Wang <jinpu.wang@ionos.com>
CC:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
References: <20210610082010.16507-1-thunder.leizhen@huawei.com>
 <CAMGffEkacjUFs8+Z7Jnuuvm3+o_R8JOhrokUu61VmVKopPr9dw@mail.gmail.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <c3bf4122-15ec-0e18-8cd5-3f65ac86325c@huawei.com>
Date:   Thu, 10 Jun 2021 17:18:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAMGffEkacjUFs8+Z7Jnuuvm3+o_R8JOhrokUu61VmVKopPr9dw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2021/6/10 16:59, Jinpu Wang wrote:
> On Thu, Jun 10, 2021 at 10:20 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
>>
>> Fixes scripts/checkpatch.pl warning:
>> WARNING: Possible unnecessary 'out of memory' message
>>
>> Remove it can help us save a bit of memory.
>>
>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>> ---
>>  drivers/scsi/pm8001/pm8001_sas.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
>> index 6860d5a9ef83b44..fff01a6effc4dab 100644
>> --- a/drivers/scsi/pm8001/pm8001_sas.c
>> +++ b/drivers/scsi/pm8001/pm8001_sas.c
>> @@ -118,10 +118,8 @@ int pm8001_mem_alloc(struct pci_dev *pdev, void **virt_addr,
>>                 align_offset = (dma_addr_t)align - 1;
>>         mem_virt_alloc = dma_alloc_coherent(&pdev->dev, mem_size + align,
>>                                             &mem_dma_handle, GFP_KERNEL);
>> -       if (!mem_virt_alloc) {
>> -               pr_err("pm80xx: memory allocation error\n");
>> +       if (!mem_virt_alloc)
>>                 return -1;
>> -       }
> while you are at it, can you also fix the return code to -ENOMEM

OK, I will update it.

> 
> 
> Thanks.
> 
> .
> 

