Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68544C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 06:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1430364DD6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 06:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhA1G5q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:57:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:38628 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhA1G5p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Jan 2021 01:57:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 932A2AC45;
        Thu, 28 Jan 2021 06:57:03 +0000 (UTC)
Subject: Re: [PATCH] scsi: do not retry FAILFAST commands on
 DID_TRANSPORT_DISRUPTED
To:     michael.christie@oracle.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Hannes Reinecke <hare@suse.com>
References: <20210126130212.47998-1-hare@suse.de>
 <e5c71e73-f36b-8ff8-ef4e-d424304431a6@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <fa31a242-bed7-6466-2ac5-e69a5d71b8ef@suse.de>
Date:   Thu, 28 Jan 2021 07:57:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <e5c71e73-f36b-8ff8-ef4e-d424304431a6@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/28/21 1:51 AM, michael.christie@oracle.com wrote:
> On 1/26/21 7:02 AM, Hannes Reinecke wrote:
>> When a command is return with DID_TRANSPORT_DISRUPTED we should
>> be looking at the REQ_FAILFAST_TRANSPORT flag and do not retry
>> the command if set.
>> Otherwise multipath will be requeuing a command on the failed
>> path and not fail it over to one of the working paths.
>>
>> Cc: Martin Wilck <martin.wilck@suse.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>   drivers/scsi/scsi_error.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index a52665eaf288..005118385b70 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -1753,6 +1753,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
>>       case DID_TIME_OUT:
>>           goto check_type;
>>       case DID_BUS_BUSY:
>> +    case DID_TRANSPORT_DISRUPTED:
>>           return (scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT);
>>       case DID_PARITY:
>>           return (scmd->request->cmd_flags & REQ_FAILFAST_DEV);
> 
> We don't fast fail for that error code to avoid churn for transient 
> transport problems. The FC and iscsi drivers block the rport/session, 
> return that code and then it's up the fast_io_fail/replacement timeout.
> 
_But_ if prevents that command to be failed over to another path, so 
essentially we're blocking execution until fast_io_fail tmo.

For no good reason as we have other paths available.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
