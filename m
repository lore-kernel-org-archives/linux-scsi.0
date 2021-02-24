Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7308C4332D
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 15:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71AD564EDD
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 15:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbhBXPpe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 10:45:34 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2604 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbhBXOyr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 09:54:47 -0500
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Dlyw34JSfz67nc8;
        Wed, 24 Feb 2021 22:28:51 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 24 Feb 2021 15:32:53 +0100
Received: from [10.47.6.193] (10.47.6.193) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 24 Feb
 2021 14:32:52 +0000
Subject: Re: [PATCH 08/31] scsi: revamp host device handling
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, <linux-scsi@vger.kernel.org>
References: <20210222132405.91369-1-hare@suse.de>
 <20210222132405.91369-9-hare@suse.de>
 <f612cac5-6dce-45af-1a9e-da32ddbeaa54@huawei.com>
 <facfb988-9224-b78e-c6e1-935dabe98747@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <ff3bf318-0eef-bdbb-9364-d17dc17cbde0@huawei.com>
Date:   Wed, 24 Feb 2021 14:31:04 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <facfb988-9224-b78e-c6e1-935dabe98747@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.6.193]
X-ClientProxiedBy: lhreml723-chm.china.huawei.com (10.201.108.74) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/02/2021 14:24, Hannes Reinecke wrote:
> On 2/24/21 2:12 PM, John Garry wrote:
>> On 22/02/2021 13:23, Hannes Reinecke wrote:
>>>    void scsi_forget_host(struct Scsi_Host *shost)
>>>    {
>>> -    struct scsi_device *sdev;
>>> +    struct scsi_device *sdev, *host_sdev = NULL;
>>>        unsigned long flags;
>>>       restart:
>>>        spin_lock_irqsave(shost->host_lock, flags);
>>>        list_for_each_entry(sdev, &shost->__devices, siblings) {
>>> +        if (scsi_device_is_host_dev(sdev)) {
>>> +            host_sdev = sdev;
>> Is there actually a limit of 1x host_sdev always?
>>
> I would have thought so, as the whole point of having a host device is
> that you have a (virtual) device which simulates access to the host itself.
> And as such has a 1:1 relationship to the HBA.

Sure, but I think that each call to scsi_get_host_dev() for the same 
host will give a new sdev each time, right?

We should protect against what is sensible and what is possible - not 
always the same :)

Thanks,
John
