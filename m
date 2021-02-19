Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A75DC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D26864EB3
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBSTjF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 14:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbhBSTjE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2021 14:39:04 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2010FC061574;
        Fri, 19 Feb 2021 11:38:24 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id g5so15699055ejt.2;
        Fri, 19 Feb 2021 11:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RlHhU71R+2+AVFgRHvyfF0VBduRqlfbsVAH5JN6QCJk=;
        b=bhTG5kYmo/b950NOaKVPuReQD9ga3yoq+AB6BkflnTGMn1ysclUlwIBOr/Stj4GIs6
         birm18utJ7yvjYtIN7TwDIdPWD4fTQoisFL5bvrEXpCd7Wln3pG8psx5yVYXAMjSi4Qj
         agrhE/Gp7rmUHy2PAm9qB4UGzQW3XWnWWh+CqnpFufRmyo9cjcmRFwZFRlHqipmJfg6i
         hYrJD3H5ilBOkwwNnfwbmnJVlK/i6lXImTv5LJa6Xil4BHX1dsaqJhcy8QSvneC8qkVM
         uAXusJ+sQ68IrI1qgAVjbHz66dcsvZQ350YYSWBF1Owi41S35jeU6Oudbn6fJWXAbhu4
         jC3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RlHhU71R+2+AVFgRHvyfF0VBduRqlfbsVAH5JN6QCJk=;
        b=JDpAUHO7K1mvRnnxVBP0SMKlQEP0Cxur7tqsRPher7jwJaOlYQY6Lzj/otP/5be0k6
         2GaZF697qdMd323Xj9DTmjMarcwMrB96jL87Fq/eK5QqvUxbrAa48VE3z07XNzi9Jkxg
         KgbymD+V7pUyuz9jD0OcfrclJrSHVjUZQgT+dR2gsou3IgUvmyKPVvQodpu6aJaACU5J
         Dk3IvKsGKuRMQmBkkEXuK/NPoyrbWtdVASnrbqceAtgZVJjtoxFXSuVU4eTdpQw9IhWg
         1pl1aFIJOXsQ7lwAFcnOcNJ1v6HrE2fTuBRiAxruJ0BIME5RN6xWrvpwn/dc3db/Ya/R
         /hkg==
X-Gm-Message-State: AOAM531qVEAAkYs9l9QDcw6veMjvg2JvdVbdP+ioFuAlhOUgbow/6Jx1
        kAhL/UyfoxsZhHPZMTOcn6j8ntAETzQ=
X-Google-Smtp-Source: ABdhPJyQjz1JDL7MtxWzPsdF8MH3vsKkATJ0w5h7t6fndD4RWPeVCFXS00MsCNJcyQXGRFhHQ9S6aA==
X-Received: by 2002:a17:907:e8f:: with SMTP id ho15mr2327633ejc.233.1613763502829;
        Fri, 19 Feb 2021 11:38:22 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id hr3sm4719781ejc.41.2021.02.19.11.38.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 11:38:22 -0800 (PST)
Subject: Re: [PATCH 19/25] tcm loop: use lio wq cmd submission helper
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210217202811.5575-1-michael.christie@oracle.com>
 <20210217202811.5575-20-michael.christie@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <68014058-614e-149c-3cd2-7542622e18f2@gmail.com>
Date:   Fri, 19 Feb 2021 20:38:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210217202811.5575-20-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17.02.21 21:28, Mike Christie wrote:
> Convert loop to use the lio wq cmd submission helper.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> ---
>   drivers/target/loopback/tcm_loop.c | 22 ++++++----------------
>   drivers/target/loopback/tcm_loop.h |  1 -
>   2 files changed, 6 insertions(+), 17 deletions(-)


Looks good.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
