Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCEACE7A88
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Sep 2023 07:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjIXHti (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Sep 2023 03:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjIXHti (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Sep 2023 03:49:38 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D57106;
        Sun, 24 Sep 2023 00:49:30 -0700 (PDT)
Received: from kwepemm000012.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RtdMN6W6KztSZQ;
        Sun, 24 Sep 2023 15:45:04 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm000012.china.huawei.com (7.193.23.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Sun, 24 Sep 2023 15:49:22 +0800
Message-ID: <236310e2-b253-553e-d210-4a4928ed8ec8@huawei.com>
Date:   Sun, 24 Sep 2023 15:49:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/2] scsi: core: cleanup scsi_dev_queue_ready()
Content-Language: en-US
From:   Wenchao Hao <haowenchao2@huawei.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <louhongxiang@huawei.com>
References: <20230922093842.2646157-1-haowenchao2@huawei.com>
 <20230922093842.2646157-2-haowenchao2@huawei.com>
 <ea28de69-8b9d-8ff8-b7fc-eb780123f055@kernel.org>
 <7a11374c-4e8e-b7f9-aca4-55686a6ec501@huawei.com>
In-Reply-To: <7a11374c-4e8e-b7f9-aca4-55686a6ec501@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm000012.china.huawei.com (7.193.23.142)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/9/24 14:27, Wenchao Hao wrote:
> On 2023/9/22 20:50, Damien Le Moal wrote:
>> On 2023/09/22 2:38, Wenchao Hao wrote:
>>> This is just a cleanup for scsi_dev_queue_ready() to avoid
>>> redundant goto and if statement, it did not change the origin
>>> logic.
>>>
>>> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
>>> ---
>>>   drivers/scsi/scsi_lib.c | 35 ++++++++++++++++++-----------------
>>>   1 file changed, 18 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index ca5eb058d5c7..f3e388127dbd 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -1254,28 +1254,29 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
>>>       int token;
>>>       token = sbitmap_get(&sdev->budget_map);
>>> -    if (atomic_read(&sdev->device_blocked)) {
>>> -        if (token < 0)
>>> -            goto out;
>>> +    if (token < 0)
>>> +        return -1;
>>
>> This is changing how this function works...
>>
> 
> I don't think so...
> The origin function flow:
> 
> static inline int scsi_dev_queue_ready(struct request_queue *q,
>                    struct scsi_device *sdev)
> {
>      ...
>      token = sbitmap_get(&sdev->budget_map);
>      if (atomic_read(&sdev->device_blocked)) {
>          if (token < 0)
>              goto out;
>      }
>      return token;
> out:
>      return -1
> }
> 
> If the token is less than 0, it would always return -1. So we can found
> it's not necessary to check token after atomic_read().
> 
>>> -        if (scsi_device_busy(sdev) > 1)
>>> -            goto out_dec;
>>> +    /*
>>> +     * device_blocked is not set at mostly time, so check it first
>>> +     * and return token when it is not set.
>>> +     */
>>> +    if (!atomic_read(&sdev->device_blocked))
>>> +        return token;
>>
>> ...because you reversed the tests order.
> 
> As explained in comment, the device_blocked is not set at mostly time,
> so when it's not set, just return the token.
> 
>>> -        /*
>>> -         * unblock after device_blocked iterates to zero
>>> -         */
>>> -        if (atomic_dec_return(&sdev->device_blocked) > 0)
>>> -            goto out_dec;
>>> -        SCSI_LOG_MLQUEUE(3, sdev_printk(KERN_INFO, sdev,
>>> -                   "unblocking device at zero depth\n"));
>>> +    /*
>>> +     * unblock after device_blocked iterates to zero
>>> +     */
>>> +    if (scsi_device_busy(sdev) > 1 ||
>>> +        atomic_dec_return(&sdev->device_blocked) > 0) {
>>
>> And here too, you are changing how the function works. The atomic_dec may not be
>> done if the first condition is true.
>>
> 
> the origin flow would not call atomic_dec_return() too when condition
> "scsi_device_busy(sdev) > 1" is true like following:
> 
> static inline int scsi_dev_queue_ready(struct request_queue *q,
>                    struct scsi_device *sdev)
> {
>      ...
>      if (atomic_read(&sdev->device_blocked)) {
>          if (scsi_device_busy(sdev) > 1)
>              goto out_dec;
> 
>          /*
>           * unblock after device_blocked iterates to zero
>           */
>          if (atomic_dec_return(&sdev->device_blocked) > 0)
>              goto out_dec;
>          SCSI_LOG_MLQUEUE(3, sdev_printk(KERN_INFO, sdev,
>                     "unblocking device at zero depth\n"));
>      }
>      return token;
> out_dec:
>      if (token >= 0)
>          sbitmap_put(&sdev->budget_map, token);
> out:
>      return -1;
> }
> 
> Here is the function before and after my change:
> 
> The old function:
> static inline int scsi_dev_queue_ready(struct request_queue *q,
>                    struct scsi_device *sdev)
> {
>      int token;
> 
>      token = sbitmap_get(&sdev->budget_map);
>      if (token < 0)
>          return -1;
> 
>      /*
>       * device_blocked is not set at mostly time, so check it first
>       * and return token when it is not set.
>       */
>      if (!atomic_read(&sdev->device_blocked))
>          return token;
> 
>      /*
>       * unblock after device_blocked iterates to zero
>       */
>      if (scsi_device_busy(sdev) > 1 ||
>          atomic_dec_return(&sdev->device_blocked) > 0) {
>          sbitmap_put(&sdev->budget_map, token);
>          return -1;
>      }
> 
>      SCSI_LOG_MLQUEUE(3, sdev_printk(KERN_INFO, sdev,
>               "unblocking device at zero depth\n"));
> 
>      return token;
> }
> 

Sorry, I paste wrong for old function, the old function is:

static inline int scsi_dev_queue_ready(struct request_queue *q,
				  struct scsi_device *sdev)
{
	int token;

	token = sbitmap_get(&sdev->budget_map);
	if (atomic_read(&sdev->device_blocked)) {
		if (token < 0)
			goto out;

		if (scsi_device_busy(sdev) > 1)
			goto out_dec;

		/*
		 * unblock after device_blocked iterates to zero
		 */
		if (atomic_dec_return(&sdev->device_blocked) > 0)
			goto out_dec;
		SCSI_LOG_MLQUEUE(3, sdev_printk(KERN_INFO, sdev,
				   "unblocking device at zero depth\n"));
	}

	return token;
out_dec:
	if (token >= 0)
		sbitmap_put(&sdev->budget_map, token);
out:
	return -1;
}

