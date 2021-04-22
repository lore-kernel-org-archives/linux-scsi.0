Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD02CC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 06:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9673261403
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 06:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhDVGh6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 02:37:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:46132 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229547AbhDVGhy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Apr 2021 02:37:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1DA2BAEA8;
        Thu, 22 Apr 2021 06:37:19 +0000 (UTC)
Subject: Re: [PATCH 15/42] NCR5380: use SCSI result accessors
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-16-hare@suse.de>
 <75df2cf5-ea29-ea54-f8d3-0f44a845409f@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d0be206b-6666-d1cd-e0fd-bf2a1b491196@suse.de>
Date:   Thu, 22 Apr 2021 08:37:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <75df2cf5-ea29-ea54-f8d3-0f44a845409f@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 11:11 PM, Bart Van Assche wrote:
> On 4/21/21 10:47 AM, Hannes Reinecke wrote:
>> Use accessors to set the SCSI result.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/NCR5380.c | 28 ++++++++++++++--------------
>>   1 file changed, 14 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
>> index d7594b794d3c..855edda9db41 100644
>> --- a/drivers/scsi/NCR5380.c
>> +++ b/drivers/scsi/NCR5380.c
>> @@ -538,7 +538,7 @@ static void complete_cmd(struct Scsi_Host *instance,
>>       if (hostdata->sensing == cmd) {
>>           /* Autosense processing ends here */
>> -        if (status_byte(cmd->result) != GOOD) {
>> +        if (get_status_byte(cmd) != SAM_STAT_GOOD) {
>>               scsi_eh_restore_cmnd(cmd, &hostdata->ses);
>>           } else {
>>               scsi_eh_restore_cmnd(cmd, &hostdata->ses);
> 
> Do all SCSI devices from the nineties report SCSI status values with the 
> lower bit set to 0? If so, can the status_byte() macro be removed entirely?
> 
As indicated in the previous reply, yes, that is the plan (removing the 
status_byte() macro). And the drivers will have to report SCSI status 
values with the lower bit cleared, otherwise the linux SCSI status codes 
would never have worked in the first place.

So I'll be adding a new patch for dropping the 'status_byte()' macro in 
the next round.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
