Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F03C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 05:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 997F961BF9
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 05:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhKPFUa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 00:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbhKPFU1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 00:20:27 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD11C0C0A4E
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 18:22:20 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id k22so23895448iol.13
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 18:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Vs3PC70yoeUckFQwekr+ktJSb4n+5JzWNeJHQDowUlk=;
        b=B7omzLkCe/MqVzdJeDQCs/OPAuyof2ktzYxwMAXAirwMPbvSbBAWCrdlICZinJE6KB
         Z/gWnt/b8ktUqDgKKwUJ+zkZtjUSMCYb1SIN/qvOsURC5FgJPgAsyqKTTkxr8deCaWY5
         PpaEJvlhkj0UPjnB/VQpAzjC0qOMNFD9oxyx5CgvQGTzLVg6wgN5GqzIzS1Cvy8w3BQz
         UFiJCKhiQ7UN5FJQ0MzjytBVr8JVt6VKANYxcawN2X7Pr+0NLMsfZmuk3OQ2tlffW13g
         hzBaiUOtWhcP/g24fq1wogOgVauPX0ht5Wxzv/wEDz98t7NPoKv8X84wT3UuK72l8Pgu
         vZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Vs3PC70yoeUckFQwekr+ktJSb4n+5JzWNeJHQDowUlk=;
        b=pBmewY1jftyBPo64O8no8wv/qGqyf4bD2Fx9Ksd+2DjXXX88FYyvmrztp7mH6gL5W1
         Ly+mnFky8yXBsrAtqELcMcW7caDarV/UWgmDVcOocBYEJ6Ig4RLLi1p1udaELPRvv67N
         O9WTIKh6+TDkck1b8WtU7Yqx+0wNSxEuBcwXgUNnROw2npzzuhCmAcaO4L5L0BHqu2Wf
         AWvoVIKtc0L1dYKXzWuQzsf9abLYqP417uloG+yfnYGxis1V4V7jN8EmY1xKb4JZdqGW
         nLiZqw3Ljgd4hRnnJNmYLLorIVdTpVQCvCcz9LX5YbHqmomY1upte8ybC22+xRRwzcaH
         VSNQ==
X-Gm-Message-State: AOAM530ptfI7B1XLSj1VIqRC0Pm3wRWrgzdMrsaxTVfGVJtofFaKKms9
        JCMF8hx4CWncLHYixFgobAUBEw==
X-Google-Smtp-Source: ABdhPJySUS1uW0kofaeOA4yJa5fQoOEMZVHKrq2wNrG93jKt8tohS8Da0f51vojTh4mh9PlzLg5BUQ==
X-Received: by 2002:a05:6638:22c2:: with SMTP id j2mr2624614jat.105.1637029339865;
        Mon, 15 Nov 2021 18:22:19 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id l9sm11571989ilh.21.2021.11.15.18.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 18:22:19 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        ChanghuiZhong <czhong@redhat.com>
In-Reply-To: <20211116014343.610501-1-ming.lei@redhat.com>
References: <20211116014343.610501-1-ming.lei@redhat.com>
Subject: Re: [PATCH V2] blk-mq: cancel blk-mq dispatch work in both blk_cleanup_queue and disk_release()
Message-Id: <163702933960.92052.4155589861281419870.b4-ty@kernel.dk>
Date:   Mon, 15 Nov 2021 19:22:19 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 16 Nov 2021 09:43:43 +0800, Ming Lei wrote:
> For avoiding to slow down queue destroy, we don't call
> blk_mq_quiesce_queue() in blk_cleanup_queue(), instead of delaying to
> cancel dispatch work in blk_release_queue().
> 
> However, this way has caused kernel oops[1], reported by Changhui. The log
> shows that scsi_device can be freed before running blk_release_queue(),
> which is expected too since scsi_device is released after the scsi disk
> is closed and the scsi_device is removed.
> 
> [...]

Applied, thanks!

[1/1] blk-mq: cancel blk-mq dispatch work in both blk_cleanup_queue and disk_release()
      commit: 2a19b28f7929866e1cec92a3619f4de9f2d20005

Best regards,
-- 
Jens Axboe


