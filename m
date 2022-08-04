Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7742C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 17:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiHDRsH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 13:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbiHDRsG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 13:48:06 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ED7101EF
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 10:48:05 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id b4so433176pji.4
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2022 10:48:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=kqAORXGunvmS31gnR/9sC9cMXYy9VCvYKPLWoMTujl0=;
        b=W9sLzr5KHGhZNVZB7qgOdQHq7nhBbiB2g8R/eAN+4tM8S1+ozd/jBqqtnAjsOTakdI
         XpG66U5RcuQgR2fmpbujeJV/xvIbifznp2rxkQCrKosWCm13KWHyG+gx6rgIHkU+MkLo
         NhiOHCaFrM7hM5v6O217JepOWB5Q1hG3QYz8AmpDHnpiAeWsVvi9sztHiz/6agA0Qum+
         ChRmK9irXIgHOr28U6RJVV1y/X6VJAYbwtqCB3Rin4QfqkkPTIF7aW6hvBduAJck+H/y
         5ETED0jiVtZEfXejDy+T6bXiM3Un8iS/zjgmCrn+jErx6I+fwjcE2Hmn67cjnv9wvB1J
         WLCg==
X-Gm-Message-State: ACgBeo34qAj3teqr1vP/z6bAhbT/ylzQwM/QwHffX94nH7EfijbnZMAT
        FSvS0XiVtS5wl/4n0h1EawjoqD6gIcU=
X-Google-Smtp-Source: AA6agR4MaCFg4bX4vxYAGJNVsVPISkPWtx3yic91/zuogGAvbbqz1FJU99SCqho2kiisyFnXGWceWQ==
X-Received: by 2002:a17:902:d2d1:b0:16e:eeac:29ab with SMTP id n17-20020a170902d2d100b0016eeeac29abmr2977589plc.125.1659635284955;
        Thu, 04 Aug 2022 10:48:04 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:30d8:61b8:d62:debd? ([2620:15c:211:201:30d8:61b8:d62:debd])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090a728600b001f31468f2f4sm3967847pjg.46.2022.08.04.10.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 10:48:03 -0700 (PDT)
Message-ID: <7a6499c6-4e98-072e-ce09-ddda7179b93e@acm.org>
Date:   Thu, 4 Aug 2022 10:48:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3] scsi: ufs: Increase the maximum data buffer size
Content-Language: en-US
To:     "yohan.joung@sk.com" <yohan.joung@sk.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
References: <20220726225232.1362251-1-bvanassche@acm.org>
 <55fce3baaabf4e33aeaccbe5b4e1f145@sk.com>
 <6263c2a5-e7b6-c9e5-69e8-b6d93604d82d@acm.org>
 <d8945bdf320240b2bdf6ee411eff6c8a@sk.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d8945bdf320240b2bdf6ee411eff6c8a@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/3/22 18:50, yohan.joung@sk.com wrote:
> In block layer, max_segment_size is obtained from get_max_segment_size.
> seg_boundary_mask is set to PAGE_SIZE - 1 in the ufs driver.
> The segment size is the PAGE size, and the max buffer size is
> segment size * max segment count ( PAGE SIZE * 128 ) = 512 KiB  in block layer
> Right?

Thanks for having reported this. I had overlooked that the UFS host 
controller driver sets the dma_boundary member of the host_template 
field. Is my understanding correct that UFS host controllers should 
support DMA segments that consist of multiple physical pages?

Thanks,

Bart.
