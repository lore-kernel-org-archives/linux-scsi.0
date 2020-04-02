Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97EA3C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 01:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 732F620675
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 01:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbgDBBUJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Apr 2020 21:20:09 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60350 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732498AbgDBBUJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Apr 2020 21:20:09 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 06DC9F0920E2BBBBEC55;
        Thu,  2 Apr 2020 09:20:04 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.195) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Apr 2020
 09:19:55 +0800
Subject: Re: [PATCH] scsi: remove show_use_blk_mq()
To:     John Garry <john.garry@huawei.com>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>
References: <20200401134049.9352-1-yanaijie@huawei.com>
 <57f6fde1-fe0c-68e7-f476-35d92902c6b1@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <ba97c964-1da2-e465-f472-dce50dcfd3f6@huawei.com>
Date:   Thu, 2 Apr 2020 09:19:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <57f6fde1-fe0c-68e7-f476-35d92902c6b1@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.195]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2020/4/1 21:51, John Garry 写道:
> On 01/04/2020 14:40, Jason Yan wrote:
>> This code is useless now so remove it.
>>
> 
> note: I did not delete this in "scsi: core: Delete scsi_use_blk_mq", to 
> avoid risk of breaking some user still using this
> 

Maybe. But removing a module param may break the user space too.
Actually when the legacy path of single queue is removed, plenty of sys
attributes have been removed. And this one needs to go sooner or later.

> thanks,
> John
> 
>> Cc: Ewan D. Milne <emilne@redhat.com>
>> Cc: Christoph Hellwig <hch@lst.de>,
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Bart Van Assche <bvanassche@acm.org>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Cc: John Garry <john.garry@huawei.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   drivers/scsi/scsi_sysfs.c | 8 --------
>>   1 file changed, 8 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 163dbcb741c1..6480e27982ab 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -386,15 +386,7 @@ show_host_busy(struct device *dev, struct 
>> device_attribute *attr, char *buf)
>>   }
>>   static DEVICE_ATTR(host_busy, S_IRUGO, show_host_busy, NULL);
>> -static ssize_t
>> -show_use_blk_mq(struct device *dev, struct device_attribute *attr, 
>> char *buf)
>> -{
>> -    return sprintf(buf, "1\n");
>> -}
>> -static DEVICE_ATTR(use_blk_mq, S_IRUGO, show_use_blk_mq, NULL);
>> -
>>   static struct attribute *scsi_sysfs_shost_attrs[] = {
>> -    &dev_attr_use_blk_mq.attr,
>>       &dev_attr_unique_id.attr,
>>       &dev_attr_host_busy.attr,
>>       &dev_attr_cmd_per_lun.attr,
>>
> 
> 
> .

