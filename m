Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C43C4320E
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 18:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AF0560E93
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 18:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhHWS4G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 14:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhHWS4F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 14:56:05 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5E2C06175F
        for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2021 11:55:22 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id a15so23130567iot.2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2021 11:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gN5m1+Ot8kbL1AcHDrnd1zQzLsJOMjFrZEkFY9Kqijo=;
        b=ZvhpNLl+p2ohVL+AzWOpNfcZKAnyUOq9Xa1DD92KeHi4kQ1/R2QbzpF+/LVv8cBRGY
         WrA+Ha2+0lcNf28Eg4viu/QmQu8s6aJgWNIGK5kpcJAD0OZ4gQeRL0WkhRVvNYnRIEH4
         MVVUJPvekbmJhxTxBeLF/7VQFjrF+szaSASBaaV2Xv2mAaY31oZPxF8HuwY/CX39zKS4
         oMfbV9hb2HqxQsgPh2vzUEDQ++Q+6cjXyxLGSF2DIt4ZJfzgMkDw7AzHQk8JYk6QPteT
         5zFs3TBUK4JypTPi5cuPJpOlhHHgHDsVxZ8pAjZrBF4tRV9T9uRw71mktnJHmBluTENp
         wVeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gN5m1+Ot8kbL1AcHDrnd1zQzLsJOMjFrZEkFY9Kqijo=;
        b=GlYWj4p4xQ/VJVKWP3ZODb1ybgiCUQeKX29w1ya9uepdclzGTxVCMDBf8lIof/RBUk
         JdtlfgKgWoM94HGTi/rK8yXOaYNCd8xWcpZvVIMQ7buJzd9Zvq0JbU9OE64G0aRFn9Eq
         f1rA0K9FmjPcHQxSGrY3DT7p1bRlLFx3REaY/J8ucnudHaYmmhP4coZ9hg91mVmMMC1H
         dHfvWAJtFtnK3liQDwuPpP2ENuDZ83g9xB0O/2KSi9H2wAJoJAOOiXgtLYtwhps+5NkT
         zcJ72gZsLzdUP2s2Cw5uXGzEzswD8ZV41+M06trekbkG+8+6ZIAj4vjowC6rlM97Aakr
         Sqww==
X-Gm-Message-State: AOAM5316jv6zzgX/0BbZDblkuRGbWr607RZtuU9RqcsF55kPJ0sC+gt2
        EYygFG+YAxUO/rLpCkNq+e5xe7ppxx3rSQ==
X-Google-Smtp-Source: ABdhPJyHd1Xb+eQ9l6FLpdfbrM5gL1Wy8EM6ml3EzMk3dBxZ9Vtw4oKBhVroRXIzRwhscAsUcE7S3A==
X-Received: by 2002:a02:c502:: with SMTP id s2mr31103930jam.135.1629744920613;
        Mon, 23 Aug 2021 11:55:20 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id p16sm8753371ilg.32.2021.08.23.11.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 11:55:20 -0700 (PDT)
Subject: Re: ensure each gendisk always has a request_queue reference v2
To:     Christoph Hellwig <hch@lst.de>
Cc:     Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210816131910.615153-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cd739220-c7c0-fcca-6399-8afaa86b56e4@kernel.dk>
Date:   Mon, 23 Aug 2021 12:55:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210816131910.615153-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/16/21 7:19 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this is the final batch of the gendisk interface cleanup series.  This
> remove the last uses of the legacy alloc_disk interface and ensures we
> always have a request_queue reference for a gendisk.

Applied, thanks.

-- 
Jens Axboe

