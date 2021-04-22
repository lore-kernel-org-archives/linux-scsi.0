Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3DAC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 06:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B0916144D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 06:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhDVGdl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 02:33:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:44192 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230232AbhDVGdk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Apr 2021 02:33:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AF5E7B008;
        Thu, 22 Apr 2021 06:33:05 +0000 (UTC)
Subject: Re: [PATCH 13/42] scsi: add get_{status,host}_byte() accessor
 function
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-14-hare@suse.de>
 <857b0e4a-06e5-b240-1075-466b607faaf5@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f450715b-3d3f-16c5-8966-4a283afbc3d5@suse.de>
Date:   Thu, 22 Apr 2021 08:33:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <857b0e4a-06e5-b240-1075-466b607faaf5@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 11:09 PM, Bart Van Assche wrote:
> On 4/21/21 10:47 AM, Hannes Reinecke wrote:
>> Add accessor functions for the host and status byte.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   include/scsi/scsi_cmnd.h | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>> index a1eb7732aa1b..0ac18a7d8ac6 100644
>> --- a/include/scsi/scsi_cmnd.h
>> +++ b/include/scsi/scsi_cmnd.h
>> @@ -316,6 +316,11 @@ static inline void set_status_byte(struct 
>> scsi_cmnd *cmd, char status)
>>       cmd->result = (cmd->result & 0xffffff00) | status;
>>   }
>> +static inline unsigned char get_status_byte(struct scsi_cmnd *cmd)
>> +{
>> +    return cmd->result & 0xff;
>> +}
> 
> So in addition to the status_byte() macro, get_status_byte() is 
> introduced? That seems like a potential source of confusion to me.
> 
The idea is to kill 'status_byte' (and the linux-specific status codes) 
entirely, which then would resolve this ambiguity.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
