Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252BAC54EAA
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 19:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237508AbjA3TYT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 14:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjA3TYS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 14:24:18 -0500
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D922D70;
        Mon, 30 Jan 2023 11:24:17 -0800 (PST)
Received: by mail-pg1-f170.google.com with SMTP id q9so8387906pgq.5;
        Mon, 30 Jan 2023 11:24:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FDOhw4bXgLDlSATV8J35aaw17CH+C7XqPUR7CtrAw5c=;
        b=doBMMvm5eUcdvBgQccRYOBE+HZwOjDLl7nN0MLHW8Xo7AT4ifj5BOsBgu6j7dJNg4g
         WCH9HGoY2QN1CznddhAXfqYuV3/fZayKZJP37Dy4jUc0JQkcoM98l2v5EftkoOiLRFHu
         hKXEuQlgetmbxqgdcIhMn/bMYUIkZyanlCpPASjpohCo0Aec4BPOAv/Ing1H+hhFHP4n
         DeYf7HP1bV8NfXHNSUwm5pyEtWZ51LElxX/Y4v3GP/QCiASH6QMXTukzgS6GLzIz9GDf
         4MLG9WspiF3PFdu6LJf/1MaLq56GKwkAsZXmzaA+tGJh0bZimemTp+g/Ucie1VMhBwzk
         26KA==
X-Gm-Message-State: AO0yUKVQyS/MJjeNV7crfXlIYRrRcCUUkkpap9MMdv8Z612wjAInyDX6
        cYaLzzJ5Hk3eYokwBWY4NUY=
X-Google-Smtp-Source: AK7set/sI/F/T+a4P1OQ0KmYjZI2xoKiJOUjx2Eoy5rgpR4uysq+4FM8gH9blP7EOhJpSw2ypYL5TQ==
X-Received: by 2002:a62:6c6:0:b0:593:d24b:104e with SMTP id 189-20020a6206c6000000b00593d24b104emr2631515pfg.12.1675106656682;
        Mon, 30 Jan 2023 11:24:16 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:5016:3bcd:59fe:334b? ([2620:15c:211:201:5016:3bcd:59fe:334b])
        by smtp.gmail.com with ESMTPSA id z12-20020aa7990c000000b0059252afc069sm7361593pff.64.2023.01.30.11.24.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 11:24:15 -0800 (PST)
Message-ID: <de654983-fb3d-6041-3090-072ea0f44f88@acm.org>
Date:   Mon, 30 Jan 2023 11:24:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20230124190308.127318-2-niklas.cassel@wdc.com>
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
 <f8320ff3-0f52-aa0c-635e-c1e7c28ffe25@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f8320ff3-0f52-aa0c-635e-c1e7c28ffe25@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/28/23 19:52, Damien Le Moal wrote:
> diff --git a/include/uapi/linux/ioprio.h b/include/uapi/linux/ioprio.h
> index f70f2596a6bf..1d90349a19c9 100644
> +/*
> + * The 13-bits of ioprio data for each class provide up to 8 QOS hints and
> + * up to 8 priority levels.
> + */
> +#define IOPRIO_PRIO_LEVEL_MASK	(IOPRIO_NR_LEVELS - 1)
> +#define IOPRIO_QOS_HINT_SHIFT	10
> +#define IOPRIO_NR_QOS_HINTS	8
> +#define IOPRIO_QOS_HINT_MASK	(IOPRIO_NR_QOS_HINTS - 1)
> +#define IOPRIO_PRIO_LEVEL(ioprio)	((ioprio) & IOPRIO_PRIO_LEVEL_MASK)
> +#define IOPRIO_QOS_HINT(ioprio)	\
> +	(((ioprio) >> IOPRIO_QOS_HINT_SHIFT) & IOPRIO_QOS_HINT_MASK)
> +

Hi Damien,

How about the following approach?
* Do not add QoS support to the ioprio_set() system cal since that
   system call only affects foreground I/O.
* Configure QoS via the v2 cgroup mechanism such that QoS policies are
   applied to both foreground and background I/O.

This approach allows to use another binary representation for I/O 
priorities and QoS in the bio.bi_ioprio field than what is supported by 
the ioprio_set() system call. This approach also allows to use names 
(strings) for QoS settings instead of numbers in the interface between 
user space and the kernel if that would be considered desirable.

Thanks,

Bart.
