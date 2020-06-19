Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88947C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 18:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 646EF21527
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 18:38:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="iO3KWLb/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388782AbgFSSiN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 14:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388798AbgFSSiL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 14:38:11 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691DCC0613EE
        for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2020 11:38:09 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s14so153831plq.6
        for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2020 11:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QDtquKpDVyqUKG68/dEGFCUQ2iKdA4vKgNk+0fPkUQA=;
        b=iO3KWLb/IOrpPbhJquZWw5Trrnm12vFb8zSZNJSSNS6Ao7sk40DRXFOezrveCkqw+j
         53Xqg+hrlZQb+KEKgITq1dZY+mZb42f+Q0N8yFNBycUbXdENWQmc0+bB2iBvEQyPpNjC
         2NbS1pQQCHGbC6Sf7kZYDV5crZiDbMiZ36aezDyYLoG7i1yUfPsV6ZGM6oJ7+h6Bpe6P
         Pml8rLPbjiBzvBTVsOKVdov4rLW+MFC2LCN2KlUafnnhE0fc3d0aOIxFdhMcsBKNRdnk
         8qO0OjWb6stOLYOrkOkB1FcBjZXIVbyUfHP0v7UxIhAYe1lkjy68Q2Hma2ue4S/Qw1Az
         GJiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QDtquKpDVyqUKG68/dEGFCUQ2iKdA4vKgNk+0fPkUQA=;
        b=s10shVJJ16cYz7p3ZGCW198pF00W0hQbOajlTYCATXAcuI1xrxR/c94GgLj+cPGF1p
         8oo+ndSL1Qz9rljprscNqYAQNrgYLzZoPakiclmwckJ91AnTzgFRSAoPkzN/+s6WmbAM
         4YnafiyEYzEX2EUGr4fZYbWAkidLBzkSmIX9XHkiFQ5nIibeUIA34sLa406kWBrItpFj
         Sm0aqKij4fIDCExf3O8r8kykLoBJE3NL1MG8W48RmyazUiu73CiTb8CVbNVdUFDLWbRF
         IBwgcy1lU9d8YeCRlvj01MQdgGf0IflTA1GIMWAojFplDnl3TsMx4ZIlxStCrQJ5KsyE
         g1Mg==
X-Gm-Message-State: AOAM533ld2zOw9Q/MGvgl3jt05+cDjV2+QxpJj23ZO76UvVu1+VJRTsU
        bDUbDdTIsC2BIFQpN0SMHgeI5xH5CGI=
X-Google-Smtp-Source: ABdhPJyit5DhFymkYaDM7kvOWtEZTZtav4eKp+qOHHILCnehtCMg2NidyxRGDqvnOyB1YUfjohdArw==
X-Received: by 2002:a17:902:9346:: with SMTP id g6mr9132665plp.19.1592591888454;
        Fri, 19 Jun 2020 11:38:08 -0700 (PDT)
Received: from ?IPv6:2600:380:7716:2151:5de8:4eed:1c04:bd8a? ([2600:380:7716:2151:5de8:4eed:1c04:bd8a])
        by smtp.gmail.com with ESMTPSA id c1sm6147856pfo.197.2020.06.19.11.38.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 11:38:07 -0700 (PDT)
Subject: Re: [PATCH 2/2] block: only return started requests from
 blk_mq_tag_to_rq()
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Keith Busch <keith.busch@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200619140159.141905-1-hare@suse.de>
 <60e34dce-aea4-311f-22da-4cb130c5ba88@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <57a809a0-d449-e5f1-8986-761d6417e2c2@kernel.dk>
Date:   Fri, 19 Jun 2020 12:38:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <60e34dce-aea4-311f-22da-4cb130c5ba88@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/19/20 8:09 AM, Hannes Reinecke wrote:
> On 6/19/20 4:01 PM, Hannes Reinecke wrote:
>> blk_mq_tag_to_rq() is used from within the driver to map a tag
>> to a request. As such it should only return requests which are
>> already started (ie passed to the driver); otherwise the driver
>> might trip over requests which it has never seen and random
>> crashes will occur.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   block/blk-mq.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 4f57d27bfa73..f02d18113f9e 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -815,9 +815,13 @@ EXPORT_SYMBOL(blk_mq_delay_kick_requeue_list);
>>   
>>   struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
>>   {
>> +	struct request *rq;
>> +
>>   	if (tag < tags->nr_tags) {
>>   		prefetch(tags->rqs[tag]);
>> -		return tags->rqs[tag];
>> +		rq = tags->rqs[tag];
>> +		if (blk_mq_request_started(rq))
>> +			return rq;
>>   	}
>>   
>>   	return NULL;
>>
> This becomes particularly obnoxious for SCSI drivers using 
> scsi_host_find_tag() for cleaning up stale commands (ie drivers like 
> qla4xxx, fnic, and snic).
> All other drivers use it from the completion routine, so one can expect 
> a valid (and started) tag here. So for those it shouldn't matter.
> 
> But still, if there are objections I could look at fixing it within the 
> SCSI stack; although that would most likely mean I'll have to implement 
> the above patch as an additional function.

The helper does exactly what it should, return a request associated
with a tag. Either add the logic to the caller, or provide a new
helper that does what you need. I'd be inclined to just add it to
the caller that needs it.

-- 
Jens Axboe

