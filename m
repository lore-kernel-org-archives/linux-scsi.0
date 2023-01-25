Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19418C54E94
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 20:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbjAYUge (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 15:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbjAYUgb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 15:36:31 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8AD5C0EB
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2023 12:36:23 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id e10-20020a17090a630a00b0022bedd66e6dso3328124pjj.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2023 12:36:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nqpyd6U7ytJsqYqXKZug05NlmDN44Dc5KkKhvm2AZWc=;
        b=Zi0hpzgPDImHLAqqxkX7VByCWm2mB8cqqWyAdZyDKFY3ehKcedZnlYSYdPQFdHa8o+
         Oh63f4vMwxXNZDOeVG29bEHVHhxZKPagrb54kgdHFPR2odEkVNsNGUzxe4fuIPoM5vGU
         qD0N/tZ7yOFH3Gp/6EE1gBrlS2xaN1FdaBk7bj1fAyp6E2ovlrqm5cF2cZUoawB0zpPW
         CrNk8o8N9GazSH+M1yzb/f5OKcaPRTye2DuokKJYVj29dU1RWRND+5tlSLhsAYSzLCIi
         3MTswM64tMrAQR6XWP0Wc+rVv3tUNhsvG37bOMvtrGiscakb+reWKNp60BG1cOFa2d1k
         Rckg==
X-Gm-Message-State: AFqh2kpfK8zGTTENuz0c7BLyW1FNgsWmqPHO8Irq34MlIHtQY49QJheB
        R+WnmiySEyUTxRB7InRgAg0=
X-Google-Smtp-Source: AMrXdXs1+3k12HMlVoJTTU5KEhn95la/sGKQC62V8mvOLuJNWZHmMCpi7ACn2gHSkKG6ZPFr7T1VBQ==
X-Received: by 2002:a17:90a:358:b0:22b:b832:d32 with SMTP id 24-20020a17090a035800b0022bb8320d32mr20103318pjf.9.1674678982583;
        Wed, 25 Jan 2023 12:36:22 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:7512:ed47:db25:4294? ([2620:15c:211:201:7512:ed47:db25:4294])
        by smtp.gmail.com with ESMTPSA id c2-20020a17090a1d0200b0022c033f501asm2048638pjd.41.2023.01.25.12.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 12:36:21 -0800 (PST)
Message-ID: <ee600ffc-82c6-1d33-f756-83ac7270366e@acm.org>
Date:   Wed, 25 Jan 2023 12:36:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: The PQ=1 saga
Content-Language: en-US
To:     Brian Bunker <brian@purestorage.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
 <CB441742-2C22-41A4-95A3-10D251C31F5B@purestorage.com>
 <yq1a627l4gn.fsf@ca-mkp.ca.oracle.com>
 <446766A5-C12A-4965-85F2-49DEF5D93424@purestorage.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <446766A5-C12A-4965-85F2-49DEF5D93424@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/23 11:56, Brian Bunker wrote:
>> On Jan 24, 2023, at 8:04 PM, Martin K. Petersen <martin.petersen@oracle.com> wrote:
>> I suspect it would be better to trigger a re-probe of the device when
>> transitioning out of unavailable state. Most of the logic is already in
>> place and we reread VPD pages, etc. I believe there are only a few
>> pieces missing from being able to do a full in-place update.
 >
> Unfortunately this doesn’t work.

If that doesn't work today, how about implementing this functionality?
How about letting the ALUA device handler do a SCSI rescan if the ALUA state
changes from a state in which READ CAPACITY does not have to be supported
(standby, unavailable) to a state in which READ CAPACITY must be supported
(active/optimized, active/non-optimized)?

Thanks,

Bart.

