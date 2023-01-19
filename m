Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30149C38142
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 04:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjASEtg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 23:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjASEsb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 23:48:31 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1125E78578;
        Wed, 18 Jan 2023 20:43:39 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id a14-20020a17090a70ce00b00229a2f73c56so4679343pjm.3;
        Wed, 18 Jan 2023 20:43:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0d4sY4KYUa7j537BEEIS3yVmB57Y9RzPLByhF0pYcg0=;
        b=p1u9uQAtSu11kyaQ7NN86iY92w1WAoNEPWqTeMMo0ZT9OMydhNSP1zawCZdQe31/m/
         CwZIQ+5Tya4Txs8IR3Wjn0pU/CQvwziC/EYZbVCmFZMq5uSSNg2UBtgweeZ+IsqOhqcc
         YaEpaEBzcsFaMr+AmDwYD8ebv3bMywThknoTSr0xzhVZLvRe5JkVpTiZNwqLpfv3geHl
         fFuV1GJsJt8halKm6aY8oo7IiXPrkM6bf5jVP6F8dgq/pLGML2MmQ52oXk7aFFwfoafa
         uOeWxOu6XQYz6Uc01aTrNCtqTIFQxpEcpFD8iofqWknT+JXwQgoavudgMQf+jG//qHxI
         8sag==
X-Gm-Message-State: AFqh2kqZEbr8ANLb8gwcXU+LVdXAqNIQR4kXKpye4hPbZELUQTpHyCje
        hzssSYhY07hAPdMff1LT/6g=
X-Google-Smtp-Source: AMrXdXsA+sH1dun7aToK6KPMwZLBrSu2P+Ad0hT+aymj16K/rYS4kTMxv9n52wqM9jKUZGY5rYEtKw==
X-Received: by 2002:a17:902:ebc9:b0:194:85da:16 with SMTP id p9-20020a170902ebc900b0019485da0016mr10777949plg.13.1674103393875;
        Wed, 18 Jan 2023 20:43:13 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id j15-20020a170903028f00b00190c6518e30sm24032502plr.243.2023.01.18.20.43.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 20:43:13 -0800 (PST)
Message-ID: <0e120274-29d8-cb53-2190-d82eabf4c431@acm.org>
Date:   Wed, 18 Jan 2023 20:43:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 0/9] Add support for segments smaller than one page
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230118225447.2809787-1-bvanassche@acm.org>
 <52073ee8-72ab-f424-1738-c56bc8d5cd67@kernel.dk>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <52073ee8-72ab-f424-1738-c56bc8d5cd67@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/18/23 17:18, Jens Axboe wrote:
> On 1/18/23 3:54?PM, Bart Van Assche wrote:
>> Hi Jens,
>>
>> Several embedded storage controllers need support for DMA segments that are
>> smaller than the size of one virtual memory page. Hence this patch series.
>> Please consider this patch series for the next merge window.
> 
> Before any real reviews are done, I have to ask "why?". This is pretty
> hairy code in the middle of the fast path for some obscure controller.
> Why would anyone ship that with > 4k page sizes rather than ship it with
> a controller that is sane?

Hi Jens,

The new config variable CONFIG_BLK_SUB_PAGE_SEGMENTS has been introduced 
to make sure that the hot path is *not* affected if that config variable 
is disabled.

Regarding the question "why": the Google Android team would like to 
improve performance by switching from 4 KiB pages to 16 KiB pages. One 
of the widely used UFS controllers (Exynos) has a maximum segment size 
of 4 KiB. Hence this patch series.

This patch series is not only useful for phones but also for Tesla cars 
since Tesla cars use an Exynos UFS controller.

A contributor to the MMC driver told me that this patch series would 
allow to simplify the MMC driver significantly (I have not yet double 
checked this).

Bart.


