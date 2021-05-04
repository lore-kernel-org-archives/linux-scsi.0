Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B641FC433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 03:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B86061153
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 03:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhEDDVN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 23:21:13 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:43588 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhEDDVN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2021 23:21:13 -0400
Received: by mail-pf1-f175.google.com with SMTP id e15so6016185pfv.10
        for <linux-scsi@vger.kernel.org>; Mon, 03 May 2021 20:20:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XwXlpLwqcJWNchMkHU81znBRycJ/JzxNo5GgTprEj/8=;
        b=Z+Y7mc1Bmm9qOA/xayds3GovxNL1K4yUAD+kf0haktssfa7cJ8b909JAaHQVXzkKgh
         2XkiwqUiBgXWpVVYZix9LqjJOrDtFjb4onps1S3An98RnyKa2B0QmHtMyytp+mK8y9Qh
         FYqYsK6NmgGxzxJFck63w8/2511EE3k4Hd1fyCE2x9wgjFngYncuuoGZ10uyLjLDbHay
         3AG6h4c0oJpWN5COd4rg614YG6y1qvJ7r6rzhM9pn5+rUsjqPLkdUk0yRtEoVDA3xzCU
         f/pFIkDL32v0PBsJQZuKMnUSWGGFWUucdB5gwBlTOISOFHJCv2FKk+O986Nmu86I7jtM
         Z0fA==
X-Gm-Message-State: AOAM530OxN1AhXTx8bNxlkPkWRacYlhouQl0wqUvXoPvtVQ+OoGr7/Xn
        m+GUoPe68+5G8wGznvviOFC1yypXe0s=
X-Google-Smtp-Source: ABdhPJxc2blpXU3Vjkg/Qp0WO/3WXGvLgiZW6vPBJJM6ZsZUJKJQK+zehRlVzLl4EH8dj8PSFkmq+g==
X-Received: by 2002:a05:6a00:bc7:b029:28e:aa38:6332 with SMTP id x7-20020a056a000bc7b029028eaa386332mr6340311pfu.34.1620098417569;
        Mon, 03 May 2021 20:20:17 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6b81:314d:2541:7829? ([2601:647:4000:d7:6b81:314d:2541:7829])
        by smtp.gmail.com with ESMTPSA id l3sm1244333pju.44.2021.05.03.20.20.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 20:20:16 -0700 (PDT)
Subject: Re: [PATCH 10/18] scsi: implement reserved command handling
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-11-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <3e41e5ea-6313-9718-c07d-20f8b203efd2@acm.org>
Date:   Mon, 3 May 2021 20:20:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210503150333.130310-11-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/21 8:03 AM, Hannes Reinecke wrote:
> These commands are set aside before allocating the block-mq tag bitmap,
> so they'll never show up as busy in the tag map.

That doesn't sound correct to me. Should the above perhaps be changed
into "blk_mq_start_request() is never called for internal commands so
they'll never show up as busy in the tag map"?

Thanks,

Bart.
