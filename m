Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB7DEC05027
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Feb 2023 00:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjBGAcL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Feb 2023 19:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjBGAcK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2023 19:32:10 -0500
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B14732E58;
        Mon,  6 Feb 2023 16:32:03 -0800 (PST)
Received: by mail-pf1-f169.google.com with SMTP id ay1so9638749pfb.7;
        Mon, 06 Feb 2023 16:32:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Ve5UGPlA42gaDvnWdHcOX6P3773YF6OLS/9lwpd1Ho=;
        b=SMBikfoGzd5NAWObE4HzM1IAD372kqiJ48/UdPWuBJ5tDRm6cyA4rAECaROVu45CCH
         nGJsFEH4/+ncM0qWRxOe+2IjsPPsXYWSs3BpYKc3bPWKXCOHNn4b+ALxytqvx02YUUab
         tCNmJTC+0yiHkh31gJv0Ds+N0qsag/K2k9G50oEAvIPj4vrsxrBGeiWlSfyGEClGp748
         e+xlx5a3IMMmH5+KLfSoMie/VAp0889UhnF37Rmx+HHDxURGRbCFdF8zRW61/GyGfoDK
         ejiTeP48W6675vse4QqttbpuX9IAe0IoWr21rqf+iCIAjB1h/FF71OOBbQ76bX59QCG0
         5hjQ==
X-Gm-Message-State: AO0yUKUipkVINTB1K2axEoe3E7jat9TjEx2BB6R2pDCnl+2gMFiBPBh7
        buapJTgpPeBA48bEWncCrMQ=
X-Google-Smtp-Source: AK7set/apv+u+wf2FLE7tCaXQadsAoti8UadndlbqXKczEY/HYunFBMTekTyAG7wlI4nV8BDIiYzbw==
X-Received: by 2002:a62:31c1:0:b0:593:96a2:d60a with SMTP id x184-20020a6231c1000000b0059396a2d60amr923633pfx.30.1675729922615;
        Mon, 06 Feb 2023 16:32:02 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:546b:df58:66df:fe23? ([2620:15c:211:201:546b:df58:66df:fe23])
        by smtp.gmail.com with ESMTPSA id m8-20020a62f208000000b005891c98e1aasm7693870pfh.119.2023.02.06.16.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 16:32:01 -0800 (PST)
Message-ID: <bee64ad1-a465-123e-4208-013e7dd69e04@acm.org>
Date:   Mon, 6 Feb 2023 16:31:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v4 2/7] block: Support configuring limits below the page
 size
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Pankaj Raghav <p.raghav@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
 <20230130212656.876311-3-bvanassche@acm.org>
 <20230201235038.nnayavxpadq5yj34@garbanzo>
 <24b34999-8f7c-7821-0b15-fdfc3f508b13@acm.org>
 <Y+GZFoHiUOQeq25d@bombadil.infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y+GZFoHiUOQeq25d@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/6/23 16:19, Luis Chamberlain wrote:
> But I'm trying to do a careful review here.

That's appreciated :-)

> The commit log did not describe what *does* happen in these situations today,
> and you seem to now be suggesting in the worst case corruption can happen.
> That changes the patch context quite a bit!
> 
> My question above still stands though, how many block drivers have a max
> hw sector smaller than the equivalent PAGE_SIZE. If you make your
> change, even if it fixes some new use case where corruption is seen, can
> it regress some old use cases for some old controllers?

The blk_queue_max_hw_sectors() change has been requested by a 
contributor to the MMC driver (I'm not familiar with the MMC driver).

I'm not aware of any storage controllers for which the maximum segment 
size is below 4 KiB.

For some storage controllers, e.g. the UFS Exynos controller, the 
maximum supported segment size is 4 KiB. This patch series makes such 
storage controllers compatible with larger page sizes, e.g. 16 KiB.

Does this answer your question?

Thanks,

Bart.

