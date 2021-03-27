Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D96C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Mar 2021 06:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 506AF6197C
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Mar 2021 06:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhC0G6Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Mar 2021 02:58:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14629 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhC0G5p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Mar 2021 02:57:45 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6qNt4Xknz1BJr5;
        Sat, 27 Mar 2021 14:55:42 +0800 (CST)
Received: from [10.174.179.92] (10.174.179.92) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 14:57:43 +0800
Subject: Re: [PATCH 1/3] scsi: check the whole result for reading write
 protect flag
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <axboe@kernel.dk>, <ming.lei@redhat.com>, <hch@lst.de>,
        <keescook@chromium.org>, <kbusch@kernel.org>,
        <linux-block@vger.kernel.org>, <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>
References: <20210319030128.1345061-1-yanaijie@huawei.com>
 <20210319030128.1345061-2-yanaijie@huawei.com>
 <yq1a6qskl3j.fsf@ca-mkp.ca.oracle.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <5fc4fa59-cbdc-190b-8c7b-4be1a4f37557@huawei.com>
Date:   Sat, 27 Mar 2021 14:57:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <yq1a6qskl3j.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.92]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

ÔÚ 2021/3/25 10:50, Martin K. Petersen Ð´µÀ:
> 
> Hi Jason!
> 
>> @@ -55,6 +55,19 @@ static inline int scsi_status_is_good(int status)
>>   		(status == SAM_STAT_COMMAND_TERMINATED));
>>   }
>>   
>> +/** scsi_result_is_good - check the result return.
>> + *
>> + * @result: the result passed up from the driver (including host and
>> + *          driver components)
>> + *
>> + * Drivers may only set other bytes but not status byte.
>> + * This checks both the status byte and other bytes.
>> + */
>> +static inline int scsi_result_is_good(int result)
>> +{
>> +	return scsi_status_is_good(result) && (result & ~0xff) == 0;
>> +}
>> +
>>   
>>   /*
>>    * standard mode-select header prepended to all mode-select commands
> 
> Instead of introducing a "don't be broken" variant of
> scsi_status_is_good(), I'd prefer you to fix the latter to do the right
> thing wrt. offline devices.
> 
> There aren't a ton of scsi_result_is_good() call sites to check. And I
> suspect that most of them wouldn't actually consider the DID_NO_CONNECT
> scenario to be "good".
> 

OK, I'll have a try and check if it works for most of the call sites.

Thanks,
Jason
