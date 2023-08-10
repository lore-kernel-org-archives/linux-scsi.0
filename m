Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E5BC001E0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 11:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbjHJL1M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 07:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjHJL1M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 07:27:12 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE60268A
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 04:27:11 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RM4M633DWzqT0m;
        Thu, 10 Aug 2023 19:24:18 +0800 (CST)
Received: from [10.67.110.142] (10.67.110.142) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 19:27:09 +0800
Message-ID: <75a8e417-24c4-4b64-a865-5af601ad28d9@huawei.com>
Date:   Thu, 10 Aug 2023 19:27:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v2] scsi: core: fix error handling for dev_set_name
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <kay.sievers@vrfy.org>,
        <gregkh@suse.de>, <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>, <bvanassche@acm.org>
References: <20230802031010.14340-1-wangzhu9@huawei.com>
 <f99f03e8-6a12-0a04-a9e4-35bac12b4971@oracle.com>
From:   wangzhu <wangzhu9@huawei.com>
In-Reply-To: <f99f03e8-6a12-0a04-a9e4-35bac12b4971@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.110.142]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a Smatch static checker warning of this commit shown as 
following, please do not consider this patch again.

I'm sorry for the inconvenience for it.


Hello Zhu Wang,

The patch 04b5b5cb0136: "scsi: core: Fix possible memory leak if
device_add() fails" from Aug 3, 2023 (linux-next), leads to the
following Smatch static checker warning:

     drivers/scsi/raid_class.c:255 raid_component_add()
     warn: freeing device managed memory (UAF): 'rc'

drivers/scsi/raid_class.c
    212  static void raid_component_release(struct device *dev)
    213  {
    214          struct raid_component *rc =
    215                  container_of(dev, struct raid_component, dev);
    216          dev_printk(KERN_ERR, rc->dev.parent, "COMPONENT 
RELEASE\n");
    217          put_device(rc->dev.parent);
    218          kfree(rc);
    219  }
    220
    221  int raid_component_add(struct raid_template *r,struct device 
*raid_dev,
    222                         struct device *component_dev)
    223  {
    224          struct device *cdev =
    225 attribute_container_find_class_device(&r->raid_attrs.ac,
    226 raid_dev);
    227          struct raid_component *rc;
    228          struct raid_data *rd = dev_get_drvdata(cdev);
    229          int err;
    230
    231          rc = kzalloc(sizeof(*rc), GFP_KERNEL);
    232          if (!rc)
    233                  return -ENOMEM;
    234
    235          INIT_LIST_HEAD(&rc->node);
    236          device_initialize(&rc->dev);

The comments for device_initialize() say we cannot call kfree(rc) after
this point.

    237          rc->dev.release = raid_component_release;
                                   ^^^^^^^^^^^^^^^^^^^^^^^
 >From this point on calling put_device(&rc->dev) is the same as calling
raid_component_release(&rc->dev);

    238          rc->dev.parent = get_device(component_dev);
    239          rc->num = rd->component_count++;
    240
    241          dev_set_name(&rc->dev, "component-%d", rc->num);
    242          list_add_tail(&rc->node, &rd->component_list);
    243          rc->dev.class = &raid_class.class;
    244          err = device_add(&rc->dev);
    245          if (err)
    246                  goto err_out;
    247
    248          return 0;
    249
    250  err_out:
    251          put_device(&rc->dev);
    252          list_del(&rc->node);
    253          rd->component_count--;
    254          put_device(component_dev);
    255          kfree(rc);

So this code is clearly a double free.  However, fixing it is not
obvious because why does raid_component_release() not call?

     list_del(&rc->node);
     rd->component_count--;

    256          return err;
    257  }

regards,
dan carpenter



On 2023/8/3 0:34, John Garry wrote:
> On 02/08/2023 04:10, Zhu Wang wrote:
>> The driver do not handle the possible returning error of dev_set_name,
>> if it returned fail, some operations should be rollback or there may be
>> possible memory leak. 
>
> What memory are we possibly leaking? Please explain how.
>
>> We use put_device to free the device and use kfree
>> to free the memory in the error handle path.
>
> Much of the core driver code in drivers/base - where dev_set_name() 
> lives - does not check the return code. Why is SCSI special?
>
> I'd say that the core driver code should be fixed up first in terms of 
> usage, and then the rest.
>
> BTW, as I see, dev_set_name() only fails for a small memory alloc 
> failure. If memory alloc failure like this occurs, then things are not 
> going to work properly anyway. Just not having the device name set 
> should not make things worse.
>
>>
>> Fixes: 71610f55fa4d ("[SCSI] struct device - replace bus_id with 
>> dev_name(), dev_set_name()")
>> Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
>> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>>
>> ---
>> Changes in v2:
>> - Add put_device(parent) in the error path.
>> ---
>>   drivers/scsi/scsi_scan.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index aa13feb17c62..de7e503bfcab 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -509,7 +509,14 @@ static struct scsi_target 
>> *scsi_alloc_target(struct device *parent,
>>       device_initialize(dev);
>>       kref_init(&starget->reap_ref);
>>       dev->parent = get_device(parent);
>> -    dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
>> +    error = dev_set_name(dev, "target%d:%d:%d", shost->host_no, 
>> channel, id);
>> +    if (error) {
>> +        dev_err(dev, "%s: dev_set_name failed, error %d\n", 
>> __func__, error);
>
> Ironically dev_err() is used, but the dev name could not be set. And 
> this dev has no init_name. So how does the print look in practice?
>
>> +        put_device(parent);
>> +        put_device(dev);
>> +        kfree(starget);
>> +        return NULL;
>> +    }
>>       dev->bus = &scsi_bus_type;
>>       dev->type = &scsi_target_type;
>>       scsi_enable_async_suspend(dev);
>
> Thanks,
> John
>
