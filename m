Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D03DC47088
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 22:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiK3WaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 17:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiK3WaJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 17:30:09 -0500
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748758B192;
        Wed, 30 Nov 2022 14:30:08 -0800 (PST)
Received: by mail-pg1-f173.google.com with SMTP id s196so26090pgs.3;
        Wed, 30 Nov 2022 14:30:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yGb/FHwpCIK4OWsn2z16J1O7JCmgjXI7b+OjscwYSeo=;
        b=QOf4q2MZ7RAtgZ+k8XX3Snt9/oJj0Tr5WDTLfkwUMN92eee2tq6JOhkzZdw3TXFxDW
         vC7XO0ZMihp+hzjHvd1yySVmMnRrp7LPvFUz2YYbwPYjH7Z00LZu0Ti0UE3Ve6EwUstf
         zcoawlrUMh4TDH2zvSmdhfI2Qwxww5jgVUgCKQU4/yy7oToMBV3xASjK275Zqpc5Azap
         +TK+e7RXz34TJK3tnoHQCPEBE+FxMGj+ZDiCHWRjhcsTbcVMVsZmxk2AZAndQ+ofO+Tr
         MH+lSZNhliyJIJZbpPv8qwHW0Wqsvp5TqHBTyoyLXZCRhKvlBFgh0+ArdY12qJNNwMDQ
         AJ4g==
X-Gm-Message-State: ANoB5pnolqsKKw9LAq6c54YzNNJ8uJ05at3DfG1FY4q5kYRvOl60VQ8z
        0WgWXaYngf7O7UY0r2WGZdc=
X-Google-Smtp-Source: AA0mqf4tGBlw9dWHk81C6mUi2JaG1Pg9Te+EewfYBtnInLLkS5sFo2u3x/huI4AYY9w9EoO65RD/9Q==
X-Received: by 2002:a63:d241:0:b0:439:8688:a98d with SMTP id t1-20020a63d241000000b004398688a98dmr37080517pgi.424.1669847407607;
        Wed, 30 Nov 2022 14:30:07 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:3729:bd90:53d2:99e3? ([2620:15c:211:201:3729:bd90:53d2:99e3])
        by smtp.gmail.com with ESMTPSA id pc8-20020a17090b3b8800b0021929c71b14sm3628810pjb.40.2022.11.30.14.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 14:30:06 -0800 (PST)
Message-ID: <15faf6f5-216d-f376-9aa6-6dc77983e294@acm.org>
Date:   Wed, 30 Nov 2022 14:30:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 7/8] scsi_debug: Support configuring the maximum
 segment size
Content-Language: en-US
To:     dgilbert@interlog.com, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20221123205740.463185-1-bvanassche@acm.org>
 <20221123205740.463185-8-bvanassche@acm.org>
 <8a3a5d53-d1e1-0c95-4aea-923c46ac4e32@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8a3a5d53-d1e1-0c95-4aea-923c46ac4e32@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/22 09:34, Douglas Gilbert wrote:
> On 2022-11-23 15:57, Bart Van Assche wrote:
>>   module_param_named(no_uld, sdebug_no_uld, int, S_IRUGO);
>> +module_param_named(max_segment_size, sdebug_max_segment_size, uint, 
>> S_IRUGO);
> 
> Could you place the above line in alphabetical order.
> 
>>   module_param_named(num_parts, sdebug_num_parts, int, S_IRUGO);
>>   module_param_named(num_tgts, sdebug_num_tgts, int, S_IRUGO | S_IWUSR);
>>   module_param_named(opt_blks, sdebug_opt_blks, int, S_IRUGO);
>> @@ -7815,6 +7817,7 @@ static int sdebug_driver_probe(struct device *dev)
>>       sdebug_driver_template.can_queue = sdebug_max_queue;
>>       sdebug_driver_template.cmd_per_lun = sdebug_max_queue;
>> +    sdebug_driver_template.max_segment_size = sdebug_max_segment_size;
>>       if (!sdebug_clustering)
>>           sdebug_driver_template.dma_boundary = PAGE_SIZE - 1;
> 
> And could you add a
> MODULE_PARM_DESC(max_segment_size, "<1 line description>");
> 
> entry as well (also in alphabetical order).

Hi Doug,

I will make these changes.

Thanks for the feedback.

Bart.

