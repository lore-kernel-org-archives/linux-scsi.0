Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70402C07E9D
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 16:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbiIZQGv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 12:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbiIZQGF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 12:06:05 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E9E25CC
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 07:54:08 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id v128so5398023ioe.12
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 07:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=GFgIjACJN9ef5+O5Og9/DlD2wJW0SUIxL2QcgPrbsYc=;
        b=O6BuwalmwwYXOzo+C/YM69mwnYKMYr8o+VXsmRvl4i7rwPH1XHeNiAWtZYlhHu3x1k
         ABZI2Iw0Glk+PwbhLkcVqjJy13+aSHZm9s3Za2oqc6nV1K1AmDgOUSWmX+KVKGph4Bsa
         Vtj+9n4D2sLGmdmjZz12dBLj6rklBdCVvkckfXkH3xFBKgBm0ee3A3hFOrrsiu3uqHWL
         QeYHgJscKTg88T8/KrFdITuLCVfqvWVszV2ZOaRIBC4FpVne0XcJSgLpIGqCWMsv2qPj
         EMSpHNc0Vb+ilgIJ+rleGG9DdET7ZoUGxEQYCqREFz0goJgMZzIWRJ5BoAvEDg1n17i7
         1Wbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=GFgIjACJN9ef5+O5Og9/DlD2wJW0SUIxL2QcgPrbsYc=;
        b=10jyotJ/M/lN6Ra/aEMmtqrfXhrLeA7Y1EiS0xI35S5C9xKXJX1KSg2VUIiiUGVudk
         99N575FyLY3FNG1ubshi2CmX9v0OzNJ9g2B7eeqxzA0UW8hKXw6CZjjXPuwM1fpF09HU
         WuVPxPDlxVv4zwB1PlV6XS89N4aEf/ZSFMsiqSU5cKiSpO+60IoCVxqfSOzxhaPffJJX
         rvoD36XwDFf2LcZbgMIqTe4l6EHLijf0tR/nXKEvLg9m7obfM/5uOznsXP2PBbEjVaCa
         Lk87ZM46Ek1jw+PDPb9eRC4lrjxDLWipREvdcqWkNz/i298hEVp5h3kWLjGxMVt/uNcN
         oYfA==
X-Gm-Message-State: ACrzQf2uVPVnnIjsk66bxDCpbgGKHP4ObgPj+aBoNbANZN7IP5o9jris
        9HLdzqQSpmUZ6DBM60nkRLtbqA==
X-Google-Smtp-Source: AMsMyM4hzRj1NCt5qjQmyZkoVCT9OWmRSxwmpvJsL6WjnZ+oLf++I8kF1xpoVmAbCJWyaZoIbUOzKQ==
X-Received: by 2002:a05:6602:2b06:b0:67f:fdf6:ffc2 with SMTP id p6-20020a0566022b0600b0067ffdf6ffc2mr9866886iov.111.1664204048218;
        Mon, 26 Sep 2022 07:54:08 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t23-20020a02b197000000b00346e7ca2463sm6868577jah.135.2022.09.26.07.54.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 07:54:07 -0700 (PDT)
Message-ID: <f7b92f52-8a33-4cf0-b8b6-328c573ad1bd@kernel.dk>
Date:   Mon, 26 Sep 2022 08:54:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4/5] nvme: split out metadata vs non metadata end_io
 uring_cmd completions
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, Stefan Roesch <shr@fb.com>
References: <20220922182805.96173-1-axboe@kernel.dk>
 <20220922182805.96173-5-axboe@kernel.dk> <Yy3O7wH16t6AhC3j@infradead.org>
 <d09e1645-919f-9239-f86d-a8e85a133e5c@kernel.dk>
 <YzG5/1zSdiMlMLnB@infradead.org>
 <69598e37-fb91-5b92-bb80-b68457a7b6f8@kernel.dk>
 <YzG6mZhtd/QysvdH@infradead.org>
 <25b9899f-0c60-39f2-179b-789b914e0f0a@kernel.dk>
 <YzG8vsR8j0VIt6Nx@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YzG8vsR8j0VIt6Nx@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/26/22 8:52 AM, Christoph Hellwig wrote:
> On Mon, Sep 26, 2022 at 08:50:41AM -0600, Jens Axboe wrote:
>> Or just the union named so it's clear it's a union? That'd make it
>>
>> pdu->u.meta
>>
>> and so forth. I think that might be cleaner.
> 
> Ok, that's at least a bit of a warning sign.

I'll go with that.

-- 
Jens Axboe


