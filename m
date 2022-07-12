Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65BDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 00:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiGLAjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 20:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGLAjY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 20:39:24 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6C22DA89
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 17:39:24 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id l124so6132563pfl.8
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 17:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fX0hOsxWnznUYY4t6cj16k6SrRIYUryBCGfQ6bCkpPU=;
        b=QmkMFknYV3U78Wsb2sdskrgWflEVhyrvz3xW8RVcgJlvwfTv2xB4IYVswySew7FDCY
         0RlqAe0WbwHDFWTmHE2Jg5vpbRyJ3zfHXr+WdxZ9vSt+jPHeUMnnaynbvzZiFUDG/zxM
         GD4aYiwqtWD93whyIlur2Rw2zBsQITVVc2oXExpeiEtDT+nt+7lDblggfusvfuU93yWE
         glO6qggjhRuODM8iZ9Ns/BTYGPOTqEJGhsrvJrOKoadzZzuaP3tUaGMufA/A99IHs8T2
         9xaiFqBoK8XOGYyit4uKffbRZWvqU7PcRCFk5sc+86u0BMTd+j7sm1/FAF9MRP2DmBGG
         X2Vw==
X-Gm-Message-State: AJIora8ceQ84k93auDG0AyxMTNeSE7fyORU6JYP7ScSNDDcVS3VVutUp
        o4fNyR5pBt0tUhz80YHF1ko=
X-Google-Smtp-Source: AGRyM1t1cu//js/5IKyn5pbO1UVGhFoTcdMZcK0/3LVO0zoglShM6IA+ebQn1/AFFGk20Wvz63v94Q==
X-Received: by 2002:a05:6a00:4407:b0:52a:e996:780c with SMTP id br7-20020a056a00440700b0052ae996780cmr155334pfb.40.1657586363434;
        Mon, 11 Jul 2022 17:39:23 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id h16-20020a056a00001000b0051bada81bc7sm3262446pfk.161.2022.07.11.17.39.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 17:39:22 -0700 (PDT)
Message-ID: <dc7d4d18-cd3c-46a6-2905-3bdbced11b53@acm.org>
Date:   Mon, 11 Jul 2022 17:39:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/3] scsi: sd_zbc: Fix handling of RC BASIS
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-4-bvanassche@acm.org>
 <90cb95f0-7d8b-af10-9480-76a2163993e2@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <90cb95f0-7d8b-af10-9480-76a2163993e2@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/11/22 16:11, Damien Le Moal wrote:
> Do you have these cases:
> 1) host-managed disks:
> SWR zones are *mandatory* so there is at least one. Thus read capacity
> will return either 0 if there are no conventional zones (they are
> optional) or the total capacity of the set of contiguous conventional
> zones starting at lba 0. In either case, read capacity does not give you
> the actual total capacity and you have to look at the report zones reply
> max lba field.

Does the scsi_debug driver allow to create a host-managed disk with one 
or more conventional zones and one or more sequential write required zones?

> Note that anyway, there are no drives out there that use RC BASIS = 0. I
> had to hack a drive FW to implement it to test this code...

A JEDEC member is telling me that I should use RC BASIS = 0 for 
host-managed zoned storage devices that only have sequential write 
required zones. That sounds weird to me so I decided to take a look at 
how the sd_zbc.c code handles RC BASIS.

Bart.

