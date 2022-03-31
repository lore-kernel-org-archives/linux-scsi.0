Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BFDC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 12:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbiCaMQn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 08:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbiCaMQl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 08:16:41 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8751A41629;
        Thu, 31 Mar 2022 05:14:54 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KThyG6nltzCr6F;
        Thu, 31 Mar 2022 20:12:38 +0800 (CST)
Received: from dggpemm500017.china.huawei.com (7.185.36.178) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 31 Mar 2022 20:14:52 +0800
Received: from [10.174.178.220] (10.174.178.220) by
 dggpemm500017.china.huawei.com (7.185.36.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 31 Mar 2022 20:14:52 +0800
Subject: Re: [PATCH] scsi: sd: call device_del() if device_add_disk() fails
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     <fmdefrancesco@gmail.com>, <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <syzbot+f08c77040fa163a75a46@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>, <linfeilong@huawei.com>
References: <20220329154948.10350-1-fmdefrancesco@gmail.com>
 <20220331152622.616534-1-haowenchao@huawei.com> <20220331054156.GI3293@kadam>
From:   Wenchao Hao <haowenchao@huawei.com>
Message-ID: <fdebdbd3-575b-b30e-d37f-dcc6d53a4f53@huawei.com>
Date:   Thu, 31 Mar 2022 20:14:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20220331054156.GI3293@kadam>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500017.china.huawei.com (7.185.36.178)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/3/31 13:41, Dan Carpenter wrote:
> On Thu, Mar 31, 2022 at 11:26:22AM -0400, 'Wenchao Hao' via syzkaller-bugs wrote:
>> I do not think it's necessary to call device_del() on this path. If the device
>> has been added, put_device() would delete it from sysfs. So the origin error
>> handle is ok with me.
>>
> 
> No.  The original is buggy and it was detected at runtime by syzbot.
> It's not static analysis, it is an actual bug found in testing.
> 
Yes, it's a bug, but the root reason is not we forget to call 
device_del(sdkp->disk_dev). It's because we did not cleanup gendisk.
The leak memory is allocated in elevator_init_mq(), we should clean
this memory via blk_cleanup_queue().

I summit a patch which would fix this memory leak:

https://lore.kernel.org/linux-scsi/20220401011018.1026553-1-haowenchao@huawei.com/T/#u

> The device_put() unwinds device_initialize().  The device_del() unwinds
> device_add().  Take a look at the comments to device_add() or take a
> look at how device_register/unregister() work.
> 

You may read the implement of put_device(), it is based on kobj_xxx.
If the kobj is still in sysfs, a cleanup would be performed.
And device_del() seems would not decrease the reference count of kobj,
the main aim is to make it invisibleto sysfs.
