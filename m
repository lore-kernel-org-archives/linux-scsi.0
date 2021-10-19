Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29948C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 17:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01EC461360
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 17:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhJSRL6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 13:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhJSRLz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2021 13:11:55 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1A1C06174E
        for <linux-scsi@vger.kernel.org>; Tue, 19 Oct 2021 10:09:42 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id h10so19161730ilq.3
        for <linux-scsi@vger.kernel.org>; Tue, 19 Oct 2021 10:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NC+QH1lLA2irkAvHgLGE0udswvy9H8J65nP8TCJKrZI=;
        b=o6vk4FISvimEK8NjzWLh71S+R+sbcpT5J1tSiaBXWMPWbd3mKL+fboJreGLKo6Bztf
         7FmcevHC4OmU8CBasGQ4F55i//4n6ioRFxgYyn203PlCncFPNiKJ/KfzCTfW8f6AzvZ1
         HYVeXG/Hcp5z71mKA1iS4YsJSksICRqFho3U8rTE07CSaLtWVegYz6CTqOsIOz3jozcg
         dwpdrj5jYem/Zdkm7BmPJFuRnfaGZ3BjuWERBenEpXIZQlwAEr5LX9jajeA/5SZ5Z0iV
         Tvqta1jqTAfdTITwuhT+TPBGhP40syTE9uLu9UVuCc1dCYK5sefZKvAKssAouGn5Uynl
         VL+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NC+QH1lLA2irkAvHgLGE0udswvy9H8J65nP8TCJKrZI=;
        b=fK+MzcGsszQaxZGIoUkb76mBRgoTmQbqlW8kcOFQpxlevOCwYUYDtbnTCwn3BTrpQl
         AM4LjdVdnL6vRzWn2XyZWWFNwrXc5/cZ0Xs8KN5PkW8Rkfs+gEY0Acfut7zS/9LFsjLm
         hCF4YqCm+jEPRFeEbSE9IG7Jsru8xjbqkhBfsqgew4NN/xE5tlSvT7jmuQ1Do2f19b0p
         QIG9R7WzxDJJMLaH00tA1X4Mby4h+6C9yq93FXJo+v71XXoBjMx0mYGzGzmaULctQhP4
         P+DGlCG0Jr4WSSXwby7z0jHqzYgAcObB+tvEdFbhQd8AuPSB94APZ0uXf+SFxtqm/STb
         dd2w==
X-Gm-Message-State: AOAM533+YH8d646EbviRVMqebetYxL60tGJZ/wMUWvxnZnxxcoB1V0wj
        tX9kGWTatGRvXzXNDhqe8dilfQ==
X-Google-Smtp-Source: ABdhPJwv1eidFbcPTz9i8Dlqlw4ktg2hwOVw+WoLVH5jOamSIQ1CXxQvIplNqHnMOPgikO6AV2QuyA==
X-Received: by 2002:a05:6e02:158c:: with SMTP id m12mr18721522ilu.132.1634663381823;
        Tue, 19 Oct 2021 10:09:41 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j17sm8634387ilq.1.2021.10.19.10.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 10:09:41 -0700 (PDT)
Subject: Re: [PATCH] block: add documentation for inflight
To:     Steffen Maier <maier@linux.ibm.com>,
        Nikanth Karthikesan <knikanth@suse.de>,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211019130230.77594-1-maier@linux.ibm.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <572fd6c4-ccb9-4799-3882-685efa4492ad@kernel.dk>
Date:   Tue, 19 Oct 2021 11:09:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211019130230.77594-1-maier@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/21 7:02 AM, Steffen Maier wrote:
> Complements v2.6.32 commit a9327cac440b ("Seperate read and write
> statistics of in_flight requests") and commit 316d315bffa4 ("block:
> Seperate read and write statistics of in_flight requests v2").

Jon, probably better if you take this through the doc tree. You can
add my:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

