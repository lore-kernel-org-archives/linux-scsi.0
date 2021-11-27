Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5724BC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 16:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbhK0Q1E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 11:27:04 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:34032 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbhK0QZD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Nov 2021 11:25:03 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C20431FC9E;
        Sat, 27 Nov 2021 16:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638030107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2BqRpV/28d2KQofpb6+EbDyABB1tCfQEJvr2ib0OtJg=;
        b=lxXBQP5qe2Cu8dC7cQc4gceqVJITL4N9dbaZUD5fC9bfnWucCEuOo19SmMKkTDBovmL1u1
        kaowPVZmhFbLzSUos/0YS3t5PEhiNjhM3GKutjcf3p0yrw4K99ggsB1kO592yDd65PKHeJ
        h6g6Me40VdE84EkVp1bjYUJx/gwD7m8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638030107;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2BqRpV/28d2KQofpb6+EbDyABB1tCfQEJvr2ib0OtJg=;
        b=n8OCpYW6xsWip7w9xeZd5tSUGlQAPdW+SJLhrGhrUNV0ymAUALzxj5dNX1KqMtxzRuX/S5
        W/Q0wMpEzad6F8Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A74F713A8D;
        Sat, 27 Nov 2021 16:21:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id y+MUKBtbomFOJgAAMHmgww
        (envelope-from <hare@suse.de>); Sat, 27 Nov 2021 16:21:47 +0000
Subject: Re: [PATCH 01/15] scsi: allocate host device
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-2-hare@suse.de>
 <bcd4e4f3-e7e1-7e3c-c0c6-8262bd82434c@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <dc4295ac-16dd-e883-bc9d-1580e91c4796@suse.de>
Date:   Sat, 27 Nov 2021 17:21:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <bcd4e4f3-e7e1-7e3c-c0c6-8262bd82434c@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/21 12:16 AM, Bart Van Assche wrote:
> On 11/25/21 7:10 AM, Hannes Reinecke wrote:
>> +/**
>> + * scsi_get_host_dev - Create a virtual scsi_device to the host adapter
>                            ^^^^^^
>                            Attach?
> 
It's just words ... sure I can change it.

>> @@ -500,7 +500,8 @@ static void 
>> scsi_device_dev_release_usercontext(struct work_struct *work)
>>           kfree_rcu(vpd_pg80, rcu);
>>       if (vpd_pg89)
>>           kfree_rcu(vpd_pg89, rcu);
>> -    kfree(sdev->inquiry);
>> +    if (!scsi_device_is_host_dev(sdev))
>> +        kfree(sdev->inquiry);
>>       kfree(sdev);
> 
> kfree() accepts a NULL pointer so please leave out the new if-test.
> 
Actually a left-over from a different patch (to use 'real' inquiry data 
for dummy devices). Will be removing it.

>> -#define MODULE_ALIAS_SCSI_DEVICE(type) \
>> +#define MODULE_ALIAS_SCSI_DEVICE(type)            \
>>       MODULE_ALIAS("scsi:t-" __stringify(type) "*")
> 
> The above change seems not related to the rest of this patch? Can it be 
> left out?
> 
Sure.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
