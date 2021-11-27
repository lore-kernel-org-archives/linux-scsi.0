Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9E3C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 17:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239785AbhK0RGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 12:06:13 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:34502 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbhK0REM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Nov 2021 12:04:12 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6D1201FC9E;
        Sat, 27 Nov 2021 17:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638032457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uAVXfpaVcORSYxcezeW7xJSoWc7vFIUCVEMohiPSQGQ=;
        b=A5EK4nxjrFo114mU6BK0TBF4tE4ltHlUGHZW9lzjgjzSdVNLpP4pzlmmxTo54oU62+DWKB
        fazqI0rzLOhT2ver50AXo+BGelOhTLGhByhG+usgYTqJh6w+q/4TnMjwQ2cka0gb42tVOB
        Mytjp9shbkNYj8abfyQWzAm3VsO6T9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638032457;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uAVXfpaVcORSYxcezeW7xJSoWc7vFIUCVEMohiPSQGQ=;
        b=tJiFYOHfMOw1os+cJeDvSsM5e+vPqdD7Pt2jqTknUW9RCY0XSgN7l08t9E0eyYlzuvQnuA
        GXlMTX1AjeQSMAAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 429FC1344E;
        Sat, 27 Nov 2021 17:00:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Gfz5DklkomGqMAAAMHmgww
        (envelope-from <hare@suse.de>); Sat, 27 Nov 2021 17:00:57 +0000
Subject: Re: [PATCH 06/15] hpsa: use scsi_host_busy_iter() to traverse
 outstanding commands
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-7-hare@suse.de>
 <c65222e1-c489-e3f4-0688-c7ae7ac941e5@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <422ec120-e0fd-07d1-4e14-c369c655b013@suse.de>
Date:   Sat, 27 Nov 2021 18:00:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <c65222e1-c489-e3f4-0688-c7ae7ac941e5@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/21 10:33 AM, John Garry wrote:
> On 25/11/2021 15:10, Hannes Reinecke wrote:
>>   static void hpsa_drain_accel_commands(struct ctlr_info *h)
>>   {
>> -    struct CommandList *c = NULL;
>> -    int i, accel_cmds_out;
>> -    int refcount;
>> +    struct hpsa_command_iter_data iter_data = {
>> +        .h = h,
>> +    };
>>       do { /* wait for all outstanding ioaccel commands to drain out */
>> -        accel_cmds_out = 0;
>> -        for (i = 0; i < h->nr_cmds; i++) {
>> -            c = h->cmd_pool + i;
>> -            refcount = atomic_inc_return(&c->refcount);
>> -            if (refcount > 1) /* Command is allocated */
>> -                accel_cmds_out += is_accelerated_cmd(c);
>> -            cmd_free(h, c);
>> -        }
>> -        if (accel_cmds_out <= 0)
>> +        iter_data.count = 0;
>> +        scsi_host_busy_iter(h->scsi_host,
>> +                    hpsa_drain_accel_commands_iter,
>> +                    &iter_data);
> 
> I haven't following this code exactly, but I assume that you want to 
> iter the reserved requests as well (or in other places in others drivers 
> in this series). For that to work we need to call 
> blk_mq_start_request(), right? I could not see it called.
> 
Actually, no; this is iterating over 'accel' commands, ie fastpath 
commands for RAID I/0. Which none of the reserved commands are.

But that doesn't mean that your comment about reserved commands not 
being started is invalid. Hmm.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
