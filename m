Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74E7C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 06:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A386A61166
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 06:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347594AbhIHGNi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 02:13:38 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:55392 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbhIHGNh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 02:13:37 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A300622206;
        Wed,  8 Sep 2021 06:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631081549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sHFKf5f0Jl1/9ndxWFeoXyar6g9fimm8yfiHzl2Jhqo=;
        b=qsl/dliJsSyryhmD+4wu+5a7fLz3c9cerw1jkcMpv0aUl55bSsv5IsYjL3nnSCynmXy1X0
        E5XcB5WzwT5kINKBEo2C6fyG6BpJmUCw2IEuT0Kde6hRlAHLAIgD//Fvt/f+EVQkxlU8wJ
        KLSQhBywJlBIFCMg0XCk4End0BLSy8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631081549;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sHFKf5f0Jl1/9ndxWFeoXyar6g9fimm8yfiHzl2Jhqo=;
        b=C4vY2XPlVysignmcepjduj3sAuUCzotlQASCI9604Kz4t56IZdITW7v6sDvPiABfEHcics
        W7Y/UhIG8PttP3Dg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 782ED13A56;
        Wed,  8 Sep 2021 06:12:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id o5/8G01UOGHqNAAAGKfGzw
        (envelope-from <hare@suse.de>); Wed, 08 Sep 2021 06:12:29 +0000
Subject: Re: [PATCH] I/O errors for ALUA state transitions
To:     michael.christie@oracle.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Rajashekhar M A <rajs@netapp.com>
References: <20210907071605.48968-1-hare@suse.de>
 <0bc96e82-fdda-4187-148d-5b34f81d4942@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <783a72db-93c7-92ad-81b4-bc7fee3ce2c1@suse.de>
Date:   Wed, 8 Sep 2021 08:12:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0bc96e82-fdda-4187-148d-5b34f81d4942@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/7/21 5:59 PM, michael.christie@oracle.com wrote:
> On 9/7/21 2:16 AM, Hannes Reinecke wrote:
>> From: Rajashekhar M A <rajs@netapp.com>
>>
>> When a host is configured with a few LUNs and IO is running,
>> injecting FC faults repeatedly leads to path recovery problems.
>> The LUNs have 4 paths each and 3 of them come back active after
>> say an FC fault which makes two of the paths go down, instead of
>> all 4. This happens after several iterations of continuous FC faults.
>>
>> Reason here is that we're returning an I/O error whenever we're
>> encountering sense code 06/04/0a (LOGICAL UNIT NOT ACCESSIBLE,
>> ASYMMETRIC ACCESS STATE TRANSITION) instead of retrying.
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/scsi_error.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 03a2ff547b22..1185083105ae 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -594,10 +594,11 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>>   		    sshdr.asc == 0x3f && sshdr.ascq == 0x0e)
>>   			return NEEDS_RETRY;
>>   		/*
>> -		 * if the device is in the process of becoming ready, we
>> -		 * should retry.
>> +		 * if the device is in the process of becoming ready, or
>> +		 * transitions between ALUA states, we should retry.
>>   		 */
>> -		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
>> +		if ((sshdr.asc == 0x04) &&
>> +		    (sshdr.ascq == 0x01 || sshdr.ascq == 0x0a))
>>   			return NEEDS_RETRY;
> 
> Why put this here instead of in alua_check_sense with the other ALUA
> state transition check?
> 
Good point. Will be updating the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
