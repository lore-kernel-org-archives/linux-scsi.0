Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0116FC38142
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 00:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbjAYAGD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 19:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjAYAGB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 19:06:01 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D6493F7;
        Tue, 24 Jan 2023 16:06:00 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso359195pjf.1;
        Tue, 24 Jan 2023 16:06:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0dts3FNDWGr5WYgS6RVFUj0bt2Wgw5JLeyle1B2A/qM=;
        b=MkFZXxCzZ2VfpanBZmAnnIVJ+koENJsJ7hL/lcaO+VIvm+cNXsi+Q6hfaUYWR8Wkgw
         1pt1LFJMIg9k7rveyE7cFiOM1s4taYLuChZXffO5ali5NGoq7sExE6blnoEc4xKDavg6
         dPrWzh4OQ21qSvDGzSR8EIIx7OWD5w8Y469xYVWpdGr3zDmF6DYyEqz1N326EJs3BN5R
         Vxg0M4swpmGQTBQ8FyMaAGA1CzENLr0onFZyUtnlDeD87120iASOsnXpQPkSM8j33WZC
         3T1sQ7rsgxdh69qXdxlWVCGQTA3cDb2WBXoAFwaxFIGxo0x7X71fwcraZnD+KSRNNs/c
         knEg==
X-Gm-Message-State: AFqh2koCG2Il/j/rOdPnLlW9cFuJXGR0+PQRNm7Gb9qcEehTwmy2O6bI
        ZoXOEBGFkAe/2aj5fcFdhN8=
X-Google-Smtp-Source: AMrXdXtQtgBMlij2kC8Gamlr24AdssVRNsRitKC9TpuvVEYno02LdU6InsETxg+NU7adxC+2B58vEQ==
X-Received: by 2002:a17:90b:38c7:b0:22b:b25a:d0a0 with SMTP id nn7-20020a17090b38c700b0022bb25ad0a0mr17932749pjb.15.1674605160148;
        Tue, 24 Jan 2023 16:06:00 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id e14-20020a17090ab38e00b00229f0c629e1sm103301pjr.45.2023.01.24.16.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 16:05:59 -0800 (PST)
Message-ID: <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
Date:   Tue, 24 Jan 2023 16:05:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-2-niklas.cassel@wdc.com>
 <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
 <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
 <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
 <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 14:59, Damien Le Moal wrote:
> There is only one priority class that ATA understands: RT (the level is
> irrelevant and ignored). All RT class IOs are mapped to high priority NCQ
> commands. All other classes map to normal priority (no priority bit set)
> commands.
> 
> And sure, we could map the level of RT class IOs to a CDL index, as we do
> for the CDL class, but what would be the point ? The user should use the
> CDL class in that case.
> 
> Furthermore, there is one additional thing that we do not yet support but
> will later: CDL descriptor 0 can be used to set a target time limit for
> high priority NCQ commands. Without this new feature introduced with CDL,
> the drive is free to schedule high priority NCQ commands as it wants, and
> that is hard coded in FW. So you can endup with very aggressive scheduling
> leading to significant overall IOPS drop and long tail latency for low
> priority commands. See page 11 and 20 of this presentation for an example:
> 
> https://www.snia.org/sites/default/files/SDC/2021/pdfs/SNIA-SDC21-LeMoal-Be-On-Time-command-duration-limits-Feature-Support-in%20Linux.pdf
> 
> For a drive that supports both CDL and NCQ priority, with CDL feature
> turned off, CDL descriptor 0 defines the time limit hint for high priority
> NCQ commands. Again, CDL and NCQ high priority are mutually exclusive.
> 
> So for clarity, I really would prefer separating CDL and RT classes as we
> did. We could integrate CDL support reusing the RT class + level for CDL
> index, but I think this may be very confusing for users, especially
> considering that the CLDs on a drive can be defined in any order the user
> wants, resulting in indexes/levels that does do not have any particular
> order, making it impossible for the host to correctly schedule commands.

Hi Damien,

Thanks again for the detailed reply. Your replies are very informative 
and help me understand the context better.

However, I'm still less than enthusiast about the introduction of the 
I/O priority class IOPRIO_CLASS_DL. To me command duration limits (CDL) 
is a mechanism that is supported by one storage standard (SCSI) and of 
which it is not sure that it will be integrated in other storage 
standards (NVMe, ...). Isn't the purpose of the block layer to provide 
an interface that is independent of the specifics of a single storage 
standard? This is why I'm in favor of letting the ATA core translate one 
of the existing I/O priority classes into a CDL instead of introducing a 
new I/O priority class (IOPRIO_CLASS_DL) in the block layer.

Others may have a different opinion.

Thanks,

Bart.
