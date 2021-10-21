Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15356C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 15:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0044660F46
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 15:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhJUPQc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 11:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbhJUPQM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Oct 2021 11:16:12 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0F3C0432C3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 08:13:32 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id d21-20020a9d4f15000000b0054e677e0ac5so763021otl.11
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 08:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yHnVkHqSj5BwwhHAlhv7wAcGZEnrphj2uouVF5jVP/s=;
        b=sOlAv4ipGzcArxwkp54XTdEqr+Rdy+Mw+N+tfFcUGHGrbCHrTP8Vzo1qFMPI2SmQRz
         nLurM1odMHo5Z2MR1Y+fIj8BsOvd06PasMR5EqAqUNsdep6waT+zC7fLWCOqkVYq0XWM
         OPTu/XceL/pBNEAsnpA22mEqL6iCc1gTTT5W0n2IxEdWozT550zc/aE+GARkODcn6R19
         2dVtgtR3w94a+hRxBZme0NFkpp1jV2oIdbGnM3IRPpqCUBJKPQh0AF9OBlcT77ORXwXg
         EqE30aOPGZ83XnohR0xca/AFKY6J77XytcXNow4qd6e9d6tUm53pPcgg1jiSYb1U09dm
         Xh+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yHnVkHqSj5BwwhHAlhv7wAcGZEnrphj2uouVF5jVP/s=;
        b=yFN7NoTfnBJYWVqsuYbkq8OpYgp6MkJ9egno/FB20K2Bhuo/CY58+AcmrNloQShouf
         F9insAkloQT0u1Vf+0URN/EVz7A9FC2sM/eyqYXMuiRL0BK8mPlIDqJCYjMsRyuJEm4N
         MHi6RmFiWquRVUR1km3YScSm08ZqRvnf5kwbifgH7MNstGOOeqJTd5IjxZG/nfAQB9y1
         2mLxrOJpvsf4jSH7K79DRPL6COBl/pkOWU5Bb1gBz5t5WwIsD5icSSsUhct84zi0QWh4
         qaeVGN+/+NibMeCfNsEbn8Wu1vXkyuEoPazEdsvWp1GmrhqbKqDpNb4726wQlYkl2AaS
         kbXg==
X-Gm-Message-State: AOAM533BgqMfqF332+sBnrAI0y4PMJ8bGnGBnSxlVhUfBqrZDod8R7pN
        0DaziUMD2OignOUsni4gvt29Ng==
X-Google-Smtp-Source: ABdhPJwKEJu+DEJtf3r2oj6Zo2hVUWDcklyzGD5PtpycXduYR7gV+IodmAmMDKxiPX8lPlYypO2JqA==
X-Received: by 2002:a9d:3e03:: with SMTP id a3mr5267633otd.39.1634829211627;
        Thu, 21 Oct 2021 08:13:31 -0700 (PDT)
Received: from ?IPv6:2600:380:783a:c43c:af64:c142:4db7:63ac? ([2600:380:783a:c43c:af64:c142:4db7:63ac])
        by smtp.gmail.com with ESMTPSA id v13sm1143141otn.41.2021.10.21.08.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 08:13:31 -0700 (PDT)
Subject: Re: please revert the UFS HPB support
To:     Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20211021144210.GA28195@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <84fac5a3-135a-2ac8-5929-a1031a311cb7@kernel.dk>
Date:   Thu, 21 Oct 2021 09:13:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211021144210.GA28195@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/21 8:42 AM, Christoph Hellwig wrote:
> Hi Martin,
> 
> I just noticed the UFS HPB support landed in 5.15, and just as
> before it is completely broken by allocating another request on
> the same device and then reinserting it in the queue.  It is bad
> enough that we have to live with blk_insert_cloned_request for
> dm-mpath, but this is too big of an API abuse to make it into
> a release.  We need to drop this code ASAP, and I can prepare
> a patch for that.

That sounds awful, do you have a link to the offending commit(s)?

-- 
Jens Axboe

