Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F9FC47097
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 06:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9AED61073
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 06:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhFDGnp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 02:43:45 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:64617 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229921AbhFDGnp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Jun 2021 02:43:45 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622788919; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=S17fN/ibPAMCQWFy+84ZG8Iso2Ij4GxnGWq2PMVnDm8=;
 b=MMlTmfLPY0UQ1gYVm99F9eK0Uj58m2od03tecb+mbVnwiPXyYypNsBEPlgip0kzfTk8+i2Xk
 w/2sO4emdoOz24wFuGRHIOl6Y+1gFrE5w5lQcP+gFyYO4yuQ5xgWkwtl6y55I3iltkxjcar5
 KRHPmxS3KSdIrbmrCKIcfFFYeWI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 60b9cb35e27c0cc77f48d6ff (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 04 Jun 2021 06:41:57
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E632BC43217; Fri,  4 Jun 2021 06:41:56 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B780CC433F1;
        Fri,  4 Jun 2021 06:41:54 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 04 Jun 2021 14:41:54 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Changheun Lee <nanich.lee@samsung.com>
Cc:     Johannes.Thumshirn@wdc.com, alex_y_xu@yahoo.ca,
        asml.silence@gmail.com, axboe@kernel.dk, bgoncalv@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, bvanassche@acm.org,
        damien.lemoal@wdc.com, gregkh@linuxfoundation.org,
        hch@infradead.org, jaegeuk@kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ming.lei@redhat.com, osandov@fb.com, patchwork-bot@kernel.org,
        tj@kernel.org, tom.leiming@gmail.com, yi.zhang@redhat.com,
        jisoo2146.oh@samsung.com, junho89.kim@samsung.com,
        mj0123.lee@samsung.com, seunghwan.hyun@samsung.com,
        sookwan7.kim@samsung.com, woosung2.lee@samsung.com,
        yt0928.kim@samsung.com
Subject: Re: [PATCH v12 0/3] bio: control bio max size
In-Reply-To: <20210604050324.28670-1-nanich.lee@samsung.com>
References: <CGME20210604052157epcas1p2e5eebb52d08b06174696290e11fdd5a4@epcas1p2.samsung.com>
 <20210604050324.28670-1-nanich.lee@samsung.com>
Message-ID: <0e7fbebf0877fd5d87c156c6020eeb09@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-04 13:03, Changheun Lee wrote:
> bio size can grow up to 4GB after muli-page bvec has been enabled.
> But sometimes large size of bio would lead to inefficient behaviors.
> Control of bio max size will be helpful to improve inefficiency.
> 
> blk_queue_max_bio_bytes() is added to enable be set the max_bio_bytes 
> in
> each driver layer. And max_bio_bytes sysfs is added to show current
> max_bio_bytes for each request queue.
> bio size can be controlled via max_bio_bytes.
> 

This is interesting, and we also noticed it right after multi-page bvec
is enabled since last year. Internally, we had a hack to disable it.
But it is good to have a tunable to control it. Thanks for the change.

Reviewed-by: Can Guo <cang@codeaurora.org>

> Changheun Lee (3):
>   bio: control bio max size
>   blk-sysfs: add max_bio_bytes
>   ufs: set max_bio_bytes with queue max sectors
> 
>  Documentation/ABI/testing/sysfs-block | 10 ++++++++++
>  Documentation/block/queue-sysfs.rst   |  7 +++++++
>  block/bio.c                           | 17 ++++++++++++++---
>  block/blk-settings.c                  | 19 +++++++++++++++++++
>  block/blk-sysfs.c                     |  7 +++++++
>  drivers/scsi/ufs/ufshcd.c             |  5 +++++
>  include/linux/bio.h                   |  4 +++-
>  include/linux/blkdev.h                |  3 +++
>  8 files changed, 68 insertions(+), 4 deletions(-)
