Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 857E9C43460
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 20:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6299C6128A
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 20:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhDYUT1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 16:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhDYUT0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 16:19:26 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC5CC061760
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 13:18:44 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 10so2154226pfl.1
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 13:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ctZ2CQtJPnMYclVf07dU+sHVR4/FEattLgQ8J9FusIY=;
        b=FcsUGlNC6jMoTfhFRoKwZCHIbL19ZNpqM02JFdnKa4S5UZ/t1sJo7DS7lIzLwo4pUG
         TEWNvEGHaSKVjPvNRUr1gtAbeDCjlNvLIxui3EkhvrS7bth1CnNAvc7rx6mwgGdC3JNZ
         btiMvTjfUPBlcd7/2RuabQrNETMEVslobeKXVpEDE3DiLxjDv+nZlGa/iQWcex4+B79r
         zoJl0GL3lkFbpeF6R0YrgMMMUGcDP1sLRC+Rm4b6bD/VDKDW0azaCm91mEwzzDzVRmZz
         fi8HrHjY8r9lPZMlmGWd5LmiPXUl+SR9WnWFWQ6G1r/9zKqNqdC5VhQDHSUDFs07n16B
         uJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ctZ2CQtJPnMYclVf07dU+sHVR4/FEattLgQ8J9FusIY=;
        b=jh8DAsU6Yfv2Mfr2DTGt1Kdx8IZ1vbOgDZ8R0xI93V4AKYbIzxARUeAWz/fYGVOSBE
         OiM6XkhTEj6jMN0xeDNnEnoPv0ZK90TaKoQMj8s9rX5CSzrD4C3Jx8FDVUi+erQ0F439
         7/zjam1lRoSlZ7KBrhsnuT1PY64CXgpjZaD2jr7ucyrmcAPVVekjDeOlS4kafFsZYOYP
         ER84uqEjoh8oHRVdZxkW0cNtDy3OPfhtJ5478Os8hZsrscYVuebgmcA1eWoUw/RvbG1y
         qQipdZ82Z0YSUaedL9adjTHCQJTWausDV4SVyG5HvzoKnsFNJ7EOXHy37jGalQPvZSm8
         4SIw==
X-Gm-Message-State: AOAM530LkNh3Xpt5QGZaQRHEfed4gnlAgak1nSPRE585RVgnmTbybnuT
        3d23LsLqiO4TNW3Pd+NUNrCMcw==
X-Google-Smtp-Source: ABdhPJzeQ0v5+IQ8etbmEF/bVIM9K9+k8nJ25bYhaJ5TaAHfCSNuxoLpR0JF/CSBFWgB5skRmSxAvw==
X-Received: by 2002:a63:2d81:: with SMTP id t123mr7029607pgt.224.1619381923984;
        Sun, 25 Apr 2021 13:18:43 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id h18sm8635748pfv.158.2021.04.25.13.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 13:18:43 -0700 (PDT)
Subject: Re: [PATCH 0/8] blk-mq: fix request UAF related with iterating over
 tagset requests
To:     Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
 <77cbc472-279e-5c9a-3428-b1a485b3f1b7@kernel.dk>
 <f4d43e0d-cdd7-4a8c-9852-bbc99053fd81@acm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dc5a66fe-2678-994d-d7ff-6160c3626d83@kernel.dk>
Date:   Sun, 25 Apr 2021 14:18:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f4d43e0d-cdd7-4a8c-9852-bbc99053fd81@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/25/21 12:39 PM, Bart Van Assche wrote:
> On 4/25/21 9:17 AM, Jens Axboe wrote:
>> I'm going to pull the UAF series for now so we don't need to do a series
>> of reverts if we deem this a better approach. I'll take a further look
>> at it tomorrow.
> 
> Please give me the time to post review comments. My opinion about this
> series is that (a) the analysis on which some patches are based is wrong
> and also (b) that some patches introduce new bugs that are worse than
> the current state of the for-next branch and also make it worse than the
> v5.11 kernel.

Just to be clear, I did not apply this series, "pull the UAF series" just
meant un-applying your series so we have a sane baseline for something
that everybody likes. There's plenty of time to figure this out for
5.13.

-- 
Jens Axboe

