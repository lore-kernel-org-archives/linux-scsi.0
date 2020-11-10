Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F410C5517A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 01:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E14EF20867
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 01:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbgKJBTW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 20:19:22 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7473 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKJBTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 20:19:22 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CVVPv3CvRzhjt7;
        Tue, 10 Nov 2020 09:19:15 +0800 (CST)
Received: from [10.174.177.149] (10.174.177.149) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Tue, 10 Nov 2020 09:19:18 +0800
Subject: Re: [PATCH] scsi: ufshcd: fix missing destroy_workqueue() on error in
 ufshcd_init
To:     Avri Altman <Avri.Altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20201109091522.55989-1-miaoqinglang@huawei.com>
 <DM6PR04MB6575DEC0E343A01B1A4D275AFCEA0@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Qinglang Miao <miaoqinglang@huawei.com>
Message-ID: <c6b7a6a2-3327-cc50-d593-abaaa58c0da2@huawei.com>
Date:   Tue, 10 Nov 2020 09:19:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB6575DEC0E343A01B1A4D275AFCEA0@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.149]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



ÔÚ 2020/11/9 17:40, Avri Altman Ð´µÀ:
>>
>> Add the missing destroy_workqueue() before return from
>> ufshcd_init in the error handling case. It seems that
>> exit_gating is an appropriate place.
>>
>> Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and other
>> error recovery paths")
>> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
>> ---
>>   drivers/scsi/ufs/ufshcd.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index b8f573a02713..9eaa0eaca374 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -9206,6 +9206,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
>> *mmio_base, unsigned int irq)
>>   exit_gating:
>>          ufshcd_exit_clk_scaling(hba);
>>          ufshcd_exit_clk_gating(hba);
>> +       destroy_workqueue(hba->eh_wq);
> Maybe also in ufshcd_remove?
> .
You're right Avri, thanks!

I'm gonna send a v2 on this patch to cover ufshcd_remove.
> 
