Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C830C07E94
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 16:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5280C613F4
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 16:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhFDQPJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 12:15:09 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:35476 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhFDQPJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 12:15:09 -0400
Received: by mail-pj1-f50.google.com with SMTP id fy24-20020a17090b0218b029016c5a59021fso1184061pjb.0;
        Fri, 04 Jun 2021 09:13:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gmm8KlnIo/nuK5ud9oSk0ktzCTOuNeA4tmOo0gRaut8=;
        b=mYocplnxAY6qMT6hyyPnGbI98DszmDXfL4MHG+HRgkaLE0OXUyu7SS5/wqeW7SF5yt
         6ZhuFax6RdyOITzuWrKAVyJpKaXVIi9UA3fNnk091r6hQfbFmNIIGsXYYO8SD5WvYHcI
         9yD3pFoZheJlRBH7fFdeSe9BEIJVhPk3mT+6ssmWt40s2fQ9vNTYOkEMZyioNvNaRMBA
         ZDVu+CGU3yn27w474c8yI8++7eAqZFGU8poAJJ729iPu+CE3wOAewEVx04yMhaw0Stli
         Py3jaI0VrVYc4dgdjaqB+5N4Co76nWCD5ZRDsMd5J1+cQhUqwn99yUJvY//DFPqRj3PA
         eZ8g==
X-Gm-Message-State: AOAM533DtWirHB4kPlCAbizd67m6805Ou3c7m1IbjLsrAcjbwURpLQFB
        5+3yJxR/V5glFh02HOnyqRI=
X-Google-Smtp-Source: ABdhPJz0VSZ0d2HnuXgK560zrDLOhqWYxGflmdVC+KLAhx45ksnzqoY/KuwnAaBbTgE0CRmghEiYHA==
X-Received: by 2002:a17:90a:520f:: with SMTP id v15mr5558604pjh.23.1622823186456;
        Fri, 04 Jun 2021 09:13:06 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 190sm2439582pgd.1.2021.06.04.09.13.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 09:13:05 -0700 (PDT)
Subject: Re: [PATCH v12 0/3] bio: control bio max size
To:     Changheun Lee <nanich.lee@samsung.com>, Johannes.Thumshirn@wdc.com,
        alex_y_xu@yahoo.ca, asml.silence@gmail.com, axboe@kernel.dk,
        bgoncalv@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, cang@codeaurora.org,
        avri.altman@wdc.com, alim.akhtar@samsung.com,
        damien.lemoal@wdc.com, gregkh@linuxfoundation.org,
        hch@infradead.org, jaegeuk@kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ming.lei@redhat.com, osandov@fb.com, patchwork-bot@kernel.org,
        tj@kernel.org, tom.leiming@gmail.com, yi.zhang@redhat.com
Cc:     jisoo2146.oh@samsung.com, junho89.kim@samsung.com,
        mj0123.lee@samsung.com, seunghwan.hyun@samsung.com,
        sookwan7.kim@samsung.com, woosung2.lee@samsung.com,
        yt0928.kim@samsung.com
References: <CGME20210604052157epcas1p2e5eebb52d08b06174696290e11fdd5a4@epcas1p2.samsung.com>
 <20210604050324.28670-1-nanich.lee@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9e1c43a8-1c6d-95c6-ce4c-34ac194b9022@acm.org>
Date:   Fri, 4 Jun 2021 09:13:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210604050324.28670-1-nanich.lee@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/21 10:03 PM, Changheun Lee wrote:
> bio size can grow up to 4GB after muli-page bvec has been enabled.
> But sometimes large size of bio would lead to inefficient behaviors.
> Control of bio max size will be helpful to improve inefficiency.
> 
> blk_queue_max_bio_bytes() is added to enable be set the max_bio_bytes in
> each driver layer. And max_bio_bytes sysfs is added to show current
> max_bio_bytes for each request queue.
> bio size can be controlled via max_bio_bytes.

Where is the version history for this patch series?

Has this patch series been tested in combination with dm-crypt?

Bart.
