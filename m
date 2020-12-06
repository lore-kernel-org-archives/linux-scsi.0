Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB8AC4167B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 10:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44DE3230FA
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 10:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgLFKQ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 05:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgLFKQ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 05:16:58 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36296C0613D0;
        Sun,  6 Dec 2020 02:16:12 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id u18so13762824lfd.9;
        Sun, 06 Dec 2020 02:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WHV07lAOVmhSmkP5MngljG1mtktpzKayNMNHBzWj6Lc=;
        b=f38mKdf7dAAFQ1WpYRMiX1k3BkdvcSG5X0TxntQ5iKUL7I1WItPMjlum2Ayeb/hmYx
         F1S8ImgpDUQVwofJQOx6Q0CG9H5bMEpH2ehPDUgDvyBezdxC52O0nKhJ+zinsXW4nuz0
         Erq33WEyG2yrioEs249m2NGP2YKeF2oYODi/IPBrxi1VHP5oNKQaHlvobPDIJZM8sC8r
         LcGI3AyMTu/gu9lHxEGJXqXaXfjt8YCbPet0Rnh0fUijjL7YVbajayzj5e3lsoEw9cWd
         s2ZKW3kyCGWtGfekWVWr4XUSEr8YUs617mwGQvqwlVdb2kxHR3z8ttsAquigAr9mLwoT
         +Iuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=WHV07lAOVmhSmkP5MngljG1mtktpzKayNMNHBzWj6Lc=;
        b=fiK0ZA/qQKN/2iDMnQSo1qyr7BHsb9dbZJ0GQDHkcJfqtLEwoR+6vMMZZFa0vHWBEc
         /+dpSQXrUhqIvklogkE1WzJy4JakwwwF4Kf1iEiTrqWEGTIBMRI50b0NFUDVm0HEADHH
         YYoVGE0jjonJqkgk3CRgNX50q40eWiEjZKMHTAQQOqKMWWrOGiF8JmAfDT9+e6soOd2v
         /OsqBgb6LQWxkDNIWdhepgd7FtmBZ3q3kjCOSSTzBpNuBx+4CZeLMIHBHu2gLV6Wt0ri
         1/6MTGeV8m9w7F/Q9D0fOoEYUuBVInO+9fKN0rPDd+Z+TlSbDZ6gxw2N/ythSg9yP2bz
         R2xg==
X-Gm-Message-State: AOAM533fPi0Z9DYECS6IHPjvnZOxIwKnnmqrKcqy4JlH3TjeR5chnsN9
        bHZzaULIHRlkoDlorX9wjjslepAImBk=
X-Google-Smtp-Source: ABdhPJyATWIKiA4tyYtxbtxJZGhv50GEP/5neZh9nMFgHvQe4Q1TZRv7HUHQD1YoO8KrKXlx4/1Dqg==
X-Received: by 2002:a05:6512:419:: with SMTP id u25mr6080248lfk.222.1607249770583;
        Sun, 06 Dec 2020 02:16:10 -0800 (PST)
Received: from [192.168.1.100] ([31.173.86.115])
        by smtp.gmail.com with ESMTPSA id g8sm2460815lfb.223.2020.12.06.02.16.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 02:16:10 -0800 (PST)
Subject: Re: [RFC] block: avoid the unnecessary blk_bio_discard_split()
To:     Tom Yan <tom.ty89@gmail.com>, linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20201206061537.3870-1-tom.ty89@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <55e0b8be-a16b-9895-fde5-b325773ae0e7@gmail.com>
Date:   Sun, 6 Dec 2020 13:16:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201206061537.3870-1-tom.ty89@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello!

On 06.12.2020 9:15, Tom Yan wrote:

> It doesn't seem necessary to have the redundant layer of splitting.
> The request size will even be more consistent / aligned to the cap.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> ---
>   block/blk-lib.c   | 5 ++++-
>   block/blk-merge.c | 2 +-
>   block/blk.h       | 8 ++++++--
>   3 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index e90614fd8d6a..f606184a9050 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -85,9 +85,12 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>   		 *   is split in device drive, the split ones are very probably
>   		 *   to be aligned to discard_granularity of the device's queue.
>   		 */
> -		if (granularity_aligned_lba == sector_mapped)
> +		if (granularity_aligned_lba == sector_mapped) {
>   			req_sects = min_t(sector_t, nr_sects,
>   					  bio_aligned_discard_max_sectors(q));
> +			if (!req_sects)
> +				return -EOPNOTSUPP;
> +		}
>   		else

    Needs to be } else { according to the CodingStyle doc...

>   			req_sects = min_t(sector_t, nr_sects,
>   					  granularity_aligned_lba - sector_mapped);
[...]

MBR, Sergei
