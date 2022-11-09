Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A286C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 12:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiKIMs3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 07:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKIMs2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 07:48:28 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544CB1101
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 04:48:25 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8B97B1F9AD;
        Wed,  9 Nov 2022 12:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667998104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6n7oC6trPGQjH1AAOeiCHOqsIvIwZBU2wVVQuNQSL3I=;
        b=DFTEVJPnc1BYdjcoSFm/w+8k8qQN3BtbcrOT3O4ZhSjTIZo9TTBanrmggzajXwHIWvz9n1
        GdKaoevx7oS2hb1bbkmM8UmZBYKW6gmk7MzC+T7EsIPxvQF9PVSE9jsX0h4KYRy0fEfwbf
        le2tA6qEPT6km+8N/50+eU5HuOQP2ZQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667998104;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6n7oC6trPGQjH1AAOeiCHOqsIvIwZBU2wVVQuNQSL3I=;
        b=HBlk+1b/LIslwqNPVYX8tPNu914Qfa8zuBT7OpXoMZqg+g10w9/hNd8f6MuRCNUo9ZNrY5
        xwI1z1MAexWmmUDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 709CB139F1;
        Wed,  9 Nov 2022 12:48:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PPSIJZeha2OLbAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Nov 2022 12:48:23 +0000
Message-ID: <8eca30f9-1191-e92e-1c48-bf73f14850e6@suse.de>
Date:   Wed, 9 Nov 2022 13:48:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <20221109074754.24075-1-hare@suse.de>
 <bc23a83b-af57-0920-4155-cf6aa4057a60@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [External] : [PATCH] scsi_error: do not queue pointless abort
 workqueue functions
In-Reply-To: <bc23a83b-af57-0920-4155-cf6aa4057a60@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/22 09:28, John Garry wrote:
> On 09/11/2022 07:47, Hannes Reinecke wrote:
>> If a host template doesn't implement the .eh_abort_handler()
>> there is no point in queueing the abort workqueue function;
>> all it does is invoking SCSI EH anyway.
>> So return 'FAILED' from scsi_abort_command() if the .eh_abort_handler()
>> is not implemented and save us from having to wait for the
>> abort workqueue function to complete.
> 
> Do we ever use shost->tmf_work_q in this case? Doesn't seem much point 
> in allocating it, apart from keeping the code simpler
> 
Actually, no. Guess we can skip allocating it.

>>
>> Cc: Niklas Cassel <Niklas.Cassel@wdc.com>
>> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> Cc: John Garry <john.garry@oracle.com>
> 
> That's someone else :)
> 
Oh. Sorry, John :-)

>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/scsi_error.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index be2a70c5ac6d..e9f9c8f52c59 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -242,6 +242,11 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>>           return FAILED;
>>       }
>> +    if (!shost->hostt->eh_abort_handler) {
> 
> nit: no need for {}, but maybe better put comment above the check if 
> removing it. However maybe it's also a bit obvious comment.
> 
Yeah, will do.

>> +        /* No abort handler, fail command directly */
>> +        return FAILED;
>> +    }
>> +
>>       spin_lock_irqsave(shost->host_lock, flags);
>>       if (shost->eh_deadline != -1 && !shost->last_reset)
>>           shost->last_reset = jiffies;
> 
Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

