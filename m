Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29212C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 21:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F11B220679
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 21:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732372AbhAYVPl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 16:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732581AbhAYVPP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 16:15:15 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00914C061573
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jan 2021 13:14:34 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id lw17so362984pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jan 2021 13:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qRHVlys2zAjjxBtjE+T6wwnyF8H38Om4NwqdpPjEWwM=;
        b=XJ6Etu3MXGdkNqFWNxmgTkstn5En/9aC8l8yyMUXyYE3wCP9zGyS2+HSQJ1I0mwg63
         1iigcIsBBPA/wvpReIFCrkTxffBIgLQ0eTlgAl3USfTYLmMl+dFPLwOrED/C+Xxdtrc9
         0YfFifIVT0hCyBp0W2XVYhLuNWiYWsjlO2W2AnUDLkODBTsusnyoNCKtMQN60UB7Y+VD
         rZbG0Fh8LevhgLJk43X6VXrrLQ6l0rX7awWPrdGAUYqgVzd5cSpFd0d1jm4PfkBwuCjX
         BSq5KEn9OYAZY+LZrMjK8ZU8SoBm+cAr2PkM3EGg1yuypLHblRFwzA03nmRkNKBSQV5N
         cC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qRHVlys2zAjjxBtjE+T6wwnyF8H38Om4NwqdpPjEWwM=;
        b=q+MC2/YD8hHXZDfJSmukMJmDYkOSFook5mhrA+I6dm3DiDV0j0YQ3X3Fw1Wh9kab1A
         eenkb6T/hmQWCHS7PmnU4HfCP1Y1PJEsx6RxFRHpWTtAexWR+HtjUiwo3Dp4uWwiZ1Sl
         cj3oy7+8y3Q19AUoPjwiD0u8LB788zllnNz6O5mjFFuvelx7apWkWaylOTPLA8hUuSVZ
         pkbQMmIGcL89Y4i+SbDw8URlCmcXPdapNxf8SQUQyDa497nyFZVTFadRD4j+lSy/fCIc
         cKNK1ht9Gp4K2kzIEIKc2JJxqMLGoHQIE96+4jy20BPOwC2T4nxo6WxtDgnCeLsRo42/
         xymg==
X-Gm-Message-State: AOAM533qjJdE6HynF6eMDg2Ba6JiNnXur11q188RH8tsNVeKbXWqLWF7
        k/KN3ep6Viy6ocQWBef48tY9EA==
X-Google-Smtp-Source: ABdhPJyu4y6/35DKByDjoOtf3OGFpY5YYhLb7LjvpjQwqZaT4/kHlkcBWKXiBbFTRzB5pEth1NfUJg==
X-Received: by 2002:a17:90a:c907:: with SMTP id v7mr2207890pjt.0.1611609274381;
        Mon, 25 Jan 2021 13:14:34 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id r14sm18607214pgi.27.2021.01.25.13.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 13:14:33 -0800 (PST)
Subject: Re: [PATCH 0/2] Resource-managed blk_ksm_init()
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-block <linux-block@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Satya Tangirala <satyat@google.com>
References: <20210121082155.111333-1-ebiggers@kernel.org>
 <CAPDyKFrLn_4Csxc6BeRR0-zY+_RQuNqNSF9SmKk3Bx2WFJJ_Ag@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2d03dda2-adaf-a44a-922d-f3770e3da8f4@kernel.dk>
Date:   Mon, 25 Jan 2021 14:14:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAPDyKFrLn_4Csxc6BeRR0-zY+_RQuNqNSF9SmKk3Bx2WFJJ_Ag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/21/21 5:50 AM, Ulf Hansson wrote:
> + Jens, Martin, James
> 
> 
> On Thu, 21 Jan 2021 at 09:23, Eric Biggers <ebiggers@kernel.org> wrote:
>>
>> This patchset adds a resource-managed variant of blk_ksm_init() so that
>> drivers don't have to worry about calling blk_ksm_destroy().
>>
>> This was suggested during review of my patchset which adds eMMC inline
>> encryption support
>> (https://lkml.kernel.org/linux-mmc/20210104184542.4616-1-ebiggers@kernel.org/T/#u).
>> That patchset proposes a second caller of blk_ksm_init().  But it can
>> instead use the resource-managed variant, as can the UFS driver.
>>
>> My preference is that patch #1 be taken through the MMC tree together
>> with my MMC patchset, so that we don't have to wait an extra cycle for
>> the MMC changes.  Patch #2 can then go in later.
> 
> Sure, I can pick patch #1 through my mmc tree, but need an ack from
> Jens to do it. Or whatever he prefers.

Or we can take it through the block tree, usually the easiest as
it's the most likely source of potential conflicts. And that's true
for both of them, as long as the SCSI side signs off on patch 2/2.


-- 
Jens Axboe

