Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F05C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 14:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49D2861361
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 14:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhJTOEh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 10:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhJTOEh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 10:04:37 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8840C061746
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 07:02:22 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id y207so9722191oia.11
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 07:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fasKjH6neLHJGQKXWnbpfp+Zf9dplFj5ge5uyM8zytE=;
        b=PGBxqdHOBR301r3rq795pclPkLqGKtwnB9xJwXfpJo03061xsV6pSaZ00HMZs+mFgp
         fyVU09SJpZOpkXRL1Q8qOCQt0+c3RRQ9Xx8756TROD78333jwnztkc2tlhPl/7BR5sWy
         wZl5X9C7o9pW4ngO8otOJLU2Ha+TcsNuv0uzkotcsqn9Yk1GQ4mmCoQEqSRcvIKBwLgV
         SDqRpErEQUCgPyyYnSpFkj9eLfVo0udVO+0jYpDi1Rd1M3FyRZ+7JLZWAJUadOa6+LUb
         KSHdq9KW3rv+pDtrppXFZ/aNMMPf8P4PSXg+PWKpunH7i6A3i78g6TIuGdGOvKskDFIC
         i+dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fasKjH6neLHJGQKXWnbpfp+Zf9dplFj5ge5uyM8zytE=;
        b=JFN0IbNWwczb0pHjECjVb7UTCiwUvO4kUwFipBb3YHRdtUFJXC+ySnTImR9rUyK3z2
         ltaiT4pFVE4641V1p+1AZDA6LwEGiOO8XU/tUTqLrtveKX7Ry0xDlYIEK5er8ytWGrGE
         2UoyAq2PKGY/wCkupWOFK1EFCYnCsUKAtwRZHfz/SeiLo49fqcxFtnY0hR3koO6G3X/T
         jl5qY3sCyzYCitptCOAzj7kIPoa9WFzgKMXesSSVvOQYk5NNGAF1IMUUBGKKJBjaG2l2
         hN1Gyfj0unUq/bDEkCVXDYjiuazdTw4xXPmk0HYrbj+v9HsaDiz7XuoZc1VbLHmRSF4S
         8g8Q==
X-Gm-Message-State: AOAM530qwjwLzmIJTxE18zJID3sygYE6ihy4NsUb8a9M5ZfF86kKOF8J
        r3R657y5bgl1MsxGZ3AW4dR///9vvTUQnA==
X-Google-Smtp-Source: ABdhPJwZr4sXlpWImaGdcJgkClNFE73Vt4YBcOqCPNapcAtcyCPykp9pp/0iKQC8MCc1RUu3hIlnLw==
X-Received: by 2002:aca:c1c3:: with SMTP id r186mr9571156oif.79.1634738540342;
        Wed, 20 Oct 2021 07:02:20 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x62sm464931oig.24.2021.10.20.07.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 07:02:19 -0700 (PDT)
Subject: Re: [PATCHSET v3] Batched completions
To:     John Garry <john.garry@huawei.com>, linux-block@vger.kernel.org
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20211017020623.77815-1-axboe@kernel.dk>
 <b47e9ae3-52e0-8cfa-9dcb-bfd46ad4c46d@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <27be55bd-2a94-2c11-bf9f-934cefb9dbbe@kernel.dk>
Date:   Wed, 20 Oct 2021 08:02:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b47e9ae3-52e0-8cfa-9dcb-bfd46ad4c46d@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/20/21 5:14 AM, John Garry wrote:
> On 17/10/2021 03:06, Jens Axboe wrote:
>> Hi,
> 
> +linux-scsi
> 
>>
>> We now do decent batching of allocations for submit, but we still
>> complete requests individually. This costs a lot of CPU cycles.
>>
>> This patchset adds support for collecting requests for completion,
>> and then completing them as a batch. This includes things like freeing
>> a batch of tags.
>>
>> This version is looking pretty good to me now, and should be ready
>> for 5.16.
> 
> Just wondering if anyone was looking at supporting this for SCSI 
> midlayer? I was thinking about looking at it...

Since it's pretty new, don't think anyone has looked at that yet.
I just did the nvme case, for both submit and complete batching.
But the code is generic and would plug into anything.

-- 
Jens Axboe

