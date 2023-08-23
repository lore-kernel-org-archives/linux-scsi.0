Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2037EE49A3
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 15:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbjHWPRi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Aug 2023 11:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236635AbjHWPRf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2023 11:17:35 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB38FE7B;
        Wed, 23 Aug 2023 08:17:08 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-68a5457b930so2274862b3a.2;
        Wed, 23 Aug 2023 08:17:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692803750; x=1693408550;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zODWKjFLTG3KmUmUSCQMpsPng8pgZqpf54yZxjbJeIM=;
        b=Mbvia6qOwvJMIc84ucyrorABNwIaVgU7xgFquIfaU1P0V4BiFSf1RGYaQbBbNWEAUD
         /jpGJicYQ9mqdget5pA8lFwZFjPvsebpNB+Uli6vN1UUGZ5vaAUFgwgxREgFNX0tpkFK
         HdtXi/ayQI6/K02iBf1jJG/vE49Ag9TvyW58yfcDyK+63MigH20l46tEDyvDMW/x32/e
         Vu3yCWrF8JYIDN2yCMA/d3xIStEO35c3Gk5u7+IXyoyAteMCVG/ImCTQ7pSWERLksHVy
         N5z/dMJkJHXRULkJAHz2nrXcUAeO63iRSIANdXYxg00T3otlErAaggYm6Z351ifpozuC
         u9hg==
X-Gm-Message-State: AOJu0YzfkRAK1LnTWfULv0AVZxdLD2TQkCyygcnMh66k0lAy6vzhF+cA
        T/J6Jjo9Ejw5m/SArnK5zq4=
X-Google-Smtp-Source: AGHT+IEn9RxZPIi/WKzeL2IegtOWXt2Mn6gK9OOAe4ovitiHA04S28ASCgRbLGZCBJ5jxFFtvK946g==
X-Received: by 2002:a05:6a20:548f:b0:137:23f1:4281 with SMTP id i15-20020a056a20548f00b0013723f14281mr12825204pzk.12.1692803749675;
        Wed, 23 Aug 2023 08:15:49 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ecb6:e8b9:f433:b4b4? ([2620:15c:211:201:ecb6:e8b9:f433:b4b4])
        by smtp.gmail.com with ESMTPSA id f21-20020a170902e99500b001b896686c78sm11068708plb.66.2023.08.23.08.15.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Aug 2023 08:15:48 -0700 (PDT)
Message-ID: <078d2954-f4af-6678-29ce-d8f65ff1397a@acm.org>
Date:   Wed, 23 Aug 2023 08:15:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v11 04/16] scsi: core: Introduce a mechanism for
 reordering requests in the error handler
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230822191822.337080-1-bvanassche@acm.org>
 <20230822191822.337080-5-bvanassche@acm.org>
 <3562fc36-4bc2-b4fb-a2ad-1e310baf1b47@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3562fc36-4bc2-b4fb-a2ad-1e310baf1b47@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/22/23 23:26, Hannes Reinecke wrote:
> On 8/22/23 21:16, Bart Van Assche wrote:
>> +/*
>> + * Comparison function that allows to sort SCSI commands by ULD driver.
>> + */
>> +static int scsi_cmp_uld(void *priv, const struct list_head *_a,
>> +            const struct list_head *_b)
>> +{
>> +    struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
>> +    struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
>> +
>> +    /* See also the comment above the list_sort() definition. */
>> +    return scsi_cmd_to_driver(a) > scsi_cmd_to_driver(b);
> 
> I have to agree with Christoph here.
> Comparing LBA numbers at the SCSI level is really the wrong place.
> SCSI commands might be anything, and quite some of these commands don't
> even have LBA numbers. So trying to order them will be pointless.
> 
> The reordering mechanism really has to go into the block layer, with
> the driver failing the request and the block layer resubmitting in-order.

Hi Hannes,

Please take another look at patches 04/16 and 05/16. As one can see no
LBA numbers are being compared in the SCSI core - comparing LBA numbers
happens in the sd (SCSI disk) driver. The code that you replied to
compares ULD pointers, a well-defined concept in the SCSI core.

Your request to move the functionality from patches 04/16 and 05/16 into
the block layer would involve the following:
* Report the unaligned write errors (because a write did not happen at the
   write pointer) to the block layer (BLK_STS_WP_MISMATCH?).
* Introduce a mechanism in the block layer for postponing error handling
   until all outstanding commands have failed. The approach from the SCSI
   core (tracking the number of failed and the number of busy commands
   and only waking up the error handler after these counters are equal)
   would be unacceptable because of the runtime overhead this mechanism
   would introduce in the block layer hot path. Additionally, I strongly
   doubt that it is possible to introduce any mechanism for postponing
   error handling in the block layer without introducing additional
   overhead in the hot path.
* Christoph's opinion is that NVMe software should use zone append
   (REQ_OP_ZONE_APPEND) instead of regular writes (REQ_OP_WRITE) when
   writing to a zoned namespace. So the SCSI subsystem would be the only
   user of the new mechanism introduced in the block layer. The reason we
   chose REQ_OP_WRITE for zoned UFS devices is because the SCSI standard
   does not support a zone append command and introducing a zone append
   command in the SCSI standards is not something that can be realized in
   time for the first generation of zoned UFS devices.

Because I assume that both Jens and Christoph disagree strongly with your
request: I have no plans to move the code for sorting zoned writes into
the block layer core.

Jens and Christoph, please correct me if I misunderstood something.

Thanks,

Bart.
