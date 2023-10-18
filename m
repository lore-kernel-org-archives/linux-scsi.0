Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 593EECDB474
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 02:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjJRCWV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 22:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjJRCWU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 22:22:20 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D01C6;
        Tue, 17 Oct 2023 19:22:17 -0700 (PDT)
Received: from kwepemm000012.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4S9F0h3hqjz15NJf;
        Wed, 18 Oct 2023 10:19:32 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm000012.china.huawei.com (7.193.23.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 18 Oct 2023 10:22:14 +0800
Message-ID: <3a76730a-d414-c67d-8851-826f86669f2b@huawei.com>
Date:   Wed, 18 Oct 2023 10:22:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 1/2] scsi: core: cleanup scsi_dev_queue_ready()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <louhongxiang@huawei.com>
References: <20231016020847.1270258-1-haowenchao2@huawei.com>
 <20231016020847.1270258-2-haowenchao2@huawei.com>
 <b3334a8c-fb48-4b98-8571-8d85cbd4ed1e@acm.org>
From:   Wenchao Hao <haowenchao2@huawei.com>
In-Reply-To: <b3334a8c-fb48-4b98-8571-8d85cbd4ed1e@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm000012.china.huawei.com (7.193.23.142)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/10/18 5:15, Bart Van Assche wrote:
> On 10/15/23 19:08, Wenchao Hao wrote:
>> +    /*
>> +     * device_blocked is not set at mostly time, so check it first
>> +     * and return token when it is not set.
>> +     */
>> +    if (!atomic_read(&sdev->device_blocked))
>> +        return token;
> 
> This patch looks like an improvement to me. But I don't think that the
> above comment is useful. I propose to move it into the patch
> description.
> 
>> -        /*
>> -         * unblock after device_blocked iterates to zero
>> -         */
>> -        if (atomic_dec_return(&sdev->device_blocked) > 0)
>> -            goto out_dec;
>> -        SCSI_LOG_MLQUEUE(3, sdev_printk(KERN_INFO, sdev,
>> -                   "unblocking device at zero depth\n"));
>> +    /*
>> +     * unblock after device_blocked iterates to zero
>> +     */
>  > +    if (scsi_device_busy(sdev) > 1 ||
>  > +        atomic_dec_return(&sdev->device_blocked) > 0) {
>  > +        sbitmap_put(&sdev->budget_map, token);
>  > +        return -1;
>  >       }
> 
> Please make the above comment match the new code, e.g. by changing it
> into the following: "Only unblock if no other commands are pending and
> if device_blocked has decreased to zero".
> 

OK, would update.

Thanks.

> Thanks,
> 
> Bart.
> 

