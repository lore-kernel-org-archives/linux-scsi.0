Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 942D8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 00:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E16061994
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 00:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbhKQAtL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 19:49:11 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:36398 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbhKQAtL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 19:49:11 -0500
Received: by mail-pf1-f180.google.com with SMTP id n26so1003438pff.3
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 16:46:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HWQ5nRiwNAoDCX+YFBk5dohRhzy9X+aR2BRl/3KnHfE=;
        b=ynomYwdhDfSKedLvmZz8K0JmyEN0QLVv5rdfYL/EWsE0pOTHtFpyj/JvB14kww2Vk9
         rwjkb+FJDo/+E1Vh+ig16ys3KQMso5WwT251+Q90v4HvkM4ZhGlS4YyjoirhkvNWYOVP
         2KgWxoAFC/ycxPksfPaY9yUQ+VjCwDnzKAzNkZKyYpLSKFIa1wZKjeEHeEpvUtwYn7Av
         H09E+cNgAt6VN+RDgogVeTNRcIpypmaldSLXn5tie422oq+3yXmMSSqL1v/bvLm7Lfwt
         9PPJCvy41+QVwDjfmrAGiyxxpnud8eO8B57JJncgtD8MGLmMU/Ifqd3OMZsfaRgJfe/2
         Etmw==
X-Gm-Message-State: AOAM530pG/jQZqMM7VV3bFQ6dFSfs8tXBVKCdzquhzVZOma/1xzv2mqc
        1/AwkJSvT1mht4fcX7WXjbwIM2zQwmI+kA==
X-Google-Smtp-Source: ABdhPJzr5s0+Mdb3FrbiPJHbHT9U9wkuSzwFrk9vKKrCjPatRrDT9YNFaItgSVKJjvl9lrCerbEUSg==
X-Received: by 2002:a05:6a00:1903:b0:47c:34c1:c6b6 with SMTP id y3-20020a056a00190300b0047c34c1c6b6mr43418387pfi.17.1637109973053;
        Tue, 16 Nov 2021 16:46:13 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id u9sm19830673pfi.23.2021.11.16.16.46.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 16:46:12 -0800 (PST)
Message-ID: <61280b78-5132-f1cc-321e-6d87dfcc292b@acm.org>
Date:   Tue, 16 Nov 2021 16:46:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 1/2] scsi: core: Add support for reserved tags
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-2-bvanassche@acm.org>
 <139e5cb6-c91e-fa64-f261-6359b6abe376@suse.de>
 <57aa04ba-edd5-93b9-4e0d-2fda4ccbe975@acm.org>
 <7f778b12-fe9b-f685-30f4-1c9f2ecdd571@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7f778b12-fe9b-f685-30f4-1c9f2ecdd571@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/21 22:54, Hannes Reinecke wrote:
> Ah. Even easier.
> I've made a prototype for this kind of operation in
> git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
> branch scsi-internal.v1
> 
> That introduces a function 'scsi_host_get_internal_tag()'
> to retrieve a tag from the reserved pool of the host tagset.
> Would that work for you?

Hi Hannes,

Thanks for the pointer, that patch looks very interesting. However, in 
the UFS driver we need both a request pointer and a tag. Since 
converting a unique tag into a request pointer is much more work than 
converting a request or SCSI command pointer into a tag, I prefer 
functions that return a request pointer or SCSI command pointer.

Thanks,

Bart.
