Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D844C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 16:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F3DB610EA
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 16:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhJUQZF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 12:25:05 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:47019 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbhJUQZE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Oct 2021 12:25:04 -0400
Received: by mail-pf1-f176.google.com with SMTP id x66so1066835pfx.13;
        Thu, 21 Oct 2021 09:22:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XdjveOQuWQpe9c88w6YkAw9IMQkaAD2HUvEGV/fm9Uo=;
        b=FsJYZ+hmsYxlhOzVJOLBJVM7Wdm4/IcXkUDxgxZFuH/8nGc6ytC48+tAspP50jTJxp
         6/XdCtMvGnOoLAwxmK/lVYHUDxm5RjC8urjC3x8nOqVgMNJ4P1wnLF1gqvFmT+GEe0VE
         CQdjQVUmPG+cQfoI0jXeaSOGxgHiPCZ69Tk+XRVq8W0DyvKx2WCyBw8H+BoQsT2pIlGr
         G+zclEQCDXTuG9Kyd9+1wq6c6XBFLsaMVhkLwdhQaaeK3/BVXgO7GM4r18EDrwCF74eY
         yHwRQR7+gdoljUQPuXskHhFixt77oQeQxpud0iGU3+PfHvBMsIWJ+3Xiz8iedRK5mXND
         QyaQ==
X-Gm-Message-State: AOAM530XK536C55xCFCiA04q528qelDIBqjoLX1eect/K243reZJEKtx
        GrhF0yqCfLyDElHl8+qDVk4=
X-Google-Smtp-Source: ABdhPJzTVu0+/rGQjKRaHpEV4QXGZMVCOqOrVWkgv0AeSRIkkc4jbpl7CEra0juPsyBghRAy6pQTCg==
X-Received: by 2002:a62:3387:0:b0:44d:7ec:906a with SMTP id z129-20020a623387000000b0044d07ec906amr6543521pfz.69.1634833368168;
        Thu, 21 Oct 2021 09:22:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:452c:8e0d:d8a1:4d6])
        by smtp.gmail.com with ESMTPSA id s22sm6407691pfe.76.2021.10.21.09.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 09:22:47 -0700 (PDT)
Subject: Re: please revert the UFS HPB support
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Daejun Park <daejun7.park@samsung.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20211021144210.GA28195@lst.de>
 <84fac5a3-135a-2ac8-5929-a1031a311cb7@kernel.dk>
 <20211021151520.GA31407@lst.de> <20211021151728.GA31600@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2cba13c3-bcd5-2a47-e4cb-54fa1ca088f3@acm.org>
Date:   Thu, 21 Oct 2021 09:22:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211021151728.GA31600@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/21 8:17 AM, Christoph Hellwig wrote:
> On Thu, Oct 21, 2021 at 05:15:20PM +0200, Christoph Hellwig wrote:
>>>> I just noticed the UFS HPB support landed in 5.15, and just as
>>>> before it is completely broken by allocating another request on
>>>> the same device and then reinserting it in the queue.  It is bad
>>>> enough that we have to live with blk_insert_cloned_request for
>>>> dm-mpath, but this is too big of an API abuse to make it into
>>>> a release.  We need to drop this code ASAP, and I can prepare
>>>> a patch for that.
>>>
>>> That sounds awful, do you have a link to the offending commit(s)?
>>
>> I'll need to look for it, busy in calls right now, but just grep for
>> blk_insert_cloned_request.
> 
> Might as well finish the git blame:
> 
> commit 41d8a9333cc96f5ad4dd7a52786585338257d9f1
> Author: Daejun Park <daejun7.park@samsung.com>
> Date:   Mon Jul 12 18:00:25 2021 +0900
> 
>      scsi: ufs: ufshpb: Add HPB 2.0 support
>          
>      Version 2.0 of HBP supports reads of varying sizes from 4KB to 1MB.
> 
>      A read operation <= 32KB is supported as single HPB read. A read between
>      36KB and 1MB is supported by a combination of write buffer command and HPB
>      read command to deliver more PPN. The write buffer commands may not be
>      issued immediately due to busy tags. To use HPB read more aggressively, the
>      driver can requeue the write buffer command. The requeue threshold is
>      implemented as timeout and can be modified with requeue_timeout_ms entry in
>      sysfs.

(+Daejun)

Daejun, can the HPB code be reworked such that it does not use 
blk_insert_cloned_request()? I'm concerned that if the HPB code is not 
reworked that it will be removed from the upstream kernel.

Thanks,

Bart.
