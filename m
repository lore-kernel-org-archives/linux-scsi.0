Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CDBC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 06:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 539A1610FC
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 06:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhEDGSU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 02:18:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:43360 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229770AbhEDGST (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 02:18:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 12C3CAE03;
        Tue,  4 May 2021 06:17:24 +0000 (UTC)
Subject: Re: [PATCH 10/18] scsi: implement reserved command handling
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-11-hare@suse.de>
 <3e41e5ea-6313-9718-c07d-20f8b203efd2@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1db7fc49-17a9-1c8d-9d94-9a1b3694f392@suse.de>
Date:   Tue, 4 May 2021 08:17:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <3e41e5ea-6313-9718-c07d-20f8b203efd2@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/21 5:20 AM, Bart Van Assche wrote:
> On 5/3/21 8:03 AM, Hannes Reinecke wrote:
>> These commands are set aside before allocating the block-mq tag bitmap,
>> so they'll never show up as busy in the tag map.
> 
> That doesn't sound correct to me. Should the above perhaps be changed
> into "blk_mq_start_request() is never called for internal commands so
> they'll never show up as busy in the tag map"?
> 
Yes, will do.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
