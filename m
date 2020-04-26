Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16964C55185
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 02:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01A5A20724
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 02:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgDZCdE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Apr 2020 22:33:04 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2902 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726087AbgDZCdD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Apr 2020 22:33:03 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8F31F761D825DC01E65D;
        Sun, 26 Apr 2020 10:33:01 +0800 (CST)
Received: from [127.0.0.1] (10.166.212.180) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Sun, 26 Apr 2020
 10:32:59 +0800
Subject: Re: [PATCH -next] scsi: aacraid: Use memdup_user() as a cleanup
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <aacraid@microsemi.com>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1587524232-118733-1-git-send-email-zou_wei@huawei.com>
 <yq1wo64bk0x.fsf@oracle.com>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <1a861285-8644-48d3-21c5-69c88e07db6f@huawei.com>
Date:   Sun, 26 Apr 2020 10:32:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <yq1wo64bk0x.fsf@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.212.180]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Thanks for your review and reply.
You are right, it is not equivalent. I will keep the original goto 
cleanup. But the return value is changed to use of PTR_ERR 
(user_srbcmd), and assign it to rcode.
I will send the v2 soon later

On 2020/4/25 6:23, Martin K. Petersen wrote:
> 
> Zou,
> 
>> diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
>> index ffe41bc..1ce1620 100644
>> --- a/drivers/scsi/aacraid/commctrl.c
>> +++ b/drivers/scsi/aacraid/commctrl.c
>> @@ -513,17 +513,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
>>   		goto cleanup;
>>   	}
>>   
>> -	user_srbcmd = kmalloc(fibsize, GFP_KERNEL);
>> -	if (!user_srbcmd) {
>> -		dprintk((KERN_DEBUG"aacraid: Could not make a copy of the srb\n"));
>> -		rcode = -ENOMEM;
>> -		goto cleanup;
>> -	}
>> -	if(copy_from_user(user_srbcmd, user_srb,fibsize)){
>> -		dprintk((KERN_DEBUG"aacraid: Could not copy srb from user\n"));
>> -		rcode = -EFAULT;
>> -		goto cleanup;
>> -	}
>> +	user_srbcmd = memdup_user(user_srb, fibsize);
>> +	if (IS_ERR(user_srbcmd))
>> +		return PTR_ERR(user_srbcmd);
>>   
>>   	flags = user_srbcmd->flags; /* from user in cpu order */
>>   	switch (flags & (SRB_DataIn | SRB_DataOut)) {
> 
> This is not equivalent, is it? The original code does a goto cleanup;
> whereas your patch returns on error.
> 

