Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DA0C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 20:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiKJUr1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 15:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKJUrZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 15:47:25 -0500
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014E654B2D
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 12:47:24 -0800 (PST)
Received: by mail-pg1-f177.google.com with SMTP id 136so2722955pga.1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 12:47:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TRJ44qpssHVMhTg9hSyJWAeGY/Zu2HX0Rt4RCz4JVM0=;
        b=BrT/L5oM5eU+B64Ur7ijwmrrpr2W/+HtDMGlgfOJlh98e0WfvFzLhqmNGFgGC9vEwu
         6fvAKWGUqfPw9tFHvN7GvezWV1nc9Zrd93/jWOMhow8Z3gBjR1F5fr6q6ZcF8jb8H9fd
         hsGOTz9TWdJuUnAsu3/TkVIoLGondMPfCJEQIxLraAq4GYGImb9msVjNwyyJ5EdtUcbv
         f7B99g5gQhLOC7WR3zSjMXx3qg3gQ33hAHLll1Sk1FReJpflywew3sOrFMraf5HhFXpE
         gG6AWHXktELsVai5Bv4wud3jg+LestUU7J+1LC94dPuIKMH7iOgSaibteENsrO8yQ4cf
         xjXg==
X-Gm-Message-State: ACrzQf2Z7zX1c/2lxNnSH7ZNM5K+Y32CCrqGSe/kb1ddBzG4ZCwqFF14
        mX+lOolA+AdhfwRp9KFBWTqS6g5u9Jw=
X-Google-Smtp-Source: AMsMyM7wE/jjg/WEpPjm5PV/89mUFLPegm/oJm5ixsW1ViJudgiR+0Ja7i6aSf1vJQV2Yc48qhPTXQ==
X-Received: by 2002:a63:4047:0:b0:46f:ec9f:dcb0 with SMTP id n68-20020a634047000000b0046fec9fdcb0mr3256964pga.202.1668113244367;
        Thu, 10 Nov 2022 12:47:24 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:2ecf:659:1c55:5? ([2620:15c:211:201:2ecf:659:1c55:5])
        by smtp.gmail.com with ESMTPSA id i4-20020a056a00004400b0056c3d3f5a8dsm86852pfk.56.2022.11.10.12.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 12:47:23 -0800 (PST)
Message-ID: <bd0b17e6-4975-be48-7c3e-337173b5804f@acm.org>
Date:   Thu, 10 Nov 2022 12:47:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v6 03/35] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-4-michael.christie@oracle.com>
 <1bd9df90-fda6-270e-e437-e1039a0a8b76@oracle.com>
 <02dd9d58-a5dc-2733-5b34-481f276fe231@oracle.com>
 <a215068e-a5f6-34ce-2b23-8f964b09db4c@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a215068e-a5f6-34ce-2b23-8f964b09db4c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/22 11:26, Mike Christie wrote:
> One thing that is weird to me is that scsi_execute_req is the more scsi'ish
> interface. I would have thought since it took the req flag since it has the
> req naming in it.
> 
> I don't care either way.

Although this is not a strong argument, it is an argument: passing a DMA 
direction is slightly more descriptive than passing REQ_OP_DRV_* since 
the information that no data is passed would be lost if the DMA 
direction argument would be changed into a REQ_OP_DRV_* argument.

Bart.
