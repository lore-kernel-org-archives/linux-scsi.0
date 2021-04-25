Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323CBC433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 20:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECA9E611B0
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 20:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhDYUnn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 16:43:43 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:42941 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhDYUnm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 16:43:42 -0400
Received: by mail-pf1-f171.google.com with SMTP id q2so5641719pfk.9;
        Sun, 25 Apr 2021 13:43:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sQEBtvQIiwMUyXs4QG1unv0E1sFViEnCAqrsWxCtU+g=;
        b=ZFvHU1p05WVt1zPNi+wcv89UjgBJ5ZknFlRF1wZS2ucVs4Ika80JUq+/Ip0qq8IXq1
         qpPmfe4XkS0HcMXvB4qzEuMOmNdM+AI/QyBJ8OFBuPHFrU8wcHR0dtjNFfnI9CnqKPkQ
         vfcsi0awQqBI7e6yxfaL91mibZkQKofAjDeepoonGw2A1dDCUjX90W9hrGOOHaDttlO4
         v7YmkLyhP8ZQAgtDKFsQ59oUAk/5mmmJTNWCDbzoqgsrRyMj115Qljx4QH5LjGX9VDZj
         r6H0Nph3PwcbyP1V+pC5hSP2Afk37vDTm7uhBHd+dyWyjolhjcnQ7gfsAOGs8wkWHZR1
         4NgA==
X-Gm-Message-State: AOAM530FOSE5yymZASQa7G2ZEhdkPpcEyeUkSu9Img32KloMBoZveZAA
        AT8X3rftclEShV0m4beS+ic=
X-Google-Smtp-Source: ABdhPJyGCX1V73odUcSv4Vn0yEldUPFkSigSfvsOAnWlvGKx/7xu0JVHelSbPHU4PfV2e+fCapwsCA==
X-Received: by 2002:a63:2445:: with SMTP id k66mr13791516pgk.62.1619383381997;
        Sun, 25 Apr 2021 13:43:01 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id a185sm9417917pfd.70.2021.04.25.13.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 13:43:01 -0700 (PDT)
Subject: Re: [PATCH 8/8] blk-mq: clear stale request in tags->rq[] before
 freeing one request pool
To:     Ming Lei <ming.lei@redhat.com>, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
 <20210425085753.2617424-9-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d3493eef-ff45-23a8-f12a-b7246ba9f3a2@acm.org>
Date:   Sun, 25 Apr 2021 13:42:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210425085753.2617424-9-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/25/21 1:57 AM, Ming Lei wrote:
> +	spin_lock_irqsave(&drv_tags->lock, flags);
> +	list_for_each_entry(page, &tags->page_list, lru) {
> +		unsigned long start = (unsigned long)page_address(page);
> +		unsigned long end = start + order_to_size(page->private);
> +		int i;
> +
> +		for (i = 0; i < set->queue_depth; i++) {
> +			struct request *rq = drv_tags->rqs[i];
> +			unsigned long rq_addr = (unsigned long)rq;
> +
> +			if (rq_addr >= start && rq_addr < end) {
> +				WARN_ON_ONCE(refcount_read(&rq->ref) != 0);
> +				cmpxchg(&drv_tags->rqs[i], rq, NULL);
> +			}
> +		}
> +	}
> +	spin_unlock_irqrestore(&drv_tags->lock, flags);

Using cmpxchg() on set->tags[] is only safe if all other set->tags[]
accesses are changed into WRITE_ONCE() or READ_ONCE().

Bart.
