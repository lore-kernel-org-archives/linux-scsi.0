Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2292C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 16:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C84961151
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 16:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242635AbhJQQWC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Oct 2021 12:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242591AbhJQQWA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Oct 2021 12:22:00 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D91AC06161C
        for <linux-scsi@vger.kernel.org>; Sun, 17 Oct 2021 09:19:51 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id x1so13469064iof.7
        for <linux-scsi@vger.kernel.org>; Sun, 17 Oct 2021 09:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m98bfzlixYwHRJy9xQyd49Ys4ry64BoGTkvwZJ8uo5I=;
        b=0nNRmTW+z+9JitGKpcYp3dhOZCx6z5zbaWYP52J929hUxBs1gV7rZTxwwS7OoDy9B6
         8PDZnjK0YzJs/JHwLAcwg1cJOPZITq7KHVncUUanGkW1DdxKuANZgNoOg9nwWt8NNQLW
         9AGD0+r9oLc7vuvihVoHvDnvT3vM5h1/gNDf1kdwhXTHyUV2opNmGL+suPOWvbXFoTNp
         KhRDy1OOmlkieTmcOihYiqYBvYzT5r8ka0yYXNPW3SqytlkybFt6TmfXjcp1/13XTr4e
         jDsax7syILnu3nyl5Z18n5Vy305ePnPyHbuvEjMhtripeP+mb1xkOyRU3Zs/xSPJ2uY9
         fzww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m98bfzlixYwHRJy9xQyd49Ys4ry64BoGTkvwZJ8uo5I=;
        b=TvZLUqVzzTDk7PJDQZHDzzzrGJqiLVIEKXd8dlK9c/FqDfMm+khP9UfwgWxCSlAIPh
         85FzpN9D+m/o2MP7t43hFYb5a4N3crMdopRE1KAFHdzU8VX7HRNARVgDLClSt/goAHy0
         8ikZlDq5k85lMmBOX26rhwDR8FUK+7oJbyKOUTeGtcJFg18dc23n+2Uhy5qnYZoRCFVt
         bZt0GGiVO/DsKI88n6Q97qsofdegO8lvofxVQmDnls705gmejsK1YE9U/mXgQ2khhFKk
         RmZyjnAjdimFAYkBMkTHCJbSlNsQzWqIzvVmWKbdNl+igXov8w5yAxaSX5C5lj2HmKJO
         Sj4g==
X-Gm-Message-State: AOAM532ZGwWNyothgI8coWLlllpBvsOY4yJlSTFdhDrAMeq/SeU9EoJ/
        2IayAMf9kZhW4lB1xQ7yQ3ROFA==
X-Google-Smtp-Source: ABdhPJwtznf6e9ywGwmoXxpYcHdnOQoaceVwkkcFOrzZJibIx5sp1fBqNKH1DbnHAQ6DSKwUA0X5eQ==
X-Received: by 2002:a05:6602:2599:: with SMTP id p25mr11374972ioo.90.1634487590516;
        Sun, 17 Oct 2021 09:19:50 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id 26sm5416212ioz.55.2021.10.17.09.19.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Oct 2021 09:19:50 -0700 (PDT)
Subject: Re: [RFC PATCH 1/3] blk-mq: Add blk_mq_complete_request_direct()
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20211015151412.3229037-1-bigeasy@linutronix.de>
 <20211015151412.3229037-2-bigeasy@linutronix.de>
 <YWmmULYUeo/Zd6Jl@infradead.org>
 <20211015161533.5cnhqqd3asy3e3vg@linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <951f4cde-fcc8-f5fe-845a-ccdc3f360428@kernel.dk>
Date:   Sun, 17 Oct 2021 10:19:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211015161533.5cnhqqd3asy3e3vg@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/15/21 10:15 AM, Sebastian Andrzej Siewior wrote:
> On 2021-10-15 09:03:28 [-0700], Christoph Hellwig wrote:
>> On Fri, Oct 15, 2021 at 05:14:10PM +0200, Sebastian Andrzej Siewior wrote:
>>> +void blk_mq_complete_request_direct(struct request *rq)
>>> +{
>>> +	WRITE_ONCE(rq->state, MQ_RQ_COMPLETE);
>>> +	rq->q->mq_ops->complete(rq);
>>> +}
>>
>> As this is called by the driver we known what ->complete this helper
>> would call.  So instead of doing this we could just call
>> blk_mq_set_request_complete and the actual completion helper.
>> The comment above it will need some updates of course.
> 
> So
> 	blk_mq_set_request_complete();
> 	mmc_blk_mq_complete();
> 
> for the mmc driver and no fiddling in the blk-mq then.

Just pass in the handler:

void blk_mq_complete_request_direct(struct request *rq,
				    void (*complete)(struct request *rq))
{
	WRITE_ONCE(rq->state, MQ_RQ_COMPLETE);
	complete(rq);
}

And we should probably put it in blk-mq.h so it inlines nicely, and
that'll be faster than the indirect call.

-- 
Jens Axboe

