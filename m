Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25107C56201
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 01:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8A2821534
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 01:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731469AbgKZB1p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 20:27:45 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8402 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730067AbgKZB1p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2020 20:27:45 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4ChKqs5czRz73q7;
        Thu, 26 Nov 2020 09:27:21 +0800 (CST)
Received: from [10.174.177.149] (10.174.177.149) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 26 Nov 2020 09:27:41 +0800
Subject: Re: [PATCH] scsi: zfcp: fix use-after-free in zfcp_unit_remove
To:     Benjamin Block <bblock@linux.ibm.com>
CC:     Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        <linux-s390@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
References: <20201120074854.31754-1-miaoqinglang@huawei.com>
 <20201125170658.GB8578@t480-pf1aa2c2>
From:   Qinglang Miao <miaoqinglang@huawei.com>
Message-ID: <4c65bead-2553-171e-54d2-87a9de0330e8@huawei.com>
Date:   Thu, 26 Nov 2020 09:27:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20201125170658.GB8578@t480-pf1aa2c2>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.149]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



ÔÚ 2020/11/26 1:06, Benjamin Block Ð´µÀ:
> On Fri, Nov 20, 2020 at 03:48:54PM +0800, Qinglang Miao wrote:
>> kfree(port) is called in put_device(&port->dev) so that following
>> use would cause use-after-free bug.
>>
>> The former put_device is redundant for device_unregister contains
>> put_device already. So just remove it to fix this.
>>
>> Fixes: 86bdf218a717 ("[SCSI] zfcp: cleanup unit sysfs attribute usage")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
>> ---
>>   drivers/s390/scsi/zfcp_unit.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_unit.c
>> index e67bf7388..664b77853 100644
>> --- a/drivers/s390/scsi/zfcp_unit.c
>> +++ b/drivers/s390/scsi/zfcp_unit.c
>> @@ -255,8 +255,6 @@ int zfcp_unit_remove(struct zfcp_port *port, u64 fcp_lun)
>>   		scsi_device_put(sdev);
>>   	}
>>   
>> -	put_device(&unit->dev);
>> -
>>   	device_unregister(&unit->dev);
>>  >>   	return 0;
> 
> Same as in the other mail for `zfcp_sysfs_port_remove_store()`. We
> explicitly get a new ref in `_zfcp_unit_find()`, so we also need to put
> that away again.
>
Sorry, Benjamin, I don't think so, because device_unregister calls 
put_device inside.

It seem's that another put_device before or after device_unregister is 
useless and even might cause an use-after-free.

