Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12082C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 22:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiJSWP7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 18:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiJSWP6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 18:15:58 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF6B19B67B
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 15:15:57 -0700 (PDT)
Received: by mail-pg1-f177.google.com with SMTP id 78so17499945pgb.13
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 15:15:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n2TK0SGU23ddCw9PQGxaqc8LluRySiQImeboMrZM4MM=;
        b=l5H4fIJ73vpp0rlYiCzZF55Ogrg2xxQQlFR+zsvowhomLNLX5aeYf9XRDyKNxknUhe
         ciwmjW2R+8YppeE7rG6K7pNWkggfbK/qQ9ZET4eZFTB/ALpnt7ONoQA6gjJEYyMO/Fjn
         oAlsCXuL/GXEJy3gedlESANloLqILm2OvR9Z5Kldg2xYD6nomLyTmS6385u5rDHWXcrp
         AcFX3r0H/JizP7+MQ9U2e+yJDyYFJcDjOlKg74Aka7aB7eBNw+0KZJiM3YVax2lvc54C
         JqFz9AND0rnvMKNGRowGrjUtZl4Rv/j+ka8E/hZXfrjtsqRbA+DKZcIrwUEQy0pzT89t
         gD8g==
X-Gm-Message-State: ACrzQf2Ix93v7pXW0oS1YmsVjQhN+vjZE5/64GWt6l8LvHhNDoAdb2ZD
        SEqkJrzbeSlQiTJYHcqlDTA=
X-Google-Smtp-Source: AMsMyM6bDH3wvata9sGc291AjFbCiu5FB/CFbkUvST+EQOuXGBMeod6ah4G1AAyYh6cs+eIYF+zx0A==
X-Received: by 2002:a05:6a00:2446:b0:528:5da9:cc7 with SMTP id d6-20020a056a00244600b005285da90cc7mr10973527pfj.51.1666217756686;
        Wed, 19 Oct 2022 15:15:56 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:8280:2606:af57:d34? ([2620:15c:211:201:8280:2606:af57:d34])
        by smtp.gmail.com with ESMTPSA id a8-20020a17090a688800b0020647f279fbsm395868pjd.29.2022.10.19.15.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 15:15:55 -0700 (PDT)
Message-ID: <2aca5af1-3949-a8ac-6050-4b06d71e2fbf@acm.org>
Date:   Wed, 19 Oct 2022 15:15:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v4 22/36] scsi: Have scsi-ml retry read_capacity_16 errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221016195946.7613-1-michael.christie@oracle.com>
 <20221016195946.7613-23-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221016195946.7613-23-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/22 12:59, Mike Christie wrote:
> +	struct scsi_failure failures[] = {
> +		{
> +			.sense = UNIT_ATTENTION,
> +			.asc = 0x29,
> +			.ascq = 0,
> +			/* Device reset might occur several times */
> +			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{
> +			.result = SCMD_FAILURE_ANY,
> +			.allowed = 3,
> +		},
> +		{},
> +	};

Is the implication of the above that any failure reported in the .result 
field will result in a retry? I don't think that matches the current 
behavior of read_capacity_16().

Thanks,

Bart.
