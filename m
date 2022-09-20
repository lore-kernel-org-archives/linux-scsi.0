Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74EDC54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Sep 2022 08:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiITIHp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Sep 2022 04:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiITIGZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2022 04:06:25 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA21F6564D
        for <linux-scsi@vger.kernel.org>; Tue, 20 Sep 2022 01:03:36 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MWv8X3XhHzcn2X;
        Tue, 20 Sep 2022 15:59:40 +0800 (CST)
Received: from dggpeml500019.china.huawei.com (7.185.36.137) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 16:03:34 +0800
Received: from [10.174.179.189] (10.174.179.189) by
 dggpeml500019.china.huawei.com (7.185.36.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 16:03:34 +0800
Message-ID: <306f0d31-5fc2-8ed4-eded-f0c280c5f63d@huawei.com>
Date:   Tue, 20 Sep 2022 16:03:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] scsi: core: Add io timeout count for scsi device
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        <qiuchangqi.qiu@huawei.com>
References: <32aff63d-1b79-916a-50e2-1e6c113ed9ef@huawei.com>
 <44e17063-3e69-98b8-b6e8-b73f8e449715@acm.org>
From:   Wu Bo <wubo40@huawei.com>
In-Reply-To: <44e17063-3e69-98b8-b6e8-b73f8e449715@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.189]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500019.china.huawei.com (7.185.36.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/9/17 0:19, Bart Van Assche wrote:
> On 9/15/22 19:01, Wu Bo wrote:
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 448748e..e84aea9 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -334,6 +334,7 @@ enum blk_eh_timer_return scsi_timeout(struct 
>> request *req)
>>          trace_scsi_dispatch_cmd_timeout(scmd);
>>          scsi_log_completion(scmd, TIMEOUT_ERROR);
>>
>> +       atomic_inc(&scmd->device->iotmo_cnt);
>>          if (host->eh_deadline != -1 && !host->last_reset)
>>                  host->last_reset = jiffies;
> 
> Please rebase this patch on top of Martin's for-next branch and repost 
> this patch. I cannot apply this patch with "git am" on Martin's for-next 
> branch.
> 
> Thanks,
> 
> Bart.
> 
> 
> .
Sorry. I will repost the patch.

Thanks,

Wu Bo.
