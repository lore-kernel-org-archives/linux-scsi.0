Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C0BC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 21:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbiLLVSl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 16:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbiLLVSQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 16:18:16 -0500
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A3CEE0E
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:16:51 -0800 (PST)
Received: by mail-pg1-f170.google.com with SMTP id 79so77779pgf.11
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:16:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rjMwAYqYPytT7dK+Q5RTOxmj8V3SEPxpK+O+/QeM1XA=;
        b=oBcAwP67bCuv/xP1ZlkHgN3QQ035U67GSYXHlmKLv8MJF9/+bnPdCfHps1qE2tqZYT
         ED29NDHIdGW8TySTqb7kzaUwxvaeg1pNtgZsukLYFDh8v6NujJMGLXf2/XfnHjCo2SiZ
         5dEXIYTiNhpkqm1ZHctsQRDOde9uuB2YSwNVbiiea9pCEnzFwb2sMFRin+PyK6P3y7lI
         BDndND8CvDU0iCojXGEfXyBSIpe7avvSfk9iEsFSqpDNEP45/yh74E5VFP+9Bz6nnPem
         w6MUHOPalxUMgN7MJZGjBPt5BgFpB0xKRS1fTfucGEGoXoC+asKDftUQENfgwZFqYXpf
         lBFA==
X-Gm-Message-State: ANoB5pmFhm50Odug/6dV5LZJJd8U58bSfdODfkyZwhZBbYUfKsJrjIK7
        ErW1qM3GjV5f/F81hZ3DLY4=
X-Google-Smtp-Source: AA0mqf6eTe5a6pdJYY42lUrU0usBRp3C02LNwF4DD0BQDWRzZQgM00MCzkAwQHeCJS++z7VOASpm5w==
X-Received: by 2002:a05:6a00:796:b0:577:3523:bd23 with SMTP id g22-20020a056a00079600b005773523bd23mr17612181pfu.27.1670879811032;
        Mon, 12 Dec 2022 13:16:51 -0800 (PST)
Received: from [10.20.6.139] (rrcs-24-43-192-3.west.biz.rr.com. [24.43.192.3])
        by smtp.gmail.com with ESMTPSA id y8-20020aa79e08000000b005775c52dbc4sm6208334pfq.167.2022.12.12.13.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 13:16:50 -0800 (PST)
Message-ID: <23b9d3ac-9522-b0de-92dd-23d2d465b339@acm.org>
Date:   Mon, 12 Dec 2022 11:16:48 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 08/15] scsi: sd: Convert to scsi_execute_args
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-9-michael.christie@oracle.com>
 <c0aa17dd-e56a-be01-16e5-fd11f096900a@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c0aa17dd-e56a-be01-16e5-fd11f096900a@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/9/22 02:12, John Garry wrote:
> On 09/12/2022 06:13, Mike Christie wrote:
>> scsi_execute* is going to be removed. Convert sd_mod to use
>> scsi_execute_args.
>>
>> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> 
> Apart from nit:
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>

I assume that 'nit' in this context refers to the same suggestion as for the
previous patch? Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


