Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0FF3C433E5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 08:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7E7C2074B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 08:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgGPINx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 04:13:53 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51374 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725831AbgGPINw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jul 2020 04:13:52 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 53DAB79A73CA35C5FB37;
        Thu, 16 Jul 2020 16:13:48 +0800 (CST)
Received: from [10.174.179.105] (10.174.179.105) by smtp.huawei.com
 (10.3.19.212) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 16 Jul
 2020 16:13:46 +0800
Subject: Re: [PATCH v2] scsi: fcoe: add missed kfree() in an error path
To:     "Ewan D. Milne" <emilne@redhat.com>, <hare@suse.de>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <robert.w.love@intel.com>, <Neerav.Parikh@intel.com>,
        <Markus.Elfring@web.de>
References: <20200709120546.38453-1-jingxiangfeng@huawei.com>
 <d1fa9e60b559b6bf3a37ef5a6aef2bd7bd6e1681.camel@redhat.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
Message-ID: <5F100C39.5070503@huawei.com>
Date:   Thu, 16 Jul 2020 16:13:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <d1fa9e60b559b6bf3a37ef5a6aef2bd7bd6e1681.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.105]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2020/7/14 1:53, Ewan D. Milne wrote:
> See below.
>
> On Thu, 2020-07-09 at 20:05 +0800, Jing Xiangfeng wrote:
>> fcoe_fdmi_info() misses to call kfree() in an error path.
>> Add a label 'free_fdmi' and jump to it.
>>
>> Fixes: f07d46bbc9ba ("fcoe: Fix smatch warning in fcoe_fdmi_info
>> function")
>> Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
>> ---
>>   drivers/scsi/fcoe/fcoe.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
>> index 25dae9f0b205..a63057a03772 100644
>> --- a/drivers/scsi/fcoe/fcoe.c
>> +++ b/drivers/scsi/fcoe/fcoe.c
>> @@ -830,7 +830,7 @@ static void fcoe_fdmi_info(struct fc_lport
>> *lport, struct net_device *netdev)
>>   		if (rc) {
>>   			printk(KERN_INFO "fcoe: Failed to retrieve FDMI
>> "
>>   					"information from netdev.\n");
>> -			return;
>> +			goto free_fdmi;
>>   		}
>>
>>   		snprintf(fc_host_serial_number(lport->host),
>> @@ -868,6 +868,7 @@ static void fcoe_fdmi_info(struct fc_lport
>> *lport, struct net_device *netdev)
>>
>>   		/* Enable FDMI lport states */
>>   		lport->fdmi_enabled = 1;
>> +free_fdmi:
>>   		kfree(fdmi);
>>   	} else {
>>   		lport->fdmi_enabled = 0;
>
> Normally I would like to see goto labels for error paths outside
> conditionals and at the end of the function.

I agree.

  In this case it would
> seem to be cleaner to put an else { } clause in the if (rc) above
> around the snprintf() calls.

It is ok with me. v1 is also a simpler way.

+Hannes, Which is preferable?

Thanks

>
> -Ewan
>
> .
>
