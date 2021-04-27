Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE2EC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 07:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B214261177
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 07:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhD0Hgs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 03:36:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:55064 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230232AbhD0Hgr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 03:36:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 32A8FAFF5;
        Tue, 27 Apr 2021 07:36:04 +0000 (UTC)
Subject: Re: [PATCH 19/39] qlogicfas408: make ql_pcmd() a void function
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-20-hare@suse.de> <20210426152619.GK25615@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <13cdd762-b74c-eecb-0dbb-9916afa0c66a@suse.de>
Date:   Tue, 27 Apr 2021 09:36:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210426152619.GK25615@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/26/21 5:26 PM, Christoph Hellwig wrote:
> On Fri, Apr 23, 2021 at 01:39:24PM +0200, Hannes Reinecke wrote:
>> Make ql_pcmd() a void function and set the SCSI result directly.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/qlogicfas408.c | 75 ++++++++++++++++++++++++-------------
>>   1 file changed, 49 insertions(+), 26 deletions(-)
> 
> Can you explain why this is useful?  Because it does not really look
> like it cleans up anything as-is.
> 
It doesn't cleanup per-se, but it allows us to use the SCSI result 
accessor functions to set the final result.
Without it we'll have to construct the result as a numeric value
within ql_pcmd(), and then set that value as a result to the SCSI 
command in the caller.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
