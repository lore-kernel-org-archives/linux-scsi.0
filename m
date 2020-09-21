Return-Path: <SRS0=3eE7=C6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93F1C43465
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 06:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59ABF20866
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 06:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgIUGAx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 02:00:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:55726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgIUGAx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Sep 2020 02:00:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 31897B6C4;
        Mon, 21 Sep 2020 06:01:27 +0000 (UTC)
Subject: Re: [PATCH 0/9] Rework runtime suspend and SCSI domain validation
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <20200906012219.17893-1-bvanassche@acm.org>
 <f4ff6be8-84b6-6f08-8657-21238c99df9c@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ab848686-fe88-7b79-f75a-e192f3e3f3eb@suse.de>
Date:   Mon, 21 Sep 2020 08:00:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <f4ff6be8-84b6-6f08-8657-21238c99df9c@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/19/20 5:45 AM, Bart Van Assche wrote:
> On 2020-09-05 18:22, Bart Van Assche wrote:
>> The SCSI runtime suspend and domain validation mechanisms both use
>> scsi_device_quiesce(). scsi_device_quiesce() restricts blk_queue_enter() to
>> BLK_MQ_REQ_PREEMPT requests. There is a conflict between the requirements
>> of runtime suspend and SCSI domain validation: no requests must be sent to
>> runtime suspended devices that are in the state RPM_SUSPENDED while
>> BLK_MQ_REQ_PREEMPT requests must be processed during SCSI domain
>> validation. This conflict is resolved by reworking the SCSI domain
>> validation implementation.
>>
>> Hybernation and runtime suspend have been retested but SCSI domain
>> validation not yet.
> 
> Hi Martin and James,
> 
> Please advise how to proceed with this patch series. This patch series
> includes an important fix for runtime power management. Unfortunately
> the only way to fix runtime powermanagement is by reworking SPI DV and
> I don't have access to a setup on which I can test the SPI DV changes.
> 
I'll check if I can resurrect my setup.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
