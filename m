Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12611C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Sep 2021 17:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAAD360F56
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Sep 2021 17:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbhIDRoG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Sep 2021 13:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237260AbhIDRoG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Sep 2021 13:44:06 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50718C061575;
        Sat,  4 Sep 2021 10:43:04 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id e26so1538014wmk.2;
        Sat, 04 Sep 2021 10:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GOezhxZvybL03SR42UwYD0Y+5sUIX9feUoEYWm7GRr8=;
        b=JkwzcThnF4K7EPycjYmDC68035fBTCz16gSYwSMY9rC2JYT3OZzTL9C71+/HdTt1x9
         eRbDLv4pdv/6wO9CVDEF2a9kJ7GD+RL/VAYgb9DQXM/25BuKPFQUHWGSANRZAaky3zWD
         +w/kKLX1q2iiWN+vNiZ4BXMRVEnIDS3uySOsYVoOBAJYu2zddPEOOKoiOXEY77F0l+TV
         nwVK3K2lnlqYJTXwYN1wgcuNxcQsnhS+hEYFMgQchgvBoTKr7Y/LcIShbzXCf7adar6j
         OP4Ft8OCNaiEANzko33Lu8BT2VLgtQfpgI5zfNbx5Ek/OUrqmL3G7wxbzgrJyQwIvBnc
         w+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GOezhxZvybL03SR42UwYD0Y+5sUIX9feUoEYWm7GRr8=;
        b=cCi860mkpNFyA7wkCn/qVBmqH9K5ZztI2sWxFV1f9WSpjjLSc3w6s1RfICpTbPB2Xg
         SX4Gv10mmyQJ2PtOWxQkyPS/gVFOCpb1dc60FU77k8GM8MDulENDAMRyPbfgFArx+t40
         cFWSu1pdCeVCz+frUPXTuLvNF4DU2EBjMsfabf8ogpmUBNWBJjRb2JVEkM/QpgTxff3e
         3oS1lvVIKyFMeV9UZc5ARW+BDHianSb7pum4sAdLmOuT+J5cGnCC2enCxLw5dS6L76+e
         mhEm7bhEMQCIyCGwYHOWibVoAjtpRj0WJZVXIjdTKfdyw7W12cUoPfqj99QaO8GiIQ+N
         MzbA==
X-Gm-Message-State: AOAM530OdtWKNDVs8kAVAn+cpJtcndGU3HjHjk78P9OyOgG1Gm4NBpox
        +92oDtiwFKXWm3mb1uj4kch/ILcUqdw=
X-Google-Smtp-Source: ABdhPJzthRe236dlreNRUfoLCVBGsDyIa5XxHytIU1QqlhKQBW+8A7ymAhrG0kLOWW5y0GUYkVy7JA==
X-Received: by 2002:a7b:c0c7:: with SMTP id s7mr4030670wmh.66.1630777382990;
        Sat, 04 Sep 2021 10:43:02 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc061e7.dynamic.kabel-deutschland.de. [188.192.97.231])
        by smtp.gmail.com with ESMTPSA id c9sm2676111wrf.77.2021.09.04.10.43.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Sep 2021 10:43:02 -0700 (PDT)
Subject: Re: [PATCH] target: fix the pgr/alua_support_store functions
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20210903124800.30525-1-mlombard@redhat.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <2390a75b-676e-9ca2-068c-707d30278040@gmail.com>
Date:   Sat, 4 Sep 2021 19:43:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210903124800.30525-1-mlombard@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03.09.21 14:48, Maurizio Lombardi wrote:
> Commit 356ba2a8bc8d ("scsi: target: tcmu: Make pgr_support and
> alua_support attributes writable")
> introduced support for changeable alua_support and pgr_support
> target attributes. They can only be changed
> if the backstore is user-backed, otherwise the kernel returns -EINVAL.
> 
> This caused a regression in targetcli/rtslib because now a warning
> is triggered when performing a target restore that includes
> non-userbacked backstores, even if rtslib is not trying to change
> the attributes' values:
> 
> $ targetctl restore
> Storage Object block/storage1: Cannot set attribute alua_support:
> [Errno 22] Invalid argument, skipped
> Storage Object block/storage1: Cannot set attribute pgr_support:
> [Errno 22] Invalid argument, skipped
> 
> Fix this warning by returning an error only if we are really
> going to flip the PGR/ALUA bit in the transport_flags field,
> otherwise we'll do nothing and return success.
> 
> Return EOPNOTSUPP instead of EINVAL if the pgr/alua attributes
> can't be changed, this way it'll be possible for userspace to understand
> if the operation failed because an invalid value has been passed
> to strtobool() or because the attributes are fixed.
> 
> Fixes: 356ba2a8bc8d ("scsi: target: tcmu: Make pgr_support and alua_support attributes writable")
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
