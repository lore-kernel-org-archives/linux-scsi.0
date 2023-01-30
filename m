Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12EDC636D3
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 20:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjA3Uky (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 15:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjA3Uku (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 15:40:50 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CD03C2AB;
        Mon, 30 Jan 2023 12:40:49 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id l4-20020a17090a850400b0023013402671so124265pjn.5;
        Mon, 30 Jan 2023 12:40:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hmflhFxLbqnfi+QwTGHt4CcSktELIMyYKlRnjrLGhiA=;
        b=vK81Q6gOW1UOsNP7maMFMDs1+YovxoY+dkp/mW+9rWtHCmuWSlZF8ZWAqNg9PqGx6L
         syCO+6rqbUSXNYt7pkH+Qfbx7WQFgmkG5c5zBh38c83tlt+rBdyw9PrJw0XuiJtI8LdD
         cbyBc0T4ONKqgmDXYyT/e9YQbpU46VHg6npS9Ilu7keId8bTKQjHocVtMV6f+9DadpvO
         V6K8yXJexq98/m7Ifke+r7c0WIYt6NU/Y2/NZ80KMs6/XpYNw8Dc1QJiJSQ9ugXl6IqT
         zQPpwp4gGCg01cjYPgs54V7JvJVwiSr1y7tMZdO3cbKAudV061a+k836wBhjh+RLA8DP
         rohg==
X-Gm-Message-State: AFqh2kq9Fx7PLxZ8smmulzdCIqBQ67gRE1RmlteRrfgY7GXXKUvZhyHs
        79S53nEG8GcMwXjRlGpXM+g=
X-Google-Smtp-Source: AMrXdXussbqe0XSnx5wccquvOxqftLaB5cS3nFNKSFtjptAtOtAxutDXuLpLcfKPx9wsZ3kuy3T8zg==
X-Received: by 2002:a17:902:988f:b0:194:9b5d:2887 with SMTP id s15-20020a170902988f00b001949b5d2887mr45230780plp.64.1675111248923;
        Mon, 30 Jan 2023 12:40:48 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:5016:3bcd:59fe:334b? ([2620:15c:211:201:5016:3bcd:59fe:334b])
        by smtp.gmail.com with ESMTPSA id x7-20020a1709029a4700b001949b915188sm8225494plv.12.2023.01.30.12.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 12:40:48 -0800 (PST)
Message-ID: <2055c51c-d448-e69b-cd41-17fb10fc1923@acm.org>
Date:   Mon, 30 Jan 2023 12:40:46 -0800
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

Does the QoS level really have to be encoded in bio.bi_ioprio? How about 
introducing a new field in the existing hole in struct bio? From the 
pahole output:

struct bio {
         struct bio *               bi_next;            /*     0     4 */
         struct block_device *      bi_bdev;            /*     4     4 */
         blk_opf_t                  bi_opf;             /*     8     4 */
         short unsigned int         bi_flags;           /*    12     2 */
         short unsigned int         bi_ioprio;          /*    14     2 */
         blk_status_t               bi_status;          /*    16     1 */

         /* XXX 3 bytes hole, try to pack */

         atomic_t                   __bi_remaining;     /*    20     4 */
         struct bvec_iter           bi_iter;            /*    24    20 */
         blk_qc_t                   bi_cookie;          /*    44     4 */
         bio_end_io_t *             bi_end_io;          /*    48     4 */
         void *                     bi_private;         /*    52     4 */
         struct bio_crypt_ctx *     bi_crypt_context;   /*    56     4 */
[ ... ]

Thanks,

Bart.
