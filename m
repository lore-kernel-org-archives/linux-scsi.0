Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14DDC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 15:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FD46610A3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 15:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242813AbhJ0PnO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 11:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238707AbhJ0PnO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2021 11:43:14 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42A2C061570
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 08:40:48 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id 3so3393418ilq.7
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 08:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1V1b8qzpm7KUEUWbM52utQU6szAcV/XqEuLa0wDBSso=;
        b=ho7pnJHOtwg7DA+HL85whEzTNOdbNGMl4RWqCIl3Ow9CbkQPsK0lBHELBKHAQpCO42
         CIL2z7UB0oRxtGXnowDj92d1pFOsT3qwtIMo8a0dxfVK9WV7CaE3i9b4w/+7OuI6wkQX
         WPuxQKE2aPoChkMB2z8EmY+eNwJP3R23/71wggVL+7koP6uvKIcV8srUCx8hmG3MtBsT
         p8gPYqx1f6NpPBRAM6ByaJfZ1z32AyJa4faYmLemWN6q2a/hUfvCPcCmsxj1E4l+reis
         lbgyOcEq9mabnPodPFBM4pnPK5JaXIQrCRjrjmERxWoACPpcwnBh0uvG0stRPcn3nL6r
         RQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1V1b8qzpm7KUEUWbM52utQU6szAcV/XqEuLa0wDBSso=;
        b=u++MAd+mIyRy70XKSXzyF9wTKP9fsNbpczlTidntmLRMW50jwLf+mGZ9989qeyPl0T
         h3CkZhLQffjlwlP9fslUk+EzkmJGRdStOI3kXAyEH/S9Byxx34k8lKlhmtZ8qlELPrLM
         wJFPL+u3xQIsFiyH3WZzymCo3iz+pN95+hljnOtjI2Q6njlCzXecpni52g6fYSzYgRaL
         TrrkeoDLoJxveO+vlfif6+s9rol+TTev9LfDTa/jVswt0uyGO9nCLPLar1Qus9r6XEwb
         WxmaNy1ukwqQTxcomYMOSLAlF6YmwHlR0OnxI3aSJXJPnJt4q8zm0x0rwcL8TyYjmuT4
         UCPw==
X-Gm-Message-State: AOAM531ttGfr5Icg6YzylN+6v6XEoea0PQySD82rZaoKDmoRTR8/BzjV
        PJuwrXZzwFwAyXPDtNtYYCQY/NCxCMCGcA==
X-Google-Smtp-Source: ABdhPJwyqvDvFLJiP96Yg+atN/QWg96a8D73xASHMazQaiG7s6okBkrAC+ZeWvEorA/DQ/V/hkXVNg==
X-Received: by 2002:a92:6408:: with SMTP id y8mr20048661ilb.34.1635349248056;
        Wed, 27 Oct 2021 08:40:48 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m7sm149192ilu.58.2021.10.27.08.40.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 08:40:45 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
 <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
 <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
 <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
 <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
 <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
 <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org> <20211027052724.GA8946@lst.de>
 <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
 <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
 <YXlqSRLHuIFiMLY7@T590> <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
 <yq135om1p3i.fsf@ca-mkp.ca.oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bbab4d8f-67c0-83bb-a979-cb9f9ac28af5@kernel.dk>
Date:   Wed, 27 Oct 2021 09:40:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <yq135om1p3i.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/21 9:35 AM, Martin K. Petersen wrote:
> 
> Jens,
> 
>> But yes, reuse of the existing request is probably another potentially
>> viable approach. My worry there is that inevitably you end up needing
>> to stash a lot of data to restore the original, and we're certainly
>> not adding anything to struct request for that.
> 
> Yeah, I much prefer the reserved tag approach. That was my original
> recommendation.
> 
> SCSI error handling does command hijacking and it is absolutely
> dreadful.

Then let's make sure we nudge it in that direction! It'd be feasible to
have less reserved tags, you only need as many as you want to have these
special commands inflight. Post that, returning BUSY and just retrying
when a request completes should be fine. Hence I'd size the reserved tag
pool appropriately depending on what kind of performance is expected out
of this, with just 1 reserved tag being enough to give us the guarantees
we need for forward progress.

I think the plan forward is clear here then:

1) Revert the optimization that requires the use of cloned insert for
   5.15.
2) Re-write the optimization using reserved tags, post 5.15 obviously.

-- 
Jens Axboe

