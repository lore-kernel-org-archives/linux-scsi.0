Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1A2C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 13:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjCFNys (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 08:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjCFNyr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 08:54:47 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BFB211CF
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 05:54:46 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so8879072pja.5
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 05:54:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678110886;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cLKkGBFA7/BKzKpuUKfVxcnQxs1/s8FI2LRTx5PhBeQ=;
        b=IWVBgD05mVSY3VD1bo2Vb59cHFeWDO4w4I0iXvqCr8xUdUxiwLo2SdLTaOx/lZtqwQ
         vTTohrwuXZxuzHycwBdY1+JdrPXq+iJ12eHiyulYW0n75c7I67ugNVgJICY3x1XoT3u3
         PEXzDwoN279ukgTLetazRlCzcuLt5mdOY269oIf4iY3cfuwyXGXKEeUj6geOT3fSkp2e
         KBT99eqXBisHt6u19M0qsvzuRwmnUivF3I63Scz4bIrxNRUD1rLS/6PH/a/8PkOFl7Gy
         xmxMRAclkF7XpG/EOwygCQMLpSE2f3N4JJMAgW+42CAqbG2mCcxDfa+yhCr+TcfpHuJ5
         qqHg==
X-Gm-Message-State: AO0yUKUSY2w6T1NYn67eDxSZ9nmwMHWVYt+k1XSB1qUXRTSSas07KTxx
        0aGx1C7c1evipADZOB+JFqunrEbhjeU=
X-Google-Smtp-Source: AK7set9eF5gCXkR4vjMqEr+hPk7mI4B3eAia7vxWtAte797VuzN6X8TjiqdefZm0JwfLAroLTQYIUg==
X-Received: by 2002:a17:90b:3b4f:b0:237:5dc6:ce14 with SMTP id ot15-20020a17090b3b4f00b002375dc6ce14mr11426438pjb.7.1678110885612;
        Mon, 06 Mar 2023 05:54:45 -0800 (PST)
Received: from [192.168.132.235] ([63.145.95.70])
        by smtp.gmail.com with ESMTPSA id v9-20020a17090ae98900b00233afe09177sm7806464pjy.8.2023.03.06.05.54.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 05:54:44 -0800 (PST)
Message-ID: <22c6c148-834c-a37c-a02b-cee7e7c861d3@acm.org>
Date:   Mon, 6 Mar 2023 05:54:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH REPOST] scsi: sd: Fix wrong zone_write_granularity value
 at revalidate
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20230306063024.3376959-1-shinichiro.kawasaki@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230306063024.3376959-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/5/23 22:30, Shin'ichiro Kawasaki wrote:
> When sd driver revalidates host-managed SMR disks, it calls
> disk_set_zoned() which changes the zone_write_granularity attribute
> value to the logical block size regardless of the device type. After
> that, the sd driver overwrites the value in sd_zbc_read_zone() with
> the physical block size, since ZBC/ZAC requires it for the host-managed
> disks. Between the calls to disk_set_zoned() and sd_zbc_read_zone(),
> there exists a window that the attribute shows the logical block size as
> the zone_write_granularity value, which is wrong for the host-managed
> disks. The duration of the window is from 20ms to 200ms, depending on
> report zone command execution time.
> 
> To avoid the wrong zone_write_granularity value between disk_set_zoned()
> and sd_zbc_read_zone(), modify the value not in sd_zbc_read_zone() but
> just after disk_set_zoned() call.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
