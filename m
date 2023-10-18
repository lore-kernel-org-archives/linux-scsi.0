Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C64CDB474
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 02:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjJRCYf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 22:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjJRCYe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 22:24:34 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A869C6;
        Tue, 17 Oct 2023 19:24:32 -0700 (PDT)
Received: from kwepemm000012.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4S9F1l3jb5zCrTt;
        Wed, 18 Oct 2023 10:20:27 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm000012.china.huawei.com (7.193.23.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 18 Oct 2023 10:24:26 +0800
Message-ID: <24a3427e-d0dd-4f77-0342-71f0296135be@huawei.com>
Date:   Wed, 18 Oct 2023 10:24:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 2/2] scsi: Add comment of target_destroy in
 scsi_host_template
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <louhongxiang@huawei.com>
References: <20231016020847.1270258-1-haowenchao2@huawei.com>
 <20231016020847.1270258-3-haowenchao2@huawei.com>
 <128adc0e-3a91-4395-b373-ef77a0882f29@acm.org>
From:   Wenchao Hao <haowenchao2@huawei.com>
In-Reply-To: <128adc0e-3a91-4395-b373-ef77a0882f29@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm000012.china.huawei.com (7.193.23.142)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/10/18 5:04, Bart Van Assche wrote:
> On 10/15/23 19:08, Wenchao Hao wrote:
>> Add comment to tell callback function target_destroy of
>> scsi_host_template is called in atomic context.
>>
>> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
>> ---
>>   include/scsi/scsi_host.h | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>> index 49f768d0ff37..2e8d77441064 100644
>> --- a/include/scsi/scsi_host.h
>> +++ b/include/scsi/scsi_host.h
>> @@ -245,6 +245,9 @@ struct scsi_host_template {
>>        * midlayer calls this point so that the driver may deallocate
>>        * and terminate any references to the target.
>>        *
>> +     * Note: this callback in called with spin_lock shost->host_lock held,
>> +     * so donot call functions might cause schedule
>> +     *
>>        * Status: OPTIONAL
>>        */
>>       void (* target_destroy)(struct scsi_target *);
> 
> The above comment can be made shorter and spelling and grammar can be improved. How about the following: "This callback is called with the host lock held and hence must not sleep."?
> 

Looks better, I would update.

Thanks.

> Thanks,
> 
> Bart.
> 

