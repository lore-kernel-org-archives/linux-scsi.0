Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEFEC4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 07:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiLHHV1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 02:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiLHHVY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 02:21:24 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46F542F42
        for <linux-scsi@vger.kernel.org>; Wed,  7 Dec 2022 23:21:23 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NSQT326v6zqSrK;
        Thu,  8 Dec 2022 15:17:11 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 15:21:21 +0800
Subject: Re: [PATCH 4/6] scsi: libsas: remove useless dev_list delete in
 sas_ex_discover_end_dev()
To:     John Garry <john.g.garry@oracle.com>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>
References: <20221204081643.3835966-1-yanaijie@huawei.com>
 <20221204081643.3835966-5-yanaijie@huawei.com>
 <aaeef818-97d6-6f38-4a10-36a5d5473b50@oracle.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <1a1f0169-bb89-c9fb-b26a-f8c03c669bd3@huawei.com>
Date:   Thu, 8 Dec 2022 15:21:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <aaeef818-97d6-6f38-4a10-36a5d5473b50@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/5 17:14, John Garry wrote:
> On 04/12/2022 08:16, Jason Yan wrote:
>> The domain device 'child' is allocated in sas_ex_discover_end_dev() and
>> never been added to dev_list. So remove the useless list_del() and
>> related locks.
>>
>> Cc: John Garry <john.g.garry@oracle.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   drivers/scsi/libsas/sas_expander.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c 
>> b/drivers/scsi/libsas/sas_expander.c
>> index a8af723fab3c..82ea7560a888 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -875,9 +875,6 @@ static struct domain_device *sas_ex_discover_end_dev(
>>    out_list_del:
>>       sas_rphy_free(child->rphy);
>>       list_del(&child->disco_list_node);
>> -    spin_lock_irq(&parent->port->dev_list_lock);
>> -    list_del(&child->dev_list_node);
>> -    spin_unlock_irq(&parent->port->dev_list_lock);
> 
> Since we have the spin lock'ing, this seems to be have been 
> intentionally added (and not some simple typo or similar) - any idea of 
> the origin?

The new device used to be added to the dev_list in this function. But 
after 92625f9bff38 ("[SCSI] libsas: restore scan order") and 
87c8331fcf72 ("[SCSI] libsas: prevent domain rediscovery competing with 
ata error handling") it is added to the disco_list instead. But the 
list_del() and locking is forgot to be removed.

Thanks,
Jason
