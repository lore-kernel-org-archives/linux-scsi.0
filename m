Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140F0C63797
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 19:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237784AbjA3TN3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 14:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238325AbjA3TN1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 14:13:27 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25B044A9;
        Mon, 30 Jan 2023 11:13:26 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id j5so12008419pjn.5;
        Mon, 30 Jan 2023 11:13:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ye2d44HpWhl3SswDOdkTRrNgF3Mq2fxwH8BmkcnO8nw=;
        b=XqnReN1WcfwuPnJSBGfWmZvN2zHIZglyd+K1/EgR3RaMLdZNeOreKtOkZOUc9AaHk3
         Ytqp0azQmXkGcni2AW77gXy603BVsZF9yw0pV7Qm6sS5INmXg6H99odqez9ps0a/2Bo8
         rrZnS0FE1yKWEEKqGV1GZ5p0OAdMN8orASEGo7c2p4hSsGjSEuRncHAFmmYSRiQjDEso
         usEeuDf/Ng2I3PniSFkgXhYVwc+MRHN+vKmOwAgCL1gor4il2y4o4XSKo5EjeGCtHTc/
         Jxs+VdznBep+H5XafKP/cGpIYlLWIokjXJcD1OjKFtUYUjAN22/hTSVcifvj7BTtmFaA
         sdMQ==
X-Gm-Message-State: AFqh2kpnCLJh5ZF9CTwZF50fGbpYkI0DF3vXOQGcxMDDMxyUcZMkfJtH
        FeaJMTjNgIOIyJy8tIO6HzAgqlhgrxA=
X-Google-Smtp-Source: AMrXdXvDPY0evIWZsB+g2b5E/H59SVv6fGjhNwzRtSh07DLkQ/fJCbG1etSA15svNsARCK2F5VKZBQ==
X-Received: by 2002:a17:90b:1b45:b0:22b:b6d5:e347 with SMTP id nv5-20020a17090b1b4500b0022bb6d5e347mr39008967pjb.29.1675106005582;
        Mon, 30 Jan 2023 11:13:25 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:5016:3bcd:59fe:334b? ([2620:15c:211:201:5016:3bcd:59fe:334b])
        by smtp.gmail.com with ESMTPSA id mv12-20020a17090b198c00b0021952b5e9bcsm9676883pjb.53.2023.01.30.11.13.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 11:13:24 -0800 (PST)
Message-ID: <9547f182-4ec2-021c-5860-5cc2e3dc515a@acm.org>
Date:   Mon, 30 Jan 2023 11:13:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20230124190308.127318-2-niklas.cassel@wdc.com>
 <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
 <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
 <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
 <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
 <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
 <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
 <e8324901-7c18-153f-b47f-112a394832bd@acm.org> <Y9Gd0eI1t8V61yzO@x1-carbon>
 <86de1e78-0ff2-be70-f592-673bce76e5ac@opensource.wdc.com>
 <Y9KF5z/v0Qp5E4sI@x1-carbon> <7f0a2464-673a-f64a-4ebb-e599c3123a24@acm.org>
 <29b50dbd-76e9-cdce-4227-a22223850c9a@opensource.wdc.com>
 <c8ef76be-c285-c797-5bdb-3a960821048b@opensource.wdc.com>
 <ddc88fa1-5aaa-4123-e43b-18dc37f477e9@acm.org>
 <049a7e88-89d1-804f-a0b5-9e5d93d505f7@opensource.wdc.com>
 <b77d5e44-bc1e-7524-7e09-a609ba471dbc@acm.org>
 <4e803108-9526-6a75-f209-789a06ef52f9@opensource.wdc.com>
 <yq1r0veh2fa.fsf@ca-mkp.ca.oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq1r0veh2fa.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/28/23 12:25, Martin K. Petersen wrote:
>   - Wrt. ioprio as conduit, I personally really dislike the idea of
>     conflating priority (relative performance wrt. other I/O) with CDL
>     (which is a QoS concept). I would really prefer those things to be
>     separate. However, I do think that the ioprio *interface* is a good
>     fit. A tool like ionice seems like a reasonable approach to letting
>     generic applications set their CDL.

Hi Martin,

My understanding is that ionice uses the ioprio_set() system call and 
hence only affects foreground I/O but not page cache writeback. This is 
why I introduced the ioprio rq-qos policy (block/blk-ioprio.c). How 
about not adding CDL support in ioprio_set() and only supporting 
configuration of CDL via the v2 cgroup mechanism?

Thanks,

Bart.

