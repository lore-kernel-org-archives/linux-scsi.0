Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37E6C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Oct 2022 17:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiJERkG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Oct 2022 13:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiJERkF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2022 13:40:05 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4EFFD10
        for <linux-scsi@vger.kernel.org>; Wed,  5 Oct 2022 10:40:04 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id e129so15814168pgc.9
        for <linux-scsi@vger.kernel.org>; Wed, 05 Oct 2022 10:40:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=jsNgEzm3ETd9SKMhGrdlboCQ83S+JNp3CkNGWIQ8AGY=;
        b=FFYylvOIjWbdfijGkg8TrS2LPI69dO7Z6qGN6IIoBV/lYYN1OL6y/fP+veSehtKTU+
         LL2U0V7dL+C5O1o34ZvbB266tb7dS3qKsEDf1O2fzm2LgcFsdQUwICvtrp7LTpdpav4B
         REVTG/LcI/LYiE9zrS43b/Q0n4gI2/ENcErHS5jOBnoppzVQNhV6Xvpvm1JBgE8JEbPy
         UaOprPjUBggpJbnsEvGbZ3xxoTscweEzuuxyj8YgX05ovwE2vpAnrKT9k35ESEnuGEiL
         a4Rz2wcBqghvnbAJn+n8G0iCI7NcxXahlHoQMP4S87qFg9z5DRaMJc8FHksHnALtcOGS
         alOA==
X-Gm-Message-State: ACrzQf3pCjtHTUqY5uBBRZsYUGFHl1Pbu4jNxh2kU0kjPFX7xuZCOrOD
        rTSK52vWtbo9YzyMAeCNs4g=
X-Google-Smtp-Source: AMsMyM5RrTvyMSMrFXzfGBi6++wEubEdvlt1iytgs2rPfK5yJ50iJSSqOfDfDOrPwVpaSlN0LPn9kA==
X-Received: by 2002:a65:6e9a:0:b0:44c:2476:12e0 with SMTP id bm26-20020a656e9a000000b0044c247612e0mr796513pgb.159.1664991603313;
        Wed, 05 Oct 2022 10:40:03 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id v62-20020a626141000000b0054097cb2da6sm11166941pfb.38.2022.10.05.10.40.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 10:40:02 -0700 (PDT)
Message-ID: <30d6c549-44df-47c3-3376-241feb4e2f0b@acm.org>
Date:   Wed, 5 Oct 2022 10:40:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 32/35] scsi: sd: Have scsi-ml retry read_capacity_10
 errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-33-michael.christie@oracle.com>
 <4fda7b49-7fc0-7372-961e-e70c870d67bb@acm.org>
 <07ec60b3-2147-3194-ee6d-49139bd48c95@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <07ec60b3-2147-3194-ee6d-49139bd48c95@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/22 10:00, Mike Christie wrote:
> On 10/4/22 6:42 PM, Bart Van Assche wrote:
>> On 10/3/22 10:53, Mike Christie wrote:
>>> +    cmd[0] = READ_CAPACITY;
>>> +    memset(&cmd[1], 0, 9);
>>
>> Please remove the above code and change the cmd[] declaration into something like
>>
>> static const u8 cmd[10] = { READ_CAPACITY };
> 
> Would you be ok if I made these types of changes in a separate patchset?
> This patcheset tried to only remove the loop/goto logic since it was
> focused on retries.
> 
> Besides the ones you pointed out, I think I can make maybe 5-10 more
> scsi_execute* users use static const or at least do:
> 
> unsigned char cmd[6] = { CMD } or { }
> 
> and remove some extra memsets so we end up doing it more or less the same
> in all the users.
> 
> It seemed more like a cleanup patchset so I didn't want to mix it up as
> this one was getting big.

Hi Mike,

Patch 32/35 already changes the code that initializes cmd[] so I think 
it is fine to make the change I suggested and to rework error handling 
in a single patch. However, I agree that if reworking the initialization 
of cmd[] would be done as separate patches that it would make this 
series too big.

Thanks,

Bart.
