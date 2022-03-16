Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE348C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Mar 2022 23:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbiCPXFO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Mar 2022 19:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235255AbiCPXFM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2022 19:05:12 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A47312609
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 16:03:57 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id g19so5314005pfc.9
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 16:03:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uAnf/4xt9X+JkipsAw3/hWXAHV2ZcjjFC1nt+DnpNm0=;
        b=rEgvvjjZagrYc1s1Ji82/4NSl2Wu2eokOQv5coAWEb9SbRMPvztkFBmyvnoNh9rtAc
         ec4/SO0xAqk8FdEKqG/tJUurlMEVqQzTDKwKlr75hrEwSLKo98zoICdT+aGXKQiKeBVu
         VUVikaliTezcdHI2i/EB2q+WRTGymumAyVORosyXacvrK3sJErtW3fzr0YopH3tRfhcA
         RcXF1h/GlcIhdskYtkR/PrX9G04+dHm9i/6Wu4xyOaiKRLGlv5CA2ZKKobZOMsrqQA4a
         3tnPIWt8TnLbclhrZNNR0Je9vVpkP4QMpvRJSG+JVsO1FCDBqloEK41aLes6AqgTnEEg
         qBdA==
X-Gm-Message-State: AOAM530wpVOYDeiv348ZC1Q+At1LpQPjkSRbXQ8+pFkZr+oH18+KnQb0
        Vfz/4hNY5VWtbP9QWsnjmqs=
X-Google-Smtp-Source: ABdhPJyJ0xlEmSwdEb2tE9HrVHosi8A3RjZD19H/EAb+AhSCauBtazltHNBfMwGxso0mutIj77qJzg==
X-Received: by 2002:a65:4605:0:b0:381:fea8:7418 with SMTP id v5-20020a654605000000b00381fea87418mr1395013pgq.454.1647471836925;
        Wed, 16 Mar 2022 16:03:56 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:af9f:e726:32ab:1234? ([2620:15c:211:201:af9f:e726:32ab:1234])
        by smtp.gmail.com with ESMTPSA id w23-20020a627b17000000b004f6cf170070sm4142056pfc.186.2022.03.16.16.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 16:03:56 -0700 (PDT)
Message-ID: <19494279-78f9-ca48-3c09-091df342cd63@acm.org>
Date:   Wed, 16 Mar 2022 16:03:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v5] scsi:spraid: initial commit of Ramaxel spraid driver
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        Yanling Song <songyl@ramaxel.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <20220314025315.96674-1-songyl@ramaxel.com>
 <ecf79a5c-49f4-cf0e-edf4-9363c8b60bb5@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ecf79a5c-49f4-cf0e-edf4-9363c8b60bb5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/15/22 07:43, John Garry wrote:
> On 14/03/2022 02:53, Yanling Song wrote:
> [ ... ]
> why do you need a separate header file? why not put all this in the only 
> C file?

The C file is already very big. I like the approach of keeping 
declarations and structure definitions in a header file because that 
makes the code easier to navigate.

>> +struct spraid_completion {
>> +    __le32 result;
> 
> I think that __le32 is used for userspace common defines, while we use 
> le32 for internal to kernel

Really? I'm not aware of a le32 type in the Linux kernel.

>> +#define SPRAID_DRV_VERSION    "1.0.0.0"
> 
> I don't see much value in driver versioning. As I see, the kernel 
> version is the driver version.

+1

Thanks,

Bart.
