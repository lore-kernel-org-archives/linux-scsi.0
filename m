Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B263C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 08:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54E5560D07
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 08:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhGZIHL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 04:07:11 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58322 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbhGZIHK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 04:07:10 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DAA211FE5A;
        Mon, 26 Jul 2021 08:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627289258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q9YB575bdMZAKMtPhVHfsf9Vuk0oGw3jIjKXXV75dY0=;
        b=sKqEEZFP7dZvVnRrJyNe42DFKLZvzNzHcld8/R0lPis2iYpgCaRa/SVRqNEbFV7czUh1w/
        Ed+OxyeIUXAlavu/FlAc+TiM5ff+FzHpc7UNY06qY46kKjRPKeIpxe7BYqAYPEltACiqiE
        rAcCY+JKv/SFgZjQTv5zbyY8rA6wjx0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627289258;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q9YB575bdMZAKMtPhVHfsf9Vuk0oGw3jIjKXXV75dY0=;
        b=FbvIHjNjVcL7dVyI32vcDSMnd8+S3tpCOKC++jxIBTYwXbLxnWS+Pz9j031KE4ifLFID8i
        X47L6mZtylkDzrDA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id BC9251365C;
        Mon, 26 Jul 2021 08:47:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id Coc5Lap2/mAGJQAAGKfGzw
        (envelope-from <hare@suse.de>); Mon, 26 Jul 2021 08:47:38 +0000
Subject: Re: [PATCH v3 1/4] block: Add concurrent positioning ranges support
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <20210726013806.84815-2-damien.lemoal@wdc.com>
 <751621a5-a35b-c799-439c-8982433a6be5@suse.de>
 <DM6PR04MB7081141B64D9501BDA876433E7E89@DM6PR04MB7081.namprd04.prod.outlook.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0ec2ea13-208f-1a5e-7b11-37317b5e56b8@suse.de>
Date:   Mon, 26 Jul 2021 10:47:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB7081141B64D9501BDA876433E7E89@DM6PR04MB7081.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/26/21 10:30 AM, Damien Le Moal wrote:
> On 2021/07/26 16:34, Hannes Reinecke wrote:
[ .. ]
>> In principle it looks good, but what would be the appropriate action
>> when invalid ranges are being detected during revalidation?
>> The current code will leave the original ones intact, but I guess that's
>> questionable as the current settings are most likely invalid.
> 
> Nope. In that case, the old ranges are removed. In blk_queue_set_cranges(),
> there is:
> 
> +		if (!blk_check_ranges(disk, cr)) {
> +			kfree(cr);
> +			cr = NULL;
> +			goto reg;
> +		}
> 
> So for incorrect ranges, we will register "NULL", so no ranges. The old ranges
> are gone.
> 

Right. So that's the first concern addressed.

>> I would vote for de-register the old ones and implement an error state
>> (using an error pointer?); that would signal that there _are_ ranges,
>> but we couldn't parse them properly.
>> Hmm?
> 
> With the current code, the information "there are ranges" will be completely
> gone if the ranges are bad... dmesg will have a message about it, but that's it.
> 
So there will be no additional information in sysfs in case of incorrect 
ranges?

Hmm. Not sure if I like that, but then it might be the best option after 
all. So you can add my:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
