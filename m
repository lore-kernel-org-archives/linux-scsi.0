Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31DF8C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 18:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbiKVSqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Nov 2022 13:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbiKVSqU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2022 13:46:20 -0500
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7276C8C795
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 10:46:14 -0800 (PST)
Received: by mail-pg1-f179.google.com with SMTP id b62so14851601pgc.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 10:46:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rl8g3saj+xJnwgFXiH4Ss6Ny6N2ThyATSa2LeJayaZs=;
        b=mz/6UYmhyYGeIe/gwUwSJS/1MWlzFaZvt+yuwTldwOWyb682cZt9ed6wuznER9IDTW
         zac95HXWdaeGtInsR3lQk51umXtsRkJyYM9dYF17SVZG3BvJH4zOvb03pV3Zyzb4e6wL
         wfo31JXxyuvIRV3z4QmbGt55sqAvT8ctHSvUngGKm1LXmn2V37lGfRYNCtG7xL6OMoMU
         i3DT/pdcw8HlbHN3ULbFPNTqnQzv4OeBZ1aKmGBdcjnMaFv+HFGvJvAONjgujYdlVY5+
         F3kSuOkMUghmM/likzv+32he2zjWfZjvXt3vjYglGjmOcsaSOZH/Lwe/HB9B2wljZgbx
         ZT7A==
X-Gm-Message-State: ANoB5pkc5VPqD+lCI3VvTKnjOlMhLJK5ZxwwupGKRVBVrpHzWShNHz/7
        LAgl9fOjjZJoqHGDGjCGIaH7kXakvME=
X-Google-Smtp-Source: AA0mqf4aYc3loBxgtqAk6bKNF4RqIGHmzbjXlGK28g0Nw0vVEGVe8FQ8fIl3M7Ny/fuFat9G5ftLrw==
X-Received: by 2002:a05:6a00:3017:b0:56b:ac5c:f3dc with SMTP id ay23-20020a056a00301700b0056bac5cf3dcmr8270706pfb.77.1669142773701;
        Tue, 22 Nov 2022 10:46:13 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:3c88:9479:e09c:9acb? ([2620:15c:211:201:3c88:9479:e09c:9acb])
        by smtp.gmail.com with ESMTPSA id q93-20020a17090a1b6600b00213d28a6dedsm12371233pjq.13.2022.11.22.10.46.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 10:46:12 -0800 (PST)
Message-ID: <92d8899c-7a73-ebde-87f6-8defab44d551@acm.org>
Date:   Tue, 22 Nov 2022 10:46:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 06/15] scsi: core: Convert to scsi_execute_cmd
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     mwilck@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221122033934.33797-1-michael.christie@oracle.com>
 <20221122033934.33797-7-michael.christie@oracle.com>
 <20221122063836.GB14514@lst.de>
 <33b7d1ca-4421-2f90-071b-0661f3893865@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <33b7d1ca-4421-2f90-071b-0661f3893865@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/22 08:13, Mike Christie wrote:
> On 11/22/22 12:38 AM, Christoph Hellwig wrote:
>> On Mon, Nov 21, 2022 at 09:39:25PM -0600, Mike Christie wrote:
>>> +	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buffer,
>>> +				  request_len, 30 * HZ, 3,
>>> +				  ((struct scsi_exec_args) { .sshdr = &sshdr }));
>>
>> Maybe it's me, but I hate the syntax to declare structs inside argument
> 
> I'll change it to setup the scsi_exec_args struct like normal. I've got this
> comment several times now.
> 
> With the current design we know all the args when we declare the variables so
> I can do it then like normal.

Will struct scsi_exec_args be retained? I'm asking this because I'd like 
to add another argument to the (already too large) argument list of 
scsi_execute().

Thanks,

Bart.

