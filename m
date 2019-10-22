Return-Path: <SRS0=5qjn=YP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87456CA9EB7
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 05:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49FEE21D81
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 05:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbfJVF7j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Oct 2019 01:59:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:60786 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726024AbfJVF7i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Oct 2019 01:59:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 55DACB15A;
        Tue, 22 Oct 2019 05:59:36 +0000 (UTC)
Subject: Re: [PATCH 03/24] wd33c93: use SCSI status
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-4-hare@suse.de>
 <alpine.LNX.2.21.1910220948520.14@nippy.intranet>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <466dee43-09d5-f487-bee2-16d86d6cbb2d@suse.de>
Date:   Tue, 22 Oct 2019 07:59:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.21.1910220948520.14@nippy.intranet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/22/19 1:16 AM, Finn Thain wrote:
> On Mon, 21 Oct 2019, Hannes Reinecke wrote:
> 
>> Use standard SCSI status and drop usage of the linux-specific ones.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/wd33c93.c | 21 ++++++++-------------
>>  1 file changed, 8 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
>> index f81046f0e68a..98e04a7b9d63 100644
>> --- a/drivers/scsi/wd33c93.c
>> +++ b/drivers/scsi/wd33c93.c
>> @@ -1176,10 +1176,8 @@ wd33c93_intr(struct Scsi_Host *instance)
>>  			if (cmd->SCp.Status == ILLEGAL_STATUS_BYTE)
>>  				cmd->SCp.Status = lun;
>>  			if (cmd->cmnd[0] == REQUEST_SENSE
>> -			    && cmd->SCp.Status != GOOD)
>> -				cmd->result =
>> -				    (cmd->
>> -				     result & 0x00ffff) | (DID_ERROR << 16);
>> +			    && cmd->SCp.Status != SAM_STAT_GOOD)
>> +				set_host_byte(cmd, DID_ERROR);
> 
> This isn't obviously equivalent. Perhaps the set_host_byte() changes 
> should be done in a separate patch to the SAM_STAT_FOO changes (?)
> 
Yes, indeed.
Will be fixing it up in the next round.

>>  			else
>>  				cmd->result =
>>  				    cmd->SCp.Status | (cmd->SCp.Message << 8);
>> @@ -1262,9 +1260,8 @@ wd33c93_intr(struct Scsi_Host *instance)
>>  		    hostdata->connected = NULL;
>>  		hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
>>  		hostdata->state = S_UNCONNECTED;
>> -		if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != GOOD)
>> -			cmd->result =
>> -			    (cmd->result & 0x00ffff) | (DID_ERROR << 16);
>> +		if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != SAM_STAT_GOOD)
>> +			set_host_byte(cmd, DID_ERROR);
> 
> Same.
> 
>>  		else
>>  			cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
>>  		cmd->scsi_done(cmd);
>> @@ -1294,12 +1291,10 @@ wd33c93_intr(struct Scsi_Host *instance)
>>  			hostdata->connected = NULL;
>>  			hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
>>  			hostdata->state = S_UNCONNECTED;
>> -			DB(DB_INTR, printk(":%d", cmd->SCp.Status))
>> -			    if (cmd->cmnd[0] == REQUEST_SENSE
>> -				&& cmd->SCp.Status != GOOD)
>> -				cmd->result =
>> -				    (cmd->
>> -				     result & 0x00ffff) | (DID_ERROR << 16);
>> +			DB(DB_INTR, printk(":%d", cmd->SCp.Status));
>> +			if (cmd->cmnd[0] == REQUEST_SENSE
>> +			    && cmd->SCp.Status != SAM_STAT_GOOD)
>> +				set_host_byte(cmd->result, DID_ERROR);
> 
> Same.
> 
Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 247165 (AG München), GF: Felix Imendörffer
