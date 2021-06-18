Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD92C49EA2
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 22:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C4EA613DA
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 22:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbhFRXAY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 19:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbhFRXAX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 19:00:23 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1943C061574;
        Fri, 18 Jun 2021 15:58:12 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y15so3043167pfl.4;
        Fri, 18 Jun 2021 15:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AiOSd2tE//HdXtO7NNcBY5AKe4g51NwiW8yfeGw8NeE=;
        b=JCAAZVVt3fiPXNjRK4B/rykqCnHoXo+oFLOD1njNkEGYR4A2F7xMOuspV9IyOJVPds
         qbm9OdWEn1WXiV4DGxdwezKeEO+PUu14nzlmIW2suBHUEiPGlq7w9RdD3Jh7MK2nPRD8
         5X2scL2NTu8gkiyV1OhioDUMIwquKoj4Wqb4+ci30luf8GGMvEivKuFY6Igoq+Lrv9um
         I1euJhqWLTr39CXj2kC8w3zDuZy8vT+hfzXWYpTEFnFcI0XSofz6g39rwlJ2vJAoOq+y
         CENNZRDEfedp/usYMGtYcyOj6A+KyJNFqZ+Hjfv0i/JbfnTDcotJDLvLZZ0LANIREkpv
         WDPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AiOSd2tE//HdXtO7NNcBY5AKe4g51NwiW8yfeGw8NeE=;
        b=qqAFqMlfJsKO9lHlm+g4dn5W11ZCGBf90xHUBV2FVpN9kgQwLPSEKoMx/NxoeFR78p
         2NPeezb9pNe9dlq1lJ6d77Rmji5TDc6Xp2h3RqNtPM40CE+LMTPCEnLYTHzioehYfZ/r
         15e96E0D4ygxXI1d1W6rtDMqwEki3iSe3Rpjmq81ByE1tbnuBD6m8gEGxmtGbCZeKdQ+
         KLvzOTLJ93G3qx/fywIvFeLiQRqsiWpFKvZjtlCXSU29YBSEh4HcEGoofJrOfReMU6Qp
         KAViiOAWi3aNg5OGuzN4MqV7tQzBNuYOtlZIr3VUE7As1MNbtvae3/+KHI8hAmJTy0Zy
         LfAg==
X-Gm-Message-State: AOAM533Xkbz7eJ2kbxyECISpN9ZQ2iDLlT9jL8zTEM92Jv6W/DFwF6F5
        jRc0XWjqolFm32rtAJBQtVBvo7AnJRg=
X-Google-Smtp-Source: ABdhPJzmIqluYN9IX6fyLzoDby8QdVZWzkU2qzeaMsbpZXWxXs3BS+iU2rKz7qkFJkqRn4AR5yJMeg==
X-Received: by 2002:a62:e908:0:b029:2db:8791:c217 with SMTP id j8-20020a62e9080000b02902db8791c217mr7596611pfh.28.1624057091995;
        Fri, 18 Jun 2021 15:58:11 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m2sm8151862pgv.40.2021.06.18.15.58.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 15:58:11 -0700 (PDT)
Subject: Re: [PATCH] scsi: elx: efct: fix uninitialized variable in debug
 output
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        James Smart <james.smart@broadcom.com>
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <YMyixn98qQXjsiqe@mwanda>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <4cb2ba03-f65b-6b09-c595-3358bae0e639@gmail.com>
Date:   Fri, 18 Jun 2021 15:58:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YMyixn98qQXjsiqe@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/18/2021 6:42 AM, Dan Carpenter wrote:
> Move the debug output down a couple lines so that "id" is initialized.
> 
> Fixes: 692e5d73a811 ("scsi: elx: efct: LIO backend interface routines")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/scsi/elx/efct/efct_lio.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 

Yep!

Same patch sent by Nathan Chancellor:
https://lore.kernel.org/linux-scsi/20210617061721.2405511-1-nathan@kernel.org/


-- james


