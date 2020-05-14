Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A219C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 15:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29FF12065D
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 15:48:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="W7tvPmNX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgENPsq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 11:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgENPso (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 11:48:44 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A926C061A0E
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 08:48:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n18so1485978pfa.2
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 08:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QVPTIvQu1iziTRFJKhGerxR/iOcOw9CHIi8aErYZvwI=;
        b=W7tvPmNXua7Zb4ois7BKrYv6djiJ340OMqd6V9VkYsjKKq02CeNU2MrB9sbFTpPv8t
         HXBrK8UpJCZtqLYeXZk9Xaki/zKMdq5hz8B0bBMLc4DKGXSSIBl4eWI39VcmfGkAioR8
         LwnIECtuAXxqRmLUjxX6kcgK+jnLBdwXFx9YQmg6Gv74BBwOSEwGjEakU7HKZKnaP0tg
         5qRBWgUPFUeLMhS8uFN0QUXNU4mKbL//V8OjGV4Kd9GbWFD562HRbaPJwdrgWoSzuFdz
         GWglB43zGMi5wJDrA07Snl31/95hIkh8b+PUxpAaWE2kAZZhuohnJ8QHPy+6HTqTrJQs
         oXpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QVPTIvQu1iziTRFJKhGerxR/iOcOw9CHIi8aErYZvwI=;
        b=qh7JdsAvTidZ8LxtE6nFpKlC6gUUUZwIDY5gUzaJAoCY7TQeWjeHK2IBI6a23OaW++
         yikiRquggSJqn3RdlRXZdJeN6nJ+3EO41MP/xnCWzSD24iiwOtA9KQ4qEXsHOE8wdwoF
         Lzj6wFOUOwwVjPN/eViG+L+GNvwhRI+Aaiz9yqiUrataMhkSzlC6tcRhfKMJMfZxDATS
         OnTnSYgxp6uC6hwu94AjgKdCE1TNZ1pbNkDcWMUURpA36E+LVtjk/mj6341oX/sPQpCo
         nQhxvOHQheTcGmqv9+NLUMlWVXYTCEeDgQ2TrrclRdE9g9haB7CsRg7c71y+Iaf0AEnE
         2GTg==
X-Gm-Message-State: AOAM532972Wr6lK1mz9BkQBt9xoaOvvwfc2zlby1wHDTJDiSKoo+8PBf
        qugGSOtz78W8UduIo30OSQnILQ==
X-Google-Smtp-Source: ABdhPJxZsYPJZ4Q8VPYRGcHpXPqCXWdM4J7nk0x45q/cxf3ZKfN+0DFDU6LoyE+BI+dk41Ok9vLQTw==
X-Received: by 2002:a63:1f43:: with SMTP id q3mr4715455pgm.386.1589471323757;
        Thu, 14 May 2020 08:48:43 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:85e7:ddeb:bb07:3741? ([2605:e000:100e:8c61:85e7:ddeb:bb07:3741])
        by smtp.gmail.com with ESMTPSA id x62sm2636477pfc.46.2020.05.14.08.48.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 08:48:43 -0700 (PDT)
Subject: Re: [PATCH v13 00/12] Inline Encryption Support
To:     Eric Biggers <ebiggers@kernel.org>,
        Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
References: <20200514003727.69001-1-satyat@google.com>
 <20200514051053.GA14829@sol.localdomain>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8fa1aafe-1725-e586-ede3-a3273e674470@kernel.dk>
Date:   Thu, 14 May 2020 09:48:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514051053.GA14829@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/20 11:10 PM, Eric Biggers wrote:
> On Thu, May 14, 2020 at 12:37:15AM +0000, Satya Tangirala wrote:
>> This patch series adds support for Inline Encryption to the block layer,
>> UFS, fscrypt, f2fs and ext4. It has been rebased onto linux-block/for-next.
>>
>> Note that the patches in this series for the block layer (i.e. patches 1,
>> 2, 3, 4 and 5) can be applied independently of the subsequent patches in
>> this series.
> 
> Thanks, the (small) changes from v12 look good.  As usual, I made this available
> in git at:
> 
>         Repo: https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git
>         Tag: inline-encryption-v13
> 
> Jens, do you have any feedback on this patchset?  Is there any chance at taking
> the block layer part (patches 1-5) for 5.8?  That part needs to go upstream
> first, since patches 6-12 depend on them.  Then patches 6-12 can go upstream via
> the SCSI and fscrypt trees in the following release.

I have applied 1-5 for 5.8. Small tweak needed in patch 3 due to a header
inclusion, but clean apart from that.

-- 
Jens Axboe

