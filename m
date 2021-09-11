Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330C3C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 01:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03E91611AD
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 01:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhIKBmY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 21:42:24 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9028 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbhIKBmU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 21:42:20 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H5wRH077jzVmty;
        Sat, 11 Sep 2021 09:40:11 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Sat, 11 Sep 2021 09:41:06 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Sat, 11 Sep 2021 09:41:04 +0800
Subject: Re: [PATCH] scsi: bsg: Fix device unregistration
To:     Johan Hovold <johan@kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <fujita.tomonori@lab.ntt.co.jp>,
        <axboe@kernel.dk>, <martin.petersen@oracle.com>, <hch@lst.de>,
        <gregkh@linuxfoundation.org>, <wanghaibin.wang@huawei.com>
References: <20210909034608.1435-1-yuzenghui@huawei.com>
 <YTtTU4+DZEb4WRkR@hovoldconsulting.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <0506e034-e186-a73b-3046-6b0e1f397756@huawei.com>
Date:   Sat, 11 Sep 2021 09:41:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <YTtTU4+DZEb4WRkR@hovoldconsulting.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/9/10 20:45, Johan Hovold wrote:
> On Thu, Sep 09, 2021 at 11:46:08AM +0800, Zenghui Yu wrote:

>> @@ -218,6 +226,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
>>  out_device_del:
>>  	cdev_device_del(&bd->cdev, &bd->device);
>>  out_ida_remove:
>> +	put_device(&bd->device);
>>  	ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
>>  out_kfree:
>>  	kfree(bd);
> 
> Ehh, what about the blatant use-after-free and double-free you just
> added here?

Yeah, whoops. That's definitely wrong. I'm squash the following fix
in this patch.

Thanks for the heads up!

|diff --git a/block/bsg.c b/block/bsg.c
|index c3bb92b9af7e..882f56bff14f 100644
|--- a/block/bsg.c
|+++ b/block/bsg.c
|@@ -200,7 +200,8 @@ struct bsg_device *bsg_register_queue(struct 
request_queue *q,
|        if (ret < 0) {
|                if (ret == -ENOSPC)
|                        dev_err(parent, "bsg: too many bsg devices\n");
|-               goto out_kfree;
|+               kfree(bd);
|+               return ERR_PTR(ret);
|        }
|        bd->device.devt = MKDEV(bsg_major, ret);
|        bd->device.class = bsg_class;
|@@ -213,7 +214,7 @@ struct bsg_device *bsg_register_queue(struct 
request_queue *q,
|        bd->cdev.owner = THIS_MODULE;
|        ret = cdev_device_add(&bd->cdev, &bd->device);
|        if (ret)
|-               goto out_ida_remove;
|+               goto out_put_device;
|
|        if (q->kobj.sd) {
|                ret = sysfs_create_link(&q->kobj, &bd->device.kobj, "bsg");
|@@ -225,11 +226,8 @@ struct bsg_device *bsg_register_queue(struct 
request_queue *q,
|
| out_device_del:
|        cdev_device_del(&bd->cdev, &bd->device);
|-out_ida_remove:
|+out_put_device:
|        put_device(&bd->device);
|-       ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
|-out_kfree:
|-       kfree(bd);
|        return ERR_PTR(ret);
| }
| EXPORT_SYMBOL_GPL(bsg_register_queue);
