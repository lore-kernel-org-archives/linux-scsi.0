Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA13C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 13:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03B3B60E09
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 13:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbhHQNqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 09:46:49 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:42754 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235092AbhHQNqt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 09:46:49 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2F7C021F53;
        Tue, 17 Aug 2021 13:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629207975; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l7jTUWlxIPDJE3WnmFI07Fex/glV838jERqXX6KJQ+Q=;
        b=K9RSAssqzxrXj8a50iudIgg7pyqFIW5yDlX1eaZ6mPH9uSDy/TXvo5Ey9VLbwDVBV3S3tm
        Pk5SPOCi5sUR4RKcIdtzESKRMbcvMFpqcFL95s5R6uIvme7HPt28F3FBDG6devFlTPm39V
        J4IsYpTb9MMtCzCzH6YFOlHPan9UixY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629207975;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l7jTUWlxIPDJE3WnmFI07Fex/glV838jERqXX6KJQ+Q=;
        b=6l47T/1cWCOdRofmkThunJh9L5pBp6QtLB+i9aH8iLr1lSNWNeQOXOzB1RcuvTfmCGtc+D
        8mUxvfRXrbkHQDDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0913A13A91;
        Tue, 17 Aug 2021 13:46:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rtTDAKe9G2HIKgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 17 Aug 2021 13:46:15 +0000
Subject: Re: [PATCH 07/51] megaraid: pass in NULL scb for host reset
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-8-hare@suse.de> <20210817122609.GF30436@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <513fa87d-12c6-d572-c493-b5b663dbbc87@suse.de>
Date:   Tue, 17 Aug 2021 15:46:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817122609.GF30436@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/21 2:26 PM, Christoph Hellwig wrote:
> On Tue, Aug 17, 2021 at 11:14:12AM +0200, Hannes Reinecke wrote:
>> When calling a host reset we shouldn't rely on the command triggering
>> the reset, so allow megaraid_abort_and_reset() to be called with a
>> NULL scb.
>> And drop the pointless 'bus_reset' and 'target_reset' handlers, which
>> just call the same function as host_reset.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/megaraid.c | 42 ++++++++++++++++-------------------------
>>  1 file changed, 16 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
>> index 56910e94dbf2..7c53933fb1b4 100644
>> --- a/drivers/scsi/megaraid.c
>> +++ b/drivers/scsi/megaraid.c
>> @@ -1905,7 +1905,7 @@ megaraid_reset(struct scsi_cmnd *cmd)
>>  
>>  	spin_lock_irq(&adapter->lock);
>>  
>> -	rval =  megaraid_abort_and_reset(adapter, cmd, SCB_RESET);
>> +	rval =  megaraid_abort_and_reset(adapter, NULL, SCB_RESET);
>>  
>>  	/*
>>  	 * This is required here to complete any completed requests
>> @@ -1944,7 +1944,7 @@ megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
>>  
>>  		scb = list_entry(pos, scb_t, list);
> 
> Ther's a dev_warn before this, which dereferences cmd.
> 
>> -		if (scb->cmd == cmd) { /* Found command */
>> +		if (!cmd || scb->cmd == cmd) { /* Found command */
>>  
>>  			scb->state |= aor;
> 
> But more importantly, this function doesn't make much sense for the
> !cmd case, as it doesn't really do anything when not matched. It
> seems like the legacy megaraid driver should just stop calling it
> for resets.
> 
Well, it does the usual RAID HBA host reset: wait for commands to
complete (That's the '!cmd' case).
So as such I guess there is a value in having a host reset function;
we might, however, look at separating the functions.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
