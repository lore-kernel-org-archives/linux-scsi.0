Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CE5C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 22:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41FDE610FC
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 22:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237444AbhI0Wak (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 18:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237678AbhI0Waj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 18:30:39 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B67C061604
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 15:29:00 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id k13so5762258ilo.7
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 15:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w9ezsQ1UkQZeC53NkFhy7B+1aNQW9TNDf1kl1c4M4R4=;
        b=Ffjc9XDV39XVuLIm8DJDvOIHuyWwHa/JDveqkJIq4EPQcwwF6i2IwXvqTayH1Zs+J0
         zBBIHTdeujFBpyTsi7j+hLC6dG1lmzreXcsCJibD0ZHuJdAABtpVv3xmIelWiJg4Kiwx
         y74YiDFOoIziOuEp0bFDeka+WbUijbofv2enBSkOGJFIlEwWIxbA3L0TdOIDNHbvW4s3
         UX5WZ/WNqYbm3RB9OdDLcEyEdxxaBYh8+Ce09lqPv5Y/yeoNEYf2H8gl9ZQ2Gx73QUuz
         bK1mNwQj3yvOA8l/cfkBNHF9G4YJ0ALLNw+vW7N07eAC0HlFOVJ1jxEY1tUin9ivF4Jg
         GOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w9ezsQ1UkQZeC53NkFhy7B+1aNQW9TNDf1kl1c4M4R4=;
        b=eTY/gOETBUvumOH3OQ1zY+4RPETfoQDFn9DVwAcUpPuLhFcEc5ZytG5jl0SVqFEAq9
         sOJexnekj0v2h9Olm32NpN3y7th//GvRkzba6KWFVq8CR1eKZQ8ag+SVcKDocSmkPgEm
         PtsOR0YnkzRO6GnWJnyTdzW6QEJTOF4xj66gcNjjaV8MK3dhQfRJfeAItQ7P8J3tM1YR
         SXctV0zytsOZaI+qiVezwY3V2k6+pD1ztI/eguv6OenYYJNHpajNnWtxPB6yNsDD2VRZ
         xLcPzOv6T05uoPlyyxMtXwNE1b6P5EbFHuUvBAi7mxcQFR+2LdUMJIouJWRuB3ByQuff
         vv2Q==
X-Gm-Message-State: AOAM5308S5ps2I1eehu0qnCxfNW45krJ1172VzXrEqYP0I4KTCj1wRhl
        QTmcqgiDE4ZfMKDxwOcnqsM+LQ==
X-Google-Smtp-Source: ABdhPJz2QpC01URNtiA6TI68tVS50xc5AHbinQF2wOnvWrWvzOWk+mcoidVwrUAWxR5vBmrTJemKng==
X-Received: by 2002:a05:6e02:661:: with SMTP id l1mr1855976ilt.122.1632781740297;
        Mon, 27 Sep 2021 15:29:00 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id z25sm7614559iow.20.2021.09.27.15.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 15:28:59 -0700 (PDT)
Subject: Re: [PATCH v4 6/6] nbd: add error handling support for add_disk()
To:     Luis Chamberlain <mcgrof@kernel.org>, martin.petersen@oracle.com,
        jejb@linux.ibm.com, kbusch@kernel.org, sagi@grimberg.me,
        adrian.hunter@intel.com, beanhuo@micron.com,
        ulf.hansson@linaro.org, avri.altman@wdc.com, swboyd@chromium.org,
        agk@redhat.com, snitzer@redhat.com, josef@toxicpanda.com
Cc:     hch@infradead.org, hare@suse.de, bvanassche@acm.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-mmc@vger.kernel.org,
        dm-devel@redhat.com, nbd@other.debian.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
References: <20210927215958.1062466-1-mcgrof@kernel.org>
 <20210927215958.1062466-7-mcgrof@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dc945e14-498b-2cc1-8ef3-8dcaacfb948c@kernel.dk>
Date:   Mon, 27 Sep 2021 16:28:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210927215958.1062466-7-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/21 3:59 PM, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.

Applied, thanks.

-- 
Jens Axboe

