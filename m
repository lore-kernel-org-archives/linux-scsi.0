Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6477CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 00:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiI3Ach (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 20:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiI3Acf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 20:32:35 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53BB201919
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 17:32:34 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id e11-20020a17090a77cb00b00205edbfd646so7504247pjs.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 17:32:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=7XG+7eWM03IS5+wXz29Ud5UvnaoL94usBKW+cV16wGc=;
        b=aNnT+E0ydK44nHEvuouSTQjVOlRX9SoIUmE1RNXILf3vGeRvGcQyRNHHbAgE7Y5Kk9
         OZabRZ+uogeJ9euLbeFBkWnLqcdxbwt0UgM5B6KOdpc5nGwFj/TzYiwqUgG4f/IAAqKH
         0lE0y16jexF1HHRNHnmqOoLm1iPK7FdrLe+NiSOEbsZOBZX2FWN4JbZ/CcepeV1lX1Kl
         T4srheazJwCDScpQsAKQL7i2tPvxAN2PC7EzSz7mnoJJTaFyF7qwnivHh0wdJj7NQfV1
         HA/zu2CPciJOpw1gPTpymGwEMwv6XZxaQ09eh425WWE5f2Qool+h9VqPAhGg5LXORmsO
         pidA==
X-Gm-Message-State: ACrzQf1HzhwcJdg1/Ht0ToOq5O71Uwff703xAoCHNPNh2U4JrP5uMWCf
        gyh1PwJHYt9vhBk8PS3aXdx3b24X+qI=
X-Google-Smtp-Source: AMsMyM6aveW5UXy8/3VTkHAooXifttL2e40PTd5uGoeHyqIImVkBfNcVO2Dd2G3fQAY6tAExaTW4jA==
X-Received: by 2002:a17:902:d353:b0:178:8976:e78f with SMTP id l19-20020a170902d35300b001788976e78fmr6104993plk.68.1664497954106;
        Thu, 29 Sep 2022 17:32:34 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:56f2:482f:20c2:1d35? ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id e123-20020a621e81000000b0052d200c8040sm274341pfe.211.2022.09.29.17.32.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 17:32:33 -0700 (PDT)
Message-ID: <508f9526-38a6-7a06-596d-990c01b20a77@acm.org>
Date:   Thu, 29 Sep 2022 17:32:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 1/8] scsi: core: Fix a race between scsi_done() and
 scsi_timeout()
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
References: <20220929220021.247097-1-bvanassche@acm.org>
 <20220929220021.247097-2-bvanassche@acm.org>
 <8d123a46-42c0-35b7-92d6-bbbbd3abab35@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8d123a46-42c0-35b7-92d6-bbbbd3abab35@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/22 17:17, Mike Christie wrote:
> On 9/29/22 5:00 PM, Bart Van Assche wrote:
>>   	if (rtn == BLK_EH_DONE) {
>>   		/*
>> -		 * Set the command to complete first in order to prevent a real
>> -		 * completion from releasing the command while error handling
>> -		 * is using it. If the command was already completed, then the
>> -		 * lower level driver beat the timeout handler, and it is safe
>> -		 * to return without escalating error recovery.
>> -		 *
>> -		 * If timeout handling lost the race to a real completion, the
>> -		 * block layer may ignore that due to a fake timeout injection,
>> -		 * so return RESET_TIMER to allow error handling another shot
> 
> I've been wondering about this code too.
> 
> I think the patch is correct for the normal cases, but I didn't understand the
> old fake timeout comment case. From the comment it seemed like that was the reason
> we did the RESET_TIMER. Does that not exist anymore or was it just bogus?

Before commit 15f73f5b3e59 ("blk-mq: move failure injection out of
blk_mq_complete_request") the scsi_mq_done() function cleared the
SCMD_STATE_COMPLETE bit in case of fake timeout injection. I think
that commit made the above comment incorrect.

> The commit you referenced actually was returning BLK_EH_DONE like we want. This
> commit:
> 
> commit f1342709d18af97b0e71449d5696b8873d1a456c
> Author: Keith Busch <keith.busch@intel.com>
> Date:   Mon Nov 26 09:54:29 2018 -0700
> 
>      scsi: Do not rely on blk-mq for double completions
> 
> 
> changed it to BLK_EH_RESET_TIMER and changed the above comment to mention
> the fake timeout case. However, the commit message mentioned the patch was done
> because we didn't want scsi digging the block layer.
> 
> If the fake injection thingy is bogus, then it seems ok to me.

Hmm ... I probably should modify the Fixes tag.

Thanks,

Bart.
