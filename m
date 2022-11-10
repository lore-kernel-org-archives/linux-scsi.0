Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A5D2C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 00:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiKJA6x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbiKJA6U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 19:58:20 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F18C20F56;
        Wed,  9 Nov 2022 16:58:11 -0800 (PST)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N73K728lyzJnY1;
        Thu, 10 Nov 2022 08:55:07 +0800 (CST)
Received: from [10.169.59.127] (10.169.59.127) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 08:58:08 +0800
Subject: Re: [PATCH 3/3] nvme: Convert NVMe errors to PT_STS errors
To:     Mike Christie <michael.christie@oracle.com>, <kbusch@kernel.org>,
        <axboe@fb.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-block@vger.kernel.org>
References: <20221109031106.201324-1-michael.christie@oracle.com>
 <20221109031106.201324-4-michael.christie@oracle.com>
 <9df9d0cf-5583-ccfd-ffd7-54432767fdfb@huawei.com>
 <cd524e32-d154-cd67-39b0-5f153a84125a@oracle.com>
From:   Chao Leng <lengchao@huawei.com>
Message-ID: <6396da68-5c87-a36d-b013-2d2fe36a8d52@huawei.com>
Date:   Thu, 10 Nov 2022 08:58:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <cd524e32-d154-cd67-39b0-5f153a84125a@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.169.59.127]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2022/11/10 1:35, Mike Christie wrote:
> On 11/9/22 2:28 AM, Chao Leng wrote:
>>
>>
>> On 2022/11/9 11:11, Mike Christie wrote:
>>> This converts the NVMe errors we could see during PR handling to PT_STS
>>> errors, so pr_ops callers can handle scsi and nvme errors without knowing
>>> the device types.
>>>
>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>> ---
>>>    drivers/nvme/host/core.c | 42 ++++++++++++++++++++++++++++++++++++++--
>>>    1 file changed, 40 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
>>> index dc4220600585..8f0177045a2f 100644
>>> --- a/drivers/nvme/host/core.c
>>> +++ b/drivers/nvme/host/core.c
>>> @@ -2104,11 +2104,43 @@ static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
>>>        return nvme_submit_sync_cmd(ns->queue, c, data, 16);
>>>    }
>>>    +static enum pr_status nvme_sc_to_pr_status(int nvme_sc)
>>> +{
>>> +    enum pr_status sts;
>>> +
>>> +    switch (nvme_sc) {
>>> +    case NVME_SC_SUCCESS:
>>> +        sts = PR_STS_SUCCESS;
>>> +        break;
>>> +    case NVME_SC_RESERVATION_CONFLICT:
>>> +        sts = PR_STS_RESERVATION_CONFLICT;
>>> +        break;
>>> +    case NVME_SC_HOST_PATH_ERROR:
>>> +        sts = PR_STS_PATH_FAILED;
>> All path-related errors should be considered.
> 
> Will do. Just one question.
> 
> I didn't see NVME_SC_CTRL_PATH_ERROR and NVME_SC_INTERNAL_PATH_ERROR
> being used. Are they retryable errors?
These two types of errors depend on the implementation of the target.
All in all, the request with path-related error should fail over to retry successfully.
