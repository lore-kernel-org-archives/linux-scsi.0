Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797ECC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 15:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F9C564ED1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 15:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbhBXPox (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 10:44:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:44106 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234878AbhBXOgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Feb 2021 09:36:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A8F48AD5C;
        Wed, 24 Feb 2021 14:35:45 +0000 (UTC)
Subject: Re: [PATCH 08/31] scsi: revamp host device handling
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
References: <20210222132405.91369-1-hare@suse.de>
 <20210222132405.91369-9-hare@suse.de>
 <f612cac5-6dce-45af-1a9e-da32ddbeaa54@huawei.com>
 <facfb988-9224-b78e-c6e1-935dabe98747@suse.de>
 <ff3bf318-0eef-bdbb-9364-d17dc17cbde0@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2f56f2f5-d0fd-e3b7-4472-fb345dc3a59f@suse.de>
Date:   Wed, 24 Feb 2021 15:35:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <ff3bf318-0eef-bdbb-9364-d17dc17cbde0@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/24/21 3:31 PM, John Garry wrote:
> On 24/02/2021 14:24, Hannes Reinecke wrote:
>> On 2/24/21 2:12 PM, John Garry wrote:
>>> On 22/02/2021 13:23, Hannes Reinecke wrote:
>>>>    void scsi_forget_host(struct Scsi_Host *shost)
>>>>    {
>>>> -    struct scsi_device *sdev;
>>>> +    struct scsi_device *sdev, *host_sdev = NULL;
>>>>        unsigned long flags;
>>>>       restart:
>>>>        spin_lock_irqsave(shost->host_lock, flags);
>>>>        list_for_each_entry(sdev, &shost->__devices, siblings) {
>>>> +        if (scsi_device_is_host_dev(sdev)) {
>>>> +            host_sdev = sdev;
>>> Is there actually a limit of 1x host_sdev always?
>>>
>> I would have thought so, as the whole point of having a host device is
>> that you have a (virtual) device which simulates access to the host
>> itself.
>> And as such has a 1:1 relationship to the HBA.
> 
> Sure, but I think that each call to scsi_get_host_dev() for the same
> host will give a new sdev each time, right?
> 
> We should protect against what is sensible and what is possible - not
> always the same :)
> 
The original implementation, yes.
With my patch series, no.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
