Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FCEC4743C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 11:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B55EE61075
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 11:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhFWLGm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 07:06:42 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3303 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhFWLGi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 07:06:38 -0400
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4G90Rc3ljXz6H840;
        Wed, 23 Jun 2021 18:50:52 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 13:04:19 +0200
Received: from [10.47.89.126] (10.47.89.126) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 23 Jun
 2021 12:04:19 +0100
Subject: Re: [PATCH 03/18] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-4-hare@suse.de>
 <d9c7f79f-f0ec-a420-517c-d6ca83d99ef9@acm.org>
 <e2b24fd6-fe1b-ac5e-e370-93900d98ac90@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4ba63914-e308-ca62-8562-c0779a7ed05c@huawei.com>
Date:   Wed, 23 Jun 2021 11:57:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <e2b24fd6-fe1b-ac5e-e370-93900d98ac90@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.89.126]
X-ClientProxiedBy: lhreml721-chm.china.huawei.com (10.201.108.72) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/05/2021 07:12, Hannes Reinecke wrote:
> On 5/4/21 4:21 AM, Bart Van Assche wrote:
>> On 5/3/21 8:03 AM, Hannes Reinecke wrote:
>>> +/**
>>> + * scsi_get_internal_cmd - allocate an internal SCSI command
>>> + * @sdev: SCSI device from which to allocate the command
>>> + * @op: operation (REQ_OP_SCSI_IN or REQ_OP_SCSI_OUT)
>>> + * @flags: BLK_MQ_REQ_* flags, e.g. BLK_MQ_REQ_NOWAIT.
>>> + *
>>> + * Allocates a SCSI command for internal LLDD use.
>>> + */
>>> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>>> +    unsigned int op, blk_mq_req_flags_t flags)
>>> +{
>>> +    struct request *rq;
>>> +    struct scsi_cmnd *scmd;
>>> +
>>> +    WARN_ON_ONCE(((op & REQ_OP_MASK) != REQ_OP_SCSI_IN) &&
>>> +             ((op & REQ_OP_MASK) != REQ_OP_SCSI_OUT));
>>> +    rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
>>> +    if (IS_ERR(rq))
>>> +        return NULL;
>>> +    scmd = blk_mq_rq_to_pdu(rq);
>>> +    scmd->request = rq;
>>> +    scmd->device = sdev;
>>> +    return scmd;
>>> +}
>>> +EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);
>>
>> Multiple fields that are initialized by the regular command submission
>> path are not initialized by the above function, e.g. scmd->tag. Has it
>> been considered to call scsi_init_command() instead of adding yet
>> another code path that initializes scmd->request?
>>
> Hmm. No, I don't think it's a good idea.
> Basic idea is that the SCSI request serves as a container for (non-SCSI) 
> management commands, _and_ that they are submitted directly from within 
> the driver, ie never ever enter ->queue_rq().
> As such we don't need an initialisation vie scsi_init_request(), and it 
> would actually be counter-productive as we would be setting up fields 
> which we'll never need anyway, and might need to tear down afterwards.

I will note that we also bypass the queue budgeting in 
blk_mq_ops.{get,put}_budget. I figure that is not an issue...

BTW, any chance of a new version?

Thanks,
John
