Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29397C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 13:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbiGRN73 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 09:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbiGRN72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 09:59:28 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447661D325
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 06:59:28 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id k19so9080466pll.5
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 06:59:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Lq/fpXinlaBHMmExMgxXWRpxnZ1QzetP4yrNawYBvnY=;
        b=3pFclR7AanGL/OF4FuwZ6di1aGUFsoO++DbJ1Wl8BKxvrlW1dJdSN0aF9T4NOBHITp
         JXoFy0MxA1VtaDi/frHArjo5z4P99v6Wk45gytDAo8L02Vh5YfqyRfM30OrUjlNeSGnq
         5I3HFpZfbDBtaA5Ez9SsWd31LLkSj2JBscoLE4mrWn6waI2dvmpr9zlPNy7JJFBqJZ0J
         TWDVkRSs9RC0RyGM3pEpGVSmRv5z7l2v0FP/vPnGpUVO91alBRhJ56yatqJHek7DSG93
         lYlV+fWlPgU4XuP+Robw63eongY3K37R74V1LmUnAOAuG2DNI4+a2dOHtQ2jXSLvmkaO
         Mzhw==
X-Gm-Message-State: AJIora99Cs84DcewNP4n7aVaLuoC/yGABhYK0wZk07+VsD2KLbx1kxgB
        YbhhTFqN1SnGGNf12llZnko=
X-Google-Smtp-Source: AGRyM1sQloJe0MUm++Z/7U9DjbALT9KZ/HD9UzZSIeRTv3EitUwyriSj+XYvzAlGYjfi19EqqpvXMg==
X-Received: by 2002:a17:902:d683:b0:16c:b718:f94b with SMTP id v3-20020a170902d68300b0016cb718f94bmr21212901ply.9.1658152767583;
        Mon, 18 Jul 2022 06:59:27 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c66-20020a621c45000000b00528ce53a4a6sm9240111pfc.196.2022.07.18.06.59.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 06:59:26 -0700 (PDT)
Message-ID: <03268468-f884-fa94-91f9-40ef4c3e57ca@acm.org>
Date:   Mon, 18 Jul 2022 06:59:25 -0700
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
 <95f2f1d5-3e32-bb6f-b8e4-df0c232ed6eb@opensource.wdc.com>
 <7f58e047-8fa8-7300-3062-ab1d22495b2d@acm.org>
 <6d228185-1ce3-b0c8-71b8-badfe78505b7@opensource.wdc.com>
 <01cac097-1420-2142-c701-2542bf437656@acm.org>
 <11a23d81-b949-15de-11d3-426d2fd45db9@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <11a23d81-b949-15de-11d3-426d2fd45db9@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/18/22 03:38, Damien Le Moal wrote:
> Even the above code (removing the "sdkp->rc_basis == 0" test) is
> borderline in my opinion. The code with the test is per specs, so correct.

Hi Damien,

I do not agree that the current code is compliant with the ZBC 
specification. My interpretation of the ZBC specification is that the RC 
BASIS field influences the meaning of the RETURNED LOGICAL BLOCK ADDRESS 
field in the READ CAPACITY response only. The max_lba variable in 
sd_zbc_check_capacity() represents the MAXIMUM LBA field from the REPORT 
ZONES response. All I found in ZBC-2 about that field is the following: 
"The MAXIMUM LBA field contains the LBA of the last logical block on the 
logical unit." I haven't found any reference to RC BASIS in the 
description of the REPORT ZONES command - neither in ZBC-1 nor in ZBC-2.

Thanks,

Bart.
