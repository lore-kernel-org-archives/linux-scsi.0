Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB1EC61D97
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 01:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjA2BJe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Jan 2023 20:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjA2BJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jan 2023 20:09:30 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B10022784;
        Sat, 28 Jan 2023 17:09:26 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id jl3so8392257plb.8;
        Sat, 28 Jan 2023 17:09:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Zoo/V0eZrLefo71ZNF/gT6IlRqxqqc8xotST2bLhTs=;
        b=cXw/yA94dsZ7ZIUasZDNqgid7PhgT/0i5J8lGNzBznBZg9gbYBRKrZl1F7ajU66o6S
         UzqBsvWJuZAJW3+WFZnUAV2baA/3dnfkmzGTZHXISawa69Rkcq6eOd24WXlD2gWrM3KG
         NKGxNpalD5oJj8mNv4bAGHo7Q4JKpSoc7bE8GFylG6JxtMNTpy/wvK1JPC/ZZNHmzZOL
         REqOJxdTCsj0eBmFErrzXq5ZX1F4OuikyGIEgoEYe0r13tJ+P0LNAMCabGNHFa/XM7wf
         RVr02MMMI41P8zpSY3bFc6ML448v2ebnVc8OPkoXBANjMr7udd1oAGUi0JR9Bs5Yz/lR
         OqtA==
X-Gm-Message-State: AO0yUKUZS7TvfBcPzxh8MIS2EKf0Hf91Fo21tdBVkkg6g0Rm1X9jgq6R
        3+NRtxbSUjKfc1n6gLXkH74=
X-Google-Smtp-Source: AK7set8+SmjTPwNcDl30yr8kyoQv4S40li+EgjlGfNK5qbCUty3s4n/0McDYAmjRAJelJVhhQIb6Xw==
X-Received: by 2002:a17:90b:1c05:b0:22c:4e1:937 with SMTP id oc5-20020a17090b1c0500b0022c04e10937mr4298261pjb.10.1674954565633;
        Sat, 28 Jan 2023 17:09:25 -0800 (PST)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id bb12-20020a17090b008c00b00226eadf094dsm5017190pjb.30.2023.01.28.17.09.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Jan 2023 17:09:24 -0800 (PST)
Message-ID: <ff34ea59-0aab-6aa9-2960-896f284362b9@acm.org>
Date:   Sat, 28 Jan 2023 17:09:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 9/9] scsi: ufs: exynos: Select
 CONFIG_BLK_SUB_PAGE_SEGMENTS for lage page sizes
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <20230118225447.2809787-1-bvanassche@acm.org>
 <20230118225447.2809787-10-bvanassche@acm.org> <Y9Scs+S9vOwe0q53@T590>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y9Scs+S9vOwe0q53@T590>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/23 19:55, Ming Lei wrote:
> I remember that PAGE_SIZE is still 4K on Android kernel, so
> UFS_EXYNOS should work just fine, or Android kernel is going
> to change PAGE_SIZE?

Hi Ming,

We want to improve Android performance by increasing the page size from 
4 KiB to 16 KiB. Hence this patch series.

Thanks,

Bart.

